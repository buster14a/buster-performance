// #1376's kernels: each called n times by a loop clang -O2 compiles, the best of three passes, in ns per call.
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
struct Big { long a[40]; int flags; };
int k_array(int);
long k_partial(int);
long k_struct(int);
long k_literal(int);
long k_copy(const struct Big*, int);
long k_return(int);
__attribute__((noinline)) struct Big k_make(int i) { struct Big b = { .a = { i, i + 1 }, .flags = i }; return b; }
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC_RAW, &t); return t.tv_sec * 1e9 + t.tv_nsec; }
int main(int argc, char** argv)
{
    const int n = argc > 1 ? atoi(argv[1]) : 2000000;
    static struct Big src = { .a = { 1, 2, 3 }, .flags = 4 };
    long s = 0;
    double best[6] = { 1e30, 1e30, 1e30, 1e30, 1e30, 1e30 };
    for (int pass = 0; pass < 3; pass++)
    {
        double t;
        t = now(); for (int i = 0; i < n; i++) s += k_array(i); t = now() - t; best[0] = t < best[0] ? t : best[0];
        t = now(); for (int i = 0; i < n; i++) s += k_partial(i); t = now() - t; best[1] = t < best[1] ? t : best[1];
        t = now(); for (int i = 0; i < n; i++) s += k_struct(i); t = now() - t; best[2] = t < best[2] ? t : best[2];
        t = now(); for (int i = 0; i < n; i++) s += k_literal(i); t = now() - t; best[3] = t < best[3] ? t : best[3];
        t = now(); for (int i = 0; i < n; i++) s += k_copy(&src, i); t = now() - t; best[4] = t < best[4] ? t : best[4];
        t = now(); for (int i = 0; i < n; i++) s += k_return(i); t = now() - t; best[5] = t < best[5] ? t : best[5];
    }
    const char* names[6] = { "array", "partial", "struct", "literal", "copy", "return" };
    for (int k = 0; k < 6; k++) printf("%s %.3f\n", names[k], best[k] / n);
    printf("check %ld\n", s);
    return 0;
}
