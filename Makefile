H_SOURCES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')

JIT_STUBS_C_SOURCES := $(shell find src/jit/stubs -type f -name '*.c')
JIT_STUBS_H_SOURCES := $(subst .c,.h,$(JIT_STUBS_C_SOURCES))

H_SOURCES += include/configuration.h
H_SOURCES += $(JIT_STUBS_H_SOURCES)

PRINTF_C_SOURCES := $(shell find src/printf -type f -name '*.c')
BLAKE2B_C_SOURCES := $(shell find src/blake2b -type f -name '*.c') $(PRINTF_C_SOURCES)
ARGON2FILL_C_SOURCES := $(shell find src/argon2fill -type f -name '*.c') $(PRINTF_C_SOURCES) $(BLAKE2B_C_SOURCES)
JIT_C_SOURCES := $(shell find src/jit -maxdepth 1 -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES)
AES_C_SOURCES := $(shell find src/aes -type f -name '*.c')

DATASET_C_SOURCES := $(sort $(shell find src/dataset -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES))
VM_C_SOURCES := $(sort $(shell find src/vm -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES) $(AES_C_SOURCES))
TESTS_C_SOURCES := $(sort $(shell find tests -maxdepth 1 -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(DATASET_C_SOURCES) $(ARGON2FILL_C_SOURCES) $(AES_C_SOURCES))

UFLAGS = -Iinclude -Isrc

# https://lld.llvm.org/WebAssembly.html
LDFLAGS = -Wl,--no-entry -Wl,-z,stack-size=8192
CFLAGS = --target=wasm32 -nostdlib -fno-builtin $(UFLAGS) \
	-msimd128 -mbulk-memory

# -matomics -Wl,--shared-memory to use shared memory

.PHONY: all clean
all: src/dataset/dataset.wasm src/vm/vm.wasm tests/harness.wasm tests/semifloat/semifloat

clean:
	rm -f **/*.wasm **/*.wasm.pages.ts include/configuration.h src/jit/stubs/*.h
	rm -rf dist

include/configuration.h: include/configuration.ts
	sed '/export const/ { s/export const /#define /; s/ = / /; s/;//; }; /^\/\// { s/^\/\///; }; /^#/!d' $< > $@

# FP heap is so fucking large that it only makes sense to compile with TCC
# don't even bother with optimisations on
tests/semifloat/the_randomx_fp_heap.o: tests/semifloat/the_randomx_fp_heap.c tests/semifloat/the_randomx_fp_heap.h
	tcc -c -o $@ tests/semifloat/the_randomx_fp_heap.c
tests/semifloat/semifloat: tests/semifloat/semifloat_test.c src/jit/stubs/semifloat.c tests/semifloat/the_randomx_fp_heap.o
	clang -march=native -ffp-model=strict $(UFLAGS) -lm -O3 -o $@ \
		tests/semifloat/semifloat_test.c src/jit/stubs/semifloat.c tests/semifloat/the_randomx_fp_heap.o

src/jit/stubs/%.wasm: src/jit/stubs/%.c
	clang -O3 $(CFLAGS) -mrelaxed-simd $(LDFLAGS) -o $@ $<
	wasm-opt -all -O4 -Oz $@ -o $@
src/jit/stubs/%.h: src/jit/stubs/%.wasm
	./stubgen.ts $< > $@

tests/harness.wasm: $(TESTS_C_SOURCES) $(H_SOURCES)
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
