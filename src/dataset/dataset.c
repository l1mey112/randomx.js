#include "argon2fill.h"
#include "../blake2b/blake2b.h"
#include "configuration.h"
#include "wasm.h"

#include <stdint.h>

// most assertions, particularly at the API boundary, will be assumed to be handled by the host

uint8_t K_buffer[60]; // 0-60
uint8_t cache[RANDOMX_ARGON_MEMORY * ARGON2_BLOCK_SIZE]; // 64-byte cache line
uint8_t program_buffer[8192]; // 8 KiB

WASM_EXPORT("Kb")
void* get_K_buffer() {
	return K_buffer;
}

WASM_EXPORT("Cb")
void* get_cache() {
	return cache;
}

WASM_EXPORT("K")
void init_new_key(uint32_t key_length) {
	printf("[K] initialise cache with key length %u\n", key_length);

	// create new cache
	uint32_t memory_blocks, segment_length;
	argon2_instance_t instance;

	/* 2. Align memory size */
	/* Minimum memory_blocks = 8L blocks, where L is the number of lanes */
	memory_blocks = RANDOMX_ARGON_MEMORY;
	segment_length = memory_blocks / (RANDOMX_ARGON_LANES * ARGON2_SYNC_POINTS);

	instance.passes = RANDOMX_ARGON_ITERATIONS;
	instance.memory_blocks = memory_blocks;
	instance.segment_length = segment_length;
	instance.lane_length = segment_length * ARGON2_SYNC_POINTS;
	instance.lanes = RANDOMX_ARGON_LANES;
	instance.threads = 1;
	instance.memory = (argon2_block_t *)cache;

	if (instance.threads > instance.lanes) {
		instance.threads = instance.lanes;
	}

	/* 3. Initialization: Hashing inputs, allocating memory, filling first
	 * blocks
	 */
	randomx_argon2_initialize(K_buffer, key_length, &instance);

	printf("[K] argon2 initialised\n");

	// 4. filler
	randomx_argon2_fill_memory_blocks(&instance);

	printf("[K] %d 1KiB memory_blocks filled\n", memory_blocks);
}
