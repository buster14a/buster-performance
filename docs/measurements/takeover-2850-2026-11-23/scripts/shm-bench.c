// shm-bench MODE BYTES [FILE]: what first touches cost by where the pages come from (#2850, the pool file's premise).
//   anon   fresh anonymous memory, advised huge: the kernel clears each 2 MB page at its first touch.
//   make   a tmpfs file, advised huge: written whole and left (the file a previous process leaves).
//   reuse  that file mapped again: its pages exist, nothing is cleared.
// Touches one byte a 4 KB page (a write), and prints the nanoseconds and the page faults taken.
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <time.h>
#include <unistd.h>

static uint64_t now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000ull + (uint64_t)t.tv_nsec;
}

int main(int argc, char** argv)
{
    int result = 1;
    if (argc >= 3)
    {
        const char* mode = argv[1];
        const uint64_t bytes = strtoull(argv[2], 0, 0);
        const int file = strcmp(mode, "anon") != 0;
        const int fd = file && argc >= 4 ? open(argv[3], O_RDWR | O_CREAT, 0600) : -1;
        const int sized = !file || (fd >= 0 && ftruncate(fd, (off_t)bytes) == 0);
        // 2 MB aligned, as the arenas' huge parts are.
        uint8_t* reserved = sized ? mmap(0, bytes + (2u << 20), PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0) : MAP_FAILED;
        uint8_t* at = reserved != MAP_FAILED ? (uint8_t*)(((uintptr_t)reserved + (2u << 20) - 1) & ~(uintptr_t)((2u << 20) - 1)) : 0;
        uint8_t* base = at != 0 ? mmap(at, bytes, PROT_READ | PROT_WRITE, (file ? MAP_SHARED : MAP_PRIVATE | MAP_ANONYMOUS) | MAP_FIXED, file ? fd : -1, 0) : MAP_FAILED;
        if (base != MAP_FAILED)
        {
            madvise(base, bytes, MADV_HUGEPAGE);
            struct rusage before, after;
            getrusage(RUSAGE_SELF, &before);
            const uint64_t start = now();
            uint64_t sum = 0;
            for (uint64_t i = 0; i < bytes; i += 4096)
            {
                sum += base[i];
                base[i] = (uint8_t)(i >> 12);
            }
            const uint64_t end = now();
            getrusage(RUSAGE_SELF, &after);
            printf("%s %llu MB: %.3f ms, %ld faults, %.3f ms system, read sum %llu\n", mode, (unsigned long long)(bytes >> 20), (double)(end - start) / 1e6,
                   after.ru_minflt - before.ru_minflt,
                   (double)((after.ru_stime.tv_sec - before.ru_stime.tv_sec) * 1000000 + (after.ru_stime.tv_usec - before.ru_stime.tv_usec)) / 1e3, (unsigned long long)sum);
            result = 0;
        }
        else
        {
            perror("mmap");
        }
    }
    return result;
}
