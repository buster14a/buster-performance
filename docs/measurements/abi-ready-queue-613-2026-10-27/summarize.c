// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for the pinned compiler's time-runs rows. All 15 samples per build/case must exit zero.
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define BUSTER_SUMMARY_CASES 33
#define BUSTER_SUMMARY_SAMPLES 15

typedef struct Sample Sample;
struct Sample
{
    double wall;
    double instructions;
    double cycles;
    double peak;
};

static double median(double* values)
{
    for (unsigned i = 1; i < BUSTER_SUMMARY_SAMPLES; i += 1)
    {
        const double value = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return values[BUSTER_SUMMARY_SAMPLES / 2];
}

int main(int argc, char** argv)
{
    const unsigned cases = argc == 3 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    FILE* input = argc == 3 ? fopen(argv[1], "r") : NULL;
    bool valid = input != NULL && cases != 0 && cases <= BUSTER_SUMMARY_CASES;
    static Sample samples[BUSTER_SUMMARY_CASES][2][BUSTER_SUMMARY_SAMPLES];
    static bool seen[BUSTER_SUMMARY_CASES][2][BUSTER_SUMMARY_SAMPLES];
    unsigned rows = 0;
    char line[8192];
    while (input != NULL && fgets(line, sizeof(line), input) != NULL)
    {
        unsigned run = 0;
        unsigned list = 0;
        unsigned copy = 0;
        char build[16];
        double wall = 0;
        double user = 0;
        double system = 0;
        unsigned long long peak = 0;
        unsigned long long minor = 0;
        unsigned long long major = 0;
        unsigned long long cycles = 0;
        unsigned long long instructions = 0;
        int status = -1;
        const int fields = sscanf(line, "run %u list %u %15s copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d",
                                  &run, &list, build, &copy, &wall, &user, &system, &peak, &minor, &major, &cycles, &instructions, &status);
        if (fields == 13)
        {
            const unsigned version = strcmp(build, "base") == 0 ? 0 : 1;
            const bool bounded = list != 0 && list <= cases && copy != 0 && copy <= 3 && run != 0 && run <= 5;
            valid = valid && bounded && status == 0 && (version == 0 || strcmp(build, "head") == 0);
            if (bounded)
            {
                const unsigned slot = (copy - 1) * 5 + run - 1;
                valid = valid && !seen[list - 1][version][slot];
                seen[list - 1][version][slot] = true;
                samples[list - 1][version][slot] = (Sample){ wall, (double)instructions, (double)cycles, (double)peak };
                rows += 1;
            }
        }
        else if (strncmp(line, "run ", 4) == 0 || strstr(line, "FAILED") != NULL)
        {
            valid = false;
        }
    }
    valid = valid && rows == cases * 2 * BUSTER_SUMMARY_SAMPLES;
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        fclose(input);
    }
    if (valid)
    {
        puts("list,build,samples,wall_ms,min_ms,max_ms,instructions,user_cycles,peak_kb");
        for (unsigned list = 0; list < cases; list += 1)
        {
            for (unsigned version = 0; version < 2; version += 1)
            {
                double wall[BUSTER_SUMMARY_SAMPLES];
                double instructions[BUSTER_SUMMARY_SAMPLES];
                double cycles[BUSTER_SUMMARY_SAMPLES];
                double peak[BUSTER_SUMMARY_SAMPLES];
                for (unsigned s = 0; s < BUSTER_SUMMARY_SAMPLES; s += 1)
                {
                    const Sample sample = samples[list][version][s];
                    wall[s] = sample.wall;
                    instructions[s] = sample.instructions;
                    cycles[s] = sample.cycles;
                    peak[s] = sample.peak;
                }
                const double wall_median = median(wall);
                const double instruction_median = median(instructions);
                const double cycle_median = median(cycles);
                const double peak_median = median(peak);
                printf("%u,%s,%u,%.3f,%.3f,%.3f,%.0f,%.0f,%.0f\n", list + 1, version == 0 ? "base" : "head", BUSTER_SUMMARY_SAMPLES,
                       wall_median, wall[0], wall[BUSTER_SUMMARY_SAMPLES - 1], instruction_median, cycle_median, peak_median);
            }
        }
    }
    else
    {
        fprintf(stderr, "summary: invalid, duplicate, missing or nonzero-exit samples (%u rows)\n", rows);
    }
    return valid ? 0 : 1;
}
