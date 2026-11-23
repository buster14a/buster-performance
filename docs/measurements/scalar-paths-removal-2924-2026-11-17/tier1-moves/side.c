// One resolver, from the tree on the include path, behind an exported wrapper named by SIDE.
#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"
static Arena side_arena;
uint32_t SIDE(const uint32_t* sources, const uint32_t* destinations, uint32_t count, uint32_t scratch, uint32_t** out_sources, uint32_t** out_destinations)
{
    if (side_arena.base == 0)
    {
        side_arena = arena_reserve(1u << 30);
    }
    arena_pop_to(&side_arena, 0);
    const Tier1ParallelMoves input = { .sources = sources, .destinations = destinations, .count = count, .scratch = scratch };
    Tier1ResolvedMoves output = { 0 };
    const Tier1AllocationError error = tier1_resolve_moves(&input, &side_arena, &output);
    *out_sources = output.sources;
    *out_destinations = output.destinations;
    return error == TIER1_ALLOCATION_OK ? output.count : UINT32_MAX;
}
