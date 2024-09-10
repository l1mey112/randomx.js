#include "configuration.h"
#include "freestanding.h"
#include "aes/aes.h"
#include "blake2b/blake2b.h"
#include "vm/vm.h"

#include <stdint.h>
#include <wasm_simd128.h>


const int mantissa_size = 52;
const int exponent_size = 11;
const uint64_t mantissa_mask = (1ULL << mantissa_size) - 1;
const uint64_t exponent_mask = (1ULL << exponent_size) - 1;
const int exponent_bias = 1023;
const int dynamic_exponent_bits = 4;
const int static_exponent_bits = 4;
const uint64_t const_exponent_bits = 0x300;
const uint64_t dynamic_mantissa_mask = (1ULL << (mantissa_size + dynamic_exponent_bits)) - 1;

static inline double get_small_positive_float_bits(uint64_t entropy) {
	uint64_t exponent = entropy >> 59; // 0..31
	uint64_t mantissa = entropy & mantissa_mask;
	exponent += exponent_bias;
	exponent &= exponent_mask;
	exponent <<= mantissa_size;
	uint64_t result = mantissa | exponent;
	return *(double*)&result;
}

static inline uint64_t get_static_exponent(uint64_t entropy) {
	uint64_t exponent = const_exponent_bits;
	exponent |= (entropy >> (64 - static_exponent_bits)) << dynamic_exponent_bits;
	exponent <<= mantissa_size;
	return exponent;
}

static inline uint64_t get_float_mask(uint64_t entropy) {
	const uint64_t mask_22bit = (1ULL << 22) - 1;
	return (entropy & mask_22bit) | get_static_exponent(entropy);
}

void program_vm() {
	VM.a[0].lo = get_small_positive_float_bits(P.entropy[0]);
	VM.a[0].hi = get_small_positive_float_bits(P.entropy[1]);
	VM.a[1].lo = get_small_positive_float_bits(P.entropy[2]);
	VM.a[1].hi = get_small_positive_float_bits(P.entropy[3]);
	VM.a[2].lo = get_small_positive_float_bits(P.entropy[4]);
	VM.a[2].hi = get_small_positive_float_bits(P.entropy[5]);
	VM.a[3].lo = get_small_positive_float_bits(P.entropy[6]);
	VM.a[3].hi = get_small_positive_float_bits(P.entropy[7]);
	VM.ma = P.entropy[8] & ((RANDOMX_DATASET_BASE_SIZE - 1) & ~(64 - 1));
	VM.mx = P.entropy[10];
	uint64_t addr_registers = P.entropy[12];
	VM.read_reg0 = 0 + (addr_registers & 1);
	addr_registers >>= 1;
	VM.read_reg1 = 2 + (addr_registers & 1);
	addr_registers >>= 1;
	VM.read_reg2 = 4 + (addr_registers & 1);
	addr_registers >>= 1;
	VM.read_reg3 = 6 + (addr_registers & 1);

	VM.dataset_offset = (P.entropy[13] % (RANDOMX_DATASET_EXTRA_SIZE / 64 + 1)) * 64;
	VM.emask[0] = get_float_mask(P.entropy[14]);
	VM.emask[1] = get_float_mask(P.entropy[15]);
}

void execute_vm() {
	program_vm();
}