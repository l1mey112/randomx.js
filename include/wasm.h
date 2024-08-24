#pragma once

#define WASM_IMPORT(module, name) \
	__attribute__((import_module(module), import_name(name)))

#define WASM_EXPORT(name) \
	__attribute__((export_name(name)))

#define memcpy __builtin_memcpy // bulk-memory
#define memset __builtin_memset // bulk-memory

#define NULL ((void*)0)

#define alignas _Alignas

#ifndef WASM_NO_OPT
#define WASM_UNROLL _Pragma("clang loop unroll(full)")
#else
#define WASM_UNROLL
#endif
