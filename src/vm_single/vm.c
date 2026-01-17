#include "vm/vm.h"
#include "aes/aes.h"
#include "blake2b/blake2b.h"
#include "freestanding.h"
#include "jit/jit.h"
#include "jit/jit_vm.h"

#include <stdint.h>

#if INSTRUMENT == 1
// we will be inserting breakpoints in the JITted code
static uint8_t jit_buffer[128 * 1024];
#else
// average RandomX WASM module size is 10 KiBs
static uint8_t jit_buffer[16 * 1024];
#endif

// used by the miner
static struct miner_state {
	uint8_t blob[256];
	uint32_t blob_length;

	uint32_t nonce;
	uint32_t nonce_end;
	uint64_t target;

	uint32_t hashes;
} st;

enum {
	NONCE_SPACE_EXHAUSTED = 0,
	NONCE_FOUND = 1,
};

static blake2b_state *SS; // seed state
static uint8_t program_count;
static bool is_hex;

// (single+miner) called on startup
WASM_EXPORT("i")
void *init(uint8_t f) {
	jit_feature = f;
	return jit_buffer;
}

// (single) start installing bytes
WASM_EXPORT("I")
void init_new_hash(bool h) {
	is_hex = h;
	program_count = RANDOMX_PROGRAM_COUNT;
	blake2b_init_key(SS, 64, NULL, 0);
}

// (single) start install bytes
WASM_EXPORT("H")
void update_hash(uint32_t data_length) {
	blake2b_update(SS, jit_buffer, data_length);
}

uint8_t S[64]; // 512-bit seed - state of the generator gen1 + gen4

alignas(16) rx_program_t P; // program buffer
alignas(16) rx_vm_t VM;
uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

static void final_vm_single_iteration();
static uint32_t final_vm_miner_iteration();

// repeat VM calls require the JITted code to be executed.
// this means we have to return back to caller for the JS to compile and invoke it

// handle all steps with a single function, to minimise the number of inter-language calls
uint32_t iterate_vm_hash() {
	// first iteration
	if (program_count == RANDOMX_PROGRAM_COUNT) {
		blake2b_finalise(SS, S);

		// S now contains the seed, modify it after scratchpad initialisation
		TIMEIT("scratchpad init");
		fillAes1Rx4(S, RANDOMX_SCRATCHPAD_L3, scratchpad); // 2 MiBs
		TIMEIT_END("scratchpad init");

		// reset rounding mode, rounding mode is preserved over RANDOMX_PROGRAM_COUNT programs
		VM.fprc = 0;
		program_count = RANDOMX_PROGRAM_COUNT;
	} else if (program_count == 0) {
		TIMEIT_END("vm iteration");

		// "The last iteration skips steps 9 and 10."
		return 0;
	} else {
		TIMEIT_END("vm iteration");

		// steps 9, 10
		// after middle iterations
		blake2b(S, 64, &VM, 256); // S = Hash512(RegisterFile)
	}

	// middle iterations
	program_count--;

	// set VM.r[0..7] to 0, everything else is initialised in vm_program and in the VM
	memset(&VM.r, 0, sizeof(VM.r));

	fillAes4Rx4(S, sizeof(P), (void *)&P); // program generation
	vm_program(&VM, &P);
	uint32_t code_size = jit_vm(&VM, &P, scratchpad, jit_buffer);

	TIMEIT("vm iteration");
	return code_size;
}

static void final_vm_single_iteration() {
	// A = AesHash1R(Scratchpad), overwrite the 64 bytes of RegisterFile
	hashAes1Rx4(scratchpad, RANDOMX_SCRATCHPAD_L3, (void *)&VM.a);

	if (is_hex) {
		blake2b_hex(jit_buffer, 32, &VM, 256); // R = Hash256(RegisterFile)
	} else {
		blake2b(jit_buffer, 32, &VM, 256); // R = Hash256(RegisterFile)
	}
}

// (single) iterate the VM
WASM_EXPORT("Rs")
uint32_t iterate_vm_single() {
	uint32_t ret = iterate_vm_hash();

	if (ret == 0) {
		// "The last iteration skips steps 9 and 10."
		TIMEIT("scratchpad hash");
		final_vm_single_iteration();
		TIMEIT_END("scratchpad hash");
	}

	return ret;
}

static void pack_nonce() {
	/* memcpy(st.blob, jit_buffer, 39); // copy in blob parameter
	// nonce is 4 bytes, write it out
	memcpy(st.blob + 39, &st.nonce, 4);
	// copy rest of the blob
	memcpy(st.blob + 43, jit_buffer + 39, st.blob_length - 39); */

	memcpy(st.blob + 39, &st.nonce, 4);
}

// (miner) iterate the VM
WASM_EXPORT("Rm")
uint32_t iterate_vm_miner() {
	if (program_count == 0xff) {
		pack_nonce();
		blake2b(S, 64, st.blob, st.blob_length); // S = Hash512(template)

		program_count = RANDOMX_PROGRAM_COUNT;
	}

	uint32_t ret = iterate_vm_hash();

	if (ret == 0) {
		// tail next
		return final_vm_miner_iteration();
	} else {
		return ret;
	}
}

static uint32_t final_vm_miner_iteration() {
	// A = AesHash1R(Scratchpad), overwrite the 64 bytes of RegisterFile
	hashAes1Rx4(scratchpad, RANDOMX_SCRATCHPAD_L3, (void *)&VM.a);
	blake2b(jit_buffer, 32, &VM, 256); // R = Hash256(RegisterFile)
	st.hashes++;

	// check if the hash is below the target
	if (*(uint64_t*)(jit_buffer + 24) < st.target) {
		// copy nonce to the output buffer + 32
		memcpy(jit_buffer + 32, &st.nonce, 4);
		return NONCE_FOUND;
	}

	st.nonce++;
	if (st.nonce >= st.nonce_end) {
		return NONCE_SPACE_EXHAUSTED;
	}

	program_count = 0xff;
	return iterate_vm_miner(); // continue with the next nonce
}

// (miner) initialise the miner blob
WASM_EXPORT("B")
void init_new_blob(uint32_t bl, uint64_t t, uint32_t n, uint32_t ne) {
	st.blob_length = bl;
	memcpy(st.blob, jit_buffer, st.blob_length); // copy in blob parameter

	st.nonce = n;
	st.nonce_end = ne;
	st.target = t;
	st.hashes = 0;
	program_count = 0xff; // new nonce state

	uint8_t major_version = st.blob[0];
	uint8_t cnv = 0;
	if (major_version >= 7) {
		cnv = major_version - 6;
	}

	assert(cnv > 5); // RandomX
}

// (miner) get the current nonce
WASM_EXPORT("n")
uint64_t get_nonce() {
	return st.nonce;
}

// (miner) get the current nonce
WASM_EXPORT("h")
uint32_t get_hashes() {
	return st.hashes;
}

#if INSTRUMENT == 1

const char *inst_tos[] = {
	[IADD_RS] = "IADD_RS",
	[IADD_M] = "IADD_M",
	[ISUB_R] = "ISUB_R",
	[ISUB_M] = "ISUB_M",
	[IMUL_R] = "IMUL_R",
	[IMUL_M] = "IMUL_M",
	[IMULH_R] = "IMULH_R",
	[IMULH_M] = "IMULH_M",
	[ISMULH_R] = "ISMULH_R",
	[ISMULH_M] = "ISMULH_M",
	[IMUL_RCP] = "IMUL_RCP",
	[INEG_R] = "INEG_R",
	[IXOR_R] = "IXOR_R",
	[IXOR_M] = "IXOR_M",
	[IROR_R] = "IROR_R",
	[IROL_R] = "IROL_R",
	[ISWAP_R] = "ISWAP_R",
	[FSWAP_R] = "FSWAP_R",
	[FADD_R] = "FADD_R",
	[FADD_M] = "FADD_M",
	[FSUB_R] = "FSUB_R",
	[FSUB_M] = "FSUB_M",
	[FSCAL_R] = "FSCAL_R",
	[FMUL_R] = "FMUL_R",
	[FDIV_M] = "FDIV_M",
	[FSQRT_R] = "FSQRT_R",
	[CBRANCH] = "CBRANCH",
	[CFROUND] = "CFROUND",
	[ISTORE] = "ISTORE",
	[NOP] = "NOP",
};

WASM_EXPORT("b")
void breakpoint(uint32_t ic, int pc, uint32_t mx, uint32_t ma, uint32_t sp_addr0, uint32_t sp_addr1) {
	// ic starts at RANDOMX_PROGRAM_ITERATIONS, then counts down, reverse of the spec
	if (pc == -1) {
		printf("ic: %04u mx: %08x ma: %08x sp_addr0: %08x sp_addr1: %08x\n", RANDOMX_PROGRAM_ITERATIONS - ic, mx, ma, sp_addr0, sp_addr1);
	} else {
		printf("pc: %03d %s\n", pc, inst_tos[P.program[pc].opcode]); // program P is augmented after compilation
	}

	uint8_t scratchpad_hash[32]; // Hash256(scratchpad)

#define C(x) *(uint64_t *)&(x)
	printf("  r0: %016llx r1: %016llx r2: %016llx r3: %016llx\n", VM.r[0], VM.r[1], VM.r[2], VM.r[3]);
	printf("  r4: %016llx r5: %016llx r6: %016llx r7: %016llx\n", VM.r[4], VM.r[5], VM.r[6], VM.r[7]);
	// nanoprintf doesn't properly support %a format specifier
	printf("  f0: %016llx %016llx f1: %016llx %016llx\n", C(VM.f[0].lo), C(VM.f[0].hi), C(VM.f[1].lo), C(VM.f[1].hi));
	printf("  f2: %016llx %016llx f3: %016llx %016llx\n", C(VM.f[2].lo), C(VM.f[2].hi), C(VM.f[3].lo), C(VM.f[3].hi));
	printf("  e0: %016llx %016llx e1: %016llx %016llx\n", C(VM.e[0].lo), C(VM.e[0].hi), C(VM.e[1].lo), C(VM.e[1].hi));
	printf("  e2: %016llx %016llx e3: %016llx %016llx\n", C(VM.e[2].lo), C(VM.e[2].hi), C(VM.e[3].lo), C(VM.e[3].hi));

	if (pc == -1) {
		printf("  a0: %016llx %016llx a1: %016llx %016llx\n", C(VM.a[0].lo), C(VM.a[0].hi), C(VM.a[1].lo), C(VM.a[1].hi));
		printf("  a2: %016llx %016llx a3: %016llx %016llx\n", C(VM.a[2].lo), C(VM.a[2].hi), C(VM.a[3].lo), C(VM.a[3].hi));
	}

	printf("  fprc: %u\n", VM.fprc);

	blake2b(scratchpad_hash, 32, scratchpad, RANDOMX_SCRATCHPAD_L3);
	printf("  Hash256(scratchpad): ");
	for (int i = 0; i < 32; i++) {
		printf("%02x", scratchpad_hash[i]);
	}
	printf("\n");
#undef C
}
#endif
