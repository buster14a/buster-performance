#include "tier1-rows.h"
__m512i r_bytes(__m512i a, __m512i b)
{
    __m512i s = _mm512_add_epi8(a, b);
    __m512i d = _mm512_sub_epi16(s, b);
    __m512i m = _mm512_mullo_epi16(d, a);
    __m512i q = _mm512_add_epi64(m, _mm512_sub_epi64(a, b));
    return _mm512_xor_si512(q, _mm512_shuffle_epi8(a, b));
}
uint64_t r_compares(__m512i a, __m512i b)
{
    __mmask64 eq = _mm512_cmpeq_epi8_mask(a, b);
    __mmask64 lt = _mm512_cmplt_epu8_mask(a, b);
    __mmask32 w = _mm512_cmpgt_epi16_mask(a, b);
    __mmask16 d = _mm512_cmple_epi32_mask(a, b);
    __mmask8 q = _mm512_cmpneq_epi64_mask(a, b);
    __mmask16 f = _mm512_cmp_ps_mask(_mm512_castsi512_ps(a), _mm512_castsi512_ps(b), _CMP_LE_OS);
    return eq ^ (lt << 1) ^ ((uint64_t)w << 7) ^ ((uint64_t)d << 23) ^ ((uint64_t)q << 40) ^ ((uint64_t)f << 47);
}
__m512i r_masked(__m512i a, __m512i b, __mmask64 k, __mmask16 k16)
{
    __m512i x = _mm512_mask_add_epi8(a, k, a, b);
    __m512i y = _mm512_maskz_sub_epi32(_mm512_mask_cmpgt_epi32_mask(k16, x, b) | (k16 >> 4), x, b);
    __m512i z = _mm512_mask_blend_epi8(_mm512_mask_cmplt_epu8_mask(k, y, a) ^ (k >> 5), y, b);
    return _mm512_mask_mov_epi16(z, (__mmask32)(k >> 3), a);
}
__m512i r_permutes(__m512i a, __m512i b, __m512i idx)
{
    __m512i p = _mm512_permutex2var_epi64(a, idx, b);
    __m512i q = _mm512_permutexvar_epi16(idx, a);
    __m512i r = _mm512_permutex2var_epi16(a, idx, b);
    __m512i s = _mm512_shuffle_epi32(p, 0x1b);
    return _mm512_ternarylogic_epi64(q, r, s, 0x96);
}
__m512i r_shifts(__m512i a, __m512i b, int n)
{
    __m512i x = _mm512_srli_epi16(a, n);
    __m512i y = _mm512_slli_epi64(a, 3);
    __m512i z = _mm512_srlv_epi64(b, _mm512_set1_epi64(n));
    __m512i w = _mm512_sllv_epi32(b, a);
    __m512i v = _mm512_srai_epi32(b, n);
    return _mm512_or_si512(_mm512_or_si512(x, y), _mm512_xor_si512(z, _mm512_add_epi32(w, v)));
}
void r_memory(unsigned char* out, const unsigned char* in, __mmask64 k, __mmask16 k16)
{
    __m512i a = _mm512_maskz_loadu_epi8(k, in);
    __m512i b = _mm512_loadu_si512(in + 3);
    _mm512_mask_storeu_epi8(out, k, _mm512_add_epi8(a, b));
    _mm512_mask_storeu_epi32(out + 64, k16, _mm512_maskz_compress_epi32(k16, b));
    _mm512_storeu_si512(out + 128, _mm512_mask_loadu_epi16(a, (__mmask32)k, in + 1));
}
__m512i r_lanes(__m512i a, __m256i h, __m128i l, long long g, int i)
{
    __m512i x = _mm512_inserti64x4(a, h, 1);
    __m512i y = _mm512_inserti32x4(x, l, 2);
    __m128i e = _mm512_extracti32x4_epi32(y, 3);
    __m256i f = _mm512_extracti64x4_epi64(a, 1);
    __m512i z = _mm512_add_epi64(y, _mm512_set1_epi64(g));
    __m512i w = _mm512_add_epi32(z, _mm512_set1_epi32(i));
    __m512i u = _mm512_cvtepu8_epi16(_mm256_add_epi8(f, _mm256_zextsi128_si256(e)));
    return _mm512_xor_si512(w, u);
}
long long r_reduce(__m512i a, __m512i b)
{
    __m512i c = _mm512_lzcnt_epi64(a);
    __m512i d = _mm512_max_epi64(a, b);
    __m512i e = _mm512_min_epu32(a, b);
    long long s = _mm512_reduce_add_epi64(_mm512_add_epi64(c, d));
    return s ^ _mm512_reduce_or_epi64(e) ^ _mm_cvtsi128_si64(_mm512_castsi512_si128(d)) ^ _mm_cvtsi128_si32(_mm512_castsi512_si128(e));
}
__m256i r_narrow(__m256i a, __m256i b, __m128i c)
{
    __m256i x = _mm256_add_epi8(a, b);
    __m256i y = _mm256_mask_sub_epi16(x, (__mmask16)_mm256_cmpgt_epi8_mask(a, b), a, b);
    __m128i z = _mm_add_epi64(c, _mm256_castsi256_si128(y));
    __m128i w = _mm_maskz_mov_epi8(_mm_cmpeq_epi8_mask(c, z), z);
    return _mm256_inserti128_si256(y, w, 1);
}
uint32_t r_loop(const unsigned char* p, unsigned n, unsigned char* out)
{
    __m512i acc = _mm512_setzero_si512();
    uint32_t count = 0;
    for (unsigned i = 0; i + 64 <= n; i += 64)
    {
        __m512i v = _mm512_loadu_si512(p + i);
        __mmask64 k = _mm512_cmpeq_epi8_mask(v, _mm512_set1_epi8('a'));
        count += (uint32_t)__builtin_popcountll(k);
        acc = _mm512_add_epi8(acc, _mm512_maskz_mov_epi8(k, _mm512_set1_epi8(1)));
        acc = _mm512_max_epu8(acc, v);
    }
    _mm512_storeu_si512(out, acc);
    return count;
}
int r_vex(__m256i a, __m256i b, __m256i m)
{
    __m256i x = _mm256_blendv_epi8(a, b, m);
    int mask = _mm256_movemask_epi8(x);
    return mask ^ _mm256_testz_si256(a, b) ^ (_mm256_testc_si256(x, m) << 1) ^ (_mm256_movemask_epi8(_mm256_add_epi8(x, m)) << 3);
}
