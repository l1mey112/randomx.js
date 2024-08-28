#pragma once

#include <stdint.h>
#include <stdbool.h>

#include "ssh.h"

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
	const char *name;
	int size;
	int *slots;
};

typedef struct ss_reginfo_t ss_reginfo_t;

struct ss_reginfo_t {
	int latency;
	ss_inst_t last_op_group;
	int last_op_par;
	int value;
};
