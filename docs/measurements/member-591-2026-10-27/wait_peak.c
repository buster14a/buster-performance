// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
// Original process-footprint wrapper; the child benchmark reports successful merges and copied deferred readers.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    const pid_t pid = argc > 1 ? fork() : -1;
    if (pid == 0)
    {
        execvp(argv[1], argv + 1);
        _exit(127);
    }
    int status = 0;
    struct rusage usage = { 0 };
    const bool waited = pid > 0 && wait4(pid, &status, 0, &usage) == pid;
    if (waited)
    {
        printf("process_peak_rss_kb=%ld user_seconds=%.6f system_seconds=%.6f\n", usage.ru_maxrss,
               (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec * 1e-6,
               (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec * 1e-6);
    }
    return !waited || !WIFEXITED(status) || WEXITSTATUS(status) != 0;
}
