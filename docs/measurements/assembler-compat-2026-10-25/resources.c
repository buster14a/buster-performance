// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Execute one benchmark, retaining its stdout/stderr and reporting whole-process wall time and Linux wait4 usage.
// max_rss_kib is the process peak, not the retained compiler arena or a per-operation allocation measurement.
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/resource.h>

int main(int argc, char** argv)
{
    int result = 2;
    FILE* report = argc >= 3 ? fopen(argv[1], "w") : 0;
    if (report != 0 && fcntl(fileno(report), F_SETFD, FD_CLOEXEC) == 0)
    {
        struct timespec start;
        struct timespec finish;
        struct rusage usage = {0};
        const bool started = clock_gettime(CLOCK_MONOTONIC, &start) == 0;
        const pid_t child = started ? fork() : -1;
        if (child == 0)
        {
            execvp(argv[2], argv + 2);
            _exit(127);
        }
        if (child > 0)
        {
            int status = 0;
            pid_t waited;
            do
            {
                waited = wait4(child, &status, 0, &usage);
            } while (waited < 0 && errno == EINTR);
            const bool timed = clock_gettime(CLOCK_MONOTONIC, &finish) == 0;
            if (waited == child && timed)
            {
                const int64_t wall = (int64_t)(finish.tv_sec - start.tv_sec) * 1000000000 + finish.tv_nsec - start.tv_nsec;
                fprintf(report, "wall_ns=%lld\nmax_rss_kib=%ld\nminor_faults=%ld\nmajor_faults=%ld\nuser_cpu_us=%lld\nsystem_cpu_us=%lld\n",
                        (long long)wall, usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt,
                        (long long)usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec,
                        (long long)usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec);
                result = WIFEXITED(status) ? WEXITSTATUS(status) : 128;
                fprintf(report, "exit_status=%d\ncommand:", result);
                for (int i = 2; i < argc; i += 1)
                {
                    fprintf(report, " %s", argv[i]);
                }
                fputc('\n', report);
            }
        }
    }
    if (report != 0 && fclose(report) != 0)
    {
        result = 2;
    }
    return result;
}
