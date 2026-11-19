// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#define _GNU_SOURCE
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static uint64_t nanoseconds(void)
{
    struct timespec t;
    if (clock_gettime(CLOCK_MONOTONIC_RAW, &t)) abort();
    return (uint64_t)t.tv_sec * 1000000000u + (uint64_t)t.tv_nsec;
}

static double milliseconds(struct timeval t)
{
    return t.tv_sec * 1000.0 + t.tv_usec / 1000.0;
}

int main(int argc, char** argv)
{
    if (argc < 3) return 2;
    uint64_t start = nanoseconds();
    pid_t child = fork();
    if (child == 0)
    {
        execv(argv[2], argv + 2);
        _exit(127);
    }
    if (child < 0) return 2;
    int status;
    struct rusage usage;
    pid_t waited;
    do { waited = wait4(child, &status, 0, &usage); } while (waited < 0 && errno == EINTR);
    uint64_t end = nanoseconds();
    if (waited < 0) return 2;
    FILE* out = fopen(argv[1], "w");
    if (!out) return 2;
    fprintf(out,"%.6f %.3f %.3f %ld %ld %ld %ld\n", (end-start)/1e6, milliseconds(usage.ru_utime),
            milliseconds(usage.ru_stime), usage.ru_minflt, usage.ru_majflt, usage.ru_nivcsw, usage.ru_maxrss);
    if (fclose(out)) return 2;
    return WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
}
