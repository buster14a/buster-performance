// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #673 resource adapter for a real GNU make recipe. Preserve its inherited jobserver descriptors and
// report wait4 resources of the compiler and its waited descendants, without altering compiler stdout/stderr.
#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int result = 2;
    if (argc >= 3)
    {
        struct timespec begin, end;
        clock_gettime(CLOCK_MONOTONIC, &begin);
        const pid_t child = fork();
        if (child == 0)
        {
            execvp(argv[2], argv + 2);
            _exit(errno == ENOENT ? 127 : 126);
        }
        int status = 0;
        struct rusage usage = { 0 };
        pid_t waited = -1;
        if (child > 0)
        {
            do { waited = wait4(child, &status, 0, &usage); } while (waited < 0 && errno == EINTR);
        }
        clock_gettime(CLOCK_MONOTONIC, &end);
        result = waited == child && child > 0 ? (WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status)) : 125;
        FILE* output = fopen(argv[1], "w");
        if (output != NULL)
        {
            const double wall = (double)(end.tv_sec - begin.tv_sec) + (double)(end.tv_nsec - begin.tv_nsec) / 1e9;
            const double user = (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec / 1e6;
            const double system = (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec / 1e6;
            const int printed = fprintf(output, "{\"wall_s\":%.9f,\"user_s\":%.6f,\"system_s\":%.6f,\"maxrss_kb\":%ld,\"minor_faults\":%ld,\"major_faults\":%ld,\"voluntary_cs\":%ld,\"involuntary_cs\":%ld,\"status\":%d}\n",
                                        wall, user, system, usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt,
                                        usage.ru_nvcsw, usage.ru_nivcsw, result);
            const int closed = fclose(output);
            result = printed < 0 || closed != 0 ? 125 : result;
        }
        else
        {
            result = 125;
        }
    }
    return result;
}
