// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original bounded reader for this record's raw benchmark samples.

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FOREIGN_COST_GROUPS 320
#define FOREIGN_COST_RUNS 21

typedef struct ForeignCostSamples ForeignCostSamples;
struct ForeignCostSamples
{
    uint64_t values[FOREIGN_COST_RUNS];
    uint32_t seen;
};

static int foreign_cost_compare(const void* a, const void* b)
{
    const uint64_t first = *(const uint64_t*)a;
    const uint64_t second = *(const uint64_t*)b;
    return (first > second) - (first < second);
}

int main(int argc, char** argv)
{
    ForeignCostSamples samples[FOREIGN_COST_GROUPS] = { 0 };
    FILE* file = argc == 3 ? fopen(argv[1], "r") : 0;
    bool valid = file != 0;
    char line[4096];
    uint32_t records = 0;
    while (valid && fgets(line, sizeof(line), file) != 0)
    {
        if (strncmp(line, "RAW,", 4) == 0)
        {
            unsigned long long group = 0;
            unsigned long long value = 0;
            unsigned int count = 0;
            unsigned int run = 0;
            char suffix = 0;
            const int fields = sscanf(line, "RAW,%llu,%u,%u,%llu %c", &group, &count, &run, &value, &suffix);
            valid = fields == 4 && group < FOREIGN_COST_GROUPS && count == FOREIGN_COST_RUNS && run < FOREIGN_COST_RUNS;
            if (valid)
            {
                const uint32_t bit = 1u << run;
                valid = (samples[group].seen & bit) == 0;
                samples[group].values[run] = value;
                samples[group].seen |= bit;
                records += 1;
            }
        }
    }
    if (file != 0)
    {
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    valid = records == FOREIGN_COST_GROUPS * FOREIGN_COST_RUNS && valid;
    for (uint32_t group = 0; valid && group < FOREIGN_COST_GROUPS; group += 1)
    {
        valid = samples[group].seen == (1u << FOREIGN_COST_RUNS) - 1;
    }
    if (valid)
    {
        static const uint32_t functions[] = { 1, 1, 2000, 2000, 2000, 102400, 102400, 102400 };
        static const char* const kinds[] = { "dynamic", "static", "dynamic", "static", "members", "dynamic", "static", "members" };
        static const char* const metrics[] = { "whole", "open", "indices", "headers", "symbols", "exchange", "resolve", "load", "groups", "winners" };
        printf("dataset,functions,kind,lanes,path,metric,count,min_ns,median_ns,max_ns,mean_ns\n");
        for (uint32_t group = 0; group < FOREIGN_COST_GROUPS; group += 1)
        {
            const uint32_t row = group / 10;
            const uint32_t input = row / 4;
            const uint32_t lanes = (row % 4) / 2 == 0 ? 1 : 8;
            const char* path = row % 2 == 0 ? "vector" : "exact";
            uint64_t total = 0;
            for (uint32_t run = 0; run < FOREIGN_COST_RUNS; run += 1)
            {
                total += samples[group].values[run];
            }
            qsort(samples[group].values, FOREIGN_COST_RUNS, sizeof(uint64_t), foreign_cost_compare);
            printf("%s,%u,%s,%u,%s,%s,%u,%llu,%llu,%llu,%.3f\n", argv[2], functions[input], kinds[input], lanes, path, metrics[group % 10], FOREIGN_COST_RUNS,
                   (unsigned long long)samples[group].values[0], (unsigned long long)samples[group].values[FOREIGN_COST_RUNS / 2],
                   (unsigned long long)samples[group].values[FOREIGN_COST_RUNS - 1], (double)total / FOREIGN_COST_RUNS);
        }
    }
    else
    {
        fprintf(stderr, "foreign-samples: rejected incomplete/malformed/duplicate sample matrix (%u records)\n", records);
    }
    return valid ? 0 : 1;
}
