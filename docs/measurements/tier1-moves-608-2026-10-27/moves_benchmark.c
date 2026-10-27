// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original #608 qualification harness. Build with the source tree's src/ on the include path.
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <time.h>
#include <linux/perf_event.h>
#include <sys/syscall.h>
#include "buster/compiler/lane.c"
#include "buster/compiler/tier1_allocate.c"

#define BUSTER_MOVE_SAMPLES 11

static uint64_t move_now(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * 1000000000u + (uint64_t)time.tv_nsec;
}

static int move_counter(uint32_t event)
{
    struct perf_event_attr attributes = {
        .type = PERF_TYPE_HARDWARE,
        .size = sizeof(attributes),
        .config = event,
        .exclude_kernel = 1,
        .exclude_hv = 1,
    };
    return (int)syscall(SYS_perf_event_open, &attributes, 0, -1, -1, 0);
}

static uint64_t move_read(int counter)
{
    uint64_t value = 0;
    if (counter < 0 || read(counter, &value, sizeof(value)) != sizeof(value))
    {
        value = 0;
    }
    return value;
}

static double move_median(double* values)
{
    for (uint32_t i = 1; i < BUSTER_MOVE_SAMPLES; i += 1)
    {
        const double value = values[i];
        uint32_t j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return values[BUSTER_MOVE_SAMPLES / 2];
}

static __attribute__((noinline, aligned(64))) bool move_batch(const Tier1ParallelMoves* input, Arena* arena, uint32_t variant, uint32_t repeats, uint64_t* checksum)
{
    bool valid = true;
    const uint64_t saved = arena->length;
    for (uint32_t r = 0; valid && r < repeats; r += 1)
    {
        Tier1ResolvedMoves output = { 0 };
        Tier1AllocationError error;
        if (variant == 0)
        {
            error = tier1_resolve_moves_scalar(input, arena, &output);
        }
        else if (variant == 1)
        {
            error = tier1_resolve_moves_indexed(input, arena, &output, false);
        }
        else if (variant == 2)
        {
            error = tier1_resolve_moves_indexed(input, arena, &output, true);
        }
        else
        {
            error = tier1_resolve_moves(input, arena, &output);
        }
        valid = error == TIER1_ALLOCATION_OK;
        if (valid)
        {
            *checksum += output.count;
            if (output.count != 0)
            {
                *checksum += output.sources[output.count - 1] + output.destinations[0];
            }
        }
        arena_pop_to(arena, saved);
    }
    return valid;
}

static bool move_verify(const Tier1ParallelMoves* input, Arena* arena)
{
    Tier1ResolvedMoves reference = { 0 };
    Tier1ResolvedMoves indexed = { 0 };
    bool valid = tier1_resolve_moves_scalar(input, arena, &reference) == TIER1_ALLOCATION_OK && tier1_resolve_moves_indexed(input, arena, &indexed, true) == TIER1_ALLOCATION_OK;
    valid = valid && reference.count == indexed.count && memcmp(reference.sources, indexed.sources, indexed.count * 4) == 0 && memcmp(reference.destinations, indexed.destinations, indexed.count * 4) == 0;
    uint32_t actual[2050];
    for (uint32_t i = 0; i < 2050; i += 1)
    {
        actual[i] = i;
    }
    for (uint32_t i = 0; valid && i < indexed.count; i += 1)
    {
        valid = indexed.sources[i] < 2050 && indexed.destinations[i] < 2050;
        if (valid)
        {
            actual[indexed.destinations[i]] = actual[indexed.sources[i]];
        }
    }
    for (uint32_t i = 0; valid && i < input->count; i += 1)
    {
        valid = actual[input->destinations[i]] == input->sources[i];
    }
    arena_pop_to(arena, 0);
    return valid;
}

int main(void)
{
    const char* names[] = { "chain", "reversed-chain", "independent", "cycle", "fan-out", "six-argument-chain" };
    const uint32_t counts[] = { 32, 64, 128, 256, 512, 1024 };
    const char* variants[] = { "original-scan", "indexed-scalar", "indexed-vector", "dispatch" };
    const int instructions = move_counter(PERF_COUNT_HW_INSTRUCTIONS);
    const int cycles = move_counter(PERF_COUNT_HW_CPU_CYCLES);
    Arena arena = arena_reserve(1u << 20);
    bool valid = arena.base != 0 && instructions >= 0 && cycles >= 0;
    uint64_t checksum = 0;
    printf("shape,count,variant,repetitions,ns_per_call,instructions_per_call,cycles_per_call,retained_bytes,peak_bytes\n");
    for (uint32_t shape = 0; valid && shape < 6; shape += 1)
    {
        for (uint32_t size = 0; valid && size < 6; size += 1)
        {
            const uint32_t count = shape == 5 ? size + 1 : counts[size];
            uint32_t sources[1024];
            uint32_t destinations[1024];
            for (uint32_t i = 0; i < count; i += 1)
            {
                sources[i] = shape == 1 ? count - i - 1 : shape == 2 ? count + i : shape == 3 ? (i + 1) % count : shape == 4 ? 0 : i;
                destinations[i] = shape == 1 ? count - i : shape == 2 || shape == 3 ? i : i + 1;
            }
            const Tier1ParallelMoves input = {
                .sources = sources,
                .destinations = destinations,
                .count = count,
                .scratch = count * 2 + 1,
            };
            valid = move_verify(&input, &arena);
            uint32_t repeats[4] = { 1, 1, 1, 1 };
            double ns[4][BUSTER_MOVE_SAMPLES];
            double ins[4][BUSTER_MOVE_SAMPLES];
            double cyc[4][BUSTER_MOVE_SAMPLES];
            for (uint32_t variant = 0; valid && variant < 4; variant += 1)
            {
                uint64_t elapsed = 0;
                while (valid && elapsed < 2000000 && repeats[variant] <= (1u << 20))
                {
                    const uint64_t start = move_now();
                    valid = move_batch(&input, &arena, variant, repeats[variant], &checksum);
                    elapsed = move_now() - start;
                    if (elapsed < 2000000)
                    {
                        repeats[variant] *= 2;
                    }
                }
            }
            for (uint32_t sample = 0; valid && sample < BUSTER_MOVE_SAMPLES; sample += 1)
            {
                for (uint32_t offset = 0; valid && offset < 4; offset += 1)
                {
                    const uint32_t variant = (sample + offset) % 4;
                    const uint64_t start_ins = move_read(instructions);
                    const uint64_t start_cyc = move_read(cycles);
                    const uint64_t start = move_now();
                    valid = move_batch(&input, &arena, variant, repeats[variant], &checksum);
                    const uint64_t elapsed = move_now() - start;
                    const uint64_t end_cyc = move_read(cycles);
                    const uint64_t end_ins = move_read(instructions);
                    ns[variant][sample] = (double)elapsed / repeats[variant];
                    ins[variant][sample] = (double)(end_ins - start_ins) / repeats[variant];
                    cyc[variant][sample] = (double)(end_cyc - start_cyc) / repeats[variant];
                }
            }
            for (uint32_t variant = 0; valid && variant < 4; variant += 1)
            {
                const uint32_t peak = count * (variant == 0 || (variant == 3 && count <= 8) ? 21 : 44);
                printf("%s,%u,%s,%u,%.3f,%.3f,%.3f,%u,%u\n", names[shape], count, variants[variant], repeats[variant], move_median(ns[variant]), move_median(ins[variant]), move_median(cyc[variant]), count * 16, peak);
            }
            fflush(stdout);
        }
    }
    fprintf(stderr, "valid=%u checksum=%" PRIu64 " counters=%d,%d\n", valid, checksum, instructions, cycles);
    if (instructions >= 0)
    {
        close(instructions);
    }
    if (cycles >= 0)
    {
        close(cycles);
    }
    arena_release(&arena);
    return valid ? 0 : 1;
}
