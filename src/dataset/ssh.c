#include "../blake2b/blake2b.h"
#include "configuration.h"
#include <stdbool.h>
#include <stdint.h>

#include "ssh.h"
#include "ssh_internal.h"
#include "wasm.h"

#define CYCLE_MAP_SIZE (RANDOMX_SUPERSCALAR_LATENCY + 4)
#define LOOK_FORWARD_CYCLES 4
#define MAX_THROWAWAY_COUNT 256

#define RegistersCount 8
#define RegisterCountFlt (RegistersCount / 2)
#define RegisterNeedsDisplacement 5 // x86 r13 register
#define RegisterNeedsSib 4          // x86 r12 register

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
static const decode_buffer_t decode_buffer[GROUP_SIZE] = {
#define A(...)                                              \
	(sizeof((int[]){__VA_ARGS__}) / sizeof(int)), (int[]) { \
		__VA_ARGS__                                         \
	}
	{"4,8,4", A(4, 8, 4)},
	{"7,3,3,3", A(7, 3, 3, 3)},
	{"3,7,3,3", A(3, 7, 3, 3)},
	{"4,9,3", A(4, 9, 3)},
	{"4,4,4,4", A(4, 4, 4, 4)},
	{"3,3,10", A(3, 3, 10)},
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

static inline bool is_zero_or_power_of_2(uint64_t x) {
	return (x & (x - 1)) == 0;
}

static bool is_mul(ss_inst_t kind) {
	switch (kind) {
	case IMUL_R:
	case IMULH_R:
	case ISMULH_R:
	case IMUL_RCP:
		return true;
	default:
		return false;
	}
}

ss_inst_desc_t create(blake2b_generator_state *S, ss_inst_t kind) {
	ss_inst_desc_t desc = { -1, -1, 0, 0, INST_INVALID, INST_INVALID, 0, false, false };
	desc.kind = kind;

	switch (kind) {
	case ISUB_R:
		desc.op_group = IADD_RS;
		desc.group_par_is_source = true;
		break;
	case IXOR_R:
		desc.op_group = IXOR_R;
		desc.group_par_is_source = true;
		break;
	case IADD_RS:
		desc.mod = blake2b_generator_u8(S);
		desc.op_group = IADD_RS;
		desc.group_par_is_source = true;
		break;
	case IMUL_R:
		desc.op_group = IMUL_R;
		desc.group_par_is_source = true;
		break;
	case IROR_C:
		do {
			desc.imm32 = blake2b_generator_u8(S) & 63;
		} while (desc.imm32 == 0);
		desc.op_group = IROR_C;
		desc.group_par_is_source = true;
		desc.op_group_par = -1;
		break;
	case IADD_C7:
	case IADD_C8:
	case IADD_C9:
		desc.imm32 = blake2b_generator_u32(S);
		desc.op_group = IADD_C7;
		desc.op_group_par = -1;
		break;
	case IXOR_C7:
	case IXOR_C8:
	case IXOR_C9:
		desc.imm32 = blake2b_generator_u32(S);
		desc.op_group = IXOR_C7;
		desc.op_group_par = -1;
		break;
	case IMULH_R:
		desc.op_group = IMULH_R;
		desc.op_group_par = blake2b_generator_u32(S);
		desc.can_reuse = true;
	case ISMULH_R:
		desc.op_group = ISMULH_R;
		desc.op_group_par = blake2b_generator_u32(S);
		desc.can_reuse = true;
		break;
	case IMUL_RCP:
		do {
			desc.imm32 = blake2b_generator_u32(S);
		} while (is_zero_or_power_of_2(desc.imm32));
		desc.op_group = IMUL_RCP;
		desc.op_group_par = -1;
		break;
	default:
		unreachable();
	}

	return desc;
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

bool inst_select_register(blake2b_generator_state *S, int *available_registers, int available_register_count, int *reg_out) {
	int index;

	if (available_register_count == 0) {
		return false;
	}

	if (available_register_count > 1) {
		index = blake2b_generator_u32(S) % available_register_count;
	} else {
		index = 0;
	}

	*reg_out = available_registers[index];
	return true;
}

bool inst_select_source(blake2b_generator_state *S, ss_inst_desc_t *inst, int cycle, ss_reginfo_t registers[8]) {
	int available_registers[8];
	int available_count = 0;

	for (int i = 0; i < 8; i++) {
		if (registers[i].latency <= cycle) {
			available_registers[available_count++] = i;
		}
	}

	// if there are only 2 available registers for IADD_RS and one of them is r5, select it as the source because it cannot be the destination
	if (available_count == 2 && inst->kind == IADD_RS) {
		if (available_registers[0] == RegisterNeedsDisplacement || available_registers[1] == RegisterNeedsDisplacement) {
			inst->op_group_par = inst->src = RegisterNeedsDisplacement;
			return true;
		}
	}
	if (inst_select_register(S, available_registers, available_count, &inst->src)) {
		if (inst->group_par_is_source) {
			inst->op_group_par = inst->src;
		}
		return true;
	}
	return false;
}

bool inst_select_destination(blake2b_generator_state *S, ss_inst_desc_t *inst, int cycle, bool allow_chained_mul, ss_reginfo_t registers[8]) {
	int available_registers[8];
	int available_count = 0;

	// Conditions for the destination register:
	//  * value must be ready at the required cycle
	//  * cannot be the same as the source register unless the instruction allows it
	//    - this avoids optimizable instructions such as "xor r, r" or "sub r, r"
	//  * register cannot be multiplied twice in a row unless allowChainedMul is true
	//    - this avoids accumulation of trailing zeroes in registers due to excessive multiplication
	//    - allowChainedMul is set to true if an attempt to find source/destination registers failed (this is quite rare, but prevents a catastrophic failure of the generator)
	//  * either the last instruction applied to the register or its source must be different than this instruction
	//    - this avoids optimizable instruction sequences such as "xor r1, r2; xor r1, r2" or "ror r, C1; ror r, C2" or "add r, C1; add r, C2"
	//  * register r5 cannot be the destination of the IADD_RS instruction (limitation of the x86 lea instruction)
	for (int i = 0; i < 8; i++) {
		bool ready = registers[i].latency <= cycle;
		bool different_src = i != inst->src;
		bool not_chained_mul = allow_chained_mul || inst->op_group != IMUL_R || registers[i].last_op_group != IMUL_R;
		bool different_last_op = registers[i].last_op_group != inst->op_group || registers[i].last_op_par != inst->op_group_par;
		bool not_r5 = inst->kind != IADD_RS || i != RegisterNeedsDisplacement;

		if (ready && different_src && not_chained_mul && different_last_op && not_r5) {
			available_registers[available_count++] = i;
		}
	}

	return inst_select_register(S, available_registers, available_count, &inst->dst);
}

int schedule_uop(bool commit, ss_uop_t uop, ss_uop_t port_busy[CYCLE_MAP_SIZE][3], int cycle) {
	// The scheduling here is done optimistically by checking port availability in order P5 -> P0 -> P1 to not overload
	// port P1 (multiplication) by instructions that can go to any port.
	for (; cycle < CYCLE_MAP_SIZE; ++cycle) {
		if ((uop & UOP_P5) != 0 && !port_busy[cycle][2]) {
			if (commit) {
				port_busy[cycle][2] = uop;
			}
			return cycle;
		}
		if ((uop & UOP_P0) != 0 && !port_busy[cycle][0]) {
			if (commit) {
				port_busy[cycle][0] = uop;
			}
			return cycle;
		}
		if ((uop & UOP_P1) != 0 && !port_busy[cycle][1]) {
			if (commit) {
				port_busy[cycle][1] = uop;
			}
			return cycle;
		}
	}
	return -1;
}

int schedule_mop(bool commit, ss_mop_t mop, bool is_dependent, ss_uop_t port_busy[CYCLE_MAP_SIZE][3], int cycle, int dep_cycle) {
	// if this macro-op depends on the previous one, increase the starting cycle if needed
	// this handles an explicit dependency chain in IMUL_RCP
	if (is_dependent) {
		cycle = cycle > dep_cycle ? cycle : dep_cycle;
	}
	// move instructions are eliminated and don't need an execution unit
	if (mop_info[mop].uop0 == UOP_NULL) {
		return cycle;
	}
	// this macro-op has only one uOP
	else if (mop_info[mop].uop1 == UOP_NULL) {
		return schedule_uop(commit, mop_info[mop].uop0, port_busy, cycle);
	} else {
		// macro-ops with 2 uOPs are scheduled conservatively by requiring both uOPs to execute in the same cycle
		for (; cycle < CYCLE_MAP_SIZE; ++cycle) {
			int cycle1 = schedule_uop(false, mop_info[mop].uop0, port_busy, cycle);
			int cycle2 = schedule_uop(false, mop_info[mop].uop1, port_busy, cycle);

			if (cycle1 >= 0 && cycle1 == cycle2) {
				if (commit) {
					schedule_uop(true, mop_info[mop].uop0, port_busy, cycle1);
					schedule_uop(true, mop_info[mop].uop1, port_busy, cycle2);
				}
				return cycle1;
			}
		}
	}

	return -1;
}

void ssh_generate(blake2b_generator_state *S, ss_program_t *prog) {

	ss_uop_t port_busy[CYCLE_MAP_SIZE][3] = {};
	ss_reginfo_t registers[8];

	for (int i = 0; i < 8; i++) {
		registers[i] = (ss_reginfo_t){ 0, INST_INVALID, -1, 0 };
	}

	decode_group_t group;
	ss_inst_desc_t inst = {
		.kind  = INST_INVALID,
		.op_group = INST_INVALID,
	};

	bool ports_saturated = false;

	int cycle = 0;
	int dep_cycle = 0;
	int retire_cycle = 0;
	int decode_cycle = 0;

	int throw_away_count = 0;

	int code_size = 0;
	int program_size = 0;

	int macro_op_index = 0;
	int macro_op_count = 0;
	int mul_count = 0;

	for (; decode_cycle < RANDOMX_SUPERSCALAR_LATENCY && !ports_saturated && program_size < SUPERSCALAR_MAX_SIZE; decode_cycle++) {
		int buffer_idx = 0;

		group = fetch_next(S, inst.kind, decode_cycle, mul_count);

		printf("; ------------- fetch cycle %d (%s)\n", cycle, decode_buffer[group].name);

		// fill all instruction slots in the current decode buffer
		while (buffer_idx < decode_buffer[group].size) {
			int top_cycle = cycle;
			bool is_last = decode_buffer[group].size == buffer_idx + 1;

			// if we have issued all macro-ops for the current RandomX instruction, create a new instruction
			if (inst.op_group == INST_INVALID || macro_op_index >= inst_info[inst.kind].mops_len) {
				if (ports_saturated || program_size >= SUPERSCALAR_MAX_SIZE) {
					break;
				}

				inst = create_for_slot(S, decode_buffer[group].slots[buffer_idx], group, is_last, buffer_idx == 0);
				macro_op_index = 0;
				printf("; %s\n", inst_info[inst.kind].name);
			}

			ss_mop_t mop = inst_info[inst.kind].mops[macro_op_index];
			bool mop_dependent = is_last && inst_info[inst.kind].final_mop_dependent;
			printf("%s ", mop_info[mop].name);

			// calculate the earliest cycle when this macro-op (all of its uOPs) can be scheduled for execution
			int schedule_cycle = schedule_mop(false, mop, mop_dependent, port_busy, cycle, dep_cycle);
			if (schedule_cycle < 0) {
				printf("; Unable to map operation '%s' to execution port (cycle %d)\n", mop_info[mop].name, cycle);
				ports_saturated = true;
				break;
			}

			// find a source register (if applicable) that will be ready when this instruction executes
			if (macro_op_index == inst_info[inst.kind].src_op) {
				int forward;
				// if no suitable operand is ready, look up to LOOK_FORWARD_CYCLES forward
				for (forward = 0; forward < LOOK_FORWARD_CYCLES && !inst_select_source(S, &inst, schedule_cycle, registers); forward++) {
					printf("; src STALL at cycle %d\n", cycle);
					schedule_cycle++;
					cycle++;
				}
				// if no register was found, throw the instruction away and try another one
				if (forward == LOOK_FORWARD_CYCLES) {
					if (throw_away_count < MAX_THROWAWAY_COUNT) {
						throw_away_count++;
						macro_op_index = inst_info[inst.kind].mops_len;
						printf("; THROW away %s\n", inst_info[inst.kind].name);
						continue;
					}
					printf("; Aborting at cycle %d with decode buffer %s - source registers not available for operation %s\n", cycle, decode_buffer[group].name, inst_info[inst.kind].name);
					inst.kind = inst.op_group = INST_INVALID;
					break;
				}
				printf("; src = r%d\n", inst.src);
			}
			// find a destination register that will be ready when this instruction executes
			if (macro_op_index == inst_info[inst.kind].dst_op) {
				int forward;
				for (forward = 0; forward < LOOK_FORWARD_CYCLES && !inst_select_destination(S, &inst, schedule_cycle, throw_away_count > 0, registers); forward++) {
					printf("; dst STALL at cycle %d\n", cycle);
					schedule_cycle++;
					cycle++;
				}

				if (forward == LOOK_FORWARD_CYCLES) {
					if (throw_away_count < MAX_THROWAWAY_COUNT) {
						throw_away_count++;
						macro_op_index = inst_info[inst.kind].mops_len;
						printf("; THROW away %s\n", inst_info[inst.kind].name);
						continue;
					}
					printf("; Aborting at cycle %d with decode buffer %s - destination registers not available\n", cycle, decode_buffer[group].name);
					inst.kind = inst.op_group = INST_INVALID;
					break;
				}
				printf("; dst = r%d\n", inst.dst);
			}

			throw_away_count = 0;

			// recalculate when the instruction can be scheduled for execution based on operand availability
			schedule_cycle = schedule_mop(true, mop, mop_dependent, port_busy, schedule_cycle, schedule_cycle);

			if (schedule_cycle < 0) {
				printf("; Unable to map operation '%s' to execution port (cycle %d)\n", mop_info[mop].name, cycle);
				ports_saturated = true;
				break;
			}

			// calculate when the result will be ready
			dep_cycle = schedule_cycle + mop_info[mop].latency;

			// if this instruction writes the result, modify register information
			//   RegisterInfo.latency - which cycle the register will be ready
			//   RegisterInfo.lastOpGroup - the last operation that was applied to the register
			//   RegisterInfo.lastOpPar - the last operation source value (-1 = constant, 0-7 = register)
			if (macro_op_index == inst_info[inst.kind].result_op) {
				ss_reginfo_t *reg = &registers[inst.dst];
				retire_cycle = dep_cycle;
				reg->latency = retire_cycle;
				reg->last_op_group = inst.op_group;
				reg->last_op_par = inst.op_group_par;
				printf("; RETIRED at cycle %d\n", retire_cycle);
			}

			code_size += mop_info[mop].size;
			buffer_idx++;
			macro_op_index++;
			macro_op_count++;

			// terminating condition
			if (schedule_cycle >= RANDOMX_SUPERSCALAR_LATENCY) {
				ports_saturated = true;
			}
			cycle = top_cycle;

			// when all macro-ops of the current instruction have been issued, add the instruction into the program
			if (macro_op_index >= inst_info[inst.kind].mops_len) {
				prog->instructions[program_size++] = inst;
				mul_count += is_mul(inst.kind);
			}
		}
		cycle++;
	}

	double ipc = (double)macro_op_count / decode_cycle;
	memset(prog->asic_latencies, 0, sizeof(prog->asic_latencies));

	// Calculate ASIC latency:
	// Assumes 1 cycle latency for all operations and unlimited parallelization.
	for (int i = 0; i < program_size; i++) {
		ss_inst_desc_t *instr = &prog->instructions[i];
		int lat_dst = prog->asic_latencies[instr->dst] + 1;
		int lat_src = instr->dst != instr->src ? prog->asic_latencies[instr->src] + 1 : 0;
		prog->asic_latencies[instr->dst] = lat_dst > lat_src ? lat_dst : lat_src;
	}

	// address register is the register with the highest ASIC latency
	int asic_latency = 0;
	int address_reg = 0;
	for (int i = 0; i < 8; i++) {
		if (prog->asic_latencies[i] > asic_latency) {
			asic_latency = prog->asic_latencies[i];
			address_reg = i;
		}
		prog->cpu_latencies[i] = registers[i].latency;
	}

	prog->size = program_size;
	prog->addr_reg = address_reg;

	prog->cpu_latency = retire_cycle;
	prog->asic_latency = asic_latency;
	prog->code_size = code_size;
	prog->macro_ops = macro_op_count;
	prog->decode_cycles = decode_cycle;
	prog->ipc = ipc;
	prog->mul_count = mul_count;
}
