// #1444: the cost of reading /proc/1/stat (PID 1's signal dispositions), as a process's first read and then 10,000
// times, in microseconds.
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

static uint64_t procstat_now(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (uint64_t)now.tv_sec * 1000000000ull + (uint64_t)now.tv_nsec;
}

static long procstat_read(void)
{
    char text[1024];
    const int fd = open("/proc/1/stat", O_RDONLY | O_CLOEXEC);
    const long got = fd >= 0 ? (long)read(fd, text, sizeof(text)) : -1;
    if (fd >= 0)
    {
        close(fd);
    }
    return got;
}

int main(void)
{
    const uint64_t first = procstat_now();
    const long got = procstat_read();
    const uint64_t second = procstat_now();
    for (int i = 0; i < 10000; i += 1)
    {
        procstat_read();
    }
    const uint64_t end = procstat_now();
    printf("first read %.2f us (%ld bytes), then %.2f us each\n", (double)(second - first) / 1e3, got, (double)(end - second) / 1e7);
    return 0;
}
