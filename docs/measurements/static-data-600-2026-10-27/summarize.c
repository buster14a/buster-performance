// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Recompute pooled medians from time-runs' individual successful process rows.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum
{
    LIMIT = 128,
    FIELDS = 8,
};

typedef struct Samples Samples;
struct Samples
{
    char name[32];
    double values[FIELDS][LIMIT];
    unsigned count;
};

static double median(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double value = values[i];
        unsigned at = i;
        while (at != 0 && values[at - 1] > value)
        {
            values[at] = values[at - 1];
            at -= 1;
        }
        values[at] = value;
    }
    return values[count / 2];
}

int main(int argc, char** argv)
{
    bool valid = argc > 1;
    puts("case\tvariant\truns\twall_ms\twall_min_ms\twall_max_ms\tuser_ms\tsystem_ms\tpeak_kib\tminor_faults\tmajor_faults\tuser_cycles\tuser_instructions");
    for (int file = 1; valid && file < argc; file += 1)
    {
        FILE* input = fopen(argv[file], "r");
        Samples samples[19][2] = { 0 };
        char names[19][64] = { 0 };
        valid = input != 0;
        char line[8192];
        while (valid && fgets(line, sizeof(line), input) != 0)
        {
            if (strncmp(line, "MATRIX_CASE ", 12) == 0)
            {
                unsigned list = 0;
                char name[64];
                valid = sscanf(line, "MATRIX_CASE %u %63s", &list, name) == 2 && list >= 1 && list <= 19;
                if (valid)
                {
                    snprintf(names[list - 1], sizeof(names[list - 1]), "%s", name);
                }
            }
            if (strncmp(line, "run ", 4) == 0)
            {
                unsigned run = 0;
                unsigned list = 0;
                unsigned copy = 0;
                char name[32];
                double wall = 0;
                double user = 0;
                double system = 0;
                unsigned long long peak = 0;
                unsigned long long minor = 0;
                unsigned long long major = 0;
                unsigned long long cycles = 0;
                unsigned long long instructions = 0;
                int status = -1;
                const int fields = sscanf(line, "run %u list %u %31s copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d",
                                          &run, &list, name, &copy, &wall, &user, &system, &peak, &minor, &major, &cycles, &instructions, &status);
                valid = fields == 13 && status == 0 && list >= 1 && list <= 19 && run != 0 && copy != 0;
                if (valid)
                {
                    Samples* group = samples[list - 1];
                    const unsigned variant = group[0].count == 0 || strcmp(name, group[0].name) == 0 ? 0 : 1;
                    Samples* target = group + variant;
                    valid = target->count < LIMIT && (target->count == 0 || strcmp(name, target->name) == 0);
                    if (valid)
                    {
                        snprintf(target->name, sizeof(target->name), "%s", name);
                        const double values[FIELDS] = { wall, user, system, (double)peak, (double)minor, (double)major, (double)cycles, (double)instructions };
                        for (unsigned field = 0; field < FIELDS; field += 1)
                        {
                            target->values[field][target->count] = values[field];
                        }
                        target->count += 1;
                    }
                }
            }
        }
        bool found = false;
        for (unsigned list = 0; valid && list < 19; list += 1)
        {
            if (samples[list][0].count != 0 || samples[list][1].count != 0)
            {
                found = true;
                for (unsigned variant = 0; valid && variant < 2; variant += 1)
                {
                    Samples* target = samples[list] + variant;
                    valid = target->count != 0;
                    if (valid)
                    {
                        double medians[FIELDS];
                        for (unsigned field = 0; field < FIELDS; field += 1)
                        {
                            medians[field] = median(target->values[field], target->count);
                        }
                        const char* name = names[list][0] != 0 ? names[list] : argv[file];
                        printf("%s\t%s\t%u\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n", name, target->name, target->count,
                               medians[0], target->values[0][0], target->values[0][target->count - 1], medians[1], medians[2],
                               medians[3], medians[4], medians[5], medians[6], medians[7]);
                    }
                }
            }
        }
        valid = valid && found;
        if (input != 0)
        {
            fclose(input);
        }
        if (!valid)
        {
            fprintf(stderr, "invalid or failed timing log: %s\n", argv[file]);
        }
    }
    return valid ? 0 : 1;
}
