#include "configuration.h"
#include "wasm.h"

#include "aes/aes.h"
#include "blake2b/blake2b.h"
#include "jit/inst.h"
#include <stdint.h>
#include <wasm_simd128.h>

uint8_t H_buffer[1024 * 8];

blake2b_state *SS; // seed state

uint8_t scratchpad[RANDOMX_SCRATCHPAD_L3];

WASM_EXPORT("b")
void *get_input_buffer() {
	return H_buffer;
}

WASM_EXPORT("I")
void init_new_hash() {
	blake2b_init_key(SS, 64, NULL, 0);
}

WASM_EXPORT("H")
void update_hash(uint32_t data_length) {
	blake2b_update(SS, H_buffer, data_length);
}

typedef struct rx_program_t rx_program_t;
typedef struct rx_reg_t rx_reg_t;
typedef struct f64x2_t f64x2_t;

// 128 + 8 * RANDOMX_PROGRAM_SIZE
struct rx_program_t {
	uint64_t entropy[16];
	rx_inst_t program[RANDOMX_PROGRAM_SIZE];
};

struct f64x2_t {
	double lo;
	double hi;
};

struct rx_reg_t {
	uint64_t r[8];
	f64x2_t f[4];
	f64x2_t e[4];
	f64x2_t a[4];
};

const int mantissa_size = 52;
const int exponent_size = 11;
const uint64_t mantissa_mask = (1ULL << mantissa_size) - 1;
const uint64_t exponent_mask = (1ULL << exponent_size) - 1;
const int exponent_bias = 1023;
const int dynamic_exponent_bits = 4;
const int static_exponent_bits = 4;
const uint64_t const_exponent_bits = 0x300;
const uint64_t dynamic_mantissa_mask = (1ULL << (mantissa_size + dynamic_exponent_bits)) - 1;

static inline uint64_t get_small_positive_float_bits(uint64_t entropy) {
	uint64_t exponent = entropy >> 59; //0..31
	uint64_t mantissa = entropy & mantissa_mask;
	exponent += exponent_bias;
	exponent &= exponent_mask;
	exponent <<= mantissa_size;
	return exponent | mantissa;
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

uint8_t S[64];  // 512-bit seed - state of the generator gen4
rx_program_t P; // program buffer

alignas(16)
rx_reg_t R;

WASM_EXPORT("R")
void finalise_hash() {
	blake2b_finalise(SS, S);

	// S now contains the seed
	fillAes1Rx4(S, RANDOMX_SCRATCHPAD_L3, scratchpad); // 2 MiBs

	/* for (int chain = 0; chain < RANDOMX_PROGRAM_COUNT - 1; ++chain) {
		// program generation
		fillAes4Rx4(S, sizeof(P), (void*)&P);

		R.a[0].lo = get_small_positive_float_bits(P.entropy[0]);
		R.a[0].hi = get_small_positive_float_bits(P.entropy[1]);
		R.a[1].lo = get_small_positive_float_bits(P.entropy[2]);
		R.a[1].hi = get_small_positive_float_bits(P.entropy[3]);
		R.a[2].lo = get_small_positive_float_bits(P.entropy[4]);
		R.a[2].hi = get_small_positive_float_bits(P.entropy[5]);
		R.a[3].lo = get_small_positive_float_bits(P.entropy[6]);
		R.a[3].hi = get_small_positive_float_bits(P.entropy[7]);
		uint32_t ma = P.entropy[8] & ((RANDOMX_DATASET_BASE_SIZE - 1) & ~(64 - 1));
		uint32_t mx = P.entropy[10];
		uint64_t addr_registers = P.entropy[12];
		uint32_t readReg0 = 0 + (addr_registers & 1);
		addr_registers >>= 1;
		uint32_t readReg1 = 2 + (addr_registers & 1);
		addr_registers >>= 1;
		uint32_t readReg2 = 4 + (addr_registers & 1);
		addr_registers >>= 1;
		uint32_t readReg3 = 6 + (addr_registers & 1);
		uint64_t dataset_offset = (P.entropy[13] % (RANDOMX_DATASET_EXTRA_SIZE / 64 + 1)) * 64;
		uint64_t eMask0 = get_float_mask(P.entropy[14]);
		uint64_t eMask1 = get_float_mask(P.entropy[15]);
	} */
}
