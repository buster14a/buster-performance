// Runs a command and prints, after its output, one line: its wall, user and system time in ms, its voluntary and
// involuntary context switches, and CPU 2's busy and total jiffies over the run (/proc/stat). Busy jiffies past the
// command's own user and system time mean another process ran on CPU 2 meanwhile.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/wait.h>

static void cpu2(unsigned long long* busy, unsigned long long* total)
{
    FILE* f = fopen("/proc/stat", "r");
    char line[512];
    *busy = 0;
    *total = 0;
    while (f != NULL && fgets(line, sizeof(line), f) != NULL)
    {
        unsigned long long v[8] = { 0 };
        if (strncmp(line, "cpu2 ", 5) == 0 && sscanf(line + 5, "%llu %llu %llu %llu %llu %llu %llu %llu", v, v + 1, v + 2, v + 3, v + 4, v + 5, v + 6, v + 7) == 8)
        {
            *busy = v[0] + v[1] + v[2] + v[5] + v[6] + v[7];
            *total = *busy + v[3] + v[4];
        }
    }
    if (f != NULL)
    {
        fclose(f);
    }
}

int main(int argc, char** argv)
{
    int status = 2;
    if (argc > 1)
    {
        struct timespec a, b;
        unsigned long long busy0, total0, busy1, total1;
        fflush(stdout);
        cpu2(&busy0, &total0);
        clock_gettime(CLOCK_MONOTONIC_RAW, &a);
        const pid_t child = fork();
        if (child == 0)
        {
            execvp(argv[1], argv + 1);
            _exit(127);
        }
        struct rusage usage = { 0 };
        int waited = 0;
        const pid_t done = wait4(child, &waited, 0, &usage);
        clock_gettime(CLOCK_MONOTONIC_RAW, &b);
        cpu2(&busy1, &total1);
        status = done == child && WIFEXITED(waited) ? WEXITSTATUS(waited) : 1;
        printf("rusage wall_ms=%.3f user_ms=%.3f sys_ms=%.3f nvcsw=%ld nivcsw=%ld cpu2_busy_jiffies=%llu cpu2_total_jiffies=%llu status=%d\n",
               (b.tv_sec - a.tv_sec) * 1e3 + (b.tv_nsec - a.tv_nsec) / 1e6, usage.ru_utime.tv_sec * 1e3 + usage.ru_utime.tv_usec / 1e3,
               usage.ru_stime.tv_sec * 1e3 + usage.ru_stime.tv_usec / 1e3, usage.ru_nvcsw, usage.ru_nivcsw, busy1 - busy0, total1 - total0, status);
    }
    return status;
}
