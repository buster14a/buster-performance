#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/mman.h>
static uint64_t now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return (uint64_t)t.tv_sec * 1000000000ull + t.tv_nsec; }
int main(void)
{
    const uint64_t bytes = 1300 * 1024;
    uint8_t* p = mmap(0, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    for (uint64_t i = 0; i < bytes; i += 4096) p[i] = 1;
    for (int r = 0; r < 5; r += 1)
    {
        uint64_t t0 = now();
        madvise(p, bytes, 23);
        uint64_t t1 = now();
        // 32 calls over pieces, as a binding's columns would
        for (int c = 0; c < 32; c += 1) madvise(p + c * (bytes / 32 & ~4095ull), bytes / 32 & ~4095ull, 23);
        uint64_t t2 = now();
        printf("present: one call %.1f us, 32 calls %.1f us\n", (t1 - t0) / 1000.0, (t2 - t1) / 1000.0);
    }
    return 0;
}
