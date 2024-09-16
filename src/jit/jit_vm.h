#pragma once

#include "freestanding.h"
#include "configuration.h"
#include "inst.h"

#include <stdbool.h>
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

typedef enum jit_inst_kind_t jit_inst_kind_t;
typedef struct jit_jump_desc_t jit_jump_desc_t;

struct jit_jump_desc_t {
	bool target;   // false if not a target, true if a target

	// supporting data for CBRANCH instructions
	uint32_t mask; // if (dst & mask) == 0, then branch
	uint64_t imm;  // dst += imm
};

void jit_vm_insts_decode(rx_inst_t insts[RANDOMX_PROGRAM_SIZE], jit_jump_desc_t jump_desc[RANDOMX_PROGRAM_SIZE]);
uint32_t jit_vm_insts(rx_inst_t insts[RANDOMX_PROGRAM_SIZE], jit_jump_desc_t jump_desc[RANDOMX_PROGRAM_SIZE], uint8_t *scratchpad, uint8_t *buf);

enum jit_inst_kind_t {
	IADD_RS,
	IADD_M,
	ISUB_R,
	ISUB_M,
	IMUL_R,
	IMUL_M,
	IMULH_R,
	IMULH_M,
	ISMULH_R,
	ISMULH_M,
	IMUL_RCP,
	INEG_R,
	IXOR_R,
	IXOR_M,
	IROR_R,
	IROL_R,
	ISWAP_R,
	FSWAP_R,
	FADD_R,
	FADD_M,
	FSUB_R,
	FSUB_M,
	FSCAL_R,
	FMUL_R,
	FDIV_M,
	FSQRT_R,
	CBRANCH,
	CFROUND,
	ISTORE,
	NOP,
};
