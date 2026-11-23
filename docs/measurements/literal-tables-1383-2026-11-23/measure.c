// measure CMD...: runs CMD, prints "<wall ms> <child peak RSS KB> <exit status>" to stderr.
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    struct timespec start;
    struct timespec stop;
    int status = 0;
    struct rusage usage = { 0 };
    clock_gettime(CLOCK_MONOTONIC, &start);
    const pid_t child = argc > 1 ? fork() : -1;
    if (child == 0)
    {
        execvp(argv[1], argv + 1);
        _exit(127);
    }
    const int waited = child > 0 ? (int)wait4(child, &status, 0, &usage) : -1;
    clock_gettime(CLOCK_MONOTONIC, &stop);
    const double ms = (double)(stop.tv_sec - start.tv_sec) * 1e3 + (double)(stop.tv_nsec - start.tv_nsec) / 1e6;
    fprintf(stderr, "%.2f %ld %d\n", ms, usage.ru_maxrss, waited > 0 && WIFEXITED(status) ? WEXITSTATUS(status) : -1);
    return waited > 0 && WIFEXITED(status) ? WEXITSTATUS(status) : 1;
}
