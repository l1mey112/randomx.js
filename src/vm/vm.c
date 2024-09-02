#include "configuration.h"
#include "wasm.h"

#include "blake2b/blake2b.h"
#include "aes/aes.h"

uint8_t H_buffer[1024 * 8];

blake2b_state *SS; // seed state
uint8_t S[64];     // 512-bit seed

uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

WASM_EXPORT("b")
void *get_input_buffer() {
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

WASM_EXPORT("R")
void finalise_hash() {
	blake2b_finalise(SS, S);

	printf("before fillAes1Rx4\n");

	// S now contains the seed
	fillAes1Rx4(S, RANDOMX_SCRATCHPAD_L3, scratchpad);

	printf("after fillAes1Rx4\n");
}
