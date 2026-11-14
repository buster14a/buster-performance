// runrss.c: runs a command and appends "label<TAB>status<TAB>wall seconds<TAB>user seconds<TAB>system seconds<TAB>peak RSS
// KiB" to a file: runrss FILE LABEL COMMAND [ARGUMENT...]. The command's status is this program's (128 + signal).
// cc -O2 -o runrss runrss.c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 4)
    {
        struct timespec start, end;
        clock_gettime(CLOCK_MONOTONIC, &start);
        const pid_t child = fork();
        if (child == 0)
        {
            execvp(argv[3], argv + 3);
            _exit(127);
        }
        int status = 0;
        struct rusage usage = { 0 };
        if (child > 0 && wait4(child, &status, 0, &usage) == child)
        {
            clock_gettime(CLOCK_MONOTONIC, &end);
            result = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
            FILE* file = fopen(argv[1], "a");
            if (file != NULL)
            {
                fprintf(file, "%s\t%d\t%.3f\t%.3f\t%.3f\t%ld\n", argv[2], result, (double)(end.tv_sec - start.tv_sec) + (double)(end.tv_nsec - start.tv_nsec) / 1e9,
                        (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec / 1e6, (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec / 1e6, usage.ru_maxrss);
                fclose(file);
            }
        }
    }
    return result;
}
