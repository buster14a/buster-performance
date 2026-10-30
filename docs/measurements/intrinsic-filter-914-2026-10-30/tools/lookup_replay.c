// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original qualification harness. Includes the selected unchanged production catalog.
// Timing and diagnostic builds are separate: LOOKUP_COSTS wraps only memcmp calls in
// this include, and is never appropriate for reporting uninstrumented lookup timings.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifndef BUSTER_INTRINSIC_CATALOG
#error Define BUSTER_INTRINSIC_CATALOG to the selected source catalog path
#endif
#ifndef BUSTER_LOOKUP_HAS_FILTER
#define BUSTER_LOOKUP_HAS_FILTER 0
#endif
#ifndef LOOKUP_COSTS
#define LOOKUP_COSTS 0
#endif

#if LOOKUP_COSTS
static uint64_t lookup_compare_calls;
static uint64_t lookup_compare_bytes;
static int lookup_counted_memcmp(const void* left, const void* right, size_t length)
{
    lookup_compare_calls += 1;
    lookup_compare_bytes += length;
    const int result = memcmp(left, right, length);
    return result;
}
#define memcmp lookup_counted_memcmp
#endif
#include BUSTER_INTRINSIC_CATALOG
#if LOOKUP_COSTS
#undef memcmp
#endif

typedef struct ReplayCorpus ReplayCorpus;
struct ReplayCorpus
{
    BuiltinIntrinsicName* names;
    uint32_t count;
    uint32_t capacity;
    uint64_t bytes;
};

static bool replay_append(ReplayCorpus* corpus, const void* bytes, uint32_t length)
{
    bool valid = corpus->count < UINT32_MAX && length <= UINT32_C(1048576);
    if (valid && corpus->count == corpus->capacity)
    {
        const uint32_t capacity = corpus->capacity == 0 ? 256 : corpus->capacity > UINT32_MAX / 2 ? UINT32_MAX : corpus->capacity * 2;
        BuiltinIntrinsicName* names = realloc(corpus->names, (size_t)capacity * sizeof(*names));
        valid = names != NULL;
        if (valid)
        {
            corpus->names = names;
            corpus->capacity = capacity;
        }
    }
    char* name = valid ? malloc(length == 0 ? 1 : length) : NULL;
    valid = valid && name != NULL;
    if (valid)
    {
        if (length != 0)
        {
            memcpy(name, bytes, length);
        }
        corpus->names[corpus->count] = (BuiltinIntrinsicName){ name, length };
        corpus->count += 1;
        corpus->bytes += length;
    }
    return valid;
}

static bool replay_read_lines(FILE* file, ReplayCorpus* corpus)
{
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length;
    bool valid = true;
    while (valid && (length = getline(&line, &capacity, file)) >= 0)
    {
        if (length > 0 && line[length - 1] == '\n')
        {
            length -= 1;
        }
        if (length > 0 && line[length - 1] == '\r')
        {
            length -= 1;
        }
        valid = length <= UINT32_MAX && replay_append(corpus, line, (uint32_t)length);
    }
    valid = valid && !ferror(file);
    free(line);
    return valid;
}

static bool replay_read_binary(FILE* file, ReplayCorpus* corpus)
{
    bool valid = true;
    while (valid)
    {
        unsigned char prefix[4];
        const size_t got = fread(prefix, 1, sizeof(prefix), file);
        if (got == 0)
        {
            break;
        }
        valid = got == sizeof(prefix);
        const uint32_t length = valid ? (uint32_t)prefix[0] | ((uint32_t)prefix[1] << 8) | ((uint32_t)prefix[2] << 16) | ((uint32_t)prefix[3] << 24) : 0;
        valid = valid && length <= UINT32_C(1048576);
        unsigned char* bytes = valid ? malloc(length == 0 ? 1 : length) : NULL;
        valid = valid && bytes != NULL;
        if (valid)
        {
            valid = fread(bytes, 1, length, file) == length && replay_append(corpus, bytes, length);
        }
        free(bytes);
    }
    valid = valid && !ferror(file);
    return valid;
}

static __attribute__((noinline)) void replay_pass(const ReplayCorpus* corpus, const BuiltinIntrinsicInfo** outputs, uint32_t batch_size, bool scalar)
{
    for (uint32_t first = 0; first < corpus->count;)
    {
        const uint32_t remaining = corpus->count - first;
        const uint32_t lanes = remaining < batch_size ? remaining : batch_size;
        builtin_intrinsic_lookup_batch(corpus->names + first, outputs + first, lanes, scalar);
        first += lanes;
    }
    // The barrier makes every output observable across passes without hashing it
    // inside the measured region. No instruction is emitted by this barrier.
    __asm__ volatile("" : : "r"(outputs) : "memory");
}

static uint64_t replay_digest(const ReplayCorpus* corpus, const BuiltinIntrinsicInfo* const* outputs)
{
    uint64_t digest = UINT64_C(1469598103934665603);
    for (uint32_t i = 0; i < corpus->count; i += 1)
    {
        const uint64_t identity = outputs[i] == NULL ? 0 : (uint64_t)(outputs[i] - builtin_intrinsic_infos) + 1;
        digest = (digest ^ identity) * UINT64_C(1099511628211);
        digest = (digest ^ corpus->names[i].length) * UINT64_C(1099511628211);
    }
    return digest;
}

static bool replay_number(const char* text, uint32_t minimum, uint32_t maximum, uint32_t* output)
{
    char* end = NULL;
    errno = 0;
    const unsigned long value = strtoul(text, &end, 10);
    const bool valid = text[0] != '\0' && end != NULL && *end == '\0' && errno == 0 && value >= minimum && value <= maximum;
    if (valid)
    {
        *output = (uint32_t)value;
    }
    return valid;
}

static uint64_t replay_nanoseconds(struct timespec before, struct timespec after)
{
    const int64_t delta = ((int64_t)after.tv_sec - (int64_t)before.tv_sec) * INT64_C(1000000000) + after.tv_nsec - before.tv_nsec;
    const uint64_t result = delta < 0 ? 0 : (uint64_t)delta;
    return result;
}

static bool replay_condition(const ReplayCorpus* corpus, const BuiltinIntrinsicInfo** outputs, uint32_t batch_size, uint32_t milliseconds, uint64_t* elapsed)
{
    bool valid = true;
    *elapsed = 0;
    if (milliseconds != 0)
    {
        struct timespec before;
        struct timespec after;
        valid = clock_gettime(CLOCK_MONOTONIC, &before) == 0;
        const uint64_t duration = (uint64_t)milliseconds * UINT64_C(1000000);
        while (valid && *elapsed < duration)
        {
            replay_pass(corpus, outputs, batch_size, true);
            valid = clock_gettime(CLOCK_MONOTONIC, &after) == 0;
            if (valid)
            {
                *elapsed = replay_nanoseconds(before, after);
            }
        }
    }
    return valid;
}

static void replay_costs(const ReplayCorpus* corpus, const BuiltinIntrinsicInfo* const* outputs, uint32_t batch_size, bool scalar)
{
    (void)scalar;
    uint64_t candidates = 0;
    uint64_t true_hits = 0;
    uint64_t positive_batches = 0;
    uint64_t batches = 0;
    for (uint32_t first = 0; first < corpus->count;)
    {
        const uint32_t remaining = corpus->count - first;
        const uint32_t lanes = remaining < batch_size ? remaining : batch_size;
        uint32_t mask = 0;
#if BUSTER_LOOKUP_HAS_FILTER
        if (!scalar)
        {
            mask = builtin_intrinsic_filter_candidates(corpus->names + first, lanes, false);
        }
        else
#endif
        {
            for (uint32_t lane = 0; lane < lanes; lane += 1)
            {
                mask |= (uint32_t)(corpus->names[first + lane].name != NULL && corpus->names[first + lane].length != 0) << lane;
            }
        }
        candidates += (uint32_t)__builtin_popcount(mask);
        positive_batches += mask != 0;
        batches += 1;
        for (uint32_t lane = 0; lane < lanes; lane += 1)
        {
            true_hits += outputs[first + lane] != NULL;
        }
        first += lanes;
    }
    printf("costs names=%u batches=%" PRIu64 " positive_batches=%" PRIu64 " candidates=%" PRIu64 " rejections=%" PRIu64 " true_hits=%" PRIu64 " false_positives=%" PRIu64,
           corpus->count, batches, positive_batches, candidates, (uint64_t)corpus->count - candidates, true_hits, candidates - true_hits);
#if LOOKUP_COSTS
    printf(" exact_compare_calls=%" PRIu64 " compared_byte_bound=%" PRIu64, lookup_compare_calls, lookup_compare_bytes);
#else
    printf(" exact_compare_calls=not_collected compared_byte_bound=not_collected");
#endif
    putchar('\n');
}

int main(int argc, char** argv)
{
    const char* path = NULL;
    bool binary = false;
    bool scalar = false;
    bool valid = true;
    uint32_t passes = 100;
    uint32_t warmup = 5;
    uint32_t samples = 7;
    uint32_t batch_size = 8;
    uint32_t after_scalar = 0;
    for (int i = 1; valid && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--scalar") == 0)
        {
            scalar = true;
        }
        else if (i + 1 < argc && strcmp(argv[i], "--format") == 0)
        {
            i += 1;
            binary = strcmp(argv[i], "u32le") == 0;
            valid = binary || strcmp(argv[i], "lines") == 0;
        }
        else if (i + 1 < argc && strcmp(argv[i], "--passes") == 0)
        {
            i += 1;
            valid = replay_number(argv[i], 1, UINT32_MAX, &passes);
        }
        else if (i + 1 < argc && strcmp(argv[i], "--samples") == 0)
        {
            i += 1;
            valid = replay_number(argv[i], 1, 1000, &samples);
        }
        else if (i + 1 < argc && strcmp(argv[i], "--warmup") == 0)
        {
            i += 1;
            valid = replay_number(argv[i], 0, UINT32_MAX, &warmup);
        }
        else if (i + 1 < argc && strcmp(argv[i], "--batch-size") == 0)
        {
            i += 1;
            valid = replay_number(argv[i], 1, 8, &batch_size);
        }
        else if (i + 1 < argc && strcmp(argv[i], "--after-scalar") == 0)
        {
            i += 1;
            valid = replay_number(argv[i], 0, 60000, &after_scalar);
        }
        else if (path == NULL && argv[i][0] != '-')
        {
            path = argv[i];
        }
        else
        {
            valid = false;
        }
    }
    FILE* file = valid && path != NULL ? fopen(path, "rb") : NULL;
    valid = valid && file != NULL;
    ReplayCorpus corpus = { 0 };
    if (valid)
    {
        valid = binary ? replay_read_binary(file, &corpus) : replay_read_lines(file, &corpus);
        valid = fclose(file) == 0 && valid && corpus.count != 0;
    }
    const BuiltinIntrinsicInfo** outputs = valid ? calloc(corpus.count, sizeof(*outputs)) : NULL;
    const BuiltinIntrinsicInfo** oracle = valid ? calloc(corpus.count, sizeof(*oracle)) : NULL;
    valid = valid && outputs != NULL && oracle != NULL;
    uint64_t digest = 0;
    if (valid)
    {
        replay_pass(&corpus, oracle, batch_size, true);
#if LOOKUP_COSTS
        lookup_compare_calls = 0;
        lookup_compare_bytes = 0;
#endif
        replay_pass(&corpus, outputs, batch_size, scalar);
        for (uint32_t i = 0; valid && i < corpus.count; i += 1)
        {
            valid = outputs[i] == oracle[i];
        }
        digest = replay_digest(&corpus, outputs);
        printf("identity vector_oracle=%s digest=%016" PRIx64 " names=%u bytes=%" PRIu64 " filter=%d host_vector=%d mode=%s batch=%u instrumented=%d after_scalar_ms=%u\n",
               valid ? "equal" : "MISMATCH", digest, corpus.count, corpus.bytes, BUSTER_LOOKUP_HAS_FILTER, BUSTER_HOST_VECTOR, scalar ? "scalar" : "vector", batch_size, LOOKUP_COSTS, after_scalar);
        replay_costs(&corpus, outputs, batch_size, scalar);
    }
    if (valid && !LOOKUP_COSTS)
    {
        for (uint32_t pass = 0; pass < warmup; pass += 1)
        {
            replay_pass(&corpus, outputs, batch_size, scalar);
        }
        for (uint32_t sample = 0; valid && sample < samples; sample += 1)
        {
            struct timespec before;
            struct timespec after;
            uint64_t conditioning_elapsed = 0;
            valid = replay_condition(&corpus, outputs, batch_size, after_scalar, &conditioning_elapsed);
            valid = valid && replay_digest(&corpus, outputs) == digest;
            valid = valid && clock_gettime(CLOCK_MONOTONIC, &before) == 0;
            for (uint32_t pass = 0; valid && pass < passes; pass += 1)
            {
                replay_pass(&corpus, outputs, batch_size, scalar);
            }
            valid = valid && clock_gettime(CLOCK_MONOTONIC, &after) == 0;
            if (valid)
            {
                const uint64_t elapsed = replay_nanoseconds(before, after);
                const uint64_t lookups = (uint64_t)passes * corpus.count;
                valid = replay_digest(&corpus, outputs) == digest;
                printf("sample=%u elapsed_ns=%" PRIu64 " lookups=%" PRIu64 " ns_per_lookup=%.9f digest=%016" PRIx64 " conditioning_ns=%" PRIu64 "\n",
                       sample, elapsed, lookups, (double)elapsed / (double)lookups, replay_digest(&corpus, outputs), conditioning_elapsed);
            }
        }
    }
    for (uint32_t i = 0; i < corpus.count; i += 1)
    {
        free((void*)corpus.names[i].name);
    }
    free(corpus.names);
    free(outputs);
    free(oracle);
    if (!valid)
    {
        fprintf(stderr, "lookup replay failed; usage: lookup_replay [--format lines|u32le] [--scalar] [--batch-size 1..8] [--passes N] [--warmup N] [--samples N] [--after-scalar 0..60000] CORPUS\n");
    }
    return valid ? 0 : 1;
}
