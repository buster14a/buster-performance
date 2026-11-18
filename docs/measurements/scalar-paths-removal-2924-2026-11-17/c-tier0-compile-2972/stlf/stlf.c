// #2972: Zen 5 store-to-load forwarding of 512-bit stores, masked and not, into loads of the same address: a chain of
// store, load, add per iteration, cycles per iteration by TSC (3.8 GHz base) over N iterations.
#include <immintrin.h>
#include <x86intrin.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define N 20000000ull
static _Alignas(64) uint8_t buffer[256];

#define BARRIER __asm__ volatile("" ::: "memory");
#define CHAIN(name, body) \
    static __attribute__((noinline)) uint64_t name(__m512i start, __mmask64 mask) \
    { \
        __m512i v = start; \
        const uint64_t t0 = __rdtsc(); \
        for (uint64_t i = 0; i < N; i += 1) \
        { \
            body \
            __asm__ volatile("" : "+v"(v) :: "memory"); \
        } \
        const uint64_t t1 = __rdtsc(); \
        uint8_t sink[64]; \
        _mm512_storeu_si512(sink, v); \
        __asm__ volatile("" :: "r"(sink) : "memory"); \
        return t1 - t0; \
    }

CHAIN(full_full, _mm512_storeu_si512(buffer, v); BARRIER v = _mm512_add_epi8(_mm512_loadu_si512(buffer), _mm512_set1_epi8(1));)
CHAIN(masked_masked, _mm512_mask_storeu_epi8(buffer, mask, v); BARRIER v = _mm512_add_epi8(_mm512_maskz_loadu_epi8(mask, buffer), _mm512_set1_epi8(1));)
CHAIN(full_masked, _mm512_storeu_si512(buffer, v); BARRIER v = _mm512_add_epi8(_mm512_maskz_loadu_epi8(mask, buffer), _mm512_set1_epi8(1));)
CHAIN(masked_full, _mm512_mask_storeu_epi8(buffer, mask, v); BARRIER v = _mm512_add_epi8(_mm512_loadu_si512(buffer), _mm512_set1_epi8(1));)
CHAIN(full_xmm, _mm512_storeu_si512(buffer, v); BARRIER v = _mm512_add_epi8(_mm512_castsi128_si512(_mm_loadu_si128((const __m128i*)buffer)), _mm512_set1_epi8(1));)
CHAIN(full_xmm_masked, _mm512_storeu_si512(buffer, v); BARRIER v = _mm512_add_epi8(_mm512_castsi128_si512(_mm_maskz_loadu_epi8((__mmask16)mask, buffer)), _mm512_set1_epi8(1));)
CHAIN(masked_xmm_masked, _mm512_mask_storeu_epi8(buffer, mask, v); BARRIER v = _mm512_add_epi8(_mm512_castsi128_si512(_mm_maskz_loadu_epi8((__mmask16)mask, buffer)), _mm512_set1_epi8(1));)
CHAIN(full_u64, _mm512_storeu_si512(buffer, v); BARRIER uint64_t w; memcpy(&w, buffer, 8); v = _mm512_add_epi8(v, _mm512_set1_epi64((int64_t)w));)
CHAIN(bytes_u64, buffer[0] = (uint8_t)_mm_cvtsi128_si32(_mm512_castsi512_si128(v)); BARRIER uint64_t w; memcpy(&w, buffer, 8); v = _mm512_add_epi8(v, _mm512_set1_epi64((int64_t)w));)
CHAIN(u64_u64, uint64_t s = (uint64_t)_mm_cvtsi128_si64(_mm512_castsi512_si128(v)); memcpy(buffer, &s, 8); BARRIER uint64_t w; memcpy(&w, buffer, 8); v = _mm512_add_epi8(v, _mm512_set1_epi64((int64_t)w));)
CHAIN(qword8_full, _mm_storel_epi64((__m128i*)buffer, _mm512_castsi512_si128(v)); BARRIER v = _mm512_add_epi8(_mm512_maskz_loadu_epi8(mask, buffer), _mm512_set1_epi8(1));)
CHAIN(registers, v = _mm512_add_epi8(_mm512_maskz_mov_epi8(mask, v), _mm512_set1_epi8(1));)

int main(void)
{
    const __m512i start = _mm512_set1_epi8(3);
    struct { const char* name; uint64_t (*run)(__m512i, __mmask64); } tests[] = {
        { "registers (no memory)", registers },
        { "64B store -> 64B load", full_full },
        { "masked 64B store -> masked 64B load (same mask)", masked_masked },
        { "64B store -> masked 64B load", full_masked },
        { "masked 64B store -> 64B load", masked_full },
        { "64B store -> 16B load", full_xmm },
        { "64B store -> masked 16B load", full_xmm_masked },
        { "masked 64B store -> masked 16B load", masked_xmm_masked },
        { "64B store -> 8B GPR load", full_u64 },
        { "1B store -> 8B GPR load", bytes_u64 },
        { "8B store -> 8B load", u64_u64 },
        { "8B store -> masked 64B load", qword8_full },
    };
    const __mmask64 masks[] = { 0x7ull, ~0ull };
    for (uint32_t m = 0; m < 2; m += 1)
    {
        printf("mask %016llx\n", (unsigned long long)masks[m]);
        for (uint32_t t = 0; t < sizeof(tests) / sizeof(tests[0]); t += 1)
        {
            uint64_t best = UINT64_MAX;
            for (uint32_t r = 0; r < 5; r += 1)
            {
                const uint64_t ticks = tests[t].run(start, masks[m]);
                best = ticks < best ? ticks : best;
            }
            printf("  %-50s %6.2f ticks/iteration\n", tests[t].name, (double)best / (double)N);
        }
    }
    return 0;
}
