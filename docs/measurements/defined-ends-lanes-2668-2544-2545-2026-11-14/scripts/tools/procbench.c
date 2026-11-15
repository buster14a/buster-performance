// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// procbench: a build's steps run as whole processes in rotated rounds, each run's own measurements kept. This is the
// record's version of buster-performance's docs/measurements/link-foreign-lanes-594-2026-10-27/procbench.c
// (buster14a/buster#445, #446, #501, #594), changed for buster14a/buster#672's whole builds:
//
// - a line holds one command or several, separated by ` ;; `, which run one after another as a build's steps do; the
//   first that fails ends the line's run;
// - the harness is a child subreaper: what a command leaves behind as it exits (the driver's exit helper,
//   buster14a/buster#1444, which tears the address space down after its caller has gone; mold's and wild's workers,
//   which their parent doesn't wait for) is reparented to the harness, waited for after the line's last command, and
//   its time and resource use recorded apart (`late`), so that a step's wall time and the time until its work has
//   really ended are both known;
// - the counters split by privilege (`cycles-u`, `cycles-k`, `instructions-u`, `instructions-k`), are read after
//   everything a line started has gone, and are a line's sum over its commands;
// - `cpus=LIST` pins a line's commands to several CPUs, `dir=PATH` runs them there, and `var=` may be given 8 times.
// It drops the 594 version's `norandom`, `pad` and `sample`, which nothing here uses.
//
//   procbench [--rounds N] [--first N] [--no-header] [--out DIR] LIST
//
// LIST holds one line per measurement, `LABEL|OPTIONS|ARGUMENT... [;; ARGUMENT...]...`, the arguments separated by
// single spaces, and comments (#) and blank lines. OPTIONS is a comma-separated list of:
//   runs=N       runs per round (1), each recorded;
//   warmups=N    runs per round before them, recorded as warm-ups (0);
//   pause=MS     milliseconds to sleep before every run (0);
//   cpus=LIST    the commands pinned to these CPUs, `2`, `0-7` or `2+0+1` (they inherit the harness's otherwise);
//   dir=PATH     the commands' working directory;
//   capture      each command's standard output and errors kept in DIR/ROUND-LABEL-RUN.K.out and .err, K the
//                command's place in its line from 0 (else /dev/null);
//   var=NAME=V   NAME=V in the commands' environment, in place of the harness's NAME if it has one;
//   events=A+B   the counters, each `cycles`, `instructions`, `task-clock`, `context-switches`, `cpu-migrations`,
//                `page-faults`, one of the first two with `-u` or `-k` (user or kernel mode alone), or `rHEX` (a raw
//                PMU config); counted for each command and everything it starts, from its exec (enable_on_exec,
//                inherit), as perf stat counts them.
// Round r (from --first, 1 by default) runs the lines in the list's order rotated by r - 1, each line's warm-ups and
// runs together. Every run is a line of standard output (tab-separated, a header first):
//   round, line, label, run, warm-up, exit status (the first failing command's, else 0);
//   wall_ns     the sum over the line's commands of the nanoseconds from the command's release (it then execs) to
//               its wait4's return: what a build tool waits for;
//   span_ns     from the first command's release to the last one's wait4's return, the harness's own work between
//               commands (a fork and the counters' opening) included;
//   settle_ns   from the first command's release until no process the line started is left;
//   user_us, sys_us, minflt, majflt, nvcsw, nivcsw: the commands' wait4 resource use, summed; maxrss_kb their largest;
//   late_user_us, late_sys_us, late_minflt, late_count: the same of the processes reaped after their commands, and
//               how many there were;
//   then each counter's value, with `*` after it when the kernel multiplexed it (time running below time enabled).

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
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PROCBENCH_LINES 128
#define PROCBENCH_ARGUMENTS 4096
#define PROCBENCH_STEPS 8
#define PROCBENCH_EVENTS 8
#define PROCBENCH_VARIABLES 8
#define PROCBENCH_LINE_BYTES 262144
#define PROCBENCH_ENVIRONMENT 4096

extern char** environ;

typedef struct ProcbenchEvent ProcbenchEvent;
struct ProcbenchEvent
{
    char name[32];
    uint32_t type;
    uint64_t config;
    bool exclude_user;
    bool exclude_kernel;
};

// A line of the list: its commands (step s is arguments[starts[s]] to the null after it) and its options.
typedef struct ProcbenchLine ProcbenchLine;
struct ProcbenchLine
{
    char label[128];
    char* arguments[PROCBENCH_ARGUMENTS];
    uint32_t starts[PROCBENCH_STEPS];
    uint32_t step_count;
    uint32_t runs;
    uint32_t warmups;
    uint32_t pause;
    cpu_set_t cpus;
    bool pinned;
    const char* directory;
    const char* variables[PROCBENCH_VARIABLES];
    uint32_t variable_count;
    bool capture;
    ProcbenchEvent events[PROCBENCH_EVENTS];
    uint32_t event_count;
};

typedef struct ProcbenchResult ProcbenchResult;
struct ProcbenchResult
{
    int status;
    uint64_t wall;
    uint64_t span;
    uint64_t settle;
    uint64_t user_us;
    uint64_t system_us;
    uint64_t minor_faults;
    uint64_t major_faults;
    uint64_t voluntary;
    uint64_t involuntary;
    uint64_t peak_kb;
    uint64_t late_user_us;
    uint64_t late_system_us;
    uint64_t late_minor_faults;
    uint64_t late_count;
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

static uint64_t procbench_microseconds(const struct timeval* time)
{
    return (uint64_t)time->tv_sec * 1000000ull + (uint64_t)time->tv_usec;
}

static bool procbench_event(ProcbenchEvent* event, const char* name)
{
    static const struct
    {
        const char* name;
        uint32_t type;
        uint64_t config;
        bool exclude_user;
        bool exclude_kernel;
    } known[] = {
        { "cycles", PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, false, false },
        { "cycles-u", PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, false, true },
        { "cycles-k", PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, true, false },
        { "instructions", PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS, false, false },
        { "instructions-u", PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS, false, true },
        { "instructions-k", PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS, true, false },
        { "task-clock", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK, false, false },
        { "context-switches", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CONTEXT_SWITCHES, false, false },
        { "cpu-migrations", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_MIGRATIONS, false, false },
        { "page-faults", PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS, false, false },
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
            event->exclude_user = known[i].exclude_user;
            event->exclude_kernel = known[i].exclude_kernel;
        }
        if (!result && name[0] == 'r' && name[1] != 0)
        {
            char* end = 0;
            event->type = PERF_TYPE_RAW;
            event->config = strtoull(name + 1, &end, 16);
            event->exclude_user = false;
            event->exclude_kernel = false;
            result = *end == 0;
        }
    }
    return result;
}

// `list`, as `2`, `0-7` or `2+0+1`, into `cpus`. False if it isn't one.
static bool procbench_cpus(cpu_set_t* cpus, char* list)
{
    bool result = list[0] != 0;
    CPU_ZERO(cpus);
    for (char* part = list; result && part != 0 && *part != 0;)
    {
        char* next = strchr(part, '+');
        if (next != 0)
        {
            *next = 0;
            next += 1;
        }
        char* end = 0;
        const long first = strtol(part, &end, 10);
        long last = first;
        result = end != part && first >= 0 && first < CPU_SETSIZE;
        if (result && *end == '-')
        {
            const char* second = end + 1;
            last = strtol(second, &end, 10);
            result = end != second && last >= first && last < CPU_SETSIZE;
        }
        result = result && *end == 0;
        for (long cpu = first; result && cpu <= last; cpu += 1)
        {
            CPU_SET((int)cpu, cpus);
        }
        part = next;
    }
    return result;
}

// Parses `options` (modified, and kept: the line points into it) into `line`. False, naming the option, if one isn't
// known.
static bool procbench_options(ProcbenchLine* line, char* options)
{
    bool result = true;
    line->runs = 1;
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
            line->runs = (uint32_t)strtoul(value, 0, 10);
        }
        else if (strcmp(option, "warmups") == 0 && value != 0)
        {
            line->warmups = (uint32_t)strtoul(value, 0, 10);
        }
        else if (strcmp(option, "pause") == 0 && value != 0)
        {
            line->pause = (uint32_t)strtoul(value, 0, 10);
        }
        else if (strcmp(option, "cpus") == 0 && value != 0)
        {
            result = procbench_cpus(&line->cpus, value);
            line->pinned = result;
        }
        else if (strcmp(option, "dir") == 0 && value != 0)
        {
            line->directory = value;
        }
        else if (strcmp(option, "var") == 0 && value != 0 && strchr(value, '=') != 0)
        {
            result = line->variable_count < PROCBENCH_VARIABLES;
            if (result)
            {
                line->variables[line->variable_count] = value;
                line->variable_count += 1;
            }
        }
        else if (strcmp(option, "capture") == 0 && value == 0)
        {
            line->capture = true;
        }
        else if (strcmp(option, "events") == 0 && value != 0)
        {
            for (char* name = value; result && name != 0 && *name != 0;)
            {
                char* next = strchr(name, '+');
                if (next != 0)
                {
                    *next = 0;
                    next += 1;
                }
                result = line->event_count < PROCBENCH_EVENTS && procbench_event(&line->events[line->event_count], name);
                line->event_count += result ? 1 : 0;
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

// Reads LIST into `lines`: how many, or -1 on an error, which it names.
static int procbench_read_list(const char* path, ProcbenchLine* lines)
{
    FILE* file = fopen(path, "r");
    int count = file != 0 ? 0 : -1;
    if (file == 0)
    {
        fprintf(stderr, "procbench: can't read %s: %s\n", path, strerror(errno));
    }
    static char texts[PROCBENCH_LINES][PROCBENCH_LINE_BYTES];
    while (count >= 0 && fgets(texts[count < PROCBENCH_LINES ? count : PROCBENCH_LINES - 1], PROCBENCH_LINE_BYTES, file) != 0)
    {
        // A list past the lines' room, or a line past its buffer, is an error rather than a shorter list.
        char* text = texts[count < PROCBENCH_LINES ? count : PROCBENCH_LINES - 1];
        if (count >= PROCBENCH_LINES || strchr(text, '\n') == 0)
        {
            fprintf(stderr, "procbench: %s has more than %d lines or a line past %d bytes\n", path, PROCBENCH_LINES, PROCBENCH_LINE_BYTES);
            count = -1;
            break;
        }
        text[strcspn(text, "\n")] = 0;
        if (text[0] == 0 || text[0] == '#')
        {
            continue;
        }
        char* label = text;
        char* options = strchr(label, '|');
        char* arguments = options != 0 ? strchr(options + 1, '|') : 0;
        ProcbenchLine* line = &lines[count];
        *line = (ProcbenchLine){ 0 };
        bool valid = options != 0 && arguments != 0 && (uint64_t)(options - label) < sizeof(line->label);
        if (valid)
        {
            *options = 0;
            *arguments = 0;
            snprintf(line->label, sizeof(line->label), "%s", label);
            valid = procbench_options(line, options + 1);
            uint32_t argument_count = 0;
            bool open = false;
            for (char* argument = strtok(arguments + 1, " "); valid && argument != 0; argument = strtok(0, " "))
            {
                if (strcmp(argument, ";;") == 0)
                {
                    // A step's end: a null after its arguments, which a step must have.
                    valid = open && argument_count + 1 < PROCBENCH_ARGUMENTS;
                    line->arguments[argument_count] = 0;
                    argument_count += valid ? 1 : 0;
                    open = false;
                }
                else
                {
                    if (!open)
                    {
                        valid = line->step_count < PROCBENCH_STEPS;
                        if (valid)
                        {
                            line->starts[line->step_count] = argument_count;
                            line->step_count += 1;
                        }
                        open = true;
                    }
                    valid = valid && argument_count + 2 < PROCBENCH_ARGUMENTS;
                    line->arguments[argument_count] = argument;
                    argument_count += valid ? 1 : 0;
                }
            }
            line->arguments[argument_count] = 0;
            valid = valid && open && line->step_count != 0;
        }
        if (!valid)
        {
            fprintf(stderr, "procbench: invalid line: %s\n", text);
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

static int procbench_open_event(const ProcbenchEvent* event, pid_t child)
{
    struct perf_event_attr attribute = { 0 };
    attribute.size = sizeof(attribute);
    attribute.type = event->type;
    attribute.config = event->config;
    attribute.disabled = 1;
    attribute.enable_on_exec = 1;
    attribute.inherit = 1;
    attribute.exclude_user = event->exclude_user ? 1 : 0;
    attribute.exclude_kernel = event->exclude_kernel ? 1 : 0;
    attribute.exclude_hv = 1;
    attribute.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING;
    return (int)syscall(SYS_perf_event_open, &attribute, child, -1, -1, PERF_FLAG_FD_CLOEXEC);
}

// One run of `line`: its commands in turn, then whatever they left behind. False if a command couldn't start or be
// measured, which it says.
static bool procbench_run(const ProcbenchLine* line, const char* out, uint32_t round, uint32_t run, ProcbenchResult* result)
{
    // The environment: the harness's, but the variables the line sets, and the line's.
    static char* environment[PROCBENCH_ENVIRONMENT];
    uint32_t count = 0;
    for (char** variable = environ; *variable != 0 && count + PROCBENCH_VARIABLES + 1 < PROCBENCH_ENVIRONMENT; variable += 1)
    {
        bool replaced = false;
        for (uint32_t v = 0; v < line->variable_count; v += 1)
        {
            const size_t name = (size_t)(strchr(line->variables[v], '=') - line->variables[v]) + 1;
            replaced = replaced || strncmp(*variable, line->variables[v], name) == 0;
        }
        if (!replaced)
        {
            environment[count++] = *variable;
        }
    }
    for (uint32_t v = 0; v < line->variable_count; v += 1)
    {
        environment[count++] = (char*)line->variables[v];
    }
    environment[count] = 0;
    int events[PROCBENCH_STEPS][PROCBENCH_EVENTS];
    uint32_t opened = 0;
    bool started = true;
    uint64_t first = 0;
    uint64_t last = 0;
    for (uint32_t s = 0; started && result->status == 0 && s < line->step_count; s += 1)
    {
        char* const* arguments = &line->arguments[line->starts[s]];
        char output_path[4096];
        char error_path[4096];
        if (line->capture)
        {
            snprintf(output_path, sizeof(output_path), "%s/%u-%s-%u.%u.out", out, round, line->label, run, s);
            snprintf(error_path, sizeof(error_path), "%s/%u-%s-%u.%u.err", out, round, line->label, run, s);
        }
        else
        {
            snprintf(output_path, sizeof(output_path), "/dev/null");
            snprintf(error_path, sizeof(error_path), "/dev/null");
        }
        int release[2];
        started = pipe2(release, O_CLOEXEC) == 0;
        const pid_t child = started ? fork() : -1;
        if (child == 0)
        {
            char byte;
            close(release[1]);
            const int output = open(output_path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
            const int errors = open(error_path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
            bool ready = output >= 0 && errors >= 0 && dup2(output, 1) == 1 && dup2(errors, 2) == 2;
            ready = ready && (!line->pinned || sched_setaffinity(0, sizeof(line->cpus), &line->cpus) == 0);
            ready = ready && (line->directory == 0 || chdir(line->directory) == 0);
            // Wait until the parent's counters are open.
            ready = ready && read(release[0], &byte, 1) == 1;
            if (ready)
            {
                execve(arguments[0], arguments, environment);
            }
            _exit(127);
        }
        started = child > 0;
        for (uint32_t e = 0; e < line->event_count; e += 1)
        {
            events[s][e] = started ? procbench_open_event(&line->events[e], child) : -1;
            if (started && events[s][e] < 0)
            {
                fprintf(stderr, "procbench: perf_event_open of %s: %s\n", line->events[e].name, strerror(errno));
                started = false;
            }
        }
        opened = s + 1;
        if (child > 0)
        {
            close(release[0]);
        }
        const uint64_t start = procbench_now();
        first = s == 0 ? start : first;
        if (started)
        {
            started = write(release[1], "x", 1) == 1;
        }
        if (child > 0)
        {
            close(release[1]);
        }
        int status = 0;
        struct rusage usage = { 0 };
        const pid_t waited = child > 0 ? wait4(child, &status, 0, &usage) : -1;
        last = procbench_now();
        started = started && waited == child;
        result->wall += last - start;
        result->status = waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : -1;
        result->user_us += procbench_microseconds(&usage.ru_utime);
        result->system_us += procbench_microseconds(&usage.ru_stime);
        result->minor_faults += (uint64_t)usage.ru_minflt;
        result->major_faults += (uint64_t)usage.ru_majflt;
        result->voluntary += (uint64_t)usage.ru_nvcsw;
        result->involuntary += (uint64_t)usage.ru_nivcsw;
        result->peak_kb = (uint64_t)usage.ru_maxrss > result->peak_kb ? (uint64_t)usage.ru_maxrss : result->peak_kb;
    }
    result->span = last - first;
    // What the commands left behind: the harness is their subreaper, so each is its child by now or will be when its
    // parent goes.
    bool left = true;
    while (left)
    {
        int status = 0;
        struct rusage usage = { 0 };
        const pid_t waited = wait4(-1, &status, 0, &usage);
        left = waited > 0 || (waited < 0 && errno == EINTR);
        if (waited > 0)
        {
            result->late_user_us += procbench_microseconds(&usage.ru_utime);
            result->late_system_us += procbench_microseconds(&usage.ru_stime);
            result->late_minor_faults += (uint64_t)usage.ru_minflt;
            result->late_count += 1;
        }
    }
    result->settle = procbench_now() - first;
    for (uint32_t s = 0; s < opened; s += 1)
    {
        for (uint32_t e = 0; e < line->event_count; e += 1)
        {
            uint64_t values[3] = { 0 };
            const bool read_all = events[s][e] >= 0 && read(events[s][e], values, sizeof(values)) == (ssize_t)sizeof(values);
            result->values[e] += read_all ? values[0] : 0;
            result->multiplexed[e] = result->multiplexed[e] || (read_all && values[2] < values[1]);
            if (events[s][e] >= 0)
            {
                close(events[s][e]);
            }
        }
    }
    return started;
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
    static ProcbenchLine lines[PROCBENCH_LINES];
    const int count = valid && list != 0 ? procbench_read_list(list, lines) : -1;
    if (!valid || list == 0)
    {
        fprintf(stderr, "usage: procbench [--rounds N] [--first N] [--no-header] [--out DIR] LIST\n");
    }
    bool succeeded = count > 0;
    if (succeeded && prctl(PR_SET_CHILD_SUBREAPER, 1, 0, 0, 0) != 0)
    {
        fprintf(stderr, "procbench: can't become a subreaper: %s\n", strerror(errno));
        succeeded = false;
    }
    if (succeeded && header)
    {
        printf("round\tline\tlabel\trun\twarmup\tstatus\twall_ns\tspan_ns\tsettle_ns\tuser_us\tsys_us\tminflt\tmajflt\tnvcsw\tnivcsw\tmaxrss_kb\tlate_user_us\tlate_sys_us\tlate_minflt\tlate_count\tcounters\n");
        fflush(stdout);
    }
    for (uint32_t round = first - 1; succeeded && round < first - 1 + rounds; round += 1)
    {
        for (int i = 0; succeeded && i < count; i += 1)
        {
            const int c = (i + (int)(round % (uint32_t)count)) % count;
            const ProcbenchLine* line = &lines[c];
            for (uint32_t run = 0; succeeded && run < line->warmups + line->runs; run += 1)
            {
                procbench_sleep(line->pause);
                ProcbenchResult result = { 0 };
                succeeded = procbench_run(line, out, round + 1, run, &result);
                printf("%u\t%d\t%s\t%u\t%d\t%d\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64
                       "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64,
                       round + 1, c, line->label, run, run < line->warmups ? 1 : 0, result.status, result.wall, result.span, result.settle, result.user_us, result.system_us,
                       result.minor_faults, result.major_faults, result.voluntary, result.involuntary, result.peak_kb, result.late_user_us, result.late_system_us,
                       result.late_minor_faults, result.late_count);
                for (uint32_t e = 0; e < line->event_count; e += 1)
                {
                    printf("\t%s=%" PRIu64 "%s", line->events[e].name, result.values[e], result.multiplexed[e] ? "*" : "");
                }
                printf("\n");
                fflush(stdout);
            }
        }
    }
    return succeeded ? 0 : 1;
}
