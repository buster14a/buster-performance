// #847: what a first touch of a 2 MB region of a MADV_HUGEPAGE mapping gives: a plain store, a load then a store
// (`*byte = *byte` through a volatile pointer), a locked read-modify-write, and a load alone; then a store into another
// 4 KB page of each region, as a lane's next write. Prints each way's microseconds per region and the mapping's
// AnonHugePages.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>

static uint64_t now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000u + (uint64_t)t.tv_nsec;
}

static long anon_huge_kb(const void* p)
{
    FILE* f = fopen("/proc/self/smaps", "r");
    char line[512];
    int inside = 0;
    long kb = -1;
    while (f != 0 && fgets(line, sizeof line, f) != 0)
    {
        unsigned long lo, hi;
        char dash;
        if (sscanf(line, "%lx%c%lx", &lo, &dash, &hi) == 3 && dash == '-')
        {
            inside = (uintptr_t)p >= lo && (uintptr_t)p < hi;
        }
        else if (inside && sscanf(line, "AnonHugePages: %ld kB", &kb) == 1)
        {
            break;
        }
    }
    if (f != 0)
    {
        fclose(f);
    }
    return kb;
}

int main(void)
{
    const size_t region = (size_t)2 << 20;
    const size_t size = (size_t)64 << 20;
    const char* names[] = { "store", "load+store", "locked or", "load" };
    for (int mode = 0; mode < 4; mode += 1)
    {
        uint8_t* mapping = mmap(0, size + region, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
        uint8_t* p = (uint8_t*)(((uintptr_t)mapping + region - 1) & ~(uintptr_t)(region - 1));
        madvise(p, size, MADV_HUGEPAGE);
        const uint64_t t0 = now();
        for (size_t r = 0; r < size; r += region)
        {
            volatile uint8_t* byte = p + r + 100;
            if (mode == 0)
            {
                *byte = 1;
            }
            else if (mode == 1)
            {
                *byte = *byte;
            }
            else if (mode == 2)
            {
                __atomic_fetch_or((uint8_t*)byte, 0, __ATOMIC_RELAXED);
            }
            else
            {
                (void)*byte;
            }
        }
        const uint64_t t1 = now();
        const long after_first = anon_huge_kb(p);
        for (size_t r = 0; r < size; r += region)
        {
            ((volatile uint8_t*)p)[r + 8192] = 2;
        }
        const uint64_t t2 = now();
        printf("%-10s first touch %6.2f us/region, AnonHugePages %6ld kB; next store %6.2f us/region, AnonHugePages %6ld kB\n", names[mode],
               (double)(t1 - t0) / 1e3 / (double)(size / region), after_first, (double)(t2 - t1) / 1e3 / (double)(size / region), anon_huge_kb(p));
        munmap(mapping, size + region);
    }
    return 0;
}
