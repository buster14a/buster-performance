#define _POSIX_C_SOURCE 200809L
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <x86intrin.h>
static uint64_t ns(void)
{
    struct timespec stamp;
    clock_gettime(CLOCK_MONOTONIC_RAW, &stamp);
    return (uint64_t)stamp.tv_sec * 1000000000 + stamp.tv_nsec;
}
int main(void)
{
    const struct timespec wait = { .tv_nsec = 40000000 };
    for (unsigned i = 0; i < 5; ++i)
    {
        const uint64_t from = ns(), first = __rdtsc();
        nanosleep(&wait, NULL);
        const uint64_t last = __rdtsc(), to = ns();
        printf("ticks=%llu ns=%llu ticks_per_ns=%.6f\n", (unsigned long long)(last - first), (unsigned long long)(to - from), (double)(last - first)/(to - from));
    }
}
