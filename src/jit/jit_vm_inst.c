#include "configuration.h"
#include "freestanding.h"
#include "inst.h"
#include "jit.h"
#include "jit_vm.h"
#include "vm/vm.h"
#include "wasm_jit.h"

#include <stdint.h>

#define OPCODE_CEIL_DECLARE(curr, prev) static const int ceil_##curr = ceil_##prev + RANDOMX_FREQ_##curr;
static const int ceil_NULL = 0;
OPCODE_CEIL_DECLARE(IADD_RS, NULL);
OPCODE_CEIL_DECLARE(IADD_M, IADD_RS);
OPCODE_CEIL_DECLARE(ISUB_R, IADD_M);
OPCODE_CEIL_DECLARE(ISUB_M, ISUB_R);
OPCODE_CEIL_DECLARE(IMUL_R, ISUB_M);
OPCODE_CEIL_DECLARE(IMUL_M, IMUL_R);
OPCODE_CEIL_DECLARE(IMULH_R, IMUL_M);
OPCODE_CEIL_DECLARE(IMULH_M, IMULH_R);
OPCODE_CEIL_DECLARE(ISMULH_R, IMULH_M);
OPCODE_CEIL_DECLARE(ISMULH_M, ISMULH_R);
OPCODE_CEIL_DECLARE(IMUL_RCP, ISMULH_M);
OPCODE_CEIL_DECLARE(INEG_R, IMUL_RCP);
OPCODE_CEIL_DECLARE(IXOR_R, INEG_R);
OPCODE_CEIL_DECLARE(IXOR_M, IXOR_R);
OPCODE_CEIL_DECLARE(IROR_R, IXOR_M);
OPCODE_CEIL_DECLARE(IROL_R, IROR_R);
OPCODE_CEIL_DECLARE(ISWAP_R, IROL_R);
OPCODE_CEIL_DECLARE(FSWAP_R, ISWAP_R);
OPCODE_CEIL_DECLARE(FADD_R, FSWAP_R);
OPCODE_CEIL_DECLARE(FADD_M, FADD_R);
OPCODE_CEIL_DECLARE(FSUB_R, FADD_M);
OPCODE_CEIL_DECLARE(FSUB_M, FSUB_R);
OPCODE_CEIL_DECLARE(FSCAL_R, FSUB_M);
OPCODE_CEIL_DECLARE(FMUL_R, FSCAL_R);
OPCODE_CEIL_DECLARE(FDIV_M, FMUL_R);
OPCODE_CEIL_DECLARE(FSQRT_R, FDIV_M);
OPCODE_CEIL_DECLARE(CBRANCH, FSQRT_R);
OPCODE_CEIL_DECLARE(CFROUND, CBRANCH);
OPCODE_CEIL_DECLARE(ISTORE, CFROUND);
OPCODE_CEIL_DECLARE(NOP, ISTORE);
#undef OPCODE_CEIL_DECLARE

// WASM is always a two's complement machine, we can just cast
#define IMM_SEXT64(x) ((int64_t)(int32_t)(x))

#define SCRATCHPAD_L1_MASK ((RANDOMX_SCRATCHPAD_L1 / 8 - 1) * 8)
#define SCRATCHPAD_L2_MASK ((RANDOMX_SCRATCHPAD_L2 / 8 - 1) * 8)
#define SCRATCHPAD_L3_MASK ((RANDOMX_SCRATCHPAD_L3 / 8 - 1) * 8)

// i32.wrap_i64
// i32.const $mask (L1 or L2)
// i32.and
// i32.const $scratchpad
// i32.add
// i64.load align=2
#define SCRATCHPAD_LOAD_L1_L2(inst)                                         \
	WASM_U8_THUNK({0xa7, 0x41});                                            \
	WASM_I64(MOD_MEM(inst->mod) ? SCRATCHPAD_L1_MASK : SCRATCHPAD_L2_MASK); \
	WASM_U8_THUNK({0x71, 0x41});                                            \
	WASM_I64((int64_t)scratchpad);                                          \
	WASM_U8_THUNK({0x6a, 0x29, 2, 0});

// i32.wrap_i64
// i32.const $mask (L3)
// i32.and
// i32.const $scratchpad
// i32.add
// i64.load align=2
#define SCRATCHPAD_LOAD_L3(inst)   \
	WASM_U8_THUNK({0xa7, 0x41});   \
	WASM_I64(SCRATCHPAD_L3_MASK);  \
	WASM_U8_THUNK({0x71, 0x41});   \
	WASM_I64((int64_t)scratchpad); \
	WASM_U8_THUNK({0x6a, 0x29, 2, 0});

uint32_t jit_vm_inst(INST_JIT_PARAMS) {
	THUNK_BEGIN;

	int opcode = inst->opcode;

	if (opcode < ceil_IADD_RS) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (dst != REGISTER_NEEDS_DISPLACEMENT) {
			// dst = dst + (src << mod)
			WASM_U8_THUNK({
				0x20, R(dst),               // local.get $dest
				0x20, R(src),               // local.get $src
				0x42, MOD_SHIFT(inst->mod), // i64.const $scale
				0x86,                       // i64.shl
				0x7c,                       // i64.add
				0x21, R(dst),               // local.set $dest
			});
		} else {
			// dst = dst + (src << mod) + imm64
			WASM_U8_THUNK({
				0x20, R(dst),               // local.get $dest
				0x20, R(src),               // local.get $src
				0x42, MOD_SHIFT(inst->mod), // i64.const $scale
				0x86,                       // i64.shl
				0x7c,                       // i64.add
				0x42,                       // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7c,         // i64.add
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IADD_M) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst + [src + imm64 & mod.mem ? L1 : L2]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7c, // i64.add
			});
			SCRATCHPAD_LOAD_L1_L2(inst);
			WASM_U8_THUNK({
				0x7c,         // i64.add
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst + [imm64 & L3]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			SCRATCHPAD_LOAD_L3(inst);
			WASM_U8_THUNK({
				0x7c,         // i64.add
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_ISUB_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst - src
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x7e,         // i64.sub
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst - imm64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7e,         // i64.sub
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_ISUB_M) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst - [src + imm64 & mod.mem ? L1 : L2]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7c, // i64.add
			});
			SCRATCHPAD_LOAD_L1_L2(inst);
			WASM_U8_THUNK({
				0x7e,         // i64.sub
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst - [imm64 & L3]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			SCRATCHPAD_LOAD_L3(inst);
			WASM_U8_THUNK({
				0x7e,         // i64.sub
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IMUL_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst * src
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x7e,         // i64.mul
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst * imm64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7e,         // i64.mul
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IMUL_M) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst * [src + imm64 & mod.mem ? L1 : L2]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7c, // i64.add
			});
			SCRATCHPAD_LOAD_L1_L2(inst);
			WASM_U8_THUNK({
				0x7e,         // i64.mul
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst * [imm64 & L3]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			SCRATCHPAD_LOAD_L3(inst);
			WASM_U8_THUNK({
				0x7e,         // i64.mul
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IMULH_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		// dst = dst * src >> 64
		WASM_U8_THUNK({
			0x20, R(dst),    // local.get $dest
			0x20, R(src),    // local.get $src
			0x10, $MUL128HI, // call $mul128hi (unsigned)
			0x21, R(dst),    // local.set $dest
		});

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IMULH_M) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst * [src + imm64 & mod.mem ? L1 : L2] >> 64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7c, // i64.add
			});
			SCRATCHPAD_LOAD_L1_L2(inst);
			WASM_U8_THUNK({
				0x10, $MUL128HI, // call $mul128hi (unsigned)
				0x21, R(dst),    // local.set $dest
			});
		} else {
			// dst = dst * [imm64 & L3] >> 64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			SCRATCHPAD_LOAD_L3(inst);
			WASM_U8_THUNK({
				0x10, $MUL128HI, // call $mul128hi (unsigned)
				0x21, R(dst),    // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_ISMULH_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		// dst = dst * src >> 64
		WASM_U8_THUNK({
			0x20, R(dst),     // local.get $dest
			0x20, R(src),     // local.get $src
			0x10, $IMUL128HI, // call $imul128hi (signed)
			0x21, R(dst),     // local.set $dest
		});

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_ISMULH_M) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst * [src + imm64 & mod.mem ? L1 : L2] >> 64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7c, // i64.add
			});
			SCRATCHPAD_LOAD_L1_L2(inst);
			WASM_U8_THUNK({
				0x10, $IMUL128HI, // call $imul128hi (signed)
				0x21, R(dst),     // local.set $dest
			});
		} else {
			// dst = dst * [imm64 & L3] >> 64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			SCRATCHPAD_LOAD_L3(inst);
			WASM_U8_THUNK({
				0x10, $IMUL128HI, // call $imul128hi (signed)
				0x21, R(dst),     // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IMUL_RCP) {
		int dst = inst->dst % 8;
		uint32_t divisor = inst->imm32;

		if (!POWER_OF_ZERO_OR_TWO(divisor)) {
			// dst = dst / imm32 (where reciprocal can be computed)
			uint32_t reciprocal = jit_reciprocal(divisor);

			// dst = dst * reciprocal
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(reciprocal)); // $reciprocal
			WASM_U8_THUNK({
				0x7e,         // i64.mul
				0x21, R(dst), // local.set $dest
			});

			register_usage[dst] = i;
		}

		THUNK_END;
	}

	if (opcode < ceil_INEG_R) {
		int dst = inst->dst % 8;

		// negation is webassembly is expressed as 0 - x

		// dst = -dst
		WASM_U8_THUNK({
			0x42, 0,      // i64.const 0
			0x20, R(dst), // local.get $dest
			0x7d,         // i64.sub
			0x21, R(dst), // local.set $dest
		});

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IXOR_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst ^ src
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x85,         // i64.xor
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst ^ imm64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x85,         // i64.xor
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IXOR_M) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst ^ [src + imm64 & mod.mem ? L1 : L2]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x7c, // i64.add
			});
			SCRATCHPAD_LOAD_L1_L2(inst);
			WASM_U8_THUNK({
				0x85,         // i64.xor
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst ^ [imm64 & L3]
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			SCRATCHPAD_LOAD_L3(inst);
			WASM_U8_THUNK({
				0x85,         // i64.xor
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IROR_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst >> src
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x8a,         // i64.rotr
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst >> imm64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x8a,         // i64.rotr
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_IROL_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst = dst << src
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x89,         // i64.rotl
				0x21, R(dst), // local.set $dest
			});
		} else {
			// dst = dst << imm64
			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x42,         // i64.const
			});
			WASM_I64(IMM_SEXT64(inst->imm32)); // $imm64
			WASM_U8_THUNK({
				0x89,         // i64.rotl
				0x21, R(dst), // local.set $dest
			});
		}

		register_usage[dst] = i;
		THUNK_END;
	}

	if (opcode < ceil_ISWAP_R) {
		int dst = inst->dst % 8;
		int src = inst->src % 8;

		if (src != dst) {
			// dst, src = src, dst

			WASM_U8_THUNK({
				0x20, R(dst), // local.get $dest
				0x20, R(src), // local.get $src
				0x21, R(dst), // local.set $dest
				0x21, R(src), // local.set $src
			});

			register_usage[dst] = i;
			register_usage[src] = i;
		}

		THUNK_END;
	}

	if (opcode < ceil_FSWAP_R) {
		int dst = inst->dst % 8;

		if (dst < 4) {
			// F(dst)
		} else {
			// E(dst - 4)
		}

		// TODO: impl
	}

	if (opcode < ceil_FADD_R) {
		int dst = inst->dst % 4;
		int src = inst->src % 4;

		WASM_U8_THUNK({
			0x20, F(dst), // local.get $dest
			0x20, A(src), // local.get $src
			0x23, $fprc,  // global.get $fprc
			0x11, 3, 0,   // call_indirect table 0, type (v128, v128) -> v128
			0x21, F(dst), // local.set $dest
		});
	}

	THUNK_END;
}
