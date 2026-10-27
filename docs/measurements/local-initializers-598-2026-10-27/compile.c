// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #598 process sampler. A pair rotates order on each round; every exit and sample is retained.
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static uint64_t now(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * 1000000000 + time.tv_nsec;
}

int main(int argc, char** argv)
{
    int failed = argc != 7 && argc != 8;
    for (unsigned round = 0; !failed && round < 12; round += 1)
    {
        for (unsigned k = 0; k < 2; k += 1)
        {
            const unsigned p = k ^ (round & 1);
            const unsigned sample = round == 0 ? 99 : round - 1;
            char log[512];
            char object[512];
            snprintf(log, sizeof(log), "%s/%s-%s-%s-%u.log", argv[6], p ? "head" : "base", argv[4], argv[5], sample);
            snprintf(object, sizeof(object), "%s/%s-%s-%s.o", argv[6], p ? "head" : "base", argv[4], argv[5]);
            const uint64_t start = now();
            const pid_t child = fork();
            if (child == 0)
            {
                const int fd = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0600);
                if (fd < 0 || dup2(fd, STDERR_FILENO) < 0)
                {
                    _exit(126);
                }
                close(fd);
                if (argc == 8)
                {
                    execl(argv[1 + p], argv[1 + p], "--lanes", "1", "-c", argv[3], "-o", object, (char*)NULL);
                }
                else
                {
                    execl(argv[1 + p], argv[1 + p], "--lanes", "1", "--time-stages", "-c", argv[3], "-o", object, (char*)NULL);
                }
                _exit(127);
            }
            int outcome = 0;
            struct rusage usage;
            if (child < 0 || wait4(child, &outcome, 0, &usage) != child)
            {
                failed = 1;
            }
            else
            {
                const int status = WIFEXITED(outcome) ? WEXITSTATUS(outcome) : 128;
                printf("%s,%s,%s,%s,%u,%llu,%llu,%llu,%ld,%d\n", round == 0 ? "warmup" : "compile", p ? "head" : "base", argv[4], argv[5], sample,
                       (unsigned long long)(now() - start),
                       (unsigned long long)usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec,
                       (unsigned long long)usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec, usage.ru_maxrss, status);
                fflush(stdout);
            }
        }
    }
    return failed;
}
