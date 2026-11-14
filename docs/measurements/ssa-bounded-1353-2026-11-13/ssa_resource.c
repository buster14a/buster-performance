// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and provenance/buster/LICENSING.md.
// Original source generators and a Linux RSS diagnostic runner for buster #1353.
// No timing results are produced: approved performance measurements belong to the 9700X.

#define _GNU_SOURCE
#include <errno.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static bool parse_count(const char* text, uint32_t* value)
{
    char* end = 0;
    errno = 0;
    const unsigned long parsed = strtoul(text, &end, 10);
    const bool valid = errno == 0 && text[0] != 0 && end[0] == 0 && parsed <= 1000000;
    if (valid)
    {
        *value = (uint32_t)parsed;
    }
    return valid;
}

static int generate(const char* shape, uint32_t count, uint32_t depth, bool executable)
{
    int status = 0;
    if (strcmp(shape, "loops") == 0)
    {
        puts("int g(int a) { int s = 0;");
        for (uint32_t item = 0; item < count; item += 1)
        {
            printf("for (int i = 0; i < a; i++) s += i * %u;\n", item);
        }
        puts("return s; }");
        if (executable)
        {
            const uint64_t expected = 5ull * count * (count - 1);
            printf("int main(void) { return g(0) != 0 || g(1) != 0 || g(5) != %llu; }\n", (unsigned long long)expected);
        }
    }
    else if (strcmp(shape, "max") == 0 || strcmp(shape, "nested") == 0)
    {
        puts("#define MAX(a,b) ({ __typeof__(a) _a = (a); __typeof__(b) _b = (b); _a > _b ? _a : _b; })");
        puts("int f(const int *p) { int s = 0;");
        for (uint32_t item = 0; item < count; item += 1)
        {
            fputs("s += ", stdout);
            for (uint32_t level = 0; level < depth; level += 1)
            {
                fputs("MAX(", stdout);
            }
            printf("p[%u]", item);
            for (uint32_t level = 0; level < depth; level += 1)
            {
                printf(",p[%u])", item + level + 1);
            }
            puts(";");
        }
        puts("return s; }");
        if (executable)
        {
            printf("int main(void) { int p[%u]; for (int i = 0; i < %u; i++) p[i] = i; return f(p) != %llu; }\n", count + depth, count + depth, (unsigned long long)((uint64_t)count * depth + (uint64_t)count * (count - 1) / 2));
        }
    }
    else
    {
        status = 2;
    }
    if (fflush(stdout) != 0)
    {
        status = 2;
    }
    return status;
}

static long child_rss(pid_t child)
{
    char path[64];
    snprintf(path, sizeof(path), "/proc/%ld/status", (long)child);
    FILE* stream = fopen(path, "r");
    long rss = 0;
    if (stream != 0)
    {
        char line[256];
        while (fgets(line, sizeof(line), stream) != 0)
        {
            if (sscanf(line, "VmRSS: %ld kB", &rss) == 1)
            {
                break;
            }
        }
        fclose(stream);
    }
    return rss;
}

static int run(long limit_kb, char** command)
{
    int status = 2;
    const pid_t child = fork();
    if (child == 0)
    {
        setpgid(0, 0);
        execvp(command[0], command);
        _exit(127);
    }
    else if (child > 0)
    {
        setpgid(child, child);
        bool guarded = false;
        bool timed_out = false;
        int result = 0;
        struct rusage usage = { 0 };
        struct timespec start = { 0 };
        clock_gettime(CLOCK_MONOTONIC, &start);
        bool done = false;
        while (!done)
        {
            const pid_t waited = wait4(child, &result, WNOHANG, &usage);
            if (waited == child)
            {
                done = true;
            }
            else if (waited < 0 && errno != EINTR)
            {
                done = true;
                result = 127 << 8;
            }
            else
            {
                struct timespec now = { 0 };
                clock_gettime(CLOCK_MONOTONIC, &now);
                guarded |= child_rss(child) > limit_kb;
                timed_out |= now.tv_sec - start.tv_sec > 180;
                if (guarded || timed_out)
                {
                    kill(-child, SIGKILL);
                }
                const struct timespec pause = { .tv_sec = 0, .tv_nsec = 1000000 };
                nanosleep(&pause, 0);
            }
        }
        status = WIFEXITED(result) ? WEXITSTATUS(result) : 128 + WTERMSIG(result);
        fprintf(stderr, "resource-rss-kb=%ld status=%d rss-guard=%u timeout=%u\n", usage.ru_maxrss, status, guarded, timed_out);
    }
    return status;
}

int main(int argc, char** argv)
{
    int status = 2;
    uint32_t count = 0;
    uint32_t depth = 0;
    if (argc == 6 && strcmp(argv[1], "generate") == 0 && parse_count(argv[3], &count) && parse_count(argv[4], &depth) && count != 0 && depth <= 16 && (strcmp(argv[5], "0") == 0 || strcmp(argv[5], "1") == 0))
    {
        status = generate(argv[2], count, depth, argv[5][0] == '1');
    }
    else if (argc >= 4 && strcmp(argv[1], "run") == 0)
    {
        char* end = 0;
        errno = 0;
        const long limit_kb = strtol(argv[2], &end, 10);
        if (errno == 0 && end[0] == 0 && limit_kb > 0)
        {
            status = run(limit_kb, argv + 3);
        }
    }
    if (status == 2)
    {
        fputs("usage: ssa-resource generate loops|max|nested COUNT DEPTH EXECUTABLE\n       ssa-resource run RSS_LIMIT_KB COMMAND [ARG...]\n", stderr);
    }
    return status;
}
