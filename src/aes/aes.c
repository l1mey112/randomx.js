#include "aes.h"
#include "wasm.h"

#include <stdint.h>
#include <wasm_simd128.h>

// AesGenerator1R:
// key0, key1, key2, key3 = Blake2b-512("RandomX AesGenerator1R keys")

#define AES_GEN_1R_KEY0 0xb4f44917, 0xdbb5552b, 0x62716609, 0x6daca553
#define AES_GEN_1R_KEY1 0x0da1dc4e, 0x1725d378, 0x846a710d, 0x6d7caf07
#define AES_GEN_1R_KEY2 0x3e20e345, 0xf4c0794f, 0x9f947ec6, 0x3f1262f1
#define AES_GEN_1R_KEY3 0x49169154, 0x16314c88, 0xb1ba317c, 0x6aef8135

// AesGenerator4R:
// key0, key1, key2, key3 = Blake2b-512("RandomX AesGenerator4R keys 0-3")
// key4, key5, key6, key7 = Blake2b-512("RandomX AesGenerator4R keys 4-7")

#define AES_GEN_4R_KEY0 0x99e5d23f, 0x2f546d2b, 0xd1833ddb, 0x6421aadd
#define AES_GEN_4R_KEY1 0xa5dfcde5, 0x06f79d53, 0xb6913f55, 0xb20e3450
#define AES_GEN_4R_KEY2 0x171c02bf, 0x0aa4679f, 0x515e7baf, 0x5c3ed904
#define AES_GEN_4R_KEY3 0xd8ded291, 0xcd673785, 0xe78f5d08, 0x85623763
#define AES_GEN_4R_KEY4 0x229effb4, 0x3d518b6d, 0xe3d6a7a6, 0xb5826f73
#define AES_GEN_4R_KEY5 0xb272b7d2, 0xe9024d4e, 0x9c10b3d9, 0xc7566bf3
#define AES_GEN_4R_KEY6 0xf63befa7, 0x2ba9660a, 0xf765a38b, 0xf273c9e7
#define AES_GEN_4R_KEY7 0xc0b0762d, 0x0c06d1fd, 0x915839de, 0x7a7cd609

/*
    Fill 'buffer' with pseudorandom data based on 512-bit 'state'.
    The state is encrypted using a single AES round per 16 bytes of output
    in 4 lanes.

    'outputSize' must be a multiple of 64.

    The modified state is written back to 'state' to allow multiple
    calls to this function.
*/
void fillAes1Rx4(uint8_t state[64], uint32_t output_size, uint8_t *buffer) {
	assume(output_size % 64 == 0);

	const uint8_t *outptr = (uint8_t *)buffer;
	const uint8_t *outputEnd = outptr + output_size;

	v128_t state0, state1, state2, state3;
	v128_t key0, key1, key2, key3;

	key0 = wasm_i32x4_make(AES_GEN_1R_KEY0);
	key1 = wasm_i32x4_make(AES_GEN_1R_KEY1);
	key2 = wasm_i32x4_make(AES_GEN_1R_KEY2);
	key3 = wasm_i32x4_make(AES_GEN_1R_KEY3);

	state0 = wasm_v128_load((v128_t *)state + 0);
	state1 = wasm_v128_load((v128_t *)state + 1);
	state2 = wasm_v128_load((v128_t *)state + 2);
	state3 = wasm_v128_load((v128_t *)state + 3);

	while (outptr < outputEnd) {
		state0 = soft_aesdec(state0, key0);
		state1 = soft_aesenc(state1, key1);
		state2 = soft_aesdec(state2, key2);
		state3 = soft_aesenc(state3, key3);

		wasm_v128_store((v128_t *)outptr + 0, state0);
		wasm_v128_store((v128_t *)outptr + 1, state1);
		wasm_v128_store((v128_t *)outptr + 2, state2);
		wasm_v128_store((v128_t *)outptr + 3, state3);

		outptr += 64;
	}

	wasm_v128_store((v128_t *)state + 0, state0);
	wasm_v128_store((v128_t *)state + 1, state1);
	wasm_v128_store((v128_t *)state + 2, state2);
	wasm_v128_store((v128_t *)state + 3, state3);
}

void fillAes4Rx4(uint8_t state[64], uint32_t output_size, uint8_t *buffer) {
	assume(output_size % 64 == 0);

	const uint8_t *outptr = (uint8_t *)buffer;
	const uint8_t *outputEnd = outptr + output_size;

	v128_t state0, state1, state2, state3;
	v128_t key0, key1, key2, key3, key4, key5, key6, key7;

	key0 = wasm_i32x4_make(AES_GEN_4R_KEY0);
	key1 = wasm_i32x4_make(AES_GEN_4R_KEY1);
	key2 = wasm_i32x4_make(AES_GEN_4R_KEY2);
	key3 = wasm_i32x4_make(AES_GEN_4R_KEY3);
	key4 = wasm_i32x4_make(AES_GEN_4R_KEY4);
	key5 = wasm_i32x4_make(AES_GEN_4R_KEY5);
	key6 = wasm_i32x4_make(AES_GEN_4R_KEY6);
	key7 = wasm_i32x4_make(AES_GEN_4R_KEY7);

	state0 = wasm_v128_load((v128_t *)state + 0);
	state1 = wasm_v128_load((v128_t *)state + 1);
	state2 = wasm_v128_load((v128_t *)state + 2);
	state3 = wasm_v128_load((v128_t *)state + 3);

	while (outptr < outputEnd) {
		state0 = soft_aesdec(state0, key0);
		state1 = soft_aesenc(state1, key0);
		state2 = soft_aesdec(state2, key4);
		state3 = soft_aesenc(state3, key4);

		state0 = soft_aesdec(state0, key1);
		state1 = soft_aesenc(state1, key1);
		state2 = soft_aesdec(state2, key5);
		state3 = soft_aesenc(state3, key5);

		state0 = soft_aesdec(state0, key2);
		state1 = soft_aesenc(state1, key2);
		state2 = soft_aesdec(state2, key6);
		state3 = soft_aesenc(state3, key6);

		state0 = soft_aesdec(state0, key3);
		state1 = soft_aesenc(state1, key3);
		state2 = soft_aesdec(state2, key7);
		state3 = soft_aesenc(state3, key7);

		wasm_v128_store((v128_t *)outptr + 0, state0);
		wasm_v128_store((v128_t *)outptr + 1, state1);
		wasm_v128_store((v128_t *)outptr + 2, state2);
		wasm_v128_store((v128_t *)outptr + 3, state3);

		outptr += 64;
	}
}
