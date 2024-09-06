#include <assert.h>
#include <math.h>
#include <stdint.h>
#include <stdbool.h>

#include "freestanding.h"
#include "wasm_simd128_polyfill.h"

#include "rdtsc.h"

typedef struct running_avg_t running_avg_t;

typedef struct finst_t finst_t;
typedef enum fsrc_t fsrc_t;
typedef enum fdest_t fdest_t;

// flags
enum fsrc_t {
	FSRC_A = 1, // read only A register
	FSRC_R = 2, // read from memory from register R
};

// only one
enum fdest_t {
	FDEST_F, // additive instruction F
	FDEST_E, // multiplicative instruction E
};

struct finst_t {
	const char *desc;
	fdest_t dest;
	fsrc_t src;
	v128_t (*fprc[4])(v128_t, v128_t); // probably safe to call one arg function with two args
};

v128_t fadd_0(v128_t dest, v128_t src) {
	return wasm_f64x2_add(dest, src);
}

v128_t fadd_1(v128_t dest, v128_t src);
v128_t fadd_2(v128_t dest, v128_t src);
v128_t fadd_3(v128_t dest, v128_t src);

v128_t fsub_0(v128_t dest, v128_t src) {
	return wasm_f64x2_sub(dest, src);
}

v128_t fsub_1(v128_t dest, v128_t src);
v128_t fsub_2(v128_t dest, v128_t src);
v128_t fsub_3(v128_t dest, v128_t src);

v128_t fmul_0(v128_t dest, v128_t src) {
	return wasm_f64x2_mul(dest, src);
}

v128_t fmul_1(v128_t dest, v128_t src);
v128_t fmul_2(v128_t dest, v128_t src);
v128_t fmul_3(v128_t dest, v128_t src);

v128_t fmul_fma_1(v128_t dest, v128_t src);
v128_t fmul_fma_2(v128_t dest, v128_t src);
v128_t fmul_fma_3(v128_t dest, v128_t src);

v128_t fdiv_0(v128_t dest, v128_t src) {
	return wasm_f64x2_div(dest, src);
}

v128_t fdiv_1(v128_t dest, v128_t src);
v128_t fdiv_2(v128_t dest, v128_t src);
v128_t fdiv_3(v128_t dest, v128_t src);

v128_t fdiv_fma_1(v128_t dest, v128_t src);
v128_t fdiv_fma_2(v128_t dest, v128_t src);
v128_t fdiv_fma_3(v128_t dest, v128_t src);

v128_t fsqrt_0(v128_t dest) {
	return wasm_f64x2_sqrt(dest);
}

v128_t fsqrt_1(v128_t dest);
v128_t fsqrt_2(v128_t dest);
v128_t fsqrt_3(v128_t dest);

v128_t fsqrt_fma_1(v128_t dest);
v128_t fsqrt_fma_2(v128_t dest);
v128_t fsqrt_fma_3(v128_t dest);

static finst_t instructions[] = {
	{"fadd", FDEST_F, FSRC_A | FSRC_R, {fadd_0, fadd_1, fadd_2, fadd_3}},
	{"fsub", FDEST_F, FSRC_A | FSRC_R, {fsub_0, fsub_1, fsub_2, fsub_3}},
	{"fmul", FDEST_E, FSRC_A, {fmul_0, fmul_1, fmul_2, fmul_3}},
	{"fmul (fma)", FDEST_E, FSRC_A, {fmul_0, fmul_fma_1, fmul_fma_2, fmul_fma_3}},
	{"fdiv", FDEST_E, FSRC_R, {fdiv_0, fdiv_1, fdiv_2, fdiv_3}},
	{"fdiv (fma)", FDEST_E, FSRC_R, {fdiv_0, fdiv_fma_1, fdiv_fma_2, fdiv_fma_3}},
	{"fsqrt", FDEST_E, 0, {(void*)fsqrt_0, (void*)fsqrt_1, (void*)fsqrt_2, (void*)fsqrt_3}},
	{"fsqrt (fma)", FDEST_E, 0, {(void*)fsqrt_0, (void*)fsqrt_fma_1, (void*)fsqrt_fma_2, (void*)fsqrt_fma_3}},
};

// PCG32
static uint64_t rngstate = 0;

uint32_t pcg32_random_r() {
	uint64_t oldstate = rngstate;
	// Advance internal state
	rngstate = oldstate * 6364136223846793005ULL + 1;
	// Calculate output function (XSH RR), uses old state for max ILP
	uint32_t xorshifted = ((oldstate >> 18u) ^ oldstate) >> 27u;
	uint32_t rot = oldstate >> 59u;
	return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

// http://marc-b-reynolds.github.io/math/2020/06/16/UniformFloat.html
double uniform(double lo, double hi) {
	uint64_t low32 = pcg32_random_r();
	uint64_t high32 = pcg32_random_r();
	uint64_t rv = low32 | (high32 << 32);

	double uni = (double)(rv >> (64 - 53)) * 0x1p-53; // [0,1)

	if (isinf(hi)) {
		hi = 0x1.fffffffffffffp100;
	}

	return lo + (hi - lo) * uni;
}

v128_t uniform128(double lo, double hi) {
	double v0 = uniform(lo, hi);
	double v1 = uniform(lo, hi);
	return wasm_f64x2_make(v0, v1);
}

struct running_avg_t {
	double avg;
	unsigned count;
};

// TODO: i should probably be removing statistical outliers
static void running_avg_update(running_avg_t *avg, double value) {
	if (value < 0.0) {
		return;
	}
	avg->count++;
	double a = 1.0 / avg->count;
	double b = 1.0 - a;
	avg->avg = a * value + b * avg->avg;
}

bool test(finst_t *inst, unsigned samples) {
	const int fprc_env[] = {
		FE_TONEAREST,
		FE_DOWNWARD,
		FE_UPWARD,
		FE_TOWARDZERO,
	};

	running_avg_t running_avg[4] = {};
	unsigned complete[4] = {};

#define TIMEIT(v, f)                                                    \
	do {                                                                \
		uint32_t rdtsc_base = rdtsc_overhead();                         \
		uint32_t start = rdtsc();                                       \
		f;                                                              \
		uint32_t end = rdtsc();                                         \
		int32_t ncycles = (int32_t)(end - start) - rdtsc_base;          \
		running_avg_update(&running_avg[v], ncycles < 0 ? 0 : ncycles); \
	} while (0)

	// boundary conditions
	unsigned INFINITY_COUNT = (samples / 100) | 2;
	unsigned bound_idx = 0;

	for (unsigned i = 0; i < samples; i++) {
		v128_t dest, src, truth, result;

		switch (inst->dest) {
		case FDEST_F:
			dest = uniform128(-3.0e+14, 3.0e+14);
			break;
		case FDEST_E:
			if (bound_idx < INFINITY_COUNT / 2) {
				dest = wasm_f64x2_const(INFINITY, INFINITY);
				bound_idx++;
			} else if (bound_idx < INFINITY_COUNT) {
				dest = wasm_f64x2_const(0x1.fffffffffffffp1023, 0x1.fffffffffffffp1023);
				bound_idx++;
			} else {
				dest = uniform128(1.7e-77, INFINITY);
			}
			break;
		}

		double src_lo, src_hi;

		if (inst->src & FSRC_A) {
			src_lo = 1;
			src_hi = 4294967296;
		}

		if (inst->src & FSRC_R) {
			if (inst->dest == FDEST_F) {
				src_lo = fmin(src_lo, -3.0e+14);
				src_hi = fmax(src_hi, 3.0e+14);
			} else {
				src_lo = fmin(src_lo, 1.7e-77);
				src_hi = fmax(src_hi, INFINITY);
			}
		}

		src = uniform128(src_lo, src_hi);

		for (int v = 1; v < 4; v++) {
			fesetround(fprc_env[v]);
			TIMEIT(0, { truth = inst->fprc[0](dest, src); });

			fesetround(FE_TONEAREST);
			TIMEIT(v, { result = inst->fprc[v](dest, src); });

			double dest0 = wasm_f64x2_extract_lane(dest, 0);
			double dest1 = wasm_f64x2_extract_lane(dest, 1);
			double src0 = wasm_f64x2_extract_lane(src, 0);
			double src1 = wasm_f64x2_extract_lane(src, 1);
			double truth0 = wasm_f64x2_extract_lane(truth, 0);
			double truth1 = wasm_f64x2_extract_lane(truth, 1);
			double result0 = wasm_f64x2_extract_lane(result, 0);
			double result1 = wasm_f64x2_extract_lane(result, 1);

#define FAIL(f) \
	printf("FAIL: [%s fprc(%d)] truth(%a, %a) == %a != op(...) == %a\n", inst->desc, v, dest##f, src##f, truth##f, result##f)

			if (truth0 == result0) {
				complete[v]++;
			} else {
				FAIL(0);
			}

			if (truth1 == result1) {
				complete[v]++;
			} else {
				FAIL(1);
			}
		}
	}

#undef FAIL
#undef TIMEIT

	bool failed = false;

	printf("%s:\n", inst->desc);
	for (int v = 0; v < 4; v++) {
		if (v == 0) {
			printf("  fprc(%d): %uclks\n", v, (unsigned)running_avg[v].avg);
		} else {
			if (complete[v] != samples * 2) {
				failed = true;
			}

			printf("  fprc(%d): %uclks [%d/%d] x%u overhead\n", v, (unsigned)running_avg[v].avg, complete[v], samples * 2, (unsigned)round(running_avg[v].avg / running_avg[0].avg));
		}
	}

	return failed;
}

/* void boundary_conditions() {
	fesetround(FE_TONEAREST);
	printf("fprc(0): inf * fin = %a\n", INFINITY * 5.5);
	fesetround(FE_DOWNWARD);
	printf("fprc(1): inf * fin = %a\n", INFINITY * 5.5);
	fesetround(FE_UPWARD);
	printf("fprc(2): inf * fin = %a\n", INFINITY * 5.5);
	fesetround(FE_TOWARDZERO);
	printf("fprc(3): inf * fin = %a\n", INFINITY * 5.5);

	fesetround(FE_TONEAREST);
	printf("fprc(0): inf / fin = %a\n", INFINITY / 0x1.ee86b53b8c8a7p+100);
	fesetround(FE_DOWNWARD);
	printf("fprc(1): inf / fin = %a\n", INFINITY / 0x1.ee86b53b8c8a7p+100);
	fesetround(FE_UPWARD);
	printf("fprc(2): inf / fin = %a\n", INFINITY / 0x1.ee86b53b8c8a7p+100);
	fesetround(FE_TOWARDZERO);
	printf("fprc(3): inf / fin = %a\n", INFINITY / 0x1.ee86b53b8c8a7p+100);

	fesetround(FE_TONEAREST);
	printf("fprc(0): inf^0.5 = %a\n", sqrt(INFINITY));
	fesetround(FE_DOWNWARD);
	printf("fprc(1): inf^0.5 = %a\n", sqrt(INFINITY));
	fesetround(FE_UPWARD);
	printf("fprc(2): inf^0.5 = %a\n", sqrt(INFINITY));
	fesetround(FE_TOWARDZERO);
	printf("fprc(3): inf^0.5 = %a\n", sqrt(INFINITY));

	fesetround(FE_TONEAREST);
	printf("fprc(0): fin * fin = %a\n", 0x1.fffffffffffffp1023 * 0x1.fffffffffffffp1023);
	fesetround(FE_DOWNWARD);
	printf("fprc(1): fin * fin = %a\n", 0x1.fffffffffffffp1023 * 0x1.fffffffffffffp1023);
	fesetround(FE_UPWARD);
	printf("fprc(2): fin * fin = %a\n", 0x1.fffffffffffffp1023 * 0x1.fffffffffffffp1023);
	fesetround(FE_TOWARDZERO);
	printf("fprc(3): fin * fin = %a\n", 0x1.fffffffffffffp1023 * 0x1.fffffffffffffp1023);

	fesetround(FE_TONEAREST);
} */

/* bool simd_fmatest(void) {
	v128_t a = wasm_f64x2_const(0x1.0000000000001p+0, 0.0);
	v128_t b = wasm_f64x2_const(0x1.ffffffffffffep-1, 0.0);
	v128_t c = wasm_f64x2_const(-1.0, 0.0);

	// using a polyfill that invokes _mm_fmadd_pd()
	v128_t d = wasm_f64x2_relaxed_madd(a, b, c);
	double d0 = wasm_f64x2_extract_lane(d, 0);

	return d0 == -0x1.0p-104;
} */

#include <immintrin.h>

bool simd_fmatest(void) {
	__m128d a = _mm_set_pd(0x1.0000000000001p+0, 0.0);
	__m128d b = _mm_set_pd(0x1.ffffffffffffep-1, 0.0);
	__m128d c = _mm_set_pd(-1.0, 0.0);

	__m128d d = _mm_fmadd_pd(a, b, c);

	return d[1] == -0x1.0p-104;
}

bool scalar_fmatest(void) {
	double a = 0x1.0000000000001p+0;
	double b = 0x1.ffffffffffffep-1;
	double c = -1.0;

	double d = fma(a, b, c);

	return d == -0x1.0p-104;
}

int main() {
	bool failed = false;

	assert(scalar_fmatest());
	assert(simd_fmatest());

	// boundary_conditions();
	
	for (int i = 0; i < (int)sizeof(instructions) / (int)sizeof(instructions[0]); i++) {
		failed |= test(&instructions[i], 5000);
	}

	return failed;
}
