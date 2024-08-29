#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

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

#define WASM_U8(p, v) \
	do {              \
		*p++ = (v);   \
	} while (0)

#define WASM_U32_0(p) WASM_U8(p, 0x00)  // 00
#define WASM_U32_1(p) WASM_U8(p, 0x01)  // 01
#define WASM_U32_2(p) WASM_U8(p, 0x02)  // 02
#define WASM_U32_3(p) WASM_U8(p, 0x03)  // 03
#define WASM_U32_4(p) WASM_U8(p, 0x04)  // 04
#define WASM_U32_5(p) WASM_U8(p, 0x05)  // 05
#define WASM_U32_6(p) WASM_U8(p, 0x06)  // 06
#define WASM_U32_7(p) WASM_U8(p, 0x07)  // 07
#define WASM_U32_8(p) WASM_U8(p, 0x08)  // 08
#define WASM_U32_9(p) WASM_U8(p, 0x09)  // 09
#define WASM_U32_10(p) WASM_U8(p, 0x0a) // 0a
#define WASM_U32_11(p) WASM_U8(p, 0x0b) // 0b
#define WASM_U32_12(p) WASM_U8(p, 0x0c) // 0c

#define WASM_TYPE_I32 0x7f
#define WASM_TYPE_I64 0x7e
#define WASM_TYPE_F32 0x7d
#define WASM_TYPE_F64 0x7c
#define WASM_TYPE_V128 0x7b

// uleb128
// >127 means 2+ bytes
#define WASM_U32(p, v)         \
	do {                       \
		p += u32_leb128(v, p); \
	} while (0)

#define WASM_I64(p, v)         \
	do {                       \
		p += i64_leb128(v, p); \
	} while (0)

#define WASM_I32(p, v)           \
	do {                         \
		WASM_I64(p, (int32_t)v); \
	} while (0)

// WASM_BINARY_MAGIC, WASM_BINARY_VERSION
// 0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00
#define WASM_MAGIC(p) \
	WASM_U8(p, 0x00); \
	WASM_U8(p, 0x61); \
	WASM_U8(p, 0x73); \
	WASM_U8(p, 0x6d); \
	WASM_U8(p, 0x01); \
	WASM_U8(p, 0x00); \
	WASM_U8(p, 0x00); \
	WASM_U8(p, 0x00)

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wshadow"

#define WASM_U32_PATCH(p, body)                      \
	do {                                             \
		uint8_t *__patch = p;                        \
		body;                                        \
		uint32_t __size = p - __patch;               \
		uint8_t __data[5];                           \
		uint32_t __len = u32_leb128(__size, __data); \
		memmove(__patch + __len, __patch, __size);   \
		memcpy(__patch, __data, __len);              \
		p += __len;                                  \
	} while (0)

#define WASM_SECTION(p, type, body) \
	WASM_U8(p, type);               \
	WASM_U32_PATCH(p, body)

int main() {
	uint8_t buf[1024];
	uint8_t *p = buf;

	WASM_MAGIC(p);

	// https://webassembly.github.io/spec/core/binary/modules.html#type-section
	WASM_SECTION(p, 0x1, {
		WASM_U32_1(p); // function types = vec(1)

		WASM_U8(p, 0x60); // function type 0
		WASM_U32_2(p);    // parameters = vec(2)
		WASM_U8(p, WASM_TYPE_I32);
		WASM_U8(p, WASM_TYPE_I32);
		WASM_U32_1(p); // results = vec(1)
		WASM_U8(p, WASM_TYPE_I32);
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-funcsec
	WASM_SECTION(p, 0x3, {
		WASM_U32_1(p); // functions = vec(1)
		WASM_U32_0(p); // function 0 = function type 0
	});

	// https://webassembly.github.=io/spec/core/binary/modules.html#binary-codesec
	WASM_SECTION(p, 0xA, {
		WASM_U32_1(p); // functions = vec(1)

		WASM_U32_PATCH(p, {
			WASM_U32_0(p);
			WASM_U8(p, 0x41); // i32.const
			WASM_I32(p, INT32_MAX);
			WASM_U8(p, 0x0B); // end
		});
	});

	write(1, buf, p - buf);
}
