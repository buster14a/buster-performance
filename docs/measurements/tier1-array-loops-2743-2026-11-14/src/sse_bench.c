#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
void v_add_i32(int32_t *d, const int32_t *a, const int32_t *b, size_t n);
float v_dot_f32(const float *a, const float *b, size_t n);
static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (double)t.tv_sec + (double)t.tv_nsec * 1e-9;
}
int main(void)
{
    enum { N = 2048 };
    int32_t *a = aligned_alloc(4096, 8192), *b = aligned_alloc(4096, 8192), *d = aligned_alloc(4096, 8192);
    float *fa = aligned_alloc(4096, 8192), *fb = aligned_alloc(4096, 8192);
    for (int i = 0; i < N; i += 1) { a[i] = i * 3; b[i] = i ^ 5; fa[i] = (float)i; fb[i] = 1.0f; }
    double best_add = 1e30, best_dot = 1e30;
    volatile float sink = 0;
    for (int s = 0; s < 7; s += 1)
    {
        double t0 = now();
        for (int r = 0; r < 20000; r += 1) { v_add_i32(d, a, b, N); }
        double t1 = now();
        for (int r = 0; r < 20000; r += 1) { sink = v_dot_f32(fa, fb, N); }
        double t2 = now();
        if (t1 - t0 < best_add) best_add = t1 - t0;
        if (t2 - t1 < best_dot) best_dot = t2 - t1;
    }
    unsigned h = 0;
    for (int i = 0; i < N; i += 1) { h = h * 31 + (unsigned)d[i]; }
    printf("add_i32 %.4f ns/element, dot_f32 %.4f ns/element, digest %08x %g\n", best_add * 1e9 / (20000.0 * N), best_dot * 1e9 / (20000.0 * N), h, (double)sink);
    return 0;
}
