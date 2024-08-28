#pragma once

#include <stdint.h>
#include <stdbool.h>

// kinds
typedef enum ss_inst_t ss_inst_t;
typedef enum ss_uop_t ss_uop_t;
typedef enum ss_mop_t ss_mop_t;

// tables
typedef struct ss_mop_info_t ss_mop_info_t;
typedef struct ss_inst_info_t ss_inst_info_t;

typedef enum decode_group_t decode_group_t;
typedef struct decode_buffer_t decode_buffer_t;

// uOPs (micro-ops) are represented only by the execution port they can go to
enum ss_uop_t {
	UOP_NULL = 0,
	UOP_P0 = 1,
	UOP_P1 = 2,
	UOP_P5 = 4,
	UOP_P01 = UOP_P0 | UOP_P1,
	UOP_P05 = UOP_P0 | UOP_P5,
	UOP_P015 = UOP_P0 | UOP_P1 | UOP_P5,
};

enum ss_mop_t {
	MOP_SUB_RR,
	MOP_XOR_RR,
	MOP_LEA_SIB,
	MOP_IMUL_RR,
	MOP_ROR_RI,
	MOP_ADD_RI,
	MOP_XOR_RI,
	MOP_MOV_RR,
	MOP_MUL_R,
	MOP_IMUL_R,
	MOP_MOV_RI,
};

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

struct ss_mop_info_t {
	const char *name;
	uint8_t latency;
	uint8_t size;
	ss_uop_t uop0;
	ss_uop_t uop1;
};

struct ss_inst_info_t {
	const char *name;
	int mops_len;
	ss_mop_t *mops;
	int src_op;
	int result_op;
	int dst_op;
	bool final_mop_dependent;
};

enum decode_group_t {
	GROUP_0_484,
	GROUP_1_7333,
	GROUP_2_3733,
	GROUP_3_493,
	GROUP_4_4444,
	GROUP_5_3310,
	GROUP_SIZE,
};

struct decode_buffer_t {
	int size;
	int *slots;
};
