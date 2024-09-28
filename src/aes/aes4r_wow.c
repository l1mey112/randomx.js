#include "aes.h"
#include "freestanding.h"

#include <stdint.h>
#include <wasm_simd128.h>

// AesGenerator4R:
// NOTE: RandomWOW uses a different set of keys, and a simpler fillAes4Rx4
#define AES_GEN_4R_KEY0 0xcf359e95, 0x141f82b7, 0x7ffbe4a6, 0xf890465d
#define AES_GEN_4R_KEY1 0x6741ffdc, 0xbd5c5ac3, 0xfee8278a, 0x6a55c450
#define AES_GEN_4R_KEY2 0x3d324aac, 0xa7279ad2, 0xd524fde4, 0x114c47a4
#define AES_GEN_4R_KEY3 0x76f6db08, 0x42d3dbd9, 0x99a9aeff, 0x810c3a2a

void fillAes4Rx4(const uint8_t state[64], uint32_t output_size, uint8_t *buffer) {
	assume(output_size % 64 == 0);

	const uint8_t *outptr = (uint8_t *)buffer;
	const uint8_t *output_end = outptr + output_size;

	v128_t state0, state1, state2, state3;
	v128_t key0, key1, key2, key3;

	key0 = I32x2_MAKE_TRANSPOSE(AES_GEN_4R_KEY0);
	key1 = I32x2_MAKE_TRANSPOSE(AES_GEN_4R_KEY1);
	key2 = I32x2_MAKE_TRANSPOSE(AES_GEN_4R_KEY2);
	key3 = I32x2_MAKE_TRANSPOSE(AES_GEN_4R_KEY3);

	state0 = wasm_v128_load((v128_t *)state + 0);
	state1 = wasm_v128_load((v128_t *)state + 1);
	state2 = wasm_v128_load((v128_t *)state + 2);
	state3 = wasm_v128_load((v128_t *)state + 3);

	while (outptr < output_end) {
		state0 = soft_aesdec(state0, key0);
		state1 = soft_aesenc(state1, key0);
		state2 = soft_aesdec(state2, key0);
		state3 = soft_aesenc(state3, key0);

		state0 = soft_aesdec(state0, key1);
		state1 = soft_aesenc(state1, key1);
		state2 = soft_aesdec(state2, key1);
		state3 = soft_aesenc(state3, key1);

		state0 = soft_aesdec(state0, key2);
		state1 = soft_aesenc(state1, key2);
		state2 = soft_aesdec(state2, key2);
		state3 = soft_aesenc(state3, key2);

		state0 = soft_aesdec(state0, key3);
		state1 = soft_aesenc(state1, key3);
		state2 = soft_aesdec(state2, key3);
		state3 = soft_aesenc(state3, key3);

		wasm_v128_store((v128_t *)outptr + 0, state0);
		wasm_v128_store((v128_t *)outptr + 1, state1);
		wasm_v128_store((v128_t *)outptr + 2, state2);
		wasm_v128_store((v128_t *)outptr + 3, state3);

		outptr += 64;
	}
}