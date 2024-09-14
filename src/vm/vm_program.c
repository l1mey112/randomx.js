#include "configuration.h"
#include "freestanding.h"
#include "vm/vm.h"

#include <stdint.h>

#define MANTISSA_SIZE 52
#define EXPONENT_SIZE 11
#define MANTISSA_MASK ((1ULL << MANTISSA_SIZE) - 1)
#define EXPONENT_MASK ((1ULL << EXPONENT_SIZE) - 1)
#define EXPONENT_BIAS 1023
#define DYNAMIC_EXPONENT_BITS 4
#define STATIC_EXPONENT_BITS 4
#define CONST_EXPONENT_BITS UINT64_C(0x300)
#define DYNAMIC_MANTISSA_MASK ((1ULL << (MANTISSA_SIZE + DYNAMIC_EXPONENT_BITS)) - 1) // emask

static inline double get_small_positive_float_bits(uint64_t entropy) {
	uint64_t exponent = entropy >> 59; // 0..31
	uint64_t mantissa = entropy & MANTISSA_MASK;
	exponent += EXPONENT_BIAS;
	exponent &= EXPONENT_MASK;
	exponent <<= MANTISSA_SIZE;
	uint64_t result = mantissa | exponent;
	return *(double *)&result;
}

static inline uint64_t get_static_exponent(uint64_t entropy) {
	uint64_t exponent = CONST_EXPONENT_BITS;
	exponent |= (entropy >> (64 - STATIC_EXPONENT_BITS)) << DYNAMIC_EXPONENT_BITS;
	exponent <<= MANTISSA_SIZE;
	return exponent;
}

static inline uint64_t get_float_mask(uint64_t entropy) {
	const uint64_t mask_22bit = (1ULL << 22) - 1;
	return (entropy & mask_22bit) | get_static_exponent(entropy);
}

void vm_program(rx_vm_t *VM, const rx_program_t *P) {
	VM->a[0].lo = get_small_positive_float_bits(P->entropy[0]);
	VM->a[0].hi = get_small_positive_float_bits(P->entropy[1]);
	VM->a[1].lo = get_small_positive_float_bits(P->entropy[2]);
	VM->a[1].hi = get_small_positive_float_bits(P->entropy[3]);
	VM->a[2].lo = get_small_positive_float_bits(P->entropy[4]);
	VM->a[2].hi = get_small_positive_float_bits(P->entropy[5]);
	VM->a[3].lo = get_small_positive_float_bits(P->entropy[6]);
	VM->a[3].hi = get_small_positive_float_bits(P->entropy[7]);
	VM->ma = P->entropy[8] & ((RANDOMX_DATASET_BASE_SIZE - 1) & ~(64 - 1));
	VM->mx = P->entropy[10];
	uint64_t addr_registers = P->entropy[12];
	VM->read_reg0 = 0 + (addr_registers & 1);
	addr_registers >>= 1;
	VM->read_reg1 = 2 + (addr_registers & 1);
	addr_registers >>= 1;
	VM->read_reg2 = 4 + (addr_registers & 1);
	addr_registers >>= 1;
	VM->read_reg3 = 6 + (addr_registers & 1);

	VM->dataset_offset = (P->entropy[13] % (RANDOMX_DATASET_EXTRA_SIZE / 64 + 1)) * 64;
	VM->emask[0] = get_float_mask(P->entropy[14]);
	VM->emask[1] = get_float_mask(P->entropy[15]);
	VM->mmask[0] = DYNAMIC_MANTISSA_MASK;
	VM->mmask[1] = DYNAMIC_MANTISSA_MASK;
}
