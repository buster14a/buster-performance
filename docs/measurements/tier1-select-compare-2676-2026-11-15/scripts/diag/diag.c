// #2676's condsum loop variants (loops.s), each over #1382's 2^20 xorshift bytes 80 times, as bench.c's condsum.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
long v_head_10(const int*, int); long v_head_20(const int*, int);
long v_nomov_10(const int*, int); long v_nomov_20(const int*, int);
long v_main_10(const int*, int); long v_main_20(const int*, int);
static uint64_t state = 0x9e3779b97f4a7c15u;
static inline uint64_t next(void) { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state; }
int main(int argc, char** argv)
{
    const char* v = argc > 1 ? argv[1] : "";
    long (*f)(const int*, int) = strcmp(v, "head_10") == 0 ? v_head_10 : strcmp(v, "head_20") == 0 ? v_head_20 : strcmp(v, "nomov_10") == 0 ? v_nomov_10 :
                                 strcmp(v, "nomov_20") == 0 ? v_nomov_20 : strcmp(v, "main_10") == 0 ? v_main_10 : strcmp(v, "main_20") == 0 ? v_main_20 : 0;
    if (f == 0) { fprintf(stderr, "diag: unknown variant '%s'\n", v); return 2; }
    enum { ELEMENTS = 1 << 20, PASSES = 80 };
    int* a = malloc(sizeof(int) * ELEMENTS);
    for (int i = 0; i < ELEMENTS; i += 1) a[i] = (int)(next() >> 56);
    long acc = 0;
    for (int pass = 0; pass < PASSES; pass += 1) acc += f(a, ELEMENTS);
    printf("%ld\n", acc);
    return 0;
}
