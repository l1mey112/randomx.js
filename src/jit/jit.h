#pragma once

#include "configuration.h"
#include "ssh.h"
#include "vm/vm.h"

#include <stdint.h>

uint32_t jit_ssh(ss_program_t prog[RANDOMX_CACHE_ACCESSES], uint8_t *cache_ptr, uint8_t *buf);
uint32_t jit_vm(rx_vm_t *VM, rx_program_t *P, uint8_t *scratchpad, uint8_t *buf);

typedef enum jit_feature_t jit_feature_t;

extern jit_feature_t jit_feature;

// synonymous with `Feature` in `src/detect/detect.ts`
enum jit_feature_t {
	JIT_BASELINE = 0,     // SIMD and bulk memory instructions
	JIT_RELAXED_SIMD = 1, // relaxed SIMD instructions
	JIT_FMA = 2,          // working fused multiply-add (assumes JIT_RELAXED_SIMD)
};

uint64_t jit_reciprocal(uint32_t divisor);

#define POWER_OF_ZERO_OR_TWO(x) ((x & (x - 1)) == 0)

// WASM is always a two's complement machine, we can just cast
#define IMM_SEXT64(x) ((int64_t)(int32_t)(x))
