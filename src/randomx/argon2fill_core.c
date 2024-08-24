#include "argon2fill.h"
#include "wasm.h"

#include <stdint.h>

static inline uint64_t fBlaMka(uint64_t x, uint64_t y) {
	const uint64_t m = 0xFFFFFFFFUL;
	const uint64_t xy = (x & m) * (y & m);
	return x + y + 2 * xy;
}

#define G(a, b, c, d)          \
	do {                       \
		a = fBlaMka(a, b);     \
		d = rotr64(d ^ a, 32); \
		c = fBlaMka(c, d);     \
		b = rotr64(b ^ c, 24); \
		a = fBlaMka(a, b);     \
		d = rotr64(d ^ a, 16); \
		c = fBlaMka(c, d);     \
		b = rotr64(b ^ c, 63); \
	} while ((void)0, 0)

#define BLAKE2_ROUND_NOMSG(v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, \
                           v12, v13, v14, v15)                               \
	do {                                                                     \
		G(v0, v4, v8, v12);                                                  \
		G(v1, v5, v9, v13);                                                  \
		G(v2, v6, v10, v14);                                                 \
		G(v3, v7, v11, v15);                                                 \
		G(v0, v5, v10, v15);                                                 \
		G(v1, v6, v11, v12);                                                 \
		G(v2, v7, v8, v13);                                                  \
		G(v3, v4, v9, v14);                                                  \
	} while ((void)0, 0)

static void xor_block(argon2_block_t *dst, const argon2_block_t *src) {
	int i;
	for (i = 0; i < ARGON2_QWORDS_IN_BLOCK; ++i) {
		dst->v[i] ^= src->v[i];
	}
}

/*
 * Function fills a new memory block and optionally XORs the old block over the new one.
 * @next_block must be initialized.
 * @param prev_block Pointer to the previous block
 * @param ref_block Pointer to the reference block
 * @param next_block Pointer to the block to be constructed
 * @param with_xor Whether to XOR into the new block (1) or just overwrite (0)
 * @pre all block pointers must be valid
 */
static void fill_block(const argon2_block_t *prev_block, const argon2_block_t *ref_block,
                       argon2_block_t *next_block, int with_xor) {
	argon2_block_t blockR, block_tmp;
	unsigned i;

	memcpy(blockR.v, ref_block->v, ARGON2_BLOCK_SIZE);
	xor_block(&blockR, prev_block);
	memcpy(&block_tmp, &blockR, ARGON2_BLOCK_SIZE);

	/* Now blockR = ref_block + prev_block and block_tmp = ref_block + prev_block */
	if (with_xor) {
		/* Saving the next block contents for XOR over: */
		xor_block(&block_tmp, next_block);
		/* Now blockR = ref_block + prev_block and
		   block_tmp = ref_block + prev_block + next_block */
	}

	/* Apply Blake2 on columns of 64-bit words: (0,1,...,15) , then
	   (16,17,..31)... finally (112,113,...127) */
	for (i = 0; i < 8; ++i) {
		BLAKE2_ROUND_NOMSG(
			blockR.v[16 * i], blockR.v[16 * i + 1], blockR.v[16 * i + 2],
			blockR.v[16 * i + 3], blockR.v[16 * i + 4], blockR.v[16 * i + 5],
			blockR.v[16 * i + 6], blockR.v[16 * i + 7], blockR.v[16 * i + 8],
			blockR.v[16 * i + 9], blockR.v[16 * i + 10], blockR.v[16 * i + 11],
			blockR.v[16 * i + 12], blockR.v[16 * i + 13], blockR.v[16 * i + 14],
			blockR.v[16 * i + 15]);
	}

	/* Apply Blake2 on rows of 64-bit words: (0,1,16,17,...112,113), then
	   (2,3,18,19,...,114,115).. finally (14,15,30,31,...,126,127) */
	for (i = 0; i < 8; i++) {
		BLAKE2_ROUND_NOMSG(
			blockR.v[2 * i], blockR.v[2 * i + 1], blockR.v[2 * i + 16],
			blockR.v[2 * i + 17], blockR.v[2 * i + 32], blockR.v[2 * i + 33],
			blockR.v[2 * i + 48], blockR.v[2 * i + 49], blockR.v[2 * i + 64],
			blockR.v[2 * i + 65], blockR.v[2 * i + 80], blockR.v[2 * i + 81],
			blockR.v[2 * i + 96], blockR.v[2 * i + 97], blockR.v[2 * i + 112],
			blockR.v[2 * i + 113]);
	}

	memcpy(next_block->v, block_tmp.v, ARGON2_BLOCK_SIZE);
	xor_block(next_block, &blockR);
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

	if (instance == NULL) {
		return;
	}

	starting_index = 0;

	if ((0 == position.pass) && (0 == position.slice)) {
		starting_index = 2; /* we have already generated the first two blocks */
	}

	/* Offset of the current block */
	curr_offset = position.lane * instance->lane_length +
	              position.slice * instance->segment_length + starting_index;

	if (0 == curr_offset % instance->lane_length) {
		/* Last block in this lane */
		prev_offset = curr_offset + instance->lane_length - 1;
	} else {
		/* Previous block */
		prev_offset = curr_offset - 1;
	}

	for (i = starting_index; i < instance->segment_length;
	     ++i, ++curr_offset, ++prev_offset) {
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
		ref_index = randomx_argon2_index_alpha(instance, &position, pseudo_rand & 0xFFFFFFFF,
		                                       ref_lane == position.lane);

		/* 2 Creating a new block */
		ref_block =
			instance->memory + instance->lane_length * ref_lane + ref_index;
		curr_block = instance->memory + curr_offset;

		// always assumed to != ARGON2_VERSION_10
		// if (ARGON2_VERSION_10 == instance->version) {
		// /* version 1.2.1 and earlier: overwrite, not XOR */

		if (0 == position.pass) {
			fill_block(instance->memory + prev_offset, ref_block,
			           curr_block, 0);
		} else {
			fill_block(instance->memory + prev_offset, ref_block,
			           curr_block, 1);
		}
	}
}
