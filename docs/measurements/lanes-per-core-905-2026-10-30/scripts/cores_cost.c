// What counting the allowed CPUs' cores from sysfs costs: one core_cpus_list read per core, its siblings skipped.
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>

static uint64_t now_ns(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000ull + (uint64_t)t.tv_nsec;
}

static uint32_t count_cores(int at, uint32_t* reads)
{
    uint64_t mask[16] = { 0 };
    uint64_t seen[16] = { 0 };
    const long written = syscall(SYS_sched_getaffinity, 0, sizeof(mask), mask);
    const int directory = at ? open("/sys/devices/system/cpu", O_RDONLY | O_DIRECTORY | O_CLOEXEC) : -1;
    uint32_t cores = 0;
    *reads = 0;
    for (uint32_t cpu = 0; cpu < 1024 && (long)(cpu / 8) < written; cpu += 1)
    {
        const uint64_t bit = 1ull << (cpu % 64);
        if ((mask[cpu / 64] & bit) == 0 || (seen[cpu / 64] & bit) != 0)
        {
            continue;
        }
        char path[96];
        char text[256];
        int fd;
        if (at)
        {
            snprintf(path, sizeof(path), "cpu%u/topology/core_cpus_list", cpu);
            fd = openat(directory, path, O_RDONLY | O_CLOEXEC);
        }
        else
        {
            snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%u/topology/core_cpus_list", cpu);
            fd = open(path, O_RDONLY | O_CLOEXEC);
        }
        const ssize_t n = fd >= 0 ? read(fd, text, sizeof(text) - 1) : -1;
        if (fd >= 0)
        {
            close(fd);
        }
        *reads += 1;
        cores += 1;
        seen[cpu / 64] |= bit;
        ssize_t i = 0;
        int more = 1;
        while (more && i < n)
        {
            uint32_t first = 0;
            uint32_t last = 0;
            int digits = 0;
            while (i < n && text[i] >= '0' && text[i] <= '9')
            {
                first = first * 10 + (uint32_t)(text[i] - '0');
                i += 1;
                digits += 1;
            }
            last = first;
            if (digits != 0 && i < n && text[i] == '-')
            {
                i += 1;
                last = 0;
                digits = 0;
                while (i < n && text[i] >= '0' && text[i] <= '9')
                {
                    last = last * 10 + (uint32_t)(text[i] - '0');
                    i += 1;
                    digits += 1;
                }
            }
            for (uint32_t c = first; digits != 0 && c <= last && c < 1024; c += 1)
            {
                seen[c / 64] |= 1ull << (c % 64);
            }
            more = digits != 0 && i < n && text[i] == ',';
            i += more;
        }
    }
    if (directory >= 0)
    {
        close(directory);
    }
    return cores != 0 ? cores : 1;
}

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

int main(int argc, char** argv)
{
    const int at = argc > 1 && argv[1][0] == 'a';
    uint32_t reads = 0;
    const uint64_t first_begin = now_ns();
    const uint32_t cores = count_cores(at, &reads);
    const uint64_t first = now_ns() - first_begin;
    enum { RUNS = 2001 };
    static uint64_t times[RUNS];
    static uint64_t affinity[RUNS];
    for (int r = 0; r < RUNS; r += 1)
    {
        const uint64_t begin = now_ns();
        count_cores(at, &reads);
        times[r] = now_ns() - begin;
        uint64_t mask[16];
        const uint64_t a = now_ns();
        syscall(SYS_sched_getaffinity, 0, sizeof(mask), mask);
        affinity[r] = now_ns() - a;
    }
    qsort(times, RUNS, sizeof(times[0]), compare);
    qsort(affinity, RUNS, sizeof(affinity[0]), compare);
    printf("%s: %u cores, %u reads; first call %.1f us; median %.1f us, p10 %.1f, p90 %.1f; sched_getaffinity median %.2f us\n", at ? "openat" : "open",
           cores, reads, first / 1e3, times[RUNS / 2] / 1e3, times[RUNS / 10] / 1e3, times[RUNS * 9 / 10] / 1e3, affinity[RUNS / 2] / 1e3);
    return 0;
}
