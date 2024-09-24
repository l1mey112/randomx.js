H_SOURCES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')

WAT_SOURCES := $(shell find . -type f -name '*.wat' -not -path './node_modules/*')
WAT_WASM_FILES := $(patsubst %.wat,%.wasm,$(WAT_SOURCES))

JIT_STUBS_C_SOURCES := $(shell find src/jit/stubs -type f -name '*.c')
JIT_STUBS_H_SOURCES := $(subst .c,.h,$(JIT_STUBS_C_SOURCES))

H_SOURCES += include/configuration.h
H_SOURCES += $(JIT_STUBS_H_SOURCES)
H_SOURCES += $(WAT_WASM_FILES)

# TODO: this is such a disgusting makefile

PRINTF_C_SOURCES := $(shell find src/printf -type f -name '*.c')
BLAKE2B_C_SOURCES := $(shell find src/blake2b -type f -name '*.c') $(PRINTF_C_SOURCES)
ARGON2FILL_C_SOURCES := $(shell find src/argon2fill -type f -name '*.c') $(PRINTF_C_SOURCES) $(BLAKE2B_C_SOURCES)
JIT_C_SOURCES := $(shell find src/jit -maxdepth 1 -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES)
AES_C_SOURCES := $(shell find src/aes -type f -name '*.c')

DATASET_C_SOURCES := $(sort $(shell find src/dataset -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES))
VM_C_SOURCES := $(sort $(shell find src/vm -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES) $(AES_C_SOURCES))
TESTS_C_SOURCES := $(sort $(shell find tests -maxdepth 1 -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(DATASET_C_SOURCES) $(ARGON2FILL_C_SOURCES) $(AES_C_SOURCES) $(VM_C_SOURCES))

wasm-opt := wasm-opt
DFLAGS :=

# Debian is a great simple daily driver. However, its fucking terrible for development.
# Debian 12 doesn't ship a proper version of Clang or Binaryen.

# To install Clang 20:
# $ apt install clang-20 clang-tools-20 clang-20-doc libclang-common-20-dev libclang-20-dev libclang1-20 clang-format-20 python3-clang-20 clangd-20 clang-tidy-20 lld-20

# To install a better version of Binaryen:
# $ # not possible, which is why I have a gate below:
DEBIAN_LSB := $(shell which lsb_release 2>/dev/null)
ifneq ($(DEBIAN_LSB),)
	DEBIAN_RELEASE := $(shell lsb_release -sr 2> /dev/null)
	ifeq ($(shell expr $(DEBIAN_RELEASE) \<= 12),1)
		wasm-opt := echo
		DFLAGS += --no-wasm-opt
	endif
endif

ifeq ($(PRODUCTION),)
	PRODUCTION := 0
endif

# PRODUCTION flag
$(info PRODUCTION=$(PRODUCTION))

UFLAGS = -Iinclude -Isrc -DPRODUCTION=$(PRODUCTION)

# https://lld.llvm.org/WebAssembly.html
LDFLAGS = -Wl,--no-entry -Wl,-z,stack-size=8192
CFLAGS = --target=wasm32 -nostdlib -fno-builtin $(UFLAGS) \
	-msimd128 -mbulk-memory $(DFLAGS)

# -matomics -Wl,--shared-memory to use shared memory

.PHONY: all clean
all: src/dataset/dataset.wasm src/vm/vm.wasm tests/harness.wasm tests/semifloat/semifloat

clean:
	rm -f **/*.wasm **/*.wasm.pages.ts include/configuration.h src/jit/stubs/*.h **/*.o
	rm -rf dist

include/configuration.h: include/configuration.ts
	sed '/export const/ { s/export const /#define /; s/ = / /; s/;//; }; /^\/\// { s/^\/\///; }; /^#/!d' $< > $@

GIT_HASH := $(shell git log -1 --format=%h)

%.wasm: %.wat
	wat2wasm --enable-all $< -o $@

# FP heap is so fucking large that it only makes sense to compile with TCC
# don't even bother with optimisations on
tests/semifloat/the_randomx_fp_heap.o: tests/semifloat/the_randomx_fp_heap.c tests/semifloat/the_randomx_fp_heap.h
	tcc -c -o $@ tests/semifloat/the_randomx_fp_heap.c
# ensure separate compilation units, NO LTO/INLINING
tests/semifloat/semifloat_stub.o: src/jit/stubs/semifloat.c
	clang -march=native -fno-lto $(UFLAGS) -O3 -c -o $@ $<
tests/semifloat/semifloat: tests/semifloat/semifloat_test.c tests/semifloat/semifloat_stub.o tests/semifloat/the_randomx_fp_heap.o
	clang -march=native -fno-lto -ffp-model=strict $(UFLAGS) -lm -Og -ggdb -o $@ \
		tests/semifloat/semifloat_test.c tests/semifloat/semifloat_stub.o tests/semifloat/the_randomx_fp_heap.o \
		-DGIT_HASH=\"$(GIT_HASH)\"

src/jit/stubs/%.wasm: src/jit/stubs/%.c
	clang -O3 $(CFLAGS) -mrelaxed-simd $(LDFLAGS) -o $@ $<
	$(wasm-opt) -all -O4 $@ -o $@
src/jit/stubs/%.h: src/jit/stubs/%.wasm
	./scripts/stubgen.ts $< > $@

tests/harness.wasm: $(TESTS_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-o $@ $(TESTS_C_SOURCES)

	wasm-strip $@
	$(wasm-opt) -all -O4 -Oz $@ -o $@

src/dataset/dataset.wasm: $(DATASET_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-Wl,--import-memory \
		-o $@ $(DATASET_C_SOURCES)

	scripts/nogrowablepatch.ts $@ '\x03env\x06memory'

	wasm-strip $@
	$(wasm-opt) -all -O4 -Oz $@ -o $@

# extract the memory
#  - memory[0] pages: initial=4097 <- env.memory
#                             ^^^^
	wasm-objdump -x $@ | sed -n 's/.*memory.*initial=\([0-9]\+\).*/export default \1/p' \
		> src/dataset/dataset.wasm.pages.ts

	wasm-objdump -x $@ | sed -n 's/.*memory.*initial=\([0-9]\+\).*/#define DATASET_MEMORY_PAGES \1/p' \
		> src/dataset/dataset.wasm.pages.h

src/vm/vm.wasm: $(VM_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-o $@ $(VM_C_SOURCES)

	wasm-strip $@
	$(wasm-opt) -all -O4 -Oz $@ -o $@
