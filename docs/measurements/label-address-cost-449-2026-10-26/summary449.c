// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Read-only summary of #449's five paired rounds. A perf -r11 row is a mean, not an individual sample or median.
// Build: clang -O2 -Wall -Wextra -Werror summary449.c -o summary449 -lm
// Usage: summary449 RAW_DIRECTORY; summary449 --self-test
#define _GNU_SOURCE
#include <ctype.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum
{
    BUSTER_ROUNDS = 5,
    BUSTER_TREES = 2,
    BUSTER_LISTS = 4,
    BUSTER_RUNS = 21,
    BUSTER_FIELDS = 6,
};

static double median(const double* input, unsigned count)
{
    double values[BUSTER_RUNS];
    for (unsigned i = 0; i < count; i += 1)
    {
        unsigned slot = i;
        while (slot != 0 && values[slot - 1] > input[i])
        {
            values[slot] = values[slot - 1];
            slot -= 1;
        }
        values[slot] = input[i];
    }
    return values[count / 2];
}

static bool receipt(const char* line, unsigned* exits)
{
    int status = -1;
    bool valid = true;
    if (sscanf(line, "exit=%d", &status) == 1)
    {
        *exits += 1;
        valid = *exits == 1 && status == 0;
    }
    return valid;
}

static bool process_log(FILE* file, double result[BUSTER_LISTS][BUSTER_FIELDS])
{
    double values[BUSTER_LISTS][BUSTER_FIELDS][BUSTER_RUNS] = { 0 };
    bool seen[BUSTER_LISTS][BUSTER_RUNS] = { 0 };
    bool summaries[BUSTER_LISTS] = { 0 };
    unsigned exits = 0;
    unsigned done = 0;
    char* line = NULL;
    size_t capacity = 0;
    bool valid = true;
    while (getline(&line, &capacity, file) >= 0)
    {
        valid = receipt(line, &exits) && valid && strstr(line, "FAILED") == NULL;
        unsigned run = 0;
        unsigned list = 0;
        if (strncmp(line, "run ", 4) == 0)
        {
            double wall = 0, user = 0, system = 0;
            unsigned long long peak = 0, minor = 0, major = 0;
            int status = -1;
            const int fields = sscanf(line, "run %u list %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, status %d",
                                      &run, &list, &wall, &user, &system, &peak, &minor, &major, &status);
            const bool row = fields == 9 && run >= 1 && run <= BUSTER_RUNS && list >= 1 && list <= BUSTER_LISTS &&
                             isfinite(wall) && wall > 0 && isfinite(user) && user >= 0 && isfinite(system) && system >= 0 && peak != 0 && status == 0;
            valid = row && valid;
            if (row)
            {
                valid = !seen[list - 1][run - 1] && valid;
                seen[list - 1][run - 1] = true;
                const double one[BUSTER_FIELDS] = { wall, user, system, (double)peak, (double)minor, (double)major };
                for (unsigned field = 0; field < BUSTER_FIELDS; field += 1)
                {
                    values[list - 1][field][run - 1] = one[field];
                }
            }
        }
        else if (strncmp(line, "list ", 5) == 0)
        {
            const char* after = strstr(line, "]: ");
            unsigned runs = 0;
            valid = sscanf(line, "list %u [", &list) == 1 && list >= 1 && list <= BUSTER_LISTS && after != NULL && valid;
            if (list >= 1 && list <= BUSTER_LISTS && after != NULL)
            {
                valid = !summaries[list - 1] && sscanf(after + 3, "%u runs, median", &runs) == 1 && runs == BUSTER_RUNS && valid;
                summaries[list - 1] = true;
            }
        }
        else if (strncmp(line, "time-runs: done, ", 17) == 0)
        {
            unsigned failed = 1;
            done += 1;
            valid = sscanf(line, "time-runs: done, %u failed processes", &failed) == 1 && failed == 0 && done == 1 && valid;
        }
    }
    valid = !ferror(file) && exits == 1 && done == 1 && valid;
    for (unsigned list = 0; list < BUSTER_LISTS; list += 1)
    {
        valid = summaries[list] && valid;
        for (unsigned run = 0; run < BUSTER_RUNS; run += 1)
        {
            valid = seen[list][run] && valid;
        }
        for (unsigned field = 0; field < BUSTER_FIELDS; field += 1)
        {
            result[list][field] = median(values[list][field], BUSTER_RUNS);
        }
    }
    free(line);
    return valid;
}

static bool perf_log(FILE* file, double result[2])
{
    const char* events[2] = { "instructions:u", "cycles:u" };
    bool seen[2] = { false, false };
    unsigned exits = 0;
    char* line = NULL;
    size_t capacity = 0;
    bool valid = true;
    while (getline(&line, &capacity, file) >= 0)
    {
        valid = receipt(line, &exits) && valid && strstr(line, "<not counted>") == NULL && strstr(line, "<not supported>") == NULL &&
                strstr(line, "non-zero status") == NULL && strstr(line, "Workload failed") == NULL;
        char* cursor = line;
        char* first = strsep(&cursor, ",");
        char* field = NULL;
        while ((field = strsep(&cursor, ",")) != NULL)
        {
            field[strcspn(field, "\r\n")] = 0;
            for (unsigned event = 0; event < 2; event += 1)
            {
                if (strcmp(field, events[event]) == 0)
                {
                    char* end = NULL;
                    const double value = strtod(first, &end);
                    while (isspace((unsigned char)*end))
                    {
                        end += 1;
                    }
                    valid = !seen[event] && end != first && *end == 0 && isfinite(value) && value > 0 && valid;
                    seen[event] = true;
                    result[event] = value;
                }
            }
        }
    }
    valid = !ferror(file) && exits == 1 && seen[0] && seen[1] && valid;
    free(line);
    return valid;
}

static bool preflight_log(FILE* file)
{
    unsigned exits = 0;
    char* line = NULL;
    size_t capacity = 0;
    bool valid = true;
    while (getline(&line, &capacity, file) >= 0)
    {
        valid = receipt(line, &exits) && valid;
    }
    valid = !ferror(file) && exits == 1 && valid;
    free(line);
    return valid;
}

static bool read_log(const char* directory, const char* name, unsigned kind, double* values)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/%s.log", directory, name);
    FILE* file = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "r") : NULL;
    bool valid = file != NULL;
    if (file != NULL)
    {
        valid = kind == 0 ? process_log(file, (double (*)[BUSTER_FIELDS])values) : kind == 1 ? perf_log(file, values) : preflight_log(file);
        valid = fclose(file) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "summary449: missing, incomplete or unsuccessful log: %s/%s.log\n", directory, name);
    }
    return valid;
}

static void print_row(const char* workload, const char* metric, const char* aggregation, const double base[BUSTER_ROUNDS], const double head[BUSTER_ROUNDS])
{
    double delta[BUSTER_ROUNDS];
    double percent[BUSTER_ROUNDS];
    double low[4] = { base[0], head[0], head[0] - base[0], 0 };
    double high[4] = { base[0], head[0], head[0] - base[0], 0 };
    bool relative = true;
    for (unsigned round = 0; round < BUSTER_ROUNDS; round += 1)
    {
        delta[round] = head[round] - base[round];
        percent[round] = base[round] != 0 ? 100 * delta[round] / base[round] : 0;
        relative = base[round] != 0 && relative;
        const double fields[4] = { base[round], head[round], delta[round], percent[round] };
        for (unsigned field = 0; field < 4; field += 1)
        {
            low[field] = round == 0 || fields[field] < low[field] ? fields[field] : low[field];
            high[field] = round == 0 || fields[field] > high[field] ? fields[field] : high[field];
        }
    }
    const double before = median(base, BUSTER_ROUNDS);
    const double after = median(head, BUSTER_ROUNDS);
    printf("%s\t%s\t%s\t%.3f\t%.3f\t%.3f\t", workload, metric, aggregation, before, after, after - before);
    if (before != 0)
    {
        printf("%.4f", 100 * (after - before) / before);
    }
    else
    {
        fputs("NA", stdout);
    }
    printf("\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t", low[0], high[0], low[1], high[1], median(delta, BUSTER_ROUNDS), low[2], high[2]);
    if (relative)
    {
        printf("%.4f\t%.4f\t%.4f\n", median(percent, BUSTER_ROUNDS), low[3], high[3]);
    }
    else
    {
        puts("NA\tNA\tNA");
    }
}

static bool self_test(void)
{
    bool valid = true;
    for (unsigned mutation = 0; mutation < 10; mutation += 1)
    {
        FILE* file = tmpfile();
        bool accepted = false;
        if (file != NULL)
        {
            for (unsigned run = 1; run <= BUSTER_RUNS; run += 1)
            {
                for (unsigned list = 1; list <= BUSTER_LISTS; list += 1)
                {
                    if (!(mutation == 1 && run == 1 && list == 1))
                    {
                        fprintf(file, "run %u list %u: %.3f ms wall, 10.000 ms user, 1.000 ms system, 1024 KB peak, 10 minor faults, 0 major, status %d\n",
                                run, list, 100.0 + run + list, mutation == 2 && run == 1 && list == 1 ? 1 : 0);
                    }
                }
            }
            for (unsigned list = 1; list <= BUSTER_LISTS; list += 1)
            {
                fprintf(file, "list %u [synthetic]: %u runs, median 1\n", list, mutation == 3 ? 20 : BUSTER_RUNS);
            }
            if (mutation == 7)
            {
                fputs("run 1 list 1: 102.000 ms wall, 10.000 ms user, 1.000 ms system, 1024 KB peak, 10 minor faults, 0 major, status 0\n", file);
            }
            if (mutation == 8)
            {
                fputs("run 22 list 1: 102.000 ms wall, 10.000 ms user, 1.000 ms system, 1024 KB peak, 10 minor faults, 0 major, status 0\n", file);
            }
            if (mutation == 9)
            {
                fputs("warm-up 1 list 1: FAILED (status 3)\n", file);
            }
            fprintf(file, "time-runs: done, %u failed processes\n", mutation == 4 ? 1 : 0);
            if (mutation != 5)
            {
                fprintf(file, "exit=%d end: synthetic\n", mutation == 6 ? 1 : 0);
            }
            rewind(file);
            double result[BUSTER_LISTS][BUSTER_FIELDS];
            accepted = process_log(file, result);
            valid = fclose(file) == 0 && valid;
            valid = (mutation != 0 || result[0][0] == 112) && valid;
        }
        valid = file != NULL && accepted == (mutation == 0) && valid;
    }
    for (unsigned mutation = 0; mutation < 6; mutation += 1)
    {
        FILE* file = tmpfile();
        bool accepted = false;
        if (file != NULL)
        {
            fprintf(file, "%s,,instructions:u,0.00%%\n", mutation == 1 ? "<not counted>" : "1700000001");
            if (mutation != 2)
            {
                fputs("400000000,,cycles:u,0.10%\n", file);
            }
            if (mutation == 3)
            {
                fputs("1700000001,,instructions:u,0.00%\n", file);
            }
            if (mutation != 4)
            {
                fprintf(file, "exit=%d end: synthetic\n", mutation == 5 ? 1 : 0);
            }
            rewind(file);
            double result[2] = { 0 };
            accepted = perf_log(file, result);
            valid = fclose(file) == 0 && valid;
        }
        valid = file != NULL && accepted == (mutation == 0) && valid;
    }
    fprintf(stderr, "summary449 self-test: %s (synthetic parser fixtures only)\n", valid ? "passed" : "FAILED");
    return valid;
}

int main(int argc, char** argv)
{
    const char* trees[BUSTER_TREES] = { "base", "head449" };
    const char* workloads[BUSTER_LISTS] = { "sqlite-check", "lua-lstrlib-c", "lua-lparser-c", "label-dispatch-check" };
    const char* preflights[BUSTER_LISTS] = { "sqlite", "lstrlib", "lparser", "labels" };
    const char* fields[BUSTER_FIELDS] = { "wall_ms", "user_ms", "system_ms", "peak_KB", "minor_faults", "major_faults" };
    double processes[BUSTER_ROUNDS][BUSTER_TREES][BUSTER_LISTS][BUSTER_FIELDS] = { 0 };
    double counters[BUSTER_ROUNDS][BUSTER_TREES][2][2] = { 0 };
    bool valid = argc == 2;
    if (valid && strcmp(argv[1], "--self-test") == 0)
    {
        valid = self_test();
    }
    else if (valid)
    {
        char name[128];
        for (unsigned tree = 0; tree < BUSTER_TREES; tree += 1)
        {
            for (unsigned workload = 0; workload < BUSTER_LISTS; workload += 1)
            {
                snprintf(name, sizeof(name), "preflight-%s-%s", trees[tree], preflights[workload]);
                valid = read_log(argv[1], name, 2, NULL) && valid;
            }
        }
        for (unsigned round = 0; round < BUSTER_ROUNDS; round += 1)
        {
            for (unsigned tree = 0; tree < BUSTER_TREES; tree += 1)
            {
                snprintf(name, sizeof(name), "process-%u-%s", round + 1, trees[tree]);
                valid = read_log(argv[1], name, 0, &processes[round][tree][0][0]) && valid;
                for (unsigned workload = 0; workload < 2; workload += 1)
                {
                    snprintf(name, sizeof(name), "%sperf-%u-%s", workload == 0 ? "" : "labels-", round + 1, trees[tree]);
                    valid = read_log(argv[1], name, 1, counters[round][tree][workload]) && valid;
                }
            }
        }
        if (valid)
        {
            puts("workload\tmetric\taggregation\tbase\thead\tdelta\tpercent\tbase_round_min\tbase_round_max\thead_round_min\thead_round_max\tpaired_delta_median\tpaired_delta_min\tpaired_delta_max\tpaired_percent_median\tpaired_percent_min\tpaired_percent_max");
            for (unsigned workload = 0; workload < BUSTER_LISTS; workload += 1)
            {
                for (unsigned field = 0; field < BUSTER_FIELDS; field += 1)
                {
                    double base[BUSTER_ROUNDS], head[BUSTER_ROUNDS];
                    for (unsigned round = 0; round < BUSTER_ROUNDS; round += 1)
                    {
                        base[round] = processes[round][0][workload][field];
                        head[round] = processes[round][1][workload][field];
                    }
                    print_row(workloads[workload], fields[field], "median_of_round_medians", base, head);
                }
            }
            for (unsigned workload = 0; workload < 2; workload += 1)
            {
                for (unsigned event = 0; event < 2; event += 1)
                {
                    double base[BUSTER_ROUNDS], head[BUSTER_ROUNDS];
                    for (unsigned round = 0; round < BUSTER_ROUNDS; round += 1)
                    {
                        base[round] = counters[round][0][workload][event];
                        head[round] = counters[round][1][workload][event];
                    }
                    print_row(workloads[workload == 0 ? 0 : 3], event == 0 ? "instructions:u" : "cycles:u", "median_of_round_means", base, head);
                }
            }
        }
    }
    else
    {
        fputs("usage: summary449 RAW_DIRECTORY | --self-test\n", stderr);
    }
    return valid && !ferror(stdout) ? 0 : 1;
}
