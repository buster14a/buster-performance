// The cost of a line-crossing load on Zen 5 when loads bound the loop: eight independent loads per iteration from
// eight lines of a 32 KiB buffer (L1), each into its own accumulator.
// Usage: split-probe2 WIDTH OFFSET ITERATIONS   (WIDTH 32 or 64; MASKED: WIDTH 33 is a 32-byte masked load of 8 bytes)
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static uint8_t buffer[32768 + 128] __attribute__((aligned(4096)));

#define STEP(k)                                                                                                         \
    do                                                                                                                  \
    {                                                                                                                   \
        const uint8_t* q = p + 64 * (line + k);                                                                         \
        __asm__ volatile("" : "+r"(q));                                                                                 \
        if (width == 64)                                                                                                \
            acc[k] = _mm512_add_epi64(acc[k], _mm512_loadu_si512(q));                                                   \
        else if (width == 32)                                                                                           \
            acc[k] = _mm512_add_epi64(acc[k], _mm512_castsi256_si512(_mm256_loadu_si256((const __m256i*)q)));         \
        else                                                                                                            \
            acc[k] = _mm512_add_epi64(acc[k], _mm512_castsi256_si512(_mm256_maskz_loadu_epi8(0xFF, q)));              \
    } while (0)

int main(int argc, char** argv)
{
    const int width = atoi(argv[1]);
    const uint32_t offset = (uint32_t)atoi(argv[2]);
    const uint64_t iterations = strtoull(argv[3], 0, 10);
    for (uint32_t i = 0; i < sizeof(buffer); i += 1)
    {
        buffer[i] = (uint8_t)(i * 7 + 3);
    }
    __m512i acc[8];
    for (int k = 0; k < 8; k += 1)
    {
        acc[k] = _mm512_setzero_si512();
    }
    const uint8_t* p = buffer + offset;
    for (uint64_t n = 0; n < iterations; n += 1)
    {
        for (uint32_t line = 0; line < 504; line += 8)
        {
            STEP(0);
            STEP(1);
            STEP(2);
            STEP(3);
            STEP(4);
            STEP(5);
            STEP(6);
            STEP(7);
        }
    }
    __m512i sum = acc[0];
    for (int k = 1; k < 8; k += 1)
    {
        sum = _mm512_xor_si512(sum, acc[k]);
    }
    uint8_t out[64];
    _mm512_storeu_si512(out, sum);
    printf("%u\n", out[0] ^ out[17]);
    return 0;
}
