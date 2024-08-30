#include "../blake2b/blake2b.h"
#include "../dataset/cache.h"
#include "configuration.h"
#include "wasm.h"

#include <stdint.h>

uint8_t H_buffer[RANDOMX_ARGON_MEMORY * 1024];

blake2b_state BLAKE2B_S[1];

WASM_EXPORT("buffer")
void *buffer() {
	return H_buffer;
}

WASM_EXPORT("blake2b_init_key")
void export_blake2b_init_key(uint32_t key_length, uint32_t hash_length) {
	blake2b_init_key(BLAKE2B_S, hash_length, H_buffer, key_length);
}

WASM_EXPORT("blake2b_update")
void export_blake2b_update(uint32_t data_length) {
	blake2b_update(BLAKE2B_S, H_buffer, data_length);
}

WASM_EXPORT("blake2b_finalise")
void export_blake2b_finalise(void) {
	blake2b_finalise(BLAKE2B_S, H_buffer);
}

blake2b_generator_state BLAKE2B_GEN_S[1];

WASM_EXPORT("blake2b_generator_init")
void export_blake2b_generator_init(uint32_t seed_length) {
	blake2b_generator_init(BLAKE2B_GEN_S, H_buffer, seed_length);
}

WASM_EXPORT("blake2b_generator_u8")
uint8_t export_blake2b_generator_u8(void) {
	return blake2b_generator_u8(BLAKE2B_GEN_S);
}

WASM_EXPORT("blake2b_generator_i32")
int32_t export_blake2b_generator_i32(void) {
	return blake2b_generator_u32(BLAKE2B_GEN_S);
}

WASM_EXPORT("init_new_cache")
void export_init_new_cache(uint32_t key_length) {
	init_new_cache(H_buffer, key_length, H_buffer);
}

WASM_EXPORT("blake2b_1024")
void export_blake2b_1024(uint32_t data_length) {
	blake2b_1024(H_buffer, H_buffer, data_length);
}
