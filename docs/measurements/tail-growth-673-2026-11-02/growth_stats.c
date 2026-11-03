// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// growth_stats LOG...: summarizes #673's balanced policy cohorts (policy_balanced's collector output, one LOG per locked
// workload group, its cohorts in the directory LOG names without ".log"). Per policy role (0 jobserver, 1 cap one, 2
// unrestricted eight): the samples, their whole-cohort wall time's median, minimum and maximum, and the medians of user
// and system time, peak RSS, minor faults, context switches, migrations, user cycles and instructions; then every
// compile's --time-stages worker-budget line (granted, active, grown, worked), counted by value. Gates: every sample has
// a result of status 0 whose objects are identical, the nine predecessor/role pairs occur equally, and every usage and
// counter file parses. Times nothing.

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define GROWTH_SAMPLES 64
#define GROWTH_FIELDS 9
#define GROWTH_SHAPES 64

static int growth_compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double growth_median(double* values, unsigned count)
{
    qsort(values, count, sizeof(double), growth_compare);
    return count == 0 ? -1 : count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

// The number after `"key":` in a one-line JSON object, or -1.
static double growth_json(const char* path, const char* key)
{
    FILE* file = fopen(path, "r");
    char text[4096] = { 0 };
    const size_t length = file != NULL ? fread(text, 1, sizeof(text) - 1, file) : 0;
    if (file != NULL)
    {
        fclose(file);
    }
    text[length] = 0;
    char pattern[64];
    snprintf(pattern, sizeof(pattern), "\"%s\":", key);
    const char* at = strstr(text, pattern);
    return at != NULL ? strtod(at + strlen(pattern), NULL) : -1;
}

// perf stat -x, counter `event`'s value, or -1 when it is missing or didn't count its whole interval.
static double growth_counter(const char* path, const char* event)
{
    FILE* file = fopen(path, "r");
    char line[512];
    double result = -1;
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char* fields[8] = { 0 };
        unsigned count = 0;
        for (char* cursor = line; count < 8 && cursor != NULL; count += 1)
        {
            fields[count] = cursor;
            cursor = strchr(cursor, ',');
            if (cursor != NULL)
            {
                *cursor = 0;
                cursor += 1;
            }
        }
        if (count >= 5 && strcmp(fields[2], event) == 0 && strtod(fields[4], NULL) == 100.0)
        {
            result = strtod(fields[0], NULL);
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return result;
}

typedef struct GrowthShape GrowthShape;
struct GrowthShape
{
    unsigned role;
    unsigned granted;
    unsigned active;
    unsigned grown;
    unsigned worked;
    unsigned count;
};

int main(int argc, char** argv)
{
    bool valid = argc >= 2;
    static const char* const names[] = { "jobserver", "cap1", "free8" };
    printf("log\tpolicy\tn\twall_ms\tmin_ms\tmax_ms\tuser_ms\tsystem_ms\tmaxrss_kib\tminor_faults\tcontext_switches\tmigrations\tcycles\tinstructions\n");
    for (int a = 1; valid && a < argc; a += 1)
    {
        FILE* log = fopen(argv[a], "r");
        valid = log != NULL;
        static double values[3][GROWTH_FIELDS][GROWTH_SAMPLES];
        unsigned counts[3] = { 0 };
        unsigned pairs[3][3] = { 0 };
        unsigned results = 0;
        unsigned samples = 0;
        GrowthShape shapes[GROWTH_SHAPES];
        unsigned shape_count = 0;
        char line[8192];
        while (valid && fgets(line, sizeof(line), log) != NULL)
        {
            unsigned workload = 0;
            unsigned index = 0;
            unsigned role = 0;
            unsigned before = 0;
            unsigned identical = 0;
            int status = 0;
            char directory[4096];
            if (sscanf(line, "sample workload=%u case=%u role=%u predecessor=%u directory=%4095s", &workload, &index, &role, &before, directory) == 5)
            {
                valid = role < 3 && before < 3 && counts[role] < GROWTH_SAMPLES;
                samples += 1;
                pairs[before][role] += valid ? 1 : 0;
                // The cohort's directory where the log is: its logged path's last name in LOG's stem.
                const char* name = strrchr(directory, '/');
                const size_t stem = strlen(argv[a]) > 4 ? strlen(argv[a]) - 4 : 0;
                char cohort[8400];
                snprintf(cohort, sizeof(cohort), "%.*s/%s", (int)stem, argv[a], name != NULL ? name + 1 : directory);
                memcpy(directory, cohort, strlen(cohort) < sizeof(directory) ? strlen(cohort) + 1 : 0);
                char path[4200];
                snprintf(path, sizeof(path), "%s/sample.usage", directory);
                static const char* const fields[] = { "wall_s", "user_s", "system_s", "maxrss_kb", "minor_faults" };
                const unsigned count = valid ? counts[role] : 0;
                for (unsigned f = 0; valid && f < 5; f += 1)
                {
                    values[role][f][count] = growth_json(path, fields[f]);
                    valid = values[role][f][count] >= 0;
                }
                valid = valid && growth_json(path, "status") == 0;
                snprintf(path, sizeof(path), "%s/perf.csv", directory);
                static const char* const events[] = { "context-switches", "cpu-migrations", "cycles", "instructions" };
                for (unsigned e = 0; valid && e < 4; e += 1)
                {
                    values[role][5 + e][count] = growth_counter(path, events[e]);
                    valid = values[role][5 + e][count] >= 0;
                }
                // Every compile's worker-budget line.
                for (unsigned file = 0; valid && file < 8; file += 1)
                {
                    snprintf(path, sizeof(path), "%s/%u.stderr", directory, file);
                    FILE* errors = fopen(path, "r");
                    GrowthShape shape = { .role = role, .count = 1 };
                    bool found = false;
                    char text[512];
                    while (errors != NULL && fgets(text, sizeof(text), errors) != NULL)
                    {
                        found |= sscanf(text, "worker-budget\tmode=%*[^\t]\tlimit=%*u\trequested=%*u\tgranted=%u\tactive=%u\tgrown=%u\tworked=%u", &shape.granted,
                                        &shape.active, &shape.grown, &shape.worked) == 4;
                        // The exploratory tree's line has no worked, and main's neither that nor grown.
                        found |= !found && sscanf(text, "worker-budget\tmode=%*[^\t]\tlimit=%*u\trequested=%*u\tgranted=%u\tactive=%u\tgrown=%u\tfallback",
                                                  &shape.granted, &shape.active, &shape.grown) == 3;
                        found |= !found && sscanf(text, "worker-budget\tmode=%*[^\t]\tlimit=%*u\trequested=%*u\tgranted=%u\tactive=%u\tfallback", &shape.granted,
                                                  &shape.active) == 2;
                    }
                    if (errors != NULL)
                    {
                        fclose(errors);
                    }
                    unsigned s = 0;
                    while (found && s < shape_count &&
                           !(shapes[s].role == shape.role && shapes[s].granted == shape.granted && shapes[s].active == shape.active &&
                             shapes[s].grown == shape.grown && shapes[s].worked == shape.worked))
                    {
                        s += 1;
                    }
                    if (found && s < shape_count)
                    {
                        shapes[s].count += 1;
                    }
                    else if (found && shape_count < GROWTH_SHAPES)
                    {
                        shapes[shape_count++] = shape;
                    }
                }
                counts[role] += valid ? 1 : 0;
            }
            else if (sscanf(line, "result workload=%u case=%u role=%u status=%d identical=%u", &workload, &index, &role, &status, &identical) == 5 &&
                     strncmp(line, "result", 6) == 0)
            {
                results += 1;
                valid = status == 0 && identical == 1;
            }
        }
        if (log != NULL)
        {
            fclose(log);
        }
        // The primer's result is one more than the samples.
        valid = valid && samples != 0 && results == samples + 1;
        for (unsigned before = 0; valid && before < 3; before += 1)
        {
            for (unsigned role = 0; valid && role < 3; role += 1)
            {
                valid = pairs[before][role] == pairs[0][0];
            }
        }
        for (unsigned role = 0; valid && role < 3; role += 1)
        {
            double wall[GROWTH_SAMPLES];
            memcpy(wall, values[role][0], sizeof(double) * counts[role]);
            qsort(wall, counts[role], sizeof(double), growth_compare);
            double medians[GROWTH_FIELDS];
            for (unsigned f = 0; f < GROWTH_FIELDS; f += 1)
            {
                medians[f] = growth_median(values[role][f], counts[role]);
            }
            printf("%s\t%s\t%u\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n", argv[a], names[role], counts[role], medians[0] * 1000,
                   wall[0] * 1000, wall[counts[role] - 1] * 1000, medians[1] * 1000, medians[2] * 1000, medians[3], medians[4], medians[5], medians[6], medians[7],
                   medians[8]);
        }
        for (unsigned s = 0; valid && s < shape_count; s += 1)
        {
            printf("# %s\t%s\tgranted=%u\tactive=%u\tgrown=%u\tworked=%u\tcompiles=%u\n", argv[a], names[shapes[s].role], shapes[s].granted, shapes[s].active,
                   shapes[s].grown, shapes[s].worked, shapes[s].count);
        }
        if (!valid)
        {
            fprintf(stderr, "growth_stats: %s fails its gates\n", argv[a]);
        }
    }
    return valid ? 0 : 1;
}
