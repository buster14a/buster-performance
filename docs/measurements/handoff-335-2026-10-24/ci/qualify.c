// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See Buster's LICENSE and LICENSING.md.
// Original #335 accounting probe. Includes the pinned compiler sources without edits.
// Arena accounting adds overhead: only the uninstrumented time-runs logs qualify speed.
// Compile on the locked 9700X: clang -O3 -g -march=native -fwrapv -funsigned-char
// -fno-strict-aliasing -Wall -Werror -Wno-unused-function -Isrc /path/to/qualify.c -lm -o /path/to/qualify
// The unused-function exception is for oracle helpers in the included parser source, not production diagnostics.
// Usage: qualify [--parser-keywords] [-E options] file.c
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/resource.h>

static uint64_t probe_maps;
static uint64_t probe_unmaps;
static uint64_t probe_mapped;
static uint64_t probe_peak_mapped;

static void* probe_mmap(void* address, size_t length, int protection, int flags, int descriptor, off_t offset)
{
    void* result = mmap(address, length, protection, flags, descriptor, offset);
    if (result != MAP_FAILED)
    {
        probe_maps += 1;
        probe_mapped += (length + 4095ull) & ~4095ull;
        probe_peak_mapped = probe_mapped > probe_peak_mapped ? probe_mapped : probe_peak_mapped;
    }
    return result;
}

static int probe_munmap(void* address, size_t length)
{
    const int result = munmap(address, length);
    if (result == 0)
    {
        probe_unmaps += 1;
        const uint64_t rounded = (length + 4095ull) & ~4095ull;
        assert(probe_mapped >= rounded);
        probe_mapped -= rounded;
    }
    return result;
}

#define mmap probe_mmap
#define munmap probe_munmap
#include "buster/compiler/c_lexer.c"
#define arena_reserve probe_original_reserve
#define arena_release probe_original_release
#define arena_push probe_original_push
#define arena_push_array probe_original_push_array
#define arena_pop_to probe_original_pop_to
#define scratch_end probe_original_scratch_end
#define scratch_begin probe_original_scratch_begin
#include "buster/compiler/lane.c"
#undef arena_reserve
#undef arena_release
#undef arena_push
#undef arena_push_array
#undef arena_pop_to
#undef scratch_end
#undef scratch_begin

typedef struct ProbeArena ProbeArena;
struct ProbeArena
{
    uint8_t* base;
    uint64_t live;
    uint64_t peak;
};

static ProbeArena probe_arenas[4096];
static uint32_t probe_arena_count;
static uint64_t probe_live;
static uint64_t probe_peak;
static uint64_t probe_pushes;
static uint64_t probe_requested;

static ProbeArena* probe_arena(uint8_t* base)
{
    ProbeArena* result = 0;
    for (uint32_t i = 0; i < probe_arena_count && result == 0; i += 1)
    {
        result = probe_arenas[i].base == base ? &probe_arenas[i] : 0;
    }
    if (result == 0 && base != 0)
    {
        assert(probe_arena_count < sizeof(probe_arenas) / sizeof(probe_arenas[0]));
        result = &probe_arenas[probe_arena_count];
        *result = (ProbeArena){ .base = base };
        probe_arena_count += 1;
    }
    return result;
}

static void probe_arena_update(Arena* arena)
{
    ProbeArena* record = probe_arena(arena->base);
    if (record != 0)
    {
        probe_live -= record->live;
        record->live = arena->length;
        record->peak = record->live > record->peak ? record->live : record->peak;
        probe_live += record->live;
        probe_peak = probe_live > probe_peak ? probe_live : probe_peak;
    }
}

static __attribute__((unused)) Arena arena_reserve(uint64_t capacity)
{
    Arena result = probe_original_reserve(capacity);
    if (result.base != 0)
    {
        ProbeArena* record = probe_arena(result.base);
        assert(record->live == 0);
        record->peak = 0;
    }
    probe_arena_update(&result);
    return result;
}

static __attribute__((unused)) void arena_release(Arena* arena)
{
    if (arena->base != 0)
    {
        arena->length = 0;
        probe_arena_update(arena);
    }
    probe_original_release(arena);
}

static __attribute__((unused)) void* arena_push(Arena* arena, uint64_t size, uint64_t alignment)
{
    void* result = probe_original_push(arena, size, alignment);
    probe_pushes += result != 0;
    probe_requested += result != 0 ? size : 0;
    probe_arena_update(arena);
    return result;
}

static __attribute__((unused)) void* arena_push_array(Arena* arena, uint64_t count, uint64_t element_bytes, uint64_t alignment)
{
    void* result = probe_original_push_array(arena, count, element_bytes, alignment);
    probe_pushes += result != 0;
    probe_requested += result != 0 ? count * element_bytes : 0;
    probe_arena_update(arena);
    return result;
}

static __attribute__((unused)) void arena_pop_to(Arena* arena, uint64_t length)
{
    probe_original_pop_to(arena, length);
    probe_arena_update(arena);
}

static __attribute__((unused)) void scratch_end(Scratch scratch)
{
    probe_original_scratch_end(scratch);
    probe_arena_update(scratch.arena);
}

static __attribute__((unused)) Scratch scratch_begin(const Arena* conflict)
{
    const uint64_t maps_before = probe_maps;
    Scratch result = probe_original_scratch_begin(conflict);
    if (probe_maps != maps_before)
    {
        ProbeArena* record = probe_arena(result.arena->base);
        assert(record != 0 && record->live == 0);
        record->peak = 0;
    }
    probe_arena_update(result.arena);
    return result;
}

#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"
#include "buster/compiler/c_parser.c"

static uint64_t probe_now(void)
{
    struct timespec now;
    const int result = clock_gettime(CLOCK_MONOTONIC, &now);
    assert(result == 0);
    return (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec;
}

// Count the production conversion's live vector runs and its exceptional tokens without changing partitions.
// Read/write totals below are logical column traffic, not cache-line traffic or hardware DRAM counters.
static void probe_traffic(const PPTokens* output, const ParseTokens* tokens)
{
    uint64_t blocks = 0;
    uint64_t lanes = 0;
    uint64_t raw = 0;
    uint64_t small = 0;
    uint64_t specials = 0;
    uint64_t pragma_tokens = 0;
    uint64_t split = 0;
    uint64_t kind_loads = 0;
    uint64_t flag_loads = 0;
    uint64_t names = 0;
    for (uint32_t i = 0; i < output->count; i += 1)
    {
        const uint8_t kind = output->kinds[i];
        const bool identifier = kind == C_TOKEN_RAW_IDENTIFIER || (kind >= BUSTER_PP_KIND_KEYWORD && kind < BUSTER_PP_KIND_PRAGMA_END);
        raw += identifier;
        small += identifier && output->values[i] < BUSTER_PP_KEYWORD_TABLE;
    }
    uint32_t i = 0;
    while (i < output->count)
    {
        const uint32_t live = output->count - i < 64 ? output->count - i : 64;
        kind_loads += live;
        flag_loads += live;
        uint32_t run = 0;
        while (run < live && output->kinds[i + run] != C_TOKEN_HASH && output->kinds[i + run] != BUSTER_PP_KIND_PRAGMA_END && output->kinds[i + run] != C_TOKEN_COLONCOLON)
        {
            const uint8_t kind = output->kinds[i + run];
            names += kind == C_TOKEN_RAW_IDENTIFIER || (kind >= BUSTER_PP_KIND_KEYWORD && kind < BUSTER_PP_KIND_PRAGMA_END);
            run += 1;
        }
        blocks += 1;
        lanes += run;
        i += run;
        if (run < live)
        {
            specials += 1;
            uint32_t end = i;
            if (output->kinds[i] == C_TOKEN_HASH && (output->flags[i] & BUSTER_PP_START_OF_LINE) != 0 && parse_pragma_at(output, i, &end))
            {
                pragma_tokens += end - i + 1;
                i = end + 1;
            }
            else
            {
                split += output->kinds[i] == C_TOKEN_COLONCOLON;
                i += 1;
            }
        }
    }
    const uint64_t padding_bytes = 2ull * BUSTER_PARSE_TOKEN_PADDING * 10;
    printf("traffic: pp_tokens=%u parse_tokens=%u identifiers=%llu small_ids=%llu pragmas=%u pragma_tokens=%llu splits=%llu\n", output->count, tokens->count,
           (unsigned long long)raw, (unsigned long long)small, tokens->pragma_count, (unsigned long long)pragma_tokens, (unsigned long long)split);
    printf("traffic: vector_blocks=%llu ordinary_lanes=%llu occupancy=%.6f exceptional_calls=%llu vector_conversion_kind_load_bytes=%llu vector_conversion_flag_load_bytes=%llu vector_conversion_name_load_bytes=%llu parser_column_payload_bytes=%llu padding_payload_bytes=%llu pragma_column_payload_bytes=%llu\n",
           (unsigned long long)blocks, (unsigned long long)lanes, blocks != 0 ? (double)lanes / (64.0 * blocks) : 0, (unsigned long long)specials,
           (unsigned long long)kind_loads, (unsigned long long)flag_loads, (unsigned long long)(4 * names), (unsigned long long)(10ull * tokens->count),
           (unsigned long long)padding_bytes, (unsigned long long)(8ull * tokens->pragma_count));
    printf("traffic: separate_keyword_kind_read_bytes=%u separate_keyword_value_read_bytes=%llu keyword_kind_write_bytes=%llu fused_pragma_value_read_bytes=%llu\n",
           output->count, (unsigned long long)(4 * raw), (unsigned long long)small, (unsigned long long)(4 * (raw - names)));
}

int main(int argc, char** argv)
{
    const uint64_t start = probe_now();
    Arena arguments = arena_reserve(1ull << 30);
    PPOptions options = { 0 };
    const char* input = 0;
    const char* output = 0;
    bool markers = false;
    bool ready = arguments.base != 0 && pp_parse_options(argc - 1, argv + 1, &options, &arguments, &input, &output, &markers);
    static InternTable table;
    static Preprocessor pp;
    static Parser parser;
    const ParseOptions parse_options = { .tree_only = true };
    ready = ready && intern_initialize(&table) && pp_initialize(&pp, &options, &table) && parse_initialize(&parser, &parse_options, options.language);
    const uint64_t prepared = probe_now();
    ready = ready && pp_run(&pp, input);
    const uint64_t preprocessed = probe_now();
    ready = ready && parse_translation_unit(&parser, &pp);
    const uint64_t parsed = probe_now();
    const uint64_t live = probe_live;
    const uint64_t scratch = parser.scratch.base != 0 ? probe_arena(parser.scratch.base)->peak : 0;
    const ParseStatistics statistics = parser.statistics;
    struct rusage usage;
    getrusage(RUSAGE_SELF, &usage);
    // Reporting scans are outside every phase timer and happen before releasing the borrowed PP storage.
    if (ready)
    {
        probe_traffic(&pp.output, &parser.tokens);
    }
    for (uint32_t i = 0; i < BUSTER_SCRATCH_ARENA_COUNT; i += 1)
    {
        const Arena* temporary = &thread_context.scratch[i];
        const uint64_t peak = temporary->base != 0 ? probe_arena(temporary->base)->peak : 0;
        printf("scratch: thread_arena=%u peak_logical_bytes=%llu\n", i, (unsigned long long)peak);
    }
    const uint64_t release_start = probe_now();
    parse_release(&parser);
    pp_release(&pp);
    intern_release(&table);
    arena_release(&arguments);
    for (uint32_t i = 0; i < BUSTER_SCRATCH_ARENA_COUNT; i += 1)
    {
        arena_release(&thread_context.scratch[i]);
    }
    const uint64_t released = probe_now();
    printf("phases: prepare_ns=%llu preprocess_ns=%llu parser_with_conversion_ns=%llu cleanup_ns=%llu total_ns=%llu ready=%d fused=%d\n",
           (unsigned long long)(prepared - start), (unsigned long long)(preprocessed - prepared), (unsigned long long)(parsed - preprocessed),
           (unsigned long long)(released - release_start), (unsigned long long)(parsed - start + released - release_start), ready, options.parser_keywords);
    printf("memory: maps=%llu unmaps=%llu arena_pushes=%llu arena_requested_bytes=%llu peak_mapped_virtual_bytes=%llu live_arena_logical_bytes=%llu peak_arena_logical_bytes=%llu parser_scratch_peak_bytes=%llu peak_rss_kb=%ld remaining_mapped=%llu remaining_logical=%llu\n",
           (unsigned long long)probe_maps, (unsigned long long)probe_unmaps, (unsigned long long)probe_pushes, (unsigned long long)probe_requested,
           (unsigned long long)probe_peak_mapped, (unsigned long long)live, (unsigned long long)probe_peak, (unsigned long long)scratch, usage.ru_maxrss,
           (unsigned long long)probe_mapped, (unsigned long long)probe_live);
    printf("fallback: items=%llu tokens=%llu flagged=%llu whole=%d\n", (unsigned long long)statistics.fallback_items,
           (unsigned long long)statistics.fallback_tokens, (unsigned long long)statistics.flagged_tokens, statistics.whole);
    return ready && probe_mapped == 0 && probe_live == 0 ? 0 : 1;
}
