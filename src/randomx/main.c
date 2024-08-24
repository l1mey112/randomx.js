#include "configuration.h"
#include "wasm.h"
#include "blake2b.h"

#include <stdint.h>

/* #define RANDOMX_CACHE_ITEMS (RANDOMX_ARGON_MEMORY * 1024 / 64)
uint8_t cache[RANDOMX_ARGON_MEMORY * 1024]; */

uint8_t H_buffer[IO_BUFFER_SIZE];

// most assertions, particularly at the API boundary, will be assumed to be handled by the host

// B()  - get the input buffer, write inputs and read outputs from here
// K()  - load a new 0-60 byte key K, will create an entire cache
// H()  - accept a chunk of the hash data, up to IO_BUFFER_SIZE
// Hf() - finalise and install the hash data H as new seed S
// R()  - execute and return the 256-bit result R

blake2b_state *SS; // seed state
alignas(128) uint8_t S[64]; // 512-bit seed

// uint8_t feature_code; // JS, SIMD or FMA

WASM_EXPORT("B")
void *get_input_buffer() {
	return H_buffer;
}

WASM_EXPORT("K")
void init_new_key(uint32_t key_length) {
	blake2b_init_key(SS, 64, H_buffer, key_length);
}

WASM_EXPORT("H")
void update_hash(uint32_t data_length) {
	blake2b_update(SS, H_buffer, data_length);
}

WASM_EXPORT("Hf")
void finalise_hash() {
	blake2b_finalise(SS, S);
}

WASM_EXPORT("R")
void execute() {
	
}
