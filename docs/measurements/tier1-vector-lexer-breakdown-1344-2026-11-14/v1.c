#include <immintrin.h>
__m512i splat8(__m512i x) { return _mm512_add_epi8(x, _mm512_set1_epi8(7)); }
__m512i zero(__m512i x, __mmask64 k) { return _mm512_maskz_compress_epi8(k, x); }
__m512i splat32(__m512i x) { return _mm512_add_epi32(x, _mm512_set1_epi32(1)); }
__m512i general(__m512i x) { return _mm512_add_epi64(x, _mm512_set_epi64(7, 6, 5, 4, 3, 2, 1, 0)); }
__m512i variable(__m512i x, char c) { return _mm512_add_epi8(x, _mm512_set1_epi8(c)); }
