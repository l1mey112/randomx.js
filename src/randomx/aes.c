#include "wasm.h"

#include <stdint.h>
#include <wasm_simd128.h>

// AesGenerator1R:
// key0, key1, key2, key3 = Blake2b-512("RandomX AesGenerator1R keys")

#define AES_GEN_1R_KEY0 0xb4f44917, 0xdbb5552b, 0x62716609, 0x6daca553
#define AES_GEN_1R_KEY1 0x0da1dc4e, 0x1725d378, 0x846a710d, 0x6d7caf07
#define AES_GEN_1R_KEY2 0x3e20e345, 0xf4c0794f, 0x9f947ec6, 0x3f1262f1
#define AES_GEN_1R_KEY3 0x49169154, 0x16314c88, 0xb1ba317c, 0x6aef8135

/*
    Fill 'buffer' with pseudorandom data based on 512-bit 'state'.
    The state is encrypted using a single AES round per 16 bytes of output
    in 4 lanes.

    'outputSize' must be a multiple of 64.

    The modified state is written back to 'state' to allow multiple
    calls to this function.
*/
/* void fillAes1Rx4(void *restrict state, uint32_t outputSize, void *restrict buffer) {
	// outputSize &= ~63;
	assume(outputSize % 64 == 0);
	const uint8_t* outptr = (uint8_t*)buffer;
	const uint8_t* outputEnd = outptr + outputSize;

	v128_t state0, state1, state2, state3;
	v128_t key0, key1, key2, key3;

	key0 = wasm_i32x4_make(AES_GEN_1R_KEY0);
	key1 = wasm_i32x4_make(AES_GEN_1R_KEY1);
	key2 = wasm_i32x4_make(AES_GEN_1R_KEY2);
	key3 = wasm_i32x4_make(AES_GEN_1R_KEY3);

	state0 = wasm_v128_load((v128_t*)state + 0);
	state1 = wasm_v128_load((v128_t*)state + 1);
	state2 = wasm_v128_load((v128_t*)state + 2);
	state3 = wasm_v128_load((v128_t*)state + 3);

	while (outptr < outputEnd) {
		state0 = aesdec(state0, key0);
		state1 = aesenc(state1, key1);
		state2 = aesdec(state2, key2);
		state3 = aesenc(state3, key3);

		wasm_v128_store((v128_t*)outptr + 0, state0);
		wasm_v128_store((v128_t*)outptr + 1, state1);
		wasm_v128_store((v128_t*)outptr + 2, state2);
		wasm_v128_store((v128_t*)outptr + 3, state3);

		outptr += 64;
	}

	wasm_v128_store((v128_t*)state + 0, state0);
	wasm_v128_store((v128_t*)state + 1, state1);
	wasm_v128_store((v128_t*)state + 2, state2);
	wasm_v128_store((v128_t*)state + 3, state3);
} */
