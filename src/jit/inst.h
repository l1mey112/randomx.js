#pragma once

#include <stdint.h>

typedef struct rx_inst_t rx_inst_t;

struct rx_inst_t {
	uint8_t opcode;
	uint8_t dst;
	uint8_t src;
	uint8_t mod;
	uint32_t imm32;
};

#define MOD_MEM(x) (x & 3)
#define MOD_SHIFT(x) ((x >> 2) & 3)
#define MOD_COND(x) (x >> 4)

#define REGISTER_NEEDS_DISPLACEMENT 5 // x86 r13 register
#define REGISTER_NEEDS_SIB 4          // x86 r12 register
