#pragma once

#include "freestanding.h"
#include "jit/inst.h"

#include <stdint.h>

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
	alignas(16) uint64_t r[8];
	alignas(16) f64x2_t f[4];
	alignas(16) f64x2_t e[4];
	alignas(16) f64x2_t a[4];

	alignas(16) uint64_t emask[2];
	alignas(16) uint64_t mmask[2]; // constant to be DYNAMIC_MANTISSA_MASK x2

	uint32_t fprc; // will not be stored to by `vm_program`

	uint32_t ma;
	uint32_t mx;

	uint32_t read_reg0;
	uint32_t read_reg1;
	uint32_t read_reg2;
	uint32_t read_reg3;

	uint64_t dataset_offset;
};

void vm_program(rx_vm_t *VM, const rx_program_t *P);
