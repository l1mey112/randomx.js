#include "vm/vm.h"
#include "aes/aes.h"
#include "blake2b/blake2b.h"
#include "configuration.h"
#include "freestanding.h"
#include "jit/jit.h"

#include <stdint.h>

// TODO: figure out how big this should be
uint8_t jit_buffer[128 * 1024];

blake2b_state *SS; // seed state
uint8_t program_count;

WASM_EXPORT("i")
void *init(uint8_t f) {
	jit_feature = f;
	return jit_buffer;
}

WASM_EXPORT("I")
void init_new_hash() {
	blake2b_init_key(SS, 64, NULL, 0);
}

WASM_EXPORT("H")
void update_hash(uint32_t data_length) {
	blake2b_update(SS, jit_buffer, data_length);
}

uint8_t S[64]; // 512-bit seed - state of the generator gen1 + gen4

alignas(16) rx_program_t P; // program buffer
alignas(16) rx_vm_t VM;
uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

WASM_EXPORT("R")
void finalise_hash() {
	blake2b_finalise(SS, S);

	// S now contains the seed
	fillAes1Rx4(S, RANDOMX_SCRATCHPAD_L3, scratchpad); // 2 MiBs

	VM.fprc = 0; // reset rounding mode
	program_count = RANDOMX_PROGRAM_COUNT;
}

// repeat VM calls require the JITted code to be executed.
// this means we have to return back to caller for the JS to compile and invoke it.
//
// we have to execute the VM at most RANDOMX_PROGRAM_COUNT times, and its absolutely
// ugly and unmaintainable to turn a while loop with special cases into a suspendable
// generator using a single function. i would rather split it up into a `Ri` + `Rf`.
// i am sure JS->WASM calls are negligible in performance.
//
// do {
//     exports.Ri()
// } while (exports.Rf())
//

WASM_EXPORT("Ri")
uint32_t iterate_vm() {
	assert(program_count != 0);

	fillAes4Rx4(S, sizeof(P), (void *)&P); // program generation
	vm_program(&VM, &P);
	return jit_vm(&VM, &P, scratchpad, jit_buffer);
}

void final_vm_iteration();

WASM_EXPORT("Rf")
bool finalise_vm() {
	assert(program_count != 0);

	// "The last iteration skips steps 9 and 10."
	if (program_count == 1) {
		final_vm_iteration();
	} else {
		// steps 9, 10
		blake2b(S, 64, &VM, 256); // S = Hash512(RegisterFile)
	}
	program_count--;

	return program_count != 0;
}

void final_vm_iteration() {
	// A = AesHash1R(Scratchpad), overwrite the 64 bytes of RegisterFile
	hashAes1Rx4(scratchpad, RANDOMX_SCRATCHPAD_L3, (void *)&VM.a);
	blake2b(jit_buffer, 32, &VM, 256); // R = Hash256(RegisterFile)
}
