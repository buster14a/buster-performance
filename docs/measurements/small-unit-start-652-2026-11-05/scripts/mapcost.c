// What an arena's reservation and first commit cost: mmap of 64 GB PROT_NONE, mprotect of its first 64 KB, a write to
// its first page, munmap; and the same with N arenas carved out of one mapping.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <time.h>
static double now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return t.tv_sec * 1e9 + t.tv_nsec; }
int main(int argc, char** argv)
{
    const int rounds = 2000, arenas = 27;
    const uint64_t size = 64ull << 30;
    double t0, t1;
    struct rlimit r;
    t0 = now(); for (int i = 0; i < rounds * arenas; i += 1) getrlimit(RLIMIT_AS, &r); t1 = now();
    printf("getrlimit: %.0f ns\n", (t1 - t0) / (rounds * arenas));
    uint8_t* maps[64];
    double map = 0, commit = 0, touch = 0, unmap = 0;
    for (int i = 0; i < rounds; i += 1)
    {
        t0 = now(); for (int a = 0; a < arenas; a += 1) maps[a] = mmap(0, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0); t1 = now(); map += t1 - t0;
        t0 = now(); for (int a = 0; a < arenas; a += 1) mprotect(maps[a] + 4096, 65536, PROT_READ | PROT_WRITE); t1 = now(); commit += t1 - t0;
        t0 = now(); for (int a = 0; a < arenas; a += 1) maps[a][4096] = 1; t1 = now(); touch += t1 - t0;
        t0 = now(); for (int a = 0; a < arenas; a += 1) munmap(maps[a], size); t1 = now(); unmap += t1 - t0;
    }
    printf("separate: mmap %.0f ns, mprotect %.0f ns, first touch %.0f ns, munmap %.0f ns per arena\n", map / (rounds * arenas), commit / (rounds * arenas), touch / (rounds * arenas), unmap / (rounds * arenas));
    map = commit = touch = unmap = 0;
    for (int i = 0; i < rounds; i += 1)
    {
        t0 = now(); uint8_t* one = mmap(0, size * arenas, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0); t1 = now(); map += t1 - t0;
        t0 = now(); for (int a = 0; a < arenas; a += 1) mprotect(one + a * size + 4096, 65536, PROT_READ | PROT_WRITE); t1 = now(); commit += t1 - t0;
        t0 = now(); for (int a = 0; a < arenas; a += 1) one[a * size + 4096] = 1; t1 = now(); touch += t1 - t0;
        t0 = now(); munmap(one, size * arenas); t1 = now(); unmap += t1 - t0;
    }
    printf("carved:   mmap %.0f ns, mprotect %.0f ns, first touch %.0f ns, munmap %.0f ns per arena\n", map / (rounds * arenas), commit / (rounds * arenas), touch / (rounds * arenas), unmap / (rounds * arenas));
    map = commit = touch = unmap = 0;
    // One writable mapping with all the arenas' first 64 KB adjacent (one commit), as one table arena does.
    for (int i = 0; i < rounds; i += 1)
    {
        t0 = now(); uint8_t* one = mmap(0, 65536 * arenas, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0); t1 = now(); map += t1 - t0;
        t0 = now(); mprotect(one, 65536 * arenas, PROT_READ | PROT_WRITE); t1 = now(); commit += t1 - t0;
        t0 = now(); for (int a = 0; a < arenas; a += 1) one[a * 65536] = 1; t1 = now(); touch += t1 - t0;
        t0 = now(); munmap(one, 65536 * arenas); t1 = now(); unmap += t1 - t0;
    }
    printf("tables:   mmap %.0f ns, mprotect %.0f ns, first touch %.0f ns, munmap %.0f ns per arena\n", map / (rounds * arenas), commit / (rounds * arenas), touch / (rounds * arenas), unmap / (rounds * arenas));
    return 0;
}
