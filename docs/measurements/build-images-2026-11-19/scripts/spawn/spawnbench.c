// Spawns a program N times one after another (as a build tool would, one job at a time) and reports the mean
// wall time and the children's user and system time per spawn.
#define _GNU_SOURCE
#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
extern char** environ;
static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (double)t.tv_sec + (double)t.tv_nsec * 1e-9;
}
int main(int argc, char** argv)
{
    int n = atoi(argv[1]);
    double t0 = now();
    for (int i = 0; i < n; i += 1)
    {
        pid_t pid;
        if (posix_spawn(&pid, argv[2], 0, 0, argv + 2, environ) != 0) { perror("spawn"); return 1; }
        int status;
        waitpid(pid, &status, 0);
    }
    double t1 = now();
    struct rusage r;
    getrusage(RUSAGE_CHILDREN, &r);
    double user = (double)r.ru_utime.tv_sec + (double)r.ru_utime.tv_usec * 1e-6;
    double sys = (double)r.ru_stime.tv_sec + (double)r.ru_stime.tv_usec * 1e-6;
    printf("%s: %.1f us wall, %.1f us user, %.1f us sys a spawn\n", argv[2], (t1 - t0) * 1e6 / n, user * 1e6 / n, sys * 1e6 / n);
    return 0;
}
