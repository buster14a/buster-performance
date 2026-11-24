// Gate for #3451's branch sizing worklist: main's size_branches (old: the worklist's scalar span sums and growth scan)
// against the branch's (new: both 16 or 64 lanes at a time), one executable. Chains of 5 to 4,000 links forward and
// backward (branch_sizing_chain, main's generator: a round per link, then the worklist), each checked for identical
// records, offsets, length, rounds, long branches and evaluations, then rdtsc ticks a call, 21 passes alternating which
// side goes first, the medians.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>
bool old_side_initialize(void);
bool new_side_initialize(void);
uint64_t old_side_chain(uint64_t*, uint64_t, bool, void*, uint32_t*, uint32_t*);
uint64_t old_side_size(void*, uint64_t, const uint32_t*, const uint32_t*, uint64_t, uint32_t*, uint64_t*);
uint64_t new_side_size(void*, uint64_t, const uint32_t*, const uint32_t*, uint64_t, uint32_t*, uint64_t*);
#define PASSES 21
#define CAP (1u << 20)
static int cmp(const void* a, const void* b) { double x = *(const double*)a, y = *(const double*)b; return x < y ? -1 : x > y; }
int main(void)
{
    if (!old_side_initialize() || !new_side_initialize()) return 2;
    uint8_t* pristine = malloc(CAP * 16ull); uint8_t* a = malloc(CAP * 16ull); uint8_t* b = malloc(CAP * 16ull);
    uint32_t* branches = malloc(CAP * 4ull); uint32_t* targets = malloc(CAP * 4ull);
    uint32_t* oa = malloc(CAP * 4ull); uint32_t* ob = malloc(CAP * 4ull);
    const uint64_t links[] = { 5, 6, 8, 12, 16, 24, 32, 48, 64, 100, 128, 256, 512, 1000, 2000, 4000 };
    uint64_t mismatches = 0;
    for (uint32_t direction = 0; direction < 2; direction += 1)
    {
        for (uint32_t l = 0; l < sizeof(links) / sizeof(links[0]); l += 1)
        {
            uint64_t state = 3451 + l;
            const uint64_t count = old_side_chain(&state, links[l], direction != 0, pristine, branches, targets);
            // A chain has a branch a link.
            const uint64_t branch_count = links[l];
            uint64_t ra[4], rb[4];
            memcpy(a, pristine, count * 16); memcpy(b, pristine, count * 16);
            const uint64_t la = old_side_size(a, count, branches, targets, branch_count, oa, ra);
            const uint64_t lb = new_side_size(b, count, branches, targets, branch_count, ob, rb);
            const bool same = la == lb && memcmp(ra, rb, sizeof(ra)) == 0 && memcmp(a, b, count * 16) == 0 && memcmp(oa, ob, count * 4) == 0;
            mismatches += !same;
            double samples[2][PASSES];
            const uint32_t repeat = links[l] < 100 ? 64 : links[l] < 1000 ? 8 : 2;
            for (uint32_t pass = 0; pass < PASSES; pass += 1)
            {
                for (uint32_t order = 0; order < 2; order += 1)
                {
                    const uint32_t side = order ^ (pass & 1);
                    uint64_t total = 0;
                    for (uint32_t r = 0; r < repeat; r += 1)
                    {
                        memcpy(a, pristine, count * 16);
                        const uint64_t before = __rdtsc();
                        if (side == 0) old_side_size(a, count, branches, targets, branch_count, oa, ra);
                        else new_side_size(a, count, branches, targets, branch_count, oa, ra);
                        total += __rdtsc() - before;
                    }
                    samples[side][pass] = (double)total / repeat;
                }
            }
            qsort(samples[0], PASSES, sizeof(double), cmp); qsort(samples[1], PASSES, sizeof(double), cmp);
            printf("%s links=%llu records=%llu branches=%llu rounds=%llu evaluations=%llu same=%d old_ticks=%.0f new_ticks=%.0f new/old=%.3f\n", direction ? "backward" : "forward",
                   (unsigned long long)links[l], (unsigned long long)count, (unsigned long long)branch_count, (unsigned long long)rb[0], (unsigned long long)rb[2], same,
                   samples[0][PASSES / 2], samples[1][PASSES / 2], samples[1][PASSES / 2] / samples[0][PASSES / 2]);
            fflush(stdout);
        }
    }
    printf("mismatches=%llu\n", (unsigned long long)mismatches);
    return mismatches != 0;
}
