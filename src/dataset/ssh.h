#pragma once

#include <stdint.h>
#include <stdbool.h>

#include "configuration.h"
#include "../blake2b/blake2b.h"

typedef struct ss_program_t ss_program_t;
typedef struct ss_inst_desc_t ss_inst_desc_t;
typedef enum ss_inst_t ss_inst_t;

//                  Intel Ivy Bridge reference
enum ss_inst_t {   // uOPs (decode)   execution ports         latency       code size
	ISUB_R = 0,    // 1               p015                    1               3 (sub)
	IXOR_R = 1,    // 1               p015                    1               3 (xor)
	IADD_RS = 2,   // 1               p01                     1               4 (lea)
	IMUL_R = 3,    // 1               p1                      3               4 (imul)
	IROR_C = 4,    // 1               p05                     1               4 (ror)
	IADD_C7 = 5,   // 1               p015                    1               7 (add)
	IXOR_C7 = 6,   // 1               p015                    1               7 (xor)
	IADD_C8 = 7,   // 1+0             p015                    1               7+1 (add+nop)
	IXOR_C8 = 8,   // 1+0             p015                    1               7+1 (xor+nop)
	IADD_C9 = 9,   // 1+0             p015                    1               7+2 (add+nop)
	IXOR_C9 = 10,  // 1+0             p015                    1               7+2 (xor+nop)
	IMULH_R = 11,  // 1+2+1           0+(p1,p5)+0             3               3+3+3 (mov+mul+mov)
	ISMULH_R = 12, // 1+2+1           0+(p1,p5)+0             3               3+3+3 (mov+imul+mov)
	IMUL_RCP = 13, // 1+1             p015+p1                 4              10+4   (mov+imul)

	INST_COUNT = 14,
	INST_INVALID = -1
};

struct ss_inst_desc_t {
	int src;
	int dst;
	int mod;
	uint32_t imm32;
	ss_inst_t kind;
	ss_inst_t op_group; // opGroup
	int op_group_par;
	bool can_reuse;
	bool group_par_is_source;
};

struct ss_program_t {
	ss_inst_desc_t instructions[SUPERSCALAR_MAX_SIZE];
	uint32_t size;

	int addr_reg;
	double ipc;
	int code_size;
	int macro_ops;
	int decode_cycles;
	int cpu_latency;
	int asic_latency;
	int mul_count;
	int cpu_latencies[8];
	int asic_latencies[8];
};

void ssh_generate(blake2b_generator_state *S, ss_program_t *prog);
