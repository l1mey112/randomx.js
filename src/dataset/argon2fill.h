#pragma once

#include <stdint.h>

#define ARGON2_BLOCK_SIZE 1024
#define ARGON2_QWORDS_IN_BLOCK (ARGON2_BLOCK_SIZE / 8)
#define ARGON2_OWORDS_IN_BLOCK (ARGON2_BLOCK_SIZE / 16)
#define ARGON2_HWORDS_IN_BLOCK (ARGON2_BLOCK_SIZE / 32)
#define ARGON2_512BIT_WORDS_IN_BLOCK (ARGON2_BLOCK_SIZE / 64)
#define ARGON2_ADDRESSES_IN_BLOCK 128
#define ARGON2_PREHASH_DIGEST_LENGTH 64
#define ARGON2_PREHASH_SEED_LENGTH 72
#define ARGON2_SYNC_POINTS 4U

#define ARGON2_VERSION_10 0x10
#define ARGON2_VERSION_13 0x13
#define ARGON2_VERSION_NUMBER ARGON2_VERSION_13

typedef struct argon2_instance_t argon2_instance_t;
typedef struct argon2_block_t argon2_block_t;
typedef struct argon2_position_t argon2_position_t;

struct argon2_block_t {
	uint64_t v[ARGON2_QWORDS_IN_BLOCK];
};

/*
 * Argon2 instance: memory pointer, number of passes, amount of memory, type,
 * and derived values.
 * Used to evaluate the number and location of blocks to construct in each
 * thread
 */
struct argon2_instance_t {
	argon2_block_t *memory; /* Memory pointer */
	uint32_t passes;        /* Number of passes */
	uint32_t memory_blocks; /* Number of blocks in memory */
	uint32_t segment_length;
	uint32_t lane_length;
	uint32_t lanes;
	uint32_t threads;
};

/*
 * Argon2 position: where we construct the block right now. Used to distribute
 * work between threads.
 */
struct argon2_position_t {
	uint32_t pass;
	uint32_t lane;
	uint8_t slice;
	uint32_t index;
};

void randomx_argon2_initialize(uint8_t *key, uint32_t key_length, argon2_instance_t *instance);
void randomx_argon2_fill_memory_blocks(const argon2_instance_t *instance);
void randomx_argon2_fill_segment_core_impl(const argon2_instance_t* instance, argon2_position_t position);
