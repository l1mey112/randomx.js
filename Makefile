## bun build.ts (will execute this Makefile)
#
#WAT_SOURCES := $(shell find . -type f -name '*.wat' -not -path './node_modules/*')
#WAT_WASM_FILES := $(patsubst %.wat,%.wasm,$(WAT_SOURCES))
#
#C_SOURCES := $(shell find . -type f -name '*.c' -not -path './node_modules/*')
#MAIN_C_SOURCES := $(shell find . -type f -name 'main.c' -not -path './node_modules/*')
#MAIN_C_WASM_FILES := $(patsubst %.c,%.wasm,$(MAIN_C_SOURCES))
#MAIN_C_JS_FILES := $(patsubst %.c,%.js,$(MAIN_C_SOURCES))
#
#HEADER_FILES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')
#HEADER_FILES += include/configuration.h
#
#all: $(WAT_WASM_FILES) $(MAIN_C_JS_FILES) $(MAIN_C_WASM_FILES)
#
#include/configuration.h: include/configuration.ts
#	sed '/export const/ { s/export const /#define /; s/ = / /; s/;//; }; /^\/\// { s/^\/\///; }; /^#/!d' $< > $@
#
#%.wasm: %.wat
#	wat2wasm --enable-all $< -o $@

#%main.wasm: $(C_SOURCES) $(HEADER_FILES)
#	clang --target=wasm32 -nostdlib -fno-builtin -Iinclude \
#		-O3 -msimd128 -mbulk-memory \
#		-Wl,--no-entry -Wl,-z,stack-size=8192 \
#		-o $@ $(C_SOURCES)
#
#	wasm-strip $@
#	wasm-opt -all -O4 -Oz $@ -o $@
#
#%main.js: %main.wasm
#	printf "$(subst $(newline),\n,${js_template})" > $@

H_SOURCES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')
H_SOURCES += include/configuration.h

PRINTF_C_SOURCES := $(shell find src/printf -type f -name '*.c')
BLAKE2B_C_SOURCES := $(shell find src/blake2b -type f -name '*.c') $(PRINTF_C_SOURCES)
DATASET_C_SOURCES := $(sort $(shell find src/dataset -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES))

LDFLAGS = -Wl,--no-entry -Wl,-z,stack-size=8192
CFLAGS = --target=wasm32 -nostdlib -fno-builtin -Iinclude \
	-msimd128 -mbulk-memory -matomics

# -Wl,--shared-memory to use shared memory

all: src/dataset/dataset.wasm

include/configuration.h: include/configuration.ts
	sed '/export const/ { s/export const /#define /; s/ = / /; s/;//; }; /^\/\// { s/^\/\///; }; /^#/!d' $< > $@

src/dataset/dataset.wasm: $(DATASET_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-Wl,--import-memory \
		-o $@ $(DATASET_C_SOURCES)

	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@

# extract the memory
#  - memory[0] pages: initial=4097 <- env.memory
#                             ^^^^
	wasm-objdump -x $@ | sed -n 's/.*initial=\([0-9]\+\).*/export default \1/p' \
		> src/dataset/dataset.wasm.pages.ts
