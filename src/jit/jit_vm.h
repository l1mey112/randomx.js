#pragma once

#include "inst.h"
#include "vm/vm.h"

#include <stdint.h>

// locals
#define R(i) (0 + (i))
#define F(i) (8 + (i))
#define E(i) (12 + (i))
#define $sp_addr0 16
#define $sp_addr1 17
#define $mx 18
#define $ma 19
#define $tmp 20
#define $ic 21
#define $tmp64 22
#define $mask_mant 23
#define $mask_exp 24

// globals
#define $fprc 0

// functions
#define $MUL128HI 2
#define $IMUL128HI 3

#define INST_JIT_PARAMS __attribute__((unused)) rx_vm_t *VM, const rx_inst_t *inst, uint8_t *scratchpad, int register_usage[8], int i, uint8_t *buf

uint32_t jit_vm_inst(INST_JIT_PARAMS);
