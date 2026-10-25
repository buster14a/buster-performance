// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original measurement-log parser. Copyright (c) 2026 David Gonzalez Martin.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_REVIEW_MAX_SAMPLES 128

typedef struct Sample Sample;
struct Sample
{
    char matrix[128];
    unsigned tree;
    unsigned round;
    unsigned list;
    unsigned kind;
    double wall;
    double throughput;
    double cycles;
    double instructions;
    double wall_min;
    double wall_max;
    double cycles_min;
    double cycles_max;
    double user;
    double system;
    unsigned long long peak_kb;
};

static Sample samples[BUSTER_REVIEW_MAX_SAMPLES];
static unsigned sample_count;

static bool parse_file(const char* path)
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    char line[16384];
    const char* leaf = strrchr(path, '/');
    leaf = leaf != NULL ? leaf + 1 : path;
    const bool driver = strncmp(leaf, "drivers-", 8) == 0;
    const bool lexer = strncmp(leaf, "lexer-", 6) == 0;
    bool seen[3][2][2] = {0};
    unsigned round = 0;
    unsigned tree = 0;
    unsigned headers = 0;
    unsigned records = 0;
    unsigned timed = 0;
    unsigned done = 0;
    unsigned ab_done = 0;
    unsigned corpus_checks = 0;
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        char tree_name[64];
        unsigned next_round = 0;
        if (sscanf(line, "== round %u tree %63s", &next_round, tree_name) == 2)
        {
            valid = next_round >= 1 && next_round <= 3 && (strcmp(tree_name, "baseline-tree") == 0 || strcmp(tree_name, "head-tree") == 0);
            round = next_round;
            tree = strcmp(tree_name, "head-tree") == 0;
            headers += 1;
        }
        if (strstr(line, "FAILED") != NULL || strstr(line, "a run failed") != NULL)
        {
            valid = false;
        }
        if (strncmp(line, "ab: done,", 9) == 0)
        {
            unsigned failures = 1;
            valid = valid && sscanf(line, "ab: done, %u failed runs", &failures) == 1 && failures == 0;
            ab_done += 1;
        }
        if (lexer && strncmp(line, "corpus: ", 8) == 0)
        {
            unsigned differences = 1;
            valid = valid && sscanf(line, "corpus: %u files differ", &differences) == 1 && differences == 0;
            corpus_checks += 1;
        }
        if (driver && strncmp(line, "run ", 4) == 0)
        {
            const char* status = strstr(line, "status ");
            valid = valid && status != NULL && atoi(status + 7) == 0;
            timed += 1;
        }
        if (strncmp(line, "time-runs: done,", 16) == 0)
        {
            unsigned failures = 1;
            valid = valid && sscanf(line, "time-runs: done, %u failed processes", &failures) == 1 && failures == 0;
            done += 1;
        }

        Sample one = {0};
        bool found = false;
        if (lexer)
        {
            found = sscanf(line, " c_tokenize %lf ms %lf GB/s %lf cycles/B [%lf-%lf] %lf instructions/B", &one.wall, &one.throughput,
                           &one.cycles, &one.cycles_min, &one.cycles_max, &one.instructions) == 6;
        }
        else if (!driver)
        {
            double output_cycles = 0;
            double ipc = 0;
            found = sscanf(line, " vectorized %lf ms %lf cycles/input token %lf cycles/output token %lf instructions/input token IPC %lf",
                           &one.wall, &one.cycles, &output_cycles, &one.instructions, &ipc) == 5;
            one.kind = 1;
        }
        else if (strncmp(line, "list ", 5) == 0)
        {
            const char* metrics = strstr(line, "]: ");
            unsigned runs = 0;
            found = metrics != NULL && sscanf(line, "list %u", &one.list) == 1 &&
                    sscanf(metrics + 3, "%u runs, median %lf ms wall (%lf to %lf), %lf ms user, %lf ms system, %llu KB peak",
                           &runs, &one.wall, &one.wall_min, &one.wall_max, &one.user, &one.system, &one.peak_kb) == 7;
            valid = valid && (!found || (runs == 9 && one.list >= 1 && one.list <= 2));
            one.kind = 2;
        }
        if (found)
        {
            const unsigned slot = driver ? one.list - 1 : 0;
            valid = valid && round >= 1 && round <= 3 && slot < 2 && sample_count < BUSTER_REVIEW_MAX_SAMPLES;
            if (valid)
            {
                valid = !seen[round - 1][tree][slot];
                seen[round - 1][tree][slot] = true;
                one.round = round;
                one.tree = tree;
                valid = valid && snprintf(one.matrix, sizeof(one.matrix), "%s", leaf) < (int)sizeof(one.matrix);
                if (valid)
                {
                    samples[sample_count++] = one;
                    records += 1;
                }
            }
        }
    }
    if (file != NULL)
    {
        valid = valid && !ferror(file);
        fclose(file);
    }
    valid = valid && headers == 6 && ab_done == 1 && records == (driver ? 12u : 6u) && (!lexer || corpus_checks == 6) && (!driver || (timed == 108 && done == 6));
    if (!valid)
    {
        fprintf(stderr, "%s: invalid/incomplete log (headers=%u records=%u timed=%u done=%u)\n", path, headers, records, timed, done);
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc > 1;
    for (int i = 1; i < argc; i += 1)
    {
        valid = parse_file(argv[i]) && valid;
    }
    if (valid)
    {
        printf("matrix,tree,round,list,kind,wall_ms,GBps,cycles_per_unit,instructions_per_unit,peak_KB,wall_min_ms,wall_max_ms,cycles_min,cycles_max,user_ms,system_ms\n");
        for (unsigned i = 0; i < sample_count; i += 1)
        {
            const Sample* s = &samples[i];
            printf("%s,%s,%u,%u,%u,%.6f,%.6f,%.6f,%.6f,%llu,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n", s->matrix,
                   s->tree ? "head" : "base", s->round, s->list, s->kind, s->wall, s->throughput, s->cycles, s->instructions,
                   s->peak_kb, s->wall_min, s->wall_max, s->cycles_min, s->cycles_max, s->user, s->system);
        }
    }
    return valid ? 0 : 1;
}
