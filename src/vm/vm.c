#include "configuration.h"
#include "freestanding.h"
#include "aes/aes.h"
#include "blake2b/blake2b.h"
#include "vm/vm.h"
#include "jit/jit.h"

#include <stdint.h>

uint8_t H_buffer[1024 * 8];

blake2b_state *SS; // seed state

uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

WASM_EXPORT("i")
void *init(uint8_t f) {
	jit_feature = f;
	return H_buffer;
}

WASM_EXPORT("I")
void init_new_hash() {
	blake2b_init_key(SS, 64, NULL, 0);
}

WASM_EXPORT("H")
void update_hash(uint32_t data_length) {
	blake2b_update(SS, H_buffer, data_length);
}

uint8_t S[64];  // 512-bit seed - state of the generator gen4

alignas(16) rx_program_t P; // program buffer
alignas(16) rx_vm_t VM;

// TODO: figure out how big this should be
uint8_t jit_buffer[128 * 1024];

WASM_EXPORT("R")
void finalise_hash() {
	blake2b_finalise(SS, S);

	// S now contains the seed
	fillAes1Rx4(S, RANDOMX_SCRATCHPAD_L3, scratchpad); // 2 MiBs

	for (int chain = 0; chain < RANDOMX_PROGRAM_COUNT - 1; chain++) {
		fillAes4Rx4(S, sizeof(P), (void *)&P); // program generation

		vm_program(&VM, &P);
		uint32_t jit_length = jit_vm(&VM, &P, jit_buffer);
		// TODO: will need to return to caller to invoke JIT code
	}
}
