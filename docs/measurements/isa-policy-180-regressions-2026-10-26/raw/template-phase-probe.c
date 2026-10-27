// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Private causal diagnostic, never a production API or acceptance benchmark.
// The included benchmark retains its original MIT/Apache notices and timers.
#define _GNU_SOURCE
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_PHASE_ALLOCATION_LIMIT 128

typedef struct PhaseAllocation
{
    void* pointer;
    size_t bytes;
    size_t alignment;
    bool zeroed;
    bool released;
} PhaseAllocation;

static PhaseAllocation phase_allocations[BUSTER_PHASE_ALLOCATION_LIMIT];
static unsigned phase_allocation_count;
static unsigned phase_allocation_cursor;
static bool phase_allocations_okay = true;

// Allocate each ordinal once. Every later benchmark invocation receives the
// same addresses, request sizes and alignment; calloc still clears its bytes.
static void* phase_allocate(size_t bytes, size_t alignment, bool zeroed)
{
    void* result = 0;
    const unsigned slot = phase_allocation_cursor;
    phase_allocation_cursor += 1;
    if (slot >= BUSTER_PHASE_ALLOCATION_LIMIT)
    {
        phase_allocations_okay = false;
    }
    else
    {
        PhaseAllocation* allocation = &phase_allocations[slot];
        if (slot == phase_allocation_count)
        {
            allocation->pointer = alignment != 0 ? aligned_alloc(alignment, bytes) : calloc(1, bytes);
            allocation->bytes = bytes;
            allocation->alignment = alignment;
            allocation->zeroed = zeroed;
            phase_allocation_count += 1;
        }
        const bool same = allocation->bytes == bytes && allocation->alignment == alignment && allocation->zeroed == zeroed && allocation->pointer != 0;
        phase_allocations_okay &= same;
        if (same)
        {
            allocation->released = false;
            if (zeroed)
            {
                memset(allocation->pointer, 0, bytes);
            }
            result = allocation->pointer;
        }
    }
    return result;
}

static void* phase_aligned_alloc(size_t alignment, size_t bytes)
{
    return phase_allocate(bytes, alignment, false);
}

static void* phase_calloc(size_t count, size_t bytes)
{
    void* result = 0;
    if (bytes != 0 && count > SIZE_MAX / bytes)
    {
        phase_allocations_okay = false;
    }
    else
    {
        result = phase_allocate(count * bytes, 0, true);
    }
    return result;
}

static void phase_free(void* pointer)
{
    bool found = pointer == 0;
    for (unsigned i = 0; pointer != 0 && i < phase_allocation_count; i += 1)
    {
        if (phase_allocations[i].pointer == pointer)
        {
            phase_allocations_okay &= !phase_allocations[i].released;
            phase_allocations[i].released = true;
            found = true;
        }
    }
    phase_allocations_okay &= found;
}

#define aligned_alloc phase_aligned_alloc
#define calloc phase_calloc
#define free phase_free
#include "src/buster/compiler/x86_64_encoder_benchmark.c"
#undef aligned_alloc
#undef calloc
#undef free

static bool phase_verify_allocator(void)
{
    phase_allocation_cursor = 0;
    void* first = phase_aligned_alloc(64, 64);
    uint8_t* second = phase_calloc(3, 16);
    bool okay = first != 0 && second != 0 && phase_allocations_okay;
    if (second != 0)
    {
        memset(second, 0xa5, 48);
    }
    phase_free(first);
    phase_free(second);
    phase_allocation_cursor = 0;
    okay &= phase_aligned_alloc(64, 64) == first && phase_calloc(3, 16) == second;
    for (unsigned i = 0; okay && i < 48; i += 1)
    {
        okay &= second[i] == 0;
    }
    phase_free(first);
    phase_free(second);
    phase_allocation_cursor = 0;
    okay &= phase_aligned_alloc(64, 128) == 0 && !phase_allocations_okay;
    phase_allocations_okay = true;
    phase_free(first);
    okay &= !phase_allocations_okay;
    phase_allocations_okay = true;
    phase_free(&okay);
    okay &= !phase_allocations_okay;
    phase_allocations_okay = true;
    phase_allocation_cursor = BUSTER_PHASE_ALLOCATION_LIMIT;
    okay &= phase_aligned_alloc(64, 64) == 0 && !phase_allocations_okay;
    phase_allocations_okay = true;
    okay &= phase_calloc(SIZE_MAX, 2) == 0 && !phase_allocations_okay;
    phase_allocations_okay = true;
    printf("phase allocation fixture: %s; reuse, calloc reset, changed shape, duplicate/unknown free, capacity and overflow\n", okay ? "pass" : "FAIL");
    return okay;
}

static bool phase_verify(void)
{
    enum { count = 199 };
    X86Instruction records[count];
    uint8_t expected[BUSTER_X86_ENCODER_CAPACITY(count)];
    uint8_t actual[BUSTER_X86_ENCODER_CAPACITY(count)];
    uint32_t expected_offsets[count], actual_offsets[count];
    uint32_t expected_ends[BUSTER_X86_ENCODER_FIXUP_CAPACITY(count)];
    uint32_t actual_ends[BUSTER_X86_ENCODER_FIXUP_CAPACITY(count)];
    bool okay = phase_verify_allocator();
    const size_t table_bytes = (BUSTER_X86_FORM_FIXUP + BUSTER_X86_FORM_TEMPLATES) * sizeof(X86TemplateEntry);
    uint8_t* reference_table = malloc(table_bytes);
    okay &= reference_table != 0;
    x86_benchmark_mode = X86_ENCODER_MODE_64;
    okay &= x86_encoder_initialize();
    okay &= make_stream(records, count, x86_benchmark_patterns, BUSTER_ARRAY_LENGTH(x86_benchmark_patterns), false, 1);
    uint32_t marked_indices[count];
    x86_benchmark_mark(records, count, marked_indices);
    for (unsigned phase = 0; okay && phase < 64; phase += 1)
    {
        memset(x86_template_storage, 0xa5, sizeof(x86_template_storage));
        x86_templates = x86_template_storage + BUSTER_X86_TEMPLATE_PADDING + phase;
        okay &= x86_encoder_initialize();
        if (phase == 0)
        {
            memcpy(reference_table, x86_templates, table_bytes);
        }
        else
        {
            okay &= memcmp(reference_table, x86_templates, table_bytes) == 0;
        }
        const uint8_t* storage = (const uint8_t*)x86_template_storage;
        const size_t prefix = (BUSTER_X86_TEMPLATE_PADDING + phase) * sizeof(X86TemplateEntry);
        const size_t suffix = prefix + (BUSTER_X86_FORM_FIXUP + BUSTER_X86_FORM_TEMPLATES) * sizeof(X86TemplateEntry);
        for (size_t i = 0; okay && i < prefix; i += 1)
        {
            okay &= storage[i] == 0xa5;
        }
        for (size_t i = suffix; okay && i < sizeof(x86_template_storage); i += 1)
        {
            okay &= storage[i] == 0xa5;
        }
        for (unsigned flags = 0; okay && flags < 4; flags += 1)
        {
            for (unsigned n = 0; okay && n <= count; n += 1)
            {
                unsigned marked = 0;
                for (unsigned i = 0; i < n; i += 1)
                {
                    marked += (records[i].form & BUSTER_X86_FORM_FIXUP) != 0;
                }
                memset(actual, 0xa5, sizeof(actual));
                const int64_t expected_length = encode_scalar_loop(records, n, expected, expected_offsets, expected_ends);
                const int64_t actual_length = x86_encode_16(records, n, actual, (flags & 1) != 0 ? actual_offsets : 0, (flags & 2) != 0 ? actual_ends : 0);
                okay &= expected_length >= 0 && actual_length == expected_length && memcmp(actual, expected, (size_t)expected_length) == 0;
                okay &= (flags & 1) == 0 || memcmp(actual_offsets, expected_offsets, n * sizeof(uint32_t)) == 0;
                okay &= (flags & 2) == 0 || memcmp(actual_ends, expected_ends, marked * sizeof(uint32_t)) == 0;
                for (size_t i = BUSTER_X86_ENCODER_CAPACITY(n); okay && i < sizeof(actual); i += 1)
                {
                    okay &= actual[i] == 0xa5;
                }
            }
        }
    }
    free(reference_table);
    printf("phase verify: %s; 64 complete identical tables, counts0..199, four output states, scalar bytes/offsets/fixups, template/output sentinels\n", okay ? "pass" : "FAIL");
    return okay;
}

int main(int argc, char** argv)
{
    bool okay = true;
    if (argc == 2 && strcmp(argv[1], "--verify") == 0)
    {
        okay = phase_verify();
    }
    else
    {
        unsigned order = 0;
        char* benchmark_arguments[64];
        int first = 1;
        if (argc >= 3 && strcmp(argv[1], "--phase-order") == 0)
        {
            okay = strlen(argv[2]) == 1 && argv[2][0] >= '0' && argv[2][0] <= '2';
            order = okay ? (unsigned)(argv[2][0] - '0') : 0;
            first = 3;
        }
        const int benchmark_argc = argc - first + 1;
        okay &= benchmark_argc > 1 && benchmark_argc < 64;
        benchmark_arguments[0] = argv[0];
        for (int i = first; okay && i < argc; i += 1)
        {
            okay &= strcmp(argv[i], "--mode16") != 0 && strcmp(argv[i], "--mode32") != 0;
            benchmark_arguments[i - first + 1] = argv[i];
        }
        if (okay)
        {
            benchmark_arguments[benchmark_argc] = 0;
        }
        const unsigned strides[] = {17, 19, 23};
        const unsigned shifts[] = {0, 21, 43};
        uint64_t allocation_identity = 0;
        unsigned slots = 0;
        for (unsigned step = 0; okay && step < 64; step += 1)
        {
            const unsigned phase = (step * strides[order] + shifts[order]) & 63;
            x86_templates = x86_template_storage + BUSTER_X86_TEMPLATE_PADDING + phase;
            phase_allocation_cursor = 0;
            printf("phase=%u step=%u order=%u template=%" PRIuPTR " mod4096=%" PRIuPTR "\n", phase, step, order, (uintptr_t)x86_templates,
                   (uintptr_t)x86_templates & 4095);
            fflush(stdout);
            okay &= run_x86_encoder_benchmark(benchmark_argc, benchmark_arguments) == 0 && phase_allocations_okay;
            uint64_t identity = UINT64_C(14695981039346656037);
            for (unsigned i = 0; i < phase_allocation_count; i += 1)
            {
                okay &= phase_allocations[i].released;
                identity = (identity ^ (uintptr_t)phase_allocations[i].pointer) * UINT64_C(1099511628211);
            }
            okay &= phase_allocation_cursor == phase_allocation_count;
            if (step == 0)
            {
                allocation_identity = identity;
                slots = phase_allocation_count;
            }
            okay &= identity == allocation_identity && slots == phase_allocation_count;
            printf("phase allocations: %u identity=%" PRIu64 " stable=%u\n", phase_allocation_count, identity, okay ? 1 : 0);
        }
        printf("phase scan: %s; 64 phases, fixed executable and allocation addresses\n", okay ? "pass" : "FAIL");
    }
    for (unsigned i = 0; i < phase_allocation_count; i += 1)
    {
        free(phase_allocations[i].pointer);
    }
    return okay ? 0 : 1;
}
