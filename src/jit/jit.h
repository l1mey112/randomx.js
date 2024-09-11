#include "ssh.h"
#include "configuration.h"
#include <stdint.h>

// export type Feature =
//     | 0 // JS + WASM + SIMD + BULK MEMORY
//     | 1 // JS + WASM + SIMD + BULK MEMORY + WORKING FMA

uint32_t jit_ssh(ss_program_t prog[RANDOMX_CACHE_ACCESSES], uint8_t *cache_ptr, uint8_t *buf);
uint64_t jit_reciprocal(uint32_t divisor);

#define POWER_OF_ZERO_OR_TWO(x) ((x & (x - 1)) == 0)
