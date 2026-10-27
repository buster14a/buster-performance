// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reducer for the retained C time-runs output. Only successful measured-process rows are admitted;
// medians use the upper middle observation, as time-runs does. Printed wall times have 0.001 ms resolution.
#define _POSIX_C_SOURCE 200809L
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_SUMMARY_SAMPLES 512
typedef struct Samples Samples;
struct Samples
{
    double wall[BUSTER_SUMMARY_SAMPLES];
    double instructions[BUSTER_SUMMARY_SAMPLES];
    double peak[BUSTER_SUMMARY_SAMPLES];
    double cycles[BUSTER_SUMMARY_SAMPLES];
    uint32_t count;
};
static Samples samples[4][3];

static double summary_median(double* values, uint32_t count)
{
    for (uint32_t i = 1; i < count; i += 1)
    {
        const double value = values[i];
        uint32_t j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return values[count / 2];
}

int main(int argc, char** argv)
{
    bool valid = argc > 1;
    const char* names[] = { "base", "head", "base-again" };
    char* line = 0;
    size_t capacity = 0;
    for (int file = 1; valid && file < argc; file += 1)
    {
        FILE* input = fopen(argv[file], "r");
        valid = input != 0;
        bool complete = false;
        while (valid && getline(&line, &capacity, input) >= 0)
        {
            complete |= strcmp(line, "time-runs: done, 0 failed processes\n") == 0;
            if (strncmp(line, "run ", 4) == 0)
            {
                unsigned run = 0;
                unsigned list = 0;
                unsigned copy = 0;
                char name[32] = { 0 };
                double wall = 0;
                double user = 0;
                double system = 0;
                uint64_t peak = 0;
                uint64_t minor = 0;
                uint64_t major = 0;
                uint64_t cycles = 0;
                uint64_t instructions = 0;
                int status = -1;
                const int fields = sscanf(line, "run %u list %u %31s copy %u: %lf ms wall, %lf ms user, %lf ms system, %" SCNu64
                                          " KB peak, %" SCNu64 " minor faults, %" SCNu64 " major, %" SCNu64 " user cycles, %" SCNu64
                                          " instructions, status %d", &run, &list, name, &copy, &wall, &user, &system, &peak, &minor, &major,
                                          &cycles, &instructions, &status);
                uint32_t build = 0;
                while (build < 3 && strcmp(name, names[build]) != 0)
                {
                    build += 1;
                }
                valid = fields == 13 && status == 0 && run != 0 && list >= 1 && list <= 4 && build < 3 && copy >= 1 && copy <= 2 &&
                        cycles != 0 && instructions != 0 && strstr(line, "FAILED") == 0;
                if (valid)
                {
                    Samples* group = &samples[list - 1][build];
                    valid = group->count < BUSTER_SUMMARY_SAMPLES;
                    if (valid)
                    {
                        const uint32_t i = group->count++;
                        group->wall[i] = wall;
                        group->instructions[i] = (double)instructions;
                        group->peak[i] = (double)peak;
                        group->cycles[i] = (double)cycles;
                    }
                }
            }
        }
        valid &= complete && input != 0 && !ferror(input);
        if (input != 0)
        {
            valid &= fclose(input) == 0;
        }
    }
    free(line);
    for (uint32_t list = 0; valid && list < 4; list += 1)
    {
        for (uint32_t build = 0; valid && build < 3; build += 1)
        {
            valid = samples[list][build].count != 0 && samples[list][build].count == samples[0][0].count;
        }
    }
    if (valid)
    {
        puts("list,build,runs,wall_median_ms,wall_min_ms,wall_max_ms,instructions_median,peak_kb_median,cycles_median");
        for (uint32_t list = 0; list < 4; list += 1)
        {
            for (uint32_t build = 0; build < 3; build += 1)
            {
                Samples* group = &samples[list][build];
                const double wall = summary_median(group->wall, group->count);
                const double instructions = summary_median(group->instructions, group->count);
                const double peak = summary_median(group->peak, group->count);
                const double cycles = summary_median(group->cycles, group->count);
                printf("%u,%s,%u,%.3f,%.3f,%.3f,%.0f,%.0f,%.0f\n", list + 1, names[build], group->count, wall,
                       group->wall[0], group->wall[group->count - 1], instructions, peak, cycles);
            }
        }
    }
    if (!valid)
    {
        fprintf(stderr, "summarize: expected complete, successful, counted time-runs output for four lists and three builds\n");
    }
    return !valid;
}
