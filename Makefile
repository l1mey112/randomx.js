# bun build.ts (will execute this Makefile)

WAT_SOURCES := $(shell find . -type f -name '*.wat' -not -path './node_modules/*')
WAT_WASM_FILES := $(patsubst %.wat,%.wasm,$(WAT_SOURCES))

C_SOURCES := $(shell find . -type f -name '*.c' -not -path './node_modules/*')
MAIN_C_SOURCES := $(shell find . -type f -name 'main.c' -not -path './node_modules/*')
MAIN_C_WASM_FILES := $(patsubst %.c,%.wasm,$(MAIN_C_SOURCES))
MAIN_C_JS_FILES := $(patsubst %.c,%.js,$(MAIN_C_SOURCES))

HEADER_FILES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')
HEADER_FILES += include/configuration.h

define newline


endef

define js_template
export default async function main(imports) {
	imports = { "e": imports }

	const wasm = await import('./main.wasm')
	const mod = await WebAssembly.instantiate(wasm, imports)
	return mod.instance.exports
}
endef

all: $(WAT_WASM_FILES) $(MAIN_C_JS_FILES) $(MAIN_C_WASM_FILES)

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

%main.js: %main.wasm
	printf "$(subst $(newline),\n,${js_template})" > $@
