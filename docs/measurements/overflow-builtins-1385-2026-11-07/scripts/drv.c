// #1385's driver, compiled once by clang -O2: 4,096 elements of a xorshift sequence shifted right by its own value's
// low bits (so that products of every magnitude occur), each kernel called 20,000 times per repetition, the best of 3
// repetitions printed, and a hash of the kernels' results, which every build must print alike.
#include <stdio.h>
#include <time.h>
#define N 4096
long add_long(const long* p, unsigned n);
long mul_long(const long* p, unsigned n);
long add_int(const long* p, unsigned n);
long mul_int(const long* p, unsigned n);
long mul_ulong(const long* p, unsigned n);
static long p[N];
static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec * 1e3 + t.tv_nsec / 1e6;
}
int main(void)
{
    unsigned long x = 88172645463325252ul;
    for (int i = 0; i < N; i++)
    {
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        p[i] = (long)x >> (x % 61);
    }
    static const char* const names[] = { "add_long", "mul_long", "add_int", "mul_int", "mul_ulong" };
    long (*const kernels[])(const long*, unsigned) = { add_long, mul_long, add_int, mul_int, mul_ulong };
    unsigned long hash = 0;
    for (int k = 0; k < 5; k++)
    {
        double best = 1e9;
        for (int r = 0; r < 3; r++)
        {
            double t0 = now();
            for (int i = 0; i < 20000; i++)
            {
                hash = hash * 31 + (unsigned long)kernels[k](p, N);
            }
            double t1 = now();
            if (t1 - t0 < best)
            {
                best = t1 - t0;
            }
        }
        printf("%s %.1f ms  ", names[k], best);
    }
    printf("(%lx)\n", hash);
    return 0;
}
