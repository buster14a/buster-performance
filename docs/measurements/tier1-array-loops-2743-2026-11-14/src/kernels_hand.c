/* The same kernels as a loop vectorizer would hand them to the back end: one AVX-512 loop over whole vectors,
   the last partial vector under a mask, a run-time overlap test before a loop that stores. No unrolling.
   Twelve kernels are written so; the other thirteen are kernels.c's, unchanged. */
#include <immintrin.h>

#define k_sum_i32 scalar_k_sum_i32
#define k_sum_u8 scalar_k_sum_u8
#define k_dot_i16 scalar_k_dot_i16
#define k_max_i32 scalar_k_max_i32
#define k_count_eq_u8 scalar_k_count_eq_u8
#define k_cond_sum_i32 scalar_k_cond_sum_i32
#define k_add_i32 scalar_k_add_i32
#define k_saxpy_f32 scalar_k_saxpy_f32
#define k_scale_u8 scalar_k_scale_u8
#define k_clamp_i32 scalar_k_clamp_i32
#define k_i32_to_f32 scalar_k_i32_to_f32
#define k_fill_u32 scalar_k_fill_u32
#include "kernels.c"
#undef k_sum_i32
#undef k_sum_u8
#undef k_dot_i16
#undef k_max_i32
#undef k_count_eq_u8
#undef k_cond_sum_i32
#undef k_add_i32
#undef k_saxpy_f32
#undef k_scale_u8
#undef k_clamp_i32
#undef k_i32_to_f32
#undef k_fill_u32

static inline int ranges_overlap(const void *a, size_t a_bytes, const void *b, size_t b_bytes)
{
    uintptr_t a0 = (uintptr_t)a;
    uintptr_t b0 = (uintptr_t)b;
    return a0 < b0 + b_bytes && b0 < a0 + a_bytes;
}

int64_t k_sum_i32(const int32_t *a, size_t n)
{
    __m512i acc = _mm512_setzero_si512();
    size_t i = 0;
    for (; i + 8 <= n; i += 8)
    {
        acc = _mm512_add_epi64(acc, _mm512_cvtepi32_epi64(_mm256_loadu_si256((const __m256i *)(a + i))));
    }
    if (i < n)
    {
        __mmask8 m = (__mmask8)((1u << (n - i)) - 1u);
        acc = _mm512_add_epi64(acc, _mm512_cvtepi32_epi64(_mm256_maskz_loadu_epi32(m, a + i)));
    }
    return _mm512_reduce_add_epi64(acc);
}

uint32_t k_sum_u8(const uint8_t *a, size_t n)
{
    __m512i zero = _mm512_setzero_si512();
    __m512i acc = zero;
    size_t i = 0;
    for (; i + 64 <= n; i += 64)
    {
        acc = _mm512_add_epi64(acc, _mm512_sad_epu8(_mm512_loadu_si512(a + i), zero));
    }
    if (i < n)
    {
        __mmask64 m = _bzhi_u64(~0ull, (unsigned)(n - i));
        acc = _mm512_add_epi64(acc, _mm512_sad_epu8(_mm512_maskz_loadu_epi8(m, a + i), zero));
    }
    return (uint32_t)_mm512_reduce_add_epi64(acc);
}

uint32_t k_dot_i16(const int16_t *a, const int16_t *b, size_t n)
{
    __m512i acc = _mm512_setzero_si512();
    size_t i = 0;
    for (; i + 32 <= n; i += 32)
    {
        acc = _mm512_add_epi32(acc, _mm512_madd_epi16(_mm512_loadu_si512(a + i), _mm512_loadu_si512(b + i)));
    }
    if (i < n)
    {
        __mmask32 m = _bzhi_u32(~0u, (unsigned)(n - i));
        acc = _mm512_add_epi32(acc, _mm512_madd_epi16(_mm512_maskz_loadu_epi16(m, a + i), _mm512_maskz_loadu_epi16(m, b + i)));
    }
    return (uint32_t)_mm512_reduce_add_epi32(acc);
}

int32_t k_max_i32(const int32_t *a, size_t n)
{
    __m512i acc = _mm512_set1_epi32(INT32_MIN);
    size_t i = 0;
    for (; i + 16 <= n; i += 16)
    {
        acc = _mm512_max_epi32(acc, _mm512_loadu_si512(a + i));
    }
    if (i < n)
    {
        __mmask16 m = (__mmask16)_bzhi_u32(~0u, (unsigned)(n - i));
        acc = _mm512_mask_max_epi32(acc, m, acc, _mm512_maskz_loadu_epi32(m, a + i));
    }
    return _mm512_reduce_max_epi32(acc);
}

size_t k_count_eq_u8(const uint8_t *a, size_t n, uint8_t v)
{
    __m512i vv = _mm512_set1_epi8((char)v);
    size_t c = 0;
    size_t i = 0;
    for (; i + 64 <= n; i += 64)
    {
        c += (size_t)_mm_popcnt_u64(_mm512_cmpeq_epi8_mask(_mm512_loadu_si512(a + i), vv));
    }
    if (i < n)
    {
        __mmask64 m = _bzhi_u64(~0ull, (unsigned)(n - i));
        c += (size_t)_mm_popcnt_u64(_mm512_mask_cmpeq_epi8_mask(m, _mm512_maskz_loadu_epi8(m, a + i), vv));
    }
    return c;
}

int64_t k_cond_sum_i32(const int32_t *a, size_t n, int32_t t)
{
    __m256i tv = _mm256_set1_epi32(t);
    __m512i acc = _mm512_setzero_si512();
    size_t i = 0;
    for (; i + 8 <= n; i += 8)
    {
        __m256i v = _mm256_loadu_si256((const __m256i *)(a + i));
        acc = _mm512_mask_add_epi64(acc, _mm256_cmpgt_epi32_mask(v, tv), acc, _mm512_cvtepi32_epi64(v));
    }
    if (i < n)
    {
        __mmask8 m = (__mmask8)((1u << (n - i)) - 1u);
        __m256i v = _mm256_maskz_loadu_epi32(m, a + i);
        acc = _mm512_mask_add_epi64(acc, _mm256_mask_cmpgt_epi32_mask(m, v, tv), acc, _mm512_cvtepi32_epi64(v));
    }
    return _mm512_reduce_add_epi64(acc);
}

void k_add_i32(int32_t *d, const int32_t *a, const int32_t *b, size_t n)
{
    if (ranges_overlap(d, n * 4, a, n * 4) || ranges_overlap(d, n * 4, b, n * 4))
    {
        scalar_k_add_i32(d, a, b, n);
    }
    else
    {
        size_t i = 0;
        for (; i + 16 <= n; i += 16)
        {
            _mm512_storeu_si512(d + i, _mm512_add_epi32(_mm512_loadu_si512(a + i), _mm512_loadu_si512(b + i)));
        }
        if (i < n)
        {
            __mmask16 m = (__mmask16)_bzhi_u32(~0u, (unsigned)(n - i));
            _mm512_mask_storeu_epi32(d + i, m, _mm512_add_epi32(_mm512_maskz_loadu_epi32(m, a + i), _mm512_maskz_loadu_epi32(m, b + i)));
        }
    }
}

void k_saxpy_f32(float *y, const float *x, float k, size_t n)
{
    if (ranges_overlap(y, n * 4, x, n * 4))
    {
        scalar_k_saxpy_f32(y, x, k, n);
    }
    else
    {
        __m512 kv = _mm512_set1_ps(k);
        size_t i = 0;
        for (; i + 16 <= n; i += 16)
        {
            _mm512_storeu_ps(y + i, _mm512_fmadd_ps(kv, _mm512_loadu_ps(x + i), _mm512_loadu_ps(y + i)));
        }
        if (i < n)
        {
            __mmask16 m = (__mmask16)_bzhi_u32(~0u, (unsigned)(n - i));
            _mm512_mask_storeu_ps(y + i, m, _mm512_fmadd_ps(kv, _mm512_maskz_loadu_ps(m, x + i), _mm512_maskz_loadu_ps(m, y + i)));
        }
    }
}

void k_scale_u8(uint8_t *d, const uint8_t *s, unsigned k, size_t n)
{
    if (ranges_overlap(d, n, s, n))
    {
        scalar_k_scale_u8(d, s, k, n);
    }
    else
    {
        __m512i kv = _mm512_set1_epi16((short)k);
        size_t i = 0;
        for (; i + 32 <= n; i += 32)
        {
            __m512i v = _mm512_cvtepu8_epi16(_mm256_loadu_si256((const __m256i *)(s + i)));
            _mm256_storeu_si256((__m256i *)(d + i), _mm512_cvtepi16_epi8(_mm512_srli_epi16(_mm512_mullo_epi16(v, kv), 8)));
        }
        if (i < n)
        {
            __mmask32 m = _bzhi_u32(~0u, (unsigned)(n - i));
            __m512i v = _mm512_cvtepu8_epi16(_mm256_maskz_loadu_epi8(m, s + i));
            _mm256_mask_storeu_epi8(d + i, m, _mm512_cvtepi16_epi8(_mm512_srli_epi16(_mm512_mullo_epi16(v, kv), 8)));
        }
    }
}

void k_clamp_i32(int32_t *d, const int32_t *a, int lo, int hi, int n)
{
    if (n > 0 && ranges_overlap(d, (size_t)n * 4, a, (size_t)n * 4))
    {
        scalar_k_clamp_i32(d, a, lo, hi, n);
    }
    else
    {
        __m512i lov = _mm512_set1_epi32(lo);
        __m512i hiv = _mm512_set1_epi32(hi);
        int i = 0;
        for (; i + 16 <= n; i += 16)
        {
            __m512i v = _mm512_loadu_si512(a + i);
            __m512i r = _mm512_mask_mov_epi32(v, _mm512_cmpgt_epi32_mask(v, hiv), hiv);
            _mm512_storeu_si512(d + i, _mm512_mask_mov_epi32(r, _mm512_cmplt_epi32_mask(v, lov), lov));
        }
        if (i < n)
        {
            __mmask16 m = (__mmask16)_bzhi_u32(~0u, (unsigned)(n - i));
            __m512i v = _mm512_maskz_loadu_epi32(m, a + i);
            __m512i r = _mm512_mask_mov_epi32(v, _mm512_cmpgt_epi32_mask(v, hiv), hiv);
            _mm512_mask_storeu_epi32(d + i, m, _mm512_mask_mov_epi32(r, _mm512_cmplt_epi32_mask(v, lov), lov));
        }
    }
}

void k_i32_to_f32(float *d, const int32_t *a, float k, size_t n)
{
    if (ranges_overlap(d, n * 4, a, n * 4))
    {
        scalar_k_i32_to_f32(d, a, k, n);
    }
    else
    {
        __m512 kv = _mm512_set1_ps(k);
        size_t i = 0;
        for (; i + 16 <= n; i += 16)
        {
            _mm512_storeu_ps(d + i, _mm512_mul_ps(_mm512_cvtepi32_ps(_mm512_loadu_si512(a + i)), kv));
        }
        if (i < n)
        {
            __mmask16 m = (__mmask16)_bzhi_u32(~0u, (unsigned)(n - i));
            _mm512_mask_storeu_ps(d + i, m, _mm512_mul_ps(_mm512_cvtepi32_ps(_mm512_maskz_loadu_epi32(m, a + i)), kv));
        }
    }
}

void k_fill_u32(uint32_t *d, uint32_t v, size_t n)
{
    __m512i vv = _mm512_set1_epi32((int)v);
    size_t i = 0;
    for (; i + 16 <= n; i += 16)
    {
        _mm512_storeu_si512(d + i, vv);
    }
    if (i < n)
    {
        __mmask16 m = (__mmask16)_bzhi_u32(~0u, (unsigned)(n - i));
        _mm512_mask_storeu_epi32(d + i, m, vv);
    }
}
