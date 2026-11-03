// discard.c: per-region madvise(MADV_DONTNEED) against one process_madvise of all regions, with spinning threads.
#define _GNU_SOURCE
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/uio.h>
#include <time.h>
#include <unistd.h>

static atomic_int stop;
static void* spin(void* argument)
{
    volatile uint64_t* counter = argument;
    while (!atomic_load_explicit(&stop, memory_order_relaxed))
    {
        *counter += 1;
    }
    return 0;
}

static uint64_t now_ns(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000ull + (uint64_t)t.tv_nsec;
}

int main(int argc, char** argv)
{
    const int regions = argc > 1 ? atoi(argv[1]) : 68;
    const int pages = argc > 2 ? atoi(argv[2]) : 4;
    const int threads = argc > 3 ? atoi(argv[3]) : 0;
    const int rounds = argc > 4 ? atoi(argv[4]) : 2000;
    const size_t bytes = 1ull << 20;
    uint8_t** base = calloc(regions, sizeof(*base));
    struct iovec* vector = calloc(regions, sizeof(*vector));
    for (int i = 0; i < regions; i += 1)
    {
        base[i] = mmap(0, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        madvise(base[i], bytes, MADV_NOHUGEPAGE);
        vector[i] = (struct iovec){ .iov_base = base[i], .iov_len = bytes };
    }
    pthread_t* workers = calloc(threads + 1, sizeof(*workers));
    uint64_t* counters = calloc((threads + 1) * 8, sizeof(*counters));
    for (int t = 0; t < threads; t += 1)
    {
        pthread_create(&workers[t], 0, spin, &counters[t * 8]);
    }
    const int pidfd = argc > 5 ? -10000 : (int)syscall(SYS_pidfd_open, getpid(), 0);
    for (int mode = 0; mode < 2; mode += 1)
    {
        uint64_t discard = 0;
        long result = 0;
        for (int r = 0; r < rounds; r += 1)
        {
            for (int i = 0; i < regions; i += 1)
            {
                for (int p = 0; p < pages; p += 1)
                {
                    base[i][p * 4096] = 1;
                }
            }
            const uint64_t start = now_ns();
            if (mode == 0)
            {
                for (int i = 0; i < regions; i += 1)
                {
                    result |= madvise(base[i], bytes, MADV_DONTNEED);
                }
            }
            else
            {
                const long done = syscall(SYS_process_madvise, pidfd, vector, regions, MADV_DONTNEED, 0);
                result |= done == (long)(bytes * regions) ? 0 : -1;
            }
            discard += now_ns() - start;
        }
        printf("%s: regions %d, pages %d, threads %d: %.2f us per round%s\n", mode == 0 ? "madvise each" : "process_madvise", regions, pages, threads,
               discard / 1000.0 / rounds, result != 0 ? " (FAILED)" : "");
    }
    atomic_store(&stop, 1);
    for (int t = 0; t < threads; t += 1)
    {
        pthread_join(workers[t], 0);
    }
    return 0;
}
