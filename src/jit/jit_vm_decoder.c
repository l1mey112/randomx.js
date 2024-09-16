#include "configuration.h"
#include "freestanding.h"
#include "inst.h"
#include "jit.h"
#include "jit_vm.h"
#include "vm/vm.h"

#include <stdint.h>

#define OPCODE_CEIL_DECLARE(curr, prev) static const int ceil_##curr = ceil_##prev + RANDOMX_FREQ_##curr;
static const int ceil_NULL = 0;
OPCODE_CEIL_DECLARE(IADD_RS, NULL);
OPCODE_CEIL_DECLARE(IADD_M, IADD_RS);
OPCODE_CEIL_DECLARE(ISUB_R, IADD_M);
OPCODE_CEIL_DECLARE(ISUB_M, ISUB_R);
OPCODE_CEIL_DECLARE(IMUL_R, ISUB_M);
OPCODE_CEIL_DECLARE(IMUL_M, IMUL_R);
OPCODE_CEIL_DECLARE(IMULH_R, IMUL_M);
OPCODE_CEIL_DECLARE(IMULH_M, IMULH_R);
OPCODE_CEIL_DECLARE(ISMULH_R, IMULH_M);
OPCODE_CEIL_DECLARE(ISMULH_M, ISMULH_R);
OPCODE_CEIL_DECLARE(IMUL_RCP, ISMULH_M);
OPCODE_CEIL_DECLARE(INEG_R, IMUL_RCP);
OPCODE_CEIL_DECLARE(IXOR_R, INEG_R);
OPCODE_CEIL_DECLARE(IXOR_M, IXOR_R);
OPCODE_CEIL_DECLARE(IROR_R, IXOR_M);
OPCODE_CEIL_DECLARE(IROL_R, IROR_R);
OPCODE_CEIL_DECLARE(ISWAP_R, IROL_R);
OPCODE_CEIL_DECLARE(FSWAP_R, ISWAP_R);
OPCODE_CEIL_DECLARE(FADD_R, FSWAP_R);
OPCODE_CEIL_DECLARE(FADD_M, FADD_R);
OPCODE_CEIL_DECLARE(FSUB_R, FADD_M);
OPCODE_CEIL_DECLARE(FSUB_M, FSUB_R);
OPCODE_CEIL_DECLARE(FSCAL_R, FSUB_M);
OPCODE_CEIL_DECLARE(FMUL_R, FSCAL_R);
OPCODE_CEIL_DECLARE(FDIV_M, FMUL_R);
OPCODE_CEIL_DECLARE(FSQRT_R, FDIV_M);
OPCODE_CEIL_DECLARE(CBRANCH, FSQRT_R);
OPCODE_CEIL_DECLARE(CFROUND, CBRANCH);
OPCODE_CEIL_DECLARE(ISTORE, CFROUND);
#undef OPCODE_CEIL_DECLARE

void jit_vm_insts_decode(rx_inst_t insts[RANDOMX_PROGRAM_SIZE], jit_jump_desc_t jump_desc[RANDOMX_PROGRAM_SIZE]) {
	int register_usage[8] = {-1, -1, -1, -1, -1, -1, -1, -1};

	memset(jump_desc, 0, sizeof(jit_jump_desc_t) * RANDOMX_PROGRAM_SIZE);

	for (int pc = 0; pc < RANDOMX_PROGRAM_SIZE; pc++) {
		rx_inst_t *inst = &insts[pc];

		int opcode = inst->opcode;

		if (opcode < ceil_IADD_RS) {
			inst->opcode = IADD_RS;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IADD_M) {
			inst->opcode = IADD_M;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_ISUB_R) {
			inst->opcode = ISUB_R;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_ISUB_M) {
			inst->opcode = ISUB_M;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IMUL_R) {
			inst->opcode = IMUL_R;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IMUL_M) {
			inst->opcode = IMUL_M;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IMULH_R) {
			inst->opcode = IMULH_R;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IMULH_M) {
			inst->opcode = IMULH_M;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_ISMULH_R) {
			inst->opcode = ISMULH_R;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_ISMULH_M) {
			inst->opcode = ISMULH_M;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IMUL_RCP) {
			uint32_t divisor = inst->imm32;

			if (POWER_OF_ZERO_OR_TWO(divisor)) {
				inst->opcode = NOP;
			} else {
				inst->opcode = IMUL_RCP;
				inst->dst %= 8;
				register_usage[inst->dst] = pc;
			}
			continue;
		}

		if (opcode < ceil_INEG_R) {
			inst->opcode = INEG_R;
			inst->dst %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IXOR_R) {
			inst->opcode = IXOR_R;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IXOR_M) {
			inst->opcode = IXOR_M;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IROR_R) {
			inst->opcode = IROR_R;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_IROL_R) {
			inst->opcode = IROL_R;
			inst->dst %= 8;
			inst->src %= 8;

			register_usage[inst->dst] = pc;
			continue;
		}

		if (opcode < ceil_ISWAP_R) {
			inst->dst %= 8;
			inst->src %= 8;

			if (inst->src == inst->dst) {
				inst->opcode = NOP;
			} else {
				inst->opcode = ISWAP_R;

				register_usage[inst->dst] = pc;
				register_usage[inst->src] = pc;
			}
			continue;
		}

		if (opcode < ceil_FSWAP_R) {
			inst->opcode = FSWAP_R;
			inst->dst %= 8;
			continue;
		}

		if (opcode < ceil_FADD_R) {
			inst->opcode = FADD_R;
			inst->dst %= 4;
			inst->src %= 4;
			continue;
		}

		if (opcode < ceil_FADD_M) {
			inst->opcode = FADD_M;
			inst->dst %= 4;
			inst->src %= 8;
			continue;
		}

		if (opcode < ceil_FSUB_R) {
			inst->opcode = FSUB_R;
			inst->dst %= 4;
			inst->src %= 4;
			continue;
		}

		if (opcode < ceil_FSUB_M) {
			inst->opcode = FSUB_M;
			inst->dst %= 4;
			inst->src %= 8;
			continue;
		}

		if (opcode < ceil_FSCAL_R) {
			inst->opcode = FSCAL_R;
			inst->dst %= 4;
			continue;
		}

		if (opcode < ceil_FMUL_R) {
			inst->opcode = FMUL_R;
			inst->dst %= 4;
			inst->src %= 4;
			continue;
		}

		if (opcode < ceil_FDIV_M) {
			inst->opcode = FDIV_M;
			inst->dst %= 4;
			inst->src %= 8;
			continue;
		}

		if (opcode < ceil_FSQRT_R) {
			inst->opcode = FSQRT_R;
			inst->dst %= 4;
			continue;
		}

		if (opcode < ceil_CBRANCH) {
			inst->opcode = CBRANCH;
			inst->dst %= 8;
			int b = MOD_COND(inst->mod) + RANDOMX_JUMP_OFFSET;

			uint64_t imm = IMM_SEXT64(inst->imm32) | (1ULL << b);
			if (RANDOMX_JUMP_OFFSET > 0 || b > 0) {
				imm &= ~(1ULL << (b - 1));
			}

			uint32_t mask = ((1 << RANDOMX_JUMP_BITS) - 1) << b;
			int target = register_usage[inst->dst] + 1; // -1 + 1 = 0

			jump_desc[target].target = true; // branch target
			// set supporting data
			jump_desc[pc].imm = imm;
			jump_desc[pc].mask = mask;

			// mark all registers as used
			for (int i = 0; i < 8; i++) {
				register_usage[i] = pc;
			}
			continue;
		}

		if (opcode < ceil_CFROUND) {
			inst->opcode = CFROUND;
			inst->src %= 8;
			continue;
		}

		if (opcode < ceil_ISTORE) {
			inst->opcode = ISTORE;
			inst->dst %= 8;
			inst->src %= 8;
			continue;
		}

		inst->opcode = NOP;
	}
}
