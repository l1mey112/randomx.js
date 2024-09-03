#pragma once

#include <wasm_simd128.h>

v128_t soft_aesenc(v128_t in, v128_t key);
v128_t soft_aesdec(v128_t in, v128_t key);

void fillAes1Rx4(const uint8_t state[64], uint32_t output_size, uint8_t *buffer);
void fillAes4Rx4(const uint8_t state[64], uint32_t output_size, uint8_t *buffer);
