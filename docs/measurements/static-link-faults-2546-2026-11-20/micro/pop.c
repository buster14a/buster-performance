#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/resource.h>
#ifndef MADV_POPULATE_READ
#define MADV_POPULATE_READ 22
#endif
static uint64_t now(void) { struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t); return (uint64_t)t.tv_sec * 1000000000ull + t.tv_nsec; }
static long minflt(void) { struct rusage u; getrusage(RUSAGE_SELF, &u); return u.ru_minflt; }
static uint32_t first[4096], count[4096]; static int n;
static volatile uint64_t sink;
static void run(const char* path, int mode)
{
    int fd = open(path, O_RDONLY); struct stat st; fstat(fd, &st);
    uint8_t* p = mmap(0, st.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0); close(fd);
    long f0 = minflt(); uint64_t t0 = now();
    if (mode == 1) for (int i = 0; i < n; i += 1) madvise(p + ((uint64_t)first[i] << 12), (uint64_t)count[i] << 12, MADV_POPULATE_READ);
    if (mode == 2) madvise(p + ((uint64_t)first[0] << 12), ((uint64_t)(first[n - 1] + count[n - 1] - first[0])) << 12, MADV_POPULATE_READ);
    uint64_t s = 0;
    for (int i = 0; i < n; i += 1) for (uint32_t k = 0; k < count[i]; k += 1) s += p[((uint64_t)(first[i] + k)) << 12];
    sink = s;
    uint64_t t1 = now(); long f1 = minflt();
    printf("mode %d: %7.1f us %4ld faults\n", mode, (t1 - t0) / 1000.0, f1 - f0);
}
int main(int argc, char** argv)
{
    FILE* r = fopen(argv[2], "r"); while (fscanf(r, "%u %u", &first[n], &count[n]) == 2) n += 1;
    for (int mode = 0; mode < 3; mode += 1) for (int k = 0; k < atoi(argv[3]); k += 1) { pid_t c = fork(); if (c == 0) { run(argv[1], mode); fflush(stdout); _exit(0); } waitpid(c, 0, 0); }
    return 0;
}
