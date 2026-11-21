// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// Compile with cc -std=c17 -O2 scripts/summary.c -o summary. Pass all raw *.out files.
// The rates below are recalculated from the integer totals and the calibrated empty interval.
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { CORPORA = 3, FAMILIES = 3, EVENTS = 6, SWEEPS = 12, ROUNDS = 7, GROUPS = CORPORA * EVENTS * SWEEPS };

typedef struct Group Group;
struct Group
{
    char corpus[16];
    char family[16];
    char sweep[20];
    char event[24];
    uint64_t chunks;
    uint64_t records;
    uint64_t raw[ROUNDS][2];
    uint64_t empty[ROUNDS][2];
    bool seen[ROUNDS][2];
};

static Group groups[GROUPS];
static uint32_t group_count;

static int compare(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return (a > b) - (a < b);
}

static bool collect(const char* path)
{
    const char* base = strrchr(path, '/');
    base = base == NULL ? path : base + 1;
    const char* corpus = strrchr(base, '-');
    const long round = strtol(base, NULL, 10);
    bool valid = round >= 1 && round <= ROUNDS && corpus != NULL;
    char name[16] = { 0 };
    valid = valid && sscanf(corpus + 1, "%15[^.]", name) == 1;
    FILE* input = valid ? fopen(path, "r") : NULL;
    valid = valid && input != NULL;
    char line[32768];
    unsigned rows = 0;
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        if (strncmp(line, "node-window-counter: ", 21) == 0)
        {
            char family[16], sweep[20], event[24], run[8];
            uint64_t chunks, records, raw, empty;
            const int fields = sscanf(line, "node-window-counter: family=%15s sweep=%19s event=%23s run=%7s chunks=%" SCNu64
                                      " records=%" SCNu64 " raw=%" SCNu64 " empty-per-chunk=%" SCNu64,
                                      family, sweep, event, run, &chunks, &records, &raw, &empty);
            valid = fields == 8 && chunks != 0 && records != 0 && (strcmp(run, "first") == 0 || strcmp(run, "second") == 0);
            if (valid)
            {
                unsigned i = 0;
                while (i < group_count && (strcmp(groups[i].corpus, name) || strcmp(groups[i].family, family) ||
                       strcmp(groups[i].sweep, sweep) || strcmp(groups[i].event, event)))
                {
                    i += 1;
                }
                if (i == group_count && i < GROUPS)
                {
                    strcpy(groups[i].corpus, name);
                    strcpy(groups[i].family, family);
                    strcpy(groups[i].sweep, sweep);
                    strcpy(groups[i].event, event);
                    groups[i].chunks = chunks;
                    groups[i].records = records;
                    group_count += 1;
                }
                const unsigned turn = strcmp(run, "second") == 0;
                valid = i < GROUPS && !groups[i].seen[round - 1][turn] && groups[i].chunks == chunks && groups[i].records == records;
                if (valid)
                {
                    groups[i].raw[round - 1][turn] = raw;
                    groups[i].empty[round - 1][turn] = empty;
                    groups[i].seen[round - 1][turn] = true;
                    rows += 1;
                }
            }
        }
    }
    if (input != NULL)
    {
        valid = !ferror(input) && rows != 0 && valid;
        fclose(input);
    }
    if (!valid)
    {
        fprintf(stderr, "invalid sample %s\n", path);
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 1 + CORPORA * FAMILIES * EVENTS * ROUNDS;
    for (int i = 1; valid && i < argc; i += 1)
    {
        valid = collect(argv[i]);
    }
    valid = valid && group_count == GROUPS;
    if (valid)
    {
        puts("corpus\tfamily\tsweep\tevent\tchunks\trecords\trounds\tfirst/chunk\tsecond/chunk\tfirst/record\tsecond/record\tpaired-extra/chunk\tmin-extra/chunk\tmax-extra/chunk");
    }
    for (uint32_t i = 0; valid && i < group_count; i += 1)
    {
        const Group* g = &groups[i];
        double first[ROUNDS], second[ROUNDS], extra[ROUNDS];
        unsigned n = 0;
        for (unsigned r = 0; r < ROUNDS; r += 1)
        {
            valid = valid && g->seen[r][0] == g->seen[r][1];
            if (g->seen[r][0] && g->seen[r][1])
            {
                first[n] = (double)g->raw[r][0] / (double)g->chunks - (double)g->empty[r][0];
                second[n] = (double)g->raw[r][1] / (double)g->chunks - (double)g->empty[r][1];
                extra[n] = first[n] - second[n];
                n += 1;
            }
        }
        valid = valid && n == ROUNDS;
        if (valid)
        {
            qsort(first, n, sizeof(*first), compare);
            qsort(second, n, sizeof(*second), compare);
            qsort(extra, n, sizeof(*extra), compare);
            const double unit = (double)g->chunks / (double)g->records;
            printf("%s\t%s\t%s\t%s\t%" PRIu64 "\t%" PRIu64 "\t%u\t%.3f\t%.3f\t%.6f\t%.6f\t%.3f\t%.3f\t%.3f\n",
                   g->corpus, g->family, g->sweep, g->event, g->chunks, g->records, n, first[n / 2], second[n / 2],
                   first[n / 2] * unit, second[n / 2] * unit, extra[n / 2], extra[0], extra[n - 1]);
        }
    }
    if (!valid)
    {
        fprintf(stderr, "expected seven complete rounds of three families and six events on each of three corpora\n");
    }
    return valid ? EXIT_SUCCESS : EXIT_FAILURE;
}
