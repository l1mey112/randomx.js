#pragma once

#include "wasm.h"

#include <stdint.h>
#include <string.h>

#define alignas _Alignas

/* static inline uint32_t load32(const void *src) {
	return *(uint32_t *)src;
}

static inline uint64_t load64(const void *src) {
	return *(uint64_t *)src;
}

static inline uint16_t load16(const void *src) {
	return *(uint16_t *)src;
}

static inline void store16(void *dst, uint16_t w) {
	*(uint16_t *)dst = w;
}

static inline void store32(void *dst, uint32_t w) {
	*(uint32_t *)dst = w;
}

static inline void store64(void *dst, uint64_t w) {
	*(uint64_t *)dst = w;
}

static inline uint64_t load48(const void *src) {
	const uint8_t *p = (const uint8_t *)src;
	return ((uint64_t)(p[0]) << 0) |
	       ((uint64_t)(p[1]) << 8) |
	       ((uint64_t)(p[2]) << 16) |
	       ((uint64_t)(p[3]) << 24) |
	       ((uint64_t)(p[4]) << 32) |
	       ((uint64_t)(p[5]) << 40);
}

static inline void store48(void *dst, uint64_t w) {
	uint8_t *p = (uint8_t *)dst;
	p[0] = (uint8_t)(w >> 0);
	p[1] = (uint8_t)(w >> 8);
	p[2] = (uint8_t)(w >> 16);
	p[3] = (uint8_t)(w >> 24);
	p[4] = (uint8_t)(w >> 32);
	p[5] = (uint8_t)(w >> 40);
}

static inline uint32_t rotr32(const uint32_t w, const unsigned c) {
	return (w >> c) | (w << (32 - c));
}

static inline uint64_t rotr64(const uint64_t w, const unsigned c) {
	return (w >> c) | (w << (64 - c));
}
 */