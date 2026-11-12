// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// allcore: the runner and the reducers of the all-core design's measurements (buster#672).
//
//   cohort   runs a command on several CPUs at once: one worker a CPU, all workers starting together, each worker's
//            runs one after another. It writes a row a run: when the run started, exited and was reaped with the
//            orphans it left (the compiler's exit helper), its status and its resource use.
//   rows     reduces a cohort's rows: its span, its runs, and each column's median over the runs.
//   stages   reduces --time-stages reports: each stage's median over the runs.
//   stat     reduces perf stat -x, output (with or without -A): each event's count a CPU, and their sum.
//   timeline reduces perf stat -I output: each event's count an interval, one row an interval.
//   buckets  puts perf script's samples in the stage their time falls in, run by run, from the cohort's rows and each
//            run's own --time-stages report, and sums each event's periods a stage, a function and a family.
//   umcstages divides system-wide counts an interval (the memory controllers') among the stages the runs were in.
//   membw    streams over a buffer a worker (read, write, non-temporal write, copy): the host's bandwidth ceiling.
//   spine    writes a preprocessed unit without its function bodies, or with some of them only.
//
// Every reducer only reads files that a run wrote, so each table can be made again from the record.

#define _GNU_SOURCE
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/perf_event.h>
#include <sched.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define ALLCORE_MAX_WORKERS 64
#define ALLCORE_MAX_ARGUMENTS 8192
#define ALLCORE_PATH_BYTES 4096
#define ALLCORE_LINE_BYTES 65536
#define ALLCORE_MAX_STAGES 96
#define ALLCORE_MAX_EVENTS 16
#define ALLCORE_NAME_BYTES 128
#define ALLCORE_MAX_COUNTERS 8

static void fail(const char* format, ...)
{
    va_list arguments;
    va_start(arguments, format);
    fprintf(stderr, "allcore: ");
    vfprintf(stderr, format, arguments);
    fprintf(stderr, "\n");
    va_end(arguments);
    exit(2);
}

static int64_t now_ns(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return (int64_t)time.tv_sec * 1000000000 + time.tv_nsec;
}

static void* allocate(size_t bytes)
{
    void* result = calloc(1, bytes > 0 ? bytes : 1);
    if (result == NULL)
    {
        fail("out of memory (%zu bytes)", bytes);
    }
    return result;
}

static char* duplicate(const char* text)
{
    char* result = strdup(text);
    if (result == NULL)
    {
        fail("out of memory");
    }
    return result;
}

// `pattern` with every %w replaced by `worker` and every %i by `run`.
static char* substitute(const char* pattern, int worker, int run)
{
    size_t capacity = strlen(pattern) + 64;
    char* result = allocate(capacity);
    size_t length = 0;
    for (const char* at = pattern; *at != 0; at += 1)
    {
        if (length + 32 >= capacity)
        {
            capacity *= 2;
            result = realloc(result, capacity);
            if (result == NULL)
            {
                fail("out of memory");
            }
        }
        if (at[0] == '%' && at[1] == 'w')
        {
            length += (size_t)snprintf(result + length, 24, "%d", worker);
            at += 1;
        }
        else if (at[0] == '%' && at[1] == 'i')
        {
            length += (size_t)snprintf(result + length, 24, "%d", run);
            at += 1;
        }
        else
        {
            result[length] = *at;
            length += 1;
        }
    }
    result[length] = 0;
    return result;
}

typedef struct Lines Lines;
struct Lines
{
    char** items;
    size_t count;
    size_t capacity;
};

static void lines_push(Lines* lines, const char* text)
{
    if (lines->count == lines->capacity)
    {
        lines->capacity = lines->capacity > 0 ? lines->capacity * 2 : 64;
        lines->items = realloc(lines->items, lines->capacity * sizeof(char*));
        if (lines->items == NULL)
        {
            fail("out of memory");
        }
    }
    lines->items[lines->count] = duplicate(text);
    lines->count += 1;
}

// The file's lines without their newlines; an empty line is skipped.
static Lines lines_read(const char* path)
{
    Lines lines = { 0 };
    FILE* file = fopen(path, "r");
    if (file == NULL)
    {
        fail("can't read %s: %s", path, strerror(errno));
    }
    char* line = allocate(ALLCORE_LINE_BYTES);
    while (fgets(line, ALLCORE_LINE_BYTES, file) != NULL)
    {
        size_t length = strlen(line);
        while (length > 0 && (line[length - 1] == '\n' || line[length - 1] == '\r'))
        {
            length -= 1;
        }
        line[length] = 0;
        if (length > 0)
        {
            lines_push(&lines, line);
        }
    }
    free(line);
    fclose(file);
    return lines;
}

// ---------------------------------------------------------------------------------------------------------------------
// cohort

typedef struct CohortRow CohortRow;
struct CohortRow
{
    int64_t start_ns;
    int64_t exit_ns;
    int64_t reap_ns;
    int64_t user_us;
    int64_t system_us;
    int64_t orphan_user_us;
    int64_t orphan_system_us;
    int64_t peak_kb;
    int64_t minor_faults;
    int64_t major_faults;
    int64_t voluntary;
    int64_t involuntary;
    int64_t orphan_minor_faults;
    int64_t counters[ALLCORE_MAX_COUNTERS];
    // The least share of a run's time that one of its counters counted for, in hundredths of a percent: 10,000 when none
    // was multiplexed.
    int32_t counted;
    int32_t orphans;
    int32_t status;
    int32_t done;
    int32_t late;
};

// A counter of a run: an event of perf_event_open by its PMU's type and its config, counted in user mode, in the kernel
// or in both, for the run's process and every process it starts (the exit helper among them).
typedef struct CohortCounter CohortCounter;
struct CohortCounter
{
    char name[ALLCORE_NAME_BYTES];
    uint32_t type;
    uint64_t config;
    char mode;
};

// --events' list: NAME@TYPE@CONFIG@MODE,... with TYPE a decimal PMU type (0 the generic hardware events, 4 the core's
// raw events, or a PMU's own from /sys/bus/event_source/devices/PMU/type), CONFIG in hexadecimal and MODE u, k or a.
static int parse_counters(const char* text, CohortCounter* counters)
{
    int count = 0;
    char* copy = duplicate(text);
    char* entry = copy;
    while (entry != NULL && *entry != 0)
    {
        char* comma = strchr(entry, ',');
        if (comma != NULL)
        {
            *comma = 0;
        }
        char* first = strchr(entry, '@');
        char* second = first != NULL ? strchr(first + 1, '@') : NULL;
        char* third = second != NULL ? strchr(second + 1, '@') : NULL;
        if (third == NULL || count == ALLCORE_MAX_COUNTERS || (third[1] != 'u' && third[1] != 'k' && third[1] != 'a'))
        {
            fail("'%s' isn't NAME@TYPE@CONFIG@MODE, or is one counter too many", entry);
        }
        *first = 0;
        snprintf(counters[count].name, ALLCORE_NAME_BYTES, "%s", entry);
        counters[count].type = (uint32_t)strtoul(first + 1, NULL, 10);
        counters[count].config = strtoull(second + 1, NULL, 16);
        counters[count].mode = third[1];
        count += 1;
        entry = comma != NULL ? comma + 1 : NULL;
    }
    free(copy);
    return count;
}

static int64_t timeval_us(struct timeval value)
{
    return (int64_t)value.tv_sec * 1000000 + value.tv_usec;
}

// One worker: pinned to `cpu`, a subreaper so that the orphans its runs leave are its to wait for, spinning until the
// cohort's start so that its core is awake and at its frequency, then its runs one after another.
static void cohort_worker(int worker, const cpu_set_t* set, const char* directory, int runs, int64_t start_ns, CohortRow* rows, char** command, int command_count, const char* error_pattern,
                          const Lines* items, const Lines* extra, const CohortCounter* counters, int counter_count)
{
    if (sched_setaffinity(0, sizeof(*set), set) != 0)
    {
        fprintf(stderr, "allcore cohort: worker %d can't be pinned to its CPUs: %s\n", worker, strerror(errno));
        _exit(3);
    }
    if (directory != NULL && chdir(directory) != 0)
    {
        fprintf(stderr, "allcore cohort: worker %d can't enter %s: %s\n", worker, directory, strerror(errno));
        _exit(3);
    }
    prctl(PR_SET_CHILD_SUBREAPER, 1, 0, 0, 0);
    const bool late = now_ns() > start_ns;
    while (now_ns() < start_ns)
    {
    }
    for (int run = 0; run < runs; run += 1)
    {
        char** arguments = allocate(((size_t)command_count + (extra != NULL ? extra->count : 0) + 2) * sizeof(char*));
        int count = 0;
        for (int i = 0; i < command_count; i += 1)
        {
            arguments[count] = substitute(command[i], worker, run);
            count += 1;
        }
        for (size_t i = 0; extra != NULL && i < extra->count; i += 1)
        {
            arguments[count] = extra->items[i];
            count += 1;
        }
        if (items != NULL)
        {
            arguments[count] = items->items[run];
            count += 1;
        }
        arguments[count] = NULL;
        char* error_path = error_pattern != NULL ? substitute(error_pattern, worker, run) : NULL;
        CohortRow* row = &rows[run];
        row->late = late;
        // The child waits at the gate until its counters are attached; they start counting as it becomes the command.
        int gate[2];
        if (pipe(gate) != 0)
        {
            _exit(4);
        }
        const pid_t child = fork();
        if (child == 0)
        {
            char byte = 0;
            close(gate[1]);
            const ssize_t got = read(gate[0], &byte, 1);
            close(gate[0]);
            const int null = open("/dev/null", O_WRONLY);
            const int error = error_path != NULL ? open(error_path, O_WRONLY | O_CREAT | O_TRUNC, 0644) : null;
            dup2(null, 1);
            dup2(error >= 0 ? error : null, 2);
            if (got == 0)
            {
                execvp(arguments[0], arguments);
            }
            _exit(127);
        }
        int descriptors[ALLCORE_MAX_COUNTERS];
        for (int c = 0; c < counter_count; c += 1)
        {
            struct perf_event_attr attribute;
            memset(&attribute, 0, sizeof(attribute));
            attribute.size = sizeof(attribute);
            attribute.type = counters[c].type;
            attribute.config = counters[c].config;
            attribute.disabled = 1;
            attribute.enable_on_exec = 1;
            attribute.inherit = 1;
            attribute.exclude_kernel = counters[c].mode == 'u';
            attribute.exclude_user = counters[c].mode == 'k';
            // No exclusion at all in mode a: the msr PMU (APERF, MPERF) refuses any.
            attribute.exclude_hv = counters[c].mode != 'a';
            attribute.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING;
            descriptors[c] = (int)syscall(SYS_perf_event_open, &attribute, child, -1, -1, 0);
            if (descriptors[c] < 0)
            {
                fprintf(stderr, "allcore cohort: worker %d can't count %s: %s\n", worker, counters[c].name, strerror(errno));
                kill(child, SIGKILL);
                _exit(5);
            }
        }
        close(gate[0]);
        row->start_ns = now_ns();
        close(gate[1]);
        int status = 0;
        struct rusage use = { 0 };
        const pid_t waited = wait4(child, &status, 0, &use);
        row->exit_ns = now_ns();
        row->status = waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 255;
        row->user_us = timeval_us(use.ru_utime);
        row->system_us = timeval_us(use.ru_stime);
        row->peak_kb = use.ru_maxrss;
        row->minor_faults = use.ru_minflt;
        row->major_faults = use.ru_majflt;
        row->voluntary = use.ru_nvcsw;
        row->involuntary = use.ru_nivcsw;
        // The orphans: the compiler's exit helper tears its address space down after the compiler's parent has its
        // status. Its time is this run's too.
        bool more = true;
        while (more)
        {
            int orphan_status = 0;
            struct rusage orphan_use = { 0 };
            const pid_t orphan = wait4(-1, &orphan_status, 0, &orphan_use);
            more = orphan > 0;
            if (more)
            {
                row->orphans += 1;
                row->orphan_user_us += timeval_us(orphan_use.ru_utime);
                row->orphan_system_us += timeval_us(orphan_use.ru_stime);
                row->orphan_minor_faults += orphan_use.ru_minflt;
            }
        }
        row->reap_ns = now_ns();
        row->counted = 10000;
        for (int c = 0; c < counter_count; c += 1)
        {
            uint64_t values[3] = { 0 };
            const ssize_t got = read(descriptors[c], values, sizeof(values));
            row->counters[c] = got == (ssize_t)sizeof(values) ? (int64_t)values[0] : -1;
            const int32_t share = values[1] > 0 ? (int32_t)((double)values[2] * 10000.0 / (double)values[1]) : 0;
            row->counted = share < row->counted ? share : row->counted;
            close(descriptors[c]);
        }
        row->done = 1;
        for (int i = 0; i < command_count; i += 1)
        {
            free(arguments[i]);
        }
        free(arguments);
        free(error_path);
    }
    _exit(0);
}

// A list of workers' CPUs, `CPU,CPU...`: a worker's entry is one CPU, or several joined by '+' (a command that runs
// lanes of its own on them). `cpus` gets each worker's first CPU.
static int parse_cpus(const char* text, int* cpus, cpu_set_t* sets)
{
    int count = 0;
    char* copy = duplicate(text);
    char* entry = copy;
    while (entry != NULL)
    {
        char* comma = strchr(entry, ',');
        if (comma != NULL)
        {
            *comma = 0;
        }
        if (count == ALLCORE_MAX_WORKERS)
        {
            fail("'%s' lists more than %d workers", text, ALLCORE_MAX_WORKERS);
        }
        CPU_ZERO(&sets[count]);
        cpus[count] = -1;
        char* member = entry;
        while (member != NULL)
        {
            char* plus = strchr(member, '+');
            if (plus != NULL)
            {
                *plus = 0;
            }
            char* end = NULL;
            const long value = strtol(member, &end, 10);
            if (end == member || *end != 0 || value < 0 || value >= CPU_SETSIZE)
            {
                fail("'%s' isn't a list of CPUs", text);
            }
            CPU_SET((int)value, &sets[count]);
            cpus[count] = cpus[count] < 0 ? (int)value : cpus[count];
            member = plus != NULL ? plus + 1 : NULL;
        }
        count += 1;
        entry = comma != NULL ? comma + 1 : NULL;
    }
    free(copy);
    return count;
}

static int command_cohort(int argc, char** argv)
{
    const char* cpus_text = NULL;
    const char* out_path = NULL;
    const char* error_pattern = NULL;
    const char* items_pattern = NULL;
    const char* extra_pattern = NULL;
    const char* label = "cohort";
    const char* directory = NULL;
    const char* events_text = NULL;
    int loops = 1;
    int spin_ms = 20;
    int at = 2;
    bool options = true;
    while (options && at < argc)
    {
        if (strcmp(argv[at], "--") == 0)
        {
            options = false;
            at += 1;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--cpus") == 0)
        {
            cpus_text = argv[at + 1];
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--loops") == 0)
        {
            loops = atoi(argv[at + 1]);
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--out") == 0)
        {
            out_path = argv[at + 1];
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--stderr") == 0)
        {
            error_pattern = argv[at + 1];
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--items") == 0)
        {
            items_pattern = argv[at + 1];
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--arguments") == 0)
        {
            extra_pattern = argv[at + 1];
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--label") == 0)
        {
            label = argv[at + 1];
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--spin-ms") == 0)
        {
            spin_ms = atoi(argv[at + 1]);
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--directory") == 0)
        {
            directory = argv[at + 1];
            at += 2;
        }
        else if (at + 1 < argc && strcmp(argv[at], "--events") == 0)
        {
            events_text = argv[at + 1];
            at += 2;
        }
        else
        {
            fail("cohort: unknown option %s", argv[at]);
        }
    }
    if (cpus_text == NULL || out_path == NULL || at >= argc || loops < 1 || spin_ms < 1)
    {
        fail("usage: allcore cohort --cpus CPU,CPU... --out ROWS.tsv [--loops N] [--label NAME] [--stderr PATTERN] [--items PATTERN] [--arguments PATTERN] [--directory DIR] [--events LIST] [--spin-ms N] -- COMMAND...\n"
             "  --events counts NAME@TYPE@CONFIG@MODE,... for each run and the processes it starts (perf_event_open's type, a hexadecimal config, and u, k or a);\n"
             "  a worker's CPU may be several joined by '+'; %%w in COMMAND and in a PATTERN is the worker's number, %%i in --stderr's the run's;\n"
             "  --directory is where the runs start (the output file and the patterns are resolved before);\n"
             "  --items names a file a worker whose every line is one run's last argument (and their count the runs);\n"
             "  --arguments names a file a worker whose lines are arguments of each of its runs");
    }
    int cpus[ALLCORE_MAX_WORKERS];
    cpu_set_t* sets = allocate(ALLCORE_MAX_WORKERS * sizeof(cpu_set_t));
    const int workers = parse_cpus(cpus_text, cpus, sets);
    char** command = argv + at;
    const int command_count = argc - at;
    CohortCounter counters[ALLCORE_MAX_COUNTERS];
    const int counter_count = events_text != NULL ? parse_counters(events_text, counters) : 0;
    Lines items[ALLCORE_MAX_WORKERS] = { 0 };
    Lines extra[ALLCORE_MAX_WORKERS] = { 0 };
    int runs[ALLCORE_MAX_WORKERS];
    int most = 0;
    for (int worker = 0; worker < workers; worker += 1)
    {
        runs[worker] = loops;
        if (items_pattern != NULL)
        {
            char* path = substitute(items_pattern, worker, 0);
            items[worker] = lines_read(path);
            runs[worker] = (int)items[worker].count;
            free(path);
        }
        if (extra_pattern != NULL)
        {
            char* path = substitute(extra_pattern, worker, 0);
            extra[worker] = lines_read(path);
            free(path);
        }
        most = runs[worker] > most ? runs[worker] : most;
    }
    CohortRow* rows = mmap(NULL, (size_t)workers * (size_t)(most + 1) * sizeof(CohortRow), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    if (rows == MAP_FAILED)
    {
        fail("cohort: no memory for the rows");
    }
    struct timespec wall;
    clock_gettime(CLOCK_REALTIME, &wall);
    const int64_t planned_ns = now_ns();
    const int64_t start_ns = planned_ns + (int64_t)spin_ms * 1000000;
    pid_t pids[ALLCORE_MAX_WORKERS];
    for (int worker = 0; worker < workers; worker += 1)
    {
        pids[worker] = fork();
        if (pids[worker] == 0)
        {
            cohort_worker(worker, &sets[worker], directory, runs[worker], start_ns, rows + (size_t)worker * (size_t)(most + 1), command, command_count, error_pattern,
                          items_pattern != NULL ? &items[worker] : NULL, extra_pattern != NULL ? &extra[worker] : NULL, counters, counter_count);
        }
        if (pids[worker] < 0)
        {
            fail("cohort: fork: %s", strerror(errno));
        }
    }
    int result = 0;
    for (int worker = 0; worker < workers; worker += 1)
    {
        int status = 0;
        if (waitpid(pids[worker], &status, 0) != pids[worker] || !WIFEXITED(status) || WEXITSTATUS(status) != 0)
        {
            result = 1;
        }
    }
    FILE* out = fopen(out_path, "w");
    if (out == NULL)
    {
        fail("cohort: can't write %s: %s", out_path, strerror(errno));
    }
    fprintf(out, "# cohort\t%s\tworkers\t%d\tstart_ns\t%lld\trealtime_at_plan\t%lld.%09ld\tmonotonic_at_plan_ns\t%lld\n", label, workers, (long long)start_ns, (long long)wall.tv_sec, wall.tv_nsec,
            (long long)planned_ns);
    fprintf(out, "label\tworker\tcpu\trun\tstart_ns\texit_ns\treap_ns\tstatus\tuser_us\tsystem_us\tpeak_kb\tminor_faults\tmajor_faults\tvoluntary\tinvoluntary\torphans\torphan_user_us\torphan_system_us\torphan_minor_faults\tlate");
    for (int c = 0; c < counter_count; c += 1)
    {
        fprintf(out, "\t%s:%c", counters[c].name, counters[c].mode);
    }
    fprintf(out, "%s\n", counter_count > 0 ? "\tcounted" : "");
    for (int worker = 0; worker < workers; worker += 1)
    {
        for (int run = 0; run < runs[worker]; run += 1)
        {
            const CohortRow* row = &rows[(size_t)worker * (size_t)(most + 1) + (size_t)run];
            if (!row->done || row->status != 0)
            {
                result = 1;
            }
            fprintf(out, "%s\t%d\t%d\t%d\t%lld\t%lld\t%lld\t%d\t%lld\t%lld\t%lld\t%lld\t%lld\t%lld\t%lld\t%d\t%lld\t%lld\t%lld\t%d", label, worker, cpus[worker], run, (long long)row->start_ns,
                    (long long)row->exit_ns, (long long)row->reap_ns, row->done ? row->status : -1, (long long)row->user_us, (long long)row->system_us, (long long)row->peak_kb,
                    (long long)row->minor_faults, (long long)row->major_faults, (long long)row->voluntary, (long long)row->involuntary, row->orphans, (long long)row->orphan_user_us,
                    (long long)row->orphan_system_us, (long long)row->orphan_minor_faults, row->late);
            for (int c = 0; c < counter_count; c += 1)
            {
                fprintf(out, "\t%lld", (long long)row->counters[c]);
            }
            if (counter_count > 0)
            {
                fprintf(out, "\t%.2f", (double)row->counted / 100.0);
            }
            fprintf(out, "\n");
        }
    }
    fclose(out);
    return result;
}

// ---------------------------------------------------------------------------------------------------------------------
// The rows, read back

typedef struct Run Run;
struct Run
{
    int worker;
    int cpu;
    int run;
    int status;
    int64_t start_ns;
    int64_t exit_ns;
    int64_t reap_ns;
    double user_ms;
    double system_ms;
    double orphan_system_ms;
    double peak_kb;
    double minor_faults;
    double orphan_minor_faults;
    double orphans;
    double involuntary;
    double counters[ALLCORE_MAX_COUNTERS + 1];
    int late;
};

typedef struct Cohort Cohort;
struct Cohort
{
    char label[ALLCORE_NAME_BYTES];
    int workers;
    int64_t start_ns;
    int64_t plan_ns;
    char counter_names[ALLCORE_MAX_COUNTERS + 1][ALLCORE_NAME_BYTES];
    int counter_count;
    Run* runs;
    size_t count;
};

static int split_tabs(char* line, char** fields, int capacity)
{
    int count = 0;
    char* at = line;
    while (at != NULL && count < capacity)
    {
        fields[count] = at;
        count += 1;
        char* tab = strchr(at, '\t');
        if (tab != NULL)
        {
            *tab = 0;
            at = tab + 1;
        }
        else
        {
            at = NULL;
        }
    }
    return count;
}

static Cohort cohort_read(const char* path)
{
    Cohort cohort = { 0 };
    const Lines lines = lines_read(path);
    cohort.runs = allocate(lines.count * sizeof(Run));
    for (size_t i = 0; i < lines.count; i += 1)
    {
        char* fields[32];
        const int count = split_tabs(lines.items[i], fields, 32);
        if (count >= 6 && strcmp(fields[0], "# cohort") == 0)
        {
            snprintf(cohort.label, sizeof(cohort.label), "%s", fields[1]);
            cohort.workers = atoi(fields[3]);
            cohort.start_ns = atoll(fields[5]);
            cohort.plan_ns = count >= 10 ? atoll(fields[9]) : cohort.start_ns;
        }
        else if (count >= 20 && strcmp(fields[0], "label") == 0)
        {
            for (int c = 20; c < count && c - 20 <= ALLCORE_MAX_COUNTERS; c += 1)
            {
                snprintf(cohort.counter_names[c - 20], ALLCORE_NAME_BYTES, "%s", fields[c]);
                cohort.counter_count = c - 20 + 1;
            }
        }
        else if (count >= 20)
        {
            Run* run = &cohort.runs[cohort.count];
            run->worker = atoi(fields[1]);
            run->cpu = atoi(fields[2]);
            run->run = atoi(fields[3]);
            run->start_ns = atoll(fields[4]);
            run->exit_ns = atoll(fields[5]);
            run->reap_ns = atoll(fields[6]);
            run->status = atoi(fields[7]);
            run->user_ms = atof(fields[8]) / 1000.0;
            run->system_ms = atof(fields[9]) / 1000.0;
            run->peak_kb = atof(fields[10]);
            run->minor_faults = atof(fields[11]);
            run->orphans = atof(fields[15]);
            run->orphan_system_ms = atof(fields[17]) / 1000.0;
            run->orphan_minor_faults = atof(fields[18]);
            run->late = atoi(fields[19]);
            run->involuntary = atof(fields[14]);
            for (int c = 20; c < count && c - 20 <= ALLCORE_MAX_COUNTERS; c += 1)
            {
                run->counters[c - 20] = atof(fields[c]);
            }
            cohort.count += 1;
        }
    }
    if (cohort.count == 0)
    {
        fail("%s holds no run", path);
    }
    return cohort;
}

static int compare_doubles(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return a < b ? -1 : a > b ? 1 : 0;
}

static double median(double* values, size_t count)
{
    double result = 0.0;
    if (count > 0)
    {
        qsort(values, count, sizeof(double), compare_doubles);
        result = count % 2 == 1 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2.0;
    }
    return result;
}

// Sets `without` to the CPUs of a list (`-` or an empty list: none).
static void parse_without(const char* text, bool* without)
{
    memset(without, 0, CPU_SETSIZE * sizeof(bool));
    char* copy = duplicate(text);
    for (char* token = strtok(copy, ","); token != NULL; token = strtok(NULL, ","))
    {
        const int cpu = atoi(token);
        if (isdigit((unsigned char)token[0]) && cpu >= 0 && cpu < CPU_SETSIZE)
        {
            without[cpu] = true;
        }
    }
    free(copy);
}

// rows [--bytes N] [--interior] [--workers] [--pool NAME] [--without CPU,CPU...] FILE...: a line a cohort; with
// --workers a line a worker instead; with --pool one line, NAME's, for all the files' runs together (rounds of one
// cohort). `span_ms` is from the cohort's start to its last reap. `mb_per_s` is the workers' rates summed: each
// worker's runs' bytes over its own span, so that a slow worker lowers only its own share (pooled: the files' mean).
// The other columns are medians over the runs: with --interior, without each worker's first and last run, which the
// other workers don't overlap as the runs between are; --without leaves out the workers on those CPUs in the files
// after it (a core a stray process shared; `--without -` none again), whose rate is then taken as the others' mean.
// The counters' columns follow, as the rows name them.
static int command_rows(int argc, char** argv)
{
    double bytes = 0.0;
    bool interior = false;
    bool per_worker = false;
    bool header = true;
    const char* pool = NULL;
    int result = 0;
    bool without[CPU_SETSIZE] = { false };
    double* pooled = NULL;
    size_t pooled_used = 0;
    size_t pooled_capacity = 0;
    int pooled_columns = 0;
    int pooled_files = 0;
    int pooled_failed = 0;
    int pooled_workers = 0;
    int pooled_kept = 0;
    size_t pooled_runs = 0;
    double pooled_rate = 0.0;
    double pooled_span = 0.0;
    Cohort pooled_names = { 0 };
    for (int at = 2; at <= argc; at += 1)
    {
        const bool last = at == argc;
        if (!last && strcmp(argv[at], "--bytes") == 0 && at + 1 < argc)
        {
            bytes = atof(argv[at + 1]);
            at += 1;
        }
        else if (!last && strcmp(argv[at], "--without") == 0 && at + 1 < argc)
        {
            parse_without(argv[at + 1], without);
            at += 1;
        }
        else if (!last && strcmp(argv[at], "--pool") == 0 && at + 1 < argc)
        {
            pool = argv[at + 1];
            at += 1;
        }
        else if (!last && strcmp(argv[at], "--interior") == 0)
        {
            interior = true;
        }
        else if (!last && strcmp(argv[at], "--workers") == 0)
        {
            per_worker = true;
        }
        else if (!last)
        {
            const Cohort cohort = cohort_read(argv[at]);
            int last_run[ALLCORE_MAX_WORKERS] = { 0 };
            int64_t worker_reap[ALLCORE_MAX_WORKERS] = { 0 };
            int worker_runs[ALLCORE_MAX_WORKERS] = { 0 };
            int worker_cpu[ALLCORE_MAX_WORKERS] = { 0 };
            int64_t last_reap = 0;
            int failed = 0;
            int late = 0;
            int workers = 0;
            for (size_t i = 0; i < cohort.count; i += 1)
            {
                const Run* run = &cohort.runs[i];
                last_run[run->worker] = run->run > last_run[run->worker] ? run->run : last_run[run->worker];
                worker_reap[run->worker] = run->reap_ns > worker_reap[run->worker] ? run->reap_ns : worker_reap[run->worker];
                worker_runs[run->worker] += 1;
                worker_cpu[run->worker] = run->cpu;
                workers = run->worker + 1 > workers ? run->worker + 1 : workers;
                last_reap = run->reap_ns > last_reap ? run->reap_ns : last_reap;
                failed += run->status != 0;
                late += run->late && run->run == 0;
            }
            // The rate: each kept worker's own, and for a worker left out the kept ones' mean.
            double rate = 0.0;
            int kept_workers = 0;
            for (int worker = 0; worker < workers; worker += 1)
            {
                if (!without[worker_cpu[worker]] && worker_reap[worker] > cohort.start_ns)
                {
                    rate += (double)worker_runs[worker] * bytes / 1e6 / ((double)(worker_reap[worker] - cohort.start_ns) / 1e9);
                    kept_workers += 1;
                }
            }
            rate = kept_workers > 0 ? rate * (double)workers / (double)kept_workers : 0.0;
            const int columns = 9 + cohort.counter_count;
            if (header)
            {
                printf("label\tworkers\tkept_workers\truns\tfailed\tlate\tspan_ms\tmb_per_s\tused\twall_ms\tteardown_ms\tuser_ms\tsystem_ms\torphan_system_ms\tpeak_kb\tminor_faults\tinvoluntary\torphans");
                for (int c = 0; c < cohort.counter_count; c += 1)
                {
                    printf("\t%s", cohort.counter_names[c]);
                }
                printf("\n");
                header = false;
            }
            const int groups = per_worker && pool == NULL ? workers : 1;
            for (int group = 0; group < groups; group += 1)
            {
                double* values = allocate(cohort.count * (size_t)columns * sizeof(double));
                size_t used = 0;
                for (size_t i = 0; i < cohort.count; i += 1)
                {
                    const Run* run = &cohort.runs[i];
                    const bool edge = last_run[run->worker] >= 2 && (run->run == 0 || run->run == last_run[run->worker]);
                    const bool mine = per_worker && pool == NULL ? run->worker == group : !without[run->cpu];
                    if (mine && (!interior || !edge))
                    {
                        double* row = values + used * (size_t)columns;
                        row[0] = (double)(run->exit_ns - run->start_ns) / 1e6;
                        row[1] = (double)(run->reap_ns - run->exit_ns) / 1e6;
                        row[2] = run->user_ms;
                        row[3] = run->system_ms;
                        row[4] = run->orphan_system_ms;
                        row[5] = run->peak_kb;
                        row[6] = run->minor_faults + run->orphan_minor_faults;
                        row[7] = run->involuntary;
                        row[8] = run->orphans;
                        for (int c = 0; c < cohort.counter_count; c += 1)
                        {
                            row[9 + c] = run->counters[c];
                        }
                        used += 1;
                    }
                }
                const double span_ms = (double)((per_worker && pool == NULL ? worker_reap[group] : last_reap) - cohort.start_ns) / 1e6;
                if (pool != NULL)
                {
                    if (pooled_files > 0 && columns != pooled_columns)
                    {
                        fail("rows: %s has other counters than the files pooled before it", argv[at]);
                    }
                    if (pooled_used + used > pooled_capacity)
                    {
                        pooled_capacity = (pooled_used + used) * 2;
                        pooled = realloc(pooled, pooled_capacity * (size_t)columns * sizeof(double));
                        if (pooled == NULL)
                        {
                            fail("out of memory");
                        }
                    }
                    memcpy(pooled + pooled_used * (size_t)columns, values, used * (size_t)columns * sizeof(double));
                    pooled_used += used;
                    pooled_columns = columns;
                    pooled_files += 1;
                    pooled_failed += failed;
                    pooled_workers = workers;
                    pooled_kept += kept_workers;
                    pooled_runs += cohort.count;
                    pooled_rate += rate;
                    pooled_span += span_ms;
                    pooled_names = cohort;
                }
                else
                {
                    const double own_rate = per_worker ? (double)worker_runs[group] * bytes / 1e6 / (span_ms / 1e3) : rate;
                    if (per_worker)
                    {
                        printf("%s.cpu%d\t1\t1\t%d\t%d\t%d\t%.3f\t%.2f\t%zu", cohort.label, worker_cpu[group], worker_runs[group], failed, late, span_ms, own_rate, used);
                    }
                    else
                    {
                        printf("%s\t%d\t%d\t%zu\t%d\t%d\t%.3f\t%.2f\t%zu", cohort.label, workers, kept_workers, cohort.count, failed, late, span_ms, own_rate, used);
                    }
                    double* column = allocate((used + 1) * sizeof(double));
                    for (int c = 0; c < columns; c += 1)
                    {
                        for (size_t i = 0; i < used; i += 1)
                        {
                            column[i] = values[i * (size_t)columns + (size_t)c];
                        }
                        printf(c == 5 || c == 6 || c >= 9 ? "\t%.0f" : "\t%.3f", median(column, used));
                    }
                    printf("\n");
                    free(column);
                }
                free(values);
            }
            result |= failed != 0;
        }
        else if (pool != NULL && pooled_files > 0)
        {
            // The pool's line: `kept_workers` is the files' mean, `runs` their sum, the span and the rate their means.
            printf("%s\t%d\t%.2f\t%zu\t%d\t0\t%.3f\t%.2f\t%zu", pool, pooled_workers, (double)pooled_kept / (double)pooled_files, pooled_runs, pooled_failed, pooled_span / (double)pooled_files,
                   pooled_rate / (double)pooled_files, pooled_used);
            double* column = allocate((pooled_used + 1) * sizeof(double));
            for (int c = 0; c < pooled_columns; c += 1)
            {
                for (size_t i = 0; i < pooled_used; i += 1)
                {
                    column[i] = pooled[i * (size_t)pooled_columns + (size_t)c];
                }
                printf(c == 5 || c == 6 || c >= 9 ? "\t%.0f" : "\t%.3f", median(column, pooled_used));
            }
            printf("\n");
            free(column);
            (void)pooled_names;
        }
    }
    return result;
}

// ---------------------------------------------------------------------------------------------------------------------
// Stage reports

typedef struct StageReport StageReport;
struct StageReport
{
    char names[ALLCORE_MAX_STAGES][40];
    double ms[ALLCORE_MAX_STAGES];
    double system_ms[ALLCORE_MAX_STAGES];
    double faults[ALLCORE_MAX_STAGES];
    double peak_kb[ALLCORE_MAX_STAGES];
    bool top[ALLCORE_MAX_STAGES];
    int count;
    double total_ms;
    double tokens;
    double peak_rss_kb;
    double user_ms;
    double process_system_ms;
    double minor_faults;
    char huge_pages[24];
    int status;
    bool found;
};

// A --time-stages report: its `time-stage` rows (a stage's phases, whose names hold a '.', among them, not `top`), the
// span and the process's lines this reads.
static StageReport stage_report_read(const char* path)
{
    StageReport report = { 0 };
    report.status = -1;
    FILE* file = fopen(path, "r");
    if (file != NULL)
    {
        report.found = true;
        char line[4096];
        while (fgets(line, sizeof(line), file) != NULL)
        {
            line[strcspn(line, "\n")] = 0;
            char* fields[12];
            const int count = split_tabs(line, fields, 12);
            if (count >= 3 && strcmp(fields[0], "time-stage") == 0 && strcmp(fields[1], "stage") != 0)
            {
                if (strcmp(fields[1], "total") == 0)
                {
                    report.total_ms = atof(fields[2]);
                }
                else if (report.count < ALLCORE_MAX_STAGES)
                {
                    snprintf(report.names[report.count], sizeof(report.names[0]), "%s", fields[1]);
                    report.ms[report.count] = atof(fields[2]);
                    report.top[report.count] = strchr(fields[1], '.') == NULL;
                    report.system_ms[report.count] = count >= 5 ? atof(fields[4]) : 0.0;
                    report.faults[report.count] = count >= 6 ? atof(fields[5]) : 0.0;
                    report.peak_kb[report.count] = count >= 7 ? atof(fields[6]) : 0.0;
                    report.count += 1;
                }
            }
            else if (count >= 3 && strcmp(fields[0], "time-process") == 0)
            {
                if (strcmp(fields[1], "tokens") == 0)
                {
                    report.tokens = atof(fields[2]);
                }
                else if (strcmp(fields[1], "peak-rss-kb") == 0)
                {
                    report.peak_rss_kb = atof(fields[2]);
                }
                else if (strcmp(fields[1], "user-ms") == 0)
                {
                    report.user_ms = atof(fields[2]);
                }
                else if (strcmp(fields[1], "system-ms") == 0)
                {
                    report.process_system_ms = atof(fields[2]);
                }
                else if (strcmp(fields[1], "minor-faults") == 0)
                {
                    report.minor_faults = atof(fields[2]);
                }
                else if (strcmp(fields[1], "huge-pages") == 0)
                {
                    snprintf(report.huge_pages, sizeof(report.huge_pages), "%s", fields[2]);
                }
            }
            else if (strncmp(line, "status ", 7) == 0)
            {
                report.status = atoi(line + 7);
            }
        }
        fclose(file);
    }
    return report;
}

// stages [--interior] [--without CPU,CPU...] ROWS.tsv PATTERN [[--without ...] ROWS.tsv PATTERN]...: each stage's median
// over the runs' reports of every cohort given (PATTERN with %w and %i, a pair a cohort: rounds pool), in milliseconds,
// with its system time, faults and added peak as the report gives them, then the process's lines. --interior leaves
// out each worker's first and last run; --without the workers on those CPUs, in the cohorts after it.
static int command_stages(int argc, char** argv)
{
    bool interior = false;
    bool without[CPU_SETSIZE] = { false };
    StageReport* reports = NULL;
    size_t used = 0;
    size_t capacity = 0;
    int missing = 0;
    char label[ALLCORE_NAME_BYTES] = "";
    int at = 2;
    while (at < argc)
    {
        if (strcmp(argv[at], "--interior") == 0)
        {
            interior = true;
            at += 1;
        }
        else if (strcmp(argv[at], "--without") == 0 && at + 1 < argc)
        {
            parse_without(argv[at + 1], without);
            at += 2;
        }
        else if (at + 1 < argc)
        {
            const Cohort cohort = cohort_read(argv[at]);
            snprintf(label, sizeof(label), "%s", cohort.label);
            int last_run[ALLCORE_MAX_WORKERS] = { 0 };
            for (size_t i = 0; i < cohort.count; i += 1)
            {
                const Run* run = &cohort.runs[i];
                last_run[run->worker] = run->run > last_run[run->worker] ? run->run : last_run[run->worker];
            }
            for (size_t i = 0; i < cohort.count; i += 1)
            {
                const Run* run = &cohort.runs[i];
                const bool edge = last_run[run->worker] >= 2 && (run->run == 0 || run->run == last_run[run->worker]);
                if ((!interior || !edge) && !without[run->cpu])
                {
                    char* path = substitute(argv[at + 1], run->worker, run->run);
                    if (used == capacity)
                    {
                        capacity = capacity > 0 ? capacity * 2 : 64;
                        reports = realloc(reports, capacity * sizeof(StageReport));
                        if (reports == NULL)
                        {
                            fail("out of memory");
                        }
                    }
                    reports[used] = stage_report_read(path);
                    if (!reports[used].found || reports[used].count == 0)
                    {
                        missing += 1;
                    }
                    else
                    {
                        used += 1;
                    }
                    free(path);
                }
            }
            at += 2;
        }
        else
        {
            fail("usage: allcore stages [--interior] [--without CPU,CPU...] ROWS.tsv PATTERN [ROWS.tsv PATTERN]...");
        }
    }
    if (used == 0)
    {
        fail("stages: no report read");
    }
    printf("# %s: %zu reports, %d missing\n", label, used, missing);
    printf("stage\tms\tsystem_ms\tminor_faults\tpeak_kb_added\n");
    double* values = allocate(used * sizeof(double));
    const StageReport* first = &reports[0];
    for (int stage = 0; stage < first->count; stage += 1)
    {
        double medians[4];
        for (int column = 0; column < 4; column += 1)
        {
            size_t count = 0;
            for (size_t i = 0; i < used; i += 1)
            {
                if (stage < reports[i].count && strcmp(reports[i].names[stage], first->names[stage]) == 0)
                {
                    values[count] = column == 0 ? reports[i].ms[stage] : column == 1 ? reports[i].system_ms[stage] : column == 2 ? reports[i].faults[stage] : reports[i].peak_kb[stage];
                    count += 1;
                }
            }
            medians[column] = median(values, count);
        }
        printf("%s\t%.3f\t%.3f\t%.0f\t%.0f\n", first->names[stage], medians[0], medians[1], medians[2], medians[3]);
    }
    const char* names[] = { "total", "tokens", "peak-rss-kb", "user-ms", "system-ms", "minor-faults" };
    for (int column = 0; column < 6; column += 1)
    {
        for (size_t i = 0; i < used; i += 1)
        {
            const StageReport* report = &reports[i];
            values[i] = column == 0 ? report->total_ms : column == 1 ? report->tokens : column == 2 ? report->peak_rss_kb : column == 3 ? report->user_ms : column == 4 ? report->process_system_ms : report->minor_faults;
        }
        printf("process\t%s\t%.3f\n", names[column], median(values, used));
    }
    int busy = 0;
    int system = 0;
    int off = 0;
    for (size_t i = 0; i < used; i += 1)
    {
        busy += strcmp(reports[i].huge_pages, "busy") == 0;
        system += strcmp(reports[i].huge_pages, "system") == 0;
        off += strcmp(reports[i].huge_pages, "off") == 0;
    }
    printf("process\thuge-pages\tsystem=%d busy=%d off=%d\n", system, busy, off);
    return 0;
}

// ---------------------------------------------------------------------------------------------------------------------
// perf stat's CSV

// stat FILE...: each counted line as `file event cpu value running_percent running_ns`; a line without a CPU (no -A)
// has cpu `all`. A line perf could not count (`<not counted>`, `<not supported>`) is printed with value -1. The time
// a counter ran is summed over the units that count it (an event of the two memory controllers ran twice the wall time).
static int command_stat(int argc, char** argv)
{
    printf("file\tevent\tcpu\tvalue\trunning_percent\trunning_ns\n");
    for (int at = 2; at < argc; at += 1)
    {
        const Lines lines = lines_read(argv[at]);
        for (size_t i = 0; i < lines.count; i += 1)
        {
            char* line = lines.items[i];
            if (line[0] != '#')
            {
                char* fields[16];
                int count = 0;
                char* field = line;
                while (field != NULL && count < 16)
                {
                    fields[count] = field;
                    count += 1;
                    char* comma = strchr(field, ',');
                    if (comma != NULL)
                    {
                        *comma = 0;
                        field = comma + 1;
                    }
                    else
                    {
                        field = NULL;
                    }
                }
                const bool per_cpu = count >= 6 && strncmp(fields[0], "CPU", 3) == 0;
                const int base = per_cpu ? 1 : 0;
                if (count >= base + 5)
                {
                    const bool counted = isdigit((unsigned char)fields[base][0]) != 0;
                    printf("%s\t%s\t%s\t%s\t%s\t%s\n", argv[at], fields[base + 2], per_cpu ? fields[0] + 3 : "all", counted ? fields[base] : "-1", fields[base + 4], fields[base + 3]);
                }
            }
        }
    }
    return 0;
}

// timeline FILE: perf stat -I's lines as one row an interval: its end in seconds, then each event's count.
static int command_timeline(int argc, char** argv)
{
    if (argc != 3)
    {
        fail("usage: allcore timeline INTERVALS.csv");
    }
    const Lines lines = lines_read(argv[2]);
    char events[ALLCORE_MAX_EVENTS][ALLCORE_NAME_BYTES];
    int event_count = 0;
    // The events, in the first interval's order.
    for (size_t i = 0; i < lines.count; i += 1)
    {
        char* copy = duplicate(lines.items[i]);
        char* fields[8];
        int count = 0;
        for (char* token = strtok(copy, ","); token != NULL && count < 8; token = strtok(NULL, ","))
        {
            fields[count] = token;
            count += 1;
        }
        if (copy[0] != '#' && count >= 3)
        {
            const char* name = fields[2];
            bool known = false;
            for (int e = 0; e < event_count; e += 1)
            {
                known = known || strcmp(events[e], name) == 0;
            }
            if (!known && event_count < ALLCORE_MAX_EVENTS)
            {
                snprintf(events[event_count], ALLCORE_NAME_BYTES, "%s", name);
                event_count += 1;
            }
        }
        free(copy);
    }
    printf("seconds");
    for (int e = 0; e < event_count; e += 1)
    {
        printf("\t%s", events[e]);
    }
    printf("\n");
    char current[64] = "";
    double values[ALLCORE_MAX_EVENTS] = { 0 };
    for (size_t i = 0; i <= lines.count; i += 1)
    {
        char* fields[8];
        int count = 0;
        if (i < lines.count && lines.items[i][0] != '#')
        {
            for (char* token = strtok(lines.items[i], ","); token != NULL && count < 8; token = strtok(NULL, ","))
            {
                fields[count] = token;
                count += 1;
            }
        }
        const bool row = count >= 3;
        if ((i == lines.count || (row && strcmp(fields[0], current) != 0)) && current[0] != 0)
        {
            printf("%s", current);
            for (int e = 0; e < event_count; e += 1)
            {
                printf("\t%.0f", values[e]);
                values[e] = 0.0;
            }
            printf("\n");
        }
        if (row)
        {
            snprintf(current, sizeof(current), "%s", fields[0]);
            for (int e = 0; e < event_count; e += 1)
            {
                if (strcmp(events[e], fields[2]) == 0)
                {
                    values[e] += atof(fields[1]);
                }
            }
        }
    }
    return 0;
}

// ---------------------------------------------------------------------------------------------------------------------
// buckets

typedef struct Sample Sample;
struct Sample
{
    int64_t time_ns;
    uint64_t period;
    uint32_t symbol;
    uint16_t cpu;
    uint8_t event;
    uint8_t kernel;
};

typedef struct Symbols Symbols;
struct Symbols
{
    char** names;
    uint32_t* slots;
    uint32_t count;
    uint32_t capacity;
    uint32_t slot_count;
};

static uint64_t hash_text(const char* text)
{
    uint64_t hash = 1469598103934665603ull;
    for (const char* at = text; *at != 0; at += 1)
    {
        hash = (hash ^ (uint8_t)*at) * 1099511628211ull;
    }
    return hash;
}

static uint32_t symbols_intern(Symbols* symbols, const char* name)
{
    if (symbols->slot_count == 0)
    {
        symbols->slot_count = 1u << 16;
        symbols->slots = allocate(symbols->slot_count * sizeof(uint32_t));
    }
    if (symbols->count * 2 >= symbols->slot_count)
    {
        const uint32_t new_count = symbols->slot_count * 2;
        uint32_t* slots = allocate(new_count * sizeof(uint32_t));
        for (uint32_t i = 0; i < symbols->count; i += 1)
        {
            uint32_t slot = (uint32_t)(hash_text(symbols->names[i]) & (new_count - 1));
            while (slots[slot] != 0)
            {
                slot = (slot + 1) & (new_count - 1);
            }
            slots[slot] = i + 1;
        }
        free(symbols->slots);
        symbols->slots = slots;
        symbols->slot_count = new_count;
    }
    uint32_t slot = (uint32_t)(hash_text(name) & (symbols->slot_count - 1));
    uint32_t result = UINT32_MAX;
    while (result == UINT32_MAX)
    {
        if (symbols->slots[slot] == 0)
        {
            if (symbols->count == symbols->capacity)
            {
                symbols->capacity = symbols->capacity > 0 ? symbols->capacity * 2 : 4096;
                symbols->names = realloc(symbols->names, symbols->capacity * sizeof(char*));
                if (symbols->names == NULL)
                {
                    fail("out of memory");
                }
            }
            symbols->names[symbols->count] = duplicate(name);
            symbols->slots[slot] = symbols->count + 1;
            result = symbols->count;
            symbols->count += 1;
        }
        else if (strcmp(symbols->names[symbols->slots[slot] - 1], name) == 0)
        {
            result = symbols->slots[slot] - 1;
        }
        else
        {
            slot = (slot + 1) & (symbols->slot_count - 1);
        }
    }
    return result;
}

typedef struct Family Family;
struct Family
{
    char prefix[ALLCORE_NAME_BYTES];
    char name[ALLCORE_NAME_BYTES];
};

// A sample's line as `perf script -F cpu,pid,tid,time,period,event,ip,sym --ns` prints it:
//   PID/TID [CPU] SECONDS.NANOSECONDS:  PERIOD  EVENT:  IP SYMBOL
static bool sample_parse(char* line, int* cpu, int64_t* time_ns, uint64_t* period, char** event, uint64_t* ip, char** symbol)
{
    bool result = false;
    char* bracket = strchr(line, '[');
    char* close = bracket != NULL ? strchr(bracket, ']') : NULL;
    if (close != NULL)
    {
        *cpu = atoi(bracket + 1);
        char* at = close + 1;
        while (*at == ' ')
        {
            at += 1;
        }
        char* colon = strchr(at, ':');
        char* dot = strchr(at, '.');
        if (colon != NULL && dot != NULL && dot < colon)
        {
            *colon = 0;
            const int64_t seconds = atoll(at);
            int64_t fraction = 0;
            int digits = 0;
            for (const char* digit = dot + 1; isdigit((unsigned char)*digit) && digits < 9; digit += 1)
            {
                fraction = fraction * 10 + (*digit - '0');
                digits += 1;
            }
            for (; digits < 9; digits += 1)
            {
                fraction *= 10;
            }
            *time_ns = seconds * 1000000000 + fraction;
            at = colon + 1;
            char* end = NULL;
            *period = strtoull(at, &end, 10);
            if (end != at)
            {
                at = end;
                while (*at == ' ')
                {
                    at += 1;
                }
                // The event's name ends at the colon before the address: a name may hold colons itself (`cycles:u`).
                char* separator = strstr(at, ": ");
                if (separator != NULL)
                {
                    *separator = 0;
                    *event = at;
                    at = separator + 1;
                    while (*at == ' ')
                    {
                        at += 1;
                    }
                    *ip = strtoull(at, &end, 16);
                    at = end;
                    while (*at == ' ')
                    {
                        at += 1;
                    }
                    *symbol = at;
                    result = true;
                }
            }
        }
    }
    return result;
}

typedef struct RunStages RunStages;
struct RunStages
{
    // The top-level stages' ends from the clock's start, in ns, and the clock's start on the samples' clock.
    int64_t ends[ALLCORE_MAX_STAGES];
    int stage_of[ALLCORE_MAX_STAGES];
    int count;
    int64_t clock_ns;
    double spread_ms;
    double after_start_ms;
    int anchors;
    bool used;
};

static int compare_samples(const void* left, const void* right)
{
    const Sample* a = left;
    const Sample* b = right;
    return a->cpu != b->cpu ? (a->cpu < b->cpu ? -1 : 1) : a->time_ns < b->time_ns ? -1 : a->time_ns > b->time_ns ? 1 : 0;
}

static int compare_int64(const void* left, const void* right)
{
    const int64_t a = *(const int64_t*)left;
    const int64_t b = *(const int64_t*)right;
    return a < b ? -1 : a > b ? 1 : 0;
}

typedef struct FunctionCount FunctionCount;
struct FunctionCount
{
    uint32_t symbol;
    double lead;
};

static int compare_function_counts(const void* left, const void* right)
{
    const FunctionCount* a = left;
    const FunctionCount* b = right;
    return a->lead > b->lead ? -1 : a->lead < b->lead ? 1 : 0;
}

// buckets --rows ROWS.tsv --stages PATTERN --samples FILE [--skip-first] [--interior] [--without CPU,CPU...]
// [--functions N] [--families FILE] [--cpu N] (--skip-first leaves out each worker's first run, --interior its first and
// last, --without the workers on those CPUs, --cpu every worker but that CPU's):
// each sample goes to the run whose span on its CPU holds its time (from the run's start to its reap), and in it to the
// stage its time falls in: `startup` before the clock's start, a stage of the run's own report, `exit` after the last
// stage's end until the run's parent has its status, `teardown` after that. Samples of no run are `outside`. The clock's
// start on the samples' clock (perf record -k CLOCK_MONOTONIC, the rows' clock) is the median of up to three estimates:
// the first sample of a function of the parser, of the reader and of Tier 0, each less the stages that end before its
// stage. Without any, it is the run's start and the median of the other runs' distance from theirs.
// Prints each stage's sums a run (the mean over the runs used), then each stage's functions and the families' sums.
static int command_buckets(int argc, char** argv)
{
    const char* rows_path = NULL;
    const char* stages_pattern = NULL;
    const char* samples_path = NULL;
    const char* families_path = NULL;
    bool skip_first = false;
    bool interior = false;
    bool all_cpus = false;
    long skip_pid[16] = { 0 };
    int skipped_pids = 0;
    size_t skipped_lines = 0;
    bool without[CPU_SETSIZE] = { false };
    int functions = 0;
    int only_cpu = -1;
    for (int at = 2; at < argc; at += 1)
    {
        if (strcmp(argv[at], "--rows") == 0 && at + 1 < argc)
        {
            rows_path = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--all-cpus") == 0)
        {
            all_cpus = true;
        }
        else if (strcmp(argv[at], "--without-pid") == 0 && at + 1 < argc)
        {
            char* copy = duplicate(argv[at + 1]);
            for (char* token = strtok(copy, ","); token != NULL && skipped_pids < 16; token = strtok(NULL, ","))
            {
                if (isdigit((unsigned char)token[0]))
                {
                    skip_pid[skipped_pids] = atol(token);
                    skipped_pids += 1;
                }
            }
            free(copy);
            at += 1;
        }
        else if (strcmp(argv[at], "--stages") == 0 && at + 1 < argc)
        {
            stages_pattern = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--without") == 0 && at + 1 < argc)
        {
            parse_without(argv[at + 1], without);
            at += 1;
        }
        else if (strcmp(argv[at], "--interior") == 0)
        {
            interior = true;
        }
        else if (strcmp(argv[at], "--samples") == 0 && at + 1 < argc)
        {
            samples_path = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--families") == 0 && at + 1 < argc)
        {
            families_path = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--functions") == 0 && at + 1 < argc)
        {
            functions = atoi(argv[at + 1]);
            at += 1;
        }
        else if (strcmp(argv[at], "--cpu") == 0 && at + 1 < argc)
        {
            only_cpu = atoi(argv[at + 1]);
            at += 1;
        }
        else if (strcmp(argv[at], "--skip-first") == 0)
        {
            skip_first = true;
        }
        else
        {
            fail("buckets: unknown option %s", argv[at]);
        }
    }
    if (rows_path == NULL || samples_path == NULL)
    {
        fail("usage: allcore buckets --rows ROWS.tsv [--stages PATTERN] --samples FILE[.gz] [--skip-first] [--interior] [--without CPU,CPU...] [--without-pid PID,PID...] [--all-cpus] [--functions N] [--families FILE] [--cpu N]");
    }
    Cohort cohort = cohort_read(rows_path);
    if (all_cpus)
    {
        // One worker whose command runs on several CPUs (lanes): its samples are its runs' by their time alone.
        for (size_t i = 0; i < cohort.count; i += 1)
        {
            cohort.runs[i].cpu = 0;
        }
    }
    int last_run[ALLCORE_MAX_WORKERS] = { 0 };
    for (size_t i = 0; i < cohort.count; i += 1)
    {
        const Run* run = &cohort.runs[i];
        last_run[run->worker] = run->run > last_run[run->worker] ? run->run : last_run[run->worker];
    }
    // The stages' names, in the first report's order, with the four this adds.
    char names[ALLCORE_MAX_STAGES + 5][40];
    int name_count = 0;
    snprintf(names[0], 40, "outside");
    snprintf(names[1], 40, "startup");
    name_count = 2;
    RunStages* stages = allocate(cohort.count * sizeof(RunStages));
    double tokens = 0.0;
    int stage_base = 2;
    int preprocess_end = -1;
    int type_table_end = -1;
    int lower_end = -1;
    for (size_t i = 0; i < cohort.count; i += 1)
    {
        const Run* run = &cohort.runs[i];
        StageReport report = { 0 };
        if (stages_pattern != NULL)
        {
            char* path = substitute(stages_pattern, run->worker, run->run);
            report = stage_report_read(path);
            free(path);
        }
        else
        {
            // Without reports, a run is one stage, `run`, from its start to its status.
            report.found = true;
            report.count = 1;
            report.top[0] = true;
            snprintf(report.names[0], sizeof(report.names[0]), "run");
            report.ms[0] = (double)(run->exit_ns - run->start_ns) / 1e6;
        }
        RunStages* own = &stages[i];
        const bool edge = last_run[run->worker] >= 2 && (run->run == 0 || run->run == last_run[run->worker]);
        own->used = report.found && report.count > 0 && run->status == 0 && !(skip_first && run->run == 0) && !(interior && edge) && !without[run->cpu] &&
                    (only_cpu < 0 || run->cpu == only_cpu);
        int64_t end = 0;
        for (int stage = 0; stage < report.count; stage += 1)
        {
            if (report.top[stage])
            {
                int index = -1;
                for (int known = stage_base; known < name_count; known += 1)
                {
                    index = strcmp(names[known], report.names[stage]) == 0 ? known : index;
                }
                if (index < 0 && name_count < ALLCORE_MAX_STAGES + 2)
                {
                    snprintf(names[name_count], 40, "%s", report.names[stage]);
                    index = name_count;
                    name_count += 1;
                }
                end += (int64_t)(report.ms[stage] * 1e6);
                own->ends[own->count] = end;
                own->stage_of[own->count] = index;
                own->count += 1;
                preprocess_end = strcmp(report.names[stage], "preprocess") == 0 ? own->count - 1 : preprocess_end;
                type_table_end = strcmp(report.names[stage], "type-table") == 0 ? own->count - 1 : type_table_end;
                lower_end = strcmp(report.names[stage], "lower") == 0 ? own->count - 1 : lower_end;
            }
        }
        tokens = report.tokens > 0.0 ? report.tokens : tokens;
    }
    const int exit_stage = name_count;
    snprintf(names[exit_stage], 40, "exit");
    const int teardown_stage = name_count + 1;
    snprintf(names[teardown_stage], 40, "teardown");
    name_count += 2;

    // The samples.
    char command[ALLCORE_PATH_BYTES + 32];
    const size_t path_length = strlen(samples_path);
    const bool zipped = path_length > 3 && strcmp(samples_path + path_length - 3, ".gz") == 0;
    snprintf(command, sizeof(command), "gzip -dc '%s'", samples_path);
    FILE* file = zipped ? popen(command, "r") : fopen(samples_path, "r");
    if (file == NULL)
    {
        fail("buckets: can't read %s", samples_path);
    }
    Symbols symbols = { 0 };
    char events[ALLCORE_MAX_EVENTS][ALLCORE_NAME_BYTES];
    int event_count = 0;
    Sample* samples = NULL;
    size_t sample_count = 0;
    size_t sample_capacity = 0;
    char* line = allocate(ALLCORE_LINE_BYTES);
    size_t unparsed = 0;
    while (fgets(line, ALLCORE_LINE_BYTES, file) != NULL)
    {
        line[strcspn(line, "\n")] = 0;
        int cpu = 0;
        int64_t time_ns = 0;
        uint64_t period = 0;
        uint64_t ip = 0;
        char* event = NULL;
        char* symbol = NULL;
        // A line starts with its process's and its thread's IDs: a stray process's samples are left out by its ID.
        const long pid = strtol(line, NULL, 10);
        bool stray = false;
        for (int k = 0; k < skipped_pids; k += 1)
        {
            stray = stray || pid == skip_pid[k];
        }
        if (stray)
        {
            skipped_lines += 1;
        }
        else if (sample_parse(line, &cpu, &time_ns, &period, &event, &ip, &symbol))
        {
            int index = -1;
            for (int e = 0; e < event_count; e += 1)
            {
                index = strcmp(events[e], event) == 0 ? e : index;
            }
            if (index < 0 && event_count < ALLCORE_MAX_EVENTS)
            {
                snprintf(events[event_count], ALLCORE_NAME_BYTES, "%s", event);
                index = event_count;
                event_count += 1;
            }
            if (index >= 0)
            {
                if (sample_count == sample_capacity)
                {
                    sample_capacity = sample_capacity > 0 ? sample_capacity * 2 : 1u << 20;
                    samples = realloc(samples, sample_capacity * sizeof(Sample));
                    if (samples == NULL)
                    {
                        fail("out of memory");
                    }
                }
                Sample* sample = &samples[sample_count];
                sample->time_ns = time_ns;
                sample->period = period;
                sample->cpu = all_cpus ? 0 : (uint16_t)cpu;
                sample->event = (uint8_t)index;
                sample->kernel = ip >= 0xffff800000000000ull;
                sample->symbol = symbols_intern(&symbols, symbol[0] != 0 ? symbol : "[none]");
                sample_count += 1;
            }
        }
        else if (line[0] != 0)
        {
            unparsed += 1;
        }
    }
    if (zipped)
    {
        pclose(file);
    }
    else
    {
        fclose(file);
    }
    qsort(samples, sample_count, sizeof(Sample), compare_samples);

    // Each run's samples: the range of its CPU's samples from its start to its reap.
    size_t* first = allocate(cohort.count * sizeof(size_t));
    size_t* last = allocate(cohort.count * sizeof(size_t));
    for (size_t i = 0; i < cohort.count; i += 1)
    {
        const Run* run = &cohort.runs[i];
        size_t low = 0;
        size_t high = sample_count;
        while (low < high)
        {
            const size_t middle = (low + high) / 2;
            const Sample* sample = &samples[middle];
            const bool before = sample->cpu < run->cpu || (sample->cpu == run->cpu && sample->time_ns < run->start_ns);
            low = before ? middle + 1 : low;
            high = before ? high : middle;
        }
        first[i] = low;
        size_t end = low;
        while (end < sample_count && samples[end].cpu == run->cpu && samples[end].time_ns <= run->reap_ns)
        {
            end += 1;
        }
        last[i] = end;
    }

    // The clock's start, run by run.
    const char* anchor_prefixes[3] = { "parse_", "check_input", "tier0_generate" };
    double* distances = allocate(cohort.count * sizeof(double));
    size_t distance_count = 0;
    for (size_t i = 0; i < cohort.count; i += 1)
    {
        RunStages* own = &stages[i];
        if (own->used)
        {
            const int before[3] = { preprocess_end, type_table_end, lower_end };
            int64_t estimates[3];
            int count = 0;
            for (int anchor = 0; anchor < 3; anchor += 1)
            {
                const size_t length = strlen(anchor_prefixes[anchor]);
                bool found = false;
                for (size_t s = first[i]; s < last[i] && !found && before[anchor] >= 0 && before[anchor] < own->count; s += 1)
                {
                    if (strncmp(symbols.names[samples[s].symbol], anchor_prefixes[anchor], length) == 0)
                    {
                        estimates[count] = samples[s].time_ns - own->ends[before[anchor]];
                        count += 1;
                        found = true;
                    }
                }
            }
            own->anchors = count;
            if (count > 0)
            {
                qsort(estimates, (size_t)count, sizeof(int64_t), compare_int64);
                own->clock_ns = count == 2 ? (estimates[0] + estimates[1]) / 2 : estimates[count / 2];
                own->spread_ms = (double)(estimates[count - 1] - estimates[0]) / 1e6;
                own->after_start_ms = (double)(own->clock_ns - cohort.runs[i].start_ns) / 1e6;
                distances[distance_count] = own->after_start_ms;
                distance_count += 1;
            }
        }
    }
    const double usual_distance_ms = distance_count > 0 ? median(distances, distance_count) : stages_pattern != NULL ? 0.4 : 0.0;
    for (size_t i = 0; i < cohort.count; i += 1)
    {
        RunStages* own = &stages[i];
        if (own->used && own->anchors == 0)
        {
            own->clock_ns = cohort.runs[i].start_ns + (int64_t)(usual_distance_ms * 1e6);
            own->after_start_ms = usual_distance_ms;
        }
    }

    // The sums.
    const size_t cells = (size_t)name_count * (size_t)event_count;
    double* totals = allocate(cells * sizeof(double));
    double* kernel_totals = allocate(cells * sizeof(double));
    const size_t function_cells = (size_t)name_count * (size_t)symbols.count * (size_t)event_count;
    double* by_function = functions > 0 || families_path != NULL ? allocate(function_cells * sizeof(double)) : NULL;
    uint8_t* assigned = allocate(sample_count);
    size_t used_runs = 0;
    double worst_spread = 0.0;
    int without_anchor = 0;
    for (size_t i = 0; i < cohort.count; i += 1)
    {
        const RunStages* own = &stages[i];
        const Run* run = &cohort.runs[i];
        if (own->used)
        {
            used_runs += 1;
            worst_spread = own->spread_ms > worst_spread ? own->spread_ms : worst_spread;
            without_anchor += own->anchors == 0;
            for (size_t s = first[i]; s < last[i]; s += 1)
            {
                const Sample* sample = &samples[s];
                const int64_t since = sample->time_ns - own->clock_ns;
                int stage = 1;
                if (since >= 0)
                {
                    stage = sample->time_ns <= run->exit_ns ? exit_stage : teardown_stage;
                    bool found = false;
                    for (int k = 0; k < own->count && !found; k += 1)
                    {
                        if (since < own->ends[k])
                        {
                            stage = own->stage_of[k];
                            found = true;
                        }
                    }
                }
                assigned[s] = 1;
                totals[(size_t)stage * (size_t)event_count + sample->event] += (double)sample->period;
                kernel_totals[(size_t)stage * (size_t)event_count + sample->event] += sample->kernel ? (double)sample->period : 0.0;
                if (by_function != NULL)
                {
                    by_function[((size_t)stage * symbols.count + sample->symbol) * (size_t)event_count + sample->event] += (double)sample->period;
                }
            }
        }
        else
        {
            for (size_t s = first[i]; s < last[i]; s += 1)
            {
                assigned[s] = 2;
            }
        }
    }
    for (size_t s = 0; s < sample_count; s += 1)
    {
        if (assigned[s] == 0 && (only_cpu < 0 || samples[s].cpu == only_cpu))
        {
            totals[samples[s].event] += (double)samples[s].period;
            kernel_totals[samples[s].event] += samples[s].kernel ? (double)samples[s].period : 0.0;
        }
    }
    if (used_runs == 0)
    {
        fail("buckets: no run used");
    }
    printf("# %s: %zu runs used of %zu, %.0f tokens, %zu sample lines (%zu unparsed, %zu of processes left out); the clock's start after a run's start: %.3f ms (median); the estimates' widest spread %.3f ms; %d runs without an anchor\n",
           cohort.label, used_runs, cohort.count, tokens, sample_count, unparsed, skipped_lines, usual_distance_ms, worst_spread, without_anchor);
    printf("stage");
    for (int e = 0; e < event_count; e += 1)
    {
        printf("\t%s", events[e]);
    }
    for (int e = 0; e < event_count; e += 1)
    {
        printf("\tkernel-ip:%s", events[e]);
    }
    printf("\n");
    double* sums = allocate((size_t)event_count * 2 * sizeof(double));
    for (int stage = 0; stage < name_count; stage += 1)
    {
        bool any = false;
        for (int e = 0; e < event_count; e += 1)
        {
            any = any || totals[(size_t)stage * (size_t)event_count + e] > 0.0;
        }
        if (any)
        {
            printf("%s", names[stage]);
            for (int e = 0; e < event_count; e += 1)
            {
                const double value = totals[(size_t)stage * (size_t)event_count + e] / (double)used_runs;
                printf("\t%.0f", value);
                sums[e] += stage != 0 ? value : 0.0;
            }
            for (int e = 0; e < event_count; e += 1)
            {
                const double value = kernel_totals[(size_t)stage * (size_t)event_count + e] / (double)used_runs;
                printf("\t%.0f", value);
                sums[event_count + e] += stage != 0 ? value : 0.0;
            }
            printf("\n");
        }
    }
    printf("total");
    for (int e = 0; e < event_count * 2; e += 1)
    {
        printf("\t%.0f", sums[e]);
    }
    printf("\n");
    if (functions > 0)
    {
        FunctionCount* counts = allocate(symbols.count * sizeof(FunctionCount));
        for (int stage = 1; stage < name_count; stage += 1)
        {
            double stage_lead = 0.0;
            for (uint32_t symbol = 0; symbol < symbols.count; symbol += 1)
            {
                counts[symbol].symbol = symbol;
                counts[symbol].lead = by_function[((size_t)stage * symbols.count + symbol) * (size_t)event_count];
                stage_lead += counts[symbol].lead;
            }
            if (stage_lead / (double)used_runs >= 0.004 * sums[0])
            {
                qsort(counts, symbols.count, sizeof(FunctionCount), compare_function_counts);
                printf("## functions\t%s\n", names[stage]);
                for (int k = 0; k < functions && (uint32_t)k < symbols.count && counts[k].lead > 0.0; k += 1)
                {
                    printf("%s", symbols.names[counts[k].symbol]);
                    for (int e = 0; e < event_count; e += 1)
                    {
                        printf("\t%.0f", by_function[((size_t)stage * symbols.count + counts[k].symbol) * (size_t)event_count + e] / (double)used_runs);
                    }
                    printf("\n");
                }
            }
        }
        // Every stage together, and the kernel's functions alone.
        uint8_t* in_kernel = allocate(symbols.count);
        for (size_t k = 0; k < sample_count; k += 1)
        {
            in_kernel[samples[k].symbol] |= samples[k].kernel;
        }
        for (int pass = 0; pass < 2; pass += 1)
        {
            for (uint32_t symbol = 0; symbol < symbols.count; symbol += 1)
            {
                counts[symbol].symbol = symbol;
                counts[symbol].lead = 0.0;
                for (int stage = 1; stage < name_count && (pass == 0 || in_kernel[symbol]); stage += 1)
                {
                    counts[symbol].lead += by_function[((size_t)stage * symbols.count + symbol) * (size_t)event_count];
                }
            }
            qsort(counts, symbols.count, sizeof(FunctionCount), compare_function_counts);
            printf("## functions\t%s\n", pass == 0 ? "all stages" : "all stages, the kernel's");
            for (int k = 0; k < functions * 2 && (uint32_t)k < symbols.count && counts[k].lead > 0.0; k += 1)
            {
                printf("%s", symbols.names[counts[k].symbol]);
                for (int e = 0; e < event_count; e += 1)
                {
                    double sum = 0.0;
                    for (int stage = 1; stage < name_count; stage += 1)
                    {
                        sum += by_function[((size_t)stage * symbols.count + counts[k].symbol) * (size_t)event_count + e];
                    }
                    printf("\t%.0f", sum / (double)used_runs);
                }
                printf("\n");
            }
        }
        free(in_kernel);
        free(counts);
    }
    if (families_path != NULL)
    {
        const Lines family_lines = lines_read(families_path);
        Family* families = allocate((family_lines.count + 2) * sizeof(Family));
        size_t family_count = 0;
        for (size_t i = 0; i < family_lines.count; i += 1)
        {
            char* fields[4];
            if (family_lines.items[i][0] != '#' && split_tabs(family_lines.items[i], fields, 4) >= 2)
            {
                snprintf(families[family_count].prefix, ALLCORE_NAME_BYTES, "%s", fields[0]);
                snprintf(families[family_count].name, ALLCORE_NAME_BYTES, "%s", fields[1]);
                family_count += 1;
            }
        }
        // Each symbol's family: the first prefix it starts with; otherwise `kernel` or `rest`.
        char (*family_names)[ALLCORE_NAME_BYTES] = allocate((family_count + 2) * ALLCORE_NAME_BYTES);
        size_t distinct = 0;
        uint32_t* family_of = allocate(symbols.count * sizeof(uint32_t));
        uint8_t* symbol_kernel = allocate(symbols.count);
        for (size_t s = 0; s < sample_count; s += 1)
        {
            symbol_kernel[samples[s].symbol] |= samples[s].kernel;
        }
        for (uint32_t symbol = 0; symbol < symbols.count; symbol += 1)
        {
            const char* family = symbol_kernel[symbol] ? "kernel" : "rest";
            bool found = false;
            for (size_t f = 0; f < family_count && !found; f += 1)
            {
                if (strncmp(symbols.names[symbol], families[f].prefix, strlen(families[f].prefix)) == 0)
                {
                    family = families[f].name;
                    found = true;
                }
            }
            size_t index = distinct;
            for (size_t d = 0; d < distinct; d += 1)
            {
                index = strcmp(family_names[d], family) == 0 ? d : index;
            }
            if (index == distinct)
            {
                snprintf(family_names[distinct], ALLCORE_NAME_BYTES, "%s", family);
                distinct += 1;
            }
            family_of[symbol] = (uint32_t)index;
        }
        double* family_sums = allocate(distinct * (size_t)name_count * (size_t)event_count * sizeof(double));
        for (int stage = 1; stage < name_count; stage += 1)
        {
            for (uint32_t symbol = 0; symbol < symbols.count; symbol += 1)
            {
                for (int e = 0; e < event_count; e += 1)
                {
                    family_sums[((size_t)family_of[symbol] * (size_t)name_count + (size_t)stage) * (size_t)event_count + e] +=
                        by_function[((size_t)stage * symbols.count + symbol) * (size_t)event_count + e] / (double)used_runs;
                }
            }
        }
        printf("## families\tall stages\n");
        for (size_t d = 0; d < distinct; d += 1)
        {
            printf("%s", family_names[d]);
            for (int e = 0; e < event_count; e += 1)
            {
                double sum = 0.0;
                for (int stage = 1; stage < name_count; stage += 1)
                {
                    sum += family_sums[(d * (size_t)name_count + (size_t)stage) * (size_t)event_count + e];
                }
                printf("\t%.0f", sum);
            }
            printf("\n");
        }
        printf("## families by stage\t(the first event)\n");
        printf("family");
        for (int stage = 1; stage < name_count; stage += 1)
        {
            printf("\t%s", names[stage]);
        }
        printf("\n");
        for (size_t d = 0; d < distinct; d += 1)
        {
            printf("%s", family_names[d]);
            for (int stage = 1; stage < name_count; stage += 1)
            {
                printf("\t%.0f", family_sums[(d * (size_t)name_count + (size_t)stage) * (size_t)event_count]);
            }
            printf("\n");
        }
    }
    return 0;
}

// ---------------------------------------------------------------------------------------------------------------------
// umcstages

// umcstages --rows ROWS.tsv --stages PATTERN --timeline INTERVALS.csv [--clock-ms D] [--lead-ms L]: system-wide counts an
// interval (perf stat -a -I around the cohort) divided among the stages the cohort's runs were in during the interval:
// an interval's count goes to each stage by the time the runs spent in it there, summed over the runs, so it assumes
// that the runs at work in an interval count alike. A run's stages are its own report's from its clock's start, D ms
// after its start (default 0.4, what `buckets` measures); `startup` before it, `exit` from its last stage's end to its
// status, `teardown` to its reap. perf's intervals count from its own start, taken as L ms (default 1) before the
// cohort's process read its clock. Prints each stage's count a run, and the counts of the intervals no run was in.
static int command_umcstages(int argc, char** argv)
{
    const char* rows_path = NULL;
    const char* stages_pattern = NULL;
    const char* timeline_path = NULL;
    double clock_ms = 0.4;
    double lead_ms = 1.0;
    for (int at = 2; at < argc; at += 1)
    {
        if (strcmp(argv[at], "--rows") == 0 && at + 1 < argc)
        {
            rows_path = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--stages") == 0 && at + 1 < argc)
        {
            stages_pattern = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--timeline") == 0 && at + 1 < argc)
        {
            timeline_path = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--clock-ms") == 0 && at + 1 < argc)
        {
            clock_ms = atof(argv[at + 1]);
            at += 1;
        }
        else if (strcmp(argv[at], "--lead-ms") == 0 && at + 1 < argc)
        {
            lead_ms = atof(argv[at + 1]);
            at += 1;
        }
        else
        {
            fail("umcstages: unknown option %s", argv[at]);
        }
    }
    if (rows_path == NULL || stages_pattern == NULL || timeline_path == NULL)
    {
        fail("usage: allcore umcstages --rows ROWS.tsv --stages PATTERN --timeline INTERVALS.csv [--clock-ms D] [--lead-ms L]");
    }
    const Cohort cohort = cohort_read(rows_path);
    char names[ALLCORE_MAX_STAGES + 4][40];
    snprintf(names[0], 40, "startup");
    int name_count = 1;
    typedef struct Span Span;
    struct Span
    {
        int64_t from;
        int64_t to;
        int stage;
    };
    Span* spans = allocate(cohort.count * (ALLCORE_MAX_STAGES + 3) * sizeof(Span));
    size_t span_count = 0;
    size_t* run_first = allocate((cohort.count + 1) * sizeof(size_t));
    size_t used_runs = 0;
    for (size_t i = 0; i < cohort.count; i += 1)
    {
        const Run* run = &cohort.runs[i];
        char* path = substitute(stages_pattern, run->worker, run->run);
        const StageReport report = stage_report_read(path);
        free(path);
        run_first[i] = span_count;
        if (report.found && report.count > 0 && run->status == 0)
        {
            used_runs += 1;
            const int64_t clock = run->start_ns + (int64_t)(clock_ms * 1e6);
            spans[span_count] = (Span){ run->start_ns, clock, 0 };
            span_count += 1;
            int64_t at = clock;
            for (int stage = 0; stage < report.count; stage += 1)
            {
                if (report.top[stage])
                {
                    int index = -1;
                    for (int known = 1; known < name_count; known += 1)
                    {
                        index = strcmp(names[known], report.names[stage]) == 0 ? known : index;
                    }
                    if (index < 0 && name_count < ALLCORE_MAX_STAGES + 1)
                    {
                        snprintf(names[name_count], 40, "%s", report.names[stage]);
                        index = name_count;
                        name_count += 1;
                    }
                    const int64_t end = at + (int64_t)(report.ms[stage] * 1e6);
                    spans[span_count] = (Span){ at, end, index };
                    span_count += 1;
                    at = end;
                }
            }
            // The two after the stages: their indices are fixed up below, once every stage has its name.
            spans[span_count] = (Span){ at, run->exit_ns > at ? run->exit_ns : at, -1 };
            span_count += 1;
            spans[span_count] = (Span){ run->exit_ns > at ? run->exit_ns : at, run->reap_ns, -2 };
            span_count += 1;
        }
    }
    run_first[cohort.count] = span_count;
    const int exit_stage = name_count;
    snprintf(names[exit_stage], 40, "exit");
    const int teardown_stage = name_count + 1;
    snprintf(names[teardown_stage], 40, "teardown");
    name_count += 2;
    for (size_t k = 0; k < span_count; k += 1)
    {
        spans[k].stage = spans[k].stage == -1 ? exit_stage : spans[k].stage == -2 ? teardown_stage : spans[k].stage;
    }
    if (used_runs == 0)
    {
        fail("umcstages: no run with a report");
    }
    const Lines lines = lines_read(timeline_path);
    char events[ALLCORE_MAX_EVENTS][ALLCORE_NAME_BYTES];
    int event_count = 0;
    double* sums = allocate((size_t)(name_count + 1) * ALLCORE_MAX_EVENTS * sizeof(double));
    double* weights = allocate((size_t)name_count * sizeof(double));
    const int64_t origin = cohort.plan_ns - (int64_t)(lead_ms * 1e6);
    double previous_seconds = 0.0;
    char previous_time[64] = "";
    double interval_from = 0.0;
    for (size_t i = 0; i < lines.count; i += 1)
    {
        char* fields[8];
        int count = 0;
        if (lines.items[i][0] != '#')
        {
            for (char* token = strtok(lines.items[i], ","); token != NULL && count < 8; token = strtok(NULL, ","))
            {
                fields[count] = token;
                count += 1;
            }
        }
        if (count >= 3)
        {
            if (strcmp(fields[0], previous_time) != 0)
            {
                interval_from = previous_seconds;
                previous_seconds = atof(fields[0]);
                snprintf(previous_time, sizeof(previous_time), "%s", fields[0]);
                const int64_t from = origin + (int64_t)(interval_from * 1e9);
                const int64_t to = origin + (int64_t)(previous_seconds * 1e9);
                for (int stage = 0; stage < name_count; stage += 1)
                {
                    weights[stage] = 0.0;
                }
                for (size_t k = 0; k < span_count; k += 1)
                {
                    const int64_t low = spans[k].from > from ? spans[k].from : from;
                    const int64_t high = spans[k].to < to ? spans[k].to : to;
                    weights[spans[k].stage] += high > low ? (double)(high - low) : 0.0;
                }
            }
            int event = -1;
            for (int e = 0; e < event_count; e += 1)
            {
                event = strcmp(events[e], fields[2]) == 0 ? e : event;
            }
            if (event < 0 && event_count < ALLCORE_MAX_EVENTS)
            {
                snprintf(events[event_count], ALLCORE_NAME_BYTES, "%s", fields[2]);
                event = event_count;
                event_count += 1;
            }
            double weight = 0.0;
            for (int stage = 0; stage < name_count; stage += 1)
            {
                weight += weights[stage];
            }
            const double value = atof(fields[1]);
            if (event >= 0 && weight > 0.0)
            {
                for (int stage = 0; stage < name_count; stage += 1)
                {
                    sums[(size_t)stage * ALLCORE_MAX_EVENTS + (size_t)event] += value * weights[stage] / weight;
                }
            }
            else if (event >= 0)
            {
                sums[(size_t)name_count * ALLCORE_MAX_EVENTS + (size_t)event] += value;
            }
        }
    }
    printf("# %s: %zu runs with a report of %zu; the clock's start %.3f ms after a run's, perf's %.3f ms before the cohort's\n", cohort.label, used_runs, cohort.count, clock_ms, lead_ms);
    printf("stage");
    for (int e = 0; e < event_count; e += 1)
    {
        printf("\t%s", events[e]);
    }
    printf("\n");
    double totals[ALLCORE_MAX_EVENTS] = { 0 };
    for (int stage = 0; stage < name_count; stage += 1)
    {
        bool any = false;
        for (int e = 0; e < event_count; e += 1)
        {
            any = any || sums[(size_t)stage * ALLCORE_MAX_EVENTS + (size_t)e] > 0.0;
        }
        if (any)
        {
            printf("%s", names[stage]);
            for (int e = 0; e < event_count; e += 1)
            {
                const double value = sums[(size_t)stage * ALLCORE_MAX_EVENTS + (size_t)e] / (double)used_runs;
                printf("\t%.0f", value);
                totals[e] += value;
            }
            printf("\n");
        }
    }
    printf("total");
    for (int e = 0; e < event_count; e += 1)
    {
        printf("\t%.0f", totals[e]);
    }
    printf("\nno-run-intervals");
    for (int e = 0; e < event_count; e += 1)
    {
        printf("\t%.0f", sums[(size_t)name_count * ALLCORE_MAX_EVENTS + (size_t)e]);
    }
    printf("\n");
    return 0;
}

// ---------------------------------------------------------------------------------------------------------------------
// membw

// membw --cpus CPU,CPU... --mode read|write|nt|copy [--megabytes N] [--seconds S]: the host's memory bandwidth under a
// stream, for the ceiling the compiles' traffic is read against. A worker a CPU, each with a buffer of its own of N MB
// (1,024 by default; two for copy), touched once before the cohort starts, then passed over again and again for S
// seconds (2 by default): read sums its words; write stores a changing word in each (ordinary stores: the line is read
// first); nt stores them with non-temporal stores (no read); copy reads one buffer and writes the other with ordinary
// stores. Prints each worker's bytes a second, as the loop counts them (the memory controllers' counters, around this
// command, say what the bus moved).
static int command_membw(int argc, char** argv)
{
    const char* cpus_text = NULL;
    const char* mode = NULL;
    size_t megabytes = 1024;
    double seconds = 2.0;
    for (int at = 2; at < argc; at += 1)
    {
        if (strcmp(argv[at], "--cpus") == 0 && at + 1 < argc)
        {
            cpus_text = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--mode") == 0 && at + 1 < argc)
        {
            mode = argv[at + 1];
            at += 1;
        }
        else if (strcmp(argv[at], "--megabytes") == 0 && at + 1 < argc)
        {
            megabytes = (size_t)atoll(argv[at + 1]);
            at += 1;
        }
        else if (strcmp(argv[at], "--seconds") == 0 && at + 1 < argc)
        {
            seconds = atof(argv[at + 1]);
            at += 1;
        }
        else
        {
            fail("membw: unknown option %s", argv[at]);
        }
    }
    const int kind = mode == NULL ? -1 : strcmp(mode, "read") == 0 ? 0 : strcmp(mode, "write") == 0 ? 1 : strcmp(mode, "nt") == 0 ? 2 : strcmp(mode, "copy") == 0 ? 3 : -1;
    if (cpus_text == NULL || kind < 0 || megabytes == 0 || seconds <= 0.0)
    {
        fail("usage: allcore membw --cpus CPU,CPU... --mode read|write|nt|copy [--megabytes N] [--seconds S]");
    }
    int cpus[ALLCORE_MAX_WORKERS];
    cpu_set_t* sets = allocate(ALLCORE_MAX_WORKERS * sizeof(cpu_set_t));
    const int workers = parse_cpus(cpus_text, cpus, sets);
    double* rates = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    int64_t* gate = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    if (rates == MAP_FAILED || gate == MAP_FAILED)
    {
        fail("membw: no memory");
    }
    const size_t bytes = megabytes << 20;
    const size_t words = bytes / 8;
    pid_t pids[ALLCORE_MAX_WORKERS];
    for (int worker = 0; worker < workers; worker += 1)
    {
        pids[worker] = fork();
        if (pids[worker] == 0)
        {
            if (sched_setaffinity(0, sizeof(cpu_set_t), &sets[worker]) != 0)
            {
                _exit(3);
            }
            uint64_t* first = mmap(NULL, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
            uint64_t* second = kind == 3 ? mmap(NULL, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0) : first;
            if (first == MAP_FAILED || second == MAP_FAILED)
            {
                _exit(4);
            }
            madvise(first, bytes, MADV_HUGEPAGE);
            madvise(second, bytes, MADV_HUGEPAGE);
            for (size_t i = 0; i < words; i += 512)
            {
                first[i] = i;
                second[i] = i + 1;
            }
            __atomic_add_fetch(&gate[1], 1, __ATOMIC_SEQ_CST);
            while (__atomic_load_n(&gate[0], __ATOMIC_ACQUIRE) == 0)
            {
            }
            const int64_t start = now_ns();
            const int64_t end = start + (int64_t)(seconds * 1e9);
            uint64_t passes = 0;
            uint64_t sum = 0;
            int64_t now = start;
            while (now < end)
            {
                if (kind == 0)
                {
                    for (size_t i = 0; i < words; i += 1)
                    {
                        sum += first[i];
                    }
                }
                else if (kind == 1)
                {
                    for (size_t i = 0; i < words; i += 1)
                    {
                        first[i] = i ^ passes;
                    }
                }
                else if (kind == 2)
                {
                    for (size_t i = 0; i < words; i += 1)
                    {
                        __builtin_ia32_movnti64((long long*)&first[i], (long long)(i ^ passes));
                    }
                    __builtin_ia32_sfence();
                }
                else
                {
                    for (size_t i = 0; i < words; i += 1)
                    {
                        second[i] = first[i] + passes;
                    }
                }
                passes += 1;
                // The sum is kept alive so that the read loop isn't removed.
                __asm__ volatile("" : : "r"(sum) : "memory");
                now = now_ns();
            }
            rates[worker] = (double)passes * (double)bytes * (kind == 3 ? 2.0 : 1.0) / ((double)(now - start) / 1e9);
            _exit(0);
        }
    }
    while (__atomic_load_n(&gate[1], __ATOMIC_ACQUIRE) < workers)
    {
        usleep(1000);
    }
    __atomic_store_n(&gate[0], 1, __ATOMIC_RELEASE);
    int result = 0;
    for (int worker = 0; worker < workers; worker += 1)
    {
        int status = 0;
        if (waitpid(pids[worker], &status, 0) != pids[worker] || !WIFEXITED(status) || WEXITSTATUS(status) != 0)
        {
            result = 1;
        }
    }
    double total = 0.0;
    printf("mode\tworkers\tmegabytes\tseconds\tcpu\tlogical_gb_per_s\n");
    for (int worker = 0; worker < workers; worker += 1)
    {
        printf("%s\t%d\t%zu\t%.1f\t%d\t%.3f\n", mode, workers, megabytes, seconds, cpus[worker], rates[worker] / 1e9);
        total += rates[worker];
    }
    printf("%s\t%d\t%zu\t%.1f\tall\t%.3f\n", mode, workers, megabytes, seconds, total / 1e9);
    return result;
}

// ---------------------------------------------------------------------------------------------------------------------
// spine

// The length of the token at `at` in preprocessed C text, and whether it is space or a line that starts with '#'.
static size_t spine_token(const char* at, const char* end, bool line_start, bool* blank)
{
    const char* cursor = at;
    *blank = false;
    if (isspace((unsigned char)*cursor))
    {
        *blank = true;
        while (cursor < end && isspace((unsigned char)*cursor))
        {
            cursor += 1;
        }
    }
    else if (*cursor == '#' && line_start)
    {
        *blank = true;
        while (cursor < end && *cursor != '\n')
        {
            cursor += 1;
        }
    }
    else if (*cursor == '"' || *cursor == '\'' ||
             ((*cursor == 'u' || *cursor == 'U' || *cursor == 'L') && cursor + 1 < end && (cursor[1] == '"' || cursor[1] == '\'')) ||
             (*cursor == 'u' && cursor + 2 < end && cursor[1] == '8' && (cursor[2] == '"' || cursor[2] == '\'')))
    {
        while (*cursor != '"' && *cursor != '\'')
        {
            cursor += 1;
        }
        const char quote = *cursor;
        cursor += 1;
        while (cursor < end && *cursor != quote && *cursor != '\n')
        {
            cursor += *cursor == '\\' && cursor + 1 < end ? 2 : 1;
        }
        cursor += cursor < end && *cursor == quote ? 1 : 0;
    }
    else if (isdigit((unsigned char)*cursor) || (*cursor == '.' && cursor + 1 < end && isdigit((unsigned char)cursor[1])))
    {
        cursor += 1;
        bool more = true;
        while (cursor < end && more)
        {
            if ((*cursor == 'e' || *cursor == 'E' || *cursor == 'p' || *cursor == 'P') && cursor + 1 < end && (cursor[1] == '+' || cursor[1] == '-'))
            {
                cursor += 2;
            }
            else if (isalnum((unsigned char)*cursor) || *cursor == '_' || *cursor == '.')
            {
                cursor += 1;
            }
            else
            {
                more = false;
            }
        }
    }
    else if (isalpha((unsigned char)*cursor) || *cursor == '_' || *cursor == '$')
    {
        while (cursor < end && (isalnum((unsigned char)*cursor) || *cursor == '_' || *cursor == '$'))
        {
            cursor += 1;
        }
    }
    else
    {
        static const char* const punctuators[] = { "...", "<<=", ">>=", "->", "++", "--", "<<", ">>", "<=", ">=", "==", "!=", "&&", "||", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "##" };
        size_t length = 1;
        for (size_t i = 0; i < sizeof(punctuators) / sizeof(punctuators[0]); i += 1)
        {
            const size_t own = strlen(punctuators[i]);
            if (own > length && (size_t)(end - cursor) >= own && strncmp(cursor, punctuators[i], own) == 0)
            {
                length = own;
            }
        }
        cursor += length;
    }
    return (size_t)(cursor - at);
}

// spine IN.i OUT.i [--keep FROM TO]: a preprocessed unit without its function bodies: each file-scope `{` that follows a
// `)` is replaced, to its matching `}`, by `;`, which turns the definition into a declaration. With --keep, the bodies
// whose first token is body token FROM or later and before TO (counted over the bodies' tokens alone, in source order)
// stay as they are. Everything else is copied byte for byte. It is the one-core record's spine.py, in C, with --keep.
static int command_spine(int argc, char** argv)
{
    if (argc != 4 && !(argc == 7 && strcmp(argv[4], "--keep") == 0))
    {
        fail("usage: allcore spine IN.i OUT.i [--keep FROM TO]");
    }
    const long long keep_from = argc == 7 ? atoll(argv[5]) : 0;
    const long long keep_to = argc == 7 ? atoll(argv[6]) : 0;
    FILE* in = fopen(argv[2], "rb");
    if (in == NULL)
    {
        fail("spine: can't read %s", argv[2]);
    }
    fseek(in, 0, SEEK_END);
    const long size = ftell(in);
    fseek(in, 0, SEEK_SET);
    char* text = allocate((size_t)size + 1);
    if (fread(text, 1, (size_t)size, in) != (size_t)size)
    {
        fail("spine: short read of %s", argv[2]);
    }
    fclose(in);
    FILE* out = fopen(argv[3], "wb");
    if (out == NULL)
    {
        fail("spine: can't write %s", argv[3]);
    }
    const char* end = text + size;
    const char* at = text;
    long depth = 0;
    bool in_body = false;
    bool skipping = false;
    bool previous_close = false;
    bool line_start = true;
    long long bodies = 0;
    long long kept_bodies = 0;
    long long body_tokens = 0;
    long long dropped = 0;
    long long kept = 0;
    while (at < end)
    {
        bool blank = false;
        const size_t length = spine_token(at, end, line_start, &blank);
        if (blank)
        {
            if (!skipping)
            {
                fwrite(at, 1, length, out);
            }
            for (size_t i = 0; i < length; i += 1)
            {
                line_start = at[i] == '\n' ? true : (isspace((unsigned char)at[i]) ? line_start : false);
            }
        }
        else
        {
            line_start = false;
            const bool open = length == 1 && *at == '{';
            const bool close = length == 1 && *at == '}';
            if (open && depth == 0 && previous_close)
            {
                in_body = true;
                bodies += 1;
                skipping = !(body_tokens >= keep_from && body_tokens < keep_to);
                kept_bodies += skipping ? 0 : 1;
                if (skipping)
                {
                    fputc(';', out);
                }
            }
            depth += open ? 1 : close ? -1 : 0;
            body_tokens += in_body ? 1 : 0;
            if (skipping)
            {
                dropped += 1;
            }
            else
            {
                fwrite(at, 1, length, out);
                kept += 1;
            }
            if (close && depth == 0 && in_body)
            {
                in_body = false;
                skipping = false;
            }
            previous_close = length == 1 && *at == ')';
        }
        at += length;
    }
    fclose(out);
    printf("%lld bodies of %lld body tokens: %lld kept, %lld dropped with %lld tokens of %lld; %lld tokens written (a `;` for each dropped body)\n", bodies, body_tokens, kept_bodies,
           bodies - kept_bodies, dropped, kept + dropped, kept + bodies - kept_bodies);
    return 0;
}

int main(int argc, char** argv)
{
    int result = 2;
    const char* command = argc > 1 ? argv[1] : "";
    if (strcmp(command, "cohort") == 0)
    {
        result = command_cohort(argc, argv);
    }
    else if (strcmp(command, "rows") == 0)
    {
        result = command_rows(argc, argv);
    }
    else if (strcmp(command, "stages") == 0)
    {
        result = command_stages(argc, argv);
    }
    else if (strcmp(command, "stat") == 0)
    {
        result = command_stat(argc, argv);
    }
    else if (strcmp(command, "timeline") == 0)
    {
        result = command_timeline(argc, argv);
    }
    else if (strcmp(command, "buckets") == 0)
    {
        result = command_buckets(argc, argv);
    }
    else if (strcmp(command, "umcstages") == 0)
    {
        result = command_umcstages(argc, argv);
    }
    else if (strcmp(command, "membw") == 0)
    {
        result = command_membw(argc, argv);
    }
    else if (strcmp(command, "spine") == 0)
    {
        result = command_spine(argc, argv);
    }
    else
    {
        fprintf(stderr, "usage: allcore cohort|rows|stages|stat|timeline|buckets|umcstages|membw|spine ...\n");
    }
    return result;
}
