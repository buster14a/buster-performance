// #1549's kernels: each called n times by a loop clang -O2 compiles, the best of three passes, in ns per call.
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
struct Big { long a[40]; int flags; };
long k_return(int);
long k_cleanup(int);
long k_wrapped(int);
__attribute__((noinline)) struct Big k_make(int i) { struct Big b = { .a = { i, i + 1 }, .flags = i }; return b; }
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC_RAW, &t); return t.tv_sec * 1e9 + t.tv_nsec; }
int main(int argc, char** argv)
{
    const int n = argc > 1 ? atoi(argv[1]) : 2000000;
    long s = 0;
    double best[3] = { 1e30, 1e30, 1e30 };
    for (int pass = 0; pass < 3; pass++)
    {
        double t;
        t = now(); for (int i = 0; i < n; i++) s += k_return(i); t = now() - t; best[0] = t < best[0] ? t : best[0];
        t = now(); for (int i = 0; i < n; i++) s += k_cleanup(i); t = now() - t; best[1] = t < best[1] ? t : best[1];
        t = now(); for (int i = 0; i < n; i++) s += k_wrapped(i); t = now() - t; best[2] = t < best[2] ? t : best[2];
    }
    const char* names[3] = { "return", "cleanup", "wrapped" };
    for (int k = 0; k < 3; k++) printf("%s %.3f\n", names[k], best[k] / n);
    printf("check %ld\n", s);
    return 0;
}
