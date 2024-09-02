#include "argon2fill.h"
#include "blake2b.h"
#include "configuration.h"
#include "wasm.h"

#include <stdint.h>

// most assertions, particularly at the API boundary, will be assumed to be handled by the host

// B()  - get the input buffer, write inputs and read outputs from here
// K()  - load a new 0-60 byte key K, will create an entire cache
// Hi() - initialise a new hash H, with an output length of 0-64 bytes
// H()  - accept a chunk of the hash data, up to IO_BUFFER_SIZE
// Hf() - finalise and install the hash data H as new seed S
// R()  - execute and return the 256-bit result R

uint8_t H_buffer[IO_BUFFER_SIZE];

blake2b_state *SS; // seed state
uint8_t S[64];     // 512-bit seed

uint8_t cache[RANDOMX_ARGON_MEMORY * ARGON2_BLOCK_SIZE]; // 64-byte cache line
uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

// uint8_t feature_code; // JS, SIMD or FMA

WASM_EXPORT("B")
void *get_input_buffer() {
	return H_buffer;
}

WASM_EXPORT("K")
void init_new_key(uint32_t key_length) {
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
	randomx_argon2_initialize(H_buffer, key_length, &instance);

	printf("[K] argon2 initialised\n");

	// 4. filler
	randomx_argon2_fill_memory_blocks(&instance);

	printf("[K] %d 1KiB memory_blocks filled\n", memory_blocks);
}

WASM_EXPORT("Hi")
void init_new_hash() {
	blake2b_init_key(SS, 64, NULL, 0);
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
	__builtin_unreachable();
}
