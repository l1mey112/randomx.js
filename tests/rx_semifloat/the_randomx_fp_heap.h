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

typedef struct TESTV TESTV;
typedef struct TESTVU TESTVU;

struct TESTV {
	double x0;
	double x1;
	double y0;
	double y1;
	double z0;
	double z1;
};

struct TESTVU {
	double x0;
	double x1;
	double z0;
	double z1;
};

extern TESTV HEAP_FADD_0[8666];
extern TESTV HEAP_FADD_1[8900];
extern TESTV HEAP_FADD_2[8369];
extern TESTV HEAP_FADD_3[8198];
extern TESTV HEAP_FSUB_0[8279];
extern TESTV HEAP_FSUB_1[8461];
extern TESTV HEAP_FSUB_2[7872];
extern TESTV HEAP_FSUB_3[7697];
extern TESTV HEAP_FMUL_0[15160];
extern TESTV HEAP_FMUL_1[15441];
extern TESTV HEAP_FMUL_2[14419];
extern TESTV HEAP_FMUL_3[14078];
extern TESTV HEAP_FMUL_FMA_1[15441];
extern TESTV HEAP_FMUL_FMA_2[14419];
extern TESTV HEAP_FMUL_FMA_3[14078];
extern TESTV HEAP_FDIV_0[2450];
extern TESTV HEAP_FDIV_1[2514];
extern TESTV HEAP_FDIV_2[2424];
extern TESTV HEAP_FDIV_3[2392];
extern TESTV HEAP_FDIV_FMA_1[2514];
extern TESTV HEAP_FDIV_FMA_2[2424];
extern TESTV HEAP_FDIV_FMA_3[2392];
extern TESTVU HEAP_FSQRT_0[2011];
extern TESTVU HEAP_FSQRT_1[2076];
extern TESTVU HEAP_FSQRT_2[1963];
extern TESTVU HEAP_FSQRT_3[1932];
extern TESTVU HEAP_FSQRT_FMA_1[2076];
extern TESTVU HEAP_FSQRT_FMA_2[1963];
extern TESTVU HEAP_FSQRT_FMA_3[1932];
