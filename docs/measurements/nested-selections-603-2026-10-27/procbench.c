// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// procbench: whole processes run in rotated rounds, each run's own measurements kept (buster14a/buster#445 and #446).
//
//   procbench [--rounds N] [--first N] [--no-header] [--out DIR] LIST
//
// LIST holds one command per line, `LABEL|OPTIONS|ARGUMENT...`, the arguments separated by single spaces, and comments
// (#) and blank lines. OPTIONS is a comma-separated list of:
//   runs=N       runs per round (1), each recorded;
//   warmups=N    runs per round before them, recorded as warm-ups (0);
//   pause=MS     milliseconds to sleep before every run (0);
//   cpu=N        the child pinned to CPU N (inherits the harness's CPUs otherwise);
//   norandom     the child without address space randomization (personality ADDR_NO_RANDOMIZE, as setarch -R);
//   pad=N        an environment variable of N bytes added to the child's environment, which moves its initial stack;
//   sample=MS    /proc/PID/smaps_rollup and /proc/PID/stat read MS milliseconds after the child starts;
//   capture      the child's standard output and errors kept in DIR/round-label-run.out and .err (else /dev/null);
//   events=A:B   the counters, each `cycles`, `instructions`, `task-clock`, `context-switches`, `cpu-migrations`,
//                `page-faults`, or `rHEX` (a raw PMU config); counted for the child and every thread it starts, from
//                its exec to its exit (enable_on_exec, inherit), as perf stat counts them.
// Round r (from --first, 1 by default) runs the commands in the list's order rotated by r - 1, each command's warm-ups and runs together. Every run is a
// line of standard output (tab-separated, a header first): round, command, label, run, warm-up, exit status, wall
// nanoseconds from the release of the child (which then execs) to wait4's return, user and system microseconds, minor
// and major faults, voluntary and involuntary context switches, peak resident KB, the sample's AnonHugePages and Rss KB
// and the initial stack's address (startstack, -1 without a sample), then each counter's value, with `*` after it when
// the kernel multiplexed it (time running below time enabled).

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <linux/perf_event.h>
#include <sched.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/personality.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PROCBENCH_COMMANDS 64
#define PROCBENCH_ARGUMENTS 1024
#define PROCBENCH_EVENTS 8
#define PROCBENCH_LINE_BYTES 65536
#define PROCBENCH_ENVIRONMENT 4096

extern char** environ;

typedef struct ProcbenchEvent ProcbenchEvent;
struct ProcbenchEvent
{
    char name[32];
    uint32_t type;
    uint64_t config;
};

typedef struct ProcbenchCommand ProcbenchCommand;
struct ProcbenchCommand
{
    char label[128];
    char* arguments[PROCBENCH_ARGUMENTS];
    uint32_t runs;
    uint32_t warmups;
    uint32_t pause;
    int cpu;
    bool norandom;
    uint32_t pad;
    uint32_t sample;
    bool capture;
    ProcbenchEvent events[PROCBENCH_EVENTS];
    uint32_t event_count;
};

typedef struct ProcbenchResult ProcbenchResult;
struct ProcbenchResult
{
    int status;
    uint64_t wall;
    struct rusage usage;
    int64_t huge_kb;
    int64_t rss_kb;
    int64_t start_stack;
    uint64_t values[PROCBENCH_EVENTS];
    bool multiplexed[PROCBENCH_EVENTS];
};

static uint64_t procbench_now(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC_RAW, &now);
    return (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec;
}

static void procbench_sleep(uint32_t milliseconds)
{
    const struct timespec pause = {
        .tv_sec = milliseconds / 1000,
        .tv_nsec = (long)(milliseconds % 1000) * 1000000,
    };
    nanosleep(&pause, 0);
}

static bool procbench_event(ProcbenchEvent* event, const char* name)
{
    static const struct
    {
        const char* name;
        uint32_t type;
        uint64_t config;
    } known[] = {
        { "cycles", PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES },
        { "instructions", PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS },
        { "task-clock", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK },
        { "context-switches", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES },
        { "cpu-migrations", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS },
        { "page-faults", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS },
    };
    bool result = strlen(name) < sizeof(event->name);
    if (result)
    {
        snprintf(event->name, sizeof(event->name), "%s", name);
        result = false;
        for (uint32_t i = 0; !result && i < sizeof(known) / sizeof(known[0]); i += 1)
        {
            result = strcmp(name, known[i].name) == 0;
            event->type = known[i].type;
            event->config = known[i].config;
        }
        if (!result && name[0] == 'r' && name[1] != 0)
        {
            char* end = 0;
            event->type = PERF_TYPE_RAW;
            event->config = strtoull(name + 1, &end, 16);
            result = *end == 0;
        }
    }
    return result;
}

// Parses `options` (modified) into `command`. False, naming the option, if one isn't known.
static bool procbench_options(ProcbenchCommand* command, char* options)
{
    bool result = true;
    command->runs = 1;
    command->cpu = -1;
    for (char* option = strtok(options, ","); result && option != 0; option = strtok(0, ","))
    {
        char* value = strchr(option, '=');
        if (value != 0)
        {
            *value = 0;
            value += 1;
        }
        if (strcmp(option, "runs") == 0 && value != 0)
        {
            command->runs = (uint32_t)strtoul(value, 0, 10);
        }
        else if (strcmp(option, "warmups") == 0 && value != 0)
        {
            command->warmups = (uint32_t)strtoul(value, 0, 10);
        }
        else if (strcmp(option, "pause") == 0 && value != 0)
        {
            command->pause = (uint32_t)strtoul(value, 0, 10);
        }
        else if (strcmp(option, "cpu") == 0 && value != 0)
        {
            command->cpu = (int)strtol(value, 0, 10);
        }
        else if (strcmp(option, "norandom") == 0 && value == 0)
        {
            command->norandom = true;
        }
        else if (strcmp(option, "pad") == 0 && value != 0)
        {
            command->pad = (uint32_t)strtoul(value, 0, 10);
            result = command->pad < PROCBENCH_LINE_BYTES;
        }
        else if (strcmp(option, "sample") == 0 && value != 0)
        {
            command->sample = (uint32_t)strtoul(value, 0, 10);
        }
        else if (strcmp(option, "capture") == 0 && value == 0)
        {
            command->capture = true;
        }
        else if (strcmp(option, "events") == 0 && value != 0)
        {
            for (char* name = value; result && name != 0 && *name != 0;)
            {
                char* next = strchr(name, ':');
                if (next != 0)
                {
                    *next = 0;
                    next += 1;
                }
                result = command->event_count < PROCBENCH_EVENTS && procbench_event(&command->events[command->event_count], name);
                command->event_count += result ? 1 : 0;
                name = next;
            }
        }
        else
        {
            result = false;
        }
        if (!result)
        {
            fprintf(stderr, "procbench: unknown option or value: %s\n", option);
        }
    }
    return result;
}

// Reads LIST into `commands`: how many, or -1 on an error, which it names.
static int procbench_read_list(const char* path, ProcbenchCommand* commands)
{
    FILE* file = fopen(path, "r");
    int count = file != 0 ? 0 : -1;
    if (file == 0)
    {
        fprintf(stderr, "procbench: can't read %s: %s\n", path, strerror(errno));
    }
    static char lines[PROCBENCH_COMMANDS][PROCBENCH_LINE_BYTES];
    while (count >= 0 && count < PROCBENCH_COMMANDS && fgets(lines[count], PROCBENCH_LINE_BYTES, file) != 0)
    {
        char* line = lines[count];
        line[strcspn(line, "\n")] = 0;
        if (line[0] == 0 || line[0] == '#')
        {
            continue;
        }
        char* label = line;
        char* options = strchr(label, '|');
        char* arguments = options != 0 ? strchr(options + 1, '|') : 0;
        ProcbenchCommand* command = &commands[count];
        *command = (ProcbenchCommand){ 0 };
        bool valid = options != 0 && arguments != 0 && (uint64_t)(options - label) < sizeof(command->label);
        if (valid)
        {
            *options = 0;
            *arguments = 0;
            snprintf(command->label, sizeof(command->label), "%s", label);
            valid = procbench_options(command, options + 1);
            uint32_t argument_count = 0;
            for (char* argument = strtok(arguments + 1, " "); valid && argument != 0; argument = strtok(0, " "))
            {
                valid = argument_count + 1 < PROCBENCH_ARGUMENTS;
                command->arguments[argument_count] = argument;
                argument_count += valid ? 1 : 0;
            }
            valid = valid && argument_count != 0;
        }
        if (!valid)
        {
            fprintf(stderr, "procbench: invalid command: %s\n", line);
            count = -1;
        }
        else
        {
            count += 1;
        }
    }
    if (file != 0)
    {
        fclose(file);
    }
    return count;
}

// /proc/PID/smaps_rollup's AnonHugePages and Rss, and /proc/PID/stat's startstack (field 28).
static void procbench_sample(pid_t child, ProcbenchResult* result)
{
    char path[64];
    char text[8192];
    snprintf(path, sizeof(path), "/proc/%d/smaps_rollup", (int)child);
    int file = open(path, O_RDONLY | O_CLOEXEC);
    ssize_t length = file >= 0 ? read(file, text, sizeof(text) - 1) : -1;
    if (file >= 0)
    {
        close(file);
    }
    text[length > 0 ? length : 0] = 0;
    const char* huge = strstr(text, "AnonHugePages:");
    const char* rss = strstr(text, "Rss:");
    result->huge_kb = huge != 0 ? strtoll(huge + strlen("AnonHugePages:"), 0, 10) : -1;
    result->rss_kb = rss != 0 ? strtoll(rss + strlen("Rss:"), 0, 10) : -1;
    snprintf(path, sizeof(path), "/proc/%d/stat", (int)child);
    file = open(path, O_RDONLY | O_CLOEXEC);
    length = file >= 0 ? read(file, text, sizeof(text) - 1) : -1;
    if (file >= 0)
    {
        close(file);
    }
    text[length > 0 ? length : 0] = 0;
    // The fields after the command's name, which ends at the last ')': state is field 3, startstack field 28.
    const char* after = strrchr(text, ')');
    result->start_stack = -1;
    if (after != 0)
    {
        const char* field = after + 2;
        for (uint32_t f = 3; field != 0 && f < 28; f += 1)
        {
            field = strchr(field, ' ');
            field = field != 0 ? field + 1 : 0;
        }
        result->start_stack = field != 0 ? strtoll(field, 0, 10) : -1;
    }
}

static int procbench_open_event(const ProcbenchEvent* event, pid_t child)
{
    struct perf_event_attr attribute = { 0 };
    attribute.size = sizeof(attribute);
    attribute.type = event->type;
    attribute.config = event->config;
    attribute.disabled = 1;
    attribute.enable_on_exec = 1;
    attribute.inherit = 1;
    attribute.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING;
    return (int)syscall(SYS_perf_event_open, &attribute, child, -1, -1, PERF_FLAG_FD_CLOEXEC);
}

// One run of `command`: false if it couldn't start or be measured, which it says.
static bool procbench_run(const ProcbenchCommand* command, const char* out, uint32_t round, uint32_t run, ProcbenchResult* result)
{
    char output_path[4096];
    char error_path[4096];
    if (command->capture)
    {
        snprintf(output_path, sizeof(output_path), "%s/%u-%s-%u.out", out, round, command->label, run);
        snprintf(error_path, sizeof(error_path), "%s/%u-%s-%u.err", out, round, command->label, run);
    }
    else
    {
        snprintf(output_path, sizeof(output_path), "/dev/null");
        snprintf(error_path, sizeof(error_path), "/dev/null");
    }
    // The environment: the harness's, and the pad.
    static char* environment[PROCBENCH_ENVIRONMENT];
    static char pad[PROCBENCH_LINE_BYTES + 32];
    uint32_t count = 0;
    for (char** variable = environ; *variable != 0 && count + 2 < PROCBENCH_ENVIRONMENT; variable += 1)
    {
        environment[count++] = *variable;
    }
    if (command->pad != 0)
    {
        memcpy(pad, "PROCBENCH_PAD=", 14);
        memset(pad + 14, 'x', command->pad);
        pad[14 + command->pad] = 0;
        environment[count++] = pad;
    }
    environment[count] = 0;
    int release[2];
    bool started = pipe2(release, O_CLOEXEC) == 0;
    const pid_t child = started ? fork() : -1;
    if (child == 0)
    {
        char byte;
        close(release[1]);
        const int output = open(output_path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
        const int errors = open(error_path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
        bool ready = output >= 0 && errors >= 0 && dup2(output, 1) == 1 && dup2(errors, 2) == 2;
        if (ready && command->cpu >= 0)
        {
            cpu_set_t cpus;
            CPU_ZERO(&cpus);
            CPU_SET(command->cpu, &cpus);
            ready = sched_setaffinity(0, sizeof(cpus), &cpus) == 0;
        }
        if (ready && command->norandom)
        {
            ready = personality(ADDR_NO_RANDOMIZE) != -1;
        }
        // Wait until the parent's counters are open.
        ready = ready && read(release[0], &byte, 1) == 1;
        if (ready)
        {
            execve(command->arguments[0], command->arguments, environment);
        }
        _exit(127);
    }
    started = child > 0;
    int events[PROCBENCH_EVENTS];
    for (uint32_t e = 0; e < command->event_count; e += 1)
    {
        events[e] = started ? procbench_open_event(&command->events[e], child) : -1;
        if (started && events[e] < 0)
        {
            fprintf(stderr, "procbench: perf_event_open of %s: %s\n", command->events[e].name, strerror(errno));
            started = false;
        }
    }
    if (child > 0)
    {
        close(release[0]);
    }
    const uint64_t start = procbench_now();
    if (started)
    {
        started = write(release[1], "x", 1) == 1;
    }
    if (child > 0)
    {
        close(release[1]);
    }
    result->huge_kb = -1;
    result->rss_kb = -1;
    result->start_stack = -1;
    if (started && command->sample != 0)
    {
        procbench_sleep(command->sample);
        procbench_sample(child, result);
    }
    int status = 0;
    const pid_t waited = child > 0 ? wait4(child, &status, 0, &result->usage) : -1;
    const uint64_t end = procbench_now();
    result->wall = end - start;
    result->status = waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    for (uint32_t e = 0; e < command->event_count; e += 1)
    {
        uint64_t values[3] = { 0 };
        const bool read_all = events[e] >= 0 && read(events[e], values, sizeof(values)) == (ssize_t)sizeof(values);
        result->values[e] = read_all ? values[0] : 0;
        result->multiplexed[e] = read_all && values[2] < values[1];
        if (events[e] >= 0)
        {
            close(events[e]);
        }
    }
    (void)run;
    return started && waited == child;
}

int main(int argc, char** argv)
{
    uint32_t rounds = 1;
    uint32_t first = 1;
    bool header = true;
    const char* out = ".";
    const char* list = 0;
    bool valid = true;
    for (int i = 1; valid && i < argc; i += 1)
    {
        if (strcmp(argv[i], "--rounds") == 0 && i + 1 < argc)
        {
            rounds = (uint32_t)strtoul(argv[++i], 0, 10);
        }
        else if (strcmp(argv[i], "--first") == 0 && i + 1 < argc)
        {
            first = (uint32_t)strtoul(argv[++i], 0, 10);
            valid = first != 0;
        }
        else if (strcmp(argv[i], "--no-header") == 0)
        {
            header = false;
        }
        else if (strcmp(argv[i], "--out") == 0 && i + 1 < argc)
        {
            out = argv[++i];
        }
        else if (list == 0 && argv[i][0] != '-')
        {
            list = argv[i];
        }
        else
        {
            valid = false;
        }
    }
    static ProcbenchCommand commands[PROCBENCH_COMMANDS];
    const int count = valid && list != 0 ? procbench_read_list(list, commands) : -1;
    if (!valid || list == 0)
    {
        fprintf(stderr, "usage: procbench [--rounds N] [--first N] [--no-header] [--out DIR] LIST\n");
    }
    bool succeeded = count > 0;
    if (succeeded && header)
    {
        printf("round\tcommand\tlabel\trun\twarmup\tstatus\twall_ns\tuser_us\tsys_us\tminflt\tmajflt\tnvcsw\tnivcsw\tmaxrss_kb\thuge_kb\trss_kb\tstart_stack\tcounters\n");
        fflush(stdout);
    }
    for (uint32_t round = first - 1; succeeded && round < first - 1 + rounds; round += 1)
    {
        for (int i = 0; succeeded && i < count; i += 1)
        {
            const int c = (i + (int)(round % (uint32_t)count)) % count;
            const ProcbenchCommand* command = &commands[c];
            for (uint32_t run = 0; succeeded && run < command->warmups + command->runs; run += 1)
            {
                procbench_sleep(command->pause);
                ProcbenchResult result = { 0 };
                succeeded = procbench_run(command, out, round + 1, run, &result);
                const struct rusage* usage = &result.usage;
                printf("%u\t%d\t%s\t%u\t%d\t%d\t%" PRIu64 "\t%lld\t%lld\t%ld\t%ld\t%ld\t%ld\t%ld\t%lld\t%lld\t%lld", round + 1, c, command->label, run,
                       run < command->warmups ? 1 : 0, result.status, result.wall, (long long)usage->ru_utime.tv_sec * 1000000 + usage->ru_utime.tv_usec,
                       (long long)usage->ru_stime.tv_sec * 1000000 + usage->ru_stime.tv_usec, usage->ru_minflt, usage->ru_majflt, usage->ru_nvcsw, usage->ru_nivcsw,
                       usage->ru_maxrss, (long long)result.huge_kb, (long long)result.rss_kb, (long long)result.start_stack);
                for (uint32_t e = 0; e < command->event_count; e += 1)
                {
                    printf("\t%s=%" PRIu64 "%s", command->events[e].name, result.values[e], result.multiplexed[e] ? "*" : "");
                }
                printf("\n");
                fflush(stdout);
            }
        }
    }
    return succeeded ? 0 : 1;
}
