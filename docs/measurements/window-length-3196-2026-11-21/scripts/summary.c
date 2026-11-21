// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    uint64_t chunks, swept, candidates, taken, records, entries;
    uint64_t ticks[2];
} Sample;

static bool parse_field(const char* line, const char* field, uint64_t* out)
{
    const char* start = strstr(line, field);
    if (start == NULL) return false;
    start += strlen(field);
    char* end = NULL;
    *out = strtoull(start, &end, 10);
    return end != start;
}

static bool read_sample(const char* base, Sample* s)
{
    char name[512];
    snprintf(name, sizeof(name), "%s.status", base);
    FILE* status = fopen(name, "r");
    if (status == NULL) return false;
    int ret = -1;
    bool ok = fscanf(status, "%d", &ret) == 1 && ret == 0;
    fclose(status);
    snprintf(name, sizeof(name), "%s.out", base);
    FILE* f = fopen(name, "r");
    if (f == NULL) return false;
    bool seen[4] = { false };
    char line[4096];
    while (ok && fgets(line, sizeof(line), f))
    {
        uint64_t n = 0;
        if (strstr(line, "node-shadow: window tests expressions="))
        {
            seen[0] = parse_field(line, " chunks=", &s->chunks);
        }
        if (strstr(line, "node-shadow: window rows expressions="))
        {
            seen[1] = parse_field(line, " expressions=", &s->candidates) && parse_field(line, " taken=", &s->taken) &&
                      parse_field(line, " their-records=", &s->records) && parse_field(line, " their-entries=", &s->entries) &&
                      parse_field(line, " records-swept=", &s->swept) && parse_field(line, " differences=", &n) && n == 0 &&
                      parse_field(line, " second-runs-that-differ=", &n) && n == 0;
        }
        if (strstr(line, "node-shadow: window rows ticks=")) seen[2] = parse_field(line, " ticks=", &s->ticks[0]);
        if (strstr(line, "node-shadow: window rows a second run over the same chunk")) seen[3] = parse_field(line, " ticks=", &s->ticks[1]);
    }
    ok = ok && !ferror(f) && seen[0] && seen[1] && seen[2] && seen[3] && s->chunks && s->swept && s->taken && s->entries;
    fclose(f);
    return ok;
}

static int cmp(const void* a, const void* b)
{
    double x = *(const double*)a, y = *(const double*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    int rounds = argc == 3 ? atoi(argv[2]) : 7;
    if ((argc != 2 && argc != 3) || rounds < 1 || rounds > 7) return 1;
    const char* corpora[] = { "sqlite", "lua", "musl" };
    puts("corpus\twindow\tchunks\trecords swept\texpressions offered\texpressions taken\ttaken records\ttaken entries\tread\tmedian ticks per record\tmin\tmax");
    for (size_t c = 0; c < 3; ++c)
    {
        Sample expected[2] = { 0 };
        double readings[3][2][7] = { 0 };
        for (int r = 1; r <= rounds; ++r)
        {
            for (int idx = 0; idx < 4; ++idx)
            {
                int size = ((idx == 1 || idx == 2) == (r % 2 == 1)) ? 2 : 1;
                char file[480];
                snprintf(file, sizeof(file), "%s/%d-%d-%d-%s", argv[1], r, idx, size, corpora[c]);
                Sample s = { 0 };
                if (!read_sample(file, &s)) { fprintf(stderr, "missing or invalid %s\n", file); return 1; }
                Sample* e = &expected[size - 1];
                if (e->chunks && (s.chunks != e->chunks || s.swept != e->swept || s.candidates != e->candidates ||
                    s.taken != e->taken || s.records != e->records || s.entries != e->entries)) return 1;
                *e = s;
                for (int t = 0; t < 2; ++t) readings[size - 1][t][r - 1] += (double)s.ticks[t] / (double)s.swept / 2.0;
            }
            for (int t = 0; t < 2; ++t) readings[2][t][r - 1] = readings[1][t][r - 1] - readings[0][t][r - 1];
        }
        for (int i = 0; i < 3; ++i)
        {
            for (int t = 0; t < 2; ++t)
            {
                double* list = readings[i][t];
                qsort(list, (size_t)rounds, sizeof(double), cmp);
                const double med = (list[rounds / 2] + list[(rounds - 1) / 2]) / 2;
                if (i == 2) printf("%s\ttwo-minus-one\t-\t-\t-\t-\t-\t-", corpora[c]);
                else
                {
                    const Sample* s = &expected[i];
                    printf("%s\t%d\t%"PRIu64"\t%"PRIu64"\t%"PRIu64"\t%"PRIu64"\t%"PRIu64"\t%"PRIu64,
                           corpora[c], i + 1, s->chunks, s->swept, s->candidates, s->taken, s->records, s->entries);
                }
                printf("\t%s\t%.5f\t%.5f\t%.5f\n", t ? "repeat" : "first", med, list[0], list[rounds - 1]);
            }
        }
    }
    return 0;
}
