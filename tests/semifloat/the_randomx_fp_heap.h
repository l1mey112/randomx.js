#pragma once

#define FADD_0 0
#define FADD_1 1
#define FADD_2 2
#define FADD_3 3
#define FSUB_0 4
#define FSUB_1 5
#define FSUB_2 6
#define FSUB_3 7
#define FMUL_0 8
#define FMUL_1 9
#define FMUL_2 10
#define FMUL_3 11
#define FMUL_FMA_1 12
#define FMUL_FMA_2 13
#define FMUL_FMA_3 14
#define FDIV_0 15
#define FDIV_1 16
#define FDIV_2 17
#define FDIV_3 18
#define FDIV_FMA_1 19
#define FDIV_FMA_2 20
#define FDIV_FMA_3 21
#define FSQRT_0 22
#define FSQRT_1 23
#define FSQRT_2 24
#define FSQRT_3 25
#define FSQRT_FMA_1 26
#define FSQRT_FMA_2 27
#define FSQRT_FMA_3 28

#define FCOUNT 29

void TESTV(int op, double x0, double x1, double y0, double y1, double z0, double z1);
void TESTVU(int op, double x0, double x1, double z0, double z1);
void SAMPLE(void);
