#include "jit.h"

#include <stdint.h>

uint64_t jit_reciprocal(uint32_t divisor) {
	uint64_t p2exp63 = 1ULL << 63;
	uint64_t q = p2exp63 / divisor;
	uint64_t r = p2exp63 % divisor;
	int32_t shift = 64 - __builtin_clzll(divisor);
	return (q << shift) + ((r << shift) / divisor);
}
