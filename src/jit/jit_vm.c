#include "configuration.h"
#include "freestanding.h"
#include "inst.h"
#include "jit.h"
#include "vm/vm.h"
#include "wasm_jit.h"

#include <stdint.h>

#define R(i) (0 + (i))
#define F(i) (8 + (i))
#define E(i) (12 + (i))
#define $ma_mx 16
#define $tmp 17
#define $ic 18

uint32_t vm_ptr_to_tmp(rx_vm_t *VM, uint8_t *buf) {
	THUNK_BEGIN;

	WASM_U8(0x41);         // i32.const
	WASM_I64((int64_t)VM); // VM pointer
	WASM_U8_THUNK({
		0x21, $tmp, // local.set $tmp
	});

	THUNK_END;
}

// local.get $tmp
// v128.load align=4 offset=$offset
// local.set $reg
#define V128_LOAD(offset, reg)                  \
	WASM_U8_THUNK({0x20, $tmp, 0xfd, 0x00, 4}); \
	WASM_U32(offset);                           \
	WASM_U8_THUNK({0x21, reg})

// local.get $tmp
// i64.load align=3 offset=$offset
// local.set $reg
#define I64_LOAD(offset, reg)             \
	WASM_U8_THUNK({0x20, $tmp, 0x29, 3}); \
	WASM_U32(offset);                     \
	WASM_U8_THUNK({0x21, reg})

// local.get $tmp
// local.get $reg
// v128.store align=4 offset=$offset
#define V128_STORE(offset, reg)                            \
	WASM_U8_THUNK({0x20, $tmp, 0x20, reg, 0xfd, 0x0b, 4}); \
	WASM_U32(offset)

// local.get $tmp
// local.get $reg
// i64.store align=3 offset=$offset
#define I64_STORE(offset, reg)                       \
	WASM_U8_THUNK({0x20, $tmp, 0x20, reg, 0x37, 3}); \
	WASM_U32(offset)

uint32_t load_registers(rx_vm_t *VM, uint8_t *buf) {
	THUNK_BEGIN;

	p += vm_ptr_to_tmp(VM, buf);
	
	I64_LOAD(0, R(0));
	I64_LOAD(8, R(1));
	I64_LOAD(16, R(2));
	I64_LOAD(24, R(3));
	I64_LOAD(32, R(4));
	I64_LOAD(40, R(5));
	I64_LOAD(48, R(6));
	I64_LOAD(56, R(7));
	V128_LOAD(64, F(0));
	V128_LOAD(80, F(1));
	V128_LOAD(96, F(2));
	V128_LOAD(112, F(3));
	V128_LOAD(128, E(0));
	V128_LOAD(144, E(1));
	V128_LOAD(160, E(2));
	V128_LOAD(176, E(3));
	I64_LOAD(288, $ma_mx); // sp_addr0 = VM->ma

	THUNK_END;
}

uint32_t store_registers(rx_vm_t *VM, uint8_t *buf) {
	THUNK_BEGIN;

	p += vm_ptr_to_tmp(VM, buf);
	I64_STORE(0, R(0));
	I64_STORE(8, R(1));
	I64_STORE(16, R(2));
	I64_STORE(24, R(3));
	I64_STORE(32, R(4));
	I64_STORE(40, R(5));
	I64_STORE(48, R(6));
	I64_STORE(56, R(7));
	V128_STORE(64, F(0));
	V128_STORE(80, F(1));
	V128_STORE(96, F(2));
	V128_STORE(112, F(3));
	V128_STORE(128, E(0));
	V128_STORE(144, E(1));
	V128_STORE(160, E(2));
	V128_STORE(176, E(3));

	THUNK_END;
}

#undef I64_STORE
#undef V128_STORE
#undef I64_LOAD
#undef V128_LOAD

uint32_t jit_vm_main(rx_vm_t *VM, const rx_program_t *P, uint8_t *scratchpad, uint8_t *buf) {
	THUNK_BEGIN;

	// load registers from VM pointer
	p += load_registers(VM, p);

	// set $ic to RANDOMX_PROGRAM_ITERATIONS and enter loop
	WASM_U8(0x41); // i32.const
	WASM_I64(RANDOMX_PROGRAM_ITERATIONS);
	WASM_U8_THUNK({
		0x21, $ic,  // local.set $ic
		0x03, 0x40, // loop () -> ()
	});

	// TODO: inside JIT

	// loop until $ic == 0
	WASM_U8_THUNK({
		0x20, $ic,  // local.get $ic
		0x41, 0x01, // i32.const 1
		0x6b,       // i32.sub
		0x22, $ic,  // local.tee $ic
		0x0d, 0,    // br_if 0
		0x0b,       // end
	});

	// store registers to VM pointer
	p += store_registers(VM, p);

	THUNK_END;
}

uint32_t jit_vm(rx_vm_t *VM, const rx_program_t *P, uint8_t *scratchpad, uint8_t *buf) {
	THUNK_BEGIN;

	WASM_MAGIC();

	// https://webassembly.github.io/spec/core/binary/modules.html#type-section
	WASM_SECTION(WASM_SECTION_TYPE, {
		WASM_U8_THUNK({
			2, // function types = vec(2)

			// function type 0 : () -> ()
			0x60,
			0, // 0 parameters
			0, // 0 return values

			// function type 1 : (i64) -> (i64, i64, i64, i64, i64, i64, i64, i64)
			0x60,
			1, // 1 parameter
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

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-importsec
	WASM_SECTION(WASM_SECTION_IMPORT, {
		WASM_U8_THUNK({
			2, // imports = vec(1)

			// import 0: e.m
			1, 'e', 1, 'm', // name = "e.m"
			0x02,           // import kind = memory
			0x00, 0,        // limit [0..]

			// import 1: e.d (superscalarhash)
			1, 'e', 1, 'd', // name = "e.d"
			0x00,           // func
			1,              // (i64) -> (i64, i64, i64, i64, i64, i64, i64, i64)
		});
	});

	// import 0: e.d - function index 0
	// (all other function idxs are shifted by 1, amount of imports)

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-funcsec
	WASM_SECTION(WASM_SECTION_FUNCTION, {
		WASM_U8_THUNK({
			1, // functions = vec(1)

			0, // type = 0
		});
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-exportsec
	WASM_SECTION(WASM_SECTION_EXPORT, {
		WASM_U8_THUNK({
			1, // exports = vec(1)

			// export 0: d
			1, 'd', // name = "d"
			0x00,   // export kind = func
			1,      // function index = 1
		});
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-codesec
	WASM_SECTION(WASM_SECTION_CODE, {
		WASM_U8(1); // functions = vec(1)

		// function 0
		WASM_U32_PATCH({
			WASM_U8_THUNK({
				4, // local entries = vec(4)

				8, WASM_TYPE_I64,  // $r0, $r1, $r2, $r3, $r4, $r5, $r6, $r7
				8, WASM_TYPE_V128, // $f0, $f1, $f2, $f3, $e0, $e1, $e2, $e3
				1, WASM_TYPE_I64,  // $ma_mx
				2, WASM_TYPE_I32,  // $tmp, $ic
			});

			p += jit_vm_main(VM, P, scratchpad, p);

			WASM_U8(0x0b); // end
		});
	});

	THUNK_END;
}
