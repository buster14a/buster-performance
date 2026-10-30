// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Measurement harness for buster #140's review (buster-performance record).
// Scratch harness for the #140 review: the current tier1_allocate paths against two minimal fixes, same inputs,
// same outputs (checked byte for byte). Variant bit 0: registers resolved in the matching loop (no prefix sum, no
// pointer jumping). Variant bit 1: the scalar scan expires intervals at their end events instead of scanning 32 slots.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <time.h>
#include <unistd.h>
#include <linux/perf_event.h>
#include <sys/syscall.h>

#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"

static void proto_color(const Tier1AllocationInput* input, uint32_t class, const uint32_t* events, uint32_t event_count, uint8_t* regs)
{
    uint8_t ended[33];
    memset(ended, 0xff, sizeof(ended));
    uint32_t available = input->registers[class];
    uint32_t live = 0;
    for (uint32_t e = 0; e < event_count; e += 1)
    {
        const uint32_t interval = events[e] >> 1;
        if ((events[e] & 1) == 0)
        {
            live -= 1;
            ended[live] = regs[interval];
        }
        else
        {
            uint8_t r = ended[live];
            if (r != 0xff)
            {
                ended[live] = 0xff;
            }
            else
            {
                r = (uint8_t)__builtin_ctz(available);
                available &= available - 1;
            }
            regs[interval] = r;
            live += 1;
        }
    }
}

static bool proto_scan(const Tier1AllocationInput* input, uint32_t class, const uint32_t* events, uint32_t event_count, const uint32_t* allowed, uint8_t* regs, uint32_t* split, uint8_t* kinds)
{
    uint32_t active[32];
    for (uint32_t r = 0; r < 32; r += 1)
    {
        active[r] = UINT32_MAX;
    }
    uint32_t occupied = 0;
    bool valid = true;
    for (uint32_t e = 0; valid && e < event_count; e += 1)
    {
        const uint32_t event = events[e];
        const uint32_t interval = event >> 1;
        if ((event & BUSTER_TIER1_ALLOCATE_USE_EVENT) == 0 && input->classes[interval] == class)
        {
            if ((event & 1) == 0)
            {
                const uint32_t r = regs[interval];
                if (r < 32 && active[r] == interval)
                {
                    active[r] = UINT32_MAX;
                    occupied &= ~(1u << r);
                }
            }
            else
            {
                const uint32_t position = input->starts[interval];
                const uint32_t free = ~occupied & allowed[interval];
                uint32_t chosen = UINT32_MAX;
                if (free != 0)
                {
                    chosen = (uint32_t)__builtin_ctz(free);
                    if (input->hints != 0 && input->hints[interval] != UINT8_MAX && ((free >> input->hints[interval]) & 1) != 0)
                    {
                        chosen = input->hints[interval];
                    }
                }
                else
                {
                    const bool required = input->flags != 0 && (input->flags[interval] & BUSTER_TIER1_ALLOCATE_REQUIRED) != 0;
                    uint32_t farthest = tier1_allocation_next_use(input, interval, position);
                    for (uint32_t r = 0; r < 32; r += 1)
                    {
                        const uint32_t other = active[r];
                        if (((allowed[interval] >> r) & 1) != 0 && other != UINT32_MAX && (input->flags == 0 || (input->flags[other] & BUSTER_TIER1_ALLOCATE_REQUIRED) == 0))
                        {
                            const uint32_t next = tier1_allocation_next_use(input, other, position);
                            if ((required && chosen == UINT32_MAX) || next > farthest)
                            {
                                chosen = r;
                                farthest = next;
                            }
                        }
                    }
                    if (chosen != UINT32_MAX)
                    {
                        const uint32_t victim = active[chosen];
                        split[victim] = position;
                        kinds[victim] = tier1_allocation_spill_kind(input, victim);
                    }
                    else if (required)
                    {
                        valid = false;
                    }
                }
                if (chosen != UINT32_MAX)
                {
                    regs[interval] = (uint8_t)chosen;
                    active[chosen] = interval;
                    occupied |= 1u << chosen;
                }
                else
                {
                    split[interval] = position;
                    kinds[interval] = tier1_allocation_spill_kind(input, interval);
                }
            }
        }
    }
    return valid;
}

#include "proto_impl.c"

#define SAMPLES 11

static uint64_t now_ns(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * 1000000000u + (uint64_t)time.tv_nsec;
}

static int cycles_open(void)
{
    struct perf_event_attr attributes = {
        .type = PERF_TYPE_HARDWARE,
        .size = sizeof(struct perf_event_attr),
        .config = PERF_COUNT_HW_CPU_CYCLES,
        .exclude_kernel = 1,
        .exclude_hv = 1,
    };
    return (int)syscall(SYS_perf_event_open, &attributes, 0, -1, -1, PERF_FLAG_FD_CLOEXEC);
}

static uint64_t cycles_read(int descriptor)
{
    uint64_t cycles = 0;
    if (descriptor < 0 || read(descriptor, &cycles, sizeof(cycles)) != sizeof(cycles))
    {
        cycles = 0;
    }
    return cycles;
}

static double median(double* samples)
{
    for (uint32_t i = 1; i < SAMPLES; i += 1)
    {
        for (uint32_t j = i; j > 0 && samples[j - 1] > samples[j]; j -= 1)
        {
            const double swap = samples[j];
            samples[j] = samples[j - 1];
            samples[j - 1] = swap;
        }
    }
    return samples[SAMPLES / 2];
}

typedef struct Config Config;
struct Config
{
    const char* name;
    bool vector;
    uint32_t variant;
};

static const Config configs[] = {
    { "vector-current", true, 0 },
    { "vector-resolved", true, 1 },
    { "vector-both-fixes", true, 3 },
    { "scalar-current", false, 0 },
    { "scalar-end-events", false, 2 },
};
#define CONFIGS (sizeof(configs) / sizeof(configs[0]))

static __attribute__((noinline)) bool batch(const Tier1AllocationInput* input, Arena* arena, const Config* config, uint32_t repetitions, uint64_t* checksum)
{
    bool valid = true;
    const uint64_t saved = arena->length;
    for (uint32_t repetition = 0; valid && repetition < repetitions; repetition += 1)
    {
        Tier1Allocation output = { 0 };
        valid = proto_allocate_impl(input, arena, config->vector, config->variant, &output) == TIER1_ALLOCATION_OK;
        if (valid)
        {
            *checksum += output.fragment_count + output.spill_count + output.registers[input->count - 1];
        }
        arena_pop_to(arena, saved);
    }
    return valid;
}

static bool same_output(const Tier1Allocation* a, const Tier1Allocation* b)
{
    bool same = a->fragment_count == b->fragment_count && a->spill_count == b->spill_count && a->interval_count == b->interval_count;
    same = same && memcmp(a->fragment_offsets, b->fragment_offsets, ((uint64_t)a->interval_count + 1) * 4) == 0;
    same = same && memcmp(a->starts, b->starts, (uint64_t)a->fragment_count * 4) == 0 && memcmp(a->ends, b->ends, (uint64_t)a->fragment_count * 4) == 0;
    same = same && memcmp(a->kinds, b->kinds, a->fragment_count) == 0 && memcmp(a->registers, b->registers, a->fragment_count) == 0;
    return same;
}

static uint64_t random_state = 0x9e3779b97f4a7c15u;
static uint32_t random_next(void)
{
    random_state ^= random_state << 13;
    random_state ^= random_state >> 7;
    random_state ^= random_state << 17;
    return (uint32_t)(random_state >> 11);
}

// Workload shapes. 0..3 are benchmark-tier1-allocation's. 4: mostly 1-3-instruction temporaries with 5% long values
// (pressure fits). 5: the same with 15% long values (overfull). 6: one reuse chain ([2i+1, 2i+2) per value).
static uint32_t generate(uint32_t shape, uint32_t count, uint32_t* starts, uint32_t* ends, uint32_t* values, uint32_t* allowed, uint32_t* uses, uint32_t* offsets, uint8_t* classes, uint8_t* remat)
{
    uint32_t positions = 0;
    for (uint32_t i = 0; i < count; i += 1)
    {
        uint32_t start = 0;
        uint32_t end = 0;
        uint8_t class = (uint8_t)(i & 1);
        if (shape <= 3)
        {
            start = i * 2;
            end = start + (shape == 3 ? 96 + i % 32 : 8 + i % 8);
        }
        else if (shape == 4 || shape == 5)
        {
            const uint32_t percent = random_next() % 100;
            const uint32_t long_share = shape == 4 ? 5 : 15;
            const uint32_t length = percent < long_share ? 10 + random_next() % 190 : 1 + random_next() % 3;
            start = i * 2 + 1;
            end = (i + length) * 2;
            class = (uint8_t)(i % 4 == 0 ? 1 : 0);
        }
        else
        {
            start = i * 2 + 1;
            end = i * 2 + 2;
            class = 0;
        }
        starts[i] = start;
        ends[i] = end;
        values[i] = i;
        allowed[i] = 0xffef;
        uses[i] = end - 1;
        offsets[i] = i;
        classes[i] = class;
        remat[i] = i % 4 == 0 ? 1 : 0;
        positions = end > positions ? end : positions;
    }
    offsets[count] = count;
    return positions + 2;
}

int main(int argc, char** argv)
{
    const uint32_t only_shape = argc > 1 ? (uint32_t)strtoul(argv[1], 0, 10) : UINT32_MAX;
    const uint32_t only_config = argc > 2 ? (uint32_t)strtoul(argv[2], 0, 10) : UINT32_MAX;
    const uint32_t profile_seconds = argc > 3 ? (uint32_t)strtoul(argv[3], 0, 10) : 0;
    Arena input_arena = arena_reserve(64u << 20);
    Arena arena = arena_reserve(256u << 20);
    const int descriptor = cycles_open();
    uint64_t checksum = 0;
    const uint32_t shapes[] = { 0, 1, 2, 3, 4, 4, 5, 5, 6, 6 };
    const uint32_t counts[] = { 16, 128, 2048, 16384, 4096, 65536, 4096, 65536, 4096, 65536 };
    const char* names[] = { "tiny-fit", "small-fit", "large-fit", "large-pressure", "temps-fit", "temps-fit", "temps-pressure", "temps-pressure", "one-chain", "one-chain" };
    bool valid = input_arena.base != 0 && arena.base != 0;
    printf("ns/interval and cycles/interval (median of %u); outputs of every variant compared with vector-current\n", SAMPLES);
    for (uint32_t w = 0; valid && w < sizeof(shapes) / sizeof(shapes[0]); w += 1)
    {
        if (only_shape != UINT32_MAX && only_shape != w)
        {
            continue;
        }
        const uint32_t count = counts[w];
        uint32_t* starts = arena_push_array(&input_arena, count, 4, 4);
        uint32_t* ends = arena_push_array(&input_arena, count, 4, 4);
        uint32_t* values = arena_push_array(&input_arena, count, 4, 4);
        uint32_t* allowed = arena_push_array(&input_arena, count, 4, 4);
        uint32_t* uses = arena_push_array(&input_arena, count, 4, 4);
        uint32_t* offsets = arena_push_array(&input_arena, (uint64_t)count + 1, 4, 4);
        uint8_t* classes = arena_push_array(&input_arena, count, 1, 1);
        uint8_t* remat = arena_push_array(&input_arena, count, 1, 1);
        const uint32_t positions = generate(shapes[w], count, starts, ends, values, allowed, uses, offsets, classes, remat);
        const Tier1AllocationInput input = {
            .starts = starts,
            .ends = ends,
            .values = values,
            .allowed_registers = allowed,
            .classes = classes,
            .rematerializable = remat,
            .use_offsets = offsets,
            .use_positions = uses,
            .use_count = count,
            .count = count,
            .value_count = count,
            .position_count = positions,
            .registers = { 0xffef, 0xffef },
        };
        Tier1Allocation reference = { 0 };
        Tier1Allocation scalar_reference = { 0 };
        valid = tier1_allocate(&input, &arena, &reference) == TIER1_ALLOCATION_OK && (count > 4096 || tier1_allocation_verify(&input, &reference));
        valid = valid && tier1_allocate_scalar(&input, &arena, &scalar_reference) == TIER1_ALLOCATION_OK && (count > 4096 || tier1_allocation_verify(&input, &scalar_reference));
        const uint64_t reference_end = arena.length;
        for (uint32_t c = 0; valid && c < CONFIGS; c += 1)
        {
            Tier1Allocation output = { 0 };
            valid = proto_allocate_impl(&input, &arena, configs[c].vector, configs[c].variant, &output) == TIER1_ALLOCATION_OK && same_output(configs[c].vector ? &reference : &scalar_reference, &output);
            if (!valid)
            {
                fprintf(stderr, "%s %u: %s differs from its path's tier1_allocate\n", names[w], count, configs[c].name);
            }
            arena_pop_to(&arena, reference_end);
        }
        printf("%-15s %6u intervals, peak pressure %u/%u, vector-path intervals %u, scalar %u, spill slots %u\n", names[w], count, reference.peak_pressure[0], reference.peak_pressure[1], reference.vector_intervals, reference.scalar_intervals, reference.spill_count);
        if (profile_seconds != 0 && only_config < CONFIGS)
        {
            const uint64_t until = now_ns() + (uint64_t)profile_seconds * 1000000000u;
            while (valid && now_ns() < until)
            {
                valid = batch(&input, &arena, &configs[only_config], 64, &checksum);
            }
            continue;
        }
        uint32_t repetitions = 1;
        uint64_t elapsed = 0;
        while (valid && elapsed < 2000000 && repetitions < (1u << 20))
        {
            const uint64_t begin = now_ns();
            valid = batch(&input, &arena, &configs[0], repetitions, &checksum);
            elapsed = now_ns() - begin;
            repetitions = elapsed < 2000000 ? repetitions * 2 : repetitions;
        }
        double nanoseconds[CONFIGS][SAMPLES];
        double cycles[CONFIGS][SAMPLES];
        for (uint32_t pass = 0; valid && pass < SAMPLES; pass += 1)
        {
            for (uint32_t order = 0; valid && order < CONFIGS; order += 1)
            {
                const uint32_t c = (pass + order) % CONFIGS;
                const uint64_t begin_cycles = cycles_read(descriptor);
                const uint64_t begin = now_ns();
                valid = batch(&input, &arena, &configs[c], repetitions, &checksum);
                const uint64_t end = now_ns();
                const uint64_t end_cycles = cycles_read(descriptor);
                nanoseconds[c][pass] = (double)(end - begin) / repetitions / count;
                cycles[c][pass] = (double)(end_cycles - begin_cycles) / repetitions / count;
            }
        }
        for (uint32_t c = 0; valid && c < CONFIGS; c += 1)
        {
            printf("    %-18s %8.3f ns/interval %8.2f cycles/interval\n", configs[c].name, median(nanoseconds[c]), median(cycles[c]));
        }
        arena_pop_to(&arena, 0);
        arena_pop_to(&input_arena, 0);
    }
    printf("checksum %" PRIu64 "\n", checksum);
    return valid ? 0 : 1;
}
