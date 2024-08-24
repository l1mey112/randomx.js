# bun build.ts (will execute this Makefile)

WAT_SOURCES := $(shell find . -type f -name '*.wat' -not -path './node_modules/*')
WAT_WASM_FILES := $(patsubst %.wat,%.wasm,$(WAT_SOURCES))

C_SOURCES := $(shell find . -type f -name '*.c' -not -path './node_modules/*')
MAIN_C_SOURCES := $(shell find . -type f -name 'main.c' -not -path './node_modules/*')
MAIN_C_WASM_FILES := $(patsubst %.c,%.wasm,$(MAIN_C_SOURCES))
MAIN_C_WASM_NO_OPT_FILES := $(patsubst %.c,%.asmjs.wasm,$(MAIN_C_SOURCES))
MAIN_C_ASM_JS_FILES := $(patsubst %.c,%.asmjs.js,$(MAIN_C_SOURCES))
MAIN_C_WASM_JS_FILES := $(patsubst %.c,%.wasmjs.js,$(MAIN_C_SOURCES))
MAIN_C_JS_FILES := $(patsubst %.c,%.js,$(MAIN_C_SOURCES))

HEADER_FILES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')
HEADER_FILES += include/configuration.h

define newline


endef

define wasmjs_template
import wasm from './main.wasm'

export async function exports(imports) {
	const mod = await WebAssembly.instantiate(wasm, imports)
	return mod.instance.exports
}
endef

define js_template
export default async function main(feature, imports) {
	imports ||= {}
	imports = { "e": imports }
	
	if (feature === 0) {
		const m = await import('./main.asmjs')
		return m.asmFunc(imports)
	} else {
		const m = await import('./main.wasmjs')
		return await m.exports(imports)
	}
}
endef

all: $(WAT_WASM_FILES) $(MAIN_C_WASM_FILES) $(MAIN_C_ASM_JS_FILES) $(MAIN_C_WASM_JS_FILES) $(MAIN_C_JS_FILES) $(MAIN_C_WASM_NO_OPT_FILES)

include/configuration.h: include/configuration.ts
	sed '/export const/ { s/export const /#define /; s/ = / /; s/;//; }; /^\/\// { s/^\/\///; }; /^#/!d' $< > $@

%.wasm: %.wat
	wat2wasm --enable-all $< -o $@

%main.wasm: $(C_SOURCES) $(HEADER_FILES)
	clang --target=wasm32 -nostdlib -fno-builtin -Iinclude \
		-O3 -msimd128 -mbulk-memory \
		-Wl,--no-entry -Wl,-z,stack-size=8192 \
		-o $@ $(C_SOURCES)

	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@

# no -msimd128 as that causes unaligned load crashes in wasm2js
# use DWASM_NO_OPT to reduce code size by disabling unrolling etc

# -Oz/-Os BREAKS THE FUCKING JS EXECUTABLE

%main.asmjs.wasm: $(C_SOURCES) $(HEADER_FILES)
	clang --target=wasm32 -nostdlib -fno-builtin -Iinclude \
		-O -mbulk-memory -DWASM_NO_OPT \
		-Wl,--no-entry -Wl,-z,stack-size=8192 \
		-o $@ $(C_SOURCES)

	wasm-strip $@
	wasm-opt -all -Oz $@ -o $@

%main.asmjs.js: %main.asmjs.wasm
	wasm2js -all $< -o $@
	sed -i '/^\s*import/ d' $@
	sed -i 's/function asmFunc(\(.*\)) {/export function asmFunc(\1) {"use asm";/' $@
	perl -0777 -i -pe 's/var retasmFunc.*//igs' $@

%main.wasmjs.js: %main.wasm
	printf "$(subst $(newline),\n,${wasmjs_template})" > $@

%main.js: %main.asmjs.js %main.wasmjs.js
	printf "$(subst $(newline),\n,${js_template})" > $@
