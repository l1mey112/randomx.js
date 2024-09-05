#include "freestanding.h"

#ifdef __wasm__
#include <wasm_simd128.h>
#else
#include "wasm_simd128_polyfill.h"
#endif

static inline v128_t sum_residue(v128_t a, v128_t b, v128_t c) {
	v128_t delta_a = wasm_f64x2_sub(a, wasm_f64x2_sub(c, b));
	v128_t delta_b = wasm_f64x2_sub(b, wasm_f64x2_sub(c, a));
	v128_t res = wasm_f64x2_add(delta_a, delta_b);
	return res;
}

// preconditions
// - no NaNs, no subnormals
// - source registers: always finite
// 1. finite - no infinities (register type F, additive instructions)
// 2.

// toward negative infinity
static inline v128_t nextafter_1_finite(v128_t res, v128_t c) {
	v128_t to_round = wasm_f64x2_lt(res, wasm_f64x2_const(0.0, 0.0)); // res < 0.0
	v128_t is_zero = wasm_f64x2_eq(c, wasm_f64x2_const(0.0, 0.0)); // c == 0.0

	v128_t k = wasm_i64x2_add(c, wasm_v128_or(wasm_f64x2_gt(c, wasm_f64x2_const(0.0, 0.0)), wasm_i64x2_const(1, 1)));
	k = wasm_v128_bitselect(wasm_i32x4_const(0x80000000, 1, 0x80000000, 1), k, is_zero); // is_zero ? +-minsubnormal : k

	// to_round ? k : c
	return wasm_v128_bitselect(k, c, to_round);
}

// toward positive infinity
static inline v128_t nextafter_2_finite(v128_t res, v128_t c) {
	v128_t to_round = wasm_f64x2_gt(res, wasm_f64x2_const(0.0, 0.0)); // res > 0.0
	v128_t is_zero = wasm_f64x2_eq(c, wasm_f64x2_const(0.0, 0.0)); // c == 0.0

	v128_t k = wasm_i64x2_add(c, wasm_v128_or(wasm_f64x2_lt(c, wasm_f64x2_const(0.0, 0.0)), wasm_i64x2_const(1, 1)));
	k = wasm_v128_bitselect(wasm_i32x4_const(0x00000000, 1, 0x00000000, 1), k, is_zero); // is_zero ? +-minsubnormal : k

	// to_round ? k : c
	return wasm_v128_bitselect(k, c, to_round);
}

// toward zero
static inline v128_t nextafter_3_finite(v128_t res, v128_t c) {
	// if (res > 0.0 && c < 0.0) || (res < 0.0 && c > 0.0)
	v128_t to_round = wasm_v128_or(
		wasm_v128_and(wasm_f64x2_gt(res, wasm_f64x2_const(0.0, 0.0)), wasm_f64x2_lt(c, wasm_f64x2_const(0.0, 0.0))),
		wasm_v128_and(wasm_f64x2_lt(res, wasm_f64x2_const(0.0, 0.0)), wasm_f64x2_gt(c, wasm_f64x2_const(0.0, 0.0)))
	);
	v128_t is_zero = wasm_f64x2_eq(c, wasm_f64x2_const(0.0, 0.0)); // c == 0.0

	v128_t k = wasm_i64x2_sub(c, wasm_i64x2_const(1, 1));
	k = wasm_v128_bitselect(wasm_f64x2_const(0.0, 0.0), k, is_zero); // is_zero ? 0 : k

	// to_round ? k : c
	return wasm_v128_bitselect(k, c, to_round);
}

// toward negative infinity
static inline v128_t nextafter_1_nozero(v128_t res, v128_t c) {
	v128_t to_round = wasm_f64x2_lt(res, wasm_f64x2_const(0.0, 0.0)); // res < 0.0
	v128_t k = wasm_i64x2_add(c, wasm_v128_or(wasm_f64x2_gt(c, wasm_f64x2_const(0.0, 0.0)), wasm_i64x2_const(1, 1)));

	// to_round ? k : c
	return wasm_v128_bitselect(k, c, to_round);
}

// toward positive infinity
static inline v128_t nextafter_2_nozero(v128_t res, v128_t c) {
	v128_t to_round = wasm_f64x2_gt(res, wasm_f64x2_const(0.0, 0.0)); // res > 0.0
	v128_t k = wasm_i64x2_add(c, wasm_v128_or(wasm_f64x2_lt(c, wasm_f64x2_const(0.0, 0.0)), wasm_i64x2_const(1, 1)));

	// to_round ? k : c
	return wasm_v128_bitselect(k, c, to_round);
}

// toward zero
static inline v128_t nextafter_3_nozero(v128_t res, v128_t c) {
	// if (res > 0.0 && c < 0.0) || (res < 0.0 && c > 0.0)
	v128_t to_round = wasm_v128_or(
		wasm_v128_and(wasm_f64x2_gt(res, wasm_f64x2_const(0.0, 0.0)), wasm_f64x2_lt(c, wasm_f64x2_const(0.0, 0.0))),
		wasm_v128_and(wasm_f64x2_lt(res, wasm_f64x2_const(0.0, 0.0)), wasm_f64x2_gt(c, wasm_f64x2_const(0.0, 0.0)))
	);
	v128_t k = wasm_i64x2_sub(c, wasm_i64x2_const(1, 1));

	// to_round ? k : c
	return wasm_v128_bitselect(k, c, to_round);
}

WASM_EXPORT("fadd_1")
v128_t fadd_1(v128_t dest, v128_t src) {
	v128_t c = wasm_f64x2_add(dest, src);
	v128_t res = sum_residue(dest, src, c);
	return nextafter_1_finite(res, c);
}

WASM_EXPORT("fadd_2")
v128_t fadd_2(v128_t dest, v128_t src) {
	v128_t c = wasm_f64x2_add(dest, src);
	v128_t res = sum_residue(dest, src, c);
	return nextafter_2_finite(res, c);
}

WASM_EXPORT("fadd_3")
v128_t fadd_3(v128_t dest, v128_t src) {
	v128_t c = wasm_f64x2_add(dest, src);
	v128_t res = sum_residue(dest, src, c);
	return nextafter_3_finite(res, c);
}

WASM_EXPORT("fsub_1")
v128_t fsub_1(v128_t dest, v128_t src) {
	v128_t c = wasm_f64x2_sub(dest, src);
	v128_t res = sum_residue(dest, wasm_f64x2_neg(src), c);
	return nextafter_1_finite(res, c);
}

WASM_EXPORT("fsub_2")
v128_t fsub_2(v128_t dest, v128_t src) {
	v128_t c = wasm_f64x2_sub(dest, src);
	v128_t res = sum_residue(dest, wasm_f64x2_neg(src), c);
	return nextafter_2_finite(res, c);
}

WASM_EXPORT("fsub_3")
v128_t fsub_3(v128_t dest, v128_t src) {
	v128_t c = wasm_f64x2_sub(dest, src);
	v128_t res = sum_residue(dest, wasm_f64x2_neg(src), c);
	return nextafter_3_finite(res, c);
}

static inline v128_t upper_half(v128_t x) {
	v128_t secator = wasm_f64x2_const(134217729.0, 134217729.0);
	v128_t p = wasm_f64x2_mul(x, secator);
	return wasm_f64x2_add(p, wasm_f64x2_sub(x, p));
}

static inline v128_t mul_residue(v128_t a, v128_t b, v128_t c) {
	v128_t aup = upper_half(a);
	v128_t alo = wasm_f64x2_sub(a, aup);
	v128_t bup = upper_half(b);
	v128_t blo = wasm_f64x2_sub(b, bup);

	v128_t high = wasm_f64x2_mul(aup, bup); 
	v128_t mid = wasm_f64x2_add(wasm_f64x2_mul(aup, blo), wasm_f64x2_mul(alo, bup));
	v128_t low = wasm_f64x2_mul(alo, blo);
	v128_t ab = wasm_f64x2_add(high, mid);
	v128_t resab = wasm_f64x2_add(wasm_f64x2_sub(high, ab), mid);
	resab = wasm_f64x2_add(resab, low);

	v128_t fma = wasm_f64x2_sub(ab, c); // a*b - c
	return wasm_f64x2_add(resab, fma);
}

// assume no NaN, subnormal, inf, or zero
static inline v128_t frexp_reg_e_nozero_noinf(v128_t x, v128_t *eptr) {
	/* int hx, ix, lx;
	hx = __HI(x);
	ix = 0x7fffffff & hx;
	lx = __LO(x);
	*eptr = 0;
	*eptr += (ix >> 20) - 1022;
	hx = (hx & 0x800fffff) | 0x3fe00000;
	__HI(x) = hx;
	return x; */

	v128_t ix = wasm_v128_and(x, wasm_i32x4_const(0x7ff00000, 0, 0x7ff00000, 0));
	*eptr = wasm_i64x2_sub(ix, wasm_i64x2_const(UINT64_C(1022) << 52, UINT64_C(1022) << 52));

	v128_t hx = wasm_v128_and(x, wasm_i32x4_const(0x800fffff, 0xFFFFFFFF, 0x800fffff, 0xFFFFFFFF));
	hx = wasm_v128_or(hx, wasm_i32x4_const(0x3fe00000, 0, 0x3fe00000, 0));
	return hx;
}

// assume no NaN, subnormal, inf, or zero
static inline v128_t ldexp_reg_e_nozero_noinf(v128_t x, v128_t n) {
	/* int hx, k;
	hx = __HI(x);
	k = (hx & 0x7ff00000) >> 20;
	k += n;
	__HI(x) = (hx & 0x800fffff) | (k << 20);
	return x; */

	// n mask only to exponent

	v128_t k = wasm_i64x2_add(wasm_v128_and(x, wasm_i32x4_const(0x7ff00000, 0, 0x7ff00000, 0)), n);
	k = wasm_v128_and(k, wasm_i32x4_const(0x7ff00000, 0, 0x7ff00000, 0));
	v128_t hx = wasm_v128_and(x, wasm_i32x4_const(0x800fffff, 0xFFFFFFFF, 0x800fffff, 0xFFFFFFFF));
	hx = wasm_v128_or(hx, k);

	return hx;
}

/* double fmul_1(double a, double b) {
	double c = a * b;

	int expa, expb;
	double a_scaled = frexp_reg_e_nozero_noinf(a, &expa);
	double b_scaled = frexp_reg_e_nozero_noinf(b, &expb);
	double c_scaled = ldexp_reg_e_nozero_noinf(c, -expa - expb);
	double res = mul_residue(a_scaled, b_scaled, c_scaled);
	
	if (!isfinite(c)) {
		// fin * fin = _inf_; round down to the nearest representable number
		if (isfinite(a) && isfinite(b)) {
			res = -1.0; // rounding down
		} else {
			// inf * inf = inf
			res = 0.0; // no rounding
		}
	}

	if (res < 0.0) {
		fmul_1_taken++;
		return nextafter_1_reg_e(c);
	}

	return c;
} */

v128_t fmul_1(v128_t dest, v128_t src) {
	v128_t c = wasm_f64x2_mul(dest, src);

	v128_t expa, expb;
	v128_t a_scaled = frexp_reg_e_nozero_noinf(dest, &expa);
	v128_t b_scaled = frexp_reg_e_nozero_noinf(src, &expb);
	v128_t c_scaled = ldexp_reg_e_nozero_noinf(c, wasm_i64x2_sub(wasm_i64x2_neg(expa), expb));
	v128_t res = mul_residue(a_scaled, b_scaled, c_scaled);

	// infinities absolutely unlikely. 0.003414% of all cases
	// TODO: there is a possibility that gating this behind a branch will be faster

	// check isinf (entire exponent set)
	v128_t isinf = wasm_f64x2_eq(c, wasm_f64x2_const(INFINITY, INFINITY));
	v128_t isfinite_a = wasm_f64x2_ne(dest, wasm_f64x2_const(INFINITY, INFINITY));
	// do not check for finite on `b` as it is not needed

	// fin * fin = _inf_; round down to the nearest representable number
	// inf * fin = inf
	//
	// res = isinf ? (isfinite_a ? -1.0 : 1.0) : res
	//                             ^^^^   ^^^
	//                    rounding down   no rounding
	v128_t res_isinf = wasm_v128_bitselect(wasm_f64x2_const(-1.0, -1.0), wasm_f64x2_const(1.0, 1.0), isfinite_a);
	res = wasm_v128_bitselect(res_isinf, res, isinf);

	printf("c: %f %f\n", wasm_f64x2_extract_lane(c, 0), wasm_f64x2_extract_lane(c, 1));
	printf("res: %f %f\n", wasm_f64x2_extract_lane(res, 0), wasm_f64x2_extract_lane(res, 1));

	return nextafter_1_nozero(res, c);
}

// apparently for rounding up with [1, inf) nearest ties to even is equivalent??
// UPDATE:  fprc(2): 6clks [19999/20000] x0 overhead
//          FAIL: [fmul fprc(2)] truth(0x1.f7ed5b2af7643p-256, 0x1.80748f83f0b63p+30) == 0x1.7a64bd6788632p-225 != op(...) == 0x1.7a64bd6788631p-225
v128_t fmul_2(v128_t dest, v128_t src) {
	return wasm_f64x2_mul(dest, src);
}

v128_t fmul_3(v128_t dest, v128_t src) {
	return wasm_f64x2_mul(dest, src);
}
