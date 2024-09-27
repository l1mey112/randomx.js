#include "freestanding.h"

#if INSTRUMENT

#define NANOPRINTF_USE_FIELD_WIDTH_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_PRECISION_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_FLOAT_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_LARGE_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_BINARY_FORMAT_SPECIFIERS 1
#define NANOPRINTF_USE_WRITEBACK_FORMAT_SPECIFIERS 0
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

#endif
