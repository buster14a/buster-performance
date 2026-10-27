// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Summarize retained `compiler time-runs` process lines across rounds, placements and copies.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

enum
{
    LISTS = 32,
    BUILDS = 3,
    SAMPLES = 512,
    FIELDS = 4,
};
static double samples[LISTS][BUILDS][FIELDS][SAMPLES];
static unsigned counts[LISTS][BUILDS];

static void sort(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
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
}

int main(int argc, char** argv)
{
    const char* names[BUILDS] = {
        "base",
        "head",
        "base-again",
    };
    bool result = argc > 1;
    unsigned total = 0;
    for (int argument = 1; result && argument < argc; argument += 1)
    {
        FILE* input = fopen(argv[argument], "r");
        result = input != 0;
        char* line = 0;
        size_t capacity = 0;
        while (result && getline(&line, &capacity, input) >= 0)
        {
            unsigned run, list, copy, placement = 1;
            char build[32];
            double wall, user, system;
            unsigned long long rss, minor, major, cycles, instructions;
            int status;
            int end = 0;
            int read = sscanf(line, "run %u list %u %31s placement %u copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d%n",
                              &run, &list, build, &placement, &copy, &wall, &user, &system, &rss, &minor, &major, &cycles, &instructions, &status, &end);
            const bool placed = read == 14;
            if (!placed)
            {
                read = sscanf(line, "run %u list %u %31s copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d%n",
                              &run, &list, build, &copy, &wall, &user, &system, &rss, &minor, &major, &cycles, &instructions, &status, &end);
            }
            if (placed || read == 13)
            {
                while (isspace((unsigned char)line[end]))
                {
                    end += 1;
                }
                unsigned b = 0;
                while (b < BUILDS && strcmp(names[b], build) != 0)
                {
                    b += 1;
                }
                result = line[end] == 0 && run > 0 && placement > 0 && copy > 0 && list > 0 && list <= LISTS && b < BUILDS && status == 0 && cycles != 0 && instructions != 0;
                if (result)
                {
                    const unsigned n = counts[list - 1][b];
                    result = n < SAMPLES;
                    if (result)
                    {
                        samples[list - 1][b][0][n] = wall;
                        samples[list - 1][b][1][n] = (double)instructions;
                        samples[list - 1][b][2][n] = (double)cycles;
                        samples[list - 1][b][3][n] = (double)rss;
                        counts[list - 1][b] += 1;
                        total += 1;
                    }
                }
            }
            else if (strncmp(line, "run ", 4) == 0 || (strncmp(line, "warm-up ", 8) == 0 && strstr(line, "FAILED") != 0))
            {
                result = false;
            }
        }
        free(line);
        if (input != 0)
        {
            result = !ferror(input) && result;
            result = fclose(input) == 0 && result;
        }
    }
    printf("list\tbuild\tsamples\twall_ms\tmin_ms\tmax_ms\tinstructions\tuser_cycles\tpeak_rss_kb\n");
    for (unsigned list = 0; result && list < LISTS; list += 1)
    {
        for (unsigned b = 0; b < BUILDS; b += 1)
        {
            const unsigned count = counts[list][b];
            if (count != 0)
            {
                for (unsigned field = 0; field < FIELDS; field += 1)
                {
                    sort(samples[list][b][field], count);
                }
                printf("%u\t%s\t%u\t%.3f\t%.3f\t%.3f\t%.0f\t%.0f\t%.0f\n", list + 1, names[b], count,
                       samples[list][b][0][count / 2], samples[list][b][0][0], samples[list][b][0][count - 1],
                       samples[list][b][1][count / 2], samples[list][b][2][count / 2], samples[list][b][3][count / 2]);
            }
        }
    }
    return !(result && total != 0);
}
