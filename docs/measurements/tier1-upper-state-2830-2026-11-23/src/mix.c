// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// mix.c REPS: every function compiled by the compiler under test (--tier1 -march=znver5). Each round, dot16 sums
// 64 products by 512-bit intrinsics and returns; then saxpy runs a scalar float loop over 2,048 floats, and
// scale_sum a scalar double reduction. Without a vzeroupper on dot16's exit, and with legacy SSE moves in the
// scalar loops, the scalar loops run in the dirty upper state (buster#2830). Prints a checksum.
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define MIX_N 2048

__attribute__((noinline)) float dot16(const float* a, const float* b)
{
    __m512 s = _mm512_mul_ps(_mm512_loadu_ps(a), _mm512_loadu_ps(b));
    s = _mm512_fmadd_ps(_mm512_loadu_ps(a + 16), _mm512_loadu_ps(b + 16), s);
    s = _mm512_fmadd_ps(_mm512_loadu_ps(a + 32), _mm512_loadu_ps(b + 32), s);
    s = _mm512_fmadd_ps(_mm512_loadu_ps(a + 48), _mm512_loadu_ps(b + 48), s);
    return _mm512_reduce_add_ps(s);
}

__attribute__((noinline)) void saxpy(float* y, const float* x, float k, int n)
{
    for (int i = 0; i < n; i += 1)
    {
        y[i] = k * x[i] + y[i];
    }
}

__attribute__((noinline)) double scale_sum(const float* y, int n)
{
    double s = 0.0;
    for (int i = 0; i < n; i += 1)
    {
        s += (double)y[i] * 0.5;
    }
    return s;
}

int main(int argc, char** argv)
{
    const long reps = argc > 1 ? atol(argv[1]) : 100000;
    float* y = aligned_alloc(64, MIX_N * sizeof(float));
    float* x = aligned_alloc(64, MIX_N * sizeof(float));
    int result = 1;
    if (y != NULL && x != NULL)
    {
        for (int i = 0; i < MIX_N; i += 1)
        {
            y[i] = (float)(i & 7);
            x[i] = (float)(i & 3) * 0.25f;
        }
        double total = 0.0;
        for (long r = 0; r < reps; r += 1)
        {
            const float d = dot16(x, y + (r & 63));
            saxpy(y, x, d * 0x1p-30f, MIX_N);
            total += scale_sum(y, MIX_N);
        }
        printf("mix: %ld rounds, checksum %.6e\n", reps, total);
        result = 0;
    }
    free(y);
    free(x);
    return result;
}
