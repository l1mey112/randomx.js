# bun build.ts (will execute this Makefile)

WAT_SOURCES := $(shell find . -type f -name '*.wat')
WAT_WASM_FILES := $(patsubst %.wat,%.wasm,$(WAT_SOURCES))

MAIN_C_SOURCES := $(shell find . -type f -name 'main.c')
MAIN_C_WASM_FILES := $(patsubst %.c,%.wasm,$(MAIN_C_SOURCES))
MAIN_C_JS_FILES := $(patsubst %.c,%.asmjs.js,$(MAIN_C_SOURCES))


all: $(WAT_WASM_FILES) $(MAIN_C_WASM_FILES) $(MAIN_C_JS_FILES)

%.wasm: %.wat
	wat2wasm --enable-all $< -o $@

%main.wasm: %main.c
	clang --target=wasm32 -nostdlib -fno-builtin -I./include \
		-O3 -msimd128 -mbulk-memory \
		-Wl,--no-entry -Wl,-z,stack-size=8192 \
		-o $@ $<

	wasm-strip $@
	wasm-opt -all -Oz $@ -o $@

%main.asmjs.js: %main.wasm
	wasm2js -all $< -o $@
