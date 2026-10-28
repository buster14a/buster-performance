// Original bounded wait4 receipt helper; the command inherits the caller's cores affinity.
#define _GNU_SOURCE
#include <errno.h>
#include <linux/perf_event.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static double seconds(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (double)value.tv_sec + (double)value.tv_nsec / 1000000000.0;
}

int main(int argc, char** argv)
{
    if (argc < 3) return 2;
    FILE* receipt = fopen(argv[1], "w");
    if (receipt == NULL) return 2;
    int ready[2];
    if (pipe(ready) != 0) return 2;
    const pid_t child = fork();
    if (child == 0)
    {
        close(ready[1]);
        char byte = 0;
        ssize_t got;
        do { got = read(ready[0], &byte, 1); } while (got < 0 && errno == EINTR);
        close(ready[0]);
        if (got != 1) _exit(125);
        execv(argv[2], argv + 2);
        _exit(127);
    }
    close(ready[0]);
    struct perf_event_attr attributes = { .type = PERF_TYPE_HARDWARE, .size = sizeof(struct perf_event_attr),
        .config = PERF_COUNT_HW_CPU_CYCLES, .disabled = 1, .inherit = 1, .enable_on_exec = 1,
        .exclude_kernel = 1, .exclude_hv = 1, .read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING };
    int counters[2] = { -1, -1 };
    for (unsigned event = 0; child > 0 && event < 2; event += 1)
    {
        attributes.config = event == 0 ? PERF_COUNT_HW_CPU_CYCLES : PERF_COUNT_HW_INSTRUCTIONS;
        counters[event] = (int)syscall(SYS_perf_event_open, &attributes, child, -1, -1, 0);
        if (counters[event] < 0) fprintf(stderr, "time-command: counter%u: %s\n", event, strerror(errno));
    }
    const double start = seconds();
    const ssize_t released = child > 0 ? write(ready[1], "x", 1) : -1;
    close(ready[1]);
    int status = 0;
    struct rusage usage = { 0 };
    pid_t waited = -1;
    if (child > 0)
    {
        do { waited = wait4(child, &status, 0, &usage); } while (waited < 0 && errno == EINTR);
    }
    const int result = waited != child || child < 0 ? 125 : WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
    uint64_t counts[2] = { 0, 0 };
    bool counted = released == 1;
    for (unsigned event = 0; event < 2; event += 1)
    {
        uint64_t values[3] = { 0 };
        ssize_t got = -1;
        if (counters[event] >= 0)
        {
            do { got = read(counters[event], values, sizeof(values)); } while (got < 0 && errno == EINTR);
            close(counters[event]);
        }
        counted &= got == (ssize_t)sizeof(values) && values[1] != 0 && values[1] == values[2];
        counts[event] = values[0];
    }
    fprintf(receipt, "status=%d wall_s=%.9f user_s=%.6f system_s=%.6f RSS_KiB=%ld minor=%ld major=%ld voluntary=%ld involuntary=%ld counted=%u cycles=%llu instructions=%llu\n",
            result, seconds() - start, (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec / 1000000.0,
            (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec / 1000000.0, usage.ru_maxrss,
            usage.ru_minflt, usage.ru_majflt, usage.ru_nvcsw, usage.ru_nivcsw, counted,
            (unsigned long long)counts[0], (unsigned long long)counts[1]);
    const int written = fclose(receipt);
    return result == 0 && written != 0 ? 125 : result;
}
