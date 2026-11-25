// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Measure one fresh executable inside the host lock. Include fork, exec and exit.
#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static long long micros(struct timeval t)
{
    return (long long)t.tv_sec * 1000000 + t.tv_usec;
}

int main(int argc, char** argv)
{
    struct timespec begin, end;
    if (argc < 2 || clock_gettime(CLOCK_MONOTONIC, &begin) != 0) { return 1; }
    const pid_t child = fork();
    if (child == 0)
    {
        execv(argv[1], argv + 1);
        _exit(127);
    }
    if (child < 0) { perror("fork"); return 1; }
    int status;
    pid_t waited;
    struct rusage usage;
    do { waited = wait4(child, &status, 0, &usage); } while (waited < 0 && errno == EINTR);
    if (waited < 0 || clock_gettime(CLOCK_MONOTONIC, &end) != 0) { return 1; }
    if (!WIFEXITED(status) || WEXITSTATUS(status) != 0)
    {
        fprintf(stderr, "compiler wait status %d\n", status);
        return 1;
    }
    const double ms = (end.tv_sec - begin.tv_sec) * 1000.0 + (end.tv_nsec - begin.tv_nsec) * 1e-6;
    printf("%.6f\t%lld\t%lld\t%ld\t%ld\t%ld\n", ms, micros(usage.ru_utime), micros(usage.ru_stime),
           usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt);
    return 0;
}
