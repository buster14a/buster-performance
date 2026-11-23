// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// #1398's four intrinsic kernels, compiled by each compiler under test at -march=znver5 (driver.c, by clang -O2,
// calls and times them).
#include <immintrin.h>
#include <stdint.h>

__attribute__((noinline)) void k_sum(const float* p, int n, float* out)
{
    __m256 s = _mm256_setzero_ps();
    for (int i = 0; i + 8 <= n; i += 8)
    {
        s = _mm256_add_ps(s, _mm256_loadu_ps(p + i));
    }
    _mm256_storeu_ps(out, s);
}

__attribute__((noinline)) void k_adds(uint8_t* d, const uint8_t* a, const uint8_t* b, int n)
{
    for (int i = 0; i + 32 <= n; i += 32)
    {
        _mm256_storeu_si256((__m256i*)(d + i), _mm256_adds_epu8(_mm256_loadu_si256((const __m256i*)(a + i)), _mm256_loadu_si256((const __m256i*)(b + i))));
    }
}

__attribute__((noinline)) uint64_t k_count(const int32_t* p, int n, int32_t k)
{
    const __m512i key = _mm512_set1_epi32(k);
    uint64_t c = 0;
    for (int i = 0; i + 16 <= n; i += 16)
    {
        c += (uint64_t)__builtin_popcount(_mm512_cmpeq_epi32_mask(_mm512_loadu_si512(p + i), key));
    }
    return c;
}

__attribute__((noinline)) void k_fma(const float* a, const float* b, int n, float* out)
{
    __m256 s = _mm256_setzero_ps();
    for (int i = 0; i + 8 <= n; i += 8)
    {
        s = _mm256_fmadd_ps(_mm256_loadu_ps(a + i), _mm256_loadu_ps(b + i), s);
    }
    _mm256_storeu_ps(out, s);
}
