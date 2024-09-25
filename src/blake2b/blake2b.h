#pragma once

#include <stdint.h>

#define BLAKE2B_BLOCKBYTES 128
#define BLAKE2B_OUTBYTES 64
#define BLAKE2B_KEYBYTES 64
#define BLAKE2B_SALTBYTES 16
#define BLAKE2B_PERSONALBYTES 16

typedef struct blake2b_state blake2b_state;
typedef struct blake2b_generator_state blake2b_generator_state;

struct blake2b_state {
	uint64_t h[8];
	uint64_t t[2];
	uint64_t f[2];
	uint8_t buf[BLAKE2B_BLOCKBYTES];
	int buflen;
	int outlen;
	uint8_t last_node;
};

// `blake2b_*hex` needs `outlen` * 2 of space in `out`

void blake2b_init_key(blake2b_state *S, int outlen, const uint8_t *key, int keylen);
void blake2b_update(blake2b_state *S, const void *pin, int inlen);
void blake2b_finalise(blake2b_state *S, uint8_t buffer[BLAKE2B_OUTBYTES]);
void blake2b_finalise_hex(blake2b_state *S, uint8_t *buffer);

void blake2b(uint8_t *out, uint32_t outlen, const void *in, uint32_t inlen);
void blake2b_hex(uint8_t *out, uint32_t outlen, const void *in, uint32_t inlen);
void blake2b_1024(uint8_t *out, const void *in, uint32_t inlen);

struct blake2b_generator_state {
	uint8_t data[64];
	uint32_t index;
};

void blake2b_generator_init(blake2b_generator_state *S, const uint8_t *seed, int seed_len);
uint8_t blake2b_generator_u8(blake2b_generator_state *S);
uint32_t blake2b_generator_u32(blake2b_generator_state *S);
