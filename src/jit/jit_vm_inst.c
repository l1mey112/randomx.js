#include "freestanding.h"
#include "inst.h"
#include "jit.h"
#include "jit_vm.h"
#include "vm/vm.h"
#include "wasm_jit.h"

#include <stdint.h>

#define SCRATCHPAD_L1_MASK ((RANDOMX_SCRATCHPAD_L1 / 8 - 1) * 8)
#define SCRATCHPAD_L2_MASK ((RANDOMX_SCRATCHPAD_L2 / 8 - 1) * 8)
#define SCRATCHPAD_L3_MASK ((RANDOMX_SCRATCHPAD_L3 / 8 - 1) * 8)

// i64.const $imm64
// i64.add
// i32.wrap_i64
// i32.const $mask (L1 or L2)
// i32.and
// i32.const $scratchpad
// i32.add
#define SCRATCHPAD_PTR_L1_L2(inst)                                          \
	WASM_U8_THUNK({0x42});                                                  \
	WASM_I64(IMM_SEXT64(inst->imm32));                                      \
	WASM_U8_THUNK({0x7c, 0xa7, 0x41});                                      \
	WASM_I64(MOD_MEM(inst->mod) ? SCRATCHPAD_L1_MASK : SCRATCHPAD_L2_MASK); \
	WASM_U8_THUNK({0x71, 0x41});                                            \
	WASM_I64((int64_t)scratchpad);                                          \
	WASM_U8_THUNK({0x6a})

// i64.const $imm64
// i32.wrap_i64
// i32.const $mask (L3)
// i32.and
// i32.const $scratchpad
// i32.add
#define SCRATCHPAD_DIRECT_PTR_L3(inst) \
	WASM_U8_THUNK({0x42});             \
	WASM_I64(IMM_SEXT64(inst->imm32)); \
	WASM_U8_THUNK({0xa7, 0x41});       \
	WASM_I64(SCRATCHPAD_L3_MASK);      \
	WASM_U8_THUNK({0x71, 0x41});       \
	WASM_I64((int64_t)scratchpad);     \
	WASM_U8_THUNK({0x6a})

// i64.const $imm64
// i64.add
// i32.wrap_i64
// i32.const $mask (L3)
// i32.and
// i32.const $scratchpad
// i32.add
#define SCRATCHPAD_PTR_L3(inst)        \
	WASM_U8_THUNK({0x42});             \
	WASM_I64(IMM_SEXT64(inst->imm32)); \
	WASM_U8_THUNK({0x7c, 0xa7, 0x41}); \
	WASM_I64(SCRATCHPAD_L3_MASK);      \
	WASM_U8_THUNK({0x71, 0x41});       \
	WASM_I64((int64_t)scratchpad);     \
	WASM_U8_THUNK({0x6a})

// i64.const $imm64
// i64.add
// i32.wrap_i64
// i32.const $mask (L1 or L2)
// i32.and
// i32.const $scratchpad
// i32.add
// i64.load align=2
#define SCRATCHPAD_LOAD_L1_L2(inst) \
	SCRATCHPAD_PTR_L1_L2(inst);     \
	WASM_U8_THUNK({0x29, 2, 0})

// i64.const $imm64
// i64.add
// i32.wrap_i64
// i32.const $mask (L1 or L2)
// i32.and
// i32.const $scratchpad
// i32.add
// v128.load64_zero align=3 offset=0
// f64x2.convert_low_i32x4_s
#define SCRATCHPAD_LOAD_F_L1_L2(inst) \
	SCRATCHPAD_PTR_L1_L2(inst);       \
	WASM_U8_THUNK({0xfd, 0x5d, 3, 0, 0xfd, 0xfe, 0x01})

// i64.const $imm64
// i64.add
// i32.wrap_i64
// i32.const $mask (L1 or L2)
// i32.and
// i32.const $scratchpad
// i32.add
// v128.load64_zero align=3 offset=0
// f64x2.convert_low_i32x4_s
// local.get $mask_mant
// v128.and
// local.get $mask_exp
// v128.or
#define SCRATCHPAD_LOAD_E_L1_L2(inst) \
	SCRATCHPAD_PTR_L1_L2(inst);       \
	WASM_U8_THUNK({0xfd, 0x5d, 3, 0, 0xfd, 0xfe, 0x01, 0x20, $mask_mant, 0xfd, 0x4e, 0x20, $mask_exp, 0xfd, 0x50})

// i64.const $imm64
// i32.wrap_i64
// i32.const $mask (L3)
// i32.and
// i32.const $scratchpad
// i32.add
// i64.load align=2
#define SCRATCHPAD_DIRECT_LOAD_L3(inst) \
	SCRATCHPAD_DIRECT_PTR_L3(inst);     \
	WASM_U8_THUNK({0x29, 2, 0})

#if INSTRUMENT == 1

// call out to the function import e.d, for instrumentation
static uint32_t breakpoint(rx_vm_t *VM, uint8_t *buf, int pc) {
	THUNK_BEGIN;

	// (ic: i32, pc: i32, mx: i32, ma: i32, sp_addr0: i32, sp_addr1: i32) -> ()

	p += epilogue_store_registers(VM, p);

	WASM_U8_THUNK({
		0x20, $ic, // local.get $ic
		0x41,      // i32.const
	});
	WASM_I32(pc); // $pc
	WASM_U8_THUNK({
		0x20, $mx,       // local.get $mx
		0x20, $ma,       // local.get $ma
		0x20, $sp_addr0, // local.get $sp_addr0
		0x20, $sp_addr1, // local.get $sp_addr1
		0x10, 1,         // call 1 (import e.d)
	});

	THUNK_END;
}

#endif

uint32_t jit_vm_insts(rx_vm_t *VM, rx_inst_t insts[RANDOMX_PROGRAM_SIZE], jit_jump_desc_t jump_desc[RANDOMX_PROGRAM_SIZE], uint8_t *scratchpad, uint8_t *buf) {
	THUNK_BEGIN;

#if INSTRUMENT == 1
	p += breakpoint(VM, p, -1);
#endif

	for (int pc = 0; pc < RANDOMX_PROGRAM_SIZE; pc++) {
		rx_inst_t *inst = &insts[pc];

		if (jump_desc[pc].target) {
			WASM_U8_THUNK({
				0x03, 0x40, // loop () -> ()
			});
		}

		switch (inst->opcode) {
		case IADD_RS:
			if (inst->dst != REGISTER_NEEDS_DISPLACEMENT) {
				// dst = dst + (src << mod)
				WASM_U8_THUNK({
					0x20, R(inst->dst),         // local.get $dest
					0x20, R(inst->src),         // local.get $src
					0x42, MOD_SHIFT(inst->mod), // i64.const $scale
					0x86,                       // i64.shl
					0x7c,                       // i64.add
					0x21, R(inst->dst),         // local.set $dest
				});
			} else {
				// dst = dst + (src << mod) + imm64
				WASM_U8_THUNK({
					0x20, R(inst->dst),         // local.get $dest
					0x20, R(inst->src),         // local.get $src
					0x42, MOD_SHIFT(inst->mod), // i64.const $scale
					0x86,                       // i64.shl
					0x7c,                       // i64.add
					0x42,                       // i64.const
				});
				WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
				WASM_U8_THUNK({
					0x7c,               // i64.add
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IADD_M:
			if (inst->src != inst->dst) {
				// dst = dst + [src + imm64 & mod.mem ? L1 : L2]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
				});
				SCRATCHPAD_LOAD_L1_L2(inst);
				WASM_U8_THUNK({
					0x7c,               // i64.add
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst + [imm64 & L3]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_DIRECT_LOAD_L3(inst);
				WASM_U8_THUNK({
					0x7c,               // i64.add
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case ISUB_R:
			if (inst->src != inst->dst) {
				// dst = dst - src
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
					0x7d,               // i64.sub
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst - imm64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x42,               // i64.const
				});
				WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
				WASM_U8_THUNK({
					0x7d,               // i64.sub
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case ISUB_M:
			if (inst->src != inst->dst) {
				// dst = dst - [src + imm64 & mod.mem ? L1 : L2]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
				});
				SCRATCHPAD_LOAD_L1_L2(inst);
				WASM_U8_THUNK({
					0x7d,               // i64.sub
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst - [imm64 & L3]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_DIRECT_LOAD_L3(inst);
				WASM_U8_THUNK({
					0x7d,               // i64.sub
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IMUL_R:
			if (inst->src != inst->dst) {
				// dst = dst * src
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
					0x7e,               // i64.mul
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst * imm64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x42,               // i64.const
				});
				WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
				WASM_U8_THUNK({
					0x7e,               // i64.mul
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IMUL_M:
			if (inst->src != inst->dst) {
				// dst = dst * [src + imm64 & mod.mem ? L1 : L2]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
				});
				SCRATCHPAD_LOAD_L1_L2(inst);
				WASM_U8_THUNK({
					0x7e,               // i64.mul
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst * [imm64 & L3]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_DIRECT_LOAD_L3(inst);
				WASM_U8_THUNK({
					0x7e,               // i64.mul
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IMULH_R:
			// dst = dst * src >> 64
			WASM_U8_THUNK({
				0x20, R(inst->dst), // local.get $dest
				0x20, R(inst->src), // local.get $src
				0x10, $MUL128HI,    // call $mul128hi (unsigned)
				0x21, R(inst->dst), // local.set $dest
			});
			break;
		case IMULH_M:
			if (inst->src != inst->dst) {
				// dst = dst * [src + imm64 & mod.mem ? L1 : L2] >> 64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
				});
				SCRATCHPAD_LOAD_L1_L2(inst);
				WASM_U8_THUNK({
					0x10, $MUL128HI,    // call $mul128hi (unsigned)
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst * [imm64 & L3] >> 64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_DIRECT_LOAD_L3(inst);
				WASM_U8_THUNK({
					0x10, $MUL128HI,    // call $mul128hi (unsigned)
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case ISMULH_R:
			// dst = dst * src >> 64
			WASM_U8_THUNK({
				0x20, R(inst->dst), // local.get $dest
				0x20, R(inst->src), // local.get $src
				0x10, $IMUL128HI,   // call $imul128hi (signed)
				0x21, R(inst->dst), // local.set $dest
			});
			break;
		case ISMULH_M:
			if (inst->src != inst->dst) {
				// dst = dst * [src + imm64 & mod.mem ? L1 : L2] >> 64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
				});
				SCRATCHPAD_LOAD_L1_L2(inst);
				WASM_U8_THUNK({
					0x10, $IMUL128HI,   // call $imul128hi (signed)
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst * [imm64 & L3] >> 64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_DIRECT_LOAD_L3(inst);
				WASM_U8_THUNK({
					0x10, $IMUL128HI,   // call $imul128hi (signed)
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IMUL_RCP:
			// dst = dst / imm32 (where reciprocal can be computed)
			// dst = dst * reciprocal
			WASM_U8_THUNK({
				0x20, R(inst->dst), // local.get $dest
				0x42,               // i64.const
			});
			WASM_I64(jit_reciprocal(inst->imm32)); // $reciprocal
			WASM_U8_THUNK({
				0x7e,               // i64.mul
				0x21, R(inst->dst), // local.set $dest
			});
			break;
		case INEG_R:
			// negation is webassembly is expressed as 0 - x
			// dst = -dst
			WASM_U8_THUNK({
				0x42, 0,            // i64.const 0
				0x20, R(inst->dst), // local.get $dest
				0x7d,               // i64.sub
				0x21, R(inst->dst), // local.set $dest
			});
			break;
		case IXOR_R:
			if (inst->src != inst->dst) {
				// dst = dst ^ src
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
					0x85,               // i64.xor
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst ^ imm64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x42,               // i64.const
				});
				WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
				WASM_U8_THUNK({
					0x85,               // i64.xor
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IXOR_M:
			if (inst->src != inst->dst) {
				// dst = dst ^ [src + imm64 & mod.mem ? L1 : L2]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
				});
				SCRATCHPAD_LOAD_L1_L2(inst);
				WASM_U8_THUNK({
					0x85,               // i64.xor
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst ^ [imm64 & L3]
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_DIRECT_LOAD_L3(inst);
				WASM_U8_THUNK({
					0x85,               // i64.xor
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IROR_R:
			if (inst->src != inst->dst) {
				// dst = dst >> src
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
					0x8a,               // i64.rotr
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst >> imm64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x42,               // i64.const
				});
				WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
				WASM_U8_THUNK({
					0x8a,               // i64.rotr
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case IROL_R:
			if (inst->src != inst->dst) {
				// dst = dst << src
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x20, R(inst->src), // local.get $src
					0x89,               // i64.rotl
					0x21, R(inst->dst), // local.set $dest
				});
			} else {
				// dst = dst << imm64
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
					0x42,               // i64.const
				});
				WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
				WASM_U8_THUNK({
					0x89,               // i64.rotl
					0x21, R(inst->dst), // local.set $dest
				});
			}
			break;
		case ISWAP_R:
			// dst, src = src, dst
			WASM_U8_THUNK({
				0x20, R(inst->dst), // local.get $dest
				0x20, R(inst->src), // local.get $src
				0x21, R(inst->dst), // local.set $dest
				0x21, R(inst->src), // local.set $src
			});
			break;
		case FSWAP_R: {
			// perform a swap using a i8x16.swizzle
			// element 0 : 8, 9, 10, 11, 12, 13, 14, 15,
			// element 1 : 0, 1,  2,  3,  4,  5,  6,  7

			int wdst = inst->dst < 4 ? F(inst->dst) : E(inst->dst - 4);

			WASM_U8_THUNK({
				0x20, wdst,                                           // local.get $dest
				0xfd, 0x0c, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, // v128.const 0x0b0a0908 0x0f0e0d0c 0x03020100 0x07060504
				0x0f, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, //
			});

			// (dst0, dst1) = (dst1, dst0)
			if (jit_feature & JIT_RELAXED_SIMD) {
				// using relaxed_swizzle instead of swizzle will only really help baseline jits
				WASM_U8_THUNK({
					0xfd, 0x80, 0x02, // i8x16.relaxed_swizzle
				});
			} else {
				WASM_U8_THUNK({
					0xfd, 0x0e, // i8x16.swizzle
				});
			}

			WASM_U8_THUNK({
				0x21, wdst, // local.set $dest
			});
			break;
		}
		case FADD_R:
			// dst = dst + src
			WASM_U8_THUNK({
				0x20, F(inst->dst), // local.get $dest
				0x20, A(inst->src), // local.get $src
				0x23, $fprc,        // global.get $fprc
				0x11, 3, 0,         // call_indirect table 0, type (v128, v128) -> v128
				0x21, F(inst->dst), // local.set $dest
			});
			break;
		case FADD_M:
			// dst = dst + [src + imm64 & mod.mem ? L1 : L2]
			WASM_U8_THUNK({
				0x20, F(inst->dst), // local.get $dest
				0x20, R(inst->src), // local.get $src
			});
			SCRATCHPAD_LOAD_F_L1_L2(inst);
			WASM_U8_THUNK({
				0x23, $fprc,        // global.get $fprc
				0x11, 3, 0,         // call_indirect table 0, type (v128, v128) -> v128
				0x21, F(inst->dst), // local.set $dest
			});
			break;
		case FSUB_R:
			// dst = dst - src
			WASM_U8_THUNK({
				0x20, F(inst->dst), // local.get $dest
				0x20, A(inst->src), // local.get $src
				0x23, $fprc,        // global.get $fprc
				0x11, 3, 1,         // call_indirect table 1, type (v128, v128) -> v128
				0x21, F(inst->dst), // local.set $dest
			});
			break;
		case FSUB_M:
			// dst = dst - [src + imm64 & mod.mem ? L1 : L2]
			WASM_U8_THUNK({
				0x20, F(inst->dst), // local.get $dest
				0x20, R(inst->src), // local.get $src
			});
			SCRATCHPAD_LOAD_F_L1_L2(inst);
			WASM_U8_THUNK({
				0x23, $fprc,        // global.get $fprc
				0x11, 3, 1,         // call_indirect table 1, type (v128, v128) -> v128
				0x21, F(inst->dst), // local.set $dest
			});
			break;
		case FSCAL_R:
			// (dst0, dst1) = (dst0 ^ 0x80F0000000000000, dst0 ^ 0x80F0000000000000)
			WASM_U8_THUNK({
				0x20, F(inst->dst),                                   // local.get $dest
				0xfd, 0x0c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, // v128.const 0x00000000 0x80f00000 0x00000000 0x80f00000
				0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x80, //
				0xfd, 0x51,                                           // v128.xor
				0x21, F(inst->dst),                                   // local.set $dest
			});
			break;
		case FMUL_R:
			// dst = dst * src
			WASM_U8_THUNK({
				0x20, E(inst->dst), // local.get $dest
				0x20, A(inst->src), // local.get $src
				0x23, $fprc,        // global.get $fprc
				0x11, 3, 2,         // call_indirect table 2, type (v128, v128) -> v128
				0x21, E(inst->dst), // local.set $dest
			});
			break;
		case FDIV_M:
			// dst = dst * [src + imm64 & mod.mem ? L1 : L2]
			WASM_U8_THUNK({
				0x20, E(inst->dst), // local.get $dest
				0x20, R(inst->src), // local.get $src
			});
			SCRATCHPAD_LOAD_E_L1_L2(inst);
			WASM_U8_THUNK({
				0x23, $fprc,        // global.get $fprc
				0x11, 3, 3,         // call_indirect table 3, type (v128, v128) -> v128
				0x21, E(inst->dst), // local.set $dest
			});
			break;
		case FSQRT_R:
			// dst = sqrt(dst)
			WASM_U8_THUNK({
				0x20, E(inst->dst), // local.get $dest
				0x23, $fprc,        // global.get $fprc
				0x11, 4, 4,         // call_indirect table 4, type (v128) -> v128
				0x21, E(inst->dst), // local.set $dest
			});
			break;
		case CBRANCH: {
			jit_jump_desc_t *jd = &jump_desc[pc];

			// dst += imm
			// if (dst & mask == 0) pc = target
			WASM_U8_THUNK({
				0x20, R(inst->dst), // local.get $dest
				0x42,               // i64.const
			});
			WASM_I64(jd->imm); // $imm64
			WASM_U8_THUNK({
				0x7c,               // i64.add
				0x22, R(inst->dst), // local.tee $dest
				0x42,               // i64.const
			});
			WASM_I64((uint64_t)jd->mask);
			WASM_U8_THUNK({
				0x83,    // i64.and
				0x50,    // i64.eqz
				0x0d, 0, // br_if
				0x0b,    // end (loop enclosed by target)
			});
			break;
		}
		case CFROUND:
			// fprc = (src >>> imm) & 3
			WASM_U8_THUNK({
				0x20, R(inst->src), // local.get $src
				0x42,               // i64.const
			});
			WASM_I64(inst->imm32 & 63); // $imm
			WASM_U8_THUNK({
				0x8a,        // i64.rotr
				0xa7,        // i32.wrap_i64
				0x41, 3,     // i32.const 3
				0x71,        // i32.and
				0x24, $fprc, // global.set $fprc
			});
			break;
		case ISTORE:
			// store L3 condition
			if (MOD_COND(inst->mod) < 14) {
				// [dst + imm64 & mod.mem ? L1 : L2] = src
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_PTR_L1_L2(inst);
				WASM_U8_THUNK({
					0x20, R(inst->src), // local.get $src
					0x37, 2, 0,         // i64.store align=2
				});
			} else {
				// [dst + imm64 & L3] = src
				WASM_U8_THUNK({
					0x20, R(inst->dst), // local.get $dest
				});
				SCRATCHPAD_PTR_L3(inst);
				WASM_U8_THUNK({
					0x20, R(inst->src), // local.get $src
					0x37, 2, 0,         // i64.store align=2
				});
			}
			break;
		case NOP:
			break;
		default:
			unreachable();
		}

#if INSTRUMENT == 1 // 1 to enable
		p += breakpoint(VM, p, pc);
#endif
	}

	THUNK_END;
}
