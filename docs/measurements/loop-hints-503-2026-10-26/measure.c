// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original issue-503 driver comparison. Each four-run block is ABBA or BAAB;
// only successful fresh processes enter the paired wall/user/RSS samples.
#define _GNU_SOURCE
#include <fcntl.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static uint64_t now(void)
{
    struct timespec stamp;
    clock_gettime(CLOCK_MONOTONIC_RAW, &stamp);
    return (uint64_t)stamp.tv_sec * UINT64_C(1000000000) + stamp.tv_nsec;
}

static bool run(const char* compiler, const char* source, bool scalar, uint64_t* wall, struct rusage* usage)
{
    const uint64_t begin = now();
    const pid_t child = fork();
    if (child == 0)
    {
        const int output = open("/dev/null", O_WRONLY);
        if (output < 0 || dup2(output, STDOUT_FILENO) < 0)
        {
            _exit(126);
        }
        close(output);
        char* arguments[] = { (char*)compiler, scalar ? "--scalar" : "-fsyntax-only", "-fsyntax-only", "-std=gnu17", "-march=znver5", (char*)source, NULL };
        execv(compiler, arguments);
        _exit(127);
    }
    int status = 0;
    const pid_t waited = child > 0 ? wait4(child, &status, 0, usage) : -1;
    *wall = now() - begin;
    return waited == child && child > 0 && WIFEXITED(status) && WEXITSTATUS(status) == 0;
}

static bool generate(const char* source, unsigned count)
{
    FILE* file = fopen(source, "wb");
    bool valid = file != NULL;
    for (unsigned f = 0; valid && f < count; f += 1)
    {
        valid = fprintf(file, "int f%u(int n) { int s = 0;\n#pragma clang loop vectorize(disable) unroll_count(4)\n"
                              "for (int i = 0; i < n; i += 1) s += i; return s; }\n", f) > 0;
    }
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = false;
    if (argc == 4 && strcmp(argv[1], "--generate") == 0)
    {
        valid = generate(argv[2], (unsigned)strtoul(argv[3], NULL, 10));
    }
    else if (argc == 5)
    {
        const bool scalar = strcmp(argv[4], "scalar") == 0;
        valid = scalar || strcmp(argv[4], "vector") == 0;
        double ratios[6] = { 0 };
        double sum = 0;
        for (unsigned tree = 0; valid && tree < 2; tree += 1)
        {
            uint64_t wall = 0;
            struct rusage usage = { 0 };
            valid = run(argv[tree + 1], argv[3], scalar, &wall, &usage);
        }
        puts("block,slot,tree,wall_ns,user_us,system_us,maxrss_kb");
        for (unsigned block = 0; valid && block < 6; block += 1)
        {
            double walls[2] = { 0 };
            for (unsigned slot = 0; valid && slot < 4; slot += 1)
            {
                const unsigned tree = (slot == 0 || slot == 3) ^ (block & 1);
                struct rusage usage = { 0 };
                uint64_t wall = 0;
                valid = run(argv[tree + 1], argv[3], scalar, &wall, &usage);
                if (valid)
                {
                    const int64_t user = (int64_t)usage.ru_utime.tv_sec * 1000000 + usage.ru_utime.tv_usec;
                    const int64_t system = (int64_t)usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec;
                    printf("%u,%u,%s,%llu,%lld,%lld,%ld\n", block, slot, tree == 0 ? "base" : "head", (unsigned long long)wall,
                           (long long)user, (long long)system, usage.ru_maxrss);
                    walls[tree] += wall;
                }
            }
            ratios[block] = valid ? (walls[1] / walls[0] - 1) * 100 : 0;
            sum += ratios[block];
        }
        if (valid)
        {
            const double mean = sum / 6;
            double squares = 0;
            for (unsigned block = 0; block < 6; block += 1)
            {
                squares += (ratios[block] - mean) * (ratios[block] - mean);
            }
            fprintf(stderr, "mean paired wall change %.3f%%, six-block t95 [%.3f%%, %.3f%%]\n", mean,
                    mean - 2.571 * sqrt(squares / 30), mean + 2.571 * sqrt(squares / 30));
        }
    }
    else
    {
        fprintf(stderr, "usage: measure BASE HEAD SOURCE scalar|vector; measure --generate FILE FUNCTIONS\n");
    }
    return valid ? 0 : 1;
}
