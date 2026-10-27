// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded whole-process A/B benchmark for one #593 workload at four sizes. One warmup and three timed
// rounds rotate five variants: both default compilers, tcc, and both compilers with their stage clocks enabled.
// Every round requires identical objects from all four Buster variants; all three compilers' objects run against
// verify.c after each size. No sample is excluded for its timing. Invoke under the shared lock, pinned to CPU 2.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>
#include <fcntl.h>

typedef struct Sample Sample;
struct Sample
{
    double wall;
    double input;
    double declarations;
    long peak;
    int status;
};

static uint64_t now(void)
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return (uint64_t)time.tv_sec * UINT64_C(1000000000) + (uint64_t)time.tv_nsec;
}

static Sample execute(char* const* arguments, const char* log)
{
    Sample result = { .status = 1 };
    const uint64_t start = now();
    const pid_t child = fork();
    if (child == 0)
    {
        const int file = open(log, O_CREAT | O_TRUNC | O_RDWR, 0644);
        if (file >= 0 && dup2(file, STDOUT_FILENO) >= 0 && dup2(file, STDERR_FILENO) >= 0)
        {
            execvp(arguments[0], arguments);
        }
        _exit(127);
    }
    struct rusage usage = { 0 };
    int status = 0;
    if (child > 0 && wait4(child, &status, 0, &usage) == child)
    {
        result.wall = (double)(now() - start) / 1e6;
        result.peak = usage.ru_maxrss;
        result.status = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
    }
    return result;
}

static bool stages(const char* path, Sample* sample)
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    unsigned fields = 0;
    char line[4096];
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        char name[80];
        double value = 0;
        if (sscanf(line, "time-stage\t%79s\t%lf", name, &value) == 2)
        {
            if (strcmp(name, "check-input") == 0)
            {
                sample->input = value;
                fields |= 1;
            }
            if (strcmp(name, "check-declarations") == 0)
            {
                sample->declarations = value;
                fields |= 2;
            }
            fields |= strcmp(name, "total") == 0 ? 4 : 0;
        }
    }
    if (file != NULL)
    {
        valid = !ferror(file);
        fclose(file);
    }
    return valid && fields == 7;
}

static bool same(const char* a, const char* b)
{
    FILE* first = fopen(a, "rb");
    FILE* second = fopen(b, "rb");
    bool valid = first != NULL && second != NULL;
    size_t count = 1;
    while (valid && count != 0)
    {
        unsigned char left[8192];
        unsigned char right[8192];
        count = fread(left, 1, sizeof(left), first);
        const size_t other = fread(right, 1, sizeof(right), second);
        valid = count == other && memcmp(left, right, count) == 0 && !ferror(first) && !ferror(second);
    }
    if (first != NULL)
    {
        fclose(first);
    }
    if (second != NULL)
    {
        fclose(second);
    }
    return valid;
}

static double median(double a, double b, double c)
{
    const double low = a < b ? a : b;
    const double high = a > b ? a : b;
    return c < low ? low : c > high ? high : c;
}

int main(int argc, char** argv)
{
    static const char* const variants[] = { "base", "head", "tcc", "base-stages", "head-stages" };
    static const unsigned counts[] = { 20000, 40000, 80000, 160000 };
    bool valid = argc == 3 || argc == 5;
    const char* kind = valid ? argv[1] : "";
    const unsigned id = valid ? (unsigned)strtoul(argv[2], NULL, 10) : 7;
    const unsigned first = argc == 5 ? (unsigned)strtoul(argv[3], NULL, 10) : 0;
    const unsigned last = argc == 5 ? (unsigned)strtoul(argv[4], NULL, 10) : 4;
    valid = valid && id < 7 && first < last && last <= 4;
    setvbuf(stdout, NULL, _IOLBF, 0);
    for (unsigned size = first; valid && size < last; size += 1)
    {
        char source[256];
        char objects[5][256];
        Sample samples[3][5] = { 0 };
        snprintf(source, sizeof(source), "inputs/%s-%u.c", kind, counts[size]);
        for (unsigned variant = 0; variant < 5; variant += 1)
        {
            snprintf(objects[variant], sizeof(objects[variant]), "objects/paired-%s-%u-%s.o", kind, counts[size], variants[variant]);
        }
        for (unsigned round = 0; valid && round < 4; round += 1)
        {
            for (unsigned position = 0; valid && position < 5; position += 1)
            {
                const unsigned variant = (position + round + size) % 5;
                char log[512];
                snprintf(log, sizeof(log), "logs/paired-%s-%u-%u-%s.log", kind, counts[size], round, variants[variant]);
                char* arguments[9];
                unsigned count = 0;
                arguments[count++] = variant == 2 ? "/usr/bin/tcc" : variant == 0 || variant == 3 ? "../base/build/compiler" : "../head/build/compiler";
                if (variant >= 3)
                {
                    arguments[count++] = "--time-stages";
                }
                arguments[count++] = "-c";
                arguments[count++] = source;
                arguments[count++] = "-o";
                arguments[count++] = objects[variant];
                arguments[count] = NULL;
                Sample sample = execute(arguments, log);
                valid = sample.status == 0 && (variant < 3 || stages(log, &sample));
                printf("sample,%s,%u,%u,%s,warmup=%u,wall_ms=%.6f,peak_kb=%ld,input_ms=%.3f,declarations_ms=%.3f,status=%d\n",
                       kind, counts[size], round, variants[variant], round == 0, sample.wall, sample.peak, sample.input, sample.declarations, sample.status);
                if (round != 0)
                {
                    samples[round - 1][variant] = sample;
                }
            }
            for (unsigned variant = 1; valid && variant < 5; variant += 1)
            {
                valid = variant == 2 || same(objects[0], objects[variant]);
            }
            printf("objects,%s,%u,%u,byte_identical=%u\n", kind, counts[size], round, valid);
        }
        for (unsigned variant = 0; valid && variant < 3; variant += 1)
        {
            char define[32];
            char output[512];
            char log[512];
            char count[32];
            snprintf(define, sizeof(define), "-DKIND=%u", id);
            snprintf(output, sizeof(output), "objects/verify-%s-%u-%s", kind, counts[size], variants[variant]);
            snprintf(log, sizeof(log), "logs/verify-%s-%u-%s.log", kind, counts[size], variants[variant]);
            snprintf(count, sizeof(count), "%u", counts[size]);
            char* compile[] = { "clang", "-O0", define, "verify.c", objects[variant], "-o", output, NULL };
            valid = execute(compile, log).status == 0;
            char* run[] = { output, count, NULL };
            valid = valid && execute(run, log).status == 0;
            printf("verify,%s,%u,%s,status=%u\n", kind, counts[size], variants[variant], valid ? 0 : 1);
        }
        if (valid)
        {
            printf("summary,%s,%u", kind, counts[size]);
            for (unsigned variant = 0; variant < 5; variant += 1)
            {
                printf(",%s_wall=%.6f,%s_input=%.3f,%s_declarations=%.3f,%s_peak=%.0f", variants[variant], median(samples[0][variant].wall, samples[1][variant].wall, samples[2][variant].wall),
                       variants[variant], median(samples[0][variant].input, samples[1][variant].input, samples[2][variant].input),
                       variants[variant], median(samples[0][variant].declarations, samples[1][variant].declarations, samples[2][variant].declarations),
                       variants[variant], median((double)samples[0][variant].peak, (double)samples[1][variant].peak, (double)samples[2][variant].peak));
            }
            putchar('\n');
        }
    }
    printf("comparison,%s,status=%u\n", kind, valid ? 0 : 1);
    return valid ? 0 : 1;
}
