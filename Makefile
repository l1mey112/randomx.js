H_SOURCES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')

JIT_STUBS_C_SOURCES := $(shell find src/jit/stubs -type f -name '*.c')
JIT_STUBS_H_SOURCES := $(subst .c,.h,$(JIT_STUBS_C_SOURCES))

H_SOURCES += include/configuration.h
H_SOURCES += $(JIT_STUBS_H_SOURCES)

PRINTF_C_SOURCES := $(shell find src/printf -type f -name '*.c')
BLAKE2B_C_SOURCES := $(shell find src/blake2b -type f -name '*.c') $(PRINTF_C_SOURCES)
ARGON2FILL_C_SOURCES := $(shell find src/argon2fill -type f -name '*.c') $(PRINTF_C_SOURCES) $(BLAKE2B_C_SOURCES)
JIT_C_SOURCES := $(shell find src/jit -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES)
AES_C_SOURCES := $(shell find src/aes -type f -name '*.c')

DATASET_C_SOURCES := $(sort $(shell find src/dataset -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES))
VM_C_SOURCES := $(sort $(shell find src/vm -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES) $(AES_C_SOURCES))
TESTS_C_SOURCES := $(sort $(shell find src/tests -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(DATASET_C_SOURCES) $(ARGON2FILL_C_SOURCES) $(AES_C_SOURCES))

# https://lld.llvm.org/WebAssembly.html
LDFLAGS = -Wl,--no-entry -Wl,-z,stack-size=8192
CFLAGS = --target=wasm32 -nostdlib -fno-builtin -Iinclude -Isrc \
	-msimd128 -mbulk-memory

# -matomics -Wl,--shared-memory to use shared memory

.PHONY: all clean
all: src/dataset/dataset.wasm src/vm/vm.wasm src/tests/harness.wasm

clean:
	rm -f **/*.wasm **/*.wasm.pages.ts include/configuration.h src/jit/stubs/*.h
	rm -rf dist

include/configuration.h: include/configuration.ts
	sed '/export const/ { s/export const /#define /; s/ = / /; s/;//; }; /^\/\// { s/^\/\///; }; /^#/!d' $< > $@

src/jit/stubs/%.wasm: src/jit/stubs/%.c
	clang -O3 $(CFLAGS) $(LDFLAGS) -o $@ $<
	wasm-opt -all -O4 -Oz $@ -o $@
src/jit/stubs/%.h: src/jit/stubs/%.wasm
	./stubgen.ts $< > $@

src/tests/harness.wasm: $(TESTS_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-o $@ $(TESTS_C_SOURCES)

	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@

src/dataset/dataset.wasm: $(DATASET_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-Wl,--import-memory \
		-o $@ $(DATASET_C_SOURCES)

	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@

# extract the memory
#  - memory[0] pages: initial=4097 <- env.memory
#                             ^^^^
	wasm-objdump -x $@ | sed -n 's/.*memory.*initial=\([0-9]\+\).*/export default \1/p' \
		> src/dataset/dataset.wasm.pages.ts

src/vm/vm.wasm: $(VM_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-o $@ $(VM_C_SOURCES)

	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@
