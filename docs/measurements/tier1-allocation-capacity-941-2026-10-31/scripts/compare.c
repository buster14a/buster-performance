// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Qualification harness for buster PR #941 (buster-performance record).
//
// compare MAIN.txt HEAD.txt pairs capacity.c's lines from main's build and the change's, case by case and entry
// point by entry point, and exits with status 1 unless:
// - both builds take the vector path (host_vector 1), ran the same cases and report no violation;
// - every ample outcome is the same: the status, and for a success the hash of every public field and the retained
//   bytes;
// - no boundary is higher in the change's build: none of its failures is a capacity at which main succeeds or
//   gives its refusal;
// - every difference is the one the change makes to the arena: tier1_allocate no longer pushes the old coloring's
//   parents, next, deltas and pressure columns (4, 4, 8 and 8 bytes per interval, every column and every push after
//   them 4-byte aligned), so for a call that gets past the input validation its boundary, and a success's scratch
//   bytes, are 24 bytes per interval lower, and tier1_allocate_scalar's are the same.
// Each capacity from the change's boundary to main's is one where main runs out of room and the change does what
// both do with ample room: a success, or the same refusal. It prints the comparison by entry point and kind.
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum
{
    COMPARE_PREFIX = 19,
    COMPARE_MAXIMUM = 8192,
    COMPARE_REMOVED_BYTES = 24,
};

typedef struct Line Line;
struct Line
{
    uint32_t number;
    char label[128];
    char path[64];
    uint32_t intervals;
    uint32_t uses;
    uint32_t fixed;
    int32_t ample;
    uint64_t hash;
    uint64_t retained;
    uint64_t scratch;
    uint64_t peak;
    uint64_t boundary;
    char sweep[32];
    uint64_t probes;
    uint64_t capacity_failures;
    uint64_t violations;
};

typedef struct Run Run;
struct Run
{
    Line lines[COMPARE_MAXIMUM];
    uint32_t count;
    int32_t host_vector;
    uint64_t calls;
    uint64_t violations;
    bool finished;
};

static Run runs[2];

static bool compare_read(const char* name, Run* run)
{
    FILE* file = fopen(name, "r");
    bool valid = file != 0;
    char text[1024];
    run->host_vector = -1;
    while (valid && fgets(text, sizeof(text), file) != 0)
    {
        if (strncmp(text, "case ", 5) == 0 && strstr(text, " intervals ") != 0)
        {
            valid = run->count < COMPARE_MAXIMUM;
            Line* line = &run->lines[run->count];
            valid = valid && sscanf(text, "case %" SCNu32 " %127s %63[^:]: intervals %" SCNu32 " uses %" SCNu32 " fixed %" SCNu32 " ample %" SCNd32 " hash %" SCNx64 " retained %" SCNu64 " scratch %" SCNu64 " peak %" SCNu64 " boundary %" SCNu64 " sweep %31s probes %" SCNu64 " capacity-failures %" SCNu64 " violations %" SCNu64, &line->number, line->label, line->path, &line->intervals, &line->uses, &line->fixed, &line->ample, &line->hash, &line->retained, &line->scratch, &line->peak, &line->boundary, line->sweep, &line->probes, &line->capacity_failures, &line->violations) == 16;
            run->count += valid ? 1 : 0;
        }
        else if (strncmp(text, "host_vector ", 12) == 0)
        {
            valid = sscanf(text, "host_vector %" SCNd32, &run->host_vector) == 1;
        }
        else if (strncmp(text, "cases ", 6) == 0)
        {
            uint32_t cases = 0;
            valid = sscanf(text, "cases %" SCNu32 " calls %" SCNu64 " violations %" SCNu64, &cases, &run->calls, &run->violations) == 3;
            run->finished = valid && cases * 2 == run->count;
        }
    }
    if (file != 0)
    {
        fclose(file);
    }
    if (!valid)
    {
        printf("compare: can't read %s\n", name);
    }
    return valid && run->finished;
}

// The kind of a case's ample outcome: a success, a refusal before the arena's pushes (its boundary is the prefix),
// one after them, or an impossible constraint.
static uint32_t compare_kind(const Line* line)
{
    uint32_t kind = 0;
    if (line->ample == 1)
    {
        kind = line->boundary == COMPARE_PREFIX ? 1 : 2;
    }
    else if (line->ample == 3)
    {
        kind = 3;
    }
    else if (line->ample != 0)
    {
        kind = 4;
    }
    return kind;
}

typedef struct Tally Tally;
struct Tally
{
    uint32_t cases;
    uint32_t exhaustive;
    uint32_t equal;
    uint32_t lower;
    uint32_t higher;
    uint32_t explained;
    uint64_t improved;
    int64_t smallest;
    int64_t largest;
    uint64_t probes;
    uint64_t capacity_failures;
};

int main(int argc, char** argv)
{
    bool valid = argc == 3 && compare_read(argv[1], &runs[0]) && compare_read(argv[2], &runs[1]);
    if (argc != 3)
    {
        printf("usage: compare MAIN.txt HEAD.txt\n");
    }
    valid = valid && runs[0].count == runs[1].count;
    if (valid && (runs[0].host_vector != 1 || runs[1].host_vector != 1))
    {
        printf("compare: a build doesn't take the vector path (host_vector %d and %d)\n", runs[0].host_vector, runs[1].host_vector);
        valid = false;
    }
    static const char* const kinds[] = { "success", "refused before allocating", "refused after allocating", "impossible constraint", "other" };
    Tally tallies[2][5];
    memset(tallies, 0, sizeof(tallies));
    uint32_t mismatches = 0;
    uint32_t regressions = 0;
    uint32_t unexplained = 0;
    uint32_t violated = 0;
    uint64_t scratch_saved = 0;
    for (uint32_t i = 0; valid && i < runs[0].count; i += 1)
    {
        const Line* main_line = &runs[0].lines[i];
        const Line* head_line = &runs[1].lines[i];
        const uint32_t path = strcmp(main_line->path, "tier1_allocate") == 0 ? 0 : 1;
        if (main_line->number != head_line->number || strcmp(main_line->label, head_line->label) != 0 || strcmp(main_line->path, head_line->path) != 0 || main_line->intervals != head_line->intervals || main_line->uses != head_line->uses || main_line->fixed != head_line->fixed)
        {
            printf("compare: line %u pairs different cases\n", i);
            valid = false;
        }
        const bool same = main_line->ample == head_line->ample && (main_line->ample != 0 || (main_line->hash == head_line->hash && main_line->retained == head_line->retained));
        if (!same)
        {
            printf("ample outcomes differ: case %u %s %s: main %d %016" PRIx64 " %" PRIu64 ", head %d %016" PRIx64 " %" PRIu64 "\n", main_line->number, main_line->label, main_line->path, main_line->ample, main_line->hash, main_line->retained, head_line->ample, head_line->hash, head_line->retained);
            mismatches += 1;
        }
        if (main_line->violations != 0 || head_line->violations != 0)
        {
            violated += 1;
        }
        const int64_t delta = (int64_t)main_line->boundary - (int64_t)head_line->boundary;
        const bool allocates = main_line->boundary != COMPARE_PREFIX;
        const int64_t expected = path == 0 && allocates ? (int64_t)main_line->intervals * COMPARE_REMOVED_BYTES : 0;
        const bool scratch_expected = main_line->ample != 0 || (int64_t)main_line->scratch - (int64_t)head_line->scratch == expected;
        if (delta < 0)
        {
            printf("head's boundary is higher: case %u %s %s: main %" PRIu64 ", head %" PRIu64 "\n", main_line->number, main_line->label, main_line->path, main_line->boundary, head_line->boundary);
            regressions += 1;
        }
        if (delta != expected || !scratch_expected)
        {
            printf("unexplained difference: case %u %s %s: boundary main %" PRIu64 " head %" PRIu64 ", scratch main %" PRIu64 " head %" PRIu64 ", expected %" PRId64 "\n", main_line->number, main_line->label, main_line->path, main_line->boundary, head_line->boundary, main_line->scratch, head_line->scratch, expected);
            unexplained += 1;
        }
        scratch_saved += main_line->ample == 0 ? main_line->scratch - head_line->scratch : 0;
        Tally* tally = &tallies[path][compare_kind(main_line)];
        tally->smallest = tally->cases == 0 || delta < tally->smallest ? delta : tally->smallest;
        tally->largest = tally->cases == 0 || delta > tally->largest ? delta : tally->largest;
        tally->cases += 1;
        tally->exhaustive += strcmp(main_line->sweep, "exhaustive") == 0 && strcmp(head_line->sweep, "exhaustive") == 0 ? 1 : 0;
        tally->equal += delta == 0 ? 1 : 0;
        tally->lower += delta > 0 ? 1 : 0;
        tally->higher += delta < 0 ? 1 : 0;
        tally->explained += delta == expected && scratch_expected ? 1 : 0;
        tally->improved += delta > 0 ? (uint64_t)delta : 0;
        tally->probes += main_line->probes + head_line->probes;
        tally->capacity_failures += main_line->capacity_failures + head_line->capacity_failures;
    }
    if (valid)
    {
        printf("| Entry point | Ample outcome | Cases | Swept byte by byte | Same boundary | Lower in head | Higher in head | As the removed columns predict | Capacities main fails and head doesn't | Boundary difference, bytes | Calls | CAPACITY failures |\n");
        printf("| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | ---: | ---: |\n");
        for (uint32_t path = 0; path < 2; path += 1)
        {
            for (uint32_t kind = 0; kind < 5; kind += 1)
            {
                const Tally* tally = &tallies[path][kind];
                if (tally->cases != 0)
                {
                    printf("| `%s` | %s | %u | %u | %u | %u | %u | %u | %" PRIu64 " | %" PRId64 " to %" PRId64 " | %" PRIu64 " | %" PRIu64 " |\n", path == 0 ? "tier1_allocate" : "tier1_allocate_scalar", kinds[kind], tally->cases, tally->exhaustive, tally->equal, tally->lower, tally->higher, tally->explained, tally->improved, tally->smallest, tally->largest, tally->probes, tally->capacity_failures);
                }
            }
        }
        printf("main: %u lines, %" PRIu64 " calls, %" PRIu64 " violations; head: %u lines, %" PRIu64 " calls, %" PRIu64 " violations\n", runs[0].count, runs[0].calls, runs[0].violations, runs[1].count, runs[1].calls, runs[1].violations);
        printf("ample outcomes that differ %u, boundaries higher in head %u, differences the removed columns don't explain %u, case lines with violations %u, scratch bytes saved by successes %" PRIu64 "\n", mismatches, regressions, unexplained, violated, scratch_saved);
    }
    const bool passed = valid && mismatches == 0 && regressions == 0 && unexplained == 0 && violated == 0 && runs[0].violations == 0 && runs[1].violations == 0;
    printf("compare: %s\n", passed ? "passed" : "FAILED");
    return passed ? 0 : 1;
}
