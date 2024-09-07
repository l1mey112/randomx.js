#include <stdint.h>

#pragma once

// https://www.ccsl.carleton.ca/%7Ejamuir/rdtscpm1.pdf
// https://en.wikipedia.org/wiki/Time_Stamp_Counter
// https://github.com/xuwd1/rdtsc-notes

// TODO: implement a better and less stupid rdtsc implementation
// https://codereview.stackexchange.com/questions/116154/precise-timings-with-low-jitter-via-rdtsc-for-x86-and-x64
// https://stackoverflow.com/questions/12631856/difference-between-rdtscp-rdtsc-memory-and-cpuid-rdtsc

static inline uint64_t rdtsc() {
	uint32_t lo, hi;
	asm volatile(
		"xorl %%eax, %%eax\n\t"
		"cpuid\n\t"
		"rdtsc\n\t"
		: "=a"(lo), "=d"(hi)
		:
		: "%ebx", "%ecx");
	return (uint64_t)hi << 32 | lo;
}

static inline uint32_t rdtsc_overhead() {
	uint64_t start, end;
	start = rdtsc();
	end = rdtsc();
	return end - start;
}
