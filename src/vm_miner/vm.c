#include "vm/vm.h"
#include "aes/aes.h"
#include "blake2b/blake2b.h"
#include "freestanding.h"
#include "jit/jit.h"
#include "jit/jit_vm.h"

#include <stdint.h>

#if INSTRUMENT
#error "Instrumentation is not supported in the VM miner"
#endif

// average RandomX WASM module size is 10 KiBs
static uint8_t jit_buffer[16 * 1024];

static uint8_t blob[256];
static uint32_t blob_length;

static uint32_t nonce;
static uint32_t nonce_end;
static uint64_t target;

static uint8_t program_count;

static uint32_t hashes;

WASM_EXPORT("h")
uint32_t get_hashes() {
	return hashes;
}

WASM_EXPORT("i")
void *init(uint8_t f) {
	jit_feature = f;
	return jit_buffer;
}

WASM_EXPORT("B")
void init_new_blob(uint32_t bl, uint64_t t, uint32_t n, uint32_t ne) {
	blob_length = bl;
	memcpy(blob, jit_buffer, blob_length); // copy in blob parameter

	nonce = n;
	nonce_end = ne;
	target = t;
	program_count = 0xff; // new nonce state

	uint8_t major_version = blob[0];
	uint8_t cnv = 0;
	if (major_version >= 7) {
		cnv = major_version - 6;
	}

	assert(cnv > 5); // RandomX
}

uint8_t S[64]; // 512-bit seed - state of the generator gen1 + gen4

alignas(16) rx_program_t P; // program buffer
alignas(16) rx_vm_t VM;
uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

static uint32_t final_vm_iteration();
static uint32_t iterate_vm_hash();
static void pack_nonce();

// repeat VM calls require the JITted code to be executed.
// this means we have to return back to caller for the JS to compile and invoke it

enum {
	NONCE_SPACE_EXHAUSTED = 0,
	NONCE_FOUND = 1,
};

static void pack_nonce() {
	memcpy(blob, jit_buffer, 39); // copy in blob parameter
	// nonce is 4 bytes, write it out
	memcpy(blob + 39, &nonce, 4);
	// copy rest of the blob
	memcpy(blob + 43, jit_buffer + 39, blob_length - 39);
}

WASM_EXPORT("R")
uint32_t iterate_vm() {
	if (program_count == 0xff) {
		pack_nonce();
		blake2b(S, 64, jit_buffer, blob_length); // S = Hash512(H)

		program_count = RANDOMX_PROGRAM_COUNT;
	}

	return iterate_vm_hash();
}

WASM_EXPORT("n")
uint64_t get_nonce() {
	return nonce;
}

static uint32_t final_vm_iteration() {
	// A = AesHash1R(Scratchpad), overwrite the 64 bytes of RegisterFile
	hashAes1Rx4(scratchpad, RANDOMX_SCRATCHPAD_L3, (void *)&VM.a);
	blake2b(jit_buffer, 32, &VM, 256); // R = Hash256(RegisterFile)

	// check if the hash is below the target
	if (*(uint64_t*)(jit_buffer + 24) < target) {
		// copy nonce to the output buffer + 32
		memcpy(jit_buffer + 32, &nonce, 4);
		return NONCE_FOUND;
	}

	nonce++;
	if (nonce >= nonce_end) {
		return NONCE_SPACE_EXHAUSTED;
	}

	program_count = 0xff;
	return iterate_vm(); // continue with the next nonce
}

static uint32_t iterate_vm_hash() {
	// first iteration
	if (program_count == RANDOMX_PROGRAM_COUNT) {
		// S now contains the seed, modify it after scratchpad initialisation
		fillAes1Rx4(S, RANDOMX_SCRATCHPAD_L3, scratchpad); // 2 MiBs

		// reset rounding mode, rounding mode is preserved over RANDOMX_PROGRAM_COUNT programs
		VM.fprc = 0;
		program_count = RANDOMX_PROGRAM_COUNT;
	} else if (program_count == 0) {
		// "The last iteration skips steps 9 and 10."
		hashes++;
		return final_vm_iteration();
	} else {
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
	return jit_vm(&VM, &P, scratchpad, jit_buffer);
}

