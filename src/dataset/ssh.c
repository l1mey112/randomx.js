#include "../blake2b/blake2b.h"
#include "configuration.h"
#include <stdbool.h>
#include <stdint.h>

#include "ssh_internal.h"
#include "wasm.h"

// instruction decoder hierachy:

// uOPs -> mOPs -> SuperscalarHash instructions
//  \       \       \ one or more mOPs
//   \       \ one or more uOPs
//    \ one or many possible ports

// Macro-operation as output of the x86 decoder
// Usually one macro-op = one x86 instruction, but 2 instructions are sometimes fused into 1 macro-op
// Macro-op can consist of 1 or 2 uOPs.
static const ss_mop_info_t mop_info[] = {
	{"sub_rr", 1, 3, UOP_P015, UOP_NULL},
	{"xor_rr", 1, 3, UOP_P015, UOP_NULL},
	{"lea_sib", 1, 4, UOP_P01, UOP_NULL},
	{"imul_rr", 3, 4, UOP_P1, UOP_NULL},
	{"ror_ri", 1, 4, UOP_P05, UOP_NULL},
	{"add_ri", 1, 7, UOP_P015, UOP_NULL},
	{"xor_ri", 1, 7, UOP_P015, UOP_NULL},
	{"mov_rr", 0, 3, UOP_NULL, UOP_NULL},
	{"mul_r", 4, 3, UOP_P1, UOP_P5},
	{"imul_r", 4, 3, UOP_P1, UOP_P5},
	{"mov_ri", 1, 10, UOP_P015, UOP_NULL},
};

static const ss_inst_info_t inst_info[] = {
#define A(...)                                                             \
	(sizeof((ss_mop_t[]){__VA_ARGS__}) / sizeof(ss_mop_t)), (ss_mop_t[]) { \
		__VA_ARGS__                                                        \
	}
	{"ISUB_R", A(MOP_SUB_RR), 0, 0, 0, false},
	{"IXOR_R", A(MOP_XOR_RR), 0, 0, 0, false},
	{"IADD_RS", A(MOP_LEA_SIB), 0, 0, 0, false},
	{"IMUL_R", A(MOP_IMUL_RR), 0, 0, 0, false},
	{"IROR_C", A(MOP_ROR_RI), -1, 0, 0, false},
	{"IADD_C7", A(MOP_ADD_RI), -1, 0, 0, false},
	{"IXOR_C7", A(MOP_XOR_RI), -1, 0, 0, false},
	{"IADD_C8", A(MOP_ADD_RI), -1, 0, 0, false},
	{"IXOR_C8", A(MOP_XOR_RI), -1, 0, 0, false},
	{"IADD_C9", A(MOP_ADD_RI), -1, 0, 0, false},
	{"IXOR_C9", A(MOP_XOR_RI), -1, 0, 0, false},
	{"IMULH_R", A(MOP_MOV_RR, MOP_MUL_R, MOP_MOV_RR), 1, 1, 0, false},
	{"ISMULH_R", A(MOP_MOV_RR, MOP_IMUL_R, MOP_MOV_RR), 1, 1, 0, false},
	{"IMUL_RCP", A(MOP_MOV_RI, MOP_IMUL_RR), -1, 1, 1, true},
#undef A
};

// these are some of the options how to split a 16-byte window into 3 or 4 x86 instructions.
// RandomX uses instructions with a native size of 3 (sub, xor, mul, mov), 4 (lea, mul), 7 (xor, add immediate) or 10 bytes (mov 64-bit immediate).
// Slots with sizes of 8 or 9 bytes need to be padded with a nop instruction.
static const decode_buffer_t buffers[GROUP_SIZE] = {
#define A(...)                                              \
	(sizeof((int[]){__VA_ARGS__}) / sizeof(int)), (int[]) { \
		__VA_ARGS__                                         \
	}
	{A(4, 8, 4)},
	{A(7, 3, 3, 3)},
	{A(3, 7, 3, 3)},
	{A(4, 9, 3)},
	{A(4, 4, 4, 4)},
	{A(3, 3, 10)},
#undef A
};

decode_group_t fetch_next(blake2b_generator_state *S, ss_inst_t kind, int cycle, int mul_count) {
	// If the current RandomX instruction is "IMULH", the next fetch configuration must be 3-3-10
	// because the full 128-bit multiplication instruction is 3 bytes long and decodes to 2 uOPs on Intel CPUs.
	// Intel CPUs can decode at most 4 uOPs per cycle, so this requires a 2-1-1 configuration for a total of 3 macro ops.
	if (kind == IMULH_R || kind == ISMULH_R) {
		return GROUP_5_3310;
	}

	// To make sure that the multiplication port is saturated, a 4-4-4-4 configuration is generated if the number of multiplications
	// is lower than the number of cycles.
	if (mul_count < cycle + 1) {
		return GROUP_4_4444;
	}

	// If the current RandomX instruction is "IMUL_RCP", the next buffer must begin with a 4-byte slot for multiplication.
	if (kind == IMUL_RCP) {
		return (blake2b_generator_u8(S) & 1) ? GROUP_0_484 : GROUP_3_493;
	}

	static const decode_group_t next_group[GROUP_SIZE] = {
		GROUP_0_484,
		GROUP_1_7333,
		GROUP_2_3733,
		GROUP_3_493,
	};

	return next_group[blake2b_generator_u8(S) & 3];
}

typedef struct ss_inst_desc_t ss_inst_desc_t;

struct ss_inst_desc_t {
	int src;
	int dst;
	int mod;
	uint32_t imm32;
	ss_inst_t kind;
	int op_group_par;
	bool can_reuse;
	bool group_par_is_source;
};

#define INST_DESC_INIT \
	{ -1, -1, 0, 0, INST_INVALID, 0, false, false }

ss_inst_desc_t create(blake2b_generator_state *S, ss_inst_t kind) {
}

ss_inst_desc_t create_for_slot(blake2b_generator_state *S, int slot_size, decode_group_t fetch_type, bool is_last, bool is_first) {

	static const ss_inst_t slot_3[] = {ISUB_R, IXOR_R};
	static const ss_inst_t slot_3L[] = {ISUB_R, IXOR_R, IMULH_R, ISMULH_R};
	static const ss_inst_t slot_4[] = {IROR_C, IADD_RS};
	static const ss_inst_t slot_7[] = {IXOR_C7, IADD_C7};
	static const ss_inst_t slot_8[] = {IXOR_C8, IADD_C8};
	static const ss_inst_t slot_9[] = {IXOR_C9, IADD_C9};
	static const ss_inst_t slot_10 = IMUL_RCP;

	switch (slot_size) {
	case 3:
		// if this is the last slot, we can also select "IMULH" instructions
		if (is_last) {
			return create(S, slot_3L[blake2b_generator_u8(S) & 3]);
		} else {
			return create(S, slot_3[blake2b_generator_u8(S) & 1]);
		}
	case 4:
		// if this is the 4-4-4-4 buffer, issue multiplications as the first 3 instructions
		if (fetch_type == GROUP_4_4444 && !is_last) {
			return create(S, IMUL_R);
		} else {
			return create(S, slot_4[blake2b_generator_u8(S) & 1]);
		}
	case 7:
		return create(S, slot_7[blake2b_generator_u8(S) & 1]);
	case 8:
		return create(S, slot_8[blake2b_generator_u8(S) & 1]);
	case 9:
		return create(S, slot_9[blake2b_generator_u8(S) & 1]);
	case 10:
		return create(S, slot_10);
	default:
		unreachable();
	}
}

void generate_superscalar(blake2b_generator_state *S) {
	bool ports_saturated = false;
	uint32_t program_size = 0;
	int mul_count = 0;
	decode_group_t group;
	ss_inst_desc_t current_instruction = {
		.kind = INST_INVALID,
	};

	int decode_cycle = 0;
	int cycle = 0;

	int macro_op_index = 0;

	for (; decode_cycle < RANDOMX_SUPERSCALAR_LATENCY && !ports_saturated && program_size < SUPERSCALAR_MAX_SIZE; decode_cycle++) {
		int buffer_idx = 0;

		group = fetch_next(S, current_instruction.kind, decode_cycle, mul_count);

		// fill all instruction slots in the current decode buffer
		while (buffer_idx < buffers[group].size) {
			int top_cycle = cycle;

			if (current_instruction.kind == INST_INVALID || macro_op_index >= inst_info[current_instruction.kind].mops_len) {
				if (ports_saturated || program_size >= SUPERSCALAR_MAX_SIZE) {
					break;
				}

				current_instruction = create_for_slot(S, buffers[group].slots[buffer_idx], group, buffers[group].size == buffer_idx + 1, buffer_idx == 0);
				macro_op_index = 0;
			}

			const ss_mop_t mop = inst_info[current_instruction.kind].mops[macro_op_index];
			
		}
	}
}
