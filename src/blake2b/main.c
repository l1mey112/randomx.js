#include "wasm.h"

WASM_EXPORT("add")
int add(int a, int b) {
	return a + b;
}

WASM_EXPORT("my_memset")
void my_memset(void *ptr, int value, int num) {
	memset(ptr, value, num);
}

WASM_EXPORT("my_memcpy")
void my_memcpy(void *dest, const void *src, int num) {
	memcpy(dest, src, num);
}
