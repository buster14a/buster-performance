// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Three fresh executable copies: two of main for an A/A control and one of the candidate. Every round
// rotates their order, records the driver's stage report and checks every object byte. Scalar qualification
// follows the timed rounds so its longer work cannot change the preceding samples' clock state.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define MAX_RUNS 63
#define MAX_ARGUMENTS 128

static const char* names[] = { "base-a", "base-b", "batch" };

static bool copy_file(const char* input, const char* output)
{
    FILE* from = fopen(input, "rb");
    FILE* to = from != NULL ? fopen(output, "wb") : NULL;
    bool valid = from != NULL && to != NULL;
    unsigned char bytes[65536];
    size_t count = 0;
    while (valid && (count = fread(bytes, 1, sizeof(bytes), from)) != 0)
    {
        valid = fwrite(bytes, 1, count, to) == count;
    }
    valid = valid && !ferror(from);
    if (from != NULL)
    {
        valid = fclose(from) == 0 && valid;
    }
    if (to != NULL)
    {
        valid = fclose(to) == 0 && valid;
    }
    return valid && chmod(output, 0755) == 0;
}

static bool same_files(const char* left, const char* right)
{
    FILE* a = fopen(left, "rb");
    FILE* b = fopen(right, "rb");
    bool same = a != NULL && b != NULL;
    unsigned char first[65536];
    unsigned char second[65536];
    size_t count = sizeof(first);
    while (same && count != 0)
    {
        count = fread(first, 1, sizeof(first), a);
        const size_t other = fread(second, 1, sizeof(second), b);
        same = count == other && memcmp(first, second, count) == 0;
    }
    same = same && !ferror(a) && !ferror(b);
    if (a != NULL)
    {
        same = fclose(a) == 0 && same;
    }
    if (b != NULL)
    {
        same = fclose(b) == 0 && same;
    }
    return same;
}

static double elapsed_ms(struct timespec start, struct timespec end)
{
    return (double)(end.tv_sec - start.tv_sec) * 1000.0 + (double)(end.tv_nsec - start.tv_nsec) / 1000000.0;
}

static int double_order(const void* a, const void* b)
{
    const double left = *(const double*)a;
    const double right = *(const double*)b;
    return (left > right) - (left < right);
}

static double median(const double* samples, int count)
{
    double copy[MAX_RUNS];
    memcpy(copy, samples, (size_t)count * sizeof(double));
    qsort(copy, (size_t)count, sizeof(double), double_order);
    return count % 2 != 0 ? copy[count / 2] : (copy[count / 2 - 1] + copy[count / 2]) * 0.5;
}

static bool run_compile(char** arguments, const char* log, double* wall, double* lower, long* peak, unsigned long long* evaluated, unsigned long long* batched)
{
    struct timespec start;
    struct timespec end;
    struct rusage usage = { 0 };
    int status = -1;
    clock_gettime(CLOCK_MONOTONIC_RAW, &start);
    const pid_t child = fork();
    if (child == 0)
    {
        const int fd = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd >= 0 && dup2(fd, STDOUT_FILENO) >= 0 && dup2(fd, STDERR_FILENO) >= 0)
        {
            close(fd);
            execv(arguments[0], arguments);
        }
        _exit(127);
    }
    pid_t waited = -1;
    do
    {
        waited = child > 0 ? wait4(child, &status, 0, &usage) : -1;
    } while (waited < 0 && errno == EINTR);
    clock_gettime(CLOCK_MONOTONIC_RAW, &end);
    bool valid = waited == child && child > 0 && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    *wall = elapsed_ms(start, end);
    *peak = usage.ru_maxrss;
    *lower = -1;
    *evaluated = 0;
    *batched = 0;
    FILE* report = valid ? fopen(log, "r") : NULL;
    valid = valid && report != NULL;
    char line[4096];
    while (report != NULL && fgets(line, sizeof(line), report) != NULL)
    {
        double value = 0;
        if (sscanf(line, "time-stage\tlower\t%lf", &value) == 1)
        {
            *lower = value;
        }
        sscanf(line, "lowering-nodes\tevaluated=%llu\tbatched=%llu", evaluated, batched);
    }
    if (report != NULL)
    {
        valid = !ferror(report) && fclose(report) == 0 && valid;
    }
    return valid && isfinite(*lower) && *lower >= 0;
}

int main(int argc, char** argv)
{
    const int runs = argc > 1 ? atoi(argv[1]) : 0;
    bool valid = argc >= 6 && argc < MAX_ARGUMENTS - 8 && runs > 0 && runs <= MAX_RUNS;
    if (!valid)
    {
        fprintf(stderr, "usage: compare RUNS BASE BATCH DIRECTORY COMPILER_ARGUMENT...\n");
    }
    char executables[3][4096];
    char objects[3][4096];
    char* command[MAX_ARGUMENTS];
    double walls[3][MAX_RUNS] = { 0 };
    double lowers[3][MAX_RUNS] = { 0 };
    for (int v = 0; valid && v < 3; v += 1)
    {
        snprintf(executables[v], sizeof(executables[v]), "%s/compiler-%s", argv[4], names[v]);
        snprintf(objects[v], sizeof(objects[v]), "%s/%s.o", argv[4], names[v]);
        valid = copy_file(v < 2 ? argv[2] : argv[3], executables[v]);
        printf("binary\t%s\t%s\n", names[v], v < 2 ? argv[2] : argv[3]);
    }
    for (int i = 5; valid && i < argc; i += 1)
    {
        printf("argument\t%d\t%s\n", i - 5, argv[i]);
    }
    for (int round = -2; valid && round < runs; round += 1)
    {
        for (int position = 0; valid && position < 3; position += 1)
        {
            const int v = (round + 3 + position) % 3;
            char log[4096];
            snprintf(log, sizeof(log), "%s/%s-%02d.txt", argv[4], names[v], round + 2);
            command[0] = executables[v];
            command[1] = "--time-stages";
            command[2] = "--lanes";
            command[3] = "1";
            int count = 4;
            for (int a = 5; a < argc; a += 1)
            {
                command[count++] = argv[a];
            }
            command[count++] = "-o";
            command[count++] = objects[v];
            command[count] = NULL;
            double wall = 0;
            double lower = 0;
            long peak = 0;
            unsigned long long evaluated = 0;
            unsigned long long batched = 0;
            valid = run_compile(command, log, &wall, &lower, &peak, &evaluated, &batched);
            printf("sample\t%d\t%s\twall_ms=%.6f\tlower_ms=%.6f\tpeak_kb=%ld\tevaluated=%llu\tbatched=%llu\tstatus=%s\n",
                   round, names[v], wall, lower, peak, evaluated, batched, valid ? "ok" : "FAILED");
            fflush(stdout);
            if (valid && round >= 0)
            {
                walls[v][round] = wall;
                lowers[v][round] = lower;
            }
        }
        valid = valid && same_files(objects[0], objects[1]) && same_files(objects[0], objects[2]);
        printf("objects\t%d\t%s\n", round, valid ? "identical" : "FAILED");
    }
    for (int v = 0; valid && v < 3; v += 1)
    {
        printf("median\t%s\twall_ms=%.6f\tlower_ms=%.6f\n", names[v], median(walls[v], runs), median(lowers[v], runs));
    }
    if (valid)
    {
        command[0] = executables[2];
        command[1] = "--scalar";
        double wall = 0;
        double lower = 0;
        long peak = 0;
        unsigned long long evaluated = 0;
        unsigned long long batched = 0;
        char log[4096];
        snprintf(log, sizeof(log), "%s/scalar.txt", argv[4]);
        // Keep --time-stages for the report reader, now outside the measured comparison.
        command[2] = "--time-stages";
        command[3] = "--lanes";
        command[4] = "1";
        int count = 5;
        for (int a = 5; a < argc; a += 1)
        {
            command[count++] = argv[a];
        }
        char output[4096];
        snprintf(output, sizeof(output), "%s/scalar.o", argv[4]);
        command[count++] = "-o";
        command[count++] = output;
        command[count] = NULL;
        valid = run_compile(command, log, &wall, &lower, &peak, &evaluated, &batched) && same_files(objects[0], output);
        printf("scalar-object\t%s\n", valid ? "identical" : "FAILED");
    }
    return valid ? 0 : 1;
}
