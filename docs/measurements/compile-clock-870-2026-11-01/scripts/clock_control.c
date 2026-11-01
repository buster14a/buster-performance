// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// clock_control: the #870 control for --time-stages' getrusage system-time attribution. It alternates CPU-only work,
// page faults and syscalls at swept phase lengths and start offsets, reads getrusage's system time and minor faults at
// every phase boundary, and compares them with independent hardware user/kernel cycle counts (perf_event_open) and
// with task-clock:k, which is validated rather than assumed. The output is TSV; scripts/run.sh keeps it as evidence.
//
//   clock_control [--lengths US,US,...] [--offsets US,US,...] [--rounds N] [--only cpu|fault|syscall|empty]
//                 [--calibration-ms N] [--fault-mb N] [--no-pmu]
//
// It is measurement tooling, not a compiler phase: the source and token streams never enter it, so it is scalar.

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/perf_event.h>
#include <sched.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/utsname.h>
#include <time.h>
#include <unistd.h>

#define CLOCK_CONTROL_MAX_POINTS 32
#define CLOCK_CONTROL_MAX_KINDS 5
#define CLOCK_CONTROL_TICK_NS 10000000ull
#define CLOCK_CONTROL_PAGE 4096ull

typedef enum ClockKind
{
    CLOCK_KIND_CPU,
    CLOCK_KIND_FAULT,
    CLOCK_KIND_SYSCALL,
    CLOCK_KIND_EMPTY,
} ClockKind;

static const char* const clock_kind_names[] = { "cpu", "fault", "syscall", "empty" };

typedef struct ClockPoint
{
    uint64_t length_us;
    uint64_t offset_us;
} ClockPoint;

typedef struct ClockConfig
{
    ClockPoint lengths[CLOCK_CONTROL_MAX_POINTS];
    ClockPoint offsets[CLOCK_CONTROL_MAX_POINTS];
    uint32_t length_count;
    uint32_t offset_count;
    uint32_t rounds;
    uint32_t calibration_ms;
    uint64_t fault_bytes;
    ClockKind only;
    bool only_set;
    bool no_pmu;
} ClockConfig;

typedef struct ClockPmu
{
    int user_cycles;
    int kernel_cycles;
    int task_user;
    int task_kernel;
    bool user_cycles_available;
    bool kernel_cycles_available;
    bool task_user_available;
    bool task_kernel_available;
    int user_errno;
    int kernel_errno;
    int task_user_errno;
    int task_kernel_errno;
} ClockPmu;

typedef struct ClockMark
{
    uint64_t wall_ns;
    uint64_t tsc;
    uint64_t process_cpu_ns;
    uint64_t system_us;
    uint64_t minor_faults;
    uint64_t voluntary_switches;
    uint64_t involuntary_switches;
    uint64_t pmu_user;
    uint64_t pmu_kernel;
    uint64_t task_user;
    uint64_t task_kernel;
    bool usage_available;
    bool process_cpu_available;
} ClockMark;

typedef struct ClockSample
{
    uint32_t round;
    ClockKind kind;
    uint64_t length_us;
    uint64_t offset_us;
    uint32_t sequence;
    uint64_t work_units;
    uint64_t elapsed_ns;
    uint64_t process_cpu_ns;
    uint64_t system_us;
    uint64_t minor_faults;
    uint64_t voluntary_switches;
    uint64_t involuntary_switches;
    uint64_t pmu_user_cycles;
    uint64_t pmu_kernel_cycles;
    uint64_t task_user_ns;
    uint64_t task_kernel_ns;
    bool usage_available;
    bool process_cpu_available;
} ClockSample;

static volatile uint64_t clock_control_sink;
static uint8_t* clock_control_fault_arena;
static uint64_t clock_control_fault_pages;
static uint64_t clock_control_fault_touched;
static uint64_t clock_control_cpu_rate;     // iterations per millisecond
static uint64_t clock_control_syscall_rate; // iterations per millisecond
static uint64_t clock_control_fault_rate;   // pages per millisecond
static ClockPmu clock_control_pmu;

static uint64_t clock_now_ns(void)
{
    struct timespec now = { 0 };
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec;
}

static bool clock_process_cpu_ns(uint64_t* value)
{
    struct timespec now = { 0 };
    const bool read = clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &now) == 0;
    *value = read ? (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec : 0;
    return read;
}

static uint64_t clock_spin_once(uint64_t value)
{
    value ^= value << 13;
    value ^= value >> 7;
    value ^= value << 17;
    return value;
}

// A dependent xorshift chain: no memory, no syscall and no branch, so a phase's kernel time is only the timer's.
static void clock_cpu_work(uint64_t iterations)
{
    uint64_t value = clock_control_sink | 1;
    for (uint64_t i = 0; i < iterations; i += 1)
    {
        value = clock_spin_once(value);
    }
    clock_control_sink = value;
}

static void clock_syscall_work(uint64_t iterations)
{
    uint64_t value = 0;
    for (uint64_t i = 0; i < iterations; i += 1)
    {
        value += (uint64_t)syscall(SYS_getpid);
    }
    clock_control_sink = value;
}

static uint64_t clock_fault_work(uint64_t pages)
{
    const uint64_t room = clock_control_fault_pages - clock_control_fault_touched;
    const uint64_t taken = pages < room ? pages : room;
    uint8_t value = (uint8_t)clock_control_sink;
    for (uint64_t page = 0; page < taken; page += 1)
    {
        clock_control_fault_arena[(clock_control_fault_touched + page) * CLOCK_CONTROL_PAGE] = value + (uint8_t)page;
        value += 1;
    }
    clock_control_fault_touched += taken;
    clock_control_sink = value;
    return taken;
}

static void clock_fault_reset(void)
{
    if (clock_control_fault_arena != NULL && clock_control_fault_touched != 0)
    {
        madvise(clock_control_fault_arena, clock_control_fault_touched * CLOCK_CONTROL_PAGE, MADV_DONTNEED);
        clock_control_fault_touched = 0;
    }
}

static int clock_read_text(const char* path, char* text, size_t capacity)
{
    text[0] = 0;
    const int file = open(path, O_RDONLY | O_CLOEXEC);
    bool okay = file != -1;
    size_t used = 0;
    while (okay && used + 1 < capacity)
    {
        const ssize_t got = read(file, text + used, capacity - used - 1);
        if (got > 0)
        {
            used += (size_t)got;
        }
        else if (got == 0)
        {
            break;
        }
        else
        {
            okay = errno == EINTR;
        }
    }
    if (file != -1)
    {
        close(file);
    }
    text[used] = 0;
    for (size_t i = 0; i < used; i += 1)
    {
        if (text[i] == '\n' || text[i] == '\t' || text[i] == '\r')
        {
            text[i] = ' ';
        }
    }
    while (used != 0 && text[used - 1] == ' ')
    {
        text[--used] = 0;
    }
    size_t first = 0;
    while (first < used && (text[first] == ' ' || text[first] == '\t'))
    {
        first += 1;
    }
    if (first != 0)
    {
        memmove(text, text + first, used - first + 1);
        used -= first;
    }
    return okay ? (used != 0 ? 1 : 2) : 0;
}

static void clock_config_line(const char* name, const char* path)
{
    char text[4096];
    const int status = clock_read_text(path, text, sizeof(text));
    printf("clock-config\t%s\t%s\n", name, status == 1 ? text : status == 2 ? "empty" : "unavailable");
}

static int clock_pmu_open(uint32_t type, uint64_t config, uint64_t exclude_user, uint64_t exclude_kernel, int* error)
{
    struct perf_event_attr attr;
    memset(&attr, 0, sizeof(attr));
    attr.type = type;
    attr.size = sizeof(attr);
    attr.config = config;
    attr.exclude_user = exclude_user;
    attr.exclude_kernel = exclude_kernel;
    attr.exclude_hv = 1;
    attr.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING;
    const int fd = (int)syscall(SYS_perf_event_open, &attr, 0, -1, -1, 0);
    *error = fd == -1 ? errno : 0;
    return fd;
}

typedef struct ClockPmuValue
{
    uint64_t value;
    uint64_t enabled;
    uint64_t running;
} ClockPmuValue;

static uint64_t clock_pmu_read(int fd)
{
    ClockPmuValue value = { 0 };
    if (fd < 0 || read(fd, &value, sizeof(value)) != (ssize_t)sizeof(value))
    {
        return 0;
    }
    if (value.running != 0 && value.enabled != 0)
    {
        return (uint64_t)((long double)value.value * (long double)value.enabled / (long double)value.running);
    }
    return value.value;
}

static void clock_pmu_initialize(ClockConfig* config)
{
    memset(&clock_control_pmu, 0, sizeof(clock_control_pmu));
    clock_control_pmu.user_cycles = -1;
    clock_control_pmu.kernel_cycles = -1;
    clock_control_pmu.task_user = -1;
    clock_control_pmu.task_kernel = -1;
    if (config->no_pmu)
    {
        return;
    }
    clock_control_pmu.user_cycles = clock_pmu_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, 0, 1, &clock_control_pmu.user_errno);
    clock_control_pmu.kernel_cycles = clock_pmu_open(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, 1, 0, &clock_control_pmu.kernel_errno);
    clock_control_pmu.task_user = clock_pmu_open(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK, 0, 1, &clock_control_pmu.task_user_errno);
    clock_control_pmu.task_kernel = clock_pmu_open(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK, 1, 0, &clock_control_pmu.task_kernel_errno);
    clock_control_pmu.user_cycles_available = clock_control_pmu.user_cycles >= 0;
    clock_control_pmu.kernel_cycles_available = clock_control_pmu.kernel_cycles >= 0;
    clock_control_pmu.task_user_available = clock_control_pmu.task_user >= 0;
    clock_control_pmu.task_kernel_available = clock_control_pmu.task_kernel >= 0;
    printf("clock-config\tpmu-user-cycles\t%s\n", clock_control_pmu.user_cycles_available ? "available" : strerror(clock_control_pmu.user_errno));
    printf("clock-config\tpmu-kernel-cycles\t%s\n", clock_control_pmu.kernel_cycles_available ? "available" : strerror(clock_control_pmu.kernel_errno));
    printf("clock-config\ttask-clock-user\t%s\n", clock_control_pmu.task_user_available ? "available" : strerror(clock_control_pmu.task_user_errno));
    printf("clock-config\ttask-clock-kernel\t%s\n", clock_control_pmu.task_kernel_available ? "available" : strerror(clock_control_pmu.task_kernel_errno));
}

static ClockMark clock_mark(void)
{
    ClockMark mark = { 0 };
    mark.wall_ns = clock_now_ns();
    mark.tsc = __rdtsc();
    mark.process_cpu_available = clock_process_cpu_ns(&mark.process_cpu_ns);
    struct rusage usage;
    memset(&usage, 0, sizeof(usage));
    mark.usage_available = getrusage(RUSAGE_SELF, &usage) == 0;
    mark.system_us = mark.usage_available ? (uint64_t)usage.ru_stime.tv_sec * 1000000ull + (uint64_t)usage.ru_stime.tv_usec : 0;
    mark.minor_faults = mark.usage_available ? (uint64_t)usage.ru_minflt : 0;
    mark.voluntary_switches = mark.usage_available ? (uint64_t)usage.ru_nvcsw : 0;
    mark.involuntary_switches = mark.usage_available ? (uint64_t)usage.ru_nivcsw : 0;
    mark.pmu_user = clock_pmu_read(clock_control_pmu.user_cycles);
    mark.pmu_kernel = clock_pmu_read(clock_control_pmu.kernel_cycles);
    mark.task_user = clock_pmu_read(clock_control_pmu.task_user);
    mark.task_kernel = clock_pmu_read(clock_control_pmu.task_kernel);
    return mark;
}

static void clock_print_mark_config(const ClockConfig* config)
{
    printf("clock-control\tversion\t1\n");
    printf("clock-control\trounds\t%u\n", config->rounds);
    printf("clock-control\tcalibration-ms\t%u\n", config->calibration_ms);
    printf("clock-control\tfault-mb\t%llu\n", (unsigned long long)(config->fault_bytes / (1024 * 1024)));
    printf("clock-control\tlengths-us\t");
    for (uint32_t i = 0; i < config->length_count; i += 1)
    {
        printf("%s%llu", i == 0 ? "" : ",", (unsigned long long)config->lengths[i].length_us);
    }
    printf("\nclock-control\toffsets-us\t");
    for (uint32_t i = 0; i < config->offset_count; i += 1)
    {
        printf("%s%llu", i == 0 ? "" : ",", (unsigned long long)config->offsets[i].offset_us);
    }
    printf("\n");
}

static void clock_print_configuration(const ClockConfig* config)
{
    struct utsname system;
    if (uname(&system) == 0)
    {
        printf("clock-config\tkernel\t%s %s %s %s\n", system.sysname, system.release, system.version, system.machine);
    }
    else
    {
        printf("clock-config\tkernel\tunavailable\n");
    }
    char hostname[256] = { 0 };
    printf("clock-config\thostname\t%s\n", gethostname(hostname, sizeof(hostname)) == 0 ? hostname : "unavailable");
    const long cpus = sysconf(_SC_NPROCESSORS_ONLN);
    printf("clock-config\tcpus-online-sysconf\t%ld\n", cpus);
    cpu_set_t set;
    CPU_ZERO(&set);
    if (sched_getaffinity(0, sizeof(set), &set) == 0)
    {
        printf("clock-config\tcpu-affinity\t");
        bool first = true;
        for (int cpu = 0; cpu < CPU_SETSIZE; cpu += 1)
        {
            if (CPU_ISSET(cpu, &set))
            {
                printf("%s%d", first ? "" : ",", cpu);
                first = false;
            }
        }
        printf("\n");
    }
    clock_config_line("cmdline", "/proc/cmdline");
    clock_config_line("cpu-online", "/sys/devices/system/cpu/online");
    clock_config_line("cpu-isolated", "/sys/devices/system/cpu/isolated");
    clock_config_line("cpu-nohz-full", "/sys/devices/system/cpu/nohz_full");
    clock_config_line("perf-event-paranoid", "/proc/sys/kernel/perf_event_paranoid");
    clock_config_line("cpufreq-governor", "/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor");
    clock_config_line("cpufreq-cur-khz", "/sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq");
    char text[4096];
    printf("clock-config\tconfig-gz\t%s\n", clock_read_text("/proc/config.gz", text, sizeof(text)) != 0 ? "present" : "unavailable");
    printf("clock-config\tpmu-request\t%s\n", config->no_pmu ? "disabled" : "enabled");
}

static uint64_t clock_calibrate(ClockKind kind, uint32_t milliseconds)
{
    const uint64_t duration = (uint64_t)milliseconds * 1000000ull;
    const uint64_t start = clock_now_ns();
    uint64_t units = 0;
    if (kind == CLOCK_KIND_CPU)
    {
        while (clock_now_ns() - start < duration)
        {
            clock_cpu_work(20000);
            units += 20000;
        }
        return (uint64_t)((long double)units * 1000000.0 / (long double)(clock_now_ns() - start + 1));
    }
    if (kind == CLOCK_KIND_SYSCALL)
    {
        while (clock_now_ns() - start < duration)
        {
            clock_syscall_work(1000);
            units += 1000;
        }
        return (uint64_t)((long double)units * 1000000.0 / (long double)(clock_now_ns() - start + 1));
    }
    if (kind == CLOCK_KIND_FAULT)
    {
        clock_fault_reset();
        while (clock_now_ns() - start < duration && clock_control_fault_touched < clock_control_fault_pages)
        {
            const uint64_t taken = clock_fault_work(256);
            units += taken;
            if (taken == 0)
            {
                break;
            }
        }
        const uint64_t elapsed = clock_now_ns() - start;
        clock_fault_reset();
        return (uint64_t)((long double)units * 1000000.0 / (long double)(elapsed + 1));
    }
    return 0;
}

static void clock_work(ClockKind kind, uint64_t length_us)
{
    if (kind == CLOCK_KIND_CPU)
    {
        clock_cpu_work(clock_control_cpu_rate * length_us / 1000);
    }
    else if (kind == CLOCK_KIND_SYSCALL)
    {
        clock_syscall_work(clock_control_syscall_rate * length_us / 1000);
    }
    else if (kind == CLOCK_KIND_FAULT)
    {
        clock_fault_work(clock_control_fault_rate * length_us / 1000);
    }
}

static void clock_spin_to_offset(uint64_t origin_ns, uint64_t offset_us)
{
    const uint64_t target = origin_ns + offset_us * 1000ull;
    uint64_t now = clock_now_ns();
    uint64_t when = target;
    if (now >= when)
    {
        when += ((now - when) / CLOCK_CONTROL_TICK_NS + 1) * CLOCK_CONTROL_TICK_NS;
    }
    uint64_t value = clock_control_sink | 1;
    while (now < when)
    {
        for (uint32_t i = 0; i < 512; i += 1)
        {
            value = clock_spin_once(value);
        }
        now = clock_now_ns();
    }
    clock_control_sink = value;
}

static ClockSample clock_sample(uint32_t round, ClockKind kind, uint64_t length_us, uint64_t offset_us, uint32_t sequence)
{
    ClockSample sample = { .round = round, .kind = kind, .length_us = length_us, .offset_us = offset_us, .sequence = sequence };
    const ClockMark before = clock_mark();
    if (kind == CLOCK_KIND_FAULT)
    {
        sample.work_units = clock_fault_work(clock_control_fault_rate * length_us / 1000);
    }
    else
    {
        clock_work(kind, length_us);
        sample.work_units = kind == CLOCK_KIND_CPU ? clock_control_cpu_rate * length_us / 1000 :
                            kind == CLOCK_KIND_SYSCALL ? clock_control_syscall_rate * length_us / 1000 : 0;
    }
    const ClockMark after = clock_mark();
    sample.elapsed_ns = after.wall_ns - before.wall_ns;
    sample.process_cpu_available = before.process_cpu_available && after.process_cpu_available;
    sample.process_cpu_ns = sample.process_cpu_available && after.process_cpu_ns > before.process_cpu_ns ? after.process_cpu_ns - before.process_cpu_ns : 0;
    sample.usage_available = before.usage_available && after.usage_available;
    sample.system_us = sample.usage_available && after.system_us > before.system_us ? after.system_us - before.system_us : 0;
    sample.minor_faults = sample.usage_available && after.minor_faults > before.minor_faults ? after.minor_faults - before.minor_faults : 0;
    sample.voluntary_switches = sample.usage_available && after.voluntary_switches > before.voluntary_switches ? after.voluntary_switches - before.voluntary_switches : 0;
    sample.involuntary_switches = sample.usage_available && after.involuntary_switches > before.involuntary_switches ? after.involuntary_switches - before.involuntary_switches : 0;
    sample.pmu_user_cycles = after.pmu_user > before.pmu_user ? after.pmu_user - before.pmu_user : 0;
    sample.pmu_kernel_cycles = after.pmu_kernel > before.pmu_kernel ? after.pmu_kernel - before.pmu_kernel : 0;
    sample.task_user_ns = after.task_user > before.task_user ? after.task_user - before.task_user : 0;
    sample.task_kernel_ns = after.task_kernel > before.task_kernel ? after.task_kernel - before.task_kernel : 0;
    return sample;
}

static void clock_print_sample(const ClockSample* sample)
{
    const double elapsed_ms = (double)sample->elapsed_ns / 1e6;
    const double process_cpu_ms = (double)sample->process_cpu_ns / 1e6;
    // The hardware cycles convert with their own phase's total cycle rate; a phase with no cycles has no estimate.
    const uint64_t cycles = sample->pmu_user_cycles + sample->pmu_kernel_cycles;
    const double cycle_ns = cycles != 0 ? (double)sample->elapsed_ns / (double)cycles : 0;
    const double pmu_user_ms = cycles != 0 ? (double)sample->pmu_user_cycles * cycle_ns / 1e6 : -1;
    const double pmu_kernel_ms = cycles != 0 ? (double)sample->pmu_kernel_cycles * cycle_ns / 1e6 : -1;
    printf("phase\t%u\t%s\t%llu\t%llu\t%u\t%llu\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%llu\t%llu\t%llu\t%.6f\t%.6f\t%.6f\t%s\n", sample->round,
           clock_kind_names[sample->kind], (unsigned long long)sample->length_us, (unsigned long long)sample->offset_us, sample->sequence,
           (unsigned long long)sample->work_units, elapsed_ms, process_cpu_ms, (double)sample->system_us / 1e3, pmu_user_ms, pmu_kernel_ms,
           (unsigned long long)sample->minor_faults, (unsigned long long)sample->voluntary_switches, (unsigned long long)sample->involuntary_switches,
           (double)sample->task_user_ns / 1e6, (double)sample->task_kernel_ns / 1e6,
           cycles != 0 ? (double)sample->pmu_kernel_cycles / (double)cycles : -1, sample->usage_available ? "available" : "unavailable");
}

static int clock_compare_double(const void* a, const void* b)
{
    const double left = *(const double*)a;
    const double right = *(const double*)b;
    return left < right ? -1 : left > right ? 1 : 0;
}

static double clock_median(double* values, uint32_t count)
{
    if (count == 0)
    {
        return -1;
    }
    qsort(values, count, sizeof(double), clock_compare_double);
    return count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

typedef struct ClockAggregate
{
    double system_share;
    double pmu_kernel_share;
    double system_minus_pmu_ms;
    double absolute_error_ms;
    double system_ms;
    double pmu_kernel_ms;
    double task_kernel_ms;
    double task_error_ms;
    uint32_t count;
} ClockAggregate;

static ClockAggregate clock_aggregate(const ClockSample* samples, uint32_t count, ClockKind kind, uint64_t length_us)
{
    double shares[4096];
    double pmu_shares[4096];
    double differences[4096];
    double errors[4096];
    double systems[4096];
    double pmus[4096];
    double tasks[4096];
    double task_errors[4096];
    uint32_t used = 0;
    for (uint32_t i = 0; i < count && used < 4096; i += 1)
    {
        const ClockSample* sample = &samples[i];
        if (sample->kind != kind || sample->length_us != length_us || sample->elapsed_ns == 0)
        {
            continue;
        }
        const double elapsed_ms = (double)sample->elapsed_ns / 1e6;
        const uint64_t cycles = sample->pmu_user_cycles + sample->pmu_kernel_cycles;
        const double cycle_ns = cycles != 0 ? (double)sample->elapsed_ns / (double)cycles : 0;
        const double pmu_ms = cycles != 0 ? (double)sample->pmu_kernel_cycles * cycle_ns / 1e6 : -1;
        const double system_ms = (double)sample->system_us / 1e3;
        const double task_ms = (double)sample->task_kernel_ns / 1e6;
        shares[used] = system_ms / elapsed_ms;
        pmu_shares[used] = pmu_ms >= 0 ? pmu_ms / elapsed_ms : -1;
        differences[used] = system_ms - pmu_ms;
        errors[used] = pmu_ms >= 0 ? (system_ms > pmu_ms ? system_ms - pmu_ms : pmu_ms - system_ms) : -1;
        systems[used] = system_ms;
        pmus[used] = pmu_ms;
        tasks[used] = task_ms;
        task_errors[used] = pmu_ms >= 0 ? (task_ms > pmu_ms ? task_ms - pmu_ms : pmu_ms - task_ms) : -1;
        used += 1;
    }
    ClockAggregate aggregate = { 0 };
    aggregate.count = used;
    if (used != 0)
    {
        aggregate.system_share = clock_median(shares, used);
        aggregate.pmu_kernel_share = clock_median(pmu_shares, used);
        aggregate.system_minus_pmu_ms = clock_median(differences, used);
        aggregate.absolute_error_ms = clock_median(errors, used);
        aggregate.system_ms = clock_median(systems, used);
        aggregate.pmu_kernel_ms = clock_median(pmus, used);
        aggregate.task_kernel_ms = clock_median(tasks, used);
        aggregate.task_error_ms = clock_median(task_errors, used);
    }
    return aggregate;
}

static void clock_parse_list(const char* text, ClockPoint* points, uint32_t* count)
{
    *count = 0;
    const char* at = text;
    while (*at != 0 && *count < CLOCK_CONTROL_MAX_POINTS)
    {
        char* end = NULL;
        const unsigned long long value = strtoull(at, &end, 10);
        if (end == at)
        {
            break;
        }
        points[*count].length_us = value;
        points[*count].offset_us = value;
        *count += 1;
        at = *end == ',' ? end + 1 : end;
    }
}

static bool clock_parse_options(int argc, char** argv, ClockConfig* config)
{
    config->lengths[0] = (ClockPoint){ 250, 0 };
    config->lengths[1] = (ClockPoint){ 500, 0 };
    config->lengths[2] = (ClockPoint){ 1000, 0 };
    config->lengths[3] = (ClockPoint){ 2000, 0 };
    config->lengths[4] = (ClockPoint){ 5000, 0 };
    config->lengths[5] = (ClockPoint){ 10000, 0 };
    config->lengths[6] = (ClockPoint){ 20000, 0 };
    config->lengths[7] = (ClockPoint){ 50000, 0 };
    config->length_count = 8;
    config->offsets[0] = (ClockPoint){ 0, 0 };
    config->offsets[1] = (ClockPoint){ 0, 1250 };
    config->offsets[2] = (ClockPoint){ 0, 2500 };
    config->offsets[3] = (ClockPoint){ 0, 3750 };
    config->offsets[4] = (ClockPoint){ 0, 5000 };
    config->offsets[5] = (ClockPoint){ 0, 6250 };
    config->offsets[6] = (ClockPoint){ 0, 7500 };
    config->offsets[7] = (ClockPoint){ 0, 8750 };
    config->offset_count = 8;
    config->rounds = 3;
    config->calibration_ms = 5;
    config->fault_bytes = 256ull * 1024 * 1024;
    config->only = CLOCK_KIND_CPU;
    config->only_set = false;
    config->no_pmu = false;
    for (int i = 1; i < argc; i += 1)
    {
        if (strcmp(argv[i], "--lengths") == 0 && i + 1 < argc)
        {
            clock_parse_list(argv[++i], config->lengths, &config->length_count);
        }
        else if (strcmp(argv[i], "--offsets") == 0 && i + 1 < argc)
        {
            clock_parse_list(argv[++i], config->offsets, &config->offset_count);
            for (uint32_t p = 0; p < config->offset_count; p += 1)
            {
                config->offsets[p].offset_us = config->offsets[p].length_us;
            }
        }
        else if (strcmp(argv[i], "--rounds") == 0 && i + 1 < argc)
        {
            config->rounds = (uint32_t)strtoul(argv[++i], NULL, 10);
        }
        else if (strcmp(argv[i], "--calibration-ms") == 0 && i + 1 < argc)
        {
            config->calibration_ms = (uint32_t)strtoul(argv[++i], NULL, 10);
        }
        else if (strcmp(argv[i], "--fault-mb") == 0 && i + 1 < argc)
        {
            config->fault_bytes = strtoull(argv[++i], NULL, 10) * 1024ull * 1024ull;
        }
        else if (strcmp(argv[i], "--no-pmu") == 0)
        {
            config->no_pmu = true;
        }
        else if (strcmp(argv[i], "--only") == 0 && i + 1 < argc)
        {
            const char* name = argv[++i];
            bool found = false;
            for (uint32_t k = 0; k < 4; k += 1)
            {
                if (strcmp(name, clock_kind_names[k]) == 0)
                {
                    config->only = (ClockKind)k;
                    config->only_set = true;
                    found = true;
                }
            }
            if (!found)
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }
    return config->length_count != 0 && config->offset_count != 0 && config->rounds != 0 && config->rounds <= 1000 &&
           config->calibration_ms != 0 && config->calibration_ms <= 1000 && config->fault_bytes >= 1024 * 1024;
}

int main(int argc, char** argv)
{
    ClockConfig config;
    if (!clock_parse_options(argc, argv, &config))
    {
        fprintf(stderr, "usage: clock_control [--lengths US,US,...] [--offsets US,US,...] [--rounds N] [--only cpu|fault|syscall|empty]\n"
                        "                     [--calibration-ms N] [--fault-mb N] [--no-pmu]\n");
        return 2;
    }
    clock_print_mark_config(&config);
    clock_print_configuration(&config);
    clock_pmu_initialize(&config);

    clock_control_fault_pages = config.fault_bytes / CLOCK_CONTROL_PAGE;
    clock_control_fault_arena = mmap(NULL, config.fault_bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    if (clock_control_fault_arena == MAP_FAILED)
    {
        printf("clock-config\tfault-arena\tunavailable:%s\n", strerror(errno));
        clock_control_fault_arena = NULL;
        clock_control_fault_pages = 0;
    }
    else
    {
        printf("clock-config\tfault-arena\tavailable:%llu-pages\n", (unsigned long long)clock_control_fault_pages);
    }

    clock_control_cpu_rate = clock_calibrate(CLOCK_KIND_CPU, config.calibration_ms);
    clock_control_syscall_rate = clock_calibrate(CLOCK_KIND_SYSCALL, config.calibration_ms);
    clock_control_fault_rate = clock_calibrate(CLOCK_KIND_FAULT, config.calibration_ms);
    printf("clock-control\tcalibration\tcpu\t%llu\n", (unsigned long long)clock_control_cpu_rate);
    printf("clock-control\tcalibration\tsyscall\t%llu\n", (unsigned long long)clock_control_syscall_rate);
    printf("clock-control\tcalibration\tfault\t%llu\n", (unsigned long long)clock_control_fault_rate);

    ClockKind kinds[5] = { CLOCK_KIND_CPU, CLOCK_KIND_FAULT, CLOCK_KIND_CPU, CLOCK_KIND_SYSCALL, CLOCK_KIND_EMPTY };
    const uint32_t kind_count = config.only_set ? 1 : 5;
    kinds[0] = config.only_set ? config.only : CLOCK_KIND_CPU;
    const uint64_t origin = clock_now_ns();
    const uint64_t capacity = (uint64_t)config.rounds * config.length_count * config.offset_count * kind_count;
    ClockSample* samples = calloc(capacity, sizeof(ClockSample));
    uint32_t used = 0;
    bool failed = samples == NULL;
    for (uint32_t round = 0; !failed && round < config.rounds; round += 1)
    {
        for (uint32_t l = 0; !failed && l < config.length_count; l += 1)
        {
            for (uint32_t o = 0; !failed && o < config.offset_count; o += 1)
            {
                clock_fault_reset();
                clock_spin_to_offset(origin, config.offsets[o].offset_us);
                const uint32_t first = (round + l + o) % kind_count;
                for (uint32_t k = 0; !failed && k < kind_count; k += 1)
                {
                    const ClockKind kind = kinds[(first + k) % kind_count];
                    if (used == capacity)
                    {
                        failed = true;
                        break;
                    }
                    samples[used] = clock_sample(round, kind, config.lengths[l].length_us, config.offsets[o].offset_us, k);
                    clock_print_sample(&samples[used]);
                    used += 1;
                    fflush(stdout);
                }
            }
        }
    }
    printf("clock-control\tsamples\t%u\n", used);

    // Per length: CPU-only system attribution against the hardware kernel split, the fault and syscall phases, and
    // task-clock:k's agreement with the hardware kernel time.
    bool all_consistent = true;
    bool pmu_available = clock_control_pmu.user_cycles_available && clock_control_pmu.kernel_cycles_available;
    for (uint32_t l = 0; !failed && l < config.length_count; l += 1)
    {
        const ClockAggregate cpu = clock_aggregate(samples, used, CLOCK_KIND_CPU, config.lengths[l].length_us);
        const ClockAggregate fault = clock_aggregate(samples, used, CLOCK_KIND_FAULT, config.lengths[l].length_us);
        const ClockAggregate syscall_aggregate = clock_aggregate(samples, used, CLOCK_KIND_SYSCALL, config.lengths[l].length_us);
        const ClockAggregate empty = clock_aggregate(samples, used, CLOCK_KIND_EMPTY, config.lengths[l].length_us);
        const double target_ms = (double)config.lengths[l].length_us / 1e3;
        const double tolerance_ms = target_ms * 0.10 > 0.5 ? target_ms * 0.10 : 0.5;
        const double share_tolerance = 0.02;
        const bool cpu_ok = cpu.count != 0 && cpu.absolute_error_ms <= tolerance_ms && cpu.system_share >= 0 && cpu.pmu_kernel_share >= 0 &&
                            (cpu.system_share > cpu.pmu_kernel_share ? cpu.system_share - cpu.pmu_kernel_share : cpu.pmu_kernel_share - cpu.system_share) <= share_tolerance;
        const bool fault_ok = fault.count == 0 || (fault.absolute_error_ms <= tolerance_ms && fault.pmu_kernel_share >= 0 &&
                                                   (fault.system_share > fault.pmu_kernel_share ? fault.system_share - fault.pmu_kernel_share : fault.pmu_kernel_share - fault.system_share) <= share_tolerance);
        const bool syscall_ok = syscall_aggregate.count == 0 || (syscall_aggregate.absolute_error_ms <= tolerance_ms && syscall_aggregate.pmu_kernel_share >= 0 &&
                                                                (syscall_aggregate.system_share > syscall_aggregate.pmu_kernel_share ? syscall_aggregate.system_share - syscall_aggregate.pmu_kernel_share :
                                                                 syscall_aggregate.pmu_kernel_share - syscall_aggregate.system_share) <= share_tolerance);
        const bool this_consistent = !pmu_available || (cpu_ok && fault_ok && syscall_ok);
        all_consistent = all_consistent && this_consistent;
        printf("summary\tlength-us\t%llu\tcpu-count\t%u\tcpu-system-share\t%.6f\tcpu-pmu-kernel-share\t%.6f\tcpu-system-minus-pmu-ms\t%.6f\t"
               "cpu-absolute-error-ms\t%.6f\tcpu-system-ms\t%.6f\tcpu-pmu-kernel-ms\t%.6f\tfault-system-ms\t%.6f\tfault-pmu-kernel-ms\t%.6f\t"
               "syscall-system-ms\t%.6f\tsyscall-pmu-kernel-ms\t%.6f\tempty-system-ms\t%.6f\ttask-kernel-minus-pmu-ms\t%.6f\ttolerance-ms\t%.6f\tconsistent\t%s\n",
               (unsigned long long)config.lengths[l].length_us, cpu.count, cpu.system_share, cpu.pmu_kernel_share, cpu.system_minus_pmu_ms,
               cpu.absolute_error_ms, cpu.system_ms, cpu.pmu_kernel_ms, fault.system_ms, fault.pmu_kernel_ms, syscall_aggregate.system_ms,
               syscall_aggregate.pmu_kernel_ms, empty.system_ms, cpu.task_error_ms, tolerance_ms, this_consistent ? "yes" : "no");
    }
    printf("summary\tverdict\t%s\n", !pmu_available ? "unavailable" : all_consistent ? "consistent-at-tested-lengths" : "low-confidence");
    printf("summary\treason\t%s\n", !pmu_available ? "hardware-user-kernel-cycles-unavailable" :
           all_consistent ? "getrusage-within-tolerance-at-every-tested-length" : "getrusage-disagrees-with-hardware-kernel-cycles");
    printf("summary\ttask-clock-k\t%s\n", !pmu_available ? "unavailable" : clock_control_pmu.task_kernel_available ? "compared-not-trusted" : "unavailable");

    if (clock_control_pmu.user_cycles >= 0) close(clock_control_pmu.user_cycles);
    if (clock_control_pmu.kernel_cycles >= 0) close(clock_control_pmu.kernel_cycles);
    if (clock_control_pmu.task_user >= 0) close(clock_control_pmu.task_user);
    if (clock_control_pmu.task_kernel >= 0) close(clock_control_pmu.task_kernel);
    clock_fault_reset();
    if (clock_control_fault_arena != NULL) munmap(clock_control_fault_arena, config.fault_bytes);
    free(samples);
    return failed ? 1 : 0;
}
