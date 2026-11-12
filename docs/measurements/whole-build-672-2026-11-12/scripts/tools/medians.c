// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// medians: procbench's runs reduced to a line per label.
//
//   medians RESULTS.tsv...
//
// Reads procbench's tab-separated runs (the header line names the columns; the counters follow as `name=value`), leaves
// the warm-ups out, and prints for each label, in the order of first appearance: its runs and how many of them failed
// (a status other than 0), then the medians of the runs that succeeded: wall, span and settle in milliseconds with the
// wall's least and greatest, the user and system milliseconds of the commands and of what they left behind (late), the
// peak resident megabytes, the minor faults, and each counter in millions.

#define _GNU_SOURCE
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEDIANS_LABELS 512
#define MEDIANS_RUNS 4096
#define MEDIANS_COUNTERS 8
// The fields kept of a run: procbench's columns from wall_ns to late_count, then its counters.
#define MEDIANS_FIXED 14
#define MEDIANS_FIELDS (MEDIANS_FIXED + MEDIANS_COUNTERS)

typedef struct MediansLabel MediansLabel;
struct MediansLabel
{
    char name[128];
    uint32_t runs;
    uint32_t failed;
    uint32_t kept;
    double* values[MEDIANS_FIELDS];
};

static int medians_compare(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return a < b ? -1 : a > b ? 1 : 0;
}

static double medians_median(double* values, uint32_t count)
{
    qsort(values, count, sizeof(double), medians_compare);
    return count == 0 ? 0.0 : count % 2 == 1 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2.0;
}

int main(int argc, char** argv)
{
    static MediansLabel labels[MEDIANS_LABELS];
    static char counters[MEDIANS_COUNTERS][64];
    uint32_t label_count = 0;
    uint32_t counter_count = 0;
    bool succeeded = argc > 1;
    if (!succeeded)
    {
        fprintf(stderr, "usage: medians RESULTS.tsv...\n");
    }
    for (int f = 1; succeeded && f < argc; f += 1)
    {
        FILE* file = fopen(argv[f], "r");
        succeeded = file != 0;
        if (!succeeded)
        {
            fprintf(stderr, "medians: can't read %s\n", argv[f]);
        }
        char line[8192];
        while (succeeded && fgets(line, sizeof(line), file) != 0)
        {
            // round, line, label, run, warmup, status, then MEDIANS_FIXED numbers, then the counters.
            char* fields[6 + MEDIANS_FIXED + MEDIANS_COUNTERS];
            uint32_t count = 0;
            line[strcspn(line, "\n")] = 0;
            for (char* field = line; field != 0 && count < sizeof(fields) / sizeof(fields[0]);)
            {
                char* next = strchr(field, '\t');
                if (next != 0)
                {
                    *next = 0;
                    next += 1;
                }
                fields[count++] = field;
                field = next;
            }
            if (count < 6 + MEDIANS_FIXED || strcmp(fields[0], "round") == 0 || strcmp(fields[4], "1") == 0)
            {
                continue;
            }
            uint32_t l = 0;
            while (l < label_count && strcmp(labels[l].name, fields[2]) != 0)
            {
                l += 1;
            }
            if (l == label_count)
            {
                succeeded = label_count < MEDIANS_LABELS;
                if (succeeded)
                {
                    snprintf(labels[l].name, sizeof(labels[l].name), "%s", fields[2]);
                    for (uint32_t v = 0; succeeded && v < MEDIANS_FIELDS; v += 1)
                    {
                        labels[l].values[v] = calloc(MEDIANS_RUNS, sizeof(double));
                        succeeded = labels[l].values[v] != 0;
                    }
                    label_count += 1;
                }
            }
            if (succeeded)
            {
                MediansLabel* label = &labels[l];
                label->runs += 1;
                const bool passed = strcmp(fields[5], "0") == 0;
                label->failed += passed ? 0 : 1;
                if (passed && label->kept < MEDIANS_RUNS)
                {
                    for (uint32_t v = 0; v < MEDIANS_FIXED; v += 1)
                    {
                        label->values[v][label->kept] = strtod(fields[6 + v], 0);
                    }
                    for (uint32_t c = 6 + MEDIANS_FIXED; c < count; c += 1)
                    {
                        char* value = strchr(fields[c], '=');
                        if (value != 0)
                        {
                            *value = 0;
                            uint32_t k = 0;
                            while (k < counter_count && strcmp(counters[k], fields[c]) != 0)
                            {
                                k += 1;
                            }
                            if (k == counter_count && counter_count < MEDIANS_COUNTERS)
                            {
                                snprintf(counters[k], sizeof(counters[k]), "%s", fields[c]);
                                counter_count += 1;
                            }
                            if (k < counter_count)
                            {
                                label->values[MEDIANS_FIXED + k][label->kept] = strtod(value + 1, 0);
                            }
                        }
                    }
                    label->kept += 1;
                }
            }
        }
        if (file != 0)
        {
            fclose(file);
        }
    }
    if (succeeded)
    {
        printf("label\truns\tfailed\twall_ms\twall_min\twall_max\tspan_ms\tsettle_ms\tuser_ms\tsys_ms\tlate_user_ms\tlate_sys_ms\tlate_count\tpeak_mb\tminflt");
        for (uint32_t k = 0; k < counter_count; k += 1)
        {
            printf("\t%s_M", counters[k]);
        }
        printf("\n");
        for (uint32_t l = 0; l < label_count; l += 1)
        {
            MediansLabel* label = &labels[l];
            const uint32_t n = label->kept;
            // procbench's fixed columns: 0 wall_ns, 1 span_ns, 2 settle_ns, 3 user_us, 4 sys_us, 5 minflt, 6 majflt, 7 nvcsw,
            // 8 nivcsw, 9 maxrss_kb, 10 late_user_us, 11 late_sys_us, 12 late_minflt, 13 late_count.
            double least = 0.0;
            double greatest = 0.0;
            for (uint32_t r = 0; r < n; r += 1)
            {
                const double wall = label->values[0][r];
                least = r == 0 || wall < least ? wall : least;
                greatest = r == 0 || wall > greatest ? wall : greatest;
            }
            printf("%s\t%u\t%u\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.0f\t%.1f\t%.0f", label->name, label->runs, label->failed,
                   medians_median(label->values[0], n) / 1e6, least / 1e6, greatest / 1e6, medians_median(label->values[1], n) / 1e6,
                   medians_median(label->values[2], n) / 1e6, medians_median(label->values[3], n) / 1e3, medians_median(label->values[4], n) / 1e3,
                   medians_median(label->values[10], n) / 1e3, medians_median(label->values[11], n) / 1e3, medians_median(label->values[13], n),
                   medians_median(label->values[9], n) / 1024.0, medians_median(label->values[5], n));
            for (uint32_t k = 0; k < counter_count; k += 1)
            {
                printf("\t%.3f", medians_median(label->values[MEDIANS_FIXED + k], n) / 1e6);
            }
            printf("\n");
        }
    }
    return succeeded ? 0 : 1;
}
