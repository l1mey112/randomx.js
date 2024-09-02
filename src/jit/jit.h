#include "ssh.h"
#include "configuration.h"
#include <stdint.h>

uint32_t ssh_jit(ss_program_t prog[RANDOMX_CACHE_ACCESSES], uint8_t *cache, uint8_t *buf);
