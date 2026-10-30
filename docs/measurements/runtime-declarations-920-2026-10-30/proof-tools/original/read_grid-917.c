// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Read-only completeness/status check of this campaign's time-runs records.
#define _POSIX_C_SOURCE 200809L
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    bool valid = argc == 7;
    const char* labels[] = { "base", "candidate", "base-again" };
    double walls[2][3][162] = { 0 };
    double cycles[2][3][162] = { 0 };
    double instructions[2][3][162] = { 0 };
    unsigned missing_counters = 0;
    printf("state,round,label,samples,upper_median_wall_ms,upper_median_user_cycles,upper_median_instructions\n");
    for (unsigned file = 0; valid && file < 6; file += 1)
    {
        const unsigned state = file / 3;
        const unsigned round = file % 3;
        const char* mode = state ? "after-scalar" : "plain";
        char expected[64];
        snprintf(expected, sizeof(expected), "time-%s-%u.log", mode, round + 1);
        const char* basename = strrchr(argv[file + 1], '/');
        basename = basename ? basename + 1 : argv[file + 1];
        valid = strcmp(basename, expected) == 0;
        FILE* input = valid ? fopen(argv[file + 1], "rb") : NULL;
        valid = valid && input != NULL;
        unsigned char seen[3][6][3][3] = { 0 };
        unsigned count = 0;
        char* line = NULL;
        size_t capacity = 0;
        while (valid && getline(&line, &capacity, input) >= 0)
        {
            valid = strstr(line, "FAILED") == NULL;
            if (strncmp(line, "run ", 4) == 0)
            {
                unsigned run, list, placement, copy;
                char label[32] = { 0 };
                double wall, user, system;
                unsigned long long peak, minor, major, one_cycles, one_instructions;
                int status, end = 0;
                const int fields = sscanf(line,
                    "run %u list %u %31s placement %u copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KiB wait4 peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d%n",
                    &run, &list, label, &placement, &copy, &wall, &user, &system, &peak, &minor, &major, &one_cycles, &one_instructions, &status, &end);
                unsigned build = 3;
                for (unsigned b = 0; b < 3; b += 1)
                {
                    if (strcmp(label, labels[b]) == 0)
                    {
                        build = b;
                    }
                }
                valid = valid && fields == 14 && build < 3 && list == 1 && run >= 1 && run <= 3 &&
                    placement >= 1 && placement <= 6 && copy >= 1 && copy <= 3 && status == 0 && wall > 0 && user >= 0 && system >= 0;
                for (const char* suffix = line + end; valid && *suffix; suffix += 1)
                {
                    valid = isspace((unsigned char)*suffix) != 0;
                }
                if (valid)
                {
                    valid = seen[build][placement - 1][copy - 1][run - 1] == 0;
                    seen[build][placement - 1][copy - 1][run - 1] = 1;
                    const unsigned index = round * 54 + (run - 1) * 18 + (placement - 1) * 3 + copy - 1;
                    walls[state][build][index] = wall;
                    cycles[state][build][index] = (double)one_cycles;
                    instructions[state][build][index] = (double)one_instructions;
                    missing_counters += one_cycles == 0 || one_instructions == 0;
                    count += 1;
                }
            }
        }
        if (input)
        {
            valid = !ferror(input) && fclose(input) == 0 && valid;
        }
        free(line);
        valid = valid && count == 162;
        for (unsigned b = 0; valid && b < 3; b += 1)
        {
            double samples[3][54];
            memcpy(samples[0], walls[state][b] + round * 54, sizeof(samples[0]));
            memcpy(samples[1], cycles[state][b] + round * 54, sizeof(samples[1]));
            memcpy(samples[2], instructions[state][b] + round * 54, sizeof(samples[2]));
            for (unsigned metric = 0; metric < 3; metric += 1)
            {
                qsort(samples[metric], 54, sizeof(double), compare_double);
            }
            printf("%s,%u,%s,54,%.3f,%.0f,%.0f\n", mode, round + 1, labels[b], samples[0][27], samples[1][27], samples[2][27]);
        }
    }
    for (unsigned state = 0; valid && state < 2; state += 1)
    {
        for (unsigned b = 0; b < 3; b += 1)
        {
            qsort(walls[state][b], 162, sizeof(double), compare_double);
            qsort(cycles[state][b], 162, sizeof(double), compare_double);
            qsort(instructions[state][b], 162, sizeof(double), compare_double);
            printf("%s,all,%s,162,%.3f,%.0f,%.0f\n", state ? "after-scalar" : "plain", labels[b], walls[state][b][81], cycles[state][b][81], instructions[state][b][81]);
        }
    }
    fprintf(stderr, "grid passed=%s; expected=972 measured processes; missing counter pairs=%u\n", valid ? "true" : "false", missing_counters);
    return valid ? 0 : 1;
}
