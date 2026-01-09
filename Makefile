H_SOURCES := $(shell find . -type f -name '*.h' -not -path './node_modules/*')

WAT_SOURCES := $(shell find src -type f -name '*.wat' -not -path './node_modules/*')
WAT_WASM_FILES := $(patsubst %.wat,%.wasm,$(WAT_SOURCES))

JIT_STUBS_C_SOURCES := $(shell find src/jit/stubs -type f -name '*.c')
JIT_STUBS_H_SOURCES := $(subst .c,.h,$(JIT_STUBS_C_SOURCES))

H_SOURCES += $(JIT_STUBS_H_SOURCES)

PRINTF_C_SOURCES := $(shell find src/printf -type f -name '*.c')
BLAKE2B_C_SOURCES := $(shell find src/blake2b -type f -name '*.c') $(PRINTF_C_SOURCES)
ARGON2FILL_C_SOURCES := $(shell find src/argon2fill -type f -name '*.c') $(PRINTF_C_SOURCES) $(BLAKE2B_C_SOURCES)
JIT_C_SOURCES := $(shell find src/jit -maxdepth 1 -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES)
AES_C_SOURCES := $(shell find src/aes -type f -name '*.c')

# RandomX and RandomWOW use differing AES implementations
AES_RX_C_SOURCES := $(filter-out src/aes/aes4r_wow.c, $(AES_C_SOURCES))
AES_WOW_C_SOURCES := $(filter-out src/aes/aes4r.c, $(AES_C_SOURCES))

_VM_C_SOURCES := $(shell find src/vm -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES)
_VM_SINGLE_C := $(shell find src/vm_single -type f -name '*.c')

VM_RX_C_SOURCES := $(filter-out src/vm/vm_single.c, $(_VM_C_SOURCES)) $(AES_RX_C_SOURCES)
VM_WOW_C_SOURCES := $(filter-out src/vm/vm_single.c, $(_VM_C_SOURCES)) $(AES_WOW_C_SOURCES)

# main entrypoints
DATASET_C_SOURCES := $(sort $(shell find src/dataset -type f -name '*.c') $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(ARGON2FILL_C_SOURCES))

# single hash entrypoint, no mining
VM_SINGLE_RX_C_SOURCES := $(sort $(VM_RX_C_SOURCES) $(_VM_SINGLE_C))
VM_SINGLE_WOW_C_SOURCES := $(sort $(VM_WOW_C_SOURCES) $(_VM_SINGLE_C))

VM_MINER_RX_C_SOURCES := $(sort $(VM_RX_C_SOURCES) $(shell find src/vm_miner -type f -name '*.c'))

# tests
TESTS_C_SOURCES := $(sort tests/rx_harness.c $(BLAKE2B_C_SOURCES) $(PRINTF_C_SOURCES) $(JIT_C_SOURCES) $(DATASET_C_SOURCES) $(ARGON2FILL_C_SOURCES) $(AES_RX_C_SOURCES) $(VM_RX_C_SOURCES))

ifeq ($(INSTRUMENT),)
	INSTRUMENT := 0
endif

# INSTRUMENT flag
$(info INSTRUMENT=$(INSTRUMENT))

# https://lld.llvm.org/WebAssembly.html
# -matomics -Wl,--shared-memory to use shared memory
IFLAGS = -Iinclude -Isrc -DINSTRUMENT=$(INSTRUMENT)
LDFLAGS = -Wl,--no-entry -Wl,-z,stack-size=8192
CFLAGS = --target=wasm32 -nostdlib -fno-builtin $(IFLAGS) \
	-msimd128 -mbulk-memory

RXFLAGS = -DWASM_VM_PAGES=$(shell scripts/memorypages.ts)

# main entrypoints
all: pkg-randomx.js/dataset.wasm pkg-randomx.js-shared/dataset.wasm pkg-randomwow.js/dataset.wasm pkg-randomwow.js-shared/dataset.wasm \
	pkg-randomx.js/vm.wasm pkg-randomx.js-shared/vm.wasm pkg-randomwow.js/vm.wasm pkg-randomwow.js-shared/vm.wasm $(WAT_WASM_FILES) \
	tests/rx_harness.wasm tests/semifloat/semifloat

.PHONY: clean
clean:
	git clean -Xdf

%.wasm: %.wat
	wat2wasm --enable-all $< -o $@

src/jit/stubs/%.wasm: src/jit/stubs/%.c
	clang -O3 $(CFLAGS) -mrelaxed-simd $(LDFLAGS) -o $@ $<
	wasm-opt -all -O4 $@ -o $@
src/jit/stubs/%.h: src/jit/stubs/%.wasm
	./scripts/stubgen.ts $< > $@

# FP heap is so fucking large that it only makes sense to compile with TCC
# don't even bother with optimisations on
tests/semifloat/the_randomx_fp_heap.o: tests/semifloat/the_randomx_fp_heap.c tests/semifloat/the_randomx_fp_heap.h
	tcc -c -o $@ tests/semifloat/the_randomx_fp_heap.c
# ensure separate compilation units, NO LTO/INLINING
tests/semifloat/semifloat_stub.o: src/jit/stubs/semifloat.c
	clang -march=native -fno-lto $(IFLAGS) -O3 -c -o $@ $<
tests/semifloat/semifloat: tests/semifloat/semifloat_test.c tests/semifloat/semifloat_stub.o tests/semifloat/the_randomx_fp_heap.o
	clang -march=native -fno-lto -ffp-model=strict $(IFLAGS) -lm -Og -ggdb -o $@ \
		tests/semifloat/semifloat_test.c tests/semifloat/semifloat_stub.o tests/semifloat/the_randomx_fp_heap.o

tests/rx_harness.wasm: tests/rx_harness.c $(TESTS_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-o $@ $(TESTS_C_SOURCES) \
		$(shell scripts/deflist.ts pkg-randomx.js/configuration.toml)

pkg-randomx.js/dataset.wasm: $(DATASET_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-Wl,--import-memory \
		-o $@ $(DATASET_C_SOURCES) \
		$(shell scripts/deflist.ts pkg-randomx.js/configuration.toml)

	scripts/nogrowablepatch.ts $@ '\x03env\x06memory'

ifeq ($(INSTRUMENT),0)
	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@
endif

pkg-randomx.js-shared/dataset.wasm: pkg-randomx.js/dataset.wasm
	cp $< $@
	scripts/sharedpatch.ts $@ '\x03env\x06memory'

pkg-randomwow.js/dataset.wasm: $(DATASET_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-Wl,--import-memory \
		-o $@ $(DATASET_C_SOURCES) \
		$(shell scripts/deflist.ts pkg-randomwow.js/configuration.toml)

	scripts/nogrowablepatch.ts $@ '\x03env\x06memory'

ifeq ($(INSTRUMENT),0)
	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@
endif

pkg-randomwow.js-shared/dataset.wasm: pkg-randomwow.js/dataset.wasm
	cp $< $@
	scripts/sharedpatch.ts $@ '\x03env\x06memory'

pkg-randomx.js/vm.wasm: $(VM_SINGLE_RX_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-Wl,--import-memory \
		-o $@ $(VM_SINGLE_RX_C_SOURCES) \
		$(shell scripts/deflist.ts pkg-randomx.js/configuration.toml)

	scripts/nogrowablepatch.ts $@ '\x03env\x06memory'

ifeq ($(INSTRUMENT),0)
	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@
endif

pkg-randomx.js-shared/vm.wasm: pkg-randomx.js/vm.wasm
	cp $< $@

pkg-randomwow.js/vm.wasm: $(VM_SINGLE_WOW_C_SOURCES) $(H_SOURCES)
	clang -O3 $(CFLAGS) $(LDFLAGS) \
		-Wl,--import-memory \
		-o $@ $(VM_SINGLE_WOW_C_SOURCES) \
		$(shell scripts/deflist.ts pkg-randomwow.js/configuration.toml)

	scripts/nogrowablepatch.ts $@ '\x03env\x06memory'

ifeq ($(INSTRUMENT),0)
	wasm-strip $@
	wasm-opt -all -O4 -Oz $@ -o $@
endif

pkg-randomwow.js-shared/vm.wasm: pkg-randomwow.js/vm.wasm
	cp $< $@
