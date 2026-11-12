// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// reduce DIR: perf stat's CSVs DIR/stat-NAME-ROUND.csv (NAME is a way, or a way and a variant: main-random,
// head-fixed), with /proc/vmstat's counts around each run in DIR/vmstat-NAME-ROUND.txt where the run has them, as two
// tables on standard output:
//   - each round: its page faults, the huge pages it was given at a fault (thp_fault_alloc's difference) and refused
//     (thp_fault_fallback's), its user and kernel cycles and instructions and its task clock;
//   - each NAME's medians by page state: "huge" for a run given huge pages at its faults, "none" for one given none
//     (file-scope-design-672-2026-11-12's section 13), "-" for a run without vmstat counts.
// Build: cc -O2 -o reduce reduce.c

#include <dirent.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REDUCE_RUNS 512
#define REDUCE_NAME 64

typedef struct ReduceRun ReduceRun;
struct ReduceRun
{
    char name[REDUCE_NAME];
    char state[8];
    uint32_t round;
    double user_cycles;
    double kernel_cycles;
    double both_cycles;
    double user_instructions;
    double kernel_instructions;
    double task_clock;
    double page_faults;
    int64_t huge;
    int64_t refused;
};

static ReduceRun runs[REDUCE_RUNS];
static uint32_t run_count;

// Reads one perf stat CSV's events into the run. Returns whether every event had a value.
static bool reduce_stat(const char* path, ReduceRun* run)
{
    FILE* file = fopen(path, "r");
    char line[512];
    uint32_t found = 0;
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char* first = strchr(line, ',');
        char* second = first != NULL ? strchr(first + 1, ',') : NULL;
        char* third = second != NULL ? strchr(second + 1, ',') : NULL;
        if (line[0] != '#' && third != NULL)
        {
            *third = 0;
            const char* event = second + 1;
            char* end = NULL;
            const double value = strtod(line, &end);
            const bool number = end != line;
            double* target = strcmp(event, "cycles:u") == 0 ? &run->user_cycles : strcmp(event, "cycles:k") == 0 ? &run->kernel_cycles
                             : strcmp(event, "instructions:u") == 0                                       ? &run->user_instructions
                             : strcmp(event, "instructions:k") == 0                                       ? &run->kernel_instructions
                             : strcmp(event, "task-clock") == 0                                           ? &run->task_clock
                             : strcmp(event, "page-faults") == 0                                          ? &run->page_faults
                                                                                                          : NULL;
            if (target != NULL && number)
            {
                *target = value;
                found += 1;
            }
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return found == 6;
}

// The value of `key` on a line of /proc/vmstat's counts (key value key value ...), or -1.
static int64_t reduce_count(const char* line, const char* key)
{
    int64_t result = -1;
    const size_t length = strlen(key);
    const char* at = line;
    while (result < 0 && (at = strstr(at, key)) != NULL)
    {
        const bool whole = (at == line || at[-1] == ' ') && at[length] == ' ';
        result = whole ? strtoll(at + length + 1, NULL, 10) : -1;
        at += length;
    }
    return result;
}

// Reads the vmstat counts before and after the run into its huge pages and refusals. Returns whether the file had both.
static bool reduce_vmstat(const char* path, ReduceRun* run)
{
    FILE* file = fopen(path, "r");
    char before[1024] = { 0 };
    char after[1024] = { 0 };
    const bool read = file != NULL && fgets(before, sizeof(before), file) != NULL && fgets(after, sizeof(after), file) != NULL;
    if (file != NULL)
    {
        fclose(file);
    }
    const int64_t alloc_before = read ? reduce_count(before, "thp_fault_alloc") : -1;
    const int64_t alloc_after = read ? reduce_count(after, "thp_fault_alloc") : -1;
    const int64_t fallback_before = read ? reduce_count(before, "thp_fault_fallback") : -1;
    const int64_t fallback_after = read ? reduce_count(after, "thp_fault_fallback") : -1;
    const bool valid = alloc_before >= 0 && alloc_after >= 0 && fallback_before >= 0 && fallback_after >= 0;
    run->huge = valid ? alloc_after - alloc_before : -1;
    run->refused = valid ? fallback_after - fallback_before : -1;
    return valid;
}

static int reduce_compare_doubles(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static int reduce_compare_runs(const void* a, const void* b)
{
    const ReduceRun* x = a;
    const ReduceRun* y = b;
    const int names = strcmp(x->name, y->name);
    return names != 0 ? names : (x->round > y->round) - (x->round < y->round);
}

// The median of the runs' field at `offset` among those of `name` and `state`.
static double reduce_median(const char* name, const char* state, size_t offset, uint32_t* count)
{
    double values[REDUCE_RUNS];
    uint32_t n = 0;
    for (uint32_t i = 0; i < run_count; i += 1)
    {
        if (strcmp(runs[i].name, name) == 0 && strcmp(runs[i].state, state) == 0)
        {
            values[n] = *(const double*)((const char*)&runs[i] + offset);
            n += 1;
        }
    }
    qsort(values, n, sizeof(double), reduce_compare_doubles);
    *count = n;
    return n == 0 ? 0 : n % 2 == 1 ? values[n / 2] : (values[n / 2 - 1] + values[n / 2]) / 2;
}

int main(int argc, char** argv)
{
    int status = argc == 2 ? 0 : 2;
    DIR* directory = status == 0 ? opendir(argv[1]) : NULL;
    status = status == 0 && directory == NULL ? 1 : status;
    struct dirent* entry = NULL;
    while (directory != NULL && (entry = readdir(directory)) != NULL)
    {
        const size_t length = strlen(entry->d_name);
        const char* dash = strrchr(entry->d_name, '-');
        const bool stat = length > 9 && strncmp(entry->d_name, "stat-", 5) == 0 && strcmp(entry->d_name + length - 4, ".csv") == 0 && dash != NULL &&
                          dash > entry->d_name + 5 && (size_t)(dash - entry->d_name - 5) < REDUCE_NAME;
        if (stat && run_count < REDUCE_RUNS)
        {
            ReduceRun* run = &runs[run_count];
            memset(run, 0, sizeof(*run));
            memcpy(run->name, entry->d_name + 5, (size_t)(dash - entry->d_name - 5));
            run->round = (uint32_t)strtoul(dash + 1, NULL, 10);
            char path[4096];
            snprintf(path, sizeof(path), "%s/%s", argv[1], entry->d_name);
            const bool counted = reduce_stat(path, run);
            snprintf(path, sizeof(path), "%s/vmstat-%s-%u.txt", argv[1], run->name, run->round);
            const bool paged = reduce_vmstat(path, run);
            snprintf(run->state, sizeof(run->state), "%s", !paged ? "-" : run->huge > 0 ? "huge" : "none");
            run->both_cycles = run->user_cycles + run->kernel_cycles;
            run_count += counted ? 1 : 0;
            if (!counted)
            {
                fprintf(stderr, "reduce: %s/%s lacks an event\n", argv[1], entry->d_name);
                status = 1;
            }
        }
    }
    if (directory != NULL)
    {
        closedir(directory);
    }
    if (argc != 2)
    {
        fprintf(stderr, "usage: reduce DIR\n");
    }
    qsort(runs, run_count, sizeof(ReduceRun), reduce_compare_runs);
    printf("# rounds\nname\tround\tstate\tpage faults\thuge pages at a fault\trefused\tuser cycles\tkernel cycles\tuser instructions\tkernel instructions\tCPU ms\n");
    for (uint32_t i = 0; i < run_count; i += 1)
    {
        const ReduceRun* run = &runs[i];
        printf("%s\t%u\t%s\t%.0f\t%lld\t%lld\t%.0f\t%.0f\t%.0f\t%.0f\t%.2f\n", run->name, run->round, run->state, run->page_faults, (long long)run->huge,
               (long long)run->refused, run->user_cycles, run->kernel_cycles, run->user_instructions, run->kernel_instructions, run->task_clock);
    }
    printf("\n# medians by page state\nname\tstate\truns\tpage faults\tuser cycles (M)\tkernel cycles (M)\tboth (M)\tuser instructions (M)\tCPU ms\n");
    static const char* const states[] = { "huge", "none", "-" };
    for (uint32_t i = 0; i < run_count; i += 1)
    {
        const bool first = i == 0 || strcmp(runs[i].name, runs[i - 1].name) != 0;
        for (uint32_t s = 0; first && s < 3; s += 1)
        {
            uint32_t count = 0;
            const double faults = reduce_median(runs[i].name, states[s], offsetof(ReduceRun, page_faults), &count);
            const double user = reduce_median(runs[i].name, states[s], offsetof(ReduceRun, user_cycles), &count);
            const double kernel = reduce_median(runs[i].name, states[s], offsetof(ReduceRun, kernel_cycles), &count);
            const double both = reduce_median(runs[i].name, states[s], offsetof(ReduceRun, both_cycles), &count);
            const double instructions = reduce_median(runs[i].name, states[s], offsetof(ReduceRun, user_instructions), &count);
            const double clock = reduce_median(runs[i].name, states[s], offsetof(ReduceRun, task_clock), &count);
            if (count != 0)
            {
                printf("%s\t%s\t%u\t%.0f\t%.1f\t%.1f\t%.1f\t%.1f\t%.2f\n", runs[i].name, states[s], count, faults, user / 1e6, kernel / 1e6, both / 1e6,
                       instructions / 1e6, clock);
            }
        }
    }
    return status;
}
