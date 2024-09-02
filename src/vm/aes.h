#pragma once

#include <wasm_simd128.h>

v128_t soft_aesenc(v128_t in, v128_t key);
v128_t soft_aesdec(v128_t in, v128_t key);
