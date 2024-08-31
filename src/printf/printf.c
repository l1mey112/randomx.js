#include "wasm.h"

#define NANOPRINTF_IMPLEMENTATION
#include "nanoprintf.h"

WASM_IMPORT("ch")
void env_npf_putc(int c, void *ctx);

__attribute__((minsize)) int printf(const char *restrict format, ...) {
	va_list args;
	va_start(args, format);
	int ret = npf_vpprintf(env_npf_putc, NULL, format, args);
	va_end(args);
	return ret;
}

__attribute__((minsize)) int snprintf(char *restrict str, unsigned long size, const char *restrict format, ...) {
	va_list args;
	va_start(args, format);
	int ret = npf_vsnprintf(str, size, format, args);
	va_end(args);
	return ret;
}
