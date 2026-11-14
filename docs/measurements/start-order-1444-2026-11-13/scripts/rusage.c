// #1444: runs a command N times, each a fresh process, and prints the medians of its resource use from wait4: maximum
// resident set (KB), minor and major faults, and user and system time (µs).
//   rusage N COMMAND ARGUMENT...
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/resource.h>

static int compare(const void* a, const void* b)
{
    const long x = *(const long*)a;
    const long y = *(const long*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    int result = 1;
    const int runs = argc > 2 ? atoi(argv[1]) : 0;
    if (runs > 0 && runs <= 10000)
    {
        long* rss = calloc((size_t)runs, sizeof(long));
        long* minor = calloc((size_t)runs, sizeof(long));
        long* major = calloc((size_t)runs, sizeof(long));
        long* user = calloc((size_t)runs, sizeof(long));
        long* system = calloc((size_t)runs, sizeof(long));
        result = 0;
        for (int i = 0; i < runs && result == 0; i += 1)
        {
            const pid_t child = fork();
            if (child == 0)
            {
                const int null = open("/dev/null", O_WRONLY);
                dup2(null, 1);
                dup2(null, 2);
                execv(argv[2], argv + 2);
                _exit(127);
            }
            int status = 0;
            struct rusage usage;
            wait4(child, &status, 0, &usage);
            result = WIFEXITED(status) && WEXITSTATUS(status) == 0 ? 0 : 1;
            rss[i] = usage.ru_maxrss;
            minor[i] = usage.ru_minflt;
            major[i] = usage.ru_majflt;
            user[i] = usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec;
            system[i] = usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec;
        }
        qsort(rss, (size_t)runs, sizeof(long), compare);
        qsort(minor, (size_t)runs, sizeof(long), compare);
        qsort(major, (size_t)runs, sizeof(long), compare);
        qsort(user, (size_t)runs, sizeof(long), compare);
        qsort(system, (size_t)runs, sizeof(long), compare);
        printf("runs %d status %d max-rss-kb %ld minor-faults %ld major-faults %ld user-us %ld system-us %ld\n", runs, result, rss[runs / 2],
               minor[runs / 2], major[runs / 2], user[runs / 2], system[runs / 2]);
    }
    return result;
}
