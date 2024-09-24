#pragma once

#include "configuration.h"
#include "freestanding.h"
#include "inst.h"
#include "vm/vm.h"

#include <stdbool.h>
#include <stdint.h>

#if !PRODUCTION
#define FIDX(x) (x + 2) // e.d (superscalarhash), e.b (breakpoint)
#else
#define FIDX(x) (x + 1) // e.d (superscalarhash)
#endif

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
#define $MUL128HI FIDX(1)
#define $IMUL128HI FIDX(2)

typedef enum jit_inst_kind_t jit_inst_kind_t;
typedef struct jit_jump_desc_t jit_jump_desc_t;

struct jit_jump_desc_t {
	bool target; // false if not a target, true if a target

	// supporting data for CBRANCH instructions
	uint32_t mask; // if (dst & mask) == 0, then branch
	uint64_t imm;  // dst += imm
};

void jit_vm_insts_decode(rx_inst_t insts[RANDOMX_PROGRAM_SIZE], jit_jump_desc_t jump_desc[RANDOMX_PROGRAM_SIZE]);
uint32_t jit_vm_insts(rx_vm_t *VM, rx_inst_t insts[RANDOMX_PROGRAM_SIZE], jit_jump_desc_t jump_desc[RANDOMX_PROGRAM_SIZE], uint8_t *scratchpad, uint8_t *buf);

uint32_t prologue_load_registers(rx_vm_t *VM, uint8_t *buf);
uint32_t epilogue_store_registers(rx_vm_t *VM, uint8_t *buf);

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
