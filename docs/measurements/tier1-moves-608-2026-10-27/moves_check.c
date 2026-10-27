// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original #608 semantic and sanitizer qualification harness.
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"
typedef struct Tier1AllocationTestTally Tier1AllocationTestTally;
struct Tier1AllocationTestTally
{
    uint64_t checks;
    uint64_t failures;
};
static void tier1_allocation_test_expect(Tier1AllocationTestTally* tally, bool valid, const char* name)
{
    tally->checks += 1;
    tally->failures += !valid;
    if (!valid)
    {
        fprintf(stderr, "failed: %s\n", name);
    }
}
#include "buster/compiler/tier1_moves_test.c"
int main(void)
{
    Tier1AllocationTestTally tally = { 0 };
    tier1_allocation_test_move_scaling(&tally);
    Arena arena = arena_reserve(1u << 20);
    uint64_t random = 608;
    for (uint32_t round = 0; round < 20000; round += 1)
    {
        const uint32_t count = round % 129;
        uint32_t sources[128];
        uint32_t destinations[128];
        for (uint32_t i = 0; i < count; i += 1)
        {
            random = random * UINT64_C(6364136223846793005) + 1;
            sources[i] = (uint32_t)(random >> 32) % 256;
            destinations[i] = i;
        }
        for (uint32_t i = count; i > 1; i -= 1)
        {
            random = random * UINT64_C(6364136223846793005) + 1;
            const uint32_t j = (uint32_t)(random >> 32) % i;
            const uint32_t swap = destinations[i - 1];
            destinations[i - 1] = destinations[j];
            destinations[j] = swap;
        }
        const Tier1ParallelMoves input = {
            .sources = sources,
            .destinations = destinations,
            .count = count,
            .scratch = 256,
        };
        Tier1ResolvedMoves a = { 0 };
        Tier1ResolvedMoves b = { 0 };
        bool valid = tier1_resolve_moves(&input, &arena, &a) == TIER1_ALLOCATION_OK && tier1_resolve_moves_scalar(&input, &arena, &b) == TIER1_ALLOCATION_OK;
        valid = valid && a.count == b.count && memcmp(a.sources, b.sources, a.count * 4) == 0 && memcmp(a.destinations, b.destinations, a.count * 4) == 0;
        tier1_allocation_test_expect(&tally, valid, "random exact oracle");
        arena_pop_to(&arena, 0);
    }
    arena_release(&arena);
    printf("moves-check: %" PRIu64 " checks, %" PRIu64 " failures\n", tally.checks, tally.failures);
    return tally.failures != 0;
}
