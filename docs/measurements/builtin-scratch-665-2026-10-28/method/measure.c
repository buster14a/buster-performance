// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original two-role whole-process measurement. Each run holds one input/configuration homogeneous. ABBA cycles cover
// every ordered predecessor/role pair equally; the final full-size primer is role0. Logs and objects never overwrite.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static double seconds(struct timespec time)
{
    return time.tv_sec + time.tv_nsec * 1e-9;
}

int main(int argc, char** argv)
{
    int result = argc >= 6 ? 0 : 1;
    const unsigned cycles = result == 0 ? (unsigned)strtoul(argv[4], NULL, 10) : 0;
    result = cycles > 0 && cycles <= 100 && result == 0 ? result : 1;
    if (result == 0 && (strlen(argv[2]) != strlen(argv[3]) || mkdir(argv[1], 0777) != 0))
    {
        result = 1;
    }
    FILE* receipt = NULL;
    if (result == 0)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/samples.tsv", argv[1]);
        receipt = fopen(path, "w");
        result = receipt != NULL ? result : 1;
    }
    unsigned previous = 0;
    if (receipt != NULL)
    {
        fprintf(receipt, "# argv");
        for (int i = 0; i < argc; i += 1)
        {
            fprintf(receipt, " %s", argv[i]);
        }
        fprintf(receipt, "\n# cycles %u\n# index warm role predecessor start_utc end_utc wall_ms user_ms system_ms rss_kib minor major status object_bytes\n", cycles);
    }
    for (unsigned index = 0; result == 0 && index < 3 + cycles * 4; index += 1)
    {
        const unsigned order[4] = { 0, 1, 1, 0 };
        const unsigned warm[3] = { 0, 1, 0 };
        const unsigned role = index < 3 ? warm[index] : order[(index - 3) % 4];
        char object[4096];
        char log[4096];
        snprintf(object, sizeof(object), "%s/r%04u-role%u.o", argv[1], index, role);
        snprintf(log, sizeof(log), "%s/r%04u-role%u.log", argv[1], index, role);
        char** arguments = calloc((size_t)argc + 1, sizeof(char*));
        if (arguments == NULL)
        {
            result = 1;
        }
        else
        {
            arguments[0] = argv[2 + role];
            for (int i = 5; i < argc; i += 1)
            {
                arguments[i - 4] = argv[i];
            }
            arguments[argc - 4] = "-o";
            arguments[argc - 3] = object;
            struct timespec start;
            struct timespec end;
            struct timespec start_utc;
            struct timespec end_utc;
            struct rusage usage = { 0 };
            clock_gettime(CLOCK_REALTIME, &start_utc);
            clock_gettime(CLOCK_MONOTONIC, &start);
            pid_t child = fork();
            int status = -1;
            if (child == 0)
            {
                const int fd = open(log, O_CREAT | O_EXCL | O_WRONLY, 0666);
                if (fd < 0 || dup2(fd, STDOUT_FILENO) < 0 || dup2(fd, STDERR_FILENO) < 0)
                {
                    _exit(126);
                }
                close(fd);
                execvp(arguments[0], arguments);
                _exit(127);
            }
            else if (child > 0)
            {
                while (wait4(child, &status, 0, &usage) < 0 && errno == EINTR)
                {
                }
            }
            clock_gettime(CLOCK_MONOTONIC, &end);
            clock_gettime(CLOCK_REALTIME, &end_utc);
            struct stat info = { 0 };
            const bool output = stat(object, &info) == 0 && S_ISREG(info.st_mode) && info.st_size > 0;
            fprintf(receipt, "%u %u %u %u %.9f %.9f %.6f %.6f %.6f %ld %ld %ld %d %jd\n", index, index < 3, role, previous,
                    seconds(start_utc), seconds(end_utc), (seconds(end) - seconds(start)) * 1000,
                    usage.ru_utime.tv_sec * 1000 + usage.ru_utime.tv_usec * .001,
                    usage.ru_stime.tv_sec * 1000 + usage.ru_stime.tv_usec * .001,
                    usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, status, (intmax_t)info.st_size);
            fflush(receipt);
            previous = role;
            result = status == 0 && output ? result : 1;
            free(arguments);
        }
    }
    if (receipt != NULL)
    {
        fprintf(receipt, "# status %d\n", result);
        fclose(receipt);
    }
    return result;
}
