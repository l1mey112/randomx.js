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
#define $sp_addr0 16
#define $sp_addr1 17
#define $mx 18
#define $ma 19
#define $tmp 20
#define $ic 21
#define $tmp64 22
#define $mask_mant 23
#define $mask_exp 24

#define $fprc 0

uint32_t ptr_to_tmp(void *ptr, uint8_t *buf) {
	THUNK_BEGIN;

	WASM_U8(0x41);          // i32.const
	WASM_I64((int64_t)ptr); // pointer
	WASM_U8_THUNK({
		0x21, $tmp, // local.set $tmp
	});

	THUNK_END;
}

uint32_t ptr_to_tmp_with_reg_offset(void *ptr, int reg, uint8_t *buf) {
	THUNK_BEGIN;

	WASM_U8(0x41);          // i32.const
	WASM_I64((int64_t)ptr); // pointer
	WASM_U8_THUNK({
		0x20, reg,  // local.get $reg
		0x6a,       // i32.add
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
// i32.load align=2 offset=$offset
// local.tee $reg0
// local.set $reg1
#define I32_LOAD2(offset, reg0, reg1)     \
	WASM_U8_THUNK({0x20, $tmp, 0x28, 2}); \
	WASM_U32(offset);                     \
	WASM_U8_THUNK({0x22, reg0, 0x21, reg1})

// local.get $tmp
// i32.load align=2 offset=$offset
// global.set $global
#define I32_LOAD_GLOBAL(offset, global)   \
	WASM_U8_THUNK({0x20, $tmp, 0x28, 2}); \
	WASM_U32(offset);                     \
	WASM_U8_THUNK({0x24, global})

// local.get $tmp
// global.get $global
// i32.store align=2 offset=$offset
#define I32_STORE_GLOBAL(offset, global)                \
	WASM_U8_THUNK({0x20, $tmp, 0x23, global, 0x36, 2}); \
	WASM_U32(offset)

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

// local.get $tmp
// i64.load align=3 offset=$offset
// local.get $reg
// i64.xor
// local.set $reg
#define I64_LOAD_XOR_STORE(offset, reg)   \
	WASM_U8_THUNK({0x20, $tmp, 0x29, 3}); \
	WASM_U32(offset);                     \
	WASM_U8_THUNK({0x20, reg, 0x85, 0x21, reg})

// https://github.com/WebAssembly/design/issues/1476
// not adding in an instruction for v128.const_zero is insanity
#define V128_ZERO 0xfd, 0x0c, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 // 16 bytes of 0

// v128.const $buf[0..16]
// local.set $reg
#define V128_SET(buf, reg)       \
	WASM_U8_THUNK({0xfd, 0x0c}); \
	WASM_BUF(buf, 16);           \
	WASM_U8_THUNK({0x21, reg})

// 4.3.1 Group F register conversion
// cvtdq2pd - https://nemequ.github.io/waspr/instructions/f64x2.convert_low_i32x4_s
//
// x = load low i64 of i64x2, convert packed doubles to f64x2

// local.get $tmp
// v128.load64_zero align=3 offset=$offset
// f64x2.convert_low_i32x4_s
// local.set $reg
#define V128_LOAD_F(offset, reg)                \
	WASM_U8_THUNK({0x20, $tmp, 0xfd, 0x5d, 3}); \
	WASM_U32(offset);                           \
	WASM_U8_THUNK({0xfd, 0xfe, 0x01, 0x21, reg})

// 4.3.2 Group E register conversion
// x = load low i64 of i64x2, convert packed doubles to f64x2
// x &= mask_mant
// x |= mask_exp

// local.get $tmp
// v128.load64_zero align=3 offset=$offset
// f64x2.convert_low_i32x4_s
// local.get $mask_mant
// v128.and
// local.get $mask_exp
// v128.or
// local.set $reg
#define V128_LOAD_E(offset, reg)                \
	WASM_U8_THUNK({0x20, $tmp, 0xfd, 0x5d, 3}); \
	WASM_U32(offset);                           \
	WASM_U8_THUNK({0xfd, 0xfe, 0x01, 0x20, $mask_mant, 0xfd, 0x4e, 0x20, $mask_exp, 0xfd, 0x50, 0x21, reg})

uint32_t prologue_load_registers(rx_vm_t *VM, uint8_t *buf) {
	THUNK_BEGIN;

	p += ptr_to_tmp(VM, buf);

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
	V128_LOAD(256, $mask_exp);      // mask_exp = VM->emask
	V128_LOAD(272, $mask_mant);     // mask_mant = {DYNAMIC_MANTISSA_MASK, DYNAMIC_MANTISSA_MASK}
	I32_LOAD_GLOBAL(288, $fprc);    // fprc = VM->fprc
	I32_LOAD2(292, $ma, $sp_addr1); // sp_addr1 = ma = VM->ma
	I32_LOAD2(296, $mx, $sp_addr0); // sp_addr0 = mx = VM->mx

	THUNK_END;
}

uint32_t epilogue_store_registers(rx_vm_t *VM, uint8_t *buf) {
	THUNK_BEGIN;

	p += ptr_to_tmp(VM, buf);

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
	I32_STORE_GLOBAL(272, $fprc); // VM->fprc = fprc

	THUNK_END;
}

#define SCRATCHPAD_L3 (RANDOMX_SCRATCHPAD_L3 / 8) // divide by 64 bit blocks
#define SCRATCHPAD_L3_MASK ((SCRATCHPAD_L3 - 1) * 8)
#define SCRATCHPAD_L3_MASK_64 ((SCRATCHPAD_L3 / 8 - 1) * 64)
#define DATASET_ITEM_SIZE 64
#define DATASET_ITEM_SIZE_LOG2 6
#define CACHE_LINE_MASK ((RANDOMX_DATASET_BASE_SIZE - 1) & ~(DATASET_ITEM_SIZE - 1))

uint32_t jit_vm_main(rx_vm_t *VM, const rx_program_t *P, uint8_t *scratchpad, uint8_t *buf) {
	THUNK_BEGIN;

	// load registers from VM pointer
	p += prologue_load_registers(VM, p);

	// set ic to RANDOMX_PROGRAM_ITERATIONS and enter loop
	WASM_U8(0x41); // i32.const
	WASM_I64(RANDOMX_PROGRAM_ITERATIONS);
	WASM_U8_THUNK({
		0x21, $ic,  // local.set $ic
		0x03, 0x40, // loop () -> ()
	});

	// 1. XOR of registers readReg0 and readReg1 (see Table 4.5.3) is calculated and spAddr0
	//    is XORed with the low 32 bits of the result and spAddr1 with the high 32 bits.
	{
		// sp_mix = r[read_reg0] ^ r[read_reg1]
		WASM_U8_THUNK({
			0x20, R(VM->read_reg0), // local.get $r[read_reg0]
			0x20, R(VM->read_reg1), // local.get $r[read_reg1]
			0x85,                   // i64.xor
			0x21, $tmp64,           // local.set $tmp64
		});

		// sp_addr0 ^= sp_mix
		// sp_addr0 &= SCRATCHPAD_L3_MASK_64
		WASM_U8_THUNK({
			0x20, $tmp64,    // local.get $tmp64
			0xa7,            // i32.wrap_i64 (low 32 bits)
			0x20, $sp_addr0, // local.get $sp_addr0
			0x73,            // i32.xor
			0x41,            // i32.const
		});
		WASM_I64(SCRATCHPAD_L3_MASK_64); // SCRATCHPAD_L3_MASK_64
		WASM_U8_THUNK({
			0x71,            // i32.and
			0x21, $sp_addr0, // local.set $sp_addr0
		});

		// sp_addr1 ^= sp_mix >> 32
		// sp_addr1 &= SCRATCHPAD_L3_MASK_64
		WASM_U8_THUNK({
			0x20, $tmp64,    // local.get $tmp64
			0x42, 32,        // i64.const 32
			0x88,            // i64.shr_u
			0xa7,            // i32.wrap_i64 (high 32 bits)
			0x20, $sp_addr1, // local.get $sp_addr1
			0x73,            // i32.xor
			0x41,            // i32.const
		});
		WASM_I64(SCRATCHPAD_L3_MASK_64); // SCRATCHPAD_L3_MASK_64
		WASM_U8_THUNK({
			0x71,            // i32.and
			0x21, $sp_addr1, // local.set $sp_addr1
		});
	}

	// 2. spAddr0 is used to perform a 64-byte aligned read from Scratchpad level 3 (using mask from Table 4.2.1).
	//    The 64 bytes are XORed with all integer registers in order r0-r7.
	{
		// tmp = scratchpad + sp_addr0
		p += ptr_to_tmp_with_reg_offset(scratchpad, $sp_addr0, p);

		// r[..] ^= tmp[..]
		I64_LOAD_XOR_STORE(0, R(0));
		I64_LOAD_XOR_STORE(8, R(1));
		I64_LOAD_XOR_STORE(16, R(2));
		I64_LOAD_XOR_STORE(24, R(3));
		I64_LOAD_XOR_STORE(32, R(4));
		I64_LOAD_XOR_STORE(40, R(5));
		I64_LOAD_XOR_STORE(48, R(6));
		I64_LOAD_XOR_STORE(56, R(7));
	}

	// 3. spAddr1 is used to perform a 64-byte aligned read from Scratchpad level 3 (using mask from Table 4.2.1).
	//    Each floating point register f0-f3 and e0-e3 is initialized using an 8-byte
	//    value according to the conversion rules from chapters 4.3.1 and 4.3.2.
	{
		// tmp = scratchpad + sp_addr1
		p += ptr_to_tmp_with_reg_offset(scratchpad, $sp_addr1, p);

		V128_LOAD_F(0, F(0));
		V128_LOAD_F(8, F(1));
		V128_LOAD_F(16, F(2));
		V128_LOAD_F(24, F(3));
		V128_LOAD_E(32, E(0));
		V128_LOAD_E(40, E(1));
		V128_LOAD_E(48, E(2));
		V128_LOAD_E(56, E(3));
	}

	// TODO: 4. The 256 instructions stored in the Program Buffer are executed.
	{
	}

	// 5. The mx register is XORed with the low 32 bits of registers readReg2 and readReg3 (see Table 4.5.3).
	{
		// mx ^= r[read_reg2] ^ r[read_reg3]
		// mx &= CACHE_LINE_MASK
		WASM_U8_THUNK({
			0x20, R(VM->read_reg2), // local.get $r[read_reg2]
			0x20, R(VM->read_reg3), // local.get $r[read_reg3]
			0x85,                   // i64.xor
			0xa7,                   // i32.wrap_i64 (low 32 bits)
			0x20, $mx,              // local.get $mx
			0x73,                   // i32.xor
			0x41,                   // i32.const
		});
		WASM_I64(CACHE_LINE_MASK); // CACHE_LINE_MASK
		WASM_U8_THUNK({
			0x71,      // i32.and
			0x21, $mx, // local.set $mx
		});
	}

	// 6. A 64-byte Dataset item at address datasetOffset + mx % RANDOMX_DATASET_BASE_SIZE
	//    is prefetched from the Dataset (it will be used during the next iteration).
	//
	// NOTE: I wish WASM had a prefetch instruction.
	//
	//       dataset_prefetch(block_number: VM->dataset_offset + mx)

// local.get reg
// i64.xor
// local.set reg
#define GET_XOR_SET(reg) \
	0x20, reg, 0x85, 0x21, reg

	// 7. A 64-byte Dataset item at address datasetOffset + ma % RANDOMX_DATASET_BASE_SIZE
	//    is loaded from the Dataset. The 64 bytes are XORed with all integer registers in order r0-r7.
	{
		// invoke superscalarhash (import e.d - function index 0)
		// with type (i64) -> (i64, i64, i64, i64, i64, i64, i64, i64)

		// item_number = ma / DATASET_ITEM_SIZE
		// item_number = ma >> log2(DATASET_ITEM_SIZE)

		WASM_U8_THUNK({
			0x20, $ma, // local.get $ma
			0xad,      // i64.extend_i32_u
			0x42,      // i64.const
		});
		WASM_I64(VM->dataset_offset); // VM->dataset_offset
		WASM_U8_THUNK({
			0x7c,                         // i64.add
			0x42, DATASET_ITEM_SIZE_LOG2, // i64.const DATASET_ITEM_SIZE_LOG2
			0x88,                         // i64.shr_u
			0x10, 0,                      // call 0 (import e.d)
		});

		// on stack: (r7, r6, r5, r4, r3, r2, r1, r0)
		// r[..] ^= tmp[..]
		WASM_U8_THUNK({
			GET_XOR_SET(R(7)),
			GET_XOR_SET(R(6)),
			GET_XOR_SET(R(5)),
			GET_XOR_SET(R(4)),
			GET_XOR_SET(R(3)),
			GET_XOR_SET(R(2)),
			GET_XOR_SET(R(1)),
			GET_XOR_SET(R(0)),
		});

#undef GET_XOR_SET
	}

	// 8. The values of registers mx and ma are swapped.
	{
		WASM_U8_THUNK({
			0x20, $mx, // local.get $mx
			0x20, $ma, // local.get $ma
			0x21, $mx, // local.set $mx
			0x21, $ma, // local.set $ma
		});
	}

	// 9. The values of all integer registers r0-r7 are written to the Scratchpad (L3)
	//    at address spAddr1 (64-byte aligned).
	{
		// tmp = scratchpad + sp_addr1
		p += ptr_to_tmp_with_reg_offset(scratchpad, $sp_addr1, p);

		I64_STORE(0, R(0));
		I64_STORE(8, R(1));
		I64_STORE(16, R(2));
		I64_STORE(24, R(3));
		I64_STORE(32, R(4));
		I64_STORE(40, R(5));
		I64_STORE(48, R(6));
		I64_STORE(56, R(7));
	}

// local.get reg0
// local.get reg1
// v128.xor
// local.set reg0
#define GET2_XOR_V128_SET(reg0, reg1) \
	0x20, reg0, 0x20, reg1, 0xfd, 0x51, 0x21, reg0

	// 10. Register f0 is XORed with register e0 and the result is stored in register f0.
	//     Register f1 is XORed with register e1 and the result is stored in register f1.
	//     Register f2 is XORed with register e2 and the result is stored in register f2.
	//     Register f3 is XORed with register e3 and the result is stored in register f3.
	{
		WASM_U8_THUNK({
			GET2_XOR_V128_SET(F(0), E(0)),
			GET2_XOR_V128_SET(F(1), E(1)),
			GET2_XOR_V128_SET(F(2), E(2)),
			GET2_XOR_V128_SET(F(3), E(3)),
		});

#undef GET2_XOR_V128_SET
	}

	// 11. The values of registers f0-f3 are written to the Scratchpad (L3) at address spAddr0 (64-byte aligned).
	{
		// tmp = scratchpad + sp_addr0
		p += ptr_to_tmp_with_reg_offset(scratchpad, $sp_addr0, p);

		V128_STORE(0, F(0));
		V128_STORE(16, F(1));
		V128_STORE(32, F(2));
		V128_STORE(48, F(3));
	}

	// 12. spAddr0 and spAddr1 are both set to zero.
	{
		WASM_U8_THUNK({
			0x41, 0x00,      // i32.const 0
			0x21, $sp_addr0, // local.set $sp_addr0
			0x41, 0x00,      // i32.const 0
			0x21, $sp_addr1, // local.set $sp_addr1
		});
	}

	// 13. ic is decreased by 1.
	// loop until ic == 0
	WASM_U8_THUNK({
		0x20, $ic,  // local.get $ic
		0x41, 0x01, // i32.const 1
		0x6b,       // i32.sub
		0x22, $ic,  // local.tee $ic
		0x0d, 0,    // br_if 0
		0x0b,       // end
	});

	// store registers to VM pointer
	p += epilogue_store_registers(VM, p);

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

	// https://webassembly.github.io/spec/core/binary/modules.html#global-section
	WASM_SECTION(WASM_SECTION_GLOBAL, {
		WASM_U8_THUNK({
			1, // globals = vec(1)

			// mut fprc: i32
			WASM_TYPE_I32, // type = i32
			0x01,          // mut = true
			0x41, 0x00,    // i32.const 0
			0x0b,          // end
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

		// function 0 - (actual function idx space 0 + 1 import)
		WASM_U32_PATCH({
			WASM_U8_THUNK({
				5, // local entries = vec(3)

				8, WASM_TYPE_I64,  // $r0, $r1, $r2, $r3, $r4, $r5, $r6, $r7
				8, WASM_TYPE_V128, // $f0, $f1, $f2, $f3, $e0, $e1, $e2, $e3
				6, WASM_TYPE_I32,  // $sp_addr0, $sp_addr1, $mx, $ma, $tmp, $ic
				1, WASM_TYPE_I64,  // $tmp64
				2, WASM_TYPE_V128, // $tmp128_mant, $tmp128_emask
			});

			p += jit_vm_main(VM, P, scratchpad, p);

			WASM_U8(0x0b); // end
		});
	});

	// assign local names for debug purposes

#define LOCAL_NAME(idx, name) \
	WASM_U8(idx);             \
	WASM_U8_SHORT_NAME(name)

	// https://webassembly.github.io/spec/core/binary/modules.html#custom-section
	// https://webassembly.github.io/spec/core/appendix/custom.html#name-section
	// https://github.com/WebAssembly/extended-name-section
	WASM_SECTION(WASM_SECTION_CUSTOM, {
		WASM_U8_THUNK({
			4, 'n', 'a', 'm', 'e', // name = "name"
		});
		// local names (subsection)
		WASM_SECTION(0x02, {
			// vec(function_idx, vec(idx, name))
			WASM_U8(1); // entries = vec(1)

			WASM_U8(1);  // function index 1
			WASM_U8(25); // locals = vec(25)

			LOCAL_NAME(R(0), "r0");
			LOCAL_NAME(R(1), "r1");
			LOCAL_NAME(R(2), "r2");
			LOCAL_NAME(R(3), "r3");
			LOCAL_NAME(R(4), "r4");
			LOCAL_NAME(R(5), "r5");
			LOCAL_NAME(R(6), "r6");
			LOCAL_NAME(R(7), "r7");
			LOCAL_NAME(F(0), "f0");
			LOCAL_NAME(F(1), "f1");
			LOCAL_NAME(F(2), "f2");
			LOCAL_NAME(F(3), "f3");
			LOCAL_NAME(E(0), "e0");
			LOCAL_NAME(E(1), "e1");
			LOCAL_NAME(E(2), "e2");
			LOCAL_NAME(E(3), "e3");
			LOCAL_NAME($sp_addr0, "sp_addr0");
			LOCAL_NAME($sp_addr1, "sp_addr1");
			LOCAL_NAME($mx, "mx");
			LOCAL_NAME($ma, "ma");
			LOCAL_NAME($tmp, "tmp");
			LOCAL_NAME($ic, "ic");
			LOCAL_NAME($tmp64, "tmp64");
			LOCAL_NAME($mask_mant, "mask_mant");
			LOCAL_NAME($mask_exp, "mask_exp");
		});

		// global names (subsection)
		WASM_SECTION(0x07, {
			// vec(global_idx, name)
			WASM_U8(1); // entries = vec(1)

			WASM_U8(0); // global index 0
			WASM_U8_SHORT_NAME("fprc");
		});
	});

#undef LOCAL_NAME

	THUNK_END;
}