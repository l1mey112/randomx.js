#pragma once

#define WASM_IMPORT(module, name) \
	__attribute__((import_module(module), import_name(name)))

#define WASM_EXPORT(name) \
	__attribute__((export_name(name)))

#define memcpy __builtin_memcpy // bulk-memory
#define memset __builtin_memset // bulk-memory
