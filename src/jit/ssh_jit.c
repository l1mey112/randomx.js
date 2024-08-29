#include "../dataset/ssh.h"
#include "wasm_jit.h"

#include <stdint.h>

uint32_t ssh_jit(ss_program_t prog[RANDOMX_CACHE_ACCESSES], uint8_t *buf) {
	uint8_t *p = buf;

	WASM_MAGIC();

	// https://webassembly.github.io/spec/core/binary/modules.html#type-section
	WASM_SECTION(WASM_SECTION_TYPE, {
		WASM_U32_1(); // function types = vec(1)

		WASM_U8_THUNK({
			0x60, // function type 0 : (i32, i32) -> (i64, i64, i64, i64, i64, i64, i64, i64)
			2,    // 2 parameters
			WASM_TYPE_I32,
			WASM_TYPE_I64,
			8, // 8 return values
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			WASM_TYPE_I64,
		});
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-funcsec
	WASM_SECTION(WASM_SECTION_FUNCTION, {
		WASM_U8_THUNK({
			1, // functions = vec(1)
			0, // function 0 = function type 0
		});
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-codesec
	WASM_SECTION(WASM_SECTION_CODE, {
		WASM_U32_1(); // functions = vec(1)

		const uint8_t $cache_ptr = 0, $item_number = 1, $r0 = 2, $r1 = 3, $r2 = 4, $r3 = 5, $r4 = 6, $r5 = 7, $r6 = 8, $r7 = 9;

		// function 1
		WASM_U32_PATCH({
			WASM_U32_1(); // locals entries = vec(1)

			WASM_U8(8); // 8 local variables of type i64
			WASM_U8(WASM_TYPE_I64);

			// r0 = (itemNumber + 1) * 6364136223846793005;
			// r1 = r0 ^ 9298411001130361340;
			// r2 = r0 ^ 12065312585734608966;
			// r3 = r0 ^ 9306329213124626780;
			// r4 = r0 ^ 5281919268842080866;
			// r5 = r0 ^ 10536153434571861004;
			// r6 = r0 ^ 3398623926847679864;
			// r7 = r0 ^ 9549104520008361294;
			WASM_U8_THUNK({
				0x20, $item_number,                                               // local.get $item_number
				0x42, 0x01,                                                       // i64.const 1
				0x7c,                                                             // i64.add
				0x42, 0xad, 0xfe, 0xd5, 0xe4, 0xd4, 0x85, 0xfd, 0xa8, 0xd8, 0x00, // i64.const 6364136223846793005
				0x7e,                                                             // i64.mul
				0x21, $r0,                                                        // local.set $r0
				0x20, $r0,                                                        // local.get $r0
				0x42, 0xfc, 0xc3, 0xd6, 0xcf, 0xa5, 0xf1, 0xa5, 0x85, 0x81, 0x7f, // i64.const 9298411001130361340
				0x85,                                                             // i64.xor
				0x21, $r1,                                                        // local.set $r1
				0x20, $r0,                                                        // local.get $r0
				0x42, 0xc6, 0xb0, 0x8b, 0xc6, 0xf3, 0xbb, 0xa6, 0xb8, 0xa7, 0x7f, // i64.const 12065312585734608966
				0x85,                                                             // i64.xor
				0x21, $r2,                                                        // local.set $r2
				0x20, $r0,                                                        // local.get $r0
				0x42, 0xdc, 0x92, 0x89, 0xf9, 0xcb, 0xa3, 0xae, 0x93, 0x81, 0x7f, // i64.const 9306329213124626780
				0x85,                                                             // i64.xor
				0x21, $r3,                                                        // local.set $r3
				0x20, $r0,                                                        // local.get $r0
				0x42, 0xe2, 0x94, 0xfe, 0xbc, 0xf1, 0xb2, 0xc9, 0xa6, 0xc9, 0x00, // i64.const 5281919268842080866
				0x85,                                                             // i64.xor
				0x21, $r4,                                                        // local.set $r4
				0x20, $r0,                                                        // local.get $r0
				0x42, 0x8c, 0xd8, 0xab, 0xf5, 0x9c, 0xf7, 0xfb, 0x9b, 0x92, 0x7f, // i64.const 10536153434571861004
				0x85,                                                             // i64.xor
				0x21, $r5,                                                        // local.set $r5
				0x20, $r0,                                                        // local.get $r0
				0x42, 0xf8, 0xda, 0x98, 0xe7, 0xc6, 0xce, 0x95, 0x95, 0x2f,       // i64.const 3398623926847679864
				0x85,                                                             // i64.xor
				0x21, $r6,                                                        // local.set $r6
				0x20, $r0,                                                        // local.get $r0
				0x42, 0xce, 0xca, 0xb3, 0xb1, 0xfb, 0xfe, 0xce, 0xc2, 0x84, 0x7f, // i64.const 9549104520008361294
				0x85,                                                             // i64.xor
				0x21, $r7,                                                        // local.set $r7
			});

			// return r0, r1, r2, r3, r4, r5, r6, r7

			WASM_U8_THUNK({
				0x20, $r0, // local.get $r0
				0x20, $r1, // local.get $r1
				0x20, $r2, // local.get $r2
				0x20, $r3, // local.get $r3
				0x20, $r4, // local.get $r4
				0x20, $r5, // local.get $r5
				0x20, $r6, // local.get $r6
				0x20, $r7, // local.get $r7
			});

			WASM_U8(0x0B); // end
		});
	});

	return p - buf;
}
