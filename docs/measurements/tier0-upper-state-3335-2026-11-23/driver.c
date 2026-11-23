// The driver (clang -O2): each round calls sum16 (leaving the upper state as Tier 0's code leaves it) and then saxpy over
// N elements, or saxpy alone ("clean"); prints nanoseconds per element, the median of the rounds' best-of-blocks.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
float sum16(const float* p);
void add16(float* o, const float* p);
void saxpy(float* y, const float* x, float a, int n);
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e9 + t.tv_nsec; }
static int compare(const void* a, const void* b) { double x = *(const double*)a, y = *(const double*)b; return (x > y) - (x < y); }
int main(int argc, char** argv)
{
    const int n = argc > 2 ? atoi(argv[2]) : 1024;
    const int dirty = argc > 1 && strcmp(argv[1], "dirty") == 0;
    const int wide = argc > 1 && strcmp(argv[1], "wide") == 0;
    float* x = aligned_alloc(64, n * 4);
    float* y = aligned_alloc(64, n * 4);
    float p[32];
    float o[16];
    for (int i = 0; i < n; i++) { x[i] = (float)(i % 7); y[i] = 0; }
    for (int i = 0; i < 32; i++) p[i] = (float)i;
    enum { ROUNDS = 31, REPS = 2000 };
    double times[ROUNDS];
    volatile float sink = 0;
    for (int r = 0; r < ROUNDS; r++)
    {
        const double t0 = now();
        for (int k = 0; k < REPS; k++)
        {
            if (dirty) sink += sum16(p);
            if (wide) { add16(o, p); sink += o[3]; }
            saxpy(y, x, 0.5f, n);
        }
        times[r] = (now() - t0) / ((double)REPS * n);
    }
    qsort(times, ROUNDS, sizeof(double), compare);
    printf("%s n=%d: %.3f ns/element (median of %d rounds; min %.3f, max %.3f) y[1]=%g\n", dirty ? "dirty" : wide ? "wide" : "clean", n, times[ROUNDS / 2], ROUNDS, times[0], times[ROUNDS - 1], y[1] + sink * 0);
    return 0;
}
