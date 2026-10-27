// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #601 reader for profile.c time-runs and the driver's time-stage reports.
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

typedef struct Samples Samples;
struct Samples
{
    double wall[128];
    double instructions[128];
    double cycles[128];
    double rss[128];
    double publish[128];
    double parse[128];
    double initializers[128];
    uint32_t count;
    uint32_t stages;
};

static int compare(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return (a > b) - (a < b);
}

static double median(double* values, uint32_t count)
{
    qsort(values, count, sizeof(*values), compare);
    return count != 0 ? values[count / 2] : 0;
}

static void report(const char* name, const char* metric, double a, double b, double c)
{
    printf("%s\t%s\t%.6f\t%.6f\t%.6f\t%+.3f\t%+.3f\n", name, metric, a, b, c, a != 0 ? (b / a - 1) * 100 : 0, a != 0 ? (c / a - 1) * 100 : 0);
}

static bool summarize(const char* directory, const char* name, uint32_t round)
{
    Samples values[3] = {0};
    char path[4096];
    snprintf(path, sizeof(path), "%s/%s-r%u-whole.log", directory, name, round);
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    char line[4096];
    while (input != NULL && fgets(line, sizeof(line), input) != NULL)
    {
        unsigned run, list, copy;
        char variant[32];
        double wall, user, system;
        unsigned long long rss, faults, major, cycles, instructions;
        int status;
        const int fields = sscanf(line, "run %u list %u %31s copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d", &run, &list, variant, &copy, &wall, &user, &system, &rss, &faults, &major, &cycles, &instructions, &status);
        if (fields == 13)
        {
            const uint32_t column = strcmp(variant, "base") == 0 ? 0 : strcmp(variant, "head") == 0 ? 1 : 2;
            Samples* samples = &values[column];
            valid = valid && status == 0 && cycles != 0 && instructions != 0 && samples->count < 128;
            if (samples->count < 128)
            {
                const uint32_t i = samples->count++;
                samples->wall[i] = wall;
                samples->instructions[i] = (double)instructions / 1e6;
                samples->cycles[i] = (double)cycles / 1e6;
                samples->rss[i] = (double)rss;
            }
        }
    }
    if (input != NULL)
    {
        fclose(input);
    }
    for (uint32_t column = 0; column < 2; column += 1)
    {
        for (uint32_t sample = 1; sample <= 11; sample += 1)
        {
            snprintf(path, sizeof(path), "%s/%s-r%u-%s-stage-%u.log", directory, name, round, column == 0 ? "base" : "head", sample);
            input = fopen(path, "r");
            bool publish = false;
            while (input != NULL && fgets(line, sizeof(line), input) != NULL)
            {
                char stage[64];
                double milliseconds;
                if (sscanf(line, "time-stage\t%63s\t%lf", stage, &milliseconds) == 2)
                {
                    if (strcmp(stage, "publish-data") == 0)
                    {
                        values[column].publish[sample - 1] = milliseconds;
                        publish = true;
                    }
                    else if (strcmp(stage, "parse") == 0)
                    {
                        values[column].parse[sample - 1] = milliseconds;
                    }
                    else if (strcmp(stage, "check-declarations") == 0)
                    {
                        values[column].initializers[sample - 1] = milliseconds;
                    }
                }
            }
            if (input != NULL)
            {
                fclose(input);
            }
            values[column].stages += publish;
        }
    }
    valid = valid && values[0].count == 24 && values[1].count == 24 && values[2].count == 24 && values[0].stages == 11 && values[1].stages == 11;
    if (valid)
    {
        report(name, "wall_ms", median(values[0].wall, 24), median(values[1].wall, 24), median(values[2].wall, 24));
        report(name, "instructions_M", median(values[0].instructions, 24), median(values[1].instructions, 24), median(values[2].instructions, 24));
        report(name, "cycles_M", median(values[0].cycles, 24), median(values[1].cycles, 24), median(values[2].cycles, 24));
        report(name, "rss_KB", median(values[0].rss, 24), median(values[1].rss, 24), median(values[2].rss, 24));
        report(name, "publish_ms", median(values[0].publish, 11), median(values[1].publish, 11), NAN);
        report(name, "parse_ms", median(values[0].parse, 11), median(values[1].parse, 11), NAN);
        report(name, "initializers_ms", median(values[0].initializers, 11), median(values[1].initializers, 11), NAN);
    }
    else
    {
        fprintf(stderr, "%s: incomplete or failed measurements (whole %u/%u/%u, stages %u/%u)\n", name, values[0].count, values[1].count, values[2].count, values[0].stages, values[1].stages);
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 3;
    const char* names[] = {
        "plain-1024", "plain-4096", "plain-16384", "plain-65536", "packed-16384", "wide-16384", "mixed-4096", "clear-16384", "sqlite", "lua-vm", "lua-table"
    };
    printf("case\tmetric\tbase\thead\tcontrol\thead_change_pct\tcontrol_change_pct\n");
    for (uint32_t i = 0; argc == 3 && i < sizeof(names) / sizeof(names[0]); i += 1)
    {
        const bool done = summarize(argv[1], names[i], (uint32_t)strtoul(argv[2], NULL, 10));
        valid = done && valid;
    }
    return valid ? 0 : 1;
}
