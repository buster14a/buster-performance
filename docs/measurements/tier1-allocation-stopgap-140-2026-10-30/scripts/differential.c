// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Measurement harness for buster #140's stopgap (buster-performance record).
//
// Prints, for every case and both production entry points (tier1_allocate and tier1_allocate_scalar), the status
// and a hash of every public field of the Tier1Allocation, then retained_bytes and scratch_bytes. Built once against
// main's tier1_allocate.c and once against the change's, the two outputs must agree on every status, hash and
// retained size; scratch_bytes may differ only by shrinking. Cases: benchmark-tier1-allocation's four workloads,
// the review record's six, tier1_allocate_test.c's generated shapes (fixed ranges, hints, required uses,
// rematerialization) and larger random inputs with several uses per interval.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"

static uint64_t hash_bytes(uint64_t hash, const void* bytes, uint64_t count)
{
    const uint8_t* p = bytes;
    for (uint64_t i = 0; i < count; i += 1)
    {
        hash = (hash ^ p[i]) * UINT64_C(1099511628211);
    }
    return hash;
}

static uint64_t hash_allocation(const Tier1AllocationInput* input, const Tier1Allocation* a)
{
    uint64_t h = UINT64_C(14695981039346656037);
    h = hash_bytes(h, &a->fragment_count, 4);
    h = hash_bytes(h, &a->interval_count, 4);
    h = hash_bytes(h, a->fragment_offsets, ((uint64_t)a->interval_count + 1) * 4);
    h = hash_bytes(h, a->starts, (uint64_t)a->fragment_count * 4);
    h = hash_bytes(h, a->ends, (uint64_t)a->fragment_count * 4);
    h = hash_bytes(h, a->kinds, a->fragment_count);
    h = hash_bytes(h, a->registers, a->fragment_count);
    h = hash_bytes(h, a->value_registers, input->value_count);
    h = hash_bytes(h, a->spill_ids, (uint64_t)input->value_count * 4);
    h = hash_bytes(h, &a->spill_count, 4);
    h = hash_bytes(h, a->spill_values, (uint64_t)a->spill_count * 4);
    h = hash_bytes(h, &a->vector_intervals, 4);
    h = hash_bytes(h, &a->scalar_intervals, 4);
    h = hash_bytes(h, &a->splits, 4);
    h = hash_bytes(h, a->peak_pressure, sizeof(a->peak_pressure));
    return h;
}

static uint64_t random_state;
static uint32_t random_next(void)
{
    random_state = random_state * UINT64_C(6364136223846793005) + UINT64_C(1442695040888963407);
    return (uint32_t)(random_state >> 32);
}

typedef struct Case Case;
struct Case
{
    uint32_t starts[16384];
    uint32_t ends[16384];
    uint32_t values[16384];
    uint32_t allowed[16384];
    uint8_t classes[16384];
    uint8_t remat[16384];
    uint8_t hints[16384];
    uint8_t flags[16384];
    uint32_t use_offsets[16385];
    uint32_t use_positions[49152];
    uint8_t use_required[49152];
};

static Case scratch_case;

static void run(uint32_t number, const Tier1AllocationInput* input, Arena* arena)
{
    for (uint32_t path = 0; path < 2; path += 1)
    {
        Tier1Allocation output = { 0 };
        const uint64_t before = arena->length;
        const Tier1AllocationError error = path == 0 ? tier1_allocate(input, arena, &output) : tier1_allocate_scalar(input, arena, &output);
        const uint64_t hash = error == TIER1_ALLOCATION_OK ? hash_allocation(input, &output) : 0;
        printf("case %u %s: status %d hash %016" PRIx64 " retained %" PRIu64 " scratch %" PRIu64 " arena %" PRIu64 "\n", number, path == 0 ? "tier1_allocate" : "tier1_allocate_scalar", (int)error, hash, error == TIER1_ALLOCATION_OK ? output.retained_bytes : 0, error == TIER1_ALLOCATION_OK ? output.scratch_bytes : 0, arena->length - before);
        arena_pop_to(arena, before);
    }
}

int main(void)
{
    Arena arena = arena_reserve(256u << 20);
    Case* c = &scratch_case;
    uint32_t number = 0;
    // The benchmark's and the review record's interval workloads.
    const uint32_t shapes[] = { 0, 1, 2, 3, 4, 4, 5, 5, 6, 6 };
    const uint32_t counts[] = { 16, 128, 2048, 16384, 4096, 16384, 4096, 16384, 4096, 16384 };
    random_state = 1;
    for (uint32_t w = 0; w < 10; w += 1)
    {
        const uint32_t count = counts[w];
        uint32_t positions = 0;
        for (uint32_t i = 0; i < count; i += 1)
        {
            uint32_t start = i * 2;
            uint32_t end = start + (shapes[w] == 3 ? 96 + i % 32 : 8 + i % 8);
            uint8_t class = (uint8_t)(i & 1);
            if (shapes[w] == 4 || shapes[w] == 5)
            {
                const uint32_t percent = random_next() % 100;
                const uint32_t length = percent < (shapes[w] == 4 ? 5u : 15u) ? 10 + random_next() % 190 : 1 + random_next() % 3;
                start = i * 2 + 1;
                end = (i + length) * 2;
                class = (uint8_t)(i % 4 == 0 ? 1 : 0);
            }
            else if (shapes[w] == 6)
            {
                start = i * 2 + 1;
                end = i * 2 + 2;
                class = 0;
            }
            c->starts[i] = start;
            c->ends[i] = end;
            c->values[i] = i;
            c->allowed[i] = 0xffef;
            c->use_positions[i] = end - 1;
            c->use_offsets[i] = i;
            c->classes[i] = class;
            c->remat[i] = i % 4 == 0 ? 1 : 0;
            positions = end > positions ? end : positions;
        }
        c->use_offsets[count] = count;
        const Tier1AllocationInput input = {
            .starts = c->starts, .ends = c->ends, .values = c->values, .allowed_registers = c->allowed,
            .classes = c->classes, .rematerializable = c->remat, .use_offsets = c->use_offsets,
            .use_positions = c->use_positions, .use_count = count, .count = count, .value_count = count,
            .position_count = positions + 2, .registers = { 0xffef, 0xffef },
        };
        run(number, &input, &arena);
        number += 1;
    }
    // tier1_allocate_test.c's generated shapes: constrained (fixed ranges, narrowed masks), sparse reuse chains and
    // random intervals, hints, rematerialization, and required uses on every fifth.
    const uint32_t fixed_start[] = { 23, 70, 90, 24, 0, 90, 128 };
    const uint32_t fixed_end[] = { 25, 71, 96, 26, 2, 97, 129 };
    const uint32_t fixed_regs[] = { 0x3, 0xf, 0x80000000u, 0x2, 0, 0x80000001u, 0x1 };
    const uint8_t fixed_classes[] = { 0, 0, 1, 0, 1, 1, 0 };
    random_state = 140;
    for (uint32_t iteration = 0; iteration < 3000; iteration += 1)
    {
        const uint32_t count = iteration < 96 ? iteration : random_next() % 96;
        const bool constrained = (iteration % 3) == 0;
        const bool sparse = (iteration % 3) == 1;
        const uint32_t gpr_mask = sparse ? 0xaaaa : (1u << (1 + iteration % 8)) - 1;
        for (uint32_t i = 0; i < count; i += 1)
        {
            c->starts[i] = sparse ? i * 2 : random_next() % 96;
            c->ends[i] = sparse ? c->starts[i] + 2 : c->starts[i] + 1 + random_next() % 64;
            c->values[i] = i;
            c->classes[i] = (uint8_t)(random_next() & 1);
            c->allowed[i] = c->classes[i] == 0 ? gpr_mask : UINT32_MAX;
            if (constrained && (i & 3) == 0)
            {
                c->allowed[i] &= random_next();
            }
            c->remat[i] = (uint8_t)(i & 1);
            c->hints[i] = c->allowed[i] != 0 ? (uint8_t)__builtin_ctz(c->allowed[i]) : UINT8_MAX;
            c->use_offsets[i] = i;
            c->use_positions[i] = c->ends[i] - 1;
            c->use_required[i] = (uint8_t)(i & 1);
        }
        c->use_offsets[count] = count;
        const Tier1AllocationInput input = {
            .starts = c->starts, .ends = c->ends, .values = c->values, .allowed_registers = c->allowed,
            .classes = c->classes, .hints = c->hints, .rematerializable = c->remat, .use_offsets = c->use_offsets,
            .use_positions = c->use_positions, .use_required = iteration % 5 == 0 ? c->use_required : 0,
            .use_count = count, .count = count, .value_count = count, .position_count = 192,
            .registers = { gpr_mask, UINT32_MAX },
            .fixed = { .starts = fixed_start, .ends = fixed_end, .registers = fixed_regs, .classes = fixed_classes, .count = constrained ? 7 : 0 },
        };
        run(number, &input, &arena);
        number += 1;
    }
    // Larger random inputs: up to 16,384 intervals, several sorted uses each (some required), REQUIRED flags,
    // holes as separate intervals of one value, both classes, narrowed masks and random fixed ranges.
    static uint32_t fixed_starts[64];
    static uint32_t fixed_ends[64];
    static uint32_t fixed_registers[64];
    static uint8_t fixed_class[64];
    for (uint32_t iteration = 0; iteration < 200; iteration += 1)
    {
        const uint32_t count = 1 + random_next() % 16384;
        const uint32_t positions = count * 2 + 64;
        uint32_t uses = 0;
        uint32_t value = 0;
        for (uint32_t i = 0; i < count; i += 1)
        {
            // Every fourth interval continues the previous one's value after a hole (same class).
            const bool continues = i != 0 && (random_next() & 3) == 0 && c->ends[i - 1] + 2 < positions;
            uint32_t start = continues ? c->ends[i - 1] + 1 + random_next() % 3 : random_next() % (positions - 2);
            if (start >= positions - 1)
            {
                start = positions - 2;
            }
            uint32_t length = (random_next() % 10 == 0) ? 1 + random_next() % 200 : 1 + random_next() % 6;
            uint32_t end = start + length < positions ? start + length : positions;
            c->starts[i] = start;
            c->ends[i] = end;
            c->values[i] = continues ? c->values[i - 1] : value;
            value += continues ? 0 : 1;
            c->classes[i] = continues ? c->classes[i - 1] : (uint8_t)(random_next() % 3 == 0);
            const uint32_t mask = c->classes[i] == 0 ? 0xffef : UINT32_MAX;
            c->allowed[i] = (random_next() % 8 == 0) ? (mask & (random_next() | 1u << (random_next() % 4))) : mask;
            if (c->allowed[i] == 0)
            {
                c->allowed[i] = mask & 1u;
            }
            c->remat[i] = (uint8_t)(random_next() % 4 == 0);
            c->hints[i] = (random_next() % 3 == 0 && c->allowed[i] != 0) ? (uint8_t)(31 - __builtin_clz(c->allowed[i])) : UINT8_MAX;
            c->flags[i] = 0;
            c->use_offsets[i] = uses;
            const uint32_t count_uses = random_next() % 4;
            uint32_t position = start;
            for (uint32_t u = 0; u < count_uses && uses < 49152; u += 1)
            {
                position += random_next() % 3;
                if (position < end)
                {
                    c->use_positions[uses] = position;
                    c->use_required[uses] = (uint8_t)(random_next() % 3 == 0);
                    uses += 1;
                }
            }
        }
        c->use_offsets[count] = uses;
        // Distinct intervals of one value must not overlap: the allocator's validation would refuse them. Keep the
        // continuation only when it starts at or after the previous end, as constructed above.
        const uint32_t fixed_count = random_next() % 4 == 0 ? random_next() % 64 : 0;
        for (uint32_t f = 0; f < fixed_count; f += 1)
        {
            fixed_starts[f] = random_next() % (positions - 1);
            fixed_ends[f] = fixed_starts[f] + 1 + random_next() % 4;
            fixed_ends[f] = fixed_ends[f] <= positions ? fixed_ends[f] : positions;
            fixed_class[f] = (uint8_t)(random_next() & 1);
            fixed_registers[f] = 1u << (random_next() % (fixed_class[f] == 0 ? 16 : 32));
            fixed_registers[f] &= fixed_class[f] == 0 ? 0xffefu : UINT32_MAX;
        }
        const bool use_required = (iteration & 1) != 0;
        const Tier1AllocationInput input = {
            .starts = c->starts, .ends = c->ends, .values = c->values, .allowed_registers = c->allowed,
            .classes = c->classes, .flags = c->flags, .hints = c->hints, .rematerializable = c->remat,
            .use_offsets = c->use_offsets, .use_positions = c->use_positions,
            .use_required = use_required ? c->use_required : 0, .use_count = uses, .count = count, .value_count = value,
            .position_count = positions, .registers = { 0xffef, UINT32_MAX },
            .fixed = { .starts = fixed_starts, .ends = fixed_ends, .registers = fixed_registers, .classes = fixed_class, .count = fixed_count },
        };
        run(number, &input, &arena);
        number += 1;
    }
    printf("cases %u\n", number);
    arena_release(&arena);
    return 0;
}
