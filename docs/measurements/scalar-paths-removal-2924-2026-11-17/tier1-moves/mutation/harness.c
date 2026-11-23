#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"
typedef struct Tier1AllocationTestTally Tier1AllocationTestTally;
struct Tier1AllocationTestTally
{
    uint64_t checks;
    uint64_t failures;
};

static void tier1_allocation_test_expect(Tier1AllocationTestTally* tally, bool condition, const char* name)
{
    tally->checks += 1;
    if (!condition)
    {
        if (tally->failures < 20)
        {
            fprintf(stderr, "test-tier1-allocation: %s\n", name);
        }
        tally->failures += 1;
    }
}

static uint32_t tier1_allocation_test_random(uint64_t* state)
{
    *state = *state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
    return (uint32_t)(*state >> 32);
}

// The occupancy oracle expands every fragment to individual positions; it shares neither event sorting nor
// interval-overlap tests with the allocator. All generated inputs below fit this deliberately small domain.
static bool tier1_allocation_test_occupancy(const Tier1AllocationInput* input, const Tier1Allocation* output)
{
    uint32_t owners[BUSTER_TIER1_ALLOCATE_CLASSES][32][256];
    memset(owners, 0xff, sizeof(owners));
    bool valid = true;
    for (uint32_t i = 0; valid && i < input->count; i += 1)
    {
        for (uint32_t p = input->starts[i]; valid && p < input->ends[i]; p += 1)
        {
            Tier1AllocationLocation location = { 0 };
            valid = p < 256 && tier1_allocation_location(input, output, i, p, &location);
            if (valid && location.kind == BUSTER_TIER1_ALLOCATE_REGISTER)
            {
                valid = location.reg < 32 && owners[input->classes[i]][location.reg][p] == UINT32_MAX;
                if (valid)
                {
                    owners[input->classes[i]][location.reg][p] = i;
                }
            }
        }
    }
    for (uint32_t f = 0; valid && f < input->fixed.count; f += 1)
    {
        for (uint32_t r = 0; valid && r < 32; r += 1)
        {
            if (((input->fixed.registers[f] >> r) & 1) != 0)
            {
                for (uint32_t p = input->fixed.starts[f]; valid && p < input->fixed.ends[f]; p += 1)
                {
                    valid = p < 256 && owners[input->fixed.classes[f]][r][p] == UINT32_MAX;
                }
            }
        }
    }
    return valid;
}

static bool tier1_allocation_test_equal(const Tier1AllocationInput* input, const Tier1Allocation* a, const Tier1Allocation* b)
{
    bool same = a->fragment_count == b->fragment_count && a->interval_count == b->interval_count && a->spill_count == b->spill_count && a->splits == b->splits &&
                a->vector_intervals == b->vector_intervals && a->scalar_intervals == b->scalar_intervals && memcmp(a->peak_pressure, b->peak_pressure, sizeof(a->peak_pressure)) == 0;
    if (same)
    {
        same = memcmp(a->fragment_offsets, b->fragment_offsets, ((uint64_t)input->count + 1) * 4) == 0 && memcmp(a->starts, b->starts, (uint64_t)a->fragment_count * 4) == 0 && memcmp(a->ends, b->ends, (uint64_t)a->fragment_count * 4) == 0;
        same = same && memcmp(a->kinds, b->kinds, a->fragment_count) == 0 && memcmp(a->registers, b->registers, a->fragment_count) == 0 && memcmp(a->value_registers, b->value_registers, input->value_count) == 0;
        same = same && memcmp(a->spill_ids, b->spill_ids, (uint64_t)input->value_count * 4) == 0 && memcmp(a->spill_values, b->spill_values, (uint64_t)a->spill_count * 4) == 0;
    }
    return same;
}

// tier1_allocation_color's LIFO level rule written independently: positions in order, each position's ends and then
// its starts in input order, without the event sort or the class's event column. An end at height h + 1 deposits
// its register at level h; a start at height h takes level h's register, or a fresh one. False when the class's
// pressure exceeds its registers, which sends it to the scan instead.
static bool tier1_allocation_test_levels(const Tier1AllocationInput* input, uint32_t class, uint8_t* regs)
{
    uint8_t levels[33];
    memset(levels, UINT8_MAX, sizeof(levels));
    uint32_t fresh = input->registers[class];
    const uint32_t capacity = (uint32_t)__builtin_popcount(fresh);
    uint32_t height = 0;
    bool fits = true;
    for (uint32_t p = 0; fits && p <= input->position_count; p += 1)
    {
        for (uint32_t i = 0; i < input->count; i += 1)
        {
            if (input->classes[i] == class && input->ends[i] == p)
            {
                height -= 1;
                levels[height] = regs[i];
            }
        }
        for (uint32_t i = 0; fits && i < input->count; i += 1)
        {
            if (input->classes[i] == class && input->starts[i] == p)
            {
                fits = height < capacity;
                if (fits)
                {
                    uint8_t r = levels[height];
                    levels[height] = UINT8_MAX;
                    if (r == UINT8_MAX)
                    {
                        r = (uint8_t)__builtin_ctz(fresh);
                        fresh &= fresh - 1;
                    }
                    regs[i] = r;
                    height += 1;
                }
            }
        }
    }
    return fits;
}

// A class's every register: 16 general ones, 32 vector ones, 8 opmask ones.
static uint32_t tier1_allocation_test_class_registers(uint32_t class)
{
    return class == BUSTER_TIER1_ALLOCATE_GPR ? 0xffffu : class == BUSTER_TIER1_ALLOCATE_VECTOR ? UINT32_MAX : BUSTER_TIER1_ALLOCATE_MASK_REGISTERS;
}

// tier1_moves_test.c, included below.
static bool tier1_move_test_defined(const Tier1ParallelMoves* input, const Tier1ResolvedMoves* output);

static void tier1_allocation_test_moves(Tier1AllocationTestTally* tally, Arena* arena, uint64_t seed)
{
    uint32_t sources[32];
    uint32_t destinations[32];
    for (uint32_t iteration = 0; iteration < 256; iteration += 1)
    {
        const uint64_t saved = arena->length;
        const uint32_t count = iteration % 33;
        uint64_t original[33];
        uint64_t actual[33];
        for (uint32_t i = 0; i < 33; i += 1)
        {
            original[i] = UINT64_C(0x0123456789abcdef) * (i + 1);
            actual[i] = original[i];
        }
        for (uint32_t i = 0; i < count; i += 1)
        {
            destinations[i] = i;
            sources[i] = iteration % 2 == 0 ? (i + 1) % count : tier1_allocation_test_random(&seed) % 32;
        }
        for (uint32_t i = count; i > 1; i -= 1)
        {
            const uint32_t other = tier1_allocation_test_random(&seed) % i;
            const uint32_t swap = destinations[i - 1];
            destinations[i - 1] = destinations[other];
            destinations[other] = swap;
        }
        const Tier1ParallelMoves input = {
            .sources = sources,
            .destinations = destinations,
            .count = count,
            .scratch = 32,
        };
        Tier1ResolvedMoves output = { 0 };
        bool valid = tier1_resolve_moves(&input, arena, &output) == TIER1_ALLOCATION_OK && output.count <= count * 2;
        valid = valid && tier1_move_test_defined(&input, &output);
        for (uint32_t i = 0; valid && i < output.count; i += 1)
        {
            valid = output.sources[i] < 33 && output.destinations[i] < 33;
            if (valid)
            {
                actual[output.destinations[i]] = actual[output.sources[i]];
            }
        }
        for (uint32_t i = 0; valid && i < count; i += 1)
        {
            valid = actual[destinations[i]] == original[sources[i]];
        }
        tier1_allocation_test_expect(tally, valid, "parallel move snapshot semantics");
        arena_pop_to(arena, saved);
    }
    sources[0] = 0;
    sources[1] = 1;
    destinations[0] = destinations[1] = 2;
    const Tier1ParallelMoves broken = {
        .sources = sources,
        .destinations = destinations,
        .count = 2,
        .scratch = 32,
    };
    Tier1ResolvedMoves output = { 0 };
    tier1_allocation_test_expect(tally, tier1_resolve_moves(&broken, arena, &output) == TIER1_ALLOCATION_INVALID, "duplicate move destinations rejected");
    // A move from or to the scratch register is refused, in each lane of the indexed resolver's steps and of the small
    // set's: 6 and 24 moves among registers 0 to 23, the scratch (30) put in each one's source and then its destination.
    for (uint32_t i = 0; i < 24; i += 1)
    {
        sources[i] = (i + 1) % 24;
        destinations[i] = i;
    }
    const uint32_t sizes[] = { 6, 24 };
    bool resolved = true;
    bool refused = true;
    for (uint32_t s = 0; s < 2; s += 1)
    {
        const Tier1ParallelMoves moves = {
            .sources = sources,
            .destinations = destinations,
            .count = sizes[s],
            .scratch = 30,
        };
        const uint64_t saved = arena->length;
        resolved = resolved && tier1_resolve_moves(&moves, arena, &output) == TIER1_ALLOCATION_OK;
        arena_pop_to(arena, saved);
        for (uint32_t k = 0; k < sizes[s]; k += 1)
        {
            for (uint32_t side = 0; side < 2; side += 1)
            {
                uint32_t* edited = side == 0 ? sources : destinations;
                const uint32_t kept = edited[k];
                edited[k] = 30;
                refused = refused && tier1_resolve_moves(&moves, arena, &output) == TIER1_ALLOCATION_INVALID && arena->length == saved;
                edited[k] = kept;
            }
        }
    }
    tier1_allocation_test_expect(tally, resolved, "moves away from the scratch register resolve");
    tier1_allocation_test_expect(tally, refused, "a move from or to the scratch register is refused in each lane");
}

#include "buster/compiler/tier1_moves_test.c"
int main(void)
{
    Tier1AllocationTestTally tally = { 0 };
    Arena arena = arena_reserve(256u << 20);
    tier1_allocation_test_moves(&tally, &arena, 140);
    tier1_allocation_test_move_scaling(&tally);
    printf("moves: %llu checks, %llu failures\n", (unsigned long long)tally.checks, (unsigned long long)tally.failures);
    return tally.failures != 0;
}
