// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original diagnostic workload generator and fresh-process measurement helper, 2026-10-28.
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static double milliseconds(struct timespec t)
{
    return (double)t.tv_sec * 1000 + (double)t.tv_nsec / 1000000;
}

static int generate(const char* directory, unsigned count)
{
    const char* names[] = { "warnings", "redefinitions", "overflow" };
    int result = 0;
    for (unsigned kind = 0; result == 0 && kind < 3; kind += 1)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/%s-%u.c", directory, names[kind], count);
        FILE* file = fopen(path, "w");
        result = file == 0;
        for (unsigned i = 0; !result && i < count; i += 1)
        {
            if (kind == 0)
            {
                fprintf(file, "#warning diagnostic_%u\n", i);
            }
            else if (kind == 1)
            {
                fprintf(file, "#define R %u\n", i);
            }
            else
            {
                fprintf(file, "int v%u = 2147483647 + %u;\n", i, i + 1);
            }
        }
        if (file != 0)
        {
            result |= fclose(file) != 0;
        }
    }
    return result;
}

static int measure(char** compilers, const char* input, const char* sink, unsigned rounds, const char* directory)
{
    int result = 0;
    const int piped = strcmp(sink, "pipe") == 0;
    for (unsigned round = 0; result == 0 && round < rounds; round += 1)
    {
        for (unsigned turn = 0; result == 0 && turn < 2; turn += 1)
        {
            const unsigned role = (round + turn) % 2;
            int descriptors[2] = { -1, -1 };
            char diagnostic[4096];
            char object[4096];
            snprintf(diagnostic, sizeof(diagnostic), "%s/diagnostic-%u.txt", directory, role);
            snprintf(object, sizeof(object), "%s/output-%u.o", directory, role);
            const int errors = piped ? -1 : open(diagnostic, O_WRONLY | O_CREAT | O_TRUNC, 0600);
            result = piped ? pipe(descriptors) != 0 : errors < 0;
            struct timespec before;
            struct timespec after;
            clock_gettime(CLOCK_MONOTONIC, &before);
            const pid_t child = result == 0 ? fork() : -1;
            if (child == 0)
            {
                const int null = open("/dev/null", O_WRONLY);
                if (null < 0 || dup2(null, STDOUT_FILENO) < 0 || dup2(piped ? descriptors[1] : errors, STDERR_FILENO) < 0)
                {
                    _exit(127);
                }
                close(null);
                if (piped)
                {
                    close(descriptors[0]);
                    close(descriptors[1]);
                }
                else
                {
                    close(errors);
                }
                const char* slash = strrchr(compilers[role], '/');
                const char* name = slash != 0 ? slash + 1 : compilers[role];
                if (strcmp(name, "tcc") == 0)
                {
                    execl(compilers[role], compilers[role], "-c", input, "-o", object, (char*)0);
                }
                else
                {
                    execl(compilers[role], compilers[role], "--lanes", "1", "-c", input, "-o", object, (char*)0);
                }
                _exit(127);
            }
            if (errors >= 0)
            {
                close(errors);
            }
            if (piped && descriptors[1] >= 0)
            {
                close(descriptors[1]);
                char bytes[16384];
                ssize_t count;
                do
                {
                    count = read(descriptors[0], bytes, sizeof(bytes));
                } while (count > 0 || (count < 0 && errno == EINTR));
                result |= count < 0;
                close(descriptors[0]);
            }
            int status = 0;
            struct rusage usage;
            result |= child < 0 || wait4(child, &status, 0, &usage) != child || !WIFEXITED(status) || WEXITSTATUS(status) != 0;
            clock_gettime(CLOCK_MONOTONIC, &after);
            if (!result)
            {
                printf("{\"round\":%u,\"role\":%u,\"sink\":\"%s\",\"wall_ms\":%.6f,\"user_ms\":%.6f,\"system_ms\":%.6f,\"rss_kib\":%ld,\"status\":%d}\n",
                       round, role, sink, milliseconds(after) - milliseconds(before),
                       (double)usage.ru_utime.tv_sec * 1000 + (double)usage.ru_utime.tv_usec / 1000,
                       (double)usage.ru_stime.tv_sec * 1000 + (double)usage.ru_stime.tv_usec / 1000,
                       usage.ru_maxrss, WEXITSTATUS(status));
            }
        }
    }
    return result;
}

int main(int argc, char** argv)
{
    int result = 2;
    if (argc == 4 && strcmp(argv[1], "generate") == 0)
    {
        result = generate(argv[2], (unsigned)strtoul(argv[3], 0, 10));
    }
    else if (argc == 8 && strcmp(argv[1], "measure") == 0)
    {
        result = measure(argv + 2, argv[4], argv[5], (unsigned)strtoul(argv[6], 0, 10), argv[7]);
    }
    if (result != 0)
    {
        fprintf(stderr, "probe: failed (status %d, errno %d)\n", result, errno);
    }
    return result;
}
