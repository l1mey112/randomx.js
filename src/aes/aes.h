#pragma once

#include <wasm_simd128.h>

// rx_set_int_vec_i128 or _mm_set_epi32 sets in little endian order
#define I32x2_MAKE_TRANSPOSE(k) I32x2_MAKE_TRANSPOSE_(k)
#define I32x2_MAKE_TRANSPOSE_(x, y, z, w) wasm_i32x4_make(w, z, y, x)

v128_t soft_aesenc(v128_t in, v128_t key);
v128_t soft_aesdec(v128_t in, v128_t key);

void fillAes1Rx4(const uint8_t state[64], uint32_t output_size, uint8_t *buffer);
void fillAes4Rx4(const uint8_t state[64], uint32_t output_size, uint8_t *buffer);
void hashAes1Rx4(const void *input, uint32_t input_size, uint8_t hash[64]);
