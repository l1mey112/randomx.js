#include "ssh.h"
#include "wasm_jit.h"

#include <stdint.h>

#include "stubs/imul128hi.h"
#include "stubs/mul128hi.h"

#define SSH_JIT_PARAMS __attribute__((unused)) ss_inst_t *inst, uint8_t *buf

// take in `buf` and `ss_inst_t*` and return the number of bytes written to `buf`
typedef uint32_t (*ssh_jit_fn)(SSH_JIT_PARAMS);

// all instructions here are two-address basically x86 instructions
// dest = dest op src

#define THUNK_BEGIN \
	uint8_t *p = buf;

#define THUNK_END \
	return p - buf;

static const uint8_t $cache_ptr = 0, $item_number = 1, $r0 = 2, $r1 = 3, $r2 = 4, $r3 = 5, $r4 = 6, $r5 = 7, $r6 = 8, $r7 = 9;

#define R(x) (x + 2)

#define MOD_MEM(x) (x & 3)
#define MOD_SHIFT(x) ((x >> 2) & 3)
#define MOD_COND(x) (x >> 4)

uint32_t ssh_isub_r(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// (local.set $dest (i64.sub (local.get $dest) (local.get $src)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x20, R(inst->src), // local.get $src
		0x7d,               // i64.sub
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

uint32_t ssh_ixor_r(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// (local.set $dest (i64.xor (local.get $dest) (local.get $src)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x20, R(inst->src), // local.get $src
		0x85,               // i64.xor
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

uint32_t ssh_iadd_rs(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// basically an lea instruction
	// lea $dest, [$dest + $src * scale]

	// (local.set $dest (i64.add (local.get $dest) (i64.shl (local.get $src) (i64.const $scale))))
	WASM_U8_THUNK({
		0x20, R(inst->dst),         // local.get $dest
		0x20, R(inst->src),         // local.get $src
		0x42, MOD_SHIFT(inst->mod), // i64.const $scale
		0x86,                       // i64.shl
		0x7c,                       // i64.add
		0x21, R(inst->dst),         // local.set $dest
	});

	THUNK_END
}

uint32_t ssh_imul_r(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// (local.set $dest (i64.mul (local.get $dest) (local.get $src)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x20, R(inst->src), // local.get $src
		0x7e,               // i64.mul
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

uint32_t ssh_iror_c(SSH_JIT_PARAMS) {
	THUNK_BEGIN
	// Performs a cyclic shift (rotation) of the destination register. Source operand (shift count) is implicitly masked to 6 bits. IROR rotates bits right, IROL left.

	// (local.set $dest (i64.rotr (local.get $dest) (i64.const $imm)))
	WASM_U8_THUNK({
		0x20, R(inst->dst),     // local.get $dest
		0x42, inst->imm32 & 63, // i64.const $imm
		0x8a,                   // i64.rotr
		0x21, R(inst->dst),     // local.set $dest
	});

	THUNK_END
}

uint32_t ssh_iadd_c(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// sign extended imm32
	uint64_t imm64 = (int32_t)inst->imm32;

	// (local.set $dest (i64.add (local.get $dest) (i64.const $imm)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x42                // i64.const
	});

	WASM_I64(imm64); // $imm

	WASM_U8_THUNK({
		0x7c,               // i64.add
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

uint32_t ssh_ixor_c(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// sign extended imm32
	uint64_t imm64 = (int32_t)inst->imm32;

	// (local.set $dest (i64.xor (local.get $dest) (i64.const $imm)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x42                // i64.const
	});

	WASM_I64(imm64); // $imm

	WASM_U8_THUNK({
		0x85,               // i64.xor
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

// > These instructions output the high 64 bits of the whole 128-bit multiplication result.
// > The result differs for signed and unsigned multiplication (IMULH is unsigned, ISMULH is signed).
// > The variants with a register source operand perform a squaring operation if dst equals src.

// the wasm equivalent is using v128 SIMD instructions, lane-wise extended multiplication
//  IMULH - i64x2.extmul_high_i32x4_u
// ISMULH - i64x2.extmul_high_i32x4_s

/* static uint64_t mulh128(uint64_t lhs, uint64_t rhs)
{
    uint64_t lo_lo = (lhs & 0xFFFFFFFF) * (rhs & 0xFFFFFFFF);
    uint64_t hi_lo = (lhs >> 32)        * (rhs & 0xFFFFFFFF);
    uint64_t lo_hi = (lhs & 0xFFFFFFFF) * (rhs >> 32);
    uint64_t hi_hi = (lhs >> 32)        * (rhs >> 32);

    uint64_t cross = (lo_lo >> 32) + (hi_lo & 0xFFFFFFFF) + lo_hi;
    uint64_t upper = (hi_lo >> 32) + (cross >> 32)        + hi_hi;

    return upper;
} */

// https://stackoverflow.com/questions/22845801/32-bit-signed-integer-multiplication-without-using-64-bit-data-type/22847373#22847373
// https://stackoverflow.com/questions/33789230/how-does-this-128-bit-integer-multiplication-work-in-assembly-x86-64
/* What GCC is doing is using the property that signed multiplication can be done using the following formula.

(hi,lo) = unsigned(x*y)
hi -= ((x<0) ? y : 0)  + ((y<0) ? x : 0) */

uint32_t ssh_imulh_r(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// (local.set $dest (call $mul128hi64 (local.get $dest) (local.get $src)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x20, R(inst->src), // local.get $src
		0x10, 1,            // call 1 - mul128hi64 (unsigned)
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

uint32_t ssh_ismulh_r(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	// (local.set $dest (call $imul128hi64 (local.get $dest) (local.get $src)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x20, R(inst->src), // local.get $src
		0x10, 2,            // call 2 - imul128hi64 (signed)
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

uint64_t randomx_reciprocal(uint32_t divisor) {
	uint64_t p2exp63 = 1ULL << 63;
	uint64_t q = p2exp63 / divisor;
	uint64_t r = p2exp63 % divisor;
	int32_t shift = 64 - __builtin_clzll(divisor);
	return (q << shift) + ((r << shift) / divisor);
}

uint32_t ssh_imul_rcp(SSH_JIT_PARAMS) {
	THUNK_BEGIN

	uint64_t reciprocal = randomx_reciprocal(inst->imm32);

	// (local.set $dest (i64.mul (local.get $dest) (i64.const $imm_rcp)))
	WASM_U8_THUNK({
		0x20, R(inst->dst), // local.get $dest
		0x42,               // i64.const
	});

	WASM_I64(reciprocal); // $imm_rcp

	WASM_U8_THUNK({
		0x7e,               // i64.mul
		0x21, R(inst->dst), // local.set $dest
	});

	THUNK_END
}

#undef THUNK_BEGIN
#undef THUNK_END
#undef SSH_JIT_PARAMS

static const ssh_jit_fn tables[SS_INST_COUNT] = {
	[SS_ISUB_R] = ssh_isub_r,
	[SS_IXOR_R] = ssh_ixor_r,
	[SS_IADD_RS] = ssh_iadd_rs,
	[SS_IMUL_R] = ssh_imul_r,
	[SS_IROR_C] = ssh_iror_c,
	[SS_IADD_C7] = ssh_iadd_c,
	[SS_IXOR_C7] = ssh_ixor_c,
	[SS_IADD_C8] = ssh_iadd_c,
	[SS_IXOR_C8] = ssh_ixor_c,
	[SS_IADD_C9] = ssh_iadd_c,
	[SS_IXOR_C9] = ssh_ixor_c,
	[SS_IMULH_R] = ssh_imulh_r,
	[SS_ISMULH_R] = ssh_ismulh_r,
	[SS_IMUL_RCP] = ssh_imul_rcp,
};

uint32_t ssh_jit(ss_program_t prog[RANDOMX_CACHE_ACCESSES], uint8_t *buf) {
	uint8_t *p = buf;

	WASM_MAGIC();

	// https://webassembly.github.io/spec/core/binary/modules.html#type-section
	WASM_SECTION(WASM_SECTION_TYPE, {
		WASM_U32_2(); // function types = vec(1)

		WASM_U8_THUNK({
			// function type 0 : (i32, i32) -> (i64, i64, i64, i64, i64, i64, i64, i64)
			0x60,
			2, // 2 parameters
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
			// function type 1 : (i64, i64) -> i64
			0x60,
			2, // 2 parameters
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			1, // 1 return value
			WASM_TYPE_I64,
		});
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-funcsec
	WASM_SECTION(WASM_SECTION_FUNCTION, {
		WASM_U8_THUNK({
			3, // functions = vec(3)
			0, // function 0 = function type 0
			1, // function 1 = function type 1
			1, // function 2 = function type 1
		});
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-codesec
	WASM_SECTION(WASM_SECTION_CODE, {
		WASM_U32_3(); // functions = vec(3)

		// function 0
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

			ss_program_t *first_program = &prog[0];

			// for instruction, stamp out
			for (unsigned i = 0; i < first_program->size; i++) {
				ss_inst_t *inst = &first_program->instructions[i];
				ssh_jit_fn fn = tables[inst->opcode];
				p += fn(inst, p);
			}

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

		// function 1 - mul128hi
		WASM_U32_WITH_STUB(STUB_MUL128HI);

		// function 2 - imul128hi
		WASM_U32_WITH_STUB(STUB_IMUL128HI);
	});

	return p - buf;
}
