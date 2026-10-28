#define _GNU_SOURCE
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a) / sizeof((a)[0]))
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include "../issue-652/src/buster/compiler/lane.c"

static double seconds(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return (double)time.tv_sec + (double)time.tv_nsec / 1e9;
}

int main(void)
{
    const uint64_t prefixes[] = {64ull << 10, 256ull << 10, 512ull << 10, 1ull << 20};
    const uint64_t sizes[] = {16ull << 10, 68ull << 10, 256ull << 10, 512ull << 10, 1ull << 20, 8ull << 20};
    unsigned failures = 0;
    for (unsigned s = 0; s < BUSTER_ARRAY_LENGTH(sizes); s += 1)
    {
        for (unsigned p = 0; p < BUSTER_ARRAY_LENGTH(prefixes); p += 1)
        {
            struct rusage before, after;
            getrusage(RUSAGE_SELF, &before);
            const double start = seconds();
            for (unsigned run = 0; run < 101; run += 1)
            {
                Arena arena = arena_reserve_small(64ull << 30, prefixes[p]);
                volatile uint8_t* bytes = arena_push(&arena, sizes[s], 1);
                failures += bytes == NULL;
                if (bytes != NULL)
                {
                    for (uint64_t byte = 0; byte < sizes[s]; byte += 4096)
                        bytes[byte] = (uint8_t)run;
                }
                arena_release(&arena);
            }
            const double elapsed = seconds() - start;
            getrusage(RUSAGE_SELF, &after);
            printf("size=%llu prefix=%llu us=%.3f faults=%ld failures=%u\n", (unsigned long long)sizes[s], (unsigned long long)prefixes[p], elapsed / 101 * 1e6, after.ru_minflt - before.ru_minflt, failures);
        }
    }
    return failures != 0;
}
