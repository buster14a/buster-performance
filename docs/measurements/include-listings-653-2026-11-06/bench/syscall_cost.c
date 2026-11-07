// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// The system calls of a directory's first look (#653), each timed alone on a directory: open(O_DIRECTORY), fstatfs,
// fstat, a 1 KB getdents64, close, and a failed open of a name in it. Medians of 2001.
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/statfs.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>

static uint64_t now_ns(void)
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

enum { RUNS = 2001 };
static uint64_t times[6][RUNS];

int main(int argc, char** argv)
{
    for (int a = 1; a < argc; a += 1)
    {
        char missing[4096];
        snprintf(missing, sizeof(missing), "%s/no-such-header.h", argv[a]);
        for (int r = 0; r < RUNS; r += 1)
        {
            uint64_t t0 = now_ns();
            const int fd = open(argv[a], O_RDONLY | O_DIRECTORY | O_CLOEXEC | O_NONBLOCK | O_NOCTTY);
            uint64_t t1 = now_ns();
            struct statfs fs;
            fstatfs(fd, &fs);
            uint64_t t2 = now_ns();
            struct stat st;
            fstat(fd, &st);
            uint64_t t3 = now_ns();
            static char buffer[1024];
            syscall(SYS_getdents64, fd, buffer, sizeof(buffer));
            uint64_t t4 = now_ns();
            close(fd);
            uint64_t t5 = now_ns();
            const int miss = open(missing, O_RDONLY | O_CLOEXEC | O_NONBLOCK | O_NOCTTY);
            uint64_t t6 = now_ns();
            if (miss >= 0)
            {
                close(miss);
            }
            times[0][r] = t1 - t0;
            times[1][r] = t2 - t1;
            times[2][r] = t3 - t2;
            times[3][r] = t4 - t3;
            times[4][r] = t5 - t4;
            times[5][r] = t6 - t5;
        }
        for (int k = 0; k < 6; k += 1)
        {
            qsort(times[k], RUNS, sizeof(uint64_t), compare);
        }
        printf("%-40s open %.2f  fstatfs %.2f  fstat %.2f  getdents(1KB) %.2f  close %.2f  failed open %.2f us\n", argv[a], times[0][RUNS / 2] / 1e3,
               times[1][RUNS / 2] / 1e3, times[2][RUNS / 2] / 1e3, times[3][RUNS / 2] / 1e3, times[4][RUNS / 2] / 1e3, times[5][RUNS / 2] / 1e3);
    }
    return 0;
}
