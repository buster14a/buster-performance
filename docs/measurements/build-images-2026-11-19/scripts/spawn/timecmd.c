// timecmd CMD ARGS...: runs a command and prints its wall time, its (and its children's) user and system time,
// and page faults. A stand-in for /usr/bin/time, which this container lacks.
#define _GNU_SOURCE
#include <spawn.h>
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
extern char** environ;
int main(int argc, char** argv)
{
    struct timespec a, b;
    clock_gettime(CLOCK_MONOTONIC, &a);
    pid_t pid;
    if (posix_spawnp(&pid, argv[1], 0, 0, argv + 1, environ) != 0) { perror("spawn"); return 127; }
    int status;
    struct rusage r;
    wait4(pid, &status, 0, &r);
    clock_gettime(CLOCK_MONOTONIC, &b);
    double wall = (double)(b.tv_sec - a.tv_sec) + (double)(b.tv_nsec - a.tv_nsec) * 1e-9;
    struct rusage c;
    getrusage(RUSAGE_CHILDREN, &c);
    fprintf(stdout, "timecmd: %.3f s wall, %.3f s user, %.3f s sys, %ld minor %ld major faults, %ld KB peak, status %d\n", wall,
        (double)c.ru_utime.tv_sec + (double)c.ru_utime.tv_usec * 1e-6, (double)c.ru_stime.tv_sec + (double)c.ru_stime.tv_usec * 1e-6,
        c.ru_minflt, c.ru_majflt, r.ru_maxrss, WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status));
    return WIFEXITED(status) ? WEXITSTATUS(status) : 1;
}
