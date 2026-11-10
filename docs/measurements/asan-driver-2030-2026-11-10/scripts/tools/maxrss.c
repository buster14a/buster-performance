// Runs a command and prints its peak resident set (wait4's ru_maxrss, KB) and wall time to stderr:
//   maxrss LABEL COMMAND ARGUMENTS...
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>
int main(int argc, char** argv)
{
    int result = 2;
    if (argc > 2)
    {
        struct timespec begin;
        clock_gettime(CLOCK_MONOTONIC, &begin);
        pid_t child = fork();
        if (child == 0)
        {
            execvp(argv[2], argv + 2);
            _exit(127);
        }
        int status = 0;
        struct rusage usage;
        if (child > 0 && wait4(child, &status, 0, &usage) == child)
        {
            struct timespec end;
            clock_gettime(CLOCK_MONOTONIC, &end);
            double wall = (double)(end.tv_sec - begin.tv_sec) + (double)(end.tv_nsec - begin.tv_nsec) / 1e9;
            fprintf(stderr, "%s peak-rss-kb=%ld wall=%.1f status=%d\n", argv[1], usage.ru_maxrss, wall, WIFEXITED(status) ? WEXITSTATUS(status) : -1);
            result = WIFEXITED(status) ? WEXITSTATUS(status) : 1;
        }
    }
    return result;
}
