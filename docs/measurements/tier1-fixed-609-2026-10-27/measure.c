// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #609 campaign. Build against the candidate source; link baseline.c built against the exact base.
// Whole allocations use the two unmodified production implementations. Fixed-only samples compare the retained
// original cross-product with the sweep, including mask copying, list construction and scratch allocation/reset.
// Event construction, validation and coloring remain in whole/no-fixed samples, outside fixed-only samples.
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <time.h>
#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"

Tier1AllocationError baseline_allocate(const Tier1AllocationInput* input, Arena* arena, Tier1Allocation* result);
Tier1AllocationError candidate_allocate(const Tier1AllocationInput* input, Arena* arena, Tier1Allocation* result);
static bool verification_only;

static uint64_t now(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC_RAW, &value);
    return (uint64_t)value.tv_sec * 1000000000 + (uint64_t)value.tv_nsec;
}

static bool same(const Tier1AllocationInput* input, const Tier1Allocation* a, const Tier1Allocation* b)
{
    bool equal = a->fragment_count == b->fragment_count && a->spill_count == b->spill_count && a->splits == b->splits && a->vector_intervals == b->vector_intervals && a->scalar_intervals == b->scalar_intervals;
    if (equal)
    {
        equal = memcmp(a->fragment_offsets, b->fragment_offsets, (input->count + 1) * 4) == 0 && memcmp(a->starts, b->starts, a->fragment_count * 4) == 0 && memcmp(a->ends, b->ends, a->fragment_count * 4) == 0;
        equal &= memcmp(a->kinds, b->kinds, a->fragment_count) == 0 && memcmp(a->registers, b->registers, a->fragment_count) == 0;
        equal &= memcmp(a->value_registers, b->value_registers, input->value_count) == 0 && memcmp(a->spill_ids, b->spill_ids, input->value_count * 4) == 0 && memcmp(a->spill_values, b->spill_values, a->spill_count * 4) == 0;
        equal &= memcmp(a->peak_pressure, b->peak_pressure, sizeof(a->peak_pressure)) == 0;
    }
    return equal;
}

static __attribute__((noinline, aligned(64))) bool batch(const Tier1AllocationInput* input, Arena* arena, const uint32_t* events, uint32_t* buckets, uint32_t* masks, bool old, bool fixed_only, uint32_t repetitions, uint64_t* checksum)
{
    bool valid = true;
    for (uint32_t repetition = 0; valid && repetition < repetitions; repetition += 1)
    {
        if (fixed_only)
        {
            memcpy(masks, input->allowed_registers, input->count * 4);
            if (old)
            {
                tier1_allocation_filter_fixed_simple(input, true, masks);
            }
            else
            {
                valid = tier1_allocation_filter_fixed(input, arena, true, events, input->count * 2, buckets, masks);
            }
            *checksum += masks[repetition % input->count];
        }
        else
        {
            Tier1Allocation output = { 0 };
            valid = (old ? baseline_allocate(input, arena, &output) : candidate_allocate(input, arena, &output)) == TIER1_ALLOCATION_OK;
            if (valid)
            {
                *checksum += output.fragment_count + output.spill_count + output.registers[output.fragment_count - 1];
            }
        }
        arena_pop_to(arena, 0);
    }
    return valid;
}

static void statistics(double* samples, double* median, double* minimum, double* maximum)
{
    for (uint32_t i = 1; i < 11; i += 1)
    {
        const double value = samples[i];
        uint32_t j = i;
        while (j != 0 && samples[j - 1] > value)
        {
            samples[j] = samples[j - 1];
            j -= 1;
        }
        samples[j] = value;
    }
    *minimum = samples[0];
    *median = samples[5];
    *maximum = samples[10];
}

static bool measure(uint32_t shape, uint32_t count, uint32_t fixed_count, uint32_t after_scalar, uint64_t* checksum)
{
    Arena input_arena = arena_reserve(16u << 20);
    Arena arena = arena_reserve(64u << 20);
    bool valid = input_arena.base != 0 && arena.base != 0;
    uint32_t* starts = arena_push_array(&input_arena, count, 4, 4);
    uint32_t* ends = arena_push_array(&input_arena, count, 4, 4);
    uint32_t* values = arena_push_array(&input_arena, count, 4, 4);
    uint32_t* allowed = arena_push_array(&input_arena, count, 4, 4);
    uint8_t* classes = arena_push_array(&input_arena, count, 1, 1);
    uint32_t* fixed_starts = arena_push_array(&input_arena, fixed_count, 4, 4);
    uint32_t* fixed_ends = arena_push_array(&input_arena, fixed_count, 4, 4);
    uint32_t* fixed_registers = arena_push_array(&input_arena, fixed_count, 4, 4);
    uint8_t* fixed_classes = arena_push_array(&input_arena, fixed_count, 1, 1);
    uint32_t* events = arena_push_array(&input_arena, count * 2, 4, 4);
    const uint32_t position_count = shape == 2 ? count * 4 + 64 : (count > fixed_count ? count : fixed_count) * 2;
    uint32_t* buckets = arena_push_array(&input_arena, position_count + 2, 4, 4);
    uint32_t* masks = arena_push_array(&input_arena, count, 4, 4);
    valid &= starts != 0 && ends != 0 && values != 0 && allowed != 0 && classes != 0 && fixed_starts != 0 && fixed_ends != 0 && fixed_registers != 0 && fixed_classes != 0 && events != 0 && buckets != 0 && masks != 0;
    for (uint32_t i = 0; valid && i < count; i += 1)
    {
        starts[i] = shape == 1 ? 0 : i * 2;
        ends[i] = shape == 1 ? count * 2 : starts[i] + (shape == 2 ? 32 : 1);
        values[i] = i;
        classes[i] = shape == 3 ? (uint8_t)(i & 1) : 0;
        allowed[i] = classes[i] == 0 ? (shape == 2 ? 0xffef : 3) : UINT32_MAX;
    }
    if (valid)
    {
        memset(buckets, 0, (position_count + 2) * 4);
        for (uint32_t i = 0; i < count; i += 1)
        {
            buckets[starts[i] + 1] += 1;
            buckets[ends[i] + 1] += 1;
        }
        for (uint32_t p = 1; p <= position_count + 1; p += 1)
        {
            buckets[p] += buckets[p - 1];
        }
        for (uint32_t i = 0; i < count; i += 1)
        {
            events[buckets[ends[i]]] = i * 2;
            buckets[ends[i]] += 1;
        }
        for (uint32_t i = 0; i < count; i += 1)
        {
            events[buckets[starts[i]]] = i * 2 + 1;
            buckets[starts[i]] += 1;
        }
    }
    for (uint32_t f = 0; valid && f < fixed_count; f += 1)
    {
        fixed_starts[f] = f * (shape == 2 ? 16 : 2) + 1;
        fixed_ends[f] = fixed_starts[f] + 1;
        fixed_classes[f] = shape == 3 ? (uint8_t)(f & 1) : 0;
        fixed_registers[f] = shape == 2 ? 0xfc7 : (fixed_classes[f] == 0 ? 1 : 0x80000000u);
        if (shape == 3 && (f & 2) != 0)
        {
            fixed_starts[f] -= 1;
            fixed_ends[f] -= 1;
        }
    }
    const Tier1AllocationInput input = {
        .starts = starts,
        .ends = ends,
        .values = values,
        .allowed_registers = allowed,
        .classes = classes,
        .count = count,
        .value_count = count,
        .position_count = position_count,
        .registers = { shape == 2 ? 0xffef : 3, UINT32_MAX },
        .fixed = {
            .starts = fixed_starts,
            .ends = fixed_ends,
            .registers = fixed_registers,
            .classes = fixed_classes,
            .count = fixed_count,
        },
    };
    Tier1Allocation baseline = { 0 };
    Tier1Allocation candidate = { 0 };
    valid = valid && baseline_allocate(&input, &arena, &baseline) == TIER1_ALLOCATION_OK && candidate_allocate(&input, &arena, &candidate) == TIER1_ALLOCATION_OK && same(&input, &baseline, &candidate);
    const uint64_t base_bytes = baseline.retained_bytes + baseline.scratch_bytes;
    const uint64_t head_bytes = candidate.retained_bytes + candidate.scratch_bytes;
    arena_pop_to(&arena, 0);
    if (valid)
    {
        memcpy(masks, allowed, count * 4);
        tier1_allocation_filter_fixed_simple(&input, false, masks);
        uint32_t* expected = arena_push_array(&input_arena, count, 4, 4);
        valid = expected != 0;
        if (valid)
        {
            memcpy(expected, masks, count * 4);
            memcpy(masks, allowed, count * 4);
            valid = tier1_allocation_filter_fixed(&input, &arena, true, events, count * 2, buckets, masks) && memcmp(expected, masks, count * 4) == 0;
            arena_pop_to(&arena, 0);
        }
    }
    for (uint32_t stage = 0; valid && !verification_only && stage < 2; stage += 1)
    {
        uint32_t repetitions[2] = { 1, 1 };
        for (uint32_t variant = 0; valid && variant < 2; variant += 1)
        {
            uint64_t elapsed = 0;
            while (valid && elapsed < 1000000 && repetitions[variant] < (1u << 20))
            {
                repetitions[variant] *= 2;
                const uint64_t begin = now();
                valid = batch(&input, &arena, events, buckets, masks, variant == 0, stage == 1, repetitions[variant], checksum);
                elapsed = now() - begin;
            }
        }
        double samples[2][11];
        for (uint32_t pass = 0; valid && pass < 11; pass += 1)
        {
            for (uint32_t order = 0; valid && order < 2; order += 1)
            {
                const uint32_t variant = (pass + order) & 1;
                if (after_scalar != 0)
                {
                    const uint64_t until = now() + (uint64_t)after_scalar * 1000000;
                    while (now() < until)
                    {
                        memcpy(masks, allowed, count * 4);
                        tier1_allocation_filter_fixed_simple(&input, false, masks);
                        *checksum += masks[0];
                    }
                }
                valid &= batch(&input, &arena, events, buckets, masks, variant == 0, stage == 1, 1, checksum);
                const uint64_t begin = now();
                valid &= batch(&input, &arena, events, buckets, masks, variant == 0, stage == 1, repetitions[variant], checksum);
                samples[variant][pass] = (double)(now() - begin) / repetitions[variant];
                fprintf(stderr, "sample,%u,%u,%u,%s,%s,%u,%u,%.3f,%u\n", shape, count, fixed_count, stage == 0 ? "whole" : "fixed", variant == 0 ? "base" : "head", pass, repetitions[variant], samples[variant][pass], after_scalar);
            }
        }
        for (uint32_t variant = 0; valid && variant < 2; variant += 1)
        {
            double median;
            double minimum;
            double maximum;
            statistics(samples[variant], &median, &minimum, &maximum);
            printf("%u,%u,%u,%s,%s,%u,%.3f,%.3f,%.3f,%" PRIu64 ",%" PRIu64 ",%u\n", shape, count, fixed_count, stage == 0 ? "whole" : "fixed", variant == 0 ? "base" : "head", repetitions[variant], median, minimum, maximum, base_bytes, head_bytes, after_scalar);
        }
    }
    arena_release(&input_arena);
    arena_release(&arena);
    return valid;
}

int main(int argc, char** argv)
{
    verification_only = argc == 2 && strcmp(argv[1], "--verify") == 0;
    const bool conditioned = argc == 2 && strcmp(argv[1], "--conditioned") == 0;
    bool valid = argc == 1 || argc == 5 || verification_only || conditioned;
    uint64_t checksum = 0;
    puts("shape,N,F,stage,variant,repetitions,median_ns,min_ns,max_ns,base_peak_bytes,head_peak_bytes,after_scalar_ms");
    if (argc == 5)
    {
        valid = measure((uint32_t)strtoul(argv[1], 0, 10), (uint32_t)strtoul(argv[2], 0, 10), (uint32_t)strtoul(argv[3], 0, 10), (uint32_t)strtoul(argv[4], 0, 10), &checksum);
    }
    else if (conditioned)
    {
        for (uint32_t shape = 0; valid && shape < 4; shape += 1)
        {
            valid = measure(shape, 8192, shape == 2 ? 1024 : 8192, 200, &checksum);
        }
    }
    else
    {
        for (uint32_t count = 256; valid && count <= 8192; count *= 2)
        {
            valid = measure(0, count, count, 0, &checksum) && measure(0, count, 0, 0, &checksum);
        }
        for (uint32_t shape = 1; valid && shape < 4; shape += 1)
        {
            valid = measure(shape, 256, shape == 2 ? 32 : 256, 0, &checksum) && measure(shape, 8192, shape == 2 ? 1024 : 8192, 0, &checksum);
        }
        const uint32_t tiny[] = { 1, 8, 16, 32 };
        const uint32_t fixed[] = { 0, 1, 4, 8, 16 };
        for (uint32_t n = 0; valid && n < 4; n += 1)
        {
            for (uint32_t f = 0; valid && f < 5; f += 1)
            {
                valid = measure(0, tiny[n], fixed[f], 0, &checksum);
            }
        }
    }
    fprintf(stderr, "valid=%u checksum=%" PRIu64 "\n", valid, checksum);
    return valid ? 0 : 1;
}
