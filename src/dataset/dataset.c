#include "../blake2b/blake2b.h"
#include "argon2fill.h"
#include "configuration.h"
#include "wasm.h"
#include "cache.h"

#include "ssh.h"
#include "../jit/jit.h"

#include <stdint.h>

// most assertions, particularly at the API boundary, will be assumed to be handled by the host

uint8_t K_buffer[60];                                    // 0-60
uint8_t cache[RANDOMX_ARGON_MEMORY * ARGON2_BLOCK_SIZE]; // 64-byte cache line
ss_program_t programs[RANDOMX_CACHE_ACCESSES];
uint8_t jit_buffer[16 * 1024]; // 16 KiB, just hope it doesn't overflow

WASM_EXPORT("Kb")
void *get_K_buffer() {
	return K_buffer;
}

WASM_EXPORT("Cb")
void *get_cache() {
	return cache;
}

WASM_EXPORT("Jb")
void *get_jit() {
	return jit_buffer;
}

WASM_EXPORT("K")
uint32_t init_new_key(uint32_t key_length) {
	printf("[K] initialise cache with key length %u\n", key_length);

	init_new_cache(K_buffer, key_length, cache);

	// sshash_program_t program[RANDOMX_CACHE_ACCESSES];
	blake2b_generator_state S[1];
	blake2b_generator_init(S, K_buffer, key_length);

	// generate RANDOMX_CACHE_ACCESSES programs
	for (int i = 0; i < RANDOMX_CACHE_ACCESSES; i++) {
		ssh_generate(S, &programs[i]);
	}

	uint32_t wasm_size = ssh_jit(programs, jit_buffer);

	return wasm_size;
}
