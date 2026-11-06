// The clear's threshold: `long a[N/8] = { 0 }` for N bytes from 16 to 256, n calls each, the best of five passes, in ns.
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
long s16(int); long s32(int); long s64(int); long s96(int); long s128(int); long s136(int); long s192(int); long s256(int);
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC_RAW, &t); return t.tv_sec * 1e9 + t.tv_nsec; }
typedef long (*F)(int);
int main(int argc, char** argv)
{
    const int n = argc > 1 ? atoi(argv[1]) : 4000000;
    F f[8] = { s16, s32, s64, s96, s128, s136, s192, s256 };
    const char* names[8] = { "16", "32", "64", "96", "128", "136", "192", "256" };
    double best[8];
    for (int k = 0; k < 8; k++) best[k] = 1e30;
    long s = 0;
    for (int pass = 0; pass < 5; pass++)
        for (int k = 0; k < 8; k++) { double t = now(); for (int i = 0; i < n; i++) s += f[k](i); t = now() - t; best[k] = t < best[k] ? t : best[k]; }
    for (int k = 0; k < 8; k++) printf("size%s %.3f\n", names[k], best[k] / n);
    printf("check %ld\n", s);
    return 0;
}
