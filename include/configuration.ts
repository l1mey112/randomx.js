//#pragma once

// RandomX configuration
export const RANDOMX_ARGON_MEMORY = 262144          // Number of 1 KiB Argon2 blocks in the Cache
export const RANDOMX_ARGON_ITERATIONS = 3           // Number of Argon2d iterations for Cache initialization
export const RANDOMX_ARGON_LANES = 1                // Number of parallel lanes for Cache initialization
export const RANDOMX_ARGON_SALT = "RandomX\x03"     // Argon2 salt
export const RANDOMX_CACHE_ACCESSES = 8             // Number of random Cache accesses per Dataset item
export const RANDOMX_SUPERSCALAR_LATENCY = 170      // Target latency for SuperscalarHash in CPU cycles
export const RANDOMX_DATASET_BASE_SIZE = 2147483648 // Dataset base size in bytes
export const RANDOMX_DATASET_EXTRA_SIZE = 33554368  // Dataset extra size in bytes
export const RANDOMX_PROGRAM_SIZE = 256             // Number of instructions in a RandomX program
export const RANDOMX_PROGRAM_ITERATIONS = 2048      // Number of iterations per program
export const RANDOMX_PROGRAM_COUNT = 8              // Number of programs per hash
export const RANDOMX_JUMP_BITS = 8                  // Jump condition mask size in bits
export const RANDOMX_JUMP_OFFSET = 8                // Jump condition mask offset in bits
export const RANDOMX_SCRATCHPAD_L3 = 2097152        // Scratchpad L3 size in bytes
export const RANDOMX_SCRATCHPAD_L2 = 262144         // Scratchpad L2 size in bytes
export const RANDOMX_SCRATCHPAD_L1 = 16384          // Scratchpad L1 size in bytes

export type Feature =
	| 0 // JS only (asm.js where possible)
	| 1 // JS + WASM + SIMD + BULK MEMORY
	| 2 // JS + WASM + SIMD + BULK MEMORY + WORKING FMA

export const FEATURE_JS = 0
export const FEATURE_SIMD = 1
export const FEATURE_FMA = 2
