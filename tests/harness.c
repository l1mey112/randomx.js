#include "configuration.h"
#include "freestanding.h"

#include "blake2b/blake2b.h"
#include "dataset/cache.h"
#include "jit/ssh.h"
#include "jit/jit.h"
#include "aes/aes.h"

#include <stdint.h>
#include <wasm_simd128.h>

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
	blake2b(scratch, 32, SSH->instructions, sizeof(rx_inst_t) * SSH->size);
}

WASM_EXPORT("jit_reciprocal")
uint64_t export_jit_reciprocal(uint64_t divisor) {
	return jit_reciprocal(divisor);
}

WASM_EXPORT("fillAes1Rx4")
void export_fillAes1Rx4(void) {
	uint8_t state[64] = {};
	memcpy(state, scratch, 64);
	fillAes1Rx4(state, 64, scratch);
}

WASM_EXPORT("soft_aesenc")
void export_soft_aesenc(void) {
	v128_t state = wasm_v128_load(scratch);
	v128_t key = wasm_v128_load(scratch + 16);
	v128_t result = soft_aesenc(state, key);
	wasm_v128_store(scratch, result);
}

WASM_EXPORT("soft_aesdec")
void export_soft_aesdec(void) {
	v128_t state = wasm_v128_load(scratch);
	v128_t key = wasm_v128_load(scratch + 16);
	v128_t result = soft_aesdec(state, key);
	wasm_v128_store(scratch, result);
}


WASM_EXPORT("program_VM")
void *export_program_VM(uint32_t hash_length) {
	static uint8_t S[64]; // 512-bit seed - state of the generator gen1 + gen4
	static alignas(16) rx_program_t P; // program buffer
	static alignas(16) rx_vm_t VM;
	static uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

	memset(&VM, 0, sizeof(VM));

	blake2b(S, 64, scratch, hash_length); // seed generation
	// S now contains the seed
	fillAes1Rx4(S, RANDOMX_SCRATCHPAD_L3, scratchpad); // 2 MiBs
	fillAes4Rx4(S, sizeof(P), (void *)&P); // program generation
	vm_program(&VM, &P); // program VM

	return &VM;
}
