// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Summarize measured process rows independently of time-runs' built-in report. Warmups are excluded.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <inttypes.h>

typedef struct Samples Samples;
struct Samples
{
    double wall[128];
    uint64_t instructions[128];
    uint64_t cycles[128];
    uint64_t minimum_peak;
    uint64_t maximum_peak;
    uint32_t count;
};

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    const int result = (x > y) - (x < y);
    return result;
}

static int compare_integer(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    const int result = (x > y) - (x < y);
    return result;
}

int main(int argc, char** argv)
{
    bool valid = argc > 2 && (strcmp(argv[1], "1") == 0 || strcmp(argv[1], "2") == 0);
    const unsigned selected = valid ? (unsigned)(argv[1][0] - '0') : 0;
    const char* names[] = { "base-a", "base-b", "fix" };
    printf("input\tlist\tbuild\truns\twall_ms\tcycles\tinstructions\tpeak_min_KB\tpeak_max_KB\n");
    for (int input = 2; valid && input < argc; input += 1)
    {
        FILE* file = fopen(argv[input], "r");
        valid = file != NULL;
        Samples samples[3] = { 0 };
        char line[8192];
        while (valid && fgets(line, sizeof(line), file) != NULL)
        {
            unsigned run = 0;
            unsigned list = 0;
            unsigned copy = 0;
            int status = 0;
            char build[32];
            double wall = 0;
            double user = 0;
            double system = 0;
            uint64_t peak = 0;
            uint64_t minor = 0;
            uint64_t major = 0;
            uint64_t cycles = 0;
            uint64_t instructions = 0;
            const int fields = sscanf(line, "run %u list %u %31s copy %u: %lf ms wall, %lf ms user, %lf ms system, %" SCNu64
                                      " KB peak, %" SCNu64 " minor faults, %" SCNu64 " major, %" SCNu64 " user cycles, %" SCNu64
                                      " instructions, status %d", &run, &list, build, &copy, &wall, &user, &system, &peak, &minor, &major,
                                      &cycles, &instructions, &status);
            for (uint32_t b = 0; fields == 13 && list == selected && b < 3; b += 1)
            {
                if (strcmp(build, names[b]) == 0)
                {
                    Samples* group = samples + b;
                    valid &= group->count < 128 && status == 0;
                    if (valid)
                    {
                        group->wall[group->count] = wall;
                        group->instructions[group->count] = instructions;
                        group->cycles[group->count] = cycles;
                        group->minimum_peak = group->count == 0 || peak < group->minimum_peak ? peak : group->minimum_peak;
                        group->maximum_peak = peak > group->maximum_peak ? peak : group->maximum_peak;
                        group->count += 1;
                    }
                }
            }
        }
        if (file != NULL)
        {
            const bool read = ferror(file) == 0;
            const bool closed = fclose(file) == 0;
            valid &= read && closed;
        }
        for (uint32_t b = 0; valid && b < 3; b += 1)
        {
            Samples* group = samples + b;
            valid &= group->count == 33;
            if (valid)
            {
                qsort(group->wall, group->count, sizeof(double), compare_double);
                qsort(group->instructions, group->count, sizeof(uint64_t), compare_integer);
                qsort(group->cycles, group->count, sizeof(uint64_t), compare_integer);
                const uint32_t middle = group->count / 2;
                printf("%s\t%u\t%s\t%u\t%.3f\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", argv[input], selected, names[b], group->count,
                       group->wall[middle], group->cycles[middle], group->instructions[middle], group->minimum_peak, group->maximum_peak);
            }
        }
    }
    const int result = valid ? 0 : 1;
    return result;
}
