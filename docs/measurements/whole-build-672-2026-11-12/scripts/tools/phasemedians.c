// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// phasemedians: the medians of several runs' own clocks, a line per phase.
//
//   phasemedians [--least N] REPORT...
//
// Each REPORT is one run's clock output, in any of three forms, told apart line by line:
// - the C driver's --time-stages: `time-stage NAME ms ...`, `time-write NAME ms` and `time-process NAME value` lines
//   (tab-separated), kept as `stage NAME`, `write NAME` and, for a numeric value, `process NAME`;
// - link-foreign's --time: `link-foreign: X ms on N lanes`, kept as `link total`, and its indented `NAME X ms [SUB Y]...`
//   lines, kept as `link NAME` and `link NAME.SUB`;
// - mold's --perf table, `User System Real Name` rows in seconds, kept as `mold NAME` in milliseconds of real time (a
//   name seen again in a report takes `#2`, `#3`).
// It prints, for each phase in the order of first appearance: how many reports had it, and its median, least and
// greatest values. With --least N it takes only the N reports whose total (`stage total`, `link total` or `mold all`)
// is least: the runs of a list's faster state, where its runs fall in two (a lane short of a CPU in some of them).

#define _GNU_SOURCE
#include <ctype.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PHASES_KEYS 1024
#define PHASES_RUNS 256
#define PHASES_NAME 128

typedef struct PhasesKey PhasesKey;
struct PhasesKey
{
    char name[PHASES_NAME];
    double values[PHASES_RUNS];
    uint32_t count;
    // The report that last gave it a value (from 1), so that a name repeated within a report is told apart.
    uint32_t report;
};

static PhasesKey phases_keys[PHASES_KEYS];
static uint32_t phases_key_count;

static void phases_add(const char* name, double value, uint32_t report)
{
    char unique[PHASES_NAME];
    snprintf(unique, sizeof(unique), "%s", name);
    PhasesKey* key = 0;
    for (uint32_t repeat = 2; key == 0; repeat += 1)
    {
        uint32_t k = 0;
        while (k < phases_key_count && strcmp(phases_keys[k].name, unique) != 0)
        {
            k += 1;
        }
        if (k == phases_key_count)
        {
            if (phases_key_count == PHASES_KEYS)
            {
                break;
            }
            snprintf(phases_keys[k].name, PHASES_NAME, "%s", unique);
            phases_key_count += 1;
        }
        if (phases_keys[k].report != report)
        {
            key = &phases_keys[k];
        }
        else
        {
            snprintf(unique, sizeof(unique), "%.100s#%u", name, repeat);
        }
    }
    if (key != 0 && key->count < PHASES_RUNS)
    {
        key->values[key->count] = value;
        key->count += 1;
        key->report = report;
    }
}

static int phases_compare(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return a < b ? -1 : a > b ? 1 : 0;
}

// A report's total: the first of its `stage total`, `link total` or `mold all` lines, or a negative number without one.
static double phases_total(const char* path)
{
    FILE* file = fopen(path, "r");
    double total = -1.0;
    char line[4096];
    while (file != 0 && total < 0.0 && fgets(line, sizeof(line), file) != 0)
    {
        double value = 0.0;
        double user = 0.0;
        double system = 0.0;
        int lanes = 0;
        if (sscanf(line, "time-stage\ttotal\t%lf", &value) == 1 || sscanf(line, "link-foreign: %lf ms on %d lane", &value, &lanes) == 2)
        {
            total = value;
        }
        else if (sscanf(line, " %lf %lf %lf all", &user, &system, &value) == 3)
        {
            total = value * 1000.0;
        }
    }
    if (file != 0)
    {
        fclose(file);
    }
    return total;
}

int main(int argc, char** argv)
{
    int first = 1;
    uint32_t least = 0;
    if (argc > 3 && strcmp(argv[1], "--least") == 0)
    {
        least = (uint32_t)strtoul(argv[2], 0, 10);
        first = 3;
    }
    bool succeeded = argc > first;
    if (!succeeded)
    {
        fprintf(stderr, "usage: phasemedians [--least N] REPORT...\n");
    }
    // With --least, the reports in the order of their totals, the first N of them kept (an insertion sort: a list's
    // reports are tens).
    static char* kept[PHASES_RUNS];
    static double totals[PHASES_RUNS];
    uint32_t kept_count = 0;
    for (int f = first; succeeded && f < argc && kept_count < PHASES_RUNS; f += 1)
    {
        const double total = least != 0 ? phases_total(argv[f]) : 0.0;
        uint32_t place = kept_count;
        while (least != 0 && place > 0 && totals[place - 1] > total)
        {
            kept[place] = kept[place - 1];
            totals[place] = totals[place - 1];
            place -= 1;
        }
        kept[place] = argv[f];
        totals[place] = total;
        kept_count += 1;
    }
    kept_count = least != 0 && least < kept_count ? least : kept_count;
    for (uint32_t r = 0; succeeded && r < kept_count; r += 1)
    {
        const int f = (int)r + 1;
        argv[f] = kept[r];
        FILE* file = fopen(argv[f], "r");
        succeeded = file != 0;
        if (!succeeded)
        {
            fprintf(stderr, "phasemedians: can't read %s\n", argv[f]);
        }
        char line[4096];
        const uint32_t report = r + 1;
        while (succeeded && fgets(line, sizeof(line), file) != 0)
        {
            char kind[32];
            char name[PHASES_NAME];
            char text[PHASES_NAME];
            char key[3 * PHASES_NAME];
            double value = 0.0;
            double user = 0.0;
            double system = 0.0;
            int lanes = 0;
            int consumed = 0;
            if (sscanf(line, "time-%31[a-z]\t%127[^\t\n]\t%127[^\t\n]", kind, name, text) == 3)
            {
                char* end = 0;
                value = strtod(text, &end);
                if (end != text && *end == 0 && strcmp(name, "stage") != 0)
                {
                    snprintf(key, sizeof(key), "%s %s", kind, name);
                    phases_add(key, value, report);
                }
            }
            else if (sscanf(line, "link-foreign: %lf ms on %d lane", &value, &lanes) == 2)
            {
                phases_add("link total", value, report);
            }
            else if (line[0] == ' ' && sscanf(line, " %127s %lf ms%n", name, &value, &consumed) == 2 && consumed > 0)
            {
                snprintf(key, sizeof(key), "link %s", name);
                phases_add(key, value, report);
                // The phase's own parts, `SUB Y` pairs; the lanes' line has words instead.
                const char* rest = line + consumed;
                char sub[PHASES_NAME];
                int step = 0;
                while (strcmp(name, "lanes") != 0 && sscanf(rest, " %127s %lf%n", sub, &value, &step) == 2 && step > 0)
                {
                    snprintf(key, sizeof(key), "link %s.%s", name, sub);
                    phases_add(key, value, report);
                    rest += step;
                }
            }
            else if (sscanf(line, " %lf %lf %lf %127s", &user, &system, &value, name) == 4 && isalpha((unsigned char)name[0]))
            {
                snprintf(key, sizeof(key), "mold %s", name);
                phases_add(key, value * 1000.0, report);
            }
        }
        if (file != 0)
        {
            fclose(file);
        }
    }
    if (succeeded)
    {
        printf("phase\treports\tmedian\tleast\tgreatest\n");
        for (uint32_t k = 0; k < phases_key_count; k += 1)
        {
            PhasesKey* key = &phases_keys[k];
            qsort(key->values, key->count, sizeof(double), phases_compare);
            const uint32_t n = key->count;
            const double median = n == 0 ? 0.0 : n % 2 == 1 ? key->values[n / 2] : (key->values[n / 2 - 1] + key->values[n / 2]) / 2.0;
            printf("%s\t%u\t%.3f\t%.3f\t%.3f\n", key->name, n, median, n == 0 ? 0.0 : key->values[0], n == 0 ? 0.0 : key->values[n - 1]);
        }
    }
    return succeeded ? 0 : 1;
}
