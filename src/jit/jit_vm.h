#pragma once

#include "inst.h"
#include "vm/vm.h"

#include <stdint.h>

// locals
#define R(i) (0 + (i))
#define F(i) (8 + (i))
#define E(i) (12 + (i))
#define A(i) (16 + (i))
#define $sp_addr0 20
#define $sp_addr1 21
#define $mx 22
#define $ma 23
#define $tmp 24
#define $ic 25
#define $tmp64 26
#define $mask_mant 27
#define $mask_exp 28

// globals
#define $fprc 0

// functions
#define $MUL128HI 2
#define $IMUL128HI 3

#define INST_JIT_PARAMS __attribute__((unused)) rx_vm_t *VM, const rx_inst_t *inst, uint8_t *scratchpad, int register_usage[8], int i, uint8_t *buf

uint32_t jit_vm_inst(INST_JIT_PARAMS);
