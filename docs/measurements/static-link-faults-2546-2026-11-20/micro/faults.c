#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/resource.h>
#ifndef MADV_POPULATE_READ
#define MADV_POPULATE_READ 22
#define MADV_POPULATE_WRITE 23
#endif
static uint64_t now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return (uint64_t)t.tv_sec * 1000000000ull + t.tv_nsec; }
static long minflt(void) { struct rusage u; getrusage(RUSAGE_SELF, &u); return u.ru_minflt; }
static const char* path;
static volatile uint64_t sink;
static void run(int mode)
{
    long f0 = minflt();
    uint64_t t0 = now();
    const uint64_t anon = 1300 * 1024;
    if (mode == 0 || mode == 1)
    {
        uint8_t* p = mmap(0, anon, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (mode == 1) madvise(p, anon, MADV_POPULATE_WRITE);
        for (uint64_t i = 0; i < anon; i += 4096) p[i] = 1;
    }
    else
    {
        int fd = open(path, O_RDONLY);
        struct stat st; fstat(fd, &st);
        int prot = (mode == 2 || mode == 4) ? PROT_READ | PROT_WRITE : PROT_READ;
        int flags = MAP_PRIVATE | (mode == 5 ? MAP_POPULATE : 0);
        uint8_t* p = mmap(0, st.st_size, prot, flags, fd, 0);
        close(fd);
        if (mode == 4 || mode == 6) madvise(p, st.st_size, MADV_POPULATE_READ);
        uint64_t s = 0;
        // touch the file's pages from 3 MB to its end, a page at a time (the members' records a link reads)
        for (uint64_t i = 3 << 20; i < (uint64_t)st.st_size; i += 4096) s += p[i];
        sink = s;
    }
    uint64_t t1 = now();
    long f1 = minflt();
    printf("mode %d: %8.1f us, %4ld faults\n", mode, (t1 - t0) / 1000.0, f1 - f0);
}
int main(int argc, char** argv)
{
    path = argv[1];
    int reps = atoi(argv[2]);
    for (int mode = 0; mode <= 6; mode += 1)
    {
        for (int r = 0; r < reps; r += 1)
        {
            pid_t c = fork();
            if (c == 0) { run(mode); fflush(stdout); _exit(0); }
            waitpid(c, 0, 0);
        }
    }
    return 0;
}
