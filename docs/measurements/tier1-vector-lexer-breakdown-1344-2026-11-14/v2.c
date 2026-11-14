#include <immintrin.h>
__m512i q63(__m512i x) { return _mm512_add_epi64(x, _mm512_set1_epi64(63)); }
__m512i qbig(__m512i x) { return _mm512_xor_si512(x, _mm512_set1_epi64(0x8040201008040201ll)); }
__m512i qneg(__m512i x) { return _mm512_add_epi64(x, _mm512_set1_epi64(-5)); }
__m256i q256(__m256i x) { return _mm256_add_epi64(x, _mm256_set1_epi64x(7)); }
__m128i q128(__m128i x) { return _mm_add_epi64(x, _mm_set1_epi64x(9)); }
__m512i general(__m512i x) { return _mm512_add_epi64(x, _mm512_set_epi64(7, 6, 5, 4, 3, 2, 1, 0)); }
