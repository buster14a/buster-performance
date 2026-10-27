// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Summarize #606 TSVs; negative round numbers are warm-ups. Ratios use matched rounds.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Sample
{
    double ns;
    double rss;
    bool present;
} Sample;

static Sample samples[3][2][2][2][100];
static const char* const names[] = { "sqlite", "lines", "small" };

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return (values[(count - 1) / 2] + values[count / 2]) / 2;
}

int main(void)
{
    char line[2048];
    int result = 0;
    while (fgets(line, sizeof(line), stdin) != NULL)
    {
        char name[64];
        char stages[16];
        char version[16];
        char mode[16];
        int round;
        unsigned long long ns, user, system;
        long rss, minor, major;
        int status;
        const int read = sscanf(line, "%63s %15s %d %15s %15s %llu %ld %llu %llu %ld %ld %d", name, stages, &round, version, mode,
                                &ns, &rss, &user, &system, &minor, &major, &status);
        if (read != 12 || status != 0)
        {
            fprintf(stderr, "bad sample: %s", line);
            result = 1;
        }
        else if (round >= 0 && round < 100)
        {
            for (unsigned workload = 0; workload < 3; workload += 1)
            {
                if (strcmp(name, names[workload]) == 0)
                {
                    Sample* sample = &samples[workload][strcmp(stages, "yes") == 0][strcmp(version, "head") == 0][strcmp(mode, "g") == 0][round];
                    result |= sample->present;
                    *sample = (Sample){ (double)ns, (double)rss, true };
                }
            }
        }
    }
    for (unsigned workload = 0; workload < 3; workload += 1)
    {
        for (unsigned stages = 0; stages < 2; stages += 1)
        {
            for (unsigned mode = 0; mode < 2; mode += 1)
            {
                double base[100], head[100], ratio[100], base_rss[100], head_rss[100];
                unsigned count = 0;
                for (unsigned round = 0; round < 100; round += 1)
                {
                    const Sample a = samples[workload][stages][0][mode][round];
                    const Sample b = samples[workload][stages][1][mode][round];
                    if (a.present && b.present)
                    {
                        base[count] = a.ns / 1e6;
                        head[count] = b.ns / 1e6;
                        ratio[count] = b.ns / a.ns;
                        base_rss[count] = a.rss;
                        head_rss[count] = b.rss;
                        count += 1;
                    }
                    else if (a.present != b.present)
                    {
                        result = 1;
                    }
                }
                if (count != 0)
                {
                    const double base_ms = median(base, count);
                    const double head_ms = median(head, count);
                    const double paired = median(ratio, count);
                    const double a_rss = median(base_rss, count);
                    const double b_rss = median(head_rss, count);
                    printf("%s stages=%u mode=%c pairs=%u wall_ms=%.6f->%.6f paired_ratio=%.6f range=%.6f..%.6f rss_kb=%.0f->%.0f rss_ranges=%.0f..%.0f/%.0f..%.0f\n",
                           names[workload], stages, mode == 0 ? 'c' : 'g', count, base_ms, head_ms, paired, ratio[0], ratio[count - 1], a_rss, b_rss,
                           base_rss[0], base_rss[count - 1], head_rss[0], head_rss[count - 1]);
                }
            }
        }
    }
    return result;
}
