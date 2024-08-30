#include "argon2fill.h"
#include "wasm.h"

#include <stdint.h>
#include <wasm_simd128.h>

#define r16 (wasm_i8x16_make(2, 3, 4, 5, 6, 7, 0, 1, 10, 11, 12, 13, 14, 15, 8, 9))
#define r24 (wasm_i8x16_make(3, 4, 5, 6, 7, 0, 1, 2, 11, 12, 13, 14, 15, 8, 9, 10))
#define _MM_SHUFFLE(w, z, y, x) (((w) << 6) | ((z) << 4) | ((y) << 2) | (x))

#define THIN __attribute__((__always_inline__, __nodebug__))

static inline v128_t THIN
wasm_mm_shuffle_epi8(v128_t __a, v128_t __b) {
	return wasm_i8x16_swizzle(__a, wasm_v128_and(__b, wasm_i8x16_splat(0x8F)));
}

static inline v128_t THIN
wasm_mm_srli_epi64(v128_t __a, int __count) {
	return ((unsigned int)__count < 64) ? wasm_u64x2_shr(__a, __count) : wasm_i64x2_const(0, 0);
}

#define wasm_mm_shuffle_epi32(__a, __imm) __extension__({ wasm_i32x4_shuffle((__a),                               \
		                                                                     wasm_i32x4_splat(0),                 \
		                                                                     ((__imm)&0x3), (((__imm)&0xc) >> 2), \
		                                                                     (((__imm)&0x30) >> 4), (((__imm)&0xc0) >> 6)); })

static inline v128_t THIN
wasm_mm_slli_epi64(v128_t __a, int __count) {
	return ((__count < 64) ? wasm_i64x2_shl(__a, __count) : wasm_i64x2_const(0, 0));
}

static inline v128_t THIN
wasm_mm_mul_epu32(v128_t __a, v128_t __b) {
	return wasm_u64x2_extmul_low_u32x4(wasm_i32x4_shuffle(__a, __a, 0, 2, 0, 2), wasm_i32x4_shuffle(__b, __b, 0, 2, 0, 2));
}

#define wasm_mm_roti_epi64(x, c)                              \
	(-(c) == 32)                                              \
		? wasm_mm_shuffle_epi32((x), _MM_SHUFFLE(2, 3, 0, 1)) \
	: (-(c) == 24)                                            \
		? wasm_mm_shuffle_epi8((x), r24)                      \
	: (-(c) == 16)                                            \
		? wasm_mm_shuffle_epi8((x), r16)                      \
	: (-(c) == 63)                                            \
		? wasm_v128_xor(wasm_mm_srli_epi64((x), -(c)),        \
	                    wasm_i64x2_add((x), (x)))             \
		: wasm_v128_xor(wasm_mm_srli_epi64((x), -(c)),        \
	                    wasm_mm_slli_epi64((x), 64 - (-(c))))

static inline v128_t fBlaMka(v128_t x, v128_t y) {
	const v128_t z = wasm_mm_mul_epu32(x, y);
	return wasm_i64x2_add(wasm_i64x2_add(x, y), wasm_i64x2_add(z, z));
}

#define G1(A0, B0, C0, D0, A1, B1, C1, D1) \
	do {                                   \
		A0 = fBlaMka(A0, B0);              \
		A1 = fBlaMka(A1, B1);              \
                                           \
		D0 = wasm_v128_xor(D0, A0);        \
		D1 = wasm_v128_xor(D1, A1);        \
                                           \
		D0 = wasm_mm_roti_epi64(D0, -32);  \
		D1 = wasm_mm_roti_epi64(D1, -32);  \
                                           \
		C0 = fBlaMka(C0, D0);              \
		C1 = fBlaMka(C1, D1);              \
                                           \
		B0 = wasm_v128_xor(B0, C0);        \
		B1 = wasm_v128_xor(B1, C1);        \
                                           \
		B0 = wasm_mm_roti_epi64(B0, -24);  \
		B1 = wasm_mm_roti_epi64(B1, -24);  \
	} while (0)

#define G2(A0, B0, C0, D0, A1, B1, C1, D1) \
	do {                                   \
		A0 = fBlaMka(A0, B0);              \
		A1 = fBlaMka(A1, B1);              \
                                           \
		D0 = wasm_v128_xor(D0, A0);        \
		D1 = wasm_v128_xor(D1, A1);        \
                                           \
		D0 = wasm_mm_roti_epi64(D0, -16);  \
		D1 = wasm_mm_roti_epi64(D1, -16);  \
                                           \
		C0 = fBlaMka(C0, D0);              \
		C1 = fBlaMka(C1, D1);              \
                                           \
		B0 = wasm_v128_xor(B0, C0);        \
		B1 = wasm_v128_xor(B1, C1);        \
                                           \
		B0 = wasm_mm_roti_epi64(B0, -63);  \
		B1 = wasm_mm_roti_epi64(B1, -63);  \
	} while (0)

#define _mm_srli_si128(__a, __imm) __extension__({ (v128_t) wasm_i8x16_shuffle((__a),                                    \
		                                                                       wasm_i64x2_const(0, 0),                   \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 0,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 1,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 2,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 3,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 4,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 5,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 6,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 7,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 8,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 9,  \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 10, \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 11, \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 12, \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 13, \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 14, \
		                                                                       ((__imm)&0xF0) ? 16 : ((__imm)&0xF) + 15); })

#define _mm_slli_si128(__a, __imm) __extension__({ (v128_t) wasm_i8x16_shuffle(wasm_i64x2_const(0, 0),                  \
		                                                                       (__a),                                   \
		                                                                       ((__imm)&0xF0) ? 0 : 16 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 17 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 18 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 19 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 20 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 21 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 22 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 23 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 24 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 25 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 26 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 27 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 28 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 29 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 30 - ((__imm)&0xF), \
		                                                                       ((__imm)&0xF0) ? 0 : 31 - ((__imm)&0xF)); })

#define _mm_bslli_si128(__a, __imm) \
	_mm_slli_si128((__a), (__imm))

#define _mm_bsrli_si128(__a, __imm) \
	_mm_srli_si128((__a), (__imm))

#define _mm_alignr_epi8(__a, __b, __count)                                                                                                             \
	((__count <= 16)                                                                                                                                   \
	     ? (wasm_v128_or(_mm_bslli_si128((__a), 16 - (((unsigned int)(__count)) & 0xFF)), _mm_bsrli_si128((__b), (((unsigned int)(__count)) & 0xFF)))) \
	     : (_mm_bsrli_si128((__a), (((unsigned int)(__count)) & 0xFF) - 16)))

#define DIAGONALIZE(A0, B0, C0, D0, A1, B1, C1, D1) \
	do {                                            \
		v128_t t0 = _mm_alignr_epi8(B1, B0, 8);     \
		v128_t t1 = _mm_alignr_epi8(B0, B1, 8);     \
		B0 = t0;                                    \
		B1 = t1;                                    \
                                                    \
		t0 = C0;                                    \
		C0 = C1;                                    \
		C1 = t0;                                    \
                                                    \
		t0 = _mm_alignr_epi8(D1, D0, 8);            \
		t1 = _mm_alignr_epi8(D0, D1, 8);            \
		D0 = t1;                                    \
		D1 = t0;                                    \
	} while (0)

#define UNDIAGONALIZE(A0, B0, C0, D0, A1, B1, C1, D1) \
	do {                                              \
		v128_t t0 = _mm_alignr_epi8(B0, B1, 8);       \
		v128_t t1 = _mm_alignr_epi8(B1, B0, 8);       \
		B0 = t0;                                      \
		B1 = t1;                                      \
                                                      \
		t0 = C0;                                      \
		C0 = C1;                                      \
		C1 = t0;                                      \
                                                      \
		t0 = _mm_alignr_epi8(D0, D1, 8);              \
		t1 = _mm_alignr_epi8(D1, D0, 8);              \
		D0 = t1;                                      \
		D1 = t0;                                      \
	} while (0)

#define BLAKE2_ROUND(A0, A1, B0, B1, C0, C1, D0, D1)   \
	do {                                               \
		G1(A0, B0, C0, D0, A1, B1, C1, D1);            \
		G2(A0, B0, C0, D0, A1, B1, C1, D1);            \
                                                       \
		DIAGONALIZE(A0, B0, C0, D0, A1, B1, C1, D1);   \
                                                       \
		G1(A0, B0, C0, D0, A1, B1, C1, D1);            \
		G2(A0, B0, C0, D0, A1, B1, C1, D1);            \
                                                       \
		UNDIAGONALIZE(A0, B0, C0, D0, A1, B1, C1, D1); \
	} while (0)

static void fill_block(v128_t *state, const argon2_block_t *ref_block,
                       argon2_block_t *next_block, int with_xor) {
	v128_t block_XY[ARGON2_OWORDS_IN_BLOCK];
	unsigned int i;

	if (with_xor) {
		for (i = 0; i < ARGON2_OWORDS_IN_BLOCK; i++) {
			state[i] = wasm_v128_xor(
				state[i], wasm_v128_load((const v128_t *)ref_block->v + i));
			block_XY[i] = wasm_v128_xor(
				state[i], wasm_v128_load((const v128_t *)next_block->v + i));
		}
	} else {
		for (i = 0; i < ARGON2_OWORDS_IN_BLOCK; i++) {
			block_XY[i] = state[i] = wasm_v128_xor(
				state[i], wasm_v128_load((const v128_t *)ref_block->v + i));
		}
	}

	for (i = 0; i < 8; ++i) {
		BLAKE2_ROUND(state[8 * i + 0], state[8 * i + 1], state[8 * i + 2],
		             state[8 * i + 3], state[8 * i + 4], state[8 * i + 5],
		             state[8 * i + 6], state[8 * i + 7]);
	}

	for (i = 0; i < 8; ++i) {
		BLAKE2_ROUND(state[8 * 0 + i], state[8 * 1 + i], state[8 * 2 + i],
		             state[8 * 3 + i], state[8 * 4 + i], state[8 * 5 + i],
		             state[8 * 6 + i], state[8 * 7 + i]);
	}

	for (i = 0; i < ARGON2_OWORDS_IN_BLOCK; i++) {
		state[i] = wasm_v128_xor(state[i], block_XY[i]);
		wasm_v128_store((v128_t *)next_block->v + i, state[i]);
	}
}

uint32_t randomx_argon2_index_alpha(const argon2_instance_t *instance,
                                    const argon2_position_t *position, uint32_t pseudo_rand,
                                    int same_lane) {
	/*
	 * Pass 0:
	 *      This lane : all already finished segments plus already constructed
	 * blocks in this segment
	 *      Other lanes : all already finished segments
	 * Pass 1+:
	 *      This lane : (SYNC_POINTS - 1) last segments plus already constructed
	 * blocks in this segment
	 *      Other lanes : (SYNC_POINTS - 1) last segments
	 */
	uint32_t reference_area_size;
	uint64_t relative_position;
	uint32_t start_position, absolute_position;

	if (0 == position->pass) {
		/* First pass */
		if (0 == position->slice) {
			/* First slice */
			reference_area_size =
				position->index - 1; /* all but the previous */
		} else {
			if (same_lane) {
				/* The same lane => add current segment */
				reference_area_size =
					position->slice * instance->segment_length +
					position->index - 1;
			} else {
				reference_area_size =
					position->slice * instance->segment_length +
					((position->index == 0) ? (-1) : 0);
			}
		}
	} else {
		/* Second pass */
		if (same_lane) {
			reference_area_size = instance->lane_length -
			                      instance->segment_length + position->index -
			                      1;
		} else {
			reference_area_size = instance->lane_length -
			                      instance->segment_length +
			                      ((position->index == 0) ? (-1) : 0);
		}
	}

	/* 1.2.4. Mapping pseudo_rand to 0..<reference_area_size-1> and produce
	 * relative position */
	relative_position = pseudo_rand;
	relative_position = relative_position * relative_position >> 32;
	relative_position = reference_area_size - 1 -
	                    (reference_area_size * relative_position >> 32);

	/* 1.2.5 Computing starting position */
	start_position = 0;

	if (0 != position->pass) {
		start_position = (position->slice == ARGON2_SYNC_POINTS - 1)
		                     ? 0
		                     : (position->slice + 1) * instance->segment_length;
	}

	/* 1.2.6. Computing absolute position */
	absolute_position = (start_position + relative_position) %
	                    instance->lane_length; /* absolute position */
	return absolute_position;
}

void randomx_argon2_fill_segment_core_impl(const argon2_instance_t *instance, argon2_position_t position) {
	argon2_block_t *ref_block = NULL, *curr_block = NULL;

	uint64_t pseudo_rand, ref_index, ref_lane;
	uint32_t prev_offset, curr_offset;
	uint32_t starting_index;
	uint32_t i;

	v128_t state[ARGON2_OWORDS_IN_BLOCK];

	starting_index = 0;

	if ((0 == position.pass) && (0 == position.slice)) {
		starting_index = 2; /* we have already generated the first two blocks */
	}

	/* Offset of the current block */
	curr_offset = position.lane * instance->lane_length + position.slice * instance->segment_length + starting_index;

	if (0 == curr_offset % instance->lane_length) {
		/* Last block in this lane */
		prev_offset = curr_offset + instance->lane_length - 1;
	} else {
		/* Previous block */
		prev_offset = curr_offset - 1;
	}

	memcpy(state, ((instance->memory + prev_offset)->v), ARGON2_BLOCK_SIZE);

	for (i = starting_index; i < instance->segment_length; ++i, ++curr_offset, ++prev_offset) {
		/*1.1 Rotating prev_offset if needed */
		if (curr_offset % instance->lane_length == 1) {
			prev_offset = curr_offset - 1;
		}

		/* 1.2 Computing the index of the reference block */
		/* 1.2.1 Taking pseudo-random value from the previous block */
		pseudo_rand = instance->memory[prev_offset].v[0];

		/* 1.2.2 Computing the lane of the reference block */
		ref_lane = ((pseudo_rand >> 32)) % instance->lanes;

		if ((position.pass == 0) && (position.slice == 0)) {
			/* Can not reference other lanes yet */
			ref_lane = position.lane;
		}

		/* 1.2.3 Computing the number of possible reference block within the
		 * lane.
		 */
		position.index = i;
		ref_index = randomx_argon2_index_alpha(instance, &position, pseudo_rand & 0xFFFFFFFF, ref_lane == position.lane);

		/* 2 Creating a new block */
		ref_block = instance->memory + instance->lane_length * ref_lane + ref_index;
		curr_block = instance->memory + curr_offset;

		// always assumed to != ARGON2_VERSION_10
		// if (ARGON2_VERSION_10 == instance->version) {
		// /* version 1.2.1 and earlier: overwrite, not XOR */

		if (0 == position.pass) {
			fill_block(state, ref_block, curr_block, 0);
		} else {
			fill_block(state, ref_block, curr_block, 1);
		}
	}
}
