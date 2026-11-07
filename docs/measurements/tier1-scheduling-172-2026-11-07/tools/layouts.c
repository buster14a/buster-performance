// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// #172's relative-layout analysis (docs/commands/profiling.md): time-runs' median lines of one script each, every
// build at the same placements (the same object orders). For each script and for Lua's sum over the scripts, each
// placement's ratio of a variant's median to the base's (user cycles and wall time), their mean log ratio as a
// percentage, the 95% interval of that mean over the independent placements (Student's t), and the range.
//
//   cc -O2 -o layouts layouts.c -lm && ./layouts BASE VARIANT time-calls.txt time-tables.txt ...

#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_FILES 8
#define MAX_PLACEMENTS 32

static double cycles[MAX_FILES][2][MAX_PLACEMENTS];
static double walls[MAX_FILES][2][MAX_PLACEMENTS];

// Student's t, two-sided 95%, by degrees of freedom 1..30.
static const double t95[31] = { 0,     12.706, 4.303, 3.182, 2.776, 2.571, 2.447, 2.365, 2.306, 2.262, 2.228, 2.201, 2.179, 2.160, 2.145, 2.131,
                                2.120, 2.110,  2.101, 2.093, 2.086, 2.080, 2.074, 2.069, 2.064, 2.060, 2.056, 2.052, 2.048, 2.045, 2.042 };

static void summary(const char* name, const char* metric, const double* ratios, int count)
{
    double sum = 0;
    double low = 1e9;
    double high = 0;
    for (int k = 0; k < count; k += 1)
    {
        sum += log(ratios[k]);
        low = ratios[k] < low ? ratios[k] : low;
        high = ratios[k] > high ? ratios[k] : high;
    }
    const double mean = count != 0 ? sum / count : 0;
    double squares = 0;
    for (int k = 0; k < count; k += 1)
    {
        squares += (log(ratios[k]) - mean) * (log(ratios[k]) - mean);
    }
    const double deviation = count > 1 ? sqrt(squares / (count - 1)) : 0;
    const double half = count > 1 && count <= 31 ? t95[count - 1] * deviation / sqrt((double)count) : 0;
    printf("%-11s %-6s mean %+.2f%% [%+.2f%%, %+.2f%%] over %d placements, range %+.2f%% to %+.2f%%\n", name, metric, (exp(mean) - 1) * 100,
           (exp(mean - half) - 1) * 100, (exp(mean + half) - 1) * 100, count, (low - 1) * 100, (high - 1) * 100);
}

int main(int argc, char** argv)
{
    int result = argc >= 4 && argc - 3 <= MAX_FILES ? 0 : 2;
    int placements = 0;
    for (int f = 0; result == 0 && f < argc - 3; f += 1)
    {
        FILE* file = fopen(argv[f + 3], "r");
        char line[4096];
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            char build[64];
            int list = 0;
            int placement = 0;
            const char* tail = strstr(line, "]: ");
            const char* median = tail != NULL ? strstr(tail, "median ") : NULL;
            const char* counted = tail != NULL ? strstr(tail, " KiB wait4 peak") : NULL;
            if (sscanf(line, "list %d %63s placement %d [", &list, build, &placement) == 3 && median != NULL && counted != NULL && placement >= 1 &&
                placement <= MAX_PLACEMENTS)
            {
                const int side = strcmp(build, argv[1]) == 0 ? 0 : strcmp(build, argv[2]) == 0 ? 1 : -1;
                double wall = 0;
                unsigned long long minor = 0, major = 0, user_cycles = 0;
                const char* faults = strstr(counted, "peak, ");
                if (side >= 0 && sscanf(median, "median %lf", &wall) == 1 && faults != NULL &&
                    sscanf(faults, "peak, %llu minor faults, %llu major, %llu user cycles", &minor, &major, &user_cycles) == 3)
                {
                    cycles[f][side][placement - 1] = (double)user_cycles;
                    walls[f][side][placement - 1] = wall;
                    placements = placement > placements ? placement : placements;
                }
            }
        }
        if (file != NULL)
        {
            fclose(file);
        }
    }
    double ratios[MAX_PLACEMENTS];
    for (int f = 0; result == 0 && f <= argc - 3; f += 1)
    {
        const bool sum = f == argc - 3;
        const char* name = sum ? "Lua's sum" : strrchr(argv[f + 3], '/') != NULL ? strrchr(argv[f + 3], '/') + 1 : argv[f + 3];
        for (int metric = 0; metric < 2; metric += 1)
        {
            for (int k = 0; k < placements; k += 1)
            {
                double base = 0;
                double variant = 0;
                for (int g = sum ? 0 : f; g < (sum ? argc - 3 : f + 1); g += 1)
                {
                    base += metric == 0 ? cycles[g][0][k] : walls[g][0][k];
                    variant += metric == 0 ? cycles[g][1][k] : walls[g][1][k];
                }
                ratios[k] = base > 0 ? variant / base : 1;
            }
            summary(name, metric == 0 ? "cycles" : "wall", ratios, placements);
        }
    }
    if (result != 0)
    {
        fprintf(stderr, "usage: layouts BASE VARIANT FILE...\n");
    }
    return result;
}
