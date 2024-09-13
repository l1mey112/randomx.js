#include "configuration.h"
#include "inst.h"
#include "jit.h"
#include "ssh.h"
#include "vm/vm.h"
#include "wasm_jit.h"

#include <stdint.h>

uint32_t jit_vm(rx_vm_t *VM, const rx_program_t *P, uint8_t *buf) {
	THUNK_BEGIN

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
			WASM_U8(0); // local entries = vec(0)
			WASM_U8(0x0B); // end
		});
	});

	THUNK_END
}
