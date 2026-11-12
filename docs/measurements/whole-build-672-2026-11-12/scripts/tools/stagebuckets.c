// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// stagebuckets: puts every sample of a `--time-stages` compile recorded under `perf record -T` in the stage its time
// falls in, the method of buster-performance's one-core-design-672-2026-11-12 (its tools/stage_reduce.py), in C.
//
//   stagebuckets [--functions N] [--merge FIRST LAST NAME] [--anchor PREFIX STAGE]... [--prefix PREFIX]...
//                STAGES SAMPLES [STAGES SAMPLES]...
//
// STAGES is a run's --time-stages report (its top-level `time-stage` lines, in order, are the stages' milliseconds
// from the clock's start) and SAMPLES the same run's `perf script -F time,period,event,ip,sym` text, read through
// `gzip -dc` when its name ends in .gz. The clock's start on perf's clock is the median of the anchors' estimates: an
// anchor's is the time of the first sample of a function whose name starts with PREFIX, less the stages before STAGE.
// Without --anchor the anchors are the one-core record's: `parse_tokens_from_output` at `parse`, `check_input` at
// `check-input` and `tier0_generate` at `tier0`. --merge reports the stages from FIRST to LAST as one, NAME (the emission's stages run
// function by function, so a sample's time can't split them). A STAGES of `-` takes the run as one stage, `all`, for a
// command whose report has no stages to place (many units as one command). It prints each stage's counts per run (the
// runs' mean), the spread of each run's estimates, with --functions N each stage's N first functions by the first
// event, and with --prefix each stage's counts in the functions whose names start with PREFIX.

#define _GNU_SOURCE
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUCKETS_STAGES 64
#define BUCKETS_EVENTS 8
#define BUCKETS_ANCHORS 8
#define BUCKETS_SYMBOLS 65536
#define BUCKETS_NAME 160

typedef struct BucketsSample BucketsSample;
struct BucketsSample
{
    double ms;
    uint64_t period;
    uint32_t event;
    uint32_t symbol;
};

typedef struct BucketsState BucketsState;
struct BucketsState
{
    // The reported stages: `before`, each stage of the first run's report (merged ones as one), `after`.
    char stages[BUCKETS_STAGES + 2][BUCKETS_NAME];
    uint32_t stage_count;
    char events[BUCKETS_EVENTS][BUCKETS_NAME];
    uint32_t event_count;
    // The symbols' names, in a table of open addressing by their hash.
    char (*symbols)[BUCKETS_NAME];
    uint32_t* slots;
    uint32_t symbol_count;
    // totals[stage][event], and functions[(stage * BUCKETS_SYMBOLS + symbol) * BUCKETS_EVENTS + event].
    double totals[BUCKETS_STAGES + 2][BUCKETS_EVENTS];
    double* functions;
};

static uint32_t buckets_symbol(BucketsState* state, const char* name)
{
    uint64_t hash = 1469598103934665603ull;
    for (const char* c = name; *c != 0; c += 1)
    {
        hash = (hash ^ (uint8_t)*c) * 1099511628211ull;
    }
    uint32_t slot = (uint32_t)(hash % (2 * BUCKETS_SYMBOLS));
    uint32_t result = UINT32_MAX;
    while (result == UINT32_MAX)
    {
        const uint32_t held = state->slots[slot];
        if (held == 0)
        {
            if (state->symbol_count + 1 < BUCKETS_SYMBOLS)
            {
                state->symbol_count += 1;
                snprintf(state->symbols[state->symbol_count], BUCKETS_NAME, "%s", name);
                state->slots[slot] = state->symbol_count;
                result = state->symbol_count;
            }
            else
            {
                result = 0;
            }
        }
        else if (strncmp(state->symbols[held], name, BUCKETS_NAME - 1) == 0)
        {
            result = held;
        }
        else
        {
            slot = (slot + 1) % (2 * BUCKETS_SYMBOLS);
        }
    }
    return result;
}

static uint32_t buckets_event(BucketsState* state, const char* name)
{
    uint32_t result = UINT32_MAX;
    for (uint32_t e = 0; result == UINT32_MAX && e < state->event_count; e += 1)
    {
        result = strcmp(state->events[e], name) == 0 ? e : UINT32_MAX;
    }
    if (result == UINT32_MAX && state->event_count < BUCKETS_EVENTS)
    {
        result = state->event_count;
        snprintf(state->events[result], BUCKETS_NAME, "%s", name);
        state->event_count += 1;
    }
    return result;
}

static int buckets_compare_doubles(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return a < b ? -1 : a > b ? 1 : 0;
}

typedef struct BucketsRank BucketsRank;
struct BucketsRank
{
    uint32_t symbol;
    double value;
};

static int buckets_compare_ranks(const void* left, const void* right)
{
    const BucketsRank* a = left;
    const BucketsRank* b = right;
    return a->value > b->value ? -1 : a->value < b->value ? 1 : 0;
}

int main(int argc, char** argv)
{
    uint32_t functions = 0;
    const char* merge_first = 0;
    const char* merge_last = 0;
    const char* merge_name = 0;
    const char* anchor_prefixes[BUCKETS_ANCHORS] = { "parse_tokens_from_output", "check_input", "tier0_generate" };
    const char* anchor_stages[BUCKETS_ANCHORS] = { "parse", "check-input", "tier0" };
    uint32_t anchor_count = 3;
    bool anchors_given = false;
    const char* prefixes[BUCKETS_ANCHORS] = { 0 };
    uint32_t prefix_count = 0;
    int first_file = argc;
    bool valid = true;
    for (int i = 1; valid && i < argc && first_file == argc; i += 1)
    {
        if (strcmp(argv[i], "--functions") == 0 && i + 1 < argc)
        {
            functions = (uint32_t)strtoul(argv[++i], 0, 10);
        }
        else if (strcmp(argv[i], "--merge") == 0 && i + 3 < argc)
        {
            merge_first = argv[i + 1];
            merge_last = argv[i + 2];
            merge_name = argv[i + 3];
            i += 3;
        }
        else if (strcmp(argv[i], "--anchor") == 0 && i + 2 < argc)
        {
            anchor_count = anchors_given ? anchor_count : 0;
            anchors_given = true;
            valid = anchor_count < BUCKETS_ANCHORS;
            if (valid)
            {
                anchor_prefixes[anchor_count] = argv[i + 1];
                anchor_stages[anchor_count] = argv[i + 2];
                anchor_count += 1;
            }
            i += 2;
        }
        else if (strcmp(argv[i], "--prefix") == 0 && i + 1 < argc)
        {
            valid = prefix_count < BUCKETS_ANCHORS;
            if (valid)
            {
                prefixes[prefix_count] = argv[i + 1];
                prefix_count += 1;
            }
            i += 1;
        }
        else if (argv[i][0] == '-' && argv[i][1] == '-')
        {
            valid = false;
        }
        else
        {
            first_file = i;
        }
    }
    valid = valid && first_file < argc && (argc - first_file) % 2 == 0;
    if (!valid)
    {
        fprintf(stderr, "usage: stagebuckets [--functions N] [--merge FIRST LAST NAME] [--anchor PREFIX STAGE]... [--prefix PREFIX]... STAGES SAMPLES [STAGES SAMPLES]...\n");
    }
    BucketsState* state = valid ? calloc(1, sizeof(BucketsState)) : 0;
    bool succeeded = state != 0;
    if (succeeded)
    {
        state->symbols = calloc(BUCKETS_SYMBOLS, BUCKETS_NAME);
        state->slots = calloc(2 * BUCKETS_SYMBOLS, sizeof(uint32_t));
        state->functions = calloc((size_t)(BUCKETS_STAGES + 2) * BUCKETS_SYMBOLS * BUCKETS_EVENTS, sizeof(double));
        succeeded = state->symbols != 0 && state->slots != 0 && state->functions != 0;
    }
    uint32_t runs = 0;
    for (int f = first_file; succeeded && f + 1 < argc; f += 2)
    {
        // The run's stages: its top-level time-stage lines, in order.
        char names[BUCKETS_STAGES][BUCKETS_NAME];
        double ends[BUCKETS_STAGES];
        uint32_t count = 0;
        const bool whole = strcmp(argv[f], "-") == 0;
        FILE* report = whole ? 0 : fopen(argv[f], "r");
        succeeded = whole || report != 0;
        char line[4096];
        double clock = 0.0;
        if (whole)
        {
            snprintf(names[0], BUCKETS_NAME, "all");
            ends[0] = 1e300;
            count = 1;
        }
        while (succeeded && report != 0 && fgets(line, sizeof(line), report) != 0)
        {
            char name[BUCKETS_NAME];
            double ms = 0.0;
            if (sscanf(line, "time-stage\t%159[^\t]\t%lf", name, &ms) == 2 && strchr(name, '.') == 0 && strcmp(name, "total") != 0 && count < BUCKETS_STAGES)
            {
                clock += ms;
                snprintf(names[count], BUCKETS_NAME, "%s", name);
                ends[count] = clock;
                count += 1;
            }
        }
        if (report != 0)
        {
            fclose(report);
        }
        succeeded = succeeded && count != 0;
        // The reported stages, from the first run; each run's stage s reports as map[s].
        uint32_t map[BUCKETS_STAGES];
        bool merging = false;
        uint32_t reported = 1;
        for (uint32_t s = 0; succeeded && s < count; s += 1)
        {
            const bool starts = merge_first != 0 && strcmp(names[s], merge_first) == 0;
            if (starts || !merging)
            {
                if (runs == 0)
                {
                    snprintf(state->stages[reported], BUCKETS_NAME, "%.159s", starts ? merge_name : names[s]);
                }
                reported += 1;
            }
            merging = merging || starts;
            map[s] = reported - 1;
            merging = merging && strcmp(names[s], merge_last) != 0;
        }
        if (succeeded && runs == 0)
        {
            snprintf(state->stages[0], BUCKETS_NAME, "before");
            snprintf(state->stages[reported], BUCKETS_NAME, "after");
            state->stage_count = reported + 1;
        }
        succeeded = succeeded && reported + 1 == state->stage_count;
        // The run's samples.
        const size_t length = strlen(argv[f + 1]);
        const bool zipped = length > 3 && strcmp(argv[f + 1] + length - 3, ".gz") == 0;
        char command[4096];
        snprintf(command, sizeof(command), "gzip -dc '%s'", argv[f + 1]);
        FILE* text = succeeded ? (zipped ? popen(command, "r") : fopen(argv[f + 1], "r")) : 0;
        succeeded = succeeded && text != 0;
        BucketsSample* samples = 0;
        uint64_t sample_count = 0;
        uint64_t capacity = 0;
        while (succeeded && fgets(line, sizeof(line), text) != 0)
        {
            double seconds = 0.0;
            uint64_t period = 0;
            char event[BUCKETS_NAME];
            char address[64];
            int consumed = 0;
            if (sscanf(line, " %lf: %" SCNu64 " %159s %63s %n", &seconds, &period, event, address, &consumed) == 4 && consumed > 0)
            {
                const size_t event_length = strlen(event);
                if (event_length > 0 && event[event_length - 1] == ':')
                {
                    event[event_length - 1] = 0;
                }
                char* symbol = line + consumed;
                symbol[strcspn(symbol, "\n")] = 0;
                if (sample_count == capacity)
                {
                    capacity = capacity == 0 ? 65536 : capacity * 2;
                    samples = realloc(samples, capacity * sizeof(BucketsSample));
                    succeeded = samples != 0;
                }
                if (succeeded)
                {
                    const uint32_t e = buckets_event(state, event);
                    samples[sample_count] = (BucketsSample){ .ms = seconds * 1000.0, .period = period, .event = e, .symbol = buckets_symbol(state, symbol) };
                    sample_count += e != UINT32_MAX ? 1 : 0;
                }
            }
        }
        if (text != 0)
        {
            if (zipped)
            {
                pclose(text);
            }
            else
            {
                fclose(text);
            }
        }
        // The clock's start on perf's clock.
        double estimates[BUCKETS_ANCHORS];
        uint32_t estimate_count = 0;
        if (whole)
        {
            estimates[estimate_count++] = 0.0;
        }
        for (uint32_t a = 0; succeeded && !whole && a < anchor_count; a += 1)
        {
            double before = -1.0;
            for (uint32_t s = 0; s < count; s += 1)
            {
                if (strcmp(names[s], anchor_stages[a]) == 0)
                {
                    before = s == 0 ? 0.0 : ends[s - 1];
                }
            }
            double first = -1.0;
            const size_t prefix = strlen(anchor_prefixes[a]);
            for (uint64_t i = 0; before >= 0.0 && i < sample_count; i += 1)
            {
                if (strncmp(state->symbols[samples[i].symbol], anchor_prefixes[a], prefix) == 0 && (first < 0.0 || samples[i].ms < first))
                {
                    first = samples[i].ms;
                }
            }
            if (first >= 0.0)
            {
                estimates[estimate_count++] = first - before;
            }
        }
        succeeded = succeeded && estimate_count != 0;
        if (succeeded)
        {
            qsort(estimates, estimate_count, sizeof(double), buckets_compare_doubles);
            const double offset = estimates[estimate_count / 2];
            printf("# %s: %" PRIu64 " samples, %u estimates of the clock's start, spread %.3f ms\n", argv[f + 1], sample_count, estimate_count,
                   estimates[estimate_count - 1] - estimates[0]);
            for (uint64_t i = 0; i < sample_count; i += 1)
            {
                const double ms = samples[i].ms - offset;
                uint32_t stage = ms < 0.0 ? 0 : state->stage_count - 1;
                for (uint32_t s = 0; ms >= 0.0 && s < count; s += 1)
                {
                    if (ms < ends[s])
                    {
                        stage = map[s];
                        break;
                    }
                }
                state->totals[stage][samples[i].event] += (double)samples[i].period;
                state->functions[((size_t)stage * BUCKETS_SYMBOLS + samples[i].symbol) * BUCKETS_EVENTS + samples[i].event] += (double)samples[i].period;
            }
            runs += 1;
        }
        free(samples);
    }
    if (succeeded && runs != 0)
    {
        printf("# %u runs\nstage", runs);
        for (uint32_t e = 0; e < state->event_count; e += 1)
        {
            printf("\t%s", state->events[e]);
        }
        printf("\n");
        double sums[BUCKETS_EVENTS] = { 0 };
        for (uint32_t s = 0; s < state->stage_count; s += 1)
        {
            printf("%s", state->stages[s]);
            for (uint32_t e = 0; e < state->event_count; e += 1)
            {
                printf("\t%.0f", state->totals[s][e] / runs);
                sums[e] += state->totals[s][e] / runs;
            }
            printf("\n");
        }
        printf("total");
        for (uint32_t e = 0; e < state->event_count; e += 1)
        {
            printf("\t%.0f", sums[e]);
        }
        printf("\n");
        for (uint32_t p = 0; p < prefix_count; p += 1)
        {
            const size_t length = strlen(prefixes[p]);
            printf("## functions named %s*\n", prefixes[p]);
            for (uint32_t s = 0; s < state->stage_count; s += 1)
            {
                double inside[BUCKETS_EVENTS] = { 0 };
                for (uint32_t symbol = 1; symbol <= state->symbol_count; symbol += 1)
                {
                    if (strncmp(state->symbols[symbol], prefixes[p], length) == 0)
                    {
                        for (uint32_t e = 0; e < state->event_count; e += 1)
                        {
                            inside[e] += state->functions[((size_t)s * BUCKETS_SYMBOLS + symbol) * BUCKETS_EVENTS + e];
                        }
                    }
                }
                if (inside[0] > 0.0)
                {
                    printf("%s", state->stages[s]);
                    for (uint32_t e = 0; e < state->event_count; e += 1)
                    {
                        printf("\t%.0f", inside[e] / runs);
                    }
                    printf("\n");
                }
            }
        }
        BucketsRank* ranks = functions != 0 ? calloc(BUCKETS_SYMBOLS, sizeof(BucketsRank)) : 0;
        for (uint32_t s = 0; ranks != 0 && s < state->stage_count; s += 1)
        {
            if (state->totals[s][0] / runs < 0.002 * sums[0])
            {
                continue;
            }
            uint32_t ranked = 0;
            for (uint32_t symbol = 0; symbol <= state->symbol_count; symbol += 1)
            {
                const double value = state->functions[((size_t)s * BUCKETS_SYMBOLS + symbol) * BUCKETS_EVENTS];
                if (value > 0.0)
                {
                    ranks[ranked++] = (BucketsRank){ .symbol = symbol, .value = value };
                }
            }
            qsort(ranks, ranked, sizeof(BucketsRank), buckets_compare_ranks);
            printf("## %s\n", state->stages[s]);
            for (uint32_t r = 0; r < ranked && r < functions; r += 1)
            {
                printf("%s", state->symbols[ranks[r].symbol]);
                for (uint32_t e = 0; e < state->event_count; e += 1)
                {
                    printf("\t%.0f", state->functions[((size_t)s * BUCKETS_SYMBOLS + ranks[r].symbol) * BUCKETS_EVENTS + e] / runs);
                }
                printf("\n");
            }
        }
        free(ranks);
    }
    return succeeded && runs != 0 ? 0 : 1;
}
