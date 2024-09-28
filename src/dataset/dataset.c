#include "argon2fill/argon2fill.h"
#include "blake2b/blake2b.h"
#include "cache.h"
#include "freestanding.h"

#include "jit/jit.h"
#include "jit/ssh.h"

#include <stdint.h>

// most assertions, particularly at the API boundary, will be assumed to be handled by the host

// 48 KiB, average program size is 32 KiBs
// also use for key, 0-60
static uint8_t jit_buffer[48 * 1024];

static uint8_t cache[RANDOMX_ARGON_MEMORY * ARGON2_BLOCK_SIZE]; // 64-byte cache line
static ss_program_t programs[RANDOMX_CACHE_ACCESSES];
static int memory_pages_of_dataset;

// `memory_pages_of_dataset` is to avoid the chicken-and-egg problem, without fucking the build script

WASM_EXPORT("c")
void *jit(int pages) {
	memory_pages_of_dataset = pages;
	return jit_buffer;
}

WASM_EXPORT("K")
uint32_t init_new_key(uint32_t key_length, bool is_shared_memory) {
	init_new_cache(jit_buffer, key_length, cache);

	// sshash_program_t program[RANDOMX_CACHE_ACCESSES];
	blake2b_generator_state S[1];
	blake2b_generator_init(S, jit_buffer, key_length);

	// generate RANDOMX_CACHE_ACCESSES programs
	for (int i = 0; i < RANDOMX_CACHE_ACCESSES; i++) {
		ssh_generate(S, &programs[i]);
	}

	uint32_t wasm_size = jit_ssh(programs, cache, jit_buffer, is_shared_memory, memory_pages_of_dataset);

	return wasm_size;
}
