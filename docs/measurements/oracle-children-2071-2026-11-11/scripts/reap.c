// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Runs a command as a child subreaper's child (PR_SET_CHILD_SUBREAPER) and prints two CPU times: the command's, as its
// parent's wait gives it (the processes it and its descendants waited for: what the parallel runner's rusage counts),
// and then with every orphan the command left, which the subreaper adopts and waits for as well. Their difference is
// the CPU time of processes that outlived the process that started them (a forked part's clang server, before
// oracle_serve_exit), which a runner without a subreaper never counts.
// Build: clang -O2 -o reap reap.c. Usage: reap COMMAND [ARGUMENT...]; prints "wall S command_cpu S with_orphans_cpu S
// orphans N" on standard error and exits with the command's status.
#include <errno.h>
#include <stdio.h>
#include <sys/prctl.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static double seconds(const struct rusage* usage)
{
    return (double)usage->ru_utime.tv_sec + (double)usage->ru_utime.tv_usec / 1e6 + (double)usage->ru_stime.tv_sec + (double)usage->ru_stime.tv_usec / 1e6;
}

int main(int argc, char** argv)
{
    struct timespec start;
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    const int adopted = argc > 1 ? prctl(PR_SET_CHILD_SUBREAPER, 1, 0, 0, 0) : -1;
    const pid_t child = adopted == 0 ? fork() : -1;
    if (child == 0)
    {
        execvp(argv[1], argv + 1);
        _exit(127);
    }
    int status = 0;
    pid_t waited = -1;
    do
    {
        waited = child > 0 ? waitpid(child, &status, 0) : 0;
    }
    while (waited < 0 && errno == EINTR);
    clock_gettime(CLOCK_MONOTONIC, &end);
    struct rusage command = { 0 };
    getrusage(RUSAGE_CHILDREN, &command);
    unsigned orphans = 0;
    pid_t reaped = 0;
    while ((reaped = wait(0)) > 0 || (reaped < 0 && errno == EINTR))
    {
        orphans += reaped > 0;
    }
    struct rusage all = { 0 };
    getrusage(RUSAGE_CHILDREN, &all);
    const double wall = (double)(end.tv_sec - start.tv_sec) + (double)(end.tv_nsec - start.tv_nsec) / 1e9;
    fprintf(stderr, "wall %.2f command_cpu %.2f with_orphans_cpu %.2f orphans %u\n", wall, seconds(&command), seconds(&all), orphans);
    return waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 1;
}
