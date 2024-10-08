#pragma once

#include <stdbool.h>

#ifndef INFINITY
#define INFINITY (__builtin_inff())
#endif

#ifdef __wasm__
#define WASM_IMPORT(name) \
	__attribute__((import_module("e"), import_name(name)))

#define WASM_EXPORT(name) \
	__attribute__((export_name(name)))
#else
#define WASM_IMPORT(name)
#define WASM_EXPORT(name)
#endif

#define memcpy __builtin_memcpy        // bulk-memory
#define memset __builtin_memset        // bulk-memory
#define memmove __builtin_memmove      // bulk-memory
#define rotr64 __builtin_rotateright64 // i64.rotr

#define NULL ((void *)0)

#define alignas _Alignas

#define assume(cond)                 \
	do {                             \
		if (!(cond))                 \
			__builtin_unreachable(); \
	} while (0)

#if INSTRUMENT
#define assert(cond)          \
	do {                      \
		if (!(cond))          \
			__builtin_trap(); \
	} while (0)
#else
#define assert(cond) ((void)(cond))
#endif

#define unreachable() __builtin_unreachable()
#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)

#ifndef WASM_NO_OPT
#define WASM_UNROLL _Pragma("clang loop unroll(full)")
#else
#define WASM_UNROLL
#endif

#define STRLEN_CONST(v) (sizeof(v "") - 1)

#if INSTRUMENT
int printf(const char *restrict format, ...) __attribute__((format(printf, 1, 2)));
int snprintf(char *restrict str, unsigned long size, const char *restrict format, ...) __attribute__((format(printf, 3, 4)));
#else
#define printf(...)
#define snprintf(...)
#endif

#if INSTRUMENT == 2
WASM_IMPORT("b")
void timeit(const char *name, bool finish);
#define TIMEIT(name) timeit(name, false)
#define TIMEIT_END(name) timeit(name, true)
#else
#define TIMEIT(name)
#define TIMEIT_END(name)
#endif
