#pragma once

#include "wasm.h"

#include <stdint.h>

uint32_t i64_leb128(int64_t val, uint8_t data[10]);
uint32_t u32_leb128(uint32_t val, uint8_t data[5]);

#define WASM_U8(v)  \
	do {            \
		*p++ = (v); \
	} while (0)

// uleb128
#define WASM_U32(v)            \
	do {                       \
		p += u32_leb128(v, p); \
	} while (0)

// sleb128
#define WASM_I64(v)            \
	do {                       \
		p += i64_leb128(v, p); \
	} while (0)

#define WASM_I32(v)           \
	do {                      \
		WASM_I64((int32_t)v); \
	} while (0)

// >127 means 2+ bytes
#define WASM_U32_0() WASM_U8(0x00)  // 00
#define WASM_U32_1() WASM_U8(0x01)  // 01
#define WASM_U32_2() WASM_U8(0x02)  // 02
#define WASM_U32_3() WASM_U8(0x03)  // 03
#define WASM_U32_4() WASM_U8(0x04)  // 04
#define WASM_U32_5() WASM_U8(0x05)  // 05
#define WASM_U32_6() WASM_U8(0x06)  // 06
#define WASM_U32_7() WASM_U8(0x07)  // 07
#define WASM_U32_8() WASM_U8(0x08)  // 08
#define WASM_U32_9() WASM_U8(0x09)  // 09
#define WASM_U32_10() WASM_U8(0x0a) // 0a
#define WASM_U32_11() WASM_U8(0x0b) // 0b
#define WASM_U32_12() WASM_U8(0x0c) // 0c

#define WASM_TYPE_I32 0x7f
#define WASM_TYPE_I64 0x7e
#define WASM_TYPE_F32 0x7d
#define WASM_TYPE_F64 0x7c
#define WASM_TYPE_V128 0x7b

// WASM_BINARY_MAGIC, WASM_BINARY_VERSION
// 0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00
#define WASM_MAGIC() \
	WASM_U8(0x00);   \
	WASM_U8(0x61);   \
	WASM_U8(0x73);   \
	WASM_U8(0x6d);   \
	WASM_U8(0x01);   \
	WASM_U8(0x00);   \
	WASM_U8(0x00);   \
	WASM_U8(0x00)

#define _IGNORE_SHADOW_BEGIN _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wshadow\"")
#define _IGNORE_SHADOW_END _Pragma("clang diagnostic pop")

#define WASM_U32_PATCH(...)                          \
	do {                                             \
		_IGNORE_SHADOW_BEGIN                         \
		uint8_t *__patch = p;                        \
		_IGNORE_SHADOW_END                           \
		__VA_ARGS__;                                 \
		_IGNORE_SHADOW_BEGIN                         \
		uint32_t __size = p - __patch;               \
		uint8_t __data[5];                           \
		uint32_t __len = u32_leb128(__size, __data); \
		memmove(__patch + __len, __patch, __size);   \
		memcpy(__patch, __data, __len);              \
		_IGNORE_SHADOW_END                           \
		p += __len;                                  \
	} while (0)

#define WASM_SECTION(type, ...) \
	WASM_U8(type);              \
	WASM_U32_PATCH(__VA_ARGS__)

#define WASM_SECTION_CUSTOM 0x00
#define WASM_SECTION_TYPE 0x01
#define WASM_SECTION_IMPORT 0x02
#define WASM_SECTION_FUNCTION 0x03
#define WASM_SECTION_TABLE 0x04
#define WASM_SECTION_MEMORY 0x05
#define WASM_SECTION_GLOBAL 0x06
#define WASM_SECTION_EXPORT 0x07
#define WASM_SECTION_START 0x08
#define WASM_SECTION_ELEMENT 0x09
#define WASM_SECTION_CODE 0x0A
#define WASM_SECTION_DATA 0x0B
#define WASM_SECTION_DATACOUNT 0x0C

// memcpy the WASM_THUNK({ 0x00, 0x00, 0x00, 0x00 }) to the end of the function
#define WASM_U8_THUNK(...)                                             \
	memcpy(p, (uint8_t[])__VA_ARGS__, sizeof((uint8_t[])__VA_ARGS__)); \
	p += sizeof((uint8_t[])__VA_ARGS__)
