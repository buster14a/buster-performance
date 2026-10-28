// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#define _GNU_SOURCE
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 125;
    struct timespec before = {0};
    struct timespec after = {0};
    struct rusage usage = {0};
    int status = 0;
    if (argc >= 3 && clock_gettime(CLOCK_MONOTONIC, &before) == 0)
    {
        const pid_t child = fork();
        if (child == 0)
        {
            execvp(argv[2], argv + 2);
            perror(argv[2]);
            _exit(127);
        }
        pid_t waited = -1;
        do
        {
            waited = child > 0 ? wait4(child, &status, 0, &usage) : -1;
        }
        while (waited < 0 && child > 0 && errno == EINTR);
        if (waited == child && child > 0 && clock_gettime(CLOCK_MONOTONIC, &after) == 0)
        {
            result = WIFEXITED(status) ? WEXITSTATUS(status) : WIFSIGNALED(status) ? 128 + WTERMSIG(status) : 125;
            FILE* output = fopen(argv[1], "wx");
            const double wall = (double)(after.tv_sec - before.tv_sec) + (double)(after.tv_nsec - before.tv_nsec) / 1000000000.0;
            const double user = (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec / 1000000.0;
            const double system = (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec / 1000000.0;
            const bool written = output != 0 && fprintf(output,
                "{\"status\":%d,\"wall_s\":%.9f,\"user_s\":%.6f,\"system_s\":%.6f,\"maxrss_kb\":%ld,\"minor_faults\":%ld,\"major_faults\":%ld,\"voluntary_cs\":%ld,\"involuntary_cs\":%ld}\n",
                result, wall, user, system, usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, usage.ru_nvcsw, usage.ru_nivcsw) > 0;
            const bool closed = output != 0 && fclose(output) == 0;
            if (!written || !closed)
            {
                result = 125;
            }
        }
    }
    return result;
}
