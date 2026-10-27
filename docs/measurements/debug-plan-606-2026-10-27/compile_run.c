// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original #606 measurement helper: one fresh compiler process, complete elapsed time and wait4 resources.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static uint64_t now_ns(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return (uint64_t)time.tv_sec * 1000000000 + time.tv_nsec;
}

int main(int argc, char** argv)
{
    int result = argc >= 4 ? 0 : 2;
    if (result == 0)
    {
        fflush(NULL);
        const uint64_t start = now_ns();
        const pid_t pid = fork();
        if (pid == 0)
        {
            const int errors = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0600);
            const int output = open("/dev/null", O_WRONLY);
            if (errors < 0 || output < 0 || dup2(errors, STDERR_FILENO) < 0 || dup2(output, STDOUT_FILENO) < 0)
            {
                _exit(125);
            }
            close(errors);
            close(output);
            execvp(argv[2], argv + 2);
            _exit(126);
        }
        struct rusage usage = { 0 };
        int status = 0;
        pid_t waited;
        do
        {
            waited = pid > 0 ? wait4(pid, &status, 0, &usage) : -1;
        } while (waited < 0 && errno == EINTR && pid > 0);
        const uint64_t elapsed = now_ns() - start;
        result = waited == pid && pid > 0 && WIFEXITED(status) ? WEXITSTATUS(status) : 127;
        printf("%llu\t%ld\t%llu\t%llu\t%ld\t%ld\t%d\n", (unsigned long long)elapsed, usage.ru_maxrss,
               (unsigned long long)usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec,
               (unsigned long long)usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec,
               usage.ru_minflt, usage.ru_majflt, result);
    }
    return result;
}
