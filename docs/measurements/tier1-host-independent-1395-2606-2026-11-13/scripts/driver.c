// #1395's chain benchmark driver (clang -O2): each kernel over 4,096 elements, 20,000 times per run, RUNS runs; prints
// each kernel's median, minimum and maximum run in ms, and a checksum of the results.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

long chain5(const long* p, long n);
long chain9(const long* p, long n);
long chain4(const long* p, long n);
long chain33(const long* p, long n);

#define ELEMENTS 4096
#define REPEATS 20000
#define MAX_RUNS 64

static double now_ms(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (double)t.tv_sec * 1e3 + (double)t.tv_nsec * 1e-6;
}

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    const int runs = argc > 1 ? atoi(argv[1]) : 11;
    static long p[ELEMENTS];
    for (int i = 0; i < ELEMENTS; i += 1)
    {
        p[i] = (long)((uint64_t)i * 0x9e3779b97f4a7c15u >> 40);
    }
    long (*const kernels[])(const long*, long) = { chain5, chain9, chain4, chain33 };
    const char* const names[] = { "s*5+p[i]", "s*9+p[i]", "s*4+p[i]", "(s*3)*3+p[i]" };
    unsigned long checksum = 0;
    for (int k = 0; k < 4; k += 1)
    {
        double times[MAX_RUNS];
        // One unmeasured warm-up run.
        for (int r = -1; r < runs && r < MAX_RUNS; r += 1)
        {
            const double start = now_ms();
            for (int repeat = 0; repeat < REPEATS; repeat += 1)
            {
                checksum += (unsigned long)kernels[k](p, ELEMENTS);
                __asm__ volatile("" : : : "memory");
            }
            const double end = now_ms();
            if (r >= 0)
            {
                times[r] = end - start;
            }
        }
        qsort(times, (size_t)runs, sizeof(double), compare);
        printf("%-14s median %.1f min %.1f max %.1f ms\n", names[k], times[runs / 2], times[0], times[runs - 1]);
    }
    printf("checksum %lx\n", checksum);
    return 0;
}
