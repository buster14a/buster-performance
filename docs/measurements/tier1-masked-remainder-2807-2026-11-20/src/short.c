// short.c: buster#2807's short-length driver over buster#2743's kernels (kernels.c, kernels.h, unchanged). Always built
// by clang -O2; the kernels' object is the compiler under test's. Each of the 12 loops Tier 1 vectorizes at znver5, at
// lengths below, at and around one and a few vectors: CALLS calls a measurement, the TSC's ticks a call as the least
// of ROUNDS measurements. Last, a digest of every result, which every build must print alike.
// Usage: short   Prints: name elements ticks_per_call, then "digest HEX".
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <x86intrin.h>
#include "kernels.h"

enum
{
    ROUNDS = 7,
    CALLS = 20000,
    MAXIMUM = 1024,
};

static int32_t a32[MAXIMUM];
static int32_t b32[MAXIMUM];
static int32_t d32[MAXIMUM];
static uint32_t du32[MAXIMUM];
static uint8_t a8[MAXIMUM];
static uint8_t b8[MAXIMUM];
static uint8_t d8[MAXIMUM];
static int16_t a16[MAXIMUM];
static int16_t b16[MAXIMUM];
static uint64_t a64[MAXIMUM];
static uint64_t digest = 1469598103934665603u;

static void mix(uint64_t v)
{
    digest = (digest ^ v) * 1099511628211u;
}

static uint64_t call(int kernel, size_t n, uint32_t c)
{
    uint64_t r = 0;
    switch (kernel)
    {
    case 0: r = (uint64_t)k_sum_i32(a32, n); break;
    case 1: r = k_sum_u8(a8, n); break;
    case 2: r = k_dot_i16(a16, b16, n); break;
    case 3: r = (uint64_t)k_cond_sum_i32(a32, n, 100); break;
    case 4: r = k_popcount_u64(a64, n); break;
    case 5: k_add_i32(d32, a32, b32, n); break;
    case 6: k_scale_u8(d8, a8, 77 + (c & 1), n); break;
    case 7: k_blend_u8(d8, a8, b8, 100 + (c & 1), n); break;
    case 8: k_clamp_i32(d32, a32, -1000, 1000 + (int)(c & 1), (int)n); break;
    case 9: k_fill_u32(du32, c, n); break;
    case 10: k_copy_u8(d8, a8, n); break;
    default: k_stencil3_u8(d8, a8, n); break;
    }
    return r;
}

int main(void)
{
    static const char* names[] = { "sum_i32", "sum_u8", "dot_i16", "cond_sum_i32", "popcount_u64", "add_i32", "scale_u8", "blend_u8", "clamp_i32", "fill_u32", "copy_u8", "stencil3_u8" };
    static const size_t lengths[] = { 0, 1, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65, 100, 127, 128, 129, 257 };
    uint64_t state = 0x2807;
    for (int i = 0; i < MAXIMUM; i += 1)
    {
        state = state * 6364136223846793005u + 1442695040888963407u;
        a32[i] = (int32_t)(state >> 33) % 5000 - 2500;
        b32[i] = (int32_t)(state >> 17);
        a8[i] = (uint8_t)(state >> 40);
        b8[i] = (uint8_t)(state >> 48);
        a16[i] = (int16_t)(state >> 24);
        b16[i] = (int16_t)(state >> 44);
        a64[i] = state ^ (state << 7);
    }
    for (int k = 0; k < 12; k += 1)
    {
        for (size_t l = 0; l < sizeof(lengths) / sizeof(lengths[0]); l += 1)
        {
            const size_t n = lengths[l];
            uint64_t least = UINT64_MAX;
            for (int r = 0; r < ROUNDS; r += 1)
            {
                uint64_t s = 0;
                const uint64_t start = __rdtsc();
                for (uint32_t c = 0; c < CALLS; c += 1)
                {
                    s += call(k, n, c);
                }
                const uint64_t ticks = __rdtsc() - start;
                least = ticks < least ? ticks : least;
                mix(s);
            }
            for (size_t i = 0; i < n; i += 1)
            {
                mix((uint64_t)d32[i] ^ ((uint64_t)d8[i] << 32) ^ ((uint64_t)du32[i] << 40));
            }
            printf("%s\t%zu\t%.2f\n", names[k], n, (double)least / CALLS);
        }
    }
    printf("digest\t%016llx\n", (unsigned long long)digest);
    return 0;
}
