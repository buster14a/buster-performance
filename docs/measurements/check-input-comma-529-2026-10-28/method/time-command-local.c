// Original bounded wait4 receipt helper; the command inherits the caller's cores affinity.
#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static double seconds(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (double)value.tv_sec + (double)value.tv_nsec / 1000000000.0;
}

int main(int argc, char** argv)
{
    if (argc < 3) return 2;
    FILE* receipt = fopen(argv[1], "w");
    if (receipt == NULL) return 2;
    const double start = seconds();
    const pid_t child = fork();
    if (child == 0)
    {
        execv(argv[2], argv + 2);
        _exit(127);
    }
    int status = 0;
    struct rusage usage = { 0 };
    pid_t waited = -1;
    if (child > 0)
    {
        do { waited = wait4(child, &status, 0, &usage); } while (waited < 0 && errno == EINTR);
    }
    const int result = waited != child || child < 0 ? 125 : WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
    fprintf(receipt, "status=%d wall_s=%.9f user_s=%.6f system_s=%.6f RSS_KiB=%ld minor=%ld major=%ld voluntary=%ld involuntary=%ld\n",
            result, seconds() - start, (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec / 1000000.0,
            (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec / 1000000.0, usage.ru_maxrss,
            usage.ru_minflt, usage.ru_majflt, usage.ru_nvcsw, usage.ru_nivcsw);
    const int written = fclose(receipt);
    return result == 0 && written != 0 ? 125 : result;
}
