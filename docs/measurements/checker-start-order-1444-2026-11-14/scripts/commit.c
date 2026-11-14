// #1444 item 1: what an arena's first commit costs on this host, against the ways the 2026-11-08 design allows.
// Each iteration reserves 64 GiB, makes its first 64 KB writable, writes one byte in each of its 16 pages, and unmaps
// it; the medians of ITERATIONS, in ns, of the reservation and commit together, of the 16 writes, of the unmap and of
// the whole, for each way:
//   none+mprotect   mmap PROT_NONE, then mprotect of the first 64 KB (the arenas' way);
//   rw-stack        mmap PROT_READ|PROT_WRITE, MAP_NORESERVE|MAP_STACK (base pages from the mapping, one call);
//   two-mmaps       mmap PROT_NONE, then mmap MAP_FIXED of the first 64 KB writable over it;
//   none-only       mmap PROT_NONE and munmap: the reservation alone, no commit or write.
// Pinned by the caller (taskset); 64 extra mappings stand in for a compiler's.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <time.h>

#define RESERVE (64ull << 30)
#define FIRST (64u << 10)
#define ITERATIONS 4000

static uint64_t now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000ull + (uint64_t)t.tv_nsec;
}

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return (x > y) - (x < y);
}

static void touch(char* base)
{
    for (uint32_t i = 0; i < FIRST; i += 4096)
    {
        base[i] = 1;
    }
}

int main(void)
{
    static uint64_t times[4][ITERATIONS];
    for (int i = 0; i < 64; i += 1)
    {
        void* filler = mmap(0, 1 << 20, i & 1 ? PROT_NONE : PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
        (void)filler;
    }
    const char* names[] = { "none+mprotect", "rw-stack", "two-mmaps", "none-only" };
    int failed = 0;
    for (int way = 0; way < 4; way += 1)
    {
        for (int i = 0; i < ITERATIONS; i += 1)
        {
            const uint64_t start = now();
            uint64_t committed = 0;
            uint64_t touched = 0;
            char* base = 0;
            if (way == 1)
            {
                base = mmap(0, RESERVE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE | MAP_STACK, -1, 0);
            }
            else
            {
                base = mmap(0, RESERVE, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
            }
            failed |= base == MAP_FAILED;
            if (way == 0)
            {
                failed |= mprotect(base, FIRST, PROT_READ | PROT_WRITE) != 0;
            }
            else if (way == 2)
            {
                failed |= mmap(base, FIRST, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED | MAP_STACK, -1, 0) != base;
            }
            committed = now();
            if (way != 3)
            {
                touch(base);
            }
            touched = now();
            munmap(base, RESERVE);
            const uint64_t end = now();
            times[0][i] = committed - start;
            times[1][i] = touched - committed;
            times[2][i] = end - touched;
            times[3][i] = end - start;
        }
        for (int k = 0; k < 4; k += 1)
        {
            qsort(times[k], ITERATIONS, sizeof(times[k][0]), compare);
        }
        printf("%-14s map+commit %6llu  writes %6llu  unmap %6llu  whole %6llu ns (median)\n", names[way], (unsigned long long)times[0][ITERATIONS / 2],
               (unsigned long long)times[1][ITERATIONS / 2], (unsigned long long)times[2][ITERATIONS / 2], (unsigned long long)times[3][ITERATIONS / 2]);
    }
    printf("failed: %d\n", failed);
    return failed;
}
