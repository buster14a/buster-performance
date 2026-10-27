// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #605 isolated arity-0/1/2 supplement, using campaign.c's process/stage protocol.
// clang -std=c17 -O2 -Wall -Wextra -Werror short-controls.c -o short-controls
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

typedef struct Case Case;
struct Case
{
    const char* name;
    unsigned count;
    unsigned kind;
};

static const Case cases[] =
{
    { "arity-0", 128, 0 },
    { "arity-1", 128, 1 },
    { "arity-2", 128, 2 },
};

static bool generate(const char* directory)
{
    bool valid = mkdir(directory, 0755) == 0 || errno == EEXIST;
    for (unsigned c = 0; valid && c < sizeof(cases) / sizeof(cases[0]); c += 1)
    {
        char path[1024];
        snprintf(path, sizeof(path), "%s/%s.c", directory, cases[c].name);
        FILE* output = fopen(path, "w");
        valid = output != NULL;
        if (valid)
        {
            for (unsigned i = 0; i < cases[c].count; i += 1)
            {
                if (cases[c].kind == 2)
                {
                    fprintf(output, "void*f%u(unsigned long,unsigned long) __attribute__((alloc_size(1,2))); void*f%u(unsigned long a,unsigned long b){return (void*)0;}\n", i, i);
                }
                else
                {
                    fprintf(output, "int f%u(void*) __attribute__((%s)); int f%u(void*p){return p!=0;}\n", i,
                            cases[c].kind == 1 ? "nonnull(1)" : "nothrow", i);
                }
            }
            fputs("int g(void){return 42;}\n", output);
        }
        if (output != NULL)
        {
            valid = fclose(output) == 0 && valid;
        }
    }
    return valid;
}

static uint64_t now_ns(void)
{
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    return (uint64_t)now.tv_sec * UINT64_C(1000000000) + (uint64_t)now.tv_nsec;
}

static bool same_file(const char* a, const char* b)
{
    FILE* left = fopen(a, "rb");
    FILE* right = fopen(b, "rb");
    bool equal = left != NULL && right != NULL;
    size_t bytes = 1;
    while (equal && bytes != 0)
    {
        unsigned char x[4096];
        unsigned char y[4096];
        bytes = fread(x, 1, sizeof(x), left);
        const size_t other = fread(y, 1, sizeof(y), right);
        equal = bytes == other && memcmp(x, y, bytes) == 0 && !ferror(left) && !ferror(right);
    }
    if (left != NULL)
    {
        fclose(left);
    }
    if (right != NULL)
    {
        fclose(right);
    }
    return equal;
}

static bool measure(const char* base, const char* head, const char* directory, unsigned round)
{
    const char* executables[] = { base, head };
    const char* names[] = { "base", "head" };
    char report_path[1024];
    char stages_path[1024];
    char objects[2][1024];
    snprintf(report_path, sizeof(report_path), "%s/last-stages.log", directory);
    snprintf(stages_path, sizeof(stages_path), "%s/round-%u-stages.log", directory, round);
    for (unsigned tree = 0; tree < 2; tree += 1)
    {
        snprintf(objects[tree], sizeof(objects[tree]), "%s/%s.o", directory, names[tree]);
    }
    FILE* stages = fopen(stages_path, "w");
    bool valid = stages != NULL;
    puts("round,repetition,tree,case,mode,wall_ms,check_input_ms,user_ms,system_ms,maxrss_kb,status");
    for (unsigned repetition = 0; valid && repetition <= 21; repetition += 1)
    {
        for (unsigned c = 0; valid && c < sizeof(cases) / sizeof(cases[0]); c += 1)
        {
            char source[1024];
            snprintf(source, sizeof(source), "%s/%s.c", directory, cases[c].name);
            for (unsigned mode = 0; valid && mode < 2; mode += 1)
            {
                for (unsigned order = 0; valid && order < 2; order += 1)
                {
                    const unsigned tree = (order + repetition + c + mode + round) % 2;
                    const uint64_t start = now_ns();
                    const pid_t child = fork();
                    if (child == 0)
                    {
                        const int report = open(report_path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                        const int null = open("/dev/null", O_RDWR);
                        if (report != -1 && null != -1 && dup2(null, 0) != -1 && dup2(null, 1) != -1 && dup2(report, 2) != -1)
                        {
                            if (mode == 0)
                            {
                                execl(executables[tree], executables[tree], "--time-stages", "-fsyntax-only", source, (char*)NULL);
                            }
                            else
                            {
                                execl(executables[tree], executables[tree], "--time-stages", "-c", source, "-o", objects[tree], (char*)NULL);
                            }
                        }
                        _exit(127);
                    }
                    struct rusage usage = { 0 };
                    int status = -1;
                    valid = child > 0 && wait4(child, &status, 0, &usage) == child;
                    const double wall = (double)(now_ns() - start) / 1e6;
                    const int exit_status = valid && WIFEXITED(status) ? WEXITSTATUS(status) : 128;
                    double checker = -1;
                    FILE* report = fopen(report_path, "r");
                    valid = valid && report != NULL && exit_status == 0;
                    if (report != NULL)
                    {
                        fprintf(stages, "round=%u repetition=%u tree=%s case=%s mode=%s\n", round, repetition, names[tree], cases[c].name, mode ? "object" : "syntax");
                        char line[4096];
                        while (fgets(line, sizeof(line), report) != NULL)
                        {
                            double value = 0;
                            if (sscanf(line, "time-stage\tcheck-input\t%lf", &value) == 1)
                            {
                                checker = value;
                            }
                            fputs(line, stages);
                        }
                        fclose(report);
                    }
                    valid = valid && checker >= 0;
                    printf("%u,%u,%s,%s,%s,%.6f,%.3f,%.3f,%.3f,%ld,%d\n", round, repetition, names[tree], cases[c].name,
                           mode ? "object" : "syntax", wall, checker, (double)usage.ru_utime.tv_sec * 1000 + (double)usage.ru_utime.tv_usec / 1000,
                           (double)usage.ru_stime.tv_sec * 1000 + (double)usage.ru_stime.tv_usec / 1000, usage.ru_maxrss, exit_status);
                    fflush(stdout);
                }
                if (valid && mode == 1)
                {
                    valid = same_file(objects[0], objects[1]);
                    if (!valid)
                    {
                        fprintf(stderr, "object mismatch: %s\n", cases[c].name);
                    }
                }
            }
        }
    }
    if (stages != NULL)
    {
        valid = fclose(stages) == 0 && valid;
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = false;
    if (argc == 3 && strcmp(argv[1], "generate") == 0)
    {
        valid = generate(argv[2]);
    }
    else if (argc == 6 && strcmp(argv[1], "measure") == 0)
    {
        // One invocation is one round: acquire the 9700X lock for each invocation, outside this harness.
        valid = measure(argv[2], argv[3], argv[4], (unsigned)strtoul(argv[5], NULL, 10));
    }
    else
    {
        fprintf(stderr, "usage: campaign generate DIR | campaign measure BASE HEAD DIR ROUND\n");
    }
    return valid ? 0 : 1;
}
