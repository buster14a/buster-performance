#include <immintrin.h>

void mask_blend(void* out, const void* a, const void* b, const void* c)
{
    __m512i x = _mm512_loadu_si512(a);
    __m512i y = _mm512_loadu_si512(b);
    __m512i z = _mm512_loadu_si512(c);
    __mmask64 k = _mm512_cmpeq_epi8_mask(x, y);
    _mm512_storeu_si512(out, _mm512_mask_blend_epi8(k, x, z));
}

void mask_compress(void* out, const void* a, const void* b)
{
    __m512i x = _mm512_loadu_si512(a);
    __m512i y = _mm512_loadu_si512(b);
    __mmask64 k = _mm512_cmpeq_epi8_mask(x, y);
    _mm512_storeu_si512(out, _mm512_maskz_compress_epi8(k, x));
}

typedef unsigned long long U64x8 __attribute__((vector_size(64)));

void lane0(U64x8* out, unsigned long long x)
{
    *out = (U64x8){x};
}

void distinct(U64x8* out, unsigned long long x, unsigned long long y)
{
    *out = (U64x8){x, y, x, y, x, y, x, y};
}
