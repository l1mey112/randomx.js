#include <stdbool.h>
#include <stdint.h>

uint32_t i64_leb128(int64_t val, uint8_t data[10]) {
	bool negative = val < 0;
	uint32_t i = 0;
	while (1) {
		uint8_t b = val & 0x7F;
		val >>= 7;
		if (negative) {
			val |= (~0ULL << 57);
		}
		if (((val == 0) && (!(b & 0x40))) ||
		    ((val == -1) && (b & 0x40))) {
			data[i++] = b;
			return i;
		} else {
			data[i++] = b | 0x80;
		}
	}
}

uint32_t u32_leb128(uint32_t val, uint8_t data[5]) {
	int i = 0;
	while (1) {
		uint8_t b = val & 0x7F;
		val >>= 7;
		if (val == 0) {
			data[i++] = b;
			return i;
		} else {
			data[i++] = b | 0x80;
		}
	}
}
