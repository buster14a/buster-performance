// statcost.c: what a stat of each path given costs on this machine, in TSC ticks and in cycles at the ratio given: each
// path is stat'ed REPEATS times after WARM warm-ups, and the row prints the median, the least and the 90th percentile.
//   statcost CYCLES_A_TICK PATH...
#define _GNU_SOURCE
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <x86intrin.h>

#define REPEATS 4000u
#define WARM 200u

static uint64_t ticks[REPEATS];

static int compare_ticks(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y ? 1 : 0;
}

int main(int argc, char** argv)
{
    const double cycles_a_tick = argc >= 2 ? atof(argv[1]) : 1.0;
    for (int a = 2; a < argc; a += 1)
    {
        struct stat status;
        int result = 0;
        for (uint32_t i = 0; i < WARM + REPEATS; i += 1)
        {
            const uint64_t start = __rdtsc();
            result = stat(argv[a], &status) == 0 ? 0 : errno;
            const uint64_t end = __rdtsc();
            if (i >= WARM)
            {
                ticks[i - WARM] = end - start;
            }
        }
        qsort(ticks, REPEATS, sizeof(ticks[0]), compare_ticks);
        printf("%-96s median %6llu ticks (%7.0f cycles), least %6llu, 90th percentile %6llu; errno %d\n", argv[a], (unsigned long long)ticks[REPEATS / 2],
               (double)ticks[REPEATS / 2] * cycles_a_tick, (unsigned long long)ticks[0], (unsigned long long)ticks[REPEATS * 9 / 10], result);
    }
    return 0;
}
