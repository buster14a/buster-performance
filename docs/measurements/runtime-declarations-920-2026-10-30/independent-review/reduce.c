// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Independent, read-only reduction of #920's completed raw process/stage grid.
// This does not invoke any archived compiler or measurement program.
#define _POSIX_C_SOURCE 200809L
#include <dirent.h>
#include <errno.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Sample Sample;
struct Sample
{
    double wall;
    double cycles;
    double instructions;
    bool present;
};

static Sample grid[2][3][3][6][3][3];
static bool included[2][3] = { { true, true, true }, { true, true, true } };
static bool partial_scope;
static const char* states[] = { "plain", "after-scalar" };
static const char* labels[] = { "base", "candidate", "base-again" };
static const char* metrics[] = { "preprocess", "check-input", "check-program", "backend-setup", "lower", "total", "peak-rss-kb" };

static int compare_number(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double upper_median(double* values, size_t count)
{
    qsort(values, count, sizeof(*values), compare_number);
    return values[count / 2];
}

static bool zero_status(const char* path)
{
    FILE* file = fopen(path, "r");
    char text[8] = { 0 };
    bool valid = file != NULL && fgets(text, sizeof(text), file) != NULL && strcmp(text, "0\n") == 0;
    if (file != NULL)
    {
        valid = fgetc(file) == EOF && !ferror(file) && fclose(file) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "missing/nonzero status: %s\n", path);
    }
    return valid;
}

static bool read_timing(const char* packet)
{
    bool valid = true;
    unsigned total = 0;
    unsigned selected_files = 0;
    for (unsigned state = 0; valid && state < 2; state += 1)
    {
        for (unsigned round = 0; valid && round < 3; round += 1)
        {
            if (!included[state][round])
            {
                continue;
            }
            selected_files += 1;
            char path[4096];
            snprintf(path, sizeof(path), "%s/logs/time-%s-%u.status", packet, states[state], round + 1);
            valid = zero_status(path);
            snprintf(path, sizeof(path), "%s/logs/time-%s-%u.log", packet, states[state], round + 1);
            FILE* file = valid ? fopen(path, "r") : NULL;
            valid = valid && file != NULL;
            char* line = NULL;
            size_t capacity = 0;
            unsigned rows = 0;
            unsigned done = 0;
            while (valid && getline(&line, &capacity, file) >= 0)
            {
                if (strstr(line, "FAILED") != NULL || strstr(line, "weren't counted") != NULL)
                {
                    valid = false;
                }
                if (strncmp(line, "time-runs: done,", 16) == 0)
                {
                    done += 1;
                    valid = valid && strcmp(line, "time-runs: done, 0 failed processes\n") == 0;
                }
                if (strncmp(line, "run ", 4) == 0)
                {
                    unsigned run = 0, list = 0, placement = 0, copy = 0;
                    char label[32] = { 0 };
                    double wall = 0, user = 0, system = 0;
                    unsigned long long peak = 0, minor = 0, major = 0, cycles = 0, instructions = 0;
                    int status = -1, consumed = 0;
                    errno = 0;
                    const int fields = sscanf(line, "run %u list %u %31[a-z-] placement %u copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KiB wait4 peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d%n",
                                              &run, &list, label, &placement, &copy, &wall, &user, &system, &peak, &minor, &major, &cycles, &instructions, &status, &consumed);
                    unsigned build = 3;
                    for (unsigned b = 0; b < 3; b += 1)
                    {
                        if (strcmp(label, labels[b]) == 0)
                        {
                            build = b;
                        }
                    }
                    valid = valid && fields == 14 && errno == 0 && strcmp(line + consumed, "\n") == 0 && strstr(line, ", -") == NULL &&
                            build < 3 && run >= 1 && run <= 3 && list == 1 && placement >= 1 && placement <= 6 && copy >= 1 && copy <= 3 && status == 0 &&
                            isfinite(wall) && wall > 0 && isfinite(user) && user >= 0 && isfinite(system) && system >= 0 && peak > 0 &&
                            cycles > 0 && cycles < UINT64_C(9007199254740992) && instructions > 0 && instructions < UINT64_C(9007199254740992);
                    if (valid)
                    {
                        Sample* sample = &grid[state][round][build][placement - 1][copy - 1][run - 1];
                        valid = !sample->present;
                        *sample = (Sample){ .wall = wall, .cycles = (double)cycles, .instructions = (double)instructions, .present = true };
                        rows += 1;
                    }
                }
            }
            if (file != NULL)
            {
                valid = !ferror(file) && fclose(file) == 0 && valid;
            }
            free(line);
            valid = valid && rows == 162 && done == 1;
            if (!valid)
            {
                fprintf(stderr, "timing grid rejected: %s rows=%u done=%u\n", path, rows, done);
            }
            total += rows;
        }
    }
    valid = valid && total == (partial_scope ? selected_files * 162 : 972) && selected_files != 0;
    return valid;
}

static size_t collect(unsigned state, int selected_round, unsigned build, int selected_placement, int selected_copy, unsigned metric, double* values)
{
    size_t count = 0;
    for (unsigned round = 0; round < 3; round += 1)
    {
        for (unsigned placement = 0; placement < 6; placement += 1)
        {
            for (unsigned copy = 0; copy < 3; copy += 1)
            {
                for (unsigned run = 0; run < 3; run += 1)
                {
                    if ((selected_round < 0 || selected_round == (int)round) && (selected_placement < 0 || selected_placement == (int)placement) && (selected_copy < 0 || selected_copy == (int)copy))
                    {
                        const Sample* sample = &grid[state][round][build][placement][copy][run];
                        values[count++] = metric == 0 ? sample->wall : metric == 1 ? sample->cycles : sample->instructions;
                    }
                }
            }
        }
    }
    return count;
}

static bool write_timings(const char* prefix)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s-whole.csv", prefix);
    FILE* whole = fopen(path, "w");
    snprintf(path, sizeof(path), "%s-placement.csv", prefix);
    FILE* placement_output = fopen(path, "w");
    snprintf(path, sizeof(path), "%s-sensitivity.csv", prefix);
    FILE* sensitivity = fopen(path, "w");
    bool valid = whole != NULL && placement_output != NULL && sensitivity != NULL;
    if (valid)
    {
        fputs("state,round,label,samples,upper_median_wall_ms,upper_median_user_cycles,upper_median_instructions\n", whole);
        fputs("state,round,label,placement,samples,upper_median_wall_ms\n", placement_output);
        fputs("state,round,candidate_vs_base_pct,repeated_base_vs_base_pct,candidate_vs_repeated_base_pct,candidate_crossplacement_min_pct,candidate_crossplacement_max_pct,candidate_crossplacement_copy_min_pct,candidate_crossplacement_copy_max_pct,repeated_base_crossplacement_min_pct,repeated_base_crossplacement_max_pct\n", sensitivity);
    }
    for (unsigned state = 0; valid && state < 2; state += 1)
    {
        for (int round = 0; round < 4; round += 1)
        {
            if ((round < 3 && !included[state][round]) || (round == 3 && !(included[state][0] && included[state][1] && included[state][2])))
            {
                continue;
            }
            const int selected_round = round == 3 ? -1 : round;
            char round_name[8];
            if (round == 3)
            {
                strcpy(round_name, "all");
            }
            else
            {
                snprintf(round_name, sizeof(round_name), "%d", round + 1);
            }
            double medians[3];
            double placement_min[3], placement_max[3], copy_min[3], copy_max[3];
            for (unsigned build = 0; build < 3; build += 1)
            {
                double values[162];
                double measured[3];
                size_t count = 0;
                for (unsigned metric = 0; metric < 3; metric += 1)
                {
                    count = collect(state, selected_round, build, -1, -1, metric, values);
                    measured[metric] = upper_median(values, count);
                }
                medians[build] = measured[0];
                fprintf(whole, "%s,%s,%s,%zu,%.3f,%.0f,%.0f\n", states[state], round_name, labels[build], count, measured[0], measured[1], measured[2]);
                for (unsigned placement = 0; placement < 6; placement += 1)
                {
                    const size_t points = collect(state, selected_round, build, (int)placement, -1, 0, values);
                    const double median = upper_median(values, points);
                    fprintf(placement_output, "%s,%s,%s,%u,%zu,%.3f\n", states[state], round_name, labels[build], placement + 1, points, median);
                    placement_min[build] = placement == 0 || median < placement_min[build] ? median : placement_min[build];
                    placement_max[build] = placement == 0 || median > placement_max[build] ? median : placement_max[build];
                    for (unsigned copy = 0; copy < 3; copy += 1)
                    {
                        const size_t copy_points = collect(state, selected_round, build, (int)placement, (int)copy, 0, values);
                        const double median_copy = upper_median(values, copy_points);
                        const bool first = placement == 0 && copy == 0;
                        copy_min[build] = first || median_copy < copy_min[build] ? median_copy : copy_min[build];
                        copy_max[build] = first || median_copy > copy_max[build] ? median_copy : copy_max[build];
                    }
                }
            }
            fprintf(sensitivity, "%s,%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n", states[state], round_name,
                    100 * (medians[1] / medians[0] - 1), 100 * (medians[2] / medians[0] - 1), 100 * (medians[1] / medians[2] - 1),
                    100 * (placement_min[1] / placement_max[0] - 1), 100 * (placement_max[1] / placement_min[0] - 1),
                    100 * (copy_min[1] / copy_max[0] - 1), 100 * (copy_max[1] / copy_min[0] - 1),
                    100 * (placement_min[2] / placement_max[0] - 1), 100 * (placement_max[2] / placement_min[0] - 1));
        }
    }
    if (whole != NULL) valid = fclose(whole) == 0 && valid;
    if (placement_output != NULL) valid = fclose(placement_output) == 0 && valid;
    if (sensitivity != NULL) valid = fclose(sensitivity) == 0 && valid;
    return valid;
}

static bool read_stages(const char* packet, const char* prefix)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/logs/stages.status", packet);
    bool valid = zero_status(path);
    snprintf(path, sizeof(path), "%s/stages", packet);
    DIR* directory = valid ? opendir(path) : NULL;
    valid = valid && directory != NULL;
    unsigned entries = 0;
    struct dirent* entry;
    while (directory != NULL && (entry = readdir(directory)) != NULL)
    {
        const size_t length = strlen(entry->d_name);
        entries += length >= 7 && strcmp(entry->d_name + length - 7, ".stderr") == 0;
    }
    if (directory != NULL) closedir(directory);
    valid = valid && entries == 33;
    double stages[3][7][11] = { 0 };
    for (unsigned run = 0; valid && run < 11; run += 1)
    {
        for (unsigned slot = 0; valid && slot < 3; slot += 1)
        {
            const unsigned build = (run + slot) % 3;
            snprintf(path, sizeof(path), "%s/stages/run-%u-%u-%s.stderr", packet, run, slot, labels[build]);
            FILE* file = fopen(path, "r");
            valid = file != NULL;
            char* line = NULL;
            size_t capacity = 0;
            unsigned seen[7] = { 0 };
            while (valid && getline(&line, &capacity, file) >= 0)
            {
                for (unsigned metric = 0; valid && metric < 7; metric += 1)
                {
                    char prefix_text[128];
                    snprintf(prefix_text, sizeof(prefix_text), "%s\t%s\t", metric == 6 ? "time-process" : "time-stage", metrics[metric]);
                    const size_t prefix_length = strlen(prefix_text);
                    if (strncmp(line, prefix_text, prefix_length) == 0)
                    {
                        char* end = NULL;
                        errno = 0;
                        const double value = strtod(line + prefix_length, &end);
                        valid = ++seen[metric] == 1 && errno == 0 && end != line + prefix_length && (*end == '\t' || *end == '\n') &&
                                isfinite(value) && value > 0 && value < 9007199254740992.0;
                        stages[build][metric][run] = value;
                    }
                }
            }
            if (file != NULL) valid = !ferror(file) && fclose(file) == 0 && valid;
            free(line);
            for (unsigned metric = 0; metric < 7; metric += 1) valid = valid && seen[metric] == 1;
            if (!valid) fprintf(stderr, "invalid stage record: %s\n", path);
        }
    }
    snprintf(path, sizeof(path), "%s-stages.csv", prefix);
    FILE* output = valid ? fopen(path, "w") : NULL;
    valid = valid && output != NULL;
    if (valid) fputs("label,metric,samples,upper_median,min,max\n", output);
    for (unsigned build = 0; valid && build < 3; build += 1)
    {
        for (unsigned metric = 0; metric < 7; metric += 1)
        {
            const double median = upper_median(stages[build][metric], 11);
            fprintf(output, "%s,%s,11,%.3f,%.3f,%.3f\n", labels[build], metrics[metric], median, stages[build][metric][0], stages[build][metric][10]);
        }
    }
    if (output != NULL) valid = fclose(output) == 0 && valid;
    return valid;
}

int main(int argc, char** argv)
{
    char path[4096];
    const bool stage_only = argc == 4 && strcmp(argv[3], "stages") == 0;
    partial_scope = argc == 5 && strcmp(argv[3], "partial") == 0 && strlen(argv[4]) == 6;
    bool valid = argc == 3 || stage_only || partial_scope;
    if (partial_scope)
    {
        for (unsigned i = 0; i < 6; i += 1)
        {
            valid = valid && (argv[4][i] == '0' || argv[4][i] == '1');
            included[i / 3][i % 3] = argv[4][i] == '1';
        }
    }
    if (valid)
    {
        snprintf(path, sizeof(path), "%s/logs/semantic.status", argv[1]);
        valid = zero_status(path) && (stage_only ? read_stages(argv[1], argv[2]) : read_timing(argv[1]) && write_timings(argv[2]) && (partial_scope || read_stages(argv[1], argv[2])));
    }
    fprintf(stderr, "independent reduction complete=%s; mode=%s; no image execution\n", valid ? "true" : "false", stage_only ? "33-stage-processes-only" : partial_scope ? "PROVISIONAL-explicit-round-subset-NOT-full-grid-acceptance" : "972-measured-and33-stage-processes");
    return valid ? 0 : 1;
}
