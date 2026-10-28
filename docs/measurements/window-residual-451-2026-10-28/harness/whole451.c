// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original analyzer for #451's one-executable, two-list configuration cohorts.
// Require all 21 pairs and a successful footer; keep faults/statuses and do not turn unavailable PMU fields into zeros.
#define _GNU_SOURCE
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { BUSTER_451_RUNS = 21, BUSTER_451_FIELDS = 8, BUSTER_451_BOOTSTRAPS = 10000 };
typedef struct WholeRow451 WholeRow451;
struct WholeRow451
{
    double fields[BUSTER_451_FIELDS];
    bool seen;
};
typedef struct Whole451 Whole451;
struct Whole451
{
    WholeRow451 rows[BUSTER_451_RUNS][2];
    unsigned loaded;
    unsigned done;
    unsigned failed;
    unsigned long long major[2];
    bool pmu;
    char label[512];
};

static bool read_whole451(FILE* input, Whole451* result)
{
    *result = (Whole451){ .pmu = true };
    char* line = NULL;
    size_t room = 0;
    bool valid = input != NULL;
    while (valid && getline(&line, &room, input) >= 0)
    {
        if (strstr(line, "FAILED") != NULL)
        {
            valid = false;
        }
        if (strstr(line, "user cycles weren't counted for every process") != NULL)
        {
            result->pmu = false;
        }
        unsigned failed = 0;
        if (sscanf(line, "time-runs: done, %u failed processes", &failed) == 1)
        {
            result->done += 1;
            result->failed += failed;
        }
        if (strncmp(line, "run ", 4) == 0)
        {
            unsigned run = 0;
            unsigned list = 0;
            char label[512];
            double wall = 0;
            double user = 0;
            double system = 0;
            unsigned long long rss = 0;
            unsigned long long minor = 0;
            unsigned long long major = 0;
            unsigned long long cycles = 0;
            unsigned long long instructions = 0;
            int status = -1;
            const int fields = sscanf(line, "run %u list %u %511[^:]: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d",
                                      &run, &list, label, &wall, &user, &system, &rss, &minor, &major, &cycles, &instructions, &status);
            valid = valid && fields == 12 && run >= 1 && run <= BUSTER_451_RUNS && list >= 1 && list <= 2 && status == 0 &&
                    isfinite(wall) && wall > 0 && isfinite(user) && user >= 0 && isfinite(system) && system >= 0;
            if (valid)
            {
                WholeRow451* row = &result->rows[run - 1][list - 1];
                valid = !row->seen;
                if (result->loaded == 0)
                {
                    snprintf(result->label, sizeof(result->label), "%s", label);
                }
                valid = valid && strcmp(result->label, label) == 0;
                const double values[] = { wall, user, system, rss, minor, major, cycles, instructions };
                memcpy(row->fields, values, sizeof(values));
                row->seen = true;
                result->loaded += 1;
                result->major[list - 1] += major;
                result->pmu &= cycles != 0 && instructions != 0;
            }
        }
    }
    valid = valid && result->loaded == 2 * BUSTER_451_RUNS && result->done == 1 && result->failed == 0 && ferror(input) == 0;
    for (unsigned run = 0; valid && run < BUSTER_451_RUNS; run += 1)
    {
        valid = result->rows[run][0].seen && result->rows[run][1].seen;
    }
    free(line);
    return valid;
}

static int compare_whole451(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median_whole451(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare_whole451);
    return count & 1 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) * 0.5;
}

static uint64_t random_whole451(uint64_t* state)
{
    uint64_t value = *state;
    value ^= value << 13;
    value ^= value >> 7;
    value ^= value << 17;
    *state = value;
    return value;
}

int main(int argc, char** argv)
{
    FILE* input = argc == 2 ? fopen(argv[1], "r") : NULL;
    Whole451 data;
    bool valid = read_whole451(input, &data);
    if (input != NULL)
    {
        valid = fclose(input) == 0 && valid;
    }
    if (valid)
    {
        static const char* const names[] = { "wall_ms", "user_ms", "system_ms", "peak_kib", "minor", "major", "user_cycles", "instructions" };
        printf("whole451: 21 complete pairs, statuses=0, major_total=%llu/%llu, pmu=%s\n", data.major[0], data.major[1], data.pmu ? "counted" : "unavailable");
        for (unsigned field = 0; field < BUSTER_451_FIELDS; field += 1)
        {
            double values[2][BUSTER_451_RUNS];
            for (unsigned run = 0; run < BUSTER_451_RUNS; run += 1)
            {
                values[0][run] = data.rows[run][0].fields[field];
                values[1][run] = data.rows[run][1].fields[field];
            }
            if (field < 6 || data.pmu)
            {
                printf("%s list1=%.6f list2=%.6f\n", names[field], median_whole451(values[0], BUSTER_451_RUNS), median_whole451(values[1], BUSTER_451_RUNS));
            }
            else
            {
                printf("%s unavailable\n", names[field]);
            }
        }
        double pairs[BUSTER_451_RUNS];
        for (unsigned run = 0; run < BUSTER_451_RUNS; run += 1)
        {
            pairs[run] = 100.0 * (data.rows[run][1].fields[0] / data.rows[run][0].fields[0] - 1.0);
        }
        double deltas[BUSTER_451_RUNS];
        memcpy(deltas, pairs, sizeof(pairs));
        const double point = median_whole451(deltas, BUSTER_451_RUNS);
        double bootstrap[BUSTER_451_BOOTSTRAPS];
        uint64_t state = UINT64_C(0x451e7f89091);
        for (unsigned sample = 0; sample < BUSTER_451_BOOTSTRAPS; sample += 1)
        {
            for (unsigned run = 0; run < BUSTER_451_RUNS; run += 1)
            {
                deltas[run] = pairs[random_whole451(&state) % BUSTER_451_RUNS];
            }
            bootstrap[sample] = median_whole451(deltas, BUSTER_451_RUNS);
        }
        qsort(bootstrap, BUSTER_451_BOOTSTRAPS, sizeof(*bootstrap), compare_whole451);
        printf("paired_wall_list2_vs_list1_pct=%.6f within_cohort_bootstrap_95=[%.6f,%.6f] seed=0x451e7f89091\n",
               point, bootstrap[250], bootstrap[9749]);
    }
    else
    {
        fprintf(stderr, "whole451: invalid/incomplete cohort: rows=%u footer=%u failed=%u\n", data.loaded, data.done, data.failed);
    }
    return !valid;
}
