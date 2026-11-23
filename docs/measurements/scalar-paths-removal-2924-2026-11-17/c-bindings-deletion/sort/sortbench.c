// c_bindings_sort's two arms at sizes 2..65536 (#2924 C12c-5). Build: clang -O3 -march=native sortbench.c
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <immintrin.h>
#include <x86intrin.h>

static __m512i digits16(const uint64_t* keys, uint32_t lanes, uint32_t shift)
{
    const uint32_t first = lanes < 8 ? lanes : 8;
    const uint32_t second = lanes > 8 ? lanes - 8 : 0;
    const __m512i low = _mm512_maskz_loadu_epi64((__mmask8)((1u << first) - 1), keys);
    const __m512i high = _mm512_maskz_loadu_epi64((__mmask8)((1u << second) - 1), keys + first);
    const __m512i amount = _mm512_set1_epi64(shift);
    const __m256i a = _mm512_cvtepi64_epi32(_mm512_srlv_epi64(low, amount));
    const __m256i b = _mm512_cvtepi64_epi32(_mm512_srlv_epi64(high, amount));
    return _mm512_inserti64x4(_mm512_castsi256_si512(a), b, 1);
}

__attribute__((noinline)) static uint64_t* sort_arms(uint64_t* keys, uint64_t* temporary, uint32_t count, bool vector, uint32_t varying)
{
    uint64_t* input = keys;
    uint64_t* output = temporary;
    for (uint32_t pass = 0; count > 1 && pass < 4; pass += 1)
    {
        if (!vector || ((varying >> (pass * 8)) & 255) != 0)
        {
            uint32_t histogram[256] = { 0 };
            const uint32_t shift = 32 + pass * 8;
            for (uint32_t phase = 0; phase < 2; phase += 1)
            {
                if (phase == 1)
                {
                    uint32_t total = 0;
                    for (uint32_t bucket = 0; bucket < 256; bucket += 1)
                    {
                        const uint32_t frequency = histogram[bucket];
                        histogram[bucket] = total;
                        total += frequency;
                    }
                }
                if (vector)
                {
                    for (uint32_t begin = 0; begin < count;)
                    {
                        const uint32_t lanes = count - begin < 16 ? count - begin : 16;
                        const __mmask16 mask = (__mmask16)((1u << lanes) - 1);
                        const __m512i digits = _mm512_and_si512(digits16(input + begin, lanes, shift), _mm512_set1_epi32(255));
                        const __m512i conflicts = _mm512_maskz_conflict_epi32(mask, digits);
                        const __m512i ranks = _mm512_popcnt_epi32(conflicts);
                        const uint32_t earlier = (uint32_t)_mm512_reduce_or_epi32(conflicts);
                        uint32_t buckets[16];
                        uint32_t offsets[16];
                        _mm512_storeu_si512(buckets, digits);
                        _mm512_storeu_si512(offsets, ranks);
                        if (phase == 1)
                        {
                            for (uint32_t lane = 0; lane < lanes; lane += 1)
                            {
                                output[histogram[buckets[lane]] + offsets[lane]] = input[begin + lane];
                            }
                        }
                        uint32_t last = (uint32_t)mask & ~earlier;
                        while (last != 0)
                        {
                            const uint32_t lane = (uint32_t)__builtin_ctz(last);
                            histogram[buckets[lane]] += offsets[lane] + 1;
                            last &= last - 1;
                        }
                        begin += lanes;
                    }
                }
                else
                {
                    for (uint32_t i = 0; i < count; i += 1)
                    {
                        const uint32_t bucket = (uint32_t)(input[i] >> shift) & 255;
                        if (phase == 0)
                        {
                            histogram[bucket] += 1;
                        }
                        else
                        {
                            output[histogram[bucket]++] = input[i];
                        }
                    }
                }
            }
            uint64_t* swap = input;
            input = output;
            output = swap;
        }
    }
    return input;
}

#ifdef CANDIDATE
#include CANDIDATE
#endif

static uint64_t state = 0x9e3779b97f4a7c15ull;
static uint64_t next(void)
{
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return state;
}

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

int main(int argc, char** argv)
{
    const uint32_t sizes[] = { 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536 };
    // varying: high halves below 2^8, 2^16, 2^24 (with a constant high byte), and full 32 bits; and two bytes in the middle
    const uint32_t masks[] = { 0xffu, 0xffffu, 0xffffffu, 0xffffffffu, 0xff00u };
    const uint32_t variants = 3 + (argc > 1);
    static uint64_t source[65536];
    static uint64_t keys[65536];
    static uint64_t temporary[65536];
    static uint64_t reference[65536];
    printf("size\tmask\tscalar\tvector%s\n", argc > 1 ? "\tcandidate" : "");
    for (uint32_t m = 0; m < sizeof(masks) / sizeof(masks[0]); m += 1)
    {
        for (uint32_t s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s += 1)
        {
            const uint32_t count = sizes[s];
            uint32_t any = 0;
            uint32_t every = UINT32_MAX;
            for (uint32_t i = 0; i < count; i += 1)
            {
                const uint32_t high = (uint32_t)next() & masks[m];
                source[i] = (uint64_t)high << 32 | i;
                any |= high;
                every &= high;
            }
            memcpy(reference, source, (uint64_t)count * 8);
            qsort(reference, count, 8, compare);
            const uint32_t repeats = 4000000 / count + 3;
            double best[4] = { 1e30, 1e30, 1e30, 1e30 };
            for (uint32_t round = 0; round < 7; round += 1)
            {
                for (uint32_t v = 0; v < variants - 1 + 0; v += 1)
                {
                }
                for (uint32_t v = 0; v < (argc > 1 ? 3u : 2u); v += 1)
                {
                    uint64_t total = 0;
                    const uint64_t* sorted = 0;
                    for (uint32_t r = 0; r < repeats; r += 1)
                    {
                        memcpy(keys, source, (uint64_t)count * 8);
                        const uint64_t start = __rdtsc();
#ifdef CANDIDATE
                        sorted = v == 2 ? candidate_sort(keys, temporary, count, any ^ every) : sort_arms(keys, temporary, count, v == 1, v == 1 ? any ^ every : UINT32_MAX);
#else
                        sorted = sort_arms(keys, temporary, count, v == 1, v == 1 ? any ^ every : UINT32_MAX);
#endif
                        __asm__ volatile("" ::"r"(sorted) : "memory");
                        total += __rdtsc() - start;
                    }
                    if (memcmp(sorted, reference, (uint64_t)count * 8) != 0)
                    {
                        printf("WRONG v%u size %u mask %x\n", v, count, masks[m]);
                        return 1;
                    }
                    const double each = (double)total / repeats;
                    best[v] = each < best[v] ? each : best[v];
                }
            }
            printf("%u\t%x\t%.1f\t%.1f", count, masks[m], best[0], best[1]);
            if (argc > 1)
            {
                printf("\t%.1f", best[2]);
            }
            printf("\n");
        }
    }
    return 0;
}
