#include "configuration.h"
#include "wasm.h"

#include "blake2b/blake2b.h"
#include "dataset/cache.h"
#include "jit/ssh.h"

#include <stdint.h>

static uint8_t scratch[16 * 1024];
static uint8_t cache[RANDOMX_ARGON_MEMORY * 1024];

static blake2b_state BLAKE2B_S[1];

WASM_EXPORT("scratch_buffer")
void *export_scratch_buffer() {
	return scratch;
}

WASM_EXPORT("cache_buffer")
void *export_cache_buffer() {
	return cache;
}

WASM_EXPORT("blake2b_init_key")
void export_blake2b_init_key(uint32_t key_length, uint32_t hash_length) {
	blake2b_init_key(BLAKE2B_S, hash_length, scratch, key_length);
}

WASM_EXPORT("blake2b_update")
void export_blake2b_update(uint32_t data_length) {
	blake2b_update(BLAKE2B_S, scratch, data_length);
}

WASM_EXPORT("blake2b_finalise")
void export_blake2b_finalise(void) {
	blake2b_finalise(BLAKE2B_S, scratch);
}

static blake2b_generator_state BLAKE2B_GEN_S[1];

WASM_EXPORT("blake2b_generator_init")
void export_blake2b_generator_init(uint32_t seed_length) {
	blake2b_generator_init(BLAKE2B_GEN_S, scratch, seed_length);
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
	init_new_cache(scratch, key_length, cache);
}

WASM_EXPORT("blake2b_1024")
void export_blake2b_1024(uint32_t data_length) {
	blake2b_1024(scratch, scratch, data_length);
}

WASM_EXPORT("ssh_init_newblake")
void export_ssh_init(uint32_t key_length) {
	blake2b_generator_init(BLAKE2B_GEN_S, scratch, key_length);
}

static ss_program_t SSH[1];

WASM_EXPORT("ssh_generate_hash256")
void export_ssh_generate(void) {
	ssh_generate(BLAKE2B_GEN_S, SSH);
	blake2b(scratch, 32, SSH->instructions, sizeof(ss_inst_t) * SSH->size);
}
