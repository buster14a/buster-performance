#define _GNU_SOURCE
#include <errno.h>
#include <inttypes.h>
#include <linux/perf_event.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static uint64_t now(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * 1000000000 + (uint64_t)time.tv_nsec;
}

static int sample(const char* compiler, const char* source, const char* object, unsigned round, unsigned variant, const char* family, unsigned count)
{
    int gate[2];
    int valid = pipe(gate) == 0;
    pid_t child = valid ? fork() : -1;
    if (child == 0)
    {
        close(gate[1]);
        char byte;
        const int ready = read(gate[0], &byte, 1) == 1;
        close(gate[0]);
        if (ready)
        {
            if (variant == 2)
            {
                execl(compiler, compiler, "--scalar", "--lanes", "1", "-c", source, "-o", object, (char*)NULL);
            }
            else
            {
                execl(compiler, compiler, "--lanes", "1", "-c", source, "-o", object, (char*)NULL);
            }
        }
        _exit(127);
    }
    valid &= child > 0;
    if (valid)
    {
        close(gate[0]);
        struct perf_event_attr attr = {
            .type = PERF_TYPE_HARDWARE,
            .size = sizeof(attr),
            .config = PERF_COUNT_HW_INSTRUCTIONS,
            .disabled = 1,
            .inherit = 1,
            .enable_on_exec = 1,
            .exclude_kernel = 1,
            .exclude_hv = 1,
            .read_format = PERF_FORMAT_TOTAL_TIME_ENABLED | PERF_FORMAT_TOTAL_TIME_RUNNING,
        };
        const int event = (int)syscall(SYS_perf_event_open, &attr, child, -1, -1, 0);
        const uint64_t start = now();
        valid &= write(gate[1], "x", 1) == 1;
        close(gate[1]);
        int status = 0;
        struct rusage usage = { 0 };
        valid &= wait4(child, &status, 0, &usage) == child;
        const uint64_t elapsed = now() - start;
        uint64_t counters[3] = { 0 };
        const int counted = event >= 0 && read(event, counters, sizeof(counters)) == sizeof(counters);
        if (event >= 0)
        {
            close(event);
        }
        valid &= WIFEXITED(status) && WEXITSTATUS(status) == 0 && counted && counters[0] != 0 && counters[1] != 0 && counters[1] == counters[2];
        if (round != 0)
        {
            printf("%u,%s,%s,%u,%.6f,%" PRIu64 ",%ld,%" PRIu64 ",%" PRIu64 ",%d\n", round, variant == 0 ? "base" : variant == 1 ? "head" : "scalar", family, count,
                   (double)elapsed / 1000000, counters[0], usage.ru_maxrss, counters[1], counters[2], valid ? 0 : 1);
            fflush(stdout);
        }
        if (!valid)
        {
            fprintf(stderr, "sample failed: %s %s, event=%d errno=%d status=%d\n", compiler, source, event, errno, status);
        }
    }
    return valid;
}

int main(int argc, char** argv)
{
    int valid = argc >= 5;
    if (valid)
    {
        const char* compilers[] = { argv[1], argv[2], argv[2] };
        const char* families[] = { "pointer_expression", "pointer_constant", "record_expression", "record_constant" };
        const unsigned counts[] = { 256, 512, 1024, 2048, 4096, 8192, 10000 };
        const unsigned rounds = (unsigned)strtoul(argv[4], NULL, 10);
        char source[4096];
        char object[4096];
        snprintf(object, sizeof(object), "%s/measured.o", argv[3]);
        puts("round,variant,family,associations,wall_ms,instructions_user,peak_rss_kb,counter_enabled_ns,counter_running_ns,status");
        // Round zero discards a warm-up for every executable/input. Reverse variant and input order on alternate
        // rounds; only one fresh compiler process runs at a time, on the CPU affinity inherited from taskset.
        for (unsigned round = 0; valid && round <= rounds; round += 1)
        {
            for (unsigned f = 0; valid && f < sizeof(families) / sizeof(families[0]); f += 1)
            {
                const unsigned family = (f + round) % (sizeof(families) / sizeof(families[0]));
                for (unsigned c = 0; valid && c < sizeof(counts) / sizeof(counts[0]); c += 1)
                {
                    const unsigned count = counts[round % 2 == 0 ? c : sizeof(counts) / sizeof(counts[0]) - 1 - c];
                    snprintf(source, sizeof(source), "%s/%s_%u.c", argv[3], families[family], count);
                    for (unsigned v = 0; valid && v < 3; v += 1)
                    {
                        const unsigned variant = (v + round) % 3;
                        valid = sample(compilers[variant], source, object, round, variant, families[family], count);
                    }
                }
            }
            if (valid && argc == 6)
            {
                for (unsigned v = 0; valid && v < 3; v += 1)
                {
                    const unsigned variant = (v + round) % 3;
                    valid = sample(compilers[variant], argv[5], object, round, variant, "sqlite", 0);
                }
            }
        }
        unlink(object);
    }
    return valid ? 0 : 1;
}
