#include "../blake2b/blake2b.h"
#include "argon2fill.h"
#include "configuration.h"
#include "wasm.h"

#include "ssh.h"

#include <stdint.h>

// most assertions, particularly at the API boundary, will be assumed to be handled by the host

uint8_t K_buffer[60]; // 0-60
uint8_t cache[RANDOMX_ARGON_MEMORY * ARGON2_BLOCK_SIZE]; // 64-byte cache line
ss_program_t programs[RANDOMX_CACHE_ACCESSES];

//uint8_t program_buffer[8192]; // 8 KiB

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

	// 5. generate superscalarhash programs

	// sshash_program_t program[RANDOMX_CACHE_ACCESSES];
	blake2b_generator_state S[1];
	blake2b_generator_init(S, K_buffer, key_length);
	
	for (int i = 0; i < RANDOMX_CACHE_ACCESSES; i++) {
		// generate a new program
		ssh_generate(S, &programs[i]);

		const char *inst_tostring[] = {
			[ISUB_R] = "ISUB_R",
			[IXOR_R] = "IXOR_R",
			[IADD_RS] = "IADD_RS",
			[IMUL_R] = "IMUL_R",
			[IROR_C] = "IROR_C",
			[IADD_C7] = "IADD_C7",
			[IXOR_C7] = "IXOR_C7",
			[IADD_C8] = "IADD_C8",
			[IXOR_C8] = "IXOR_C8",
			[IADD_C9] = "IADD_C9",
			[IXOR_C9] = "IXOR_C9",
			[IMULH_R] = "IMULH_R",
			[ISMULH_R] = "ISMULH_R",
			[IMUL_RCP] = "IMUL_RCP",
		};

		printf("program %d, %f\n", i, programs[i].ipc);
		for (uint32_t j = 0; j < programs[i].size; j++) {
			printf("\t%s\t%d\t%d\t%d\n", inst_tostring[programs[i].instructions[j].kind], programs[i].instructions[j].dst, programs[i].instructions[j].src, programs[i].instructions[j].imm32);
		}
	}
}
