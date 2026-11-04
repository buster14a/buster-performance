// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// #673's physical traffic, from traffic.c's samples: for each case, the medians over its rounds of its wall time (perf's
// duration_time), both memory controllers' CAS commands, read and write apart, those less the same round's idle rate
// over that time, and its commands' own counters, the cases by name. Bytes are 64 a CAS command, which
// buster-performance#49 leaves conditional, so the counts come first. A sample whose files are missing or partly counted
// fails the reader.
#define _GNU_SOURCE
#include <dirent.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRAFFIC_CASES 16
#define TRAFFIC_ROUNDS 32

typedef struct TrafficSample TrafficSample;
struct TrafficSample
{
    bool present;
    double duration_ns;
    double read;
    double write;
    double task_ms;
    double switches;
    double migrations;
    double cycles;
    double instructions;
    double faults;
};

typedef struct TrafficCase TrafficCase;
struct TrafficCase
{
    char name[64];
    TrafficSample samples[TRAFFIC_ROUNDS];
};

static int traffic_compare(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return (a > b) - (a < b);
}

static int traffic_compare_names(const void* left, const void* right)
{
    return strcmp(((const TrafficCase*)left)->name, ((const TrafficCase*)right)->name);
}

static double traffic_median(double* values, unsigned count)
{
    qsort(values, count, sizeof(double), traffic_compare);
    return count == 0 ? 0.0 : count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2.0;
}

// The counters of perf stat -x, output `path`: each event's count into the sample's field, every one fully counted.
static bool traffic_read(const char* path, TrafficSample* sample, bool system)
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    unsigned found = 0;
    char line[512];
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        if (line[0] == '#' || line[0] == '\n')
        {
            continue;
        }
        char* fields[8] = { 0 };
        unsigned count = 0;
        for (char* cursor = line; count < 8 && cursor != NULL; count += 1)
        {
            fields[count] = cursor;
            char* comma = strchr(cursor, ',');
            if (comma != NULL)
            {
                *comma = 0;
            }
            cursor = comma != NULL ? comma + 1 : NULL;
        }
        char* end = NULL;
        const double value = count >= 5 ? strtod(fields[0], &end) : 0.0;
        const bool counted = count >= 5 && end != fields[0] && strtod(fields[4], NULL) == 100.0;
        const char* event = count >= 3 ? fields[2] : "";
        double* target = NULL;
        if (system)
        {
            target = strcmp(event, "duration_time") == 0 ? &sample->duration_ns : target;
            if (strcmp(event, "amd_umc_0/umc_cas_cmd.rd/") == 0 || strcmp(event, "amd_umc_1/umc_cas_cmd.rd/") == 0)
            {
                sample->read += counted ? value : 0.0;
                found += counted ? 1 : 0;
                valid = counted;
            }
            if (strcmp(event, "amd_umc_0/umc_cas_cmd.wr/") == 0 || strcmp(event, "amd_umc_1/umc_cas_cmd.wr/") == 0)
            {
                sample->write += counted ? value : 0.0;
                found += counted ? 1 : 0;
                valid = counted;
            }
        }
        else
        {
            target = strcmp(event, "task-clock") == 0 ? &sample->task_ms : target;
            target = strcmp(event, "context-switches") == 0 ? &sample->switches : target;
            target = strcmp(event, "cpu-migrations") == 0 ? &sample->migrations : target;
            target = strcmp(event, "cycles") == 0 ? &sample->cycles : target;
            target = strcmp(event, "instructions") == 0 ? &sample->instructions : target;
            target = strcmp(event, "page-faults") == 0 ? &sample->faults : target;
        }
        if (target != NULL)
        {
            *target = value;
            found += counted ? 1 : 0;
            valid = counted;
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return valid && found == (system ? 5u : 6u);
}

int main(int argc, char** argv)
{
    // OUTDIR, traffic.c's.
    bool valid = argc == 2;
    static TrafficCase cases[TRAFFIC_CASES];
    unsigned case_count = 0;
    unsigned samples = 0;
    DIR* directory = valid ? opendir(argv[1]) : NULL;
    valid = valid && directory != NULL;
    for (struct dirent* entry = valid ? readdir(directory) : NULL; valid && entry != NULL; entry = readdir(directory))
    {
        unsigned round = 0;
        int consumed = 0;
        if (entry->d_name[0] != 'r' || sscanf(entry->d_name, "r%2u-%n", &round, &consumed) != 1 || consumed == 0 || round >= TRAFFIC_ROUNDS)
        {
            continue;
        }
        const char* name = entry->d_name + consumed;
        unsigned c = 0;
        while (c < case_count && strcmp(cases[c].name, name) != 0)
        {
            c += 1;
        }
        valid = c < TRAFFIC_CASES && strlen(name) < sizeof(cases[c].name);
        if (valid && c == case_count)
        {
            snprintf(cases[c].name, sizeof(cases[c].name), "%s", name);
            case_count += 1;
        }
        char path[PATH_MAX];
        TrafficSample* sample = valid ? &cases[c].samples[round] : NULL;
        snprintf(path, sizeof(path), "%s/%s/umc.csv", argv[1], entry->d_name);
        valid = valid && traffic_read(path, sample, true);
        if (valid && strcmp(name, "idle") != 0)
        {
            snprintf(path, sizeof(path), "%s/%s/perf.csv", argv[1], entry->d_name);
            valid = traffic_read(path, sample, false);
        }
        if (!valid)
        {
            fprintf(stderr, "traffic_stats: sample %s/%s is incomplete\n", argv[1], entry->d_name);
        }
        if (sample != NULL)
        {
            sample->present = valid;
        }
        samples += valid ? 1 : 0;
    }
    if (directory != NULL)
    {
        closedir(directory);
    }
    // By name, rather than in the directory's order, which is its file system's.
    qsort(cases, case_count, sizeof(TrafficCase), traffic_compare_names);
    unsigned idle = 0;
    while (idle < case_count && strcmp(cases[idle].name, "idle") != 0)
    {
        idle += 1;
    }
    valid = valid && idle < case_count;
    printf("case\trounds\twall_ms\tread_cas_m\twrite_cas_m\tread_excess_cas_m\twrite_excess_cas_m\tread_excess_mb\twrite_excess_mb\tidle_read_gbps\tidle_write_gbps\ttask_ms\tswitches\tmigrations\tcycles_g\tinstructions_g\tfaults\n");
    for (unsigned c = 0; valid && c < case_count; c += 1)
    {
        double wall[TRAFFIC_ROUNDS], read[TRAFFIC_ROUNDS], write[TRAFFIC_ROUNDS], read_excess[TRAFFIC_ROUNDS], write_excess[TRAFFIC_ROUNDS];
        double idle_read[TRAFFIC_ROUNDS], idle_write[TRAFFIC_ROUNDS], task[TRAFFIC_ROUNDS], switches[TRAFFIC_ROUNDS], migrations[TRAFFIC_ROUNDS];
        double cycles[TRAFFIC_ROUNDS], instructions[TRAFFIC_ROUNDS], faults[TRAFFIC_ROUNDS];
        unsigned count = 0;
        for (unsigned round = 0; round < TRAFFIC_ROUNDS; round += 1)
        {
            const TrafficSample* sample = cases[c].samples + round;
            const TrafficSample* background = cases[idle].samples + round;
            if (!sample->present)
            {
                continue;
            }
            // Each sample against its own round's idle rate: a round without one fails the reader.
            valid = valid && background->present && background->duration_ns > 0.0;
            const double read_rate = valid ? background->read / background->duration_ns : 0.0;
            const double write_rate = valid ? background->write / background->duration_ns : 0.0;
            wall[count] = sample->duration_ns / 1e6;
            read[count] = sample->read / 1e6;
            write[count] = sample->write / 1e6;
            read_excess[count] = (sample->read - read_rate * sample->duration_ns) / 1e6;
            write_excess[count] = (sample->write - write_rate * sample->duration_ns) / 1e6;
            idle_read[count] = read_rate * 64.0;
            idle_write[count] = write_rate * 64.0;
            task[count] = sample->task_ms;
            switches[count] = sample->switches;
            migrations[count] = sample->migrations;
            cycles[count] = sample->cycles / 1e9;
            instructions[count] = sample->instructions / 1e9;
            faults[count] = sample->faults;
            count += 1;
        }
        const double read_excess_median = traffic_median(read_excess, count);
        const double write_excess_median = traffic_median(write_excess, count);
        printf("%s\t%u\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.1f\t%.1f\t%.3f\t%.3f\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.0f\n", cases[c].name, count, traffic_median(wall, count),
               traffic_median(read, count), traffic_median(write, count), read_excess_median, write_excess_median, read_excess_median * 64.0,
               write_excess_median * 64.0, traffic_median(idle_read, count), traffic_median(idle_write, count), traffic_median(task, count),
               traffic_median(switches, count), traffic_median(migrations, count), traffic_median(cycles, count), traffic_median(instructions, count),
               traffic_median(faults, count));
    }
    if (!valid)
    {
        fprintf(stderr, "traffic_stats: failed; expected OUTDIR with an idle case in every round (%u samples read)\n", samples);
    }
    return !valid;
}
