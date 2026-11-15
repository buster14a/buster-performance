// Runs every shape's kernel for one source and size (gen.c), CALLS calls a repeat, the shapes in a rotating order each
// repeat, and prints each one's median user cycles, instructions and ls_bad_status2.stli_other per call (#2693).
// Usage: bench SOURCE [SIZE [REPEATS]]: every size (16 to 256) where SIZE is 0 or absent. The drivers are #1375's record's (dassign.c, dcold.c): a fixed destination read
// back after the call for a built source, 64 cold sources and destinations for the others.
#define _GNU_SOURCE
#include <linux/perf_event.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <unistd.h>
#include "kernels.h"

#define CALLS 20000000L

static long table[64][32] __attribute__((aligned(64)));
static long outs[64][32] __attribute__((aligned(64)));
static long g[32] __attribute__((aligned(64)));

static int open_counter(uint32_t type, uint64_t config, int group)
{
    struct perf_event_attr attr;
    memset(&attr, 0, sizeof(attr));
    attr.size = sizeof(attr);
    attr.type = type;
    attr.config = config;
    attr.disabled = group == -1;
    attr.exclude_kernel = 1;
    attr.exclude_hv = 1;
    attr.read_format = PERF_FORMAT_GROUP;
    return (int)syscall(SYS_perf_event_open, &attr, 0, -1, group, 0);
}

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static int run(const char* source, unsigned size, int repeats);

int main(int argc, char** argv)
{
    const char* source = argc > 1 ? argv[1] : "cold";
    const unsigned only = argc > 2 ? (unsigned)atoi(argv[2]) : 0;
    const int repeats = argc > 3 ? atoi(argv[3]) : 5;
    int status = 0;
    for (unsigned z = 0; z < 5 && status == 0; z += 1)
    {
        const unsigned size = 16u << z;
        if (only == 0 || only == size)
        {
            status = run(source, size, repeats);
        }
    }
    return status;
}

static int run(const char* source, unsigned size, int repeats)
{
    const long calls = strcmp(source, "far") == 0 ? CALLS / 8 : CALLS;
    const unsigned last = size / 8 - 1;
    for (int t = 0; t < 64; t += 1)
    {
        for (int i = 0; i < 32; i += 1)
        {
            table[t][i] = t * 100 + i;
        }
    }
    int leader = open_counter(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CPU_CYCLES, -1);
    int instructions = open_counter(PERF_TYPE_HARDWARE, PERF_COUNT_HW_INSTRUCTIONS, leader);
    int stli = open_counter(PERF_TYPE_RAW, 0x224, leader);
    if (leader < 0 || instructions < 0 || stli < 0)
    {
        perror("perf_event_open");
        return 1;
    }
    unsigned picked[16];
    unsigned count = 0;
    for (unsigned k = 0; k < sizeof(kernels) / sizeof(kernels[0]); k += 1)
    {
        if (strcmp(kernels[k].source, source) == 0 && kernels[k].size == size)
        {
            picked[count] = k;
            count += 1;
        }
    }
    static double cycles[16][64];
    static double retired[16][64];
    static double conflicts[16][64];
    long sums[16];
    for (int r = 0; r < repeats; r += 1)
    {
        for (unsigned j = 0; j < count; j += 1)
        {
            const unsigned p = (j + (unsigned)r) % count;
            Kernel* run = kernels[picked[p]].run;
            long s = 0;
            ioctl(leader, PERF_EVENT_IOC_RESET, PERF_IOC_FLAG_GROUP);
            ioctl(leader, PERF_EVENT_IOC_ENABLE, PERF_IOC_FLAG_GROUP);
            if (strcmp(source, "built") == 0 || strcmp(source, "built4") == 0 || strcmp(source, "far") == 0)
            {
                for (long i = 0; i < calls; i += 1)
                {
                    run(g, 0, i);
                    s += g[last];
                }
            }
            else
            {
                for (long i = 0; i < calls; i += 1)
                {
                    run(outs[i & 63], table[(i * 7) & 63], i);
                    s += outs[(i - 32) & 63][last];
                }
            }
            ioctl(leader, PERF_EVENT_IOC_DISABLE, PERF_IOC_FLAG_GROUP);
            uint64_t values[4];
            if (read(leader, values, sizeof(values)) < (ssize_t)(4 * sizeof(uint64_t)))
            {
                perror("read");
                return 1;
            }
            cycles[p][r] = (double)values[1] / (double)calls;
            retired[p][r] = (double)values[2] / (double)calls;
            conflicts[p][r] = (double)values[3] / (double)calls;
            sums[p] = s;
        }
    }
    for (unsigned p = 0; p < count; p += 1)
    {
        qsort(cycles[p], (size_t)repeats, sizeof(double), compare);
        qsort(retired[p], (size_t)repeats, sizeof(double), compare);
        qsort(conflicts[p], (size_t)repeats, sizeof(double), compare);
        printf("%s\t%u\t%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.3f\t%ld\n", source, size, kernels[picked[p]].shape, cycles[p][repeats / 2], cycles[p][0], cycles[p][repeats - 1], retired[p][repeats / 2],
               conflicts[p][repeats / 2], sums[p]);
    }
    fflush(stdout);
    close(stli);
    close(instructions);
    close(leader);
    return 0;
}
