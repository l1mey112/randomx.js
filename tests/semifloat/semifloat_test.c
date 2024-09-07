#include <assert.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>

#include "wasm_simd128_polyfill.h"

#include "rdtsc.h"

#ifndef GIT_HASH
#define GIT_HASH "unknown"
#endif

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

#include "the_randomx_fp_heap.h"

static bool fp_heap_failed = false;
static uint64_t fp_heap_v = 0;
static uint64_t fp_heap_vu = 0;

static const char *fp_heap_opstr[FCOUNT] = {
	[FADD_0] = "fadd_0",
	[FADD_1] = "fadd_1",
	[FADD_2] = "fadd_2",
	[FADD_3] = "fadd_3",
	[FSUB_0] = "fsub_0",
	[FSUB_1] = "fsub_1",
	[FSUB_2] = "fsub_2",
	[FSUB_3] = "fsub_3",
	[FMUL_0] = "fmul_0",
	[FMUL_1] = "fmul_1",
	[FMUL_2] = "fmul_2",
	[FMUL_3] = "fmul_3",
	[FMUL_FMA_1] = "fmul_fma_1",
	[FMUL_FMA_2] = "fmul_fma_2",
	[FMUL_FMA_3] = "fmul_fma_3",
	[FDIV_0] = "fdiv_0",
	[FDIV_1] = "fdiv_1",
	[FDIV_2] = "fdiv_2",
	[FDIV_3] = "fdiv_3",
	[FDIV_FMA_1] = "fdiv_fma_1",
	[FDIV_FMA_2] = "fdiv_fma_2",
	[FDIV_FMA_3] = "fdiv_fma_3",
	[FSQRT_0] = "fsqrt_0",
	[FSQRT_1] = "fsqrt_1",
	[FSQRT_2] = "fsqrt_2",
	[FSQRT_3] = "fsqrt_3",
	[FSQRT_FMA_1] = "fsqrt_fma_1",
	[FSQRT_FMA_2] = "fsqrt_fma_2",
	[FSQRT_FMA_3] = "fsqrt_fma_3",
};

static running_avg_t fp_heap_running_avg[FCOUNT] = {};
static unsigned fp_heap_passed[FCOUNT] = {};

// INFO: keep in mind now that, yes, we are testing the clock cycles of inevitable
//       mispredicted branches when dispatching a call to a function pointer.
//       that doesn't matter though, since its all relative and evens out in the end

#define TIMEIT(v, f)                                                    \
	do {                                                                \
		uint32_t rdtsc_base = rdtsc_overhead();                         \
		uint32_t start = rdtsc();                                       \
		f;                                                              \
		uint32_t end = rdtsc();                                         \
		int32_t ncycles = (int32_t)(end - start) - rdtsc_base;          \
		running_avg_update(&fp_heap_running_avg[v], ncycles < 0 ? 0 : ncycles); \
	} while (0)

void TESTV(int op, double x0, double x1, double y0, double y1, double z0, double z1) {
	v128_t v = wasm_f64x2_make(x0, x1);
	v128_t w = wasm_f64x2_make(y0, y1);

	fp_heap_v++;

	static v128_t (*const opft[])(v128_t, v128_t) = {
		[FADD_0] = fadd_0,
		[FADD_1] = fadd_1,
		[FADD_2] = fadd_2,
		[FADD_3] = fadd_3,
		[FSUB_0] = fsub_0,
		[FSUB_1] = fsub_1,
		[FSUB_2] = fsub_2,
		[FSUB_3] = fsub_3,
		[FMUL_0] = fmul_0,
		[FMUL_1] = fmul_1,
		[FMUL_2] = fmul_2,
		[FMUL_3] = fmul_3,
		[FMUL_FMA_1] = fmul_fma_1,
		[FMUL_FMA_2] = fmul_fma_2,
		[FMUL_FMA_3] = fmul_fma_3,
		[FDIV_0] = fdiv_0,
		[FDIV_1] = fdiv_1,
		[FDIV_2] = fdiv_2,
		[FDIV_3] = fdiv_3,
		[FDIV_FMA_1] = fdiv_fma_1,
		[FDIV_FMA_2] = fdiv_fma_2,
		[FDIV_FMA_3] = fdiv_fma_3,
	};

	v128_t (*opf)(v128_t, v128_t) = opft[op];

	v128_t result;
	TIMEIT(op, { result = opf(v, w); });

	double result0 = wasm_f64x2_extract_lane(result, 0);
	double result1 = wasm_f64x2_extract_lane(result, 1);

	if (result0 != z0) {
		printf("FAIL: %s(%a, %a) == %a != %a\n", fp_heap_opstr[op], x0, y0, result0, z0);
		fp_heap_failed = true;
	} else {
		fp_heap_passed[op]++;
	}

	if (result1 != z1) {
		printf("FAIL: %s(%a, %a) == %a != %a\n", fp_heap_opstr[op], x1, y1, result1, z1);
		fp_heap_failed = true;
	} else {
		fp_heap_passed[op]++;
	}
}

void TESTVU(int op, double x0, double x1, double z0, double z1) {
	v128_t v = wasm_f64x2_make(x0, x1);

	fp_heap_vu++;

	static v128_t (*const opft[])(v128_t) = {
		[FSQRT_0] = fsqrt_0,
		[FSQRT_1] = fsqrt_1,
		[FSQRT_2] = fsqrt_2,
		[FSQRT_3] = fsqrt_3,
		[FSQRT_FMA_1] = fsqrt_fma_1,
		[FSQRT_FMA_2] = fsqrt_fma_2,
		[FSQRT_FMA_3] = fsqrt_fma_3,
	};

	v128_t (*opf)(v128_t) = opft[op];

	v128_t result;
	TIMEIT(op, { result = opf(v); });

	double result0 = wasm_f64x2_extract_lane(result, 0);
	double result1 = wasm_f64x2_extract_lane(result, 1);

	if (result0 != z0) {
		printf("FAIL: %s(%a, %a) == %a != %a\n", fp_heap_opstr[op], x0, x1, result0, z0);
		fp_heap_failed = true;
	} else {
		fp_heap_passed[op]++;
	}

	if (result1 != z1) {
		printf("FAIL: %s(%a, %a) == %a != %a\n", fp_heap_opstr[op], x0, x1, result1, z1);
		fp_heap_failed = true;
	} else {
		fp_heap_passed[op]++;
	}
}

#undef TIMEIT

bool fp_heap() {
	SAMPLE();
	printf("FP heap: %lu infix, %lu unary, %lu total (git %s)\n", fp_heap_v, fp_heap_vu, fp_heap_v + fp_heap_vu, GIT_HASH);

	int lowbounds[] = {FADD_0, FSUB_0, FMUL_0, FDIV_0, FSQRT_0};
	for (int v = 0; v < FCOUNT; v++) {
		// iterate backwards

		bool ref_exact = false;
		int ref = 0;

		for (int i = 5; i-- > 0;) {
			if (v >= lowbounds[i]) {
				if (v == lowbounds[i]) {
					ref_exact = true;
				}
				ref = lowbounds[i];				
				break;
			}
		}

		double reference_avg = fp_heap_running_avg[ref].avg;

		printf("  %11s  | %3uclks", fp_heap_opstr[v], (unsigned)round(fp_heap_running_avg[v].avg));
		if (!ref_exact) {
			printf(" x%0.1f overhead", fp_heap_running_avg[v].avg / reference_avg);
			unsigned passes = fp_heap_passed[v];
			unsigned out_of = fp_heap_running_avg[v].count * 2;
			if (passes < out_of) {
				printf(" [%u/%u]", passes, out_of);
			}
		}
		printf("\n");
	}
	return fp_heap_failed;
}

#include <immintrin.h>

#ifndef __x86_64__
#error "x86_64 only FP tests, sorry"
#endif

bool __attribute__((optnone)) simd_fmatest(void) {
	__m128d a = _mm_set_pd(0x1.0000000000001p+0, 0.0);
	__m128d b = _mm_set_pd(0x1.ffffffffffffep-1, 0.0);
	__m128d c = _mm_set_pd(-1.0, 0.0);

	__m128d d = _mm_fmadd_pd(a, b, c);

	return d[1] == -0x1.0p-104;
}

bool __attribute__((optnone)) scalar_fmatest(void) {
	double a = 0x1.0000000000001p+0;
	double b = 0x1.ffffffffffffep-1;
	double c = -1.0;

	double d = fma(a, b, c);

	return d == -0x1.0p-104;
}

int main() {
	assert(scalar_fmatest());
	assert(simd_fmatest());

	// used to have boundary tests and overhead tests, now the FP heap covers everything
	return fp_heap();
}
