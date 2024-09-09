#include "configuration.h"
#include "inst.h"
#include "ssh.h"
#include "wasm_jit.h"

#include <stdint.h>

// JIT stubs
#include "stubs/ssh_main.h"

#define FUNC_OFFSET 1
#include "stubs/mulh.h"

#define SSH_JIT_PARAMS __attribute__((unused)) rx_inst_t *inst, uint8_t *buf

// take in `buf` and `rx_inst_t*` and return the number of bytes written to `buf`
typedef uint32_t (*ssh_jit_fn)(SSH_JIT_PARAMS);

// all instructions here are two-address basically x86 instructions
// dest = dest op src

#define THUNK_BEGIN \
	uint8_t *p = buf;

#define THUNK_END \
	return p - buf;

#define R(x) (x + $r0_ssh_main)

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
		0x20, $item_number_ssh_main, // local.get $item_number
		0x42,                        // i64.const
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
		0x6a,                         // i32.add
		0x21, $mixblock_ptr_ssh_main, // local.set $mixblock_ptr
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
			0x20, $mixblock_ptr_ssh_main, // local.get $mixblock_ptr
			0x29, 2, i * 8,               // i64.load align=2 offset=i*8
			0x20, R(i),                   // local.get $ri
			0x85,                         // i64.xor
			0x21, R(i),                   // local.set $ri
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
			0x21, $item_number_ssh_main,    // local.set $item_number
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
			WASM_STUB(STUB_SSH_MAIN);

			p += ssh_jit_programs(prog, cache, p);

			WASM_STUB(STUB_SSH_MAIN_1);
		});

		// function 1 - mul128hi
		WASM_U32_WITH_STUB(STUB_MUL128HI);

		// function 2 - imul128hi
		WASM_U32_WITH_STUB(STUB_IMUL128HI);
	});

	return p - buf;
}
