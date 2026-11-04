// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// uarch: the runner and reducer of the two-host micro-architecture campaign
// (docs/measurements/microarch-two-hosts-2026-11-04). It drives perf(1) and the
// compiler as child processes and turns their outputs into tab-separated tables.
// Every run writes its raw output first; the reducers only read those files, so a
// table can always be rebuilt from the record.
//
// Commands (OUT is a directory; every run command resumes: a run whose files exist
// is skipped):
//   time OUT ROUNDS --list LABEL ARG... [--list LABEL ARG...]...
//       Whole processes in a rotating order: wall time and wait4's rusage per run.
//   stat OUT LABEL RUNS PERF-ARG... -- ARG...
//       `perf stat -x,` RUNS times with the given events or metrics.
//   sweep OUT EVENTS FROM TO RUNS ANCHORS -- ARG...
//       One perf stat per event and run: {ANCHORS,EVENT:u,EVENT:k} as one group,
//       with a fallback to {instructions:u,EVENT:u} and {instructions:u,EVENT:k}
//       when the group cannot be scheduled whole.
//   metrics OUT METRICS FROM TO RUNS -- ARG...
//       One perf stat -M per metric and run.
//   summarize OUT
//       stat.tsv, sweep.tsv, metrics.tsv and time.tsv's medians from the raw files.
//   stages FILE...
//       Medians of the compiler's --time-stages reports (time-stage, time-check
//       and time-process lines).
//   symbols SCRIPT
//       Per-symbol sums of each event's periods in `perf script -F event,period,sym`
//       output (leader-sampled groups and IBS samples alike).
//   branches SCRIPT [TOP]
//       Mispredicted and predicted LBR entries by source symbol and by branch site
//       from `perf script -F brstacksym` output.
//   memory SCRIPT
//       Samples by symbol and data source from `perf script -F ip,sym,data_src,weight`
//       output of IBS op samples, with the median and mean load latency per symbol.
//   topdown TD1.tsv TD2.tsv WIDTH [MIN_PERCENT]
//       Per-symbol top-down level 1 and 2 shares from two `symbols` tables of
//       leader-sampled groups (run.sh's profiles td1 and td2).
//   fanout OUT LABEL ROUNDS CPU,CPU,... -- ARG...
//       One copy of the command per listed CPU at once, each pinned to its CPU;
//       the batch's wall time and the copies' summed rusage per round.
//
// Build: cc -O2 -Wall -Wextra -o uarch uarch.c (C17, Linux, glibc).

#define _GNU_SOURCE
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>
#include <dirent.h>
#include <sched.h>

typedef struct
{
    char **items;
    size_t count;
    size_t capacity;
} Strings;

typedef struct
{
    double *items;
    size_t count;
    size_t capacity;
} Values;

typedef struct
{
    char *key;
    Values values;
    Values duty;
    char *text;
} Entry;

typedef struct
{
    Entry *items;
    size_t count;
    size_t capacity;
} Table;

typedef struct
{
    int status;
    double wall_ms;
    struct rusage usage;
} RunResult;

static void *checked_realloc(void *pointer, size_t size)
{
    void *result = realloc(pointer, size);
    if (result == NULL)
    {
        fprintf(stderr, "uarch: out of memory\n");
        exit(2);
    }
    return result;
}

static char *copy_string(const char *text)
{
    size_t length = strlen(text);
    char *result = checked_realloc(NULL, length + 1);
    memcpy(result, text, length + 1);
    return result;
}

static void strings_add(Strings *strings, const char *text)
{
    if (strings->count == strings->capacity)
    {
        strings->capacity = strings->capacity ? strings->capacity * 2 : 16;
        strings->items = checked_realloc(strings->items, strings->capacity * sizeof(char *));
    }
    strings->items[strings->count++] = text ? copy_string(text) : NULL;
}

static void values_add(Values *values, double value)
{
    if (values->count == values->capacity)
    {
        values->capacity = values->capacity ? values->capacity * 2 : 8;
        values->items = checked_realloc(values->items, values->capacity * sizeof(double));
    }
    values->items[values->count++] = value;
}

static int compare_doubles(const void *a, const void *b)
{
    double x = *(const double *)a;
    double y = *(const double *)b;
    return (x > y) - (x < y);
}

static double values_median(const Values *values)
{
    double result = NAN;
    if (values->count > 0)
    {
        double *sorted = checked_realloc(NULL, values->count * sizeof(double));
        memcpy(sorted, values->items, values->count * sizeof(double));
        qsort(sorted, values->count, sizeof(double), compare_doubles);
        size_t middle = values->count / 2;
        result = values->count % 2 ? sorted[middle] : (sorted[middle - 1] + sorted[middle]) / 2;
        free(sorted);
    }
    return result;
}

static double values_min(const Values *values)
{
    double result = NAN;
    for (size_t i = 0; i < values->count; i += 1)
    {
        if (isnan(result) || values->items[i] < result) result = values->items[i];
    }
    return result;
}

static double values_max(const Values *values)
{
    double result = NAN;
    for (size_t i = 0; i < values->count; i += 1)
    {
        if (isnan(result) || values->items[i] > result) result = values->items[i];
    }
    return result;
}

static Entry *table_get(Table *table, const char *key)
{
    Entry *result = NULL;
    for (size_t i = 0; i < table->count && result == NULL; i += 1)
    {
        if (strcmp(table->items[i].key, key) == 0) result = &table->items[i];
    }
    if (result == NULL)
    {
        if (table->count == table->capacity)
        {
            table->capacity = table->capacity ? table->capacity * 2 : 64;
            table->items = checked_realloc(table->items, table->capacity * sizeof(Entry));
        }
        result = &table->items[table->count++];
        memset(result, 0, sizeof(*result));
        result->key = copy_string(key);
    }
    return result;
}

static double now_ms(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return time.tv_sec * 1e3 + time.tv_nsec * 1e-6;
}

static void make_directory(const char *path)
{
    char buffer[4096];
    snprintf(buffer, sizeof(buffer), "%s", path);
    for (char *p = buffer + 1; *p; p += 1)
    {
        if (*p == '/')
        {
            *p = 0;
            mkdir(buffer, 0755);
            *p = '/';
        }
    }
    if (mkdir(buffer, 0755) != 0 && errno != EEXIST)
    {
        perror(buffer);
        exit(2);
    }
}

static bool file_exists(const char *path)
{
    struct stat information;
    return stat(path, &information) == 0;
}

// Runs ARGV with stdout and stderr appended to LOG (or kept when LOG is NULL), in
// the C locale so that perf's CSV fields use '.' decimals.
static RunResult run_process(char **argv, const char *log)
{
    RunResult result = {0};
    double start = now_ms();
    pid_t child = fork();
    if (child == 0)
    {
        setenv("LC_ALL", "C", 1);
        if (log != NULL)
        {
            int fd = open(log, O_WRONLY | O_CREAT | O_APPEND, 0644);
            if (fd >= 0)
            {
                dup2(fd, 1);
                dup2(fd, 2);
                close(fd);
            }
        }
        execvp(argv[0], argv);
        fprintf(stderr, "uarch: exec %s: %s\n", argv[0], strerror(errno));
        _exit(127);
    }
    int status = 0;
    if (child < 0 || wait4(child, &status, 0, &result.usage) < 0)
    {
        result.status = -1;
    }
    else
    {
        result.status = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
    }
    result.wall_ms = now_ms() - start;
    return result;
}

static double timeval_ms(struct timeval value)
{
    return value.tv_sec * 1e3 + value.tv_usec * 1e-3;
}

static void append_line(const char *path, const char *line)
{
    FILE *file = fopen(path, "a");
    if (file != NULL)
    {
        fputs(line, file);
        fclose(file);
    }
}

// ---------------------------------------------------------------------------
// time

typedef struct
{
    const char *label;
    char **argv;
} Command;

static int command_time(int argc, char **argv)
{
    int result = 0;
    if (argc < 4)
    {
        fprintf(stderr, "usage: uarch time OUT ROUNDS --list LABEL ARG... [--list LABEL ARG...]...\n");
        result = 1;
    }
    else
    {
        const char *out = argv[2];
        int rounds = atoi(argv[3]);
        Command commands[64];
        int command_count = 0;
        for (int i = 4; i < argc; i += 1)
        {
            if (strcmp(argv[i], "--list") == 0 && i + 1 < argc && command_count < 64)
            {
                commands[command_count].label = argv[i + 1];
                commands[command_count].argv = &argv[i + 2];
                command_count += 1;
                argv[i] = NULL;
                i += 1;
            }
        }
        char path[4096];
        make_directory(out);
        snprintf(path, sizeof(path), "%s/logs", out);
        make_directory(path);
        char table_path[4096];
        snprintf(table_path, sizeof(table_path), "%s/time.tsv", out);
        if (!file_exists(table_path))
        {
            append_line(table_path, "label\tround\tstatus\twall_ms\tuser_ms\tsystem_ms\tmaxrss_kb\tminflt\tmajflt\tnvcsw\tnivcsw\n");
        }
        for (int round = 0; round < rounds; round += 1)
        {
            for (int k = 0; k < command_count; k += 1)
            {
                Command *command = &commands[(round + k) % command_count];
                char log[4096];
                snprintf(log, sizeof(log), "%s/logs/%s.r%d.log", out, command->label, round);
                if (file_exists(log)) continue;
                RunResult run = run_process(command->argv, log);
                char line[1024];
                snprintf(line, sizeof(line), "%s\t%d\t%d\t%.3f\t%.3f\t%.3f\t%ld\t%ld\t%ld\t%ld\t%ld\n", command->label, round,
                         run.status, run.wall_ms, timeval_ms(run.usage.ru_utime), timeval_ms(run.usage.ru_stime),
                         run.usage.ru_maxrss, run.usage.ru_minflt, run.usage.ru_majflt, run.usage.ru_nvcsw, run.usage.ru_nivcsw);
                append_line(table_path, line);
                if (run.status != 0) result = 1;
            }
        }
    }
    return result;
}

// ---------------------------------------------------------------------------
// stat, sweep, metrics

static int split_command(int argc, char **argv, int from)
{
    int result = -1;
    for (int i = from; i < argc && result < 0; i += 1)
    {
        if (strcmp(argv[i], "--") == 0) result = i;
    }
    return result;
}

// Runs `perf stat -x, --no-big-num -o CSV PERF_ARGS... -- COMMAND...`.
static RunResult perf_stat(const char *csv, const char *log, char **perf_args, int perf_count, char **command, int command_count)
{
    char **argv = checked_realloc(NULL, (size_t)(perf_count + command_count + 8) * sizeof(char *));
    int n = 0;
    argv[n++] = "perf";
    argv[n++] = "stat";
    argv[n++] = "-x,";
    argv[n++] = "--no-big-num";
    argv[n++] = "-o";
    argv[n++] = (char *)csv;
    for (int i = 0; i < perf_count; i += 1) argv[n++] = perf_args[i];
    argv[n++] = "--";
    for (int i = 0; i < command_count; i += 1) argv[n++] = command[i];
    argv[n] = NULL;
    RunResult result = run_process(argv, log);
    free(argv);
    return result;
}

static void write_status(const char *path, RunResult run)
{
    char line[512];
    snprintf(line, sizeof(line), "status\t%d\twall_ms\t%.3f\tuser_ms\t%.3f\tsystem_ms\t%.3f\tmaxrss_kb\t%ld\n", run.status, run.wall_ms,
             timeval_ms(run.usage.ru_utime), timeval_ms(run.usage.ru_stime), run.usage.ru_maxrss);
    FILE *file = fopen(path, "w");
    if (file != NULL)
    {
        fputs(line, file);
        fclose(file);
    }
}

static int command_stat(int argc, char **argv)
{
    int result = 0;
    int separator = split_command(argc, argv, 5);
    if (argc < 7 || separator < 0)
    {
        fprintf(stderr, "usage: uarch stat OUT LABEL RUNS PERF-ARG... -- ARG...\n");
        result = 1;
    }
    else
    {
        const char *out = argv[2];
        const char *label = argv[3];
        int runs = atoi(argv[4]);
        char directory[4096];
        snprintf(directory, sizeof(directory), "%s/stat", out);
        make_directory(directory);
        for (int run = 0; run < runs; run += 1)
        {
            char csv[4096], log[4096], status[4096];
            snprintf(csv, sizeof(csv), "%s/%s.r%d.csv", directory, label, run);
            snprintf(log, sizeof(log), "%s/%s.r%d.log", directory, label, run);
            snprintf(status, sizeof(status), "%s/%s.r%d.status", directory, label, run);
            if (file_exists(status)) continue;
            unlink(log);
            RunResult outcome = perf_stat(csv, log, &argv[5], separator - 5, &argv[separator + 1], argc - separator - 1);
            write_status(status, outcome);
            if (outcome.status != 0) result = 1;
        }
    }
    return result;
}

static Strings read_lines(const char *path)
{
    Strings result = {0};
    FILE *file = fopen(path, "r");
    if (file != NULL)
    {
        char line[4096];
        while (fgets(line, sizeof(line), file) != NULL)
        {
            size_t length = strlen(line);
            while (length > 0 && (line[length - 1] == '\n' || line[length - 1] == '\r' || line[length - 1] == ' ')) line[--length] = 0;
            if (length > 0 && line[0] != '#') strings_add(&result, line);
        }
        fclose(file);
    }
    return result;
}

// The fields of one perf stat CSV line: value, unit, event, run time, percent
// running, metric value, metric unit. An event spelled with terms
// ("cpu/EVENT,cmask=0x8/u") has commas of its own: perf prints them as they are,
// so a line of more than seven fields has its extra fields joined back into the
// event's.
typedef struct
{
    char *fields[8];
    int count;
} CsvLine;

static CsvLine csv_split(char *line)
{
    CsvLine result = {0};
    char *fields[32];
    int count = 0;
    char *cursor = line;
    while (count < 32)
    {
        fields[count++] = cursor;
        char *comma = strchr(cursor, ',');
        if (comma == NULL) break;
        *comma = 0;
        cursor = comma + 1;
    }
    int extra = count > 7 && fields[2][0] != 0 && strchr(fields[2], '/') != NULL ? count - 7 : 0;
    for (int i = 0; i < count && result.count < 8; i += 1)
    {
        result.fields[result.count++] = fields[i];
        if (i == 2)
        {
            // Rejoin the event's own commas (the strings are contiguous in `line`).
            for (int k = 0; k < extra; k += 1) fields[2][strlen(fields[2])] = ',';
            i += extra;
        }
    }
    return result;
}

// True when every counter line of the CSV counted with at least 99% duty.
static bool csv_complete(const char *path)
{
    Strings lines = read_lines(path);
    bool result = lines.count > 0;
    for (size_t i = 0; i < lines.count; i += 1)
    {
        CsvLine line = csv_split(lines.items[i]);
        if (line.count < 5) continue;
        if (line.fields[0][0] == '<' || atof(line.fields[4]) < 99.0) result = false;
    }
    return result;
}

static int command_sweep(int argc, char **argv)
{
    int result = 0;
    int separator = split_command(argc, argv, 8);
    if (argc < 10 || separator != 8)
    {
        fprintf(stderr, "usage: uarch sweep OUT EVENTS FROM TO RUNS ANCHORS -- ARG...\n");
        result = 1;
    }
    else
    {
        const char *out = argv[2];
        Strings events = read_lines(argv[3]);
        size_t from = (size_t)atol(argv[4]);
        size_t to = (size_t)atol(argv[5]);
        int runs = atoi(argv[6]);
        const char *anchors = argv[7];
        char directory[4096];
        snprintf(directory, sizeof(directory), "%s/sweep", out);
        make_directory(directory);
        if (to > events.count) to = events.count;
        for (size_t i = from; i < to; i += 1)
        {
            const char *event = events.items[i];
            char name_path[4096];
            snprintf(name_path, sizeof(name_path), "%s/%04zu.event", directory, i);
            FILE *name = fopen(name_path, "w");
            if (name != NULL)
            {
                fprintf(name, "%s\n", event);
                fclose(name);
            }
            for (int run = 0; run < runs; run += 1)
            {
                char csv[4096], log[4096], status[4096], spec[2048];
                snprintf(csv, sizeof(csv), "%s/%04zu.r%d.csv", directory, i, run);
                snprintf(log, sizeof(log), "%s/%04zu.r%d.log", directory, i, run);
                snprintf(status, sizeof(status), "%s/%04zu.r%d.status", directory, i, run);
                if (file_exists(status)) continue;
                unlink(log);
                snprintf(spec, sizeof(spec), "{%s,%s:u,%s:k}", anchors, event, event);
                char *perf_args[2] = {"-e", spec};
                RunResult outcome = perf_stat(csv, log, perf_args, 2, &argv[separator + 1], argc - separator - 1);
                if (outcome.status == 0 && !csv_complete(csv))
                {
                    // The whole group could not be scheduled: one event and one anchor at a time.
                    for (int mode = 0; mode < 2; mode += 1)
                    {
                        char fallback_csv[4096];
                        snprintf(fallback_csv, sizeof(fallback_csv), "%s/%04zu.r%d.f%d.csv", directory, i, run, mode);
                        snprintf(spec, sizeof(spec), "{instructions:u,%s:%s}", event, mode == 0 ? "u" : "k");
                        RunResult fallback = perf_stat(fallback_csv, log, perf_args, 2, &argv[separator + 1], argc - separator - 1);
                        if (fallback.status != 0) outcome.status = fallback.status;
                    }
                }
                write_status(status, outcome);
                if (outcome.status != 0) result = 1;
            }
        }
    }
    return result;
}

static int command_metrics(int argc, char **argv)
{
    int result = 0;
    int separator = split_command(argc, argv, 7);
    if (argc < 9 || separator != 7)
    {
        fprintf(stderr, "usage: uarch metrics OUT METRICS FROM TO RUNS -- ARG...\n");
        result = 1;
    }
    else
    {
        const char *out = argv[2];
        Strings metrics = read_lines(argv[3]);
        size_t from = (size_t)atol(argv[4]);
        size_t to = (size_t)atol(argv[5]);
        int runs = atoi(argv[6]);
        char directory[4096];
        snprintf(directory, sizeof(directory), "%s/metrics", out);
        make_directory(directory);
        if (to > metrics.count) to = metrics.count;
        for (size_t i = from; i < to; i += 1)
        {
            char name_path[4096];
            snprintf(name_path, sizeof(name_path), "%s/%04zu.metric", directory, i);
            FILE *name = fopen(name_path, "w");
            if (name != NULL)
            {
                fprintf(name, "%s\n", metrics.items[i]);
                fclose(name);
            }
            for (int run = 0; run < runs; run += 1)
            {
                char csv[4096], log[4096], status[4096];
                snprintf(csv, sizeof(csv), "%s/%04zu.r%d.csv", directory, i, run);
                snprintf(log, sizeof(log), "%s/%04zu.r%d.log", directory, i, run);
                snprintf(status, sizeof(status), "%s/%04zu.r%d.status", directory, i, run);
                if (file_exists(status)) continue;
                unlink(log);
                char *perf_args[2] = {"-M", metrics.items[i]};
                RunResult outcome = perf_stat(csv, log, perf_args, 2, &argv[separator + 1], argc - separator - 1);
                write_status(status, outcome);
                if (outcome.status != 0) result = 1;
            }
        }
    }
    return result;
}

// ---------------------------------------------------------------------------
// summarize

static int name_compare(const void *a, const void *b)
{
    return strcmp(*(char *const *)a, *(char *const *)b);
}

static Strings list_directory(const char *path, const char *suffix)
{
    Strings result = {0};
    DIR *directory = opendir(path);
    if (directory != NULL)
    {
        struct dirent *entry;
        size_t suffix_length = strlen(suffix);
        while ((entry = readdir(directory)) != NULL)
        {
            size_t length = strlen(entry->d_name);
            if (length >= suffix_length && strcmp(entry->d_name + length - suffix_length, suffix) == 0) strings_add(&result, entry->d_name);
        }
        closedir(directory);
        qsort(result.items, result.count, sizeof(char *), name_compare);
    }
    return result;
}

static double parse_value(const char *text)
{
    return text[0] == '<' || text[0] == 0 ? NAN : strtod(text, NULL);
}

// stat/LABEL.rN.csv -> rows of label, event, median value, min, max, minimum duty,
// runs, and the median metric value with its unit (where perf printed one).
static void summarize_stat(const char *out)
{
    char directory[4096];
    snprintf(directory, sizeof(directory), "%s/stat", out);
    Strings files = list_directory(directory, ".csv");
    Table table = {0};
    Table metric_table = {0};
    for (size_t f = 0; f < files.count; f += 1)
    {
        char label[1024];
        snprintf(label, sizeof(label), "%s", files.items[f]);
        char *dot = strstr(label, ".r");
        char *last = NULL;
        while (dot != NULL)
        {
            last = dot;
            dot = strstr(dot + 1, ".r");
        }
        if (last != NULL) *last = 0;
        char path[4096];
        snprintf(path, sizeof(path), "%s/%s", directory, files.items[f]);
        Strings lines = read_lines(path);
        for (size_t i = 0; i < lines.count; i += 1)
        {
            CsvLine line = csv_split(lines.items[i]);
            if (line.count < 5) continue;
            char key[2048];
            snprintf(key, sizeof(key), "%s\t%s", label, line.fields[2]);
            Entry *entry = table_get(&table, key);
            values_add(&entry->values, parse_value(line.fields[0]));
            values_add(&entry->duty, atof(line.fields[4]));
            if (line.count >= 7 && line.fields[6][0] != 0)
            {
                char metric_key[2048];
                snprintf(metric_key, sizeof(metric_key), "%s\t%s", label, line.fields[6]);
                Entry *metric = table_get(&metric_table, metric_key);
                values_add(&metric->values, parse_value(line.fields[5]));
            }
        }
    }
    char path[4096];
    snprintf(path, sizeof(path), "%s/stat.tsv", out);
    FILE *file = fopen(path, "w");
    if (file != NULL)
    {
        fprintf(file, "label\tevent\tmedian\tmin\tmax\tduty_min\truns\n");
        for (size_t i = 0; i < table.count; i += 1)
        {
            Entry *entry = &table.items[i];
            fprintf(file, "%s\t%.6g\t%.6g\t%.6g\t%.2f\t%zu\n", entry->key, values_median(&entry->values), values_min(&entry->values),
                    values_max(&entry->values), values_min(&entry->duty), entry->values.count);
        }
        for (size_t i = 0; i < metric_table.count; i += 1)
        {
            Entry *entry = &metric_table.items[i];
            fprintf(file, "%s\t%.6g\t%.6g\t%.6g\t\t%zu\n", entry->key, values_median(&entry->values), values_min(&entry->values),
                    values_max(&entry->values), entry->values.count);
        }
        fclose(file);
    }
}

typedef struct
{
    double user;
    double kernel;
    double cycles;
    double instructions;
    double duty;
    bool valid;
} SweepSample;

static SweepSample sweep_read(const char *path, const char *event)
{
    SweepSample result = {NAN, NAN, NAN, NAN, 100.0, false};
    Strings lines = read_lines(path);
    size_t user_length = strlen(event);
    for (size_t i = 0; i < lines.count; i += 1)
    {
        CsvLine line = csv_split(lines.items[i]);
        if (line.count < 5) continue;
        const char *name = line.fields[2];
        double value = parse_value(line.fields[0]);
        double duty = atof(line.fields[4]);
        if (duty < result.duty) result.duty = duty;
        if (strcmp(name, "cycles:u") == 0) result.cycles = value;
        else if (strcmp(name, "instructions:u") == 0) result.instructions = value;
        else if (strncmp(name, event, user_length) == 0 && strcmp(name + user_length, ":u") == 0) result.user = value;
        else if (strncmp(name, event, user_length) == 0 && strcmp(name + user_length, ":k") == 0) result.kernel = value;
    }
    result.valid = lines.count > 0;
    return result;
}

// sweep/NNNN.rR.csv -> event, user and kernel medians, per thousand user
// instructions and per user cycle, minimum duty, the runs and how they were taken.
static void summarize_sweep(const char *out)
{
    char directory[4096];
    snprintf(directory, sizeof(directory), "%s/sweep", out);
    Strings names = list_directory(directory, ".event");
    char path[4096];
    snprintf(path, sizeof(path), "%s/sweep.tsv", out);
    FILE *file = fopen(path, "w");
    if (file == NULL) return;
    fprintf(file, "event\tuser_median\tkernel_median\tuser_per_kinst\tuser_per_cycle\tkernel_share\tuser_min\tuser_max\tduty_min\truns\tmode\n");
    for (size_t n = 0; n < names.count; n += 1)
    {
        char name_path[4096];
        snprintf(name_path, sizeof(name_path), "%s/%s", directory, names.items[n]);
        Strings event_lines = read_lines(name_path);
        if (event_lines.count == 0) continue;
        const char *event = event_lines.items[0];
        char index[16];
        snprintf(index, sizeof(index), "%.4s", names.items[n]);
        Values user = {0}, kernel = {0}, per_kinst = {0}, per_cycle = {0};
        double duty_min = 100.0;
        int fallbacks = 0;
        for (int run = 0; run < 64; run += 1)
        {
            char csv[4096];
            snprintf(csv, sizeof(csv), "%s/%s.r%d.csv", directory, index, run);
            if (!file_exists(csv)) break;
            SweepSample sample = sweep_read(csv, event);
            char fallback_user[4096];
            snprintf(fallback_user, sizeof(fallback_user), "%s/%s.r%d.f0.csv", directory, index, run);
            if (file_exists(fallback_user))
            {
                char fallback_kernel[4096];
                snprintf(fallback_kernel, sizeof(fallback_kernel), "%s/%s.r%d.f1.csv", directory, index, run);
                SweepSample first = sweep_read(fallback_user, event);
                SweepSample second = sweep_read(fallback_kernel, event);
                sample.user = first.user;
                sample.kernel = second.kernel;
                sample.instructions = first.instructions;
                sample.cycles = NAN;
                sample.duty = first.duty < second.duty ? first.duty : second.duty;
                fallbacks += 1;
            }
            if (!sample.valid) continue;
            values_add(&user, sample.user);
            values_add(&kernel, sample.kernel);
            values_add(&per_kinst, sample.user / sample.instructions * 1000.0);
            values_add(&per_cycle, sample.user / sample.cycles);
            if (sample.duty < duty_min) duty_min = sample.duty;
        }
        double user_median = values_median(&user);
        double kernel_median = values_median(&kernel);
        fprintf(file, "%s\t%.6g\t%.6g\t%.6g\t%.6g\t%.4f\t%.6g\t%.6g\t%.2f\t%zu\t%s\n", event, user_median, kernel_median,
                values_median(&per_kinst), values_median(&per_cycle), kernel_median / (user_median + kernel_median), values_min(&user),
                values_max(&user), duty_min, user.count, fallbacks ? "fallback" : "group");
    }
    fclose(file);
}

// metrics/NNNN.rR.csv -> metric, the median of each reported metric line's
// value with its unit, minimum duty, runs and exit status.
static void summarize_metrics(const char *out)
{
    char directory[4096];
    snprintf(directory, sizeof(directory), "%s/metrics", out);
    Strings names = list_directory(directory, ".metric");
    char path[4096];
    snprintf(path, sizeof(path), "%s/metrics.tsv", out);
    FILE *file = fopen(path, "w");
    if (file == NULL) return;
    fprintf(file, "metric\treported\tmedian\tmin\tmax\tduty_min\truns\tfailed_runs\n");
    for (size_t n = 0; n < names.count; n += 1)
    {
        char name_path[4096];
        snprintf(name_path, sizeof(name_path), "%s/%s", directory, names.items[n]);
        Strings metric_lines = read_lines(name_path);
        if (metric_lines.count == 0) continue;
        const char *metric = metric_lines.items[0];
        char index[16];
        snprintf(index, sizeof(index), "%.4s", names.items[n]);
        Table reported = {0};
        double duty_min = 100.0;
        int failed = 0;
        int runs = 0;
        for (int run = 0; run < 64; run += 1)
        {
            char csv[4096], status_path[4096];
            snprintf(csv, sizeof(csv), "%s/%s.r%d.csv", directory, index, run);
            snprintf(status_path, sizeof(status_path), "%s/%s.r%d.status", directory, index, run);
            if (!file_exists(status_path)) break;
            runs += 1;
            Strings status = read_lines(status_path);
            if (status.count == 0 || strncmp(status.items[0], "status\t0\t", 9) != 0) failed += 1;
            Strings lines = read_lines(csv);
            for (size_t i = 0; i < lines.count; i += 1)
            {
                CsvLine line = csv_split(lines.items[i]);
                if (line.count < 7) continue;
                double duty = atof(line.fields[4]);
                if (line.fields[0][0] != '<' && duty < duty_min) duty_min = duty;
                if (line.fields[6][0] == 0) continue;
                Entry *entry = table_get(&reported, line.fields[6]);
                values_add(&entry->values, parse_value(line.fields[5]));
            }
        }
        if (reported.count == 0)
        {
            fprintf(file, "%s\t\tnan\tnan\tnan\t%.2f\t%d\t%d\n", metric, duty_min, runs, failed);
        }
        for (size_t i = 0; i < reported.count; i += 1)
        {
            Entry *entry = &reported.items[i];
            fprintf(file, "%s\t%s\t%.6g\t%.6g\t%.6g\t%.2f\t%d\t%d\n", metric, entry->key, values_median(&entry->values),
                    values_min(&entry->values), values_max(&entry->values), duty_min, runs, failed);
        }
    }
    fclose(file);
}

// time.tsv -> time-summary.tsv: per label, the median of each column and the
// runs that failed.
static void summarize_time(const char *out)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s/time.tsv", out);
    Strings lines = read_lines(path);
    if (lines.count < 2) return;
    const char *columns[] = {"wall_ms", "user_ms", "system_ms", "maxrss_kb", "minflt", "majflt", "nvcsw", "nivcsw"};
    Table table = {0};
    Strings labels = {0};
    for (size_t i = 1; i < lines.count; i += 1)
    {
        char *fields[16];
        int count = 0;
        char *cursor = lines.items[i];
        while (count < 16)
        {
            fields[count++] = cursor;
            char *tab = strchr(cursor, '\t');
            if (tab == NULL) break;
            *tab = 0;
            cursor = tab + 1;
        }
        if (count < 11) continue;
        bool known = false;
        for (size_t l = 0; l < labels.count; l += 1) known |= strcmp(labels.items[l], fields[0]) == 0;
        if (!known) strings_add(&labels, fields[0]);
        char key[1024];
        snprintf(key, sizeof(key), "%s\tstatus", fields[0]);
        Entry *status = table_get(&table, key);
        values_add(&status->values, atof(fields[2]));
        if (atoi(fields[2]) != 0) continue;
        for (int c = 0; c < 8; c += 1)
        {
            snprintf(key, sizeof(key), "%s\t%s", fields[0], columns[c]);
            values_add(&table_get(&table, key)->values, atof(fields[3 + c]));
        }
    }
    snprintf(path, sizeof(path), "%s/time-summary.tsv", out);
    FILE *file = fopen(path, "w");
    if (file == NULL) return;
    fprintf(file, "label\truns\tfailed\twall_ms_median\twall_ms_min\twall_ms_max\tuser_ms\tsystem_ms\tmaxrss_kb\tminflt\tmajflt\tnvcsw\tnivcsw\n");
    for (size_t l = 0; l < labels.count; l += 1)
    {
        char key[1024];
        snprintf(key, sizeof(key), "%s\tstatus", labels.items[l]);
        Entry *status = table_get(&table, key);
        int failed = 0;
        for (size_t i = 0; i < status->values.count; i += 1) failed += status->values.items[i] != 0;
        fprintf(file, "%s\t%zu\t%d", labels.items[l], status->values.count, failed);
        for (int c = 0; c < 8; c += 1)
        {
            snprintf(key, sizeof(key), "%s\t%s", labels.items[l], columns[c]);
            Entry *entry = table_get(&table, key);
            if (c == 0)
            {
                fprintf(file, "\t%.3f\t%.3f\t%.3f", values_median(&entry->values), values_min(&entry->values), values_max(&entry->values));
            }
            else
            {
                fprintf(file, "\t%.3f", values_median(&entry->values));
            }
        }
        fprintf(file, "\n");
    }
    fclose(file);
}

static int command_summarize(int argc, char **argv)
{
    int result = 0;
    if (argc != 3)
    {
        fprintf(stderr, "usage: uarch summarize OUT\n");
        result = 1;
    }
    else
    {
        summarize_stat(argv[2]);
        summarize_sweep(argv[2]);
        summarize_metrics(argv[2]);
        summarize_time(argv[2]);
    }
    return result;
}

// ---------------------------------------------------------------------------
// stages

static int command_stages(int argc, char **argv)
{
    Table table = {0};
    Strings order = {0};
    for (int a = 2; a < argc; a += 1)
    {
        Strings lines = read_lines(argv[a]);
        for (size_t i = 0; i < lines.count; i += 1)
        {
            char *line = lines.items[i];
            if (strncmp(line, "time-", 5) != 0) continue;
            char *fields[8];
            int count = 0;
            char *cursor = line;
            while (count < 8)
            {
                fields[count++] = cursor;
                char *tab = strchr(cursor, '\t');
                if (tab == NULL) break;
                *tab = 0;
                cursor = tab + 1;
            }
            if (count < 3 || strcmp(fields[1], "stage") == 0) continue;
            char *end = NULL;
            strtod(fields[2], &end);
            if (end == fields[2]) continue;
            // time-stage: ms, percent, system-ms, minor-faults, peak-kb-added.
            const char *columns[] = {"ms", "percent", "system_ms", "minor_faults", "peak_kb_added"};
            for (int c = 2; c < count && c < 7; c += 1)
            {
                char key[1024];
                snprintf(key, sizeof(key), "%s\t%s\t%s", fields[0], fields[1], strcmp(fields[0], "time-stage") == 0 ? columns[c - 2] : (c == 2 ? "value" : columns[c - 2]));
                Entry *entry = table_get(&table, key);
                if (entry->values.count == 0)
                {
                    strings_add(&order, key);
                }
                values_add(&entry->values, strtod(fields[c], NULL));
            }
        }
    }
    printf("kind\tname\tcolumn\tmedian\tmin\tmax\truns\n");
    for (size_t i = 0; i < order.count; i += 1)
    {
        Entry *entry = table_get(&table, order.items[i]);
        printf("%s\t%.6g\t%.6g\t%.6g\t%zu\n", entry->key, values_median(&entry->values), values_min(&entry->values),
               values_max(&entry->values), entry->values.count);
    }
    return 0;
}

// ---------------------------------------------------------------------------
// symbols, branches, memory

static char *trim(char *text)
{
    while (isspace((unsigned char)*text)) text += 1;
    size_t length = strlen(text);
    while (length > 0 && isspace((unsigned char)text[length - 1])) text[--length] = 0;
    return text;
}

static FILE *open_input(const char *path)
{
    FILE *file = strcmp(path, "-") == 0 ? stdin : fopen(path, "r");
    if (file == NULL)
    {
        perror(path);
        exit(2);
    }
    return file;
}

// `perf script -F period,event,ip,sym` prints each sample as
// "PERIOD EVENT: IP SYMBOL" (the period, the event with its modifiers and a
// colon, the address, the symbol or [unknown]). Sums each event's periods per
// symbol. For a leader-sampled group ({...}:S) every member prints its own line
// with the delta since the previous sample as its period, at the leader's address.
static int command_symbols(int argc, char **argv)
{
    int result = 0;
    if (argc != 3)
    {
        fprintf(stderr, "usage: uarch symbols SCRIPT\n");
        result = 1;
    }
    else
    {
        FILE *file = open_input(argv[2]);
        Table cells = {0};
        Strings events = {0};
        Table symbol_totals = {0};
        char *line = NULL;
        size_t capacity = 0;
        while (getline(&line, &capacity, file) > 0)
        {
            char *text = trim(line);
            char *end = NULL;
            double period = strtod(text, &end);
            if (end == text) continue;
            char *event = trim(end);
            char *colon = strstr(event, ": ");
            if (colon == NULL) continue;
            *colon = 0;
            char *rest = trim(colon + 2);
            // Skip the address; the symbol is the rest of the line.
            while (*rest && !isspace((unsigned char)*rest)) rest += 1;
            char *symbol = trim(rest);
            if (*symbol == 0) symbol = "[unknown]";
            bool known = false;
            for (size_t e = 0; e < events.count; e += 1) known |= strcmp(events.items[e], event) == 0;
            if (!known) strings_add(&events, event);
            char key[4096];
            snprintf(key, sizeof(key), "%s\t%s", symbol, event);
            Entry *cell = table_get(&cells, key);
            if (cell->values.count == 0) values_add(&cell->values, 0);
            cell->values.items[0] += period;
            Entry *total = table_get(&symbol_totals, symbol);
            if (total->values.count == 0) values_add(&total->values, 0);
            if (strcmp(event, events.items[0]) == 0) total->values.items[0] += period;
        }
        printf("symbol");
        for (size_t e = 0; e < events.count; e += 1) printf("\t%s", events.items[e]);
        printf("\n");
        // Symbols by the first event's total, largest first.
        size_t *order = checked_realloc(NULL, (symbol_totals.count + 1) * sizeof(size_t));
        for (size_t i = 0; i < symbol_totals.count; i += 1) order[i] = i;
        for (size_t i = 1; i < symbol_totals.count; i += 1)
        {
            size_t current = order[i];
            size_t j = i;
            while (j > 0 && symbol_totals.items[order[j - 1]].values.items[0] < symbol_totals.items[current].values.items[0])
            {
                order[j] = order[j - 1];
                j -= 1;
            }
            order[j] = current;
        }
        for (size_t i = 0; i < symbol_totals.count; i += 1)
        {
            const char *symbol = symbol_totals.items[order[i]].key;
            printf("%s", symbol);
            for (size_t e = 0; e < events.count; e += 1)
            {
                char key[4096];
                snprintf(key, sizeof(key), "%s\t%s", symbol, events.items[e]);
                Entry *cell = table_get(&cells, key);
                printf("\t%.0f", cell->values.count ? cell->values.items[0] : 0.0);
            }
            printf("\n");
        }
        free(line);
    }
    return result;
}

// One LBR entry of `perf script -F brstacksym`: FROM/TO/FLAG/... where FROM and
// TO are symbol+offset. FLAG is M (mispredicted), P (predicted) or -.
static int command_branches(int argc, char **argv)
{
    int result = 0;
    if (argc < 3)
    {
        fprintf(stderr, "usage: uarch branches SCRIPT [TOP]\n");
        result = 1;
    }
    else
    {
        size_t top = argc > 3 ? (size_t)atol(argv[3]) : 60;
        FILE *file = open_input(argv[2]);
        Table by_symbol = {0};
        Table by_site = {0};
        double entries = 0, mispredicted = 0;
        char *line = NULL;
        size_t capacity = 0;
        while (getline(&line, &capacity, file) > 0)
        {
            char *cursor = line;
            while (*cursor)
            {
                while (isspace((unsigned char)*cursor)) cursor += 1;
                if (*cursor == 0) break;
                char *token = cursor;
                while (*cursor && !isspace((unsigned char)*cursor)) cursor += 1;
                if (*cursor) *cursor++ = 0;
                char *slash1 = strchr(token, '/');
                if (slash1 == NULL) continue;
                char *slash2 = strchr(slash1 + 1, '/');
                if (slash2 == NULL) continue;
                char flag = slash2[1];
                if (flag != 'M' && flag != 'P' && flag != '-') continue;
                *slash1 = 0;
                char site[2048];
                snprintf(site, sizeof(site), "%s", token);
                char *plus = strrchr(token, '+');
                if (plus != NULL) *plus = 0;
                entries += 1;
                Entry *symbol = table_get(&by_symbol, token);
                Entry *place = table_get(&by_site, site);
                if (symbol->values.count == 0)
                {
                    values_add(&symbol->values, 0);
                    values_add(&symbol->values, 0);
                }
                if (place->values.count == 0)
                {
                    values_add(&place->values, 0);
                    values_add(&place->values, 0);
                }
                symbol->values.items[0] += 1;
                place->values.items[0] += 1;
                if (flag == 'M')
                {
                    mispredicted += 1;
                    symbol->values.items[1] += 1;
                    place->values.items[1] += 1;
                }
            }
        }
        printf("# entries\t%.0f\tmispredicted\t%.0f\n", entries, mispredicted);
        for (int pass = 0; pass < 2; pass += 1)
        {
            Table *table = pass == 0 ? &by_symbol : &by_site;
            printf("%s\tentries\tmispredicted\tmispredict_rate\tshare_of_mispredicts\n", pass == 0 ? "symbol" : "site");
            size_t *order = checked_realloc(NULL, (table->count + 1) * sizeof(size_t));
            for (size_t i = 0; i < table->count; i += 1) order[i] = i;
            for (size_t i = 1; i < table->count; i += 1)
            {
                size_t current = order[i];
                size_t j = i;
                while (j > 0 && table->items[order[j - 1]].values.items[1] < table->items[current].values.items[1])
                {
                    order[j] = order[j - 1];
                    j -= 1;
                }
                order[j] = current;
            }
            for (size_t i = 0; i < table->count && i < top; i += 1)
            {
                Entry *entry = &table->items[order[i]];
                printf("%s\t%.0f\t%.0f\t%.4f\t%.4f\n", entry->key, entry->values.items[0], entry->values.items[1],
                       entry->values.items[1] / entry->values.items[0], entry->values.items[1] / (mispredicted > 0 ? mispredicted : 1));
            }
            free(order);
        }
        free(line);
    }
    return result;
}

// IBS op samples (`perf record -e ibs_op/cnt_ctl=1,swfilt=1/u -d -W`) printed by
// `perf script -F ip,sym,data_src,weight`: each line holds the raw data source,
// its decoded fields ("|OP LOAD|LVL L1 hit|SNP ..|TLB L1 hit|LCK ..|BLK ..."),
// then the weight (the load's miss latency in cycles, 0 for a hit), the address
// and the symbol. The last three tokens are read from the end of the line.
static int command_memory(int argc, char **argv)
{
    int result = 0;
    if (argc != 3)
    {
        fprintf(stderr, "usage: uarch memory SCRIPT\n");
        result = 1;
    }
    else
    {
        FILE *file = open_input(argv[2]);
        Table by_symbol_level = {0};
        Table latencies = {0};
        Table symbol_samples = {0};
        char *line = NULL;
        size_t capacity = 0;
        while (getline(&line, &capacity, file) > 0)
        {
            char *text = trim(line);
            if (*text == 0) continue;
            // The level: the text after "|LVL " up to the next '|'.
            char level[256] = "none";
            char *lvl = strstr(text, "|LVL ");
            if (lvl != NULL)
            {
                char *end = strchr(lvl + 5, '|');
                size_t length = end ? (size_t)(end - lvl - 5) : strlen(lvl + 5);
                if (length >= sizeof(level)) length = sizeof(level) - 1;
                memcpy(level, lvl + 5, length);
                level[length] = 0;
            }
            char tlb[256] = "none";
            char *tlb_field = strstr(text, "|TLB ");
            if (tlb_field != NULL)
            {
                char *end = strchr(tlb_field + 5, '|');
                size_t length = end ? (size_t)(end - tlb_field - 5) : strlen(tlb_field + 5);
                if (length >= sizeof(tlb)) length = sizeof(tlb) - 1;
                memcpy(tlb, tlb_field + 5, length);
                tlb[length] = 0;
            }
            bool load = strstr(text, "|OP LOAD|") != NULL;
            bool store = strstr(text, "|OP STORE|") != NULL;
            // The last three tokens: weight, address, symbol.
            char *tokens[3] = {NULL, NULL, NULL};
            char *cursor = text + strlen(text);
            for (int t = 2; t >= 0 && cursor > text; t -= 1)
            {
                while (cursor > text && isspace((unsigned char)cursor[-1])) *--cursor = 0;
                while (cursor > text && !isspace((unsigned char)cursor[-1])) cursor -= 1;
                tokens[t] = cursor;
            }
            if (tokens[0] == NULL) continue;
            const char *symbol = *tokens[2] ? tokens[2] : "[unknown]";
            double weight = strtod(tokens[0], NULL);
            Entry *samples = table_get(&symbol_samples, symbol);
            if (samples->values.count == 0)
            {
                values_add(&samples->values, 0);
                values_add(&samples->values, 0);
                values_add(&samples->values, 0);
            }
            samples->values.items[0] += 1;
            samples->values.items[1] += load;
            samples->values.items[2] += store;
            if (!load && !store) continue;
            char key[4096];
            snprintf(key, sizeof(key), "%s\t%s\tLVL %s\tTLB %s", symbol, load ? "load" : "store", level, tlb);
            Entry *entry = table_get(&by_symbol_level, key);
            if (entry->values.count == 0) values_add(&entry->values, 0);
            entry->values.items[0] += 1;
            if (load && weight > 0) values_add(&table_get(&latencies, symbol)->values, weight);
        }
        printf("symbol\tsamples\tload_samples\tstore_samples\tloads_with_latency\tlatency_median\tlatency_mean\tlatency_p90\n");
        for (size_t i = 0; i < symbol_samples.count; i += 1)
        {
            Entry *samples = &symbol_samples.items[i];
            Entry *latency = table_get(&latencies, samples->key);
            double mean = 0;
            for (size_t k = 0; k < latency->values.count; k += 1) mean += latency->values.items[k];
            mean = latency->values.count ? mean / latency->values.count : NAN;
            double p90 = NAN;
            if (latency->values.count)
            {
                qsort(latency->values.items, latency->values.count, sizeof(double), compare_doubles);
                p90 = latency->values.items[(size_t)(latency->values.count * 0.9)];
            }
            printf("%s\t%.0f\t%.0f\t%.0f\t%zu\t%.1f\t%.1f\t%.1f\n", samples->key, samples->values.items[0], samples->values.items[1],
                   samples->values.items[2], latency->values.count, values_median(&latency->values), mean, p90);
        }
        printf("symbol_level\tsymbol\top\tlevel\ttlb\tsamples\n");
        for (size_t i = 0; i < by_symbol_level.count; i += 1)
        {
            printf("symbol_level\t%s\t%.0f\n", by_symbol_level.items[i].key, by_symbol_level.items[i].values.items[0]);
        }
        free(line);
    }
    return result;
}

// ---------------------------------------------------------------------------
// fanout: K independent copies of one command at once, one pinned to each CPU
// of the list, ROUNDS times; "{i}" in an argument becomes the copy's index.

static int command_fanout(int argc, char **argv)
{
    int result = 0;
    int separator = split_command(argc, argv, 6);
    if (argc < 8 || separator != 6)
    {
        fprintf(stderr, "usage: uarch fanout OUT LABEL ROUNDS CPU,CPU,... -- ARG...\n");
        result = 1;
    }
    else
    {
        const char *out = argv[2];
        const char *label = argv[3];
        int rounds = atoi(argv[4]);
        int cpus[256];
        int cpu_count = 0;
        char cpu_list[1024];
        snprintf(cpu_list, sizeof(cpu_list), "%s", argv[5]);
        for (char *token = strtok(cpu_list, ","); token != NULL && cpu_count < 256; token = strtok(NULL, ",")) cpus[cpu_count++] = atoi(token);
        int command_count = argc - separator - 1;
        char **command = &argv[separator + 1];
        char path[4096];
        snprintf(path, sizeof(path), "%s/logs", out);
        make_directory(path);
        char table_path[4096];
        snprintf(table_path, sizeof(table_path), "%s/fanout.tsv", out);
        if (!file_exists(table_path))
        {
            append_line(table_path, "label\tround\tworkers\tfailed\twall_ms\tuser_ms_sum\tsystem_ms_sum\tmaxrss_kb_max\tminflt_sum\n");
        }
        for (int round = 0; round < rounds; round += 1)
        {
            char log[4096];
            snprintf(log, sizeof(log), "%s/logs/%s.r%d.log", out, label, round);
            if (file_exists(log)) continue;
            int fd = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0644);
            pid_t children[256];
            double start = now_ms();
            for (int k = 0; k < cpu_count; k += 1)
            {
                children[k] = fork();
                if (children[k] == 0)
                {
                    cpu_set_t set;
                    CPU_ZERO(&set);
                    CPU_SET(cpus[k], &set);
                    sched_setaffinity(0, sizeof(set), &set);
                    setenv("LC_ALL", "C", 1);
                    if (fd >= 0)
                    {
                        dup2(fd, 1);
                        dup2(fd, 2);
                    }
                    char **child_argv = checked_realloc(NULL, (size_t)(command_count + 1) * sizeof(char *));
                    for (int a = 0; a < command_count; a += 1)
                    {
                        char *marker = strstr(command[a], "{i}");
                        if (marker == NULL)
                        {
                            child_argv[a] = command[a];
                        }
                        else
                        {
                            char *replaced = checked_realloc(NULL, strlen(command[a]) + 16);
                            snprintf(replaced, strlen(command[a]) + 16, "%.*s%d%s", (int)(marker - command[a]), command[a], k, marker + 3);
                            child_argv[a] = replaced;
                        }
                    }
                    child_argv[command_count] = NULL;
                    execvp(child_argv[0], child_argv);
                    _exit(127);
                }
            }
            int failed = 0;
            double user = 0, system = 0, minflt = 0;
            long maxrss = 0;
            for (int k = 0; k < cpu_count; k += 1)
            {
                int status = 0;
                struct rusage usage;
                if (wait4(children[k], &status, 0, &usage) < 0 || !WIFEXITED(status) || WEXITSTATUS(status) != 0) failed += 1;
                user += timeval_ms(usage.ru_utime);
                system += timeval_ms(usage.ru_stime);
                minflt += usage.ru_minflt;
                if (usage.ru_maxrss > maxrss) maxrss = usage.ru_maxrss;
            }
            double wall = now_ms() - start;
            if (fd >= 0) close(fd);
            char line[1024];
            snprintf(line, sizeof(line), "%s\t%d\t%d\t%d\t%.3f\t%.3f\t%.3f\t%ld\t%.0f\n", label, round, cpu_count, failed, wall, user, system, maxrss, minflt);
            append_line(table_path, line);
            if (failed) result = 1;
        }
    }
    return result;
}

// ---------------------------------------------------------------------------
// topdown: per-symbol top-down level 1 and 2 from the `symbols` tables of the two
// leader-sampled groups:
//   TD1 = {ls_not_halted_cyc, de_src_op_disp.all, ex_ret_ops,
//          de_no_dispatch_per_slot.no_ops_from_frontend, de_no_dispatch_per_slot.backend_stalls}
//   TD2 = {ls_not_halted_cyc, ex_no_retire.load_not_complete, ex_no_retire.not_complete,
//          instructions, ex_ret_brn_misp}
// with WIDTH dispatch slots per cycle (6 on Zen 4, 8 on Zen 5), as perf's
// PipelineL1/L2 metrics define them. Each row's shares come from the same
// samples; rows are the symbols with at least MIN percent of the cycles.

typedef struct
{
    Strings columns;
    Table rows;
} SymbolTable;

static SymbolTable read_symbol_table(const char *path)
{
    SymbolTable result = {0};
    Strings lines = read_lines(path);
    for (size_t i = 0; i < lines.count; i += 1)
    {
        char *fields[16];
        int count = 0;
        char *cursor = lines.items[i];
        while (count < 16)
        {
            fields[count++] = cursor;
            char *tab = strchr(cursor, '\t');
            if (tab == NULL) break;
            *tab = 0;
            cursor = tab + 1;
        }
        if (i == 0)
        {
            for (int c = 1; c < count; c += 1) strings_add(&result.columns, fields[c]);
            continue;
        }
        Entry *entry = table_get(&result.rows, fields[0]);
        for (int c = 1; c < count; c += 1) values_add(&entry->values, strtod(fields[c], NULL));
    }
    return result;
}

static int column_index(const SymbolTable *table, const char *prefix)
{
    int result = -1;
    for (size_t c = 0; c < table->columns.count && result < 0; c += 1)
    {
        if (strncmp(table->columns.items[c], prefix, strlen(prefix)) == 0) result = (int)c;
    }
    return result;
}

static double cell(Entry *entry, int column)
{
    return entry != NULL && column >= 0 && (size_t)column < entry->values.count ? entry->values.items[column] : NAN;
}

static int command_topdown(int argc, char **argv)
{
    int result = 0;
    if (argc < 5)
    {
        fprintf(stderr, "usage: uarch topdown TD1.tsv TD2.tsv WIDTH [MIN_PERCENT]\n");
        result = 1;
    }
    else
    {
        SymbolTable td1 = read_symbol_table(argv[2]);
        SymbolTable td2 = read_symbol_table(argv[3]);
        double width = atof(argv[4]);
        double minimum = argc > 5 ? atof(argv[5]) : 0.5;
        int cycles = column_index(&td1, "ls_not_halted_cyc");
        int dispatched = column_index(&td1, "de_src_op_disp.all");
        int retired = column_index(&td1, "ex_ret_ops");
        int frontend = column_index(&td1, "de_no_dispatch_per_slot.no_ops_from_frontend");
        int backend = column_index(&td1, "de_no_dispatch_per_slot.backend_stalls");
        int cycles2 = column_index(&td2, "ls_not_halted_cyc");
        int load = column_index(&td2, "ex_no_retire.load_not_complete");
        int not_complete = column_index(&td2, "ex_no_retire.not_complete");
        int instructions = column_index(&td2, "instructions");
        int mispredicts = column_index(&td2, "ex_ret_brn_misp");
        double total = 0;
        for (size_t i = 0; i < td1.rows.count; i += 1) total += cell(&td1.rows.items[i], cycles);
        printf("symbol\tcycles_share\tipc\tretiring\tfrontend\tbackend\tbad_speculation\tbackend_memory\tbackend_cpu\tmispredicts_pki\n");
        for (int pass = 0; pass < 2; pass += 1)
        {
            for (size_t i = 0; i < td1.rows.count; i += 1)
            {
                Entry *row = &td1.rows.items[i];
                double c = cell(row, cycles);
                bool all = strcmp(row->key, "[all]") == 0;
                if (pass == 0 && (all || c / total * 100.0 < minimum)) continue;
                if (pass == 1 && !all) continue;
                double slots = c * width;
                Entry *other = NULL;
                for (size_t k = 0; k < td2.rows.count && other == NULL; k += 1)
                {
                    if (strcmp(td2.rows.items[k].key, row->key) == 0) other = &td2.rows.items[k];
                }
                double backend_share = cell(row, backend) / slots;
                double memory_fraction = cell(other, load) / cell(other, not_complete);
                printf("%s\t%.4f\t%.3f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.3f\n", row->key, c / total, cell(other, instructions) / cell(other, cycles2),
                       cell(row, retired) / slots, cell(row, frontend) / slots, backend_share,
                       (cell(row, dispatched) - cell(row, retired)) / slots, backend_share * memory_fraction,
                       backend_share * (1 - memory_fraction), cell(other, mispredicts) / cell(other, instructions) * 1000.0);
            }
            if (pass == 0)
            {
                // A total row over every symbol, from the sums.
                Entry *sum1 = table_get(&td1.rows, "[all]");
                Entry *sum2 = table_get(&td2.rows, "[all]");
                if (sum1->values.count == 0)
                {
                    for (size_t c = 0; c < td1.columns.count; c += 1) values_add(&sum1->values, 0);
                    for (size_t i = 0; i < td1.rows.count; i += 1)
                    {
                        if (&td1.rows.items[i] == sum1) continue;
                        for (size_t c = 0; c < td1.columns.count && c < td1.rows.items[i].values.count; c += 1) sum1->values.items[c] += td1.rows.items[i].values.items[c];
                    }
                }
                if (sum2->values.count == 0)
                {
                    for (size_t c = 0; c < td2.columns.count; c += 1) values_add(&sum2->values, 0);
                    for (size_t i = 0; i < td2.rows.count; i += 1)
                    {
                        if (&td2.rows.items[i] == sum2) continue;
                        for (size_t c = 0; c < td2.columns.count && c < td2.rows.items[i].values.count; c += 1) sum2->values.items[c] += td2.rows.items[i].values.items[c];
                    }
                }
            }
        }
    }
    return result;
}

int main(int argc, char **argv)
{
    int result = 1;
    if (argc < 2)
    {
        fprintf(stderr, "usage: uarch time|stat|sweep|metrics|summarize|stages|symbols|branches|memory ...\n");
    }
    else if (strcmp(argv[1], "time") == 0) result = command_time(argc, argv);
    else if (strcmp(argv[1], "stat") == 0) result = command_stat(argc, argv);
    else if (strcmp(argv[1], "sweep") == 0) result = command_sweep(argc, argv);
    else if (strcmp(argv[1], "metrics") == 0) result = command_metrics(argc, argv);
    else if (strcmp(argv[1], "summarize") == 0) result = command_summarize(argc, argv);
    else if (strcmp(argv[1], "stages") == 0) result = command_stages(argc, argv);
    else if (strcmp(argv[1], "symbols") == 0) result = command_symbols(argc, argv);
    else if (strcmp(argv[1], "branches") == 0) result = command_branches(argc, argv);
    else if (strcmp(argv[1], "memory") == 0) result = command_memory(argc, argv);
    else if (strcmp(argv[1], "fanout") == 0) result = command_fanout(argc, argv);
    else if (strcmp(argv[1], "topdown") == 0) result = command_topdown(argc, argv);
    else fprintf(stderr, "uarch: unknown command %s\n", argv[1]);
    return result;
}
