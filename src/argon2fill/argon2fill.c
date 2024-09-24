#include "argon2fill.h"
#include "blake2b/blake2b.h"
#include "configuration.h"
#include "freestanding.h"

#include <stdint.h>

void rxa2_initial_hash(uint8_t *key, uint32_t key_length, uint8_t blockhash[ARGON2_PREHASH_SEED_LENGTH]) {
	blake2b_state S[1];

	uint32_t word;

	blake2b_init_key(S, ARGON2_PREHASH_DIGEST_LENGTH, NULL, 0);

#define WORD(v) \
	word = v;   \
	blake2b_update(S, (uint8_t *)&word, sizeof(word))

	WORD(RANDOMX_ARGON_LANES);      // lanes
	WORD(0);                        // outlen
	WORD(RANDOMX_ARGON_MEMORY);     // m_cost
	WORD(RANDOMX_ARGON_ITERATIONS); // t_cost
	WORD(ARGON2_VERSION_NUMBER);    // version
	WORD(0);                        // type (Argon2_d)

	WORD(key_length);                                                        // pwdlen
	blake2b_update(S, key, key_length);                                      // pwd
	WORD(STRLEN_CONST(RANDOMX_ARGON_SALT));                                  // saltlen
	blake2b_update(S, RANDOMX_ARGON_SALT, STRLEN_CONST(RANDOMX_ARGON_SALT)); // salt

	WORD(0); // secretlen
	WORD(0); // adlen

#undef WORD

	blake2b_finalise(S, blockhash);
}

void rxa2_fill_first_blocks(uint8_t blockhash[ARGON2_PREHASH_SEED_LENGTH], const argon2_instance_t *instance) {
	uint32_t l;
	/* Make the first and second block in each lane as G(H0||0||i) or
	   G(H0||1||i) */
	uint8_t blockhash_bytes[ARGON2_BLOCK_SIZE];
	for (l = 0; l < instance->lanes; ++l) {
		*(uint32_t *)(blockhash + ARGON2_PREHASH_DIGEST_LENGTH) = 0;
		*(uint32_t *)(blockhash + ARGON2_PREHASH_DIGEST_LENGTH + 4) = l;

		blake2b_1024(blockhash_bytes, blockhash, ARGON2_PREHASH_SEED_LENGTH);
		memcpy(&instance->memory[l * instance->lane_length + 0], blockhash_bytes, ARGON2_BLOCK_SIZE);

		*(uint32_t *)(blockhash + ARGON2_PREHASH_DIGEST_LENGTH) = 1;
		blake2b_1024(blockhash_bytes, blockhash, ARGON2_PREHASH_SEED_LENGTH);
		memcpy(&instance->memory[l * instance->lane_length + 1], blockhash_bytes, ARGON2_BLOCK_SIZE);
	}
}

void randomx_argon2_initialize(uint8_t *key, uint32_t key_length, argon2_instance_t *instance) {
	uint8_t blockhash[ARGON2_PREHASH_SEED_LENGTH];

	/* 1. Memory allocation */
	// we have memory already!!!

	/* 2. Initial hashing */
	/* H_0 + 8 extra bytes to produce the first blocks */
	/* uint8_t blockhash[ARGON2_PREHASH_SEED_LENGTH]; */
	/* Hashing all inputs */
	rxa2_initial_hash(key, key_length, blockhash);

	/* 3. Creating first blocks, we always have at least two blocks in a slice
	 */
	rxa2_fill_first_blocks(blockhash, instance);
}

void randomx_argon2_fill_memory_blocks(const argon2_instance_t *instance) {
	uint32_t r, s, l;

	for (r = 0; r < instance->passes; ++r) {
		for (s = 0; s < ARGON2_SYNC_POINTS; ++s) {
			for (l = 0; l < instance->lanes; ++l) {
				argon2_position_t position = {r, l, (uint8_t)s, 0};

				// printf("[randomx_argon2_fill_memory_blocks]: %p [%d %d %d]\n", instance->memory, r, s, l);
				randomx_argon2_fill_segment_v128(instance, position);
			}
		}
	}
}
