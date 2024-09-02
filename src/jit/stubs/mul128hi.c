#include "wasm.h"
#include <stdint.h>

#define LO(x) ((x)&0xffffffff)
#define HI(x) ((x)>>32)

WASM_EXPORT("mul128hi")
uint64_t mul128hi(uint64_t a, uint64_t b) {
	uint64_t ah = HI(a), al = LO(a);
	uint64_t bh = HI(b), bl = LO(b);
	uint64_t x00 = al * bl;
	uint64_t x01 = al * bh;
	uint64_t x10 = ah * bl;
	uint64_t x11 = ah * bh;
	uint64_t m1 = LO(x10) + LO(x01) + HI(x00);
	uint64_t m2 = HI(x10) + HI(x01) + LO(x11) + HI(m1);
	uint64_t m3 = HI(x11) + HI(m2);

	return (m3 << 32) + LO(m2);
}
