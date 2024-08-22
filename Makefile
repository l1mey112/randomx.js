# bun build.ts (will execute this Makefile)

WAT_SOURCES := $(shell find . -type f -name '*.wat' -not -path './node_modules/*')
WAT_WASM_FILES := $(patsubst %.wat,%.wasm,$(WAT_SOURCES))

MAIN_C_SOURCES := $(shell find . -type f -name 'main.c' -not -path './node_modules/*')
MAIN_C_WASM_FILES := $(patsubst %.c,%.wasm,$(MAIN_C_SOURCES))
MAIN_C_ASM_JS_FILES := $(patsubst %.c,%.asmjs.js,$(MAIN_C_SOURCES))
MAIN_C_WASM_JS_FILES := $(patsubst %.c,%.wasmjs.js,$(MAIN_C_SOURCES))
MAIN_C_JS_FILES := $(patsubst %.c,%.js,$(MAIN_C_SOURCES))

define newline


endef

define wasmjs_template
import wasm from './main.wasm'

export async function exports() {
	const mod = await WebAssembly.instantiate(wasm)
	return mod.instance.exports
}
endef

define js_template
export default async function main(feature) {
	if (feature === 'js') {
		const m = await import('./main.asmjs')
		return m
	} else {
		const m = await import('./main.wasmjs')
		return await m.exports()
	}
}
endef

all: $(WAT_WASM_FILES) $(MAIN_C_WASM_FILES) $(MAIN_C_ASM_JS_FILES) $(MAIN_C_WASM_JS_FILES) $(MAIN_C_JS_FILES)

%.wasm: %.wat
	wat2wasm --enable-all $< -o $@

%main.wasm: %main.c
	clang --target=wasm32 -nostdlib -fno-builtin -Iinclude \
		-O3 -msimd128 -mbulk-memory \
		-Wl,--no-entry -Wl,-z,stack-size=8192 \
		-o $@ $<

	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@

%main.asmjs.js: %main.wasm
	wasm2js -all $< -o $@

%main.wasmjs.js: %main.wasm
	echo -e "$(subst $(newline),\n,${wasmjs_template})" > $@

%main.js: %main.asmjs.js %main.wasmjs.js
	echo -e "$(subst $(newline),\n,${js_template})" > $@
	