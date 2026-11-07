// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// What a failed include probe costs against reading a directory's names once (#653).
// For each directory argument: the time of an open of a name the directory doesn't have (the probe the include search
// makes), and of an open, getdents64 to the end, and a close, with every name hashed into a set (the listing).
#define _GNU_SOURCE
#include <dirent.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

static uint64_t slots[1 << 16];

static uint32_t list_directory(const char* directory)
{
    static char buffer[32768];
    const int fd = open(directory, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
    uint32_t count = 0;
    if (fd >= 0)
    {
        memset(slots, 0, sizeof(slots));
        long got = 1;
        while (got > 0)
        {
            got = syscall(SYS_getdents64, fd, buffer, sizeof(buffer));
            for (long offset = 0; offset < got;)
            {
                const struct dirent64* entry = (const struct dirent64*)(buffer + offset);
                uint64_t hash = 14695981039346656037ull;
                for (const char* c = entry->d_name; *c != 0; c += 1)
                {
                    hash = (hash ^ (uint8_t)*c) * 1099511628211ull;
                }
                uint32_t slot = (uint32_t)hash & 0xFFFF;
                while (slots[slot] != 0)
                {
                    slot = (slot + 1) & 0xFFFF;
                }
                slots[slot] = hash | 1;
                count += 1;
                offset += entry->d_reclen;
            }
        }
        close(fd);
    }
    return count;
}

int main(int argc, char** argv)
{
    enum { RUNS = 2001 };
    static uint64_t times[RUNS];
    for (int a = 1; a < argc; a += 1)
    {
        char path[4096];
        for (int r = 0; r < RUNS; r += 1)
        {
            snprintf(path, sizeof(path), "%s/no-such-header-%d.h", argv[a], r);
            const uint64_t start = now_ns();
            const int fd = open(path, O_RDONLY | O_CLOEXEC | O_NONBLOCK | O_NOCTTY);
            times[r] = now_ns() - start;
            if (fd >= 0)
            {
                close(fd);
            }
        }
        qsort(times, RUNS, sizeof(times[0]), compare);
        const uint64_t probe = times[RUNS / 2];
        uint32_t entries = 0;
        for (int r = 0; r < RUNS; r += 1)
        {
            const uint64_t start = now_ns();
            entries = list_directory(argv[a]);
            times[r] = now_ns() - start;
        }
        qsort(times, RUNS, sizeof(times[0]), compare);
        printf("%-48s entries %5u  failed probe %6.2f us  listing %8.2f us  ratio %6.1f\n", argv[a], entries, probe / 1000.0, times[RUNS / 2] / 1000.0,
               (double)times[RUNS / 2] / (double)probe);
    }
    return 0;
}
