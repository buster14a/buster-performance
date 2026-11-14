#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>
/* sse_probe.c's two loops with AVX2's 32-byte vectors; the same names, so sse_bench.c times either. */
void v_add_i32(int32_t *d, const int32_t *a, const int32_t *b, size_t n)
{
    size_t i = 0;
    for (; i + 8 <= n; i += 8)
    {
        _mm256_storeu_si256((__m256i *)(d + i), _mm256_add_epi32(_mm256_loadu_si256((const __m256i *)(a + i)), _mm256_loadu_si256((const __m256i *)(b + i))));
    }
    for (; i < n; i += 1)
    {
        d[i] = (int32_t)((uint32_t)a[i] + (uint32_t)b[i]);
    }
}
float v_dot_f32(const float *a, const float *b, size_t n)
{
    __m256 acc = _mm256_setzero_ps();
    size_t i = 0;
    for (; i + 8 <= n; i += 8)
    {
        acc = _mm256_add_ps(acc, _mm256_mul_ps(_mm256_loadu_ps(a + i), _mm256_loadu_ps(b + i)));
    }
    float t[8];
    _mm256_storeu_ps(t, acc);
    return t[0] + t[1] + t[2] + t[3] + t[4] + t[5] + t[6] + t[7];
}
