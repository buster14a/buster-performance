// Gate for #3451's target forms: main's x86_target_forms (old: the vector loop over the compact words, then a scalar
// exact pass over the 221 extended rows) against the branch's (new: the extended lanes decided in the vector loop by
// their rest words), one executable. First every output compared over 2^20 random feature sets, every single bit, none
// and all; then rdtsc ticks a call by target, 21 passes of 256 calls alternating which side goes first, the medians.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>
void old_side(uint64_t, uint8_t*);
void new_side(uint64_t, uint8_t*);
#define FORMS 8192
#define PASSES 21
static int cmp(const void* a, const void* b) { double x = *(const double*)a, y = *(const double*)b; return x < y ? -1 : x > y; }
int main(void)
{
    static uint8_t a[FORMS] __attribute__((aligned(64)));
    static uint8_t b[FORMS] __attribute__((aligned(64)));
    uint64_t mismatches = 0, sets = 0;
    uint64_t x = 3451;
    for (uint32_t i = 0; i < (1u << 20) + 66; i += 1)
    {
        uint64_t f;
        if (i < 64) f = UINT64_C(1) << i;
        else if (i == 64) f = 0;
        else if (i == 65) f = ~UINT64_C(0);
        else { x ^= x << 13; x ^= x >> 7; x ^= x << 17; f = x & (x >> 3 | x << 5); }
        memset(a, 0x5a, sizeof(a)); memset(b, 0x5a, sizeof(b));
        old_side(f, a); new_side(f, b);
        mismatches += memcmp(a, b, sizeof(a)) != 0;
        sets += 1;
    }
    printf("compared %llu feature sets, mismatches=%llu\n", (unsigned long long)sets, (unsigned long long)mismatches);
    const uint64_t targets[] = { 0, UINT64_C(0x00000000007fffff), UINT64_C(0x1fffffffffffffff), UINT64_C(0x1fe5ffffffffffff) };
    const char* names[] = { "none", "low-23", "all", "most" };
    for (uint32_t t = 0; t < 4; t += 1)
    {
        double samples[2][PASSES];
        for (uint32_t pass = 0; pass < PASSES; pass += 1)
        {
            for (uint32_t order = 0; order < 2; order += 1)
            {
                const uint32_t side = order ^ (pass & 1);
                uint64_t total = 0;
                for (uint32_t r = 0; r < 256; r += 1)
                {
                    const uint64_t before = __rdtsc();
                    if (side == 0) old_side(targets[t], a); else new_side(targets[t], a);
                    total += __rdtsc() - before;
                    __asm__ volatile("" : : : "memory");
                }
                samples[side][pass] = (double)total / 256.0;
            }
        }
        qsort(samples[0], PASSES, sizeof(double), cmp);
        qsort(samples[1], PASSES, sizeof(double), cmp);
        printf("target=%s old_ticks=%.1f new_ticks=%.1f new/old=%.3f\n", names[t], samples[0][PASSES / 2], samples[1][PASSES / 2], samples[1][PASSES / 2] / samples[0][PASSES / 2]);
    }
    return mismatches != 0;
}
