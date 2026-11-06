// Does a load that crosses a 64-byte line cost a split on Zen 5 when only its masked-off bytes are past the line?
// Usage: split-probe MODE OFFSET LENGTH ITERATIONS
//   MODE 0: plain 32-byte load at each line + OFFSET (vmovdqu ymm)
//   MODE 1: 32-byte masked load, LENGTH bytes enabled (vmovdqu8 ymm{k}{z})
//   MODE 2: plain 16-byte load (vmovdqu xmm)
//   MODE 3: 64-byte load at each line + OFFSET (vmovdqu64 zmm)
//   MODE 4: 64-byte vpermt2b of the line and the next one, shifted by one byte (no load at an offset)
// Each pass reads 512 lines of a 32 KiB buffer (L1), four independent chains, so the loads, not latency, bound it.
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static uint8_t buffer[32768 + 128] __attribute__((aligned(4096)));

int main(int argc, char** argv)
{
    const int mode = atoi(argv[1]);
    const uint32_t offset = (uint32_t)atoi(argv[2]);
    const uint32_t length = (uint32_t)atoi(argv[3]);
    const uint64_t iterations = strtoull(argv[4], 0, 10);
    for (uint32_t i = 0; i < sizeof(buffer); i += 1)
    {
        buffer[i] = (uint8_t)(i * 7 + 3);
    }
    const __mmask32 mask = _bzhi_u32(~0u, length);
    __m512i acc0 = _mm512_setzero_si512();
    __m512i acc1 = _mm512_setzero_si512();
    __m512i indices = _mm512_add_epi8(_mm512_set_epi8(63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0), _mm512_set1_epi8(1));
    __asm__ volatile("" : "+v"(indices));
    for (uint64_t n = 0; n < iterations; n += 1)
    {
        const uint8_t* p = buffer + offset;
        for (uint32_t line = 0; line < 512; line += 2)
        {
            const uint8_t* a = p + 64 * line;
            const uint8_t* b = a + 64;
            __asm__ volatile("" : "+r"(a), "+r"(b));
            if (mode == 0)
            {
                acc0 = _mm512_xor_si512(acc0, _mm512_castsi256_si512(_mm256_loadu_si256((const __m256i*)a)));
                acc1 = _mm512_xor_si512(acc1, _mm512_castsi256_si512(_mm256_loadu_si256((const __m256i*)b)));
            }
            else if (mode == 1)
            {
                acc0 = _mm512_xor_si512(acc0, _mm512_castsi256_si512(_mm256_maskz_loadu_epi8(mask, a)));
                acc1 = _mm512_xor_si512(acc1, _mm512_castsi256_si512(_mm256_maskz_loadu_epi8(mask, b)));
            }
            else if (mode == 2)
            {
                acc0 = _mm512_xor_si512(acc0, _mm512_castsi128_si512(_mm_loadu_si128((const __m128i*)a)));
                acc1 = _mm512_xor_si512(acc1, _mm512_castsi128_si512(_mm_loadu_si128((const __m128i*)b)));
            }
            else if (mode == 3)
            {
                acc0 = _mm512_xor_si512(acc0, _mm512_loadu_si512(a));
                acc1 = _mm512_xor_si512(acc1, _mm512_loadu_si512(b));
            }
            else
            {
                const __m512i* la = (const __m512i*)(buffer + 64 * line);
                acc0 = _mm512_xor_si512(acc0, _mm512_permutex2var_epi8(la[0], indices, la[1]));
                acc1 = _mm512_xor_si512(acc1, _mm512_permutex2var_epi8(la[1], indices, la[2]));
            }
        }
    }
    uint8_t out[64];
    _mm512_storeu_si512(out, _mm512_xor_si512(acc0, acc1));
    printf("%u\n", out[0] ^ out[17]);
    return 0;
}
