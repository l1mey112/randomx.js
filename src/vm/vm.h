#pragma once

#include <stdint.h>
#include "configuration.h"
#include "jit/inst.h"

typedef struct rx_vm_t rx_vm_t;
typedef struct rx_program_t rx_program_t;
typedef struct rx_reg_t rx_reg_t;
typedef struct f64x2_t f64x2_t;


struct f64x2_t {
	double lo;
	double hi;
};

// 128 + 8 * RANDOMX_PROGRAM_SIZE
struct rx_program_t {
	uint64_t entropy[16];
	rx_inst_t program[RANDOMX_PROGRAM_SIZE];
};

struct rx_vm_t {
	uint64_t r[8];
	f64x2_t f[4];
	f64x2_t e[4];
	f64x2_t a[4];

	uint32_t ma;
	uint32_t mx;

	uint64_t emask[2];
	uint32_t read_reg0;
	uint32_t read_reg1;
	uint32_t read_reg2;
	uint32_t read_reg3;
};
