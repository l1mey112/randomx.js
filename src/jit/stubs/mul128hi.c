#include "wasm.h"
#include <stdint.h>

WASM_EXPORT("mul128hi")
uint64_t mul128hi(uint64_t lhs, uint64_t rhs) {
	uint64_t lo_lo = (lhs & 0xFFFFFFFF) * (rhs & 0xFFFFFFFF);
	uint64_t hi_lo = (lhs >> 32) * (rhs & 0xFFFFFFFF);
	uint64_t lo_hi = (lhs & 0xFFFFFFFF) * (rhs >> 32);
	uint64_t hi_hi = (lhs >> 32) * (rhs >> 32);

	uint64_t cross = (lo_lo >> 32) + (hi_lo & 0xFFFFFFFF) + lo_hi;
	uint64_t upper = (hi_lo >> 32) + (cross >> 32) + hi_hi;

	return upper;
}
