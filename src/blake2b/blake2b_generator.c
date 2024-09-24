#include "blake2b.h"
#include "freestanding.h"

#define MAX_SEED_SIZE 60

static inline void check_data(blake2b_generator_state *S, uint32_t bytes_needed) {
	if (S->index + bytes_needed > sizeof(S->data)) {
		blake2b(S->data, sizeof(S->data), S->data, sizeof(S->data));
		S->index = 0;
	}
}

void blake2b_generator_init(blake2b_generator_state *S, const uint8_t *seed, int seed_len) {
	S->index = sizeof(S->data);
	memset(S->data, 0, sizeof(S->data));
	memcpy(S->data, seed, seed_len > MAX_SEED_SIZE ? MAX_SEED_SIZE : seed_len);
}

uint8_t blake2b_generator_u8(blake2b_generator_state *S) {
	check_data(S, 1);
	return S->data[S->index++];
}

uint32_t blake2b_generator_u32(blake2b_generator_state *S) {
	check_data(S, 4);
	uint32_t ret = *(uint32_t *)(S->data + S->index);
	S->index += 4;
	return ret;
}
