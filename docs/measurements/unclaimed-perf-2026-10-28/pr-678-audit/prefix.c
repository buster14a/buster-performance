#include "host_isa.h"
#define BUSTER_INLINE static inline
static const uint16_t pp_word_indices[32] __attribute__((aligned(64))) = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };

// The inclusive prefix sums of 32 16-bit words, wrapping: five steps of a permute that moves the words up by 1, 2, 4, 8
// and 16 places, zeroing the places it shifts in (vpermw: one uop on Zen 5, latency 4), and an add.
BUSTER_INLINE __m512i pp_prefix_sum_words(__m512i x)
{
    const __m512i indices = _mm512_load_si512(pp_word_indices);
    for (uint32_t shift = 1; shift < 32; shift *= 2)
    {
        const __m512i from = _mm512_sub_epi16(indices, _mm512_set1_epi16((short)shift));
        x = _mm512_add_epi16(x, _mm512_maskz_permutexvar_epi16(~0u << shift, from, x));
    }
    return x;
}

static uint32_t pp_print_offsets(const uint32_t* lengths, uint32_t count, uint64_t gaps, uint16_t* offsets)
{
    uint32_t total = 0;
    bool ordinary = true;
    for (uint32_t first = 0; first < count; first += 32)
    {
        const uint32_t take = count - first < 32 ? count - first : 32;
        const uint32_t low = take < 16 ? take : 16;
        const uint32_t high = take > 16 ? take - 16 : 0;
        const __m512i a = _mm512_maskz_loadu_epi32((__mmask16)_bzhi_u32(~0u, low), lengths + first);
        const __m512i b = high != 0 ? _mm512_maskz_loadu_epi32((__mmask16)_bzhi_u32(~0u, high), lengths + first + 16) : _mm512_setzero_si512();
        ordinary &= (_mm512_mask_cmplt_epu32_mask((__mmask16)_bzhi_u32(~0u, low), _mm512_sub_epi32(a, _mm512_set1_epi32(1)), _mm512_set1_epi32(64)) == (__mmask16)_bzhi_u32(~0u, low));
        ordinary &= (_mm512_mask_cmplt_epu32_mask((__mmask16)_bzhi_u32(~0u, high), _mm512_sub_epi32(b, _mm512_set1_epi32(1)), _mm512_set1_epi32(64)) == (__mmask16)_bzhi_u32(~0u, high));
        const __m512i words = _mm512_inserti64x4(_mm512_castsi256_si512(_mm512_cvtepi32_epi16(a)), _mm512_cvtepi32_epi16(b), 1);
        const __m512i sizes = _mm512_mask_add_epi16(words, (__mmask32)((gaps >> first) & _bzhi_u64(~0ull, take)), words, _mm512_set1_epi16(1));
        const __m512i ends = _mm512_add_epi16(pp_prefix_sum_words(sizes), _mm512_set1_epi16((short)total));
        _mm512_mask_storeu_epi16(offsets + first, (__mmask32)_bzhi_u64(~0ull, take), _mm512_sub_epi16(ends, sizes));
        // Inactive words are zero, so the final lane also holds the last active word's end.
        total = (uint16_t)_mm256_extract_epi16(_mm512_extracti64x4_epi64(ends, 1), 15);
    }
    return ordinary ? total : 0;
}

int main(int argc, char**argv)
{
 (void)argv; uint32_t lengths[64]; uint16_t offsets[64]; for(unsigned i=0;i<64;i+=1) lengths[i]=(uint32_t)(argc+i)%64+1; return pp_print_offsets(lengths,64,~0ull,offsets)==0;
}
