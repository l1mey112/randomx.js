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

v128_t fadd_0(v128_t dest, v128_t src);
v128_t fadd_1(v128_t dest, v128_t src);
v128_t fadd_2(v128_t dest, v128_t src);
v128_t fadd_3(v128_t dest, v128_t src);

v128_t fsub_0(v128_t dest, v128_t src) ;
v128_t fsub_1(v128_t dest, v128_t src);
v128_t fsub_2(v128_t dest, v128_t src);
v128_t fsub_3(v128_t dest, v128_t src);

v128_t fmul_0(v128_t dest, v128_t src);
v128_t fmul_1(v128_t dest, v128_t src);
v128_t fmul_2(v128_t dest, v128_t src);
v128_t fmul_3(v128_t dest, v128_t src);

v128_t fmul_fma_1(v128_t dest, v128_t src);
v128_t fmul_fma_2(v128_t dest, v128_t src);
v128_t fmul_fma_3(v128_t dest, v128_t src);

v128_t fdiv_0(v128_t dest, v128_t src);
v128_t fdiv_1(v128_t dest, v128_t src);
v128_t fdiv_2(v128_t dest, v128_t src);
v128_t fdiv_3(v128_t dest, v128_t src);

v128_t fdiv_fma_1(v128_t dest, v128_t src);
v128_t fdiv_fma_2(v128_t dest, v128_t src);
v128_t fdiv_fma_3(v128_t dest, v128_t src);

v128_t fsqrt_0(v128_t dest);
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
	if (value <= 0.0) {
		return;
	}
	if (value > 75) {
		// probably some context switch
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
static unsigned fp_heap_count[FCOUNT] = {};

#define TIMEIT(v, f)                                                            \
	do {                                                                        \
		uint32_t rdtsc_base = rdtsc_overhead();                                 \
		uint32_t start = rdtsc();                                               \
		f;                                                                      \
		uint32_t end = rdtsc();                                                 \
		int32_t ncycles = (int32_t)(end - start) - rdtsc_base;                  \
		running_avg_update(&fp_heap_running_avg[v], ncycles < 0 ? 0 : ncycles); \
	} while (0)

#define LANE_V(n, fn, heap)                                                                      \
	do {                                                                                         \
		if (result##n != p->z##n) {                                                              \
			printf("FAIL: %s(%a, %a) == %a != %a\n", #fn, p->x##n, p->y##n, result##n, p->z##n); \
			fp_heap_failed = true;                                                               \
		} else {                                                                                 \
			fp_heap_passed[heap]++;                                                              \
		}                                                                                        \
		fp_heap_count[heap]++;                                                                   \
	} while (0)

#define LANE_VU(n, fn, heap)                                                        \
	do {                                                                            \
		if (result##n != p->z##n) {                                                 \
			printf("FAIL: %s(%a) == %a != %a\n", #fn, p->x##n, result##n, p->z##n); \
			fp_heap_failed = true;                                                  \
		} else {                                                                    \
			fp_heap_passed[heap]++;                                                 \
		}                                                                           \
		fp_heap_count[heap]++;                                                      \
	} while (0)

#define ITERATION_COUNT 50000

volatile v128_t _out;

#define RUNFOR_V(fn, heap)                                                    \
	p = HEAP_##heap, endp = p + sizeof(HEAP_##heap) / sizeof(HEAP_##heap[0]); \
	while (p != endp) {                                                       \
		v128_t v = wasm_f64x2_make(p->x0, p->x1);                             \
		v128_t w = wasm_f64x2_make(p->y0, p->y1);                             \
		fp_heap_v++;                                                          \
		v128_t result = fn(v, w);                                             \
		double result0 = wasm_f64x2_extract_lane(result, 0);                  \
		double result1 = wasm_f64x2_extract_lane(result, 1);                  \
		LANE_V(0, fn, heap);                                                  \
		LANE_V(1, fn, heap);                                                  \
		p++;                                                                  \
	}                                                                         \
	p = HEAP_##heap, endp = p + sizeof(HEAP_##heap) / sizeof(HEAP_##heap[0]); \
	for (unsigned c = 0; c < ITERATION_COUNT; c++) {                          \
		v128_t v = wasm_f64x2_make(p->x0, p->x1);                             \
		v128_t w = wasm_f64x2_make(p->y0, p->y1);                             \
		TIMEIT(heap, { _out = fn(v, w); });                                   \
		if (++p == endp) {                                                    \
			p = HEAP_##heap;                                                  \
		}                                                                     \
	}

#define RUNFOR_VU(fn, heap)                                                   \
	p = HEAP_##heap, endp = p + sizeof(HEAP_##heap) / sizeof(HEAP_##heap[0]); \
	while (p != endp) {                                                       \
		v128_t v = wasm_f64x2_make(p->x0, p->x1);                             \
		fp_heap_vu++;                                                         \
		v128_t result = fn(v);                                                \
		double result0 = wasm_f64x2_extract_lane(result, 0);                  \
		double result1 = wasm_f64x2_extract_lane(result, 1);                  \
		LANE_VU(0, fn, heap);                                                 \
		LANE_VU(1, fn, heap);                                                 \
		p++;                                                                  \
	}                                                                         \
	p = HEAP_##heap, endp = p + sizeof(HEAP_##heap) / sizeof(HEAP_##heap[0]); \
	for (unsigned c = 0; c < ITERATION_COUNT; c++) {                          \
		v128_t v = wasm_f64x2_make(p->x0, p->x1);                             \
		TIMEIT(heap, { _out = fn(v); });                                      \
		if (++p == endp) {                                                    \
			p = HEAP_##heap;                                                  \
		}                                                                     \
	}

bool fp_heap() {
	{
		TESTV *p, *endp;
		RUNFOR_V(fadd_0, FADD_0);
		RUNFOR_V(fadd_1, FADD_1);
		RUNFOR_V(fadd_2, FADD_2);
		RUNFOR_V(fadd_3, FADD_3);
		RUNFOR_V(fsub_0, FSUB_0);
		RUNFOR_V(fsub_1, FSUB_1);
		RUNFOR_V(fsub_2, FSUB_2);
		RUNFOR_V(fsub_3, FSUB_3);
		RUNFOR_V(fmul_0, FMUL_0);
		RUNFOR_V(fmul_1, FMUL_1);
		RUNFOR_V(fmul_2, FMUL_2);
		RUNFOR_V(fmul_3, FMUL_3);
		RUNFOR_V(fmul_fma_1, FMUL_FMA_1);
		RUNFOR_V(fmul_fma_2, FMUL_FMA_2);
		RUNFOR_V(fmul_fma_3, FMUL_FMA_3);
		RUNFOR_V(fdiv_0, FDIV_0);
		RUNFOR_V(fdiv_1, FDIV_1);
		RUNFOR_V(fdiv_2, FDIV_2);
		RUNFOR_V(fdiv_3, FDIV_3);
		RUNFOR_V(fdiv_fma_1, FDIV_FMA_1);
		RUNFOR_V(fdiv_fma_2, FDIV_FMA_2);
		RUNFOR_V(fdiv_fma_3, FDIV_FMA_3);
	}

	{
		TESTVU *p, *endp;
		RUNFOR_VU(fsqrt_0, FSQRT_0);
		RUNFOR_VU(fsqrt_1, FSQRT_1);
		RUNFOR_VU(fsqrt_2, FSQRT_2);
		RUNFOR_VU(fsqrt_3, FSQRT_3);
		RUNFOR_VU(fsqrt_fma_1, FSQRT_FMA_1);
		RUNFOR_VU(fsqrt_fma_2, FSQRT_FMA_2);
		RUNFOR_VU(fsqrt_fma_3, FSQRT_FMA_3);
	}

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
			unsigned out_of = fp_heap_count[v];
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
