// #1444: what a first touch of an anonymous base page costs on this host, against populating the same pages in one call.
// Each round maps a fresh region of N pages (MADV_NOHUGEPAGE) and touches it one way, then unmaps it:
//   write     a write to each page (one fault each)
//   read      a read then a write of each page (two faults: the zero page, then a copy)
//   populate  one madvise(MADV_POPULATE_WRITE) over the region, then a write to each page
//   scatter   process_madvise(MADV_POPULATE_WRITE) of every 8th page as its own range, then a write to those pages
//   scatter-w a write to every 8th page
// Prints the median ns per touched page over ROUNDS rounds.
//   populate PAGES ROUNDS
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/uio.h>
#include <time.h>
#include <unistd.h>

#ifndef MADV_POPULATE_WRITE
#define MADV_POPULATE_WRITE 23
#endif

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
    return x < y ? -1 : x > y;
}

int main(int argc, char** argv)
{
    const size_t pages = argc > 1 ? strtoul(argv[1], 0, 10) : 64;
    const int rounds = argc > 2 ? atoi(argv[2]) : 200;
    const char* names[] = { "write", "read", "populate", "scatter", "scatter-w" };
    uint64_t* times = calloc((size_t)rounds, sizeof(uint64_t));
    int pidfd = (int)syscall(SYS_pidfd_open, getpid(), 0);
    struct iovec* iov = calloc(pages, sizeof(struct iovec));
    for (int mode = 0; mode < 5; mode += 1)
    {
        size_t touched = mode >= 3 ? (pages + 7) / 8 : pages;
        long failed = 0;
        for (int r = 0; r < rounds; r += 1)
        {
            volatile uint8_t* p = mmap(0, pages * 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
            madvise((void*)p, pages * 4096, MADV_NOHUGEPAGE);
            const uint64_t t0 = now();
            if (mode == 0)
            {
                for (size_t i = 0; i < pages; i += 1) p[i * 4096] = 1;
            }
            else if (mode == 1)
            {
                uint8_t s = 0;
                for (size_t i = 0; i < pages; i += 1) s += p[i * 4096 + 64];
                for (size_t i = 0; i < pages; i += 1) p[i * 4096] = s;
            }
            else if (mode == 2)
            {
                failed += madvise((void*)p, pages * 4096, MADV_POPULATE_WRITE) != 0;
                for (size_t i = 0; i < pages; i += 1) p[i * 4096] = 1;
            }
            else if (mode == 3)
            {
                size_t n = 0;
                for (size_t i = 0; i < pages; i += 8) iov[n++] = (struct iovec){ (void*)(p + i * 4096), 4096 };
                failed += syscall(SYS_process_madvise, pidfd, iov, n, MADV_POPULATE_WRITE, 0) < 0;
                for (size_t i = 0; i < pages; i += 8) p[i * 4096] = 1;
            }
            else
            {
                for (size_t i = 0; i < pages; i += 8) p[i * 4096] = 1;
            }
            times[r] = now() - t0;
            munmap((void*)p, pages * 4096);
        }
        qsort(times, (size_t)rounds, sizeof(uint64_t), compare);
        printf("%-10s %4zu pages touched: %7.1f ns per page (median %lu ns)%s\n", names[mode], touched, (double)times[rounds / 2] / (double)touched, (unsigned long)times[rounds / 2], failed ? " FAILED" : "");
    }
    return 0;
}
