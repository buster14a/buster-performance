#include <emmintrin.h>
#include <stddef.h>
#include <stdint.h>
void v_add_i32(int32_t *d, const int32_t *a, const int32_t *b, size_t n)
{
    size_t i = 0;
    for (; i + 4 <= n; i += 4)
    {
        _mm_storeu_si128((__m128i *)(d + i), _mm_add_epi32(_mm_loadu_si128((const __m128i *)(a + i)), _mm_loadu_si128((const __m128i *)(b + i))));
    }
    for (; i < n; i += 1)
    {
        d[i] = (int32_t)((uint32_t)a[i] + (uint32_t)b[i]);
    }
}
float v_dot_f32(const float *a, const float *b, size_t n)
{
    __m128 acc = _mm_setzero_ps();
    size_t i = 0;
    for (; i + 4 <= n; i += 4)
    {
        acc = _mm_add_ps(acc, _mm_mul_ps(_mm_loadu_ps(a + i), _mm_loadu_ps(b + i)));
    }
    float t[4];
    _mm_storeu_ps(t, acc);
    return t[0] + t[1] + t[2] + t[3];
}
