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
#include <limits.h>

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

static bool contains(const char* path, const char* text)
{
    FILE* file = fopen(path, "r");
    char line[4096];
    bool found = false;
    while (file != NULL && !found && fgets(line, sizeof(line), file) != NULL)
    {
        found = strstr(line, text) != NULL;
    }
    if (file != NULL)
    {
        fclose(file);
    }
    return found;
}

// Resume the fixed control protocol after its first three complete pairs and fourth head. Completed files are
// retained; only the queued suffix is run here. This is one bounded default-path control/counter experiment.
static bool finish_controls(void)
{
    char root[PATH_MAX];
    char temporary[PATH_MAX + 8];
    bool valid = getcwd(root, sizeof(root)) != NULL;
    snprintf(temporary, sizeof(temporary), "%s/tmp", valid ? root : "");
    char* options[] = {
        "-c", "-DSQLITE_OMIT_LOAD_EXTENSION", "-DSQLITE_THREADSAFE=0", "-DSQLITE_ENABLE_MEMSYS5", "-DSQLITE_ENABLE_RTREE",
        "-I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite",
        "/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c",
    };
    if (valid && !contains("logs/sqlite-3-base.log", "measure-compile: 0 failures"))
    {
        char* arguments[24] = { "../base/build/compiler", "measure-compile", "--runs", "11", "--warmups", "2", "--directory", temporary, "--" };
        unsigned count = 9;
        for (unsigned i = 0; i < sizeof(options) / sizeof(options[0]); i += 1)
        {
            arguments[count++] = options[i];
        }
        arguments[count] = NULL;
        valid = execute(arguments, "logs/sqlite-3-base.log").status == 0;
    }
    if (valid && !contains("logs/sqlite-3-base-perf.csv", "instructions:u"))
    {
        char* arguments[28] = { "perf", "stat", "-x,", "-r", "3", "-e", "instructions:u,cycles:u", "-o", "logs/sqlite-3-base-perf.csv", "--", "../base/build/compiler" };
        unsigned count = 11;
        for (unsigned i = 0; i < sizeof(options) / sizeof(options[0]); i += 1)
        {
            arguments[count++] = options[i];
        }
        arguments[count++] = "-o";
        arguments[count++] = "objects/sqlite-base.o";
        arguments[count] = NULL;
        valid = execute(arguments, "logs/sqlite-3-base-perf.log").status == 0;
    }
    valid = valid && same("objects/sqlite-base.o", "objects/sqlite-head.o");
    for (unsigned variant = 0; valid && variant < 2; variant += 1)
    {
        char csv[256];
        char log[256];
        char object[256];
        const char* name = variant == 0 ? "base" : "head";
        snprintf(csv, sizeof(csv), "logs/strings-160000-%s-perf.csv", name);
        snprintf(log, sizeof(log), "logs/strings-160000-%s-perf.log", name);
        snprintf(object, sizeof(object), "objects/strings-160000-%s.o", name);
        if (!contains(csv, "instructions:u"))
        {
            char* arguments[] = { "perf", "stat", "-x,", "-r", "3", "-e", "instructions:u,cycles:u", "-o", csv, "--",
                                  variant == 0 ? "../base/build/compiler" : "../head/build/compiler", "-c", "inputs/strings-160000.c", "-o", object, NULL };
            valid = execute(arguments, log).status == 0;
        }
    }
    valid = valid && same("objects/strings-160000-base.o", "objects/strings-160000-head.o");
    if (valid)
    {
        FILE* progress = fopen("control-progress.log", "a");
        valid = progress != NULL;
        if (progress != NULL)
        {
            valid = fputs("sqlite byte_identical=1 status=0\nstring_counters byte_identical=1 status=0\n", progress) >= 0;
            valid = fclose(progress) == 0 && valid;
        }
    }
    FILE* receipt = fopen("logs/control-resume-status.log", "w");
    if (receipt != NULL)
    {
        fprintf(receipt, "control-resume status=%u\n", valid ? 0 : 1);
        fclose(receipt);
    }
    if (valid)
    {
        char* arguments[] = { "bash", "finish.sh", NULL };
        valid = execute(arguments, "logs/record-validation.log").status == 0;
    }
    return valid;
}

static double median(double a, double b, double c)
{
    const double low = a < b ? a : b;
    const double high = a > b ? a : b;
    return c < low ? low : c > high ? high : c;
}

static bool comparison(const char* kind, unsigned id, unsigned first, unsigned last)
{
    static const char* const variants[] = { "base", "head", "tcc", "base-stages", "head-stages" };
    static const unsigned counts[] = { 20000, 40000, 80000, 160000 };
    bool valid = id < 7 && first < last && last <= 4;
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
    return valid;
}

// The separate-declaration paths and their integer control form one small matrix. Continue from the caller's
// current cohort, then finish the remaining shapes under the same bounded benchmark invocation. Exit 77 tells
// the original outer scheduler that every remaining case is complete; it must not enqueue duplicates.
static int compare_main(int argc, char** argv)
{
    static const char* const kinds[] = { "strings", "repeated", "wide", "records", "pointers", "characters", "integers" };
    bool valid = argc == 3 || argc == 5;
    const char* kind = valid ? argv[1] : "";
    const unsigned id = valid ? (unsigned)strtoul(argv[2], NULL, 10) : 7;
    const unsigned first = argc == 5 ? (unsigned)strtoul(argv[3], NULL, 10) : 0;
    const unsigned last = argc == 5 ? (unsigned)strtoul(argv[4], NULL, 10) : 4;
    valid = valid && id < 7 && first < last && last <= 4;
    const bool remaining = valid && argc == 5 && id >= 4;
    setvbuf(stdout, NULL, _IOLBF, 0);
    valid = valid && comparison(kind, id, first, remaining ? 4 : last);
    for (unsigned next = id + 1; valid && remaining && next < 7; next += 1)
    {
        char log[256];
        snprintf(log, sizeof(log), "logs/comparison-%s-0.csv", kinds[next]);
        valid = fflush(stdout) == 0 && freopen(log, "w", stdout) != NULL;
        if (valid)
        {
            setvbuf(stdout, NULL, _IOLBF, 0);
            valid = comparison(kinds[next], next, 0, 4);
        }
    }
    if (valid && remaining)
    {
        FILE* completed = fopen("comparisons-complete", "w");
        valid = completed != NULL;
        if (completed != NULL)
        {
            valid = fputs("comparisons status=0\n", completed) >= 0;
            valid = fclose(completed) == 0 && valid;
        }
    }
    return valid ? remaining ? 77 : 0 : 1;
}

int main(int argc, char** argv)
{
    const int status = argc == 2 && strcmp(argv[1], "--finish-controls") == 0 ? (finish_controls() ? 0 : 1) : compare_main(argc, argv);
    return status;
}
