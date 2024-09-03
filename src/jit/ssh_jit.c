#include "configuration.h"
#include "ssh.h"
#include "wasm_jit.h"
#include "inst.h"

#include <stdint.h>

#include "stubs/imul128hi.h"
#include "stubs/mul128hi.h"

#define SSH_JIT_PARAMS __attribute__((unused)) rx_inst_t *inst, uint8_t *buf

// take in `buf` and `rx_inst_t*` and return the number of bytes written to `buf`
typedef uint32_t (*ssh_jit_fn)(SSH_JIT_PARAMS);

// all instructions here are two-address basically x86 instructions
// dest = dest op src

#define THUNK_BEGIN \
	uint8_t *p = buf;

#define THUNK_END \
	return p - buf;

static const uint8_t $item_number = 0, $mixblock_ptr = 1, $r0 = 2, $r1 = 3, $r2 = 4, $r3 = 5, $r4 = 6, $r5 = 7, $r6 = 8, $r7 = 9;

#define R(x) (x + 2)

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
	int64_t imm64 = (int32_t)inst->imm32;

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
	int64_t imm64 = (int32_t)inst->imm32;

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

// $item_number, reused as $cacheIndex
// cacheIndex = itemNumber % total 64 byte cache items

// (i64) -> () - set $mixblock_ptr
uint32_t access_mix_block(uint8_t *buf, uint8_t *cache_ptr) {
	THUNK_BEGIN

	// x % y == x & (y - 1)
	// where log2(y) is integer whole
	uint32_t mask = (RANDOMX_ARGON_MEMORY * 1024) / 64 - 1;

	// to get item index, then multiply by 64
	// x * 64 == x << log2(64)
	//        == x << 6

	// v0: i64 = (i64.and (local.get $item_number) (i64.const $mask))
	// v1: i32 = (i32.wrap_i64 v0)
	// v2: i32 = (i32.shl v1 (i32.const 6))
	// v3: i32 = (i32.add v2 (i32.const $cache_ptr))
	// (local.set $mixblock_ptr v3)
	WASM_U8_THUNK({
		0x20, $item_number, // local.get $item_number
		0x42,               // i64.const
	});

	WASM_I64(mask); // $mask

	WASM_U8_THUNK({
		0x83,    // i64.and
		0xa7,    // i32.wrap_i64
		0x41, 6, // i32.const 6
		0x74,    // i32.shl
		0x41,    // i32.const
	});

	WASM_I64((uint32_t)cache_ptr); // $cache_ptr

	WASM_U8_THUNK({
		0x6a,                // i32.add
		0x21, $mixblock_ptr, // local.set $mixblock_ptr
	});

	THUNK_END
}

uint32_t xor_mix_block(uint8_t *buf) {
	THUNK_BEGIN

	// for i in 0..8 {
	//     (local.set $ri (i64.xor (i64.load align=log2(4) offset=i*8 (local.get $mixblock_ptr))) (local.get $ri))
	// }

	// r0..7 ^= block[0..7]
	for (int i = 0; i < 8; i++) {
		// compute off_ptr
		// 7*8 = 56 < 127 meaning no special LEB128 encoding
		WASM_U8_THUNK({
			0x20, $mixblock_ptr, // local.get $mixblock_ptr
			0x29, 2, i * 8,      // i64.load align=2 offset=i*8
			0x20, R(i),          // local.get $ri
			0x85,                // i64.xor
			0x21, R(i),          // local.set $ri
		});
	}

	THUNK_END
}

uint32_t ssh_jit_programs(ss_program_t prog[RANDOMX_CACHE_ACCESSES], uint8_t *cache_ptr, uint8_t *buf) {
	THUNK_BEGIN

	// i = 0
	// do {
	//     block = cache[cacheIndex % total 64 byte items in cache]
	//     SuperscalarHash[i](r0, r1, r2, r3, r4, r5, r6, r7)
	//     r0..7 ^= block[0..7]
	//     cacheIndex = r[longest dependency chain??]
	//     i = i + 1
	// } while(i < RANDOMX_CACHE_ACCESSES)

	// perform unrolling up to RANDOMX_CACHE_ACCESSES
	for (int i = 0; i < RANDOMX_CACHE_ACCESSES; i++) {
		ss_program_t *ith_program = &prog[i];

		// SuperscalarHash[i](r0, r1, r2, r3, r4, r5, r6, r7)
		for (unsigned j = 0; j < ith_program->size; j++) {
			rx_inst_t *inst = &ith_program->instructions[j];
			ssh_jit_fn fn = tables[inst->opcode];
			p += fn(inst, p);
		}

		// block = cache[cacheIndex % total 64 byte items in cache]
		// r0..7 ^= block[0..7]
		p += access_mix_block(p, cache_ptr);
		p += xor_mix_block(p);

		// cacheIndex = r[longest dependency chain]

		// (local.set $item_number (local.get $r[ith_program->addr_reg]))
		WASM_U8_THUNK({
			0x20, R(ith_program->addr_reg), // local.get $r[ith_program->addr_reg]
			0x21, $item_number,             // local.set $item_number
		});
	}

	THUNK_END
}

uint32_t ssh_jit(ss_program_t prog[RANDOMX_CACHE_ACCESSES], uint8_t *cache, uint8_t *buf) {
	uint8_t *p = buf;

	WASM_MAGIC();

	// https://webassembly.github.io/spec/core/binary/modules.html#type-section
	WASM_SECTION(WASM_SECTION_TYPE, {
		WASM_U8(2); // function types = vec(1)

		WASM_U8_THUNK({
			// function type 0 : (i64) -> (i64, i64, i64, i64, i64, i64, i64, i64)
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
			// function type 1 : (i64, i64) -> i64
			0x60,
			2, // 2 parameters
			WASM_TYPE_I64,
			WASM_TYPE_I64,
			1, // 1 return value
			WASM_TYPE_I64,
		});
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-importsec
	WASM_SECTION(WASM_SECTION_IMPORT, {
		WASM_U8(1); // imports = vec(1)

		// import 0: e.m
		WASM_U32_NAME("e");
		WASM_U32_NAME("m");

		// TODO: shared memory
		WASM_U8_THUNK({
			0x02,   // memory
			0x00, 0 // limit [0..]
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

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-exportsec
	WASM_SECTION(WASM_SECTION_EXPORT, {
		WASM_U8(1); // exports = vec(1)

		// export 0: d
		WASM_U32_NAME("d");
		WASM_U8(0x00); // export kind = func
		WASM_U32(0);   // function index = 0
	});

	// https://webassembly.github.io/spec/core/binary/modules.html#binary-codesec
	WASM_SECTION(WASM_SECTION_CODE, {
		WASM_U8(3); // functions = vec(3)

		// function 0
		WASM_U32_PATCH({
			WASM_U8(2); // locals entries = vec(2)

			WASM_U8(1);             // 1 local variable of type i32
			WASM_U8(WASM_TYPE_I32); // $mixblock_ptr
			WASM_U8(8);             // 8 local variables of type i64
			WASM_U8(WASM_TYPE_I64); // $r0..$r7

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

			p += ssh_jit_programs(prog, cache, p);

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
