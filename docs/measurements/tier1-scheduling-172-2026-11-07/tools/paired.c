// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// #172's paired comparison of measure-tier1-programs' raw runs: for each process (file), each measured round and each
// program (speedtest1, each Lua script, and Lua's sum over its five scripts' runs of that round), the ratio of a
// variant build's wall time and user cycles to the base build's run of the same round. Prints each process's median
// ratio, and over every process's rounds the median and the 2.5th and 97.5th percentiles of the ratios.
//
//   cc -O2 -o paired paired.c && ./paired BASE VARIANT programs-1.txt programs-2.txt ...
//
// BASE and VARIANT are the runs' build fields (tier1, variant1, ...).

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ROUNDS 1024
#define MAX_FILES 16
#define PROGRAMS 7

static const char* const programs[PROGRAMS] = { "speedtest1", "calls", "tables", "strings", "arithmetic", "closures", "Lua's sum" };

typedef struct Run Run;
struct Run
{
    double wall[2][PROGRAMS];
    double cycles[2][PROGRAMS];
    int seen[2][PROGRAMS];
};

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double percentile(double* values, int count, double p)
{
    qsort(values, (size_t)count, sizeof(double), compare);
    const int index = (int)(p * (count - 1) + 0.5);
    return count == 0 ? 0 : values[index];
}

static Run runs[MAX_FILES][MAX_ROUNDS];
static int round_counts[MAX_FILES];

int main(int argc, char** argv)
{
    int result = 0;
    if (argc < 4 || argc - 3 > MAX_FILES)
    {
        fprintf(stderr, "usage: paired BASE VARIANT FILE...\n");
        result = 2;
    }
    for (int f = 0; result == 0 && f < argc - 3; f += 1)
    {
        FILE* file = fopen(argv[f + 3], "r");
        char line[1024];
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            char phase[32], program[32], build[32];
            int round = 0, position = 0, status = 0, counted = 0;
            unsigned long long wall = 0, cycles = 0, instructions = 0;
            if (sscanf(line, "tier1-programs-run\t%31s\t%d\t%d\t%31s\t%31s\t%llu\t%llu\t%llu\t%d\t%d", phase, &round, &position, program, build, &wall, &cycles,
                       &instructions, &status, &counted) == 10 &&
                strcmp(phase, "measured") == 0 && round > 0 && round <= MAX_ROUNDS)
            {
                const int side = strcmp(build, argv[1]) == 0 ? 0 : strcmp(build, argv[2]) == 0 ? 1 : -1;
                int p = -1;
                for (int k = 0; k < PROGRAMS - 1; k += 1)
                {
                    p = strcmp(program, programs[k]) == 0 ? k : p;
                }
                if (side >= 0 && p >= 0)
                {
                    Run* run = &runs[f][round - 1];
                    run->wall[side][p] = (double)wall;
                    run->cycles[side][p] = (double)cycles;
                    run->seen[side][p] = 1;
                    if (p != 0)
                    {
                        run->wall[side][PROGRAMS - 1] += (double)wall;
                        run->cycles[side][PROGRAMS - 1] += (double)cycles;
                        run->seen[side][PROGRAMS - 1] += 1;
                    }
                    round_counts[f] = round > round_counts[f] ? round : round_counts[f];
                }
            }
        }
        if (file != NULL)
        {
            fclose(file);
        }
    }
    static double all_wall[MAX_FILES * MAX_ROUNDS];
    static double all_cycles[MAX_FILES * MAX_ROUNDS];
    static double one[MAX_ROUNDS];
    for (int p = 0; result == 0 && p < PROGRAMS; p += 1)
    {
        const int needed = p == PROGRAMS - 1 ? PROGRAMS - 2 : 1;
        int count = 0;
        printf("%-11s %s/%s:", programs[p], argv[2], argv[1]);
        for (int f = 0; f < argc - 3; f += 1)
        {
            int n = 0;
            for (int r = 0; r < round_counts[f]; r += 1)
            {
                const Run* run = &runs[f][r];
                if (run->seen[0][p] == needed && run->seen[1][p] == needed && run->wall[0][p] > 0 && run->cycles[0][p] > 0)
                {
                    one[n] = run->cycles[1][p] / run->cycles[0][p];
                    all_cycles[count] = one[n];
                    all_wall[count] = run->wall[1][p] / run->wall[0][p];
                    n += 1;
                    count += 1;
                }
            }
            printf(" process %d cycles %.4f (%d rounds);", f + 1, percentile(one, n, 0.5), n);
        }
        const double cycles_median = percentile(all_cycles, count, 0.5);
        const double cycles_low = percentile(all_cycles, count, 0.025);
        const double cycles_high = percentile(all_cycles, count, 0.975);
        const double wall_median = percentile(all_wall, count, 0.5);
        const double wall_low = percentile(all_wall, count, 0.025);
        const double wall_high = percentile(all_wall, count, 0.975);
        printf(" all %d: cycles %.4f [%.4f, %.4f], wall %.4f [%.4f, %.4f]\n", count, cycles_median, cycles_low, cycles_high, wall_median, wall_low, wall_high);
    }
    return result;
}
