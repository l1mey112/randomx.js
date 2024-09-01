#include "../blake2b/blake2b.h"
#include "argon2fill.h"
#include "configuration.h"
#include "wasm.h"

#include "../jit/ssh.h"
#include "../jit/jit.h"

#include <stdint.h>

// memory_blocks * ARGON2_BLOCK_SIZE = length in bytes of cache
void init_new_cache(uint8_t *key, uint32_t key_length, uint8_t cache[RANDOMX_ARGON_MEMORY * ARGON2_BLOCK_SIZE]) {
	// create new cache
	argon2_instance_t instance;

	uint32_t memory_blocks = RANDOMX_ARGON_MEMORY; // m_cost

	/* 2. Align memory size */
	/* Minimum memory_blocks = 8L blocks, where L is the number of lanes */
	uint32_t segment_length = memory_blocks / (RANDOMX_ARGON_LANES * ARGON2_SYNC_POINTS);

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
	randomx_argon2_initialize(key, key_length, &instance);

	// 4. filler
	randomx_argon2_fill_memory_blocks(&instance);
}
