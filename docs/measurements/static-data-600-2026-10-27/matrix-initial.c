// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded qualification matrix for Buster #600. Timings use the unmodified time-runs command.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <fcntl.h>

typedef struct Case Case;
struct Case
{
    const char* mode;
    unsigned long long size;
    unsigned count;
    char name[64];
    char input[4096];
    char size_text[32];
    char count_text[32];
};

static bool run(char* const* arguments, const char* output, const char* errors, struct rusage* usage)
{
    fflush(stdout);
    const pid_t child = fork();
    if (child == 0)
    {
        bool valid = true;
        const char* paths[] = { output, errors };
        for (unsigned i = 0; i < 2; i += 1)
        {
            if (paths[i] != 0)
            {
                const int file = open(paths[i], O_WRONLY | O_CREAT | O_TRUNC, 0644);
                valid = file >= 0 && dup2(file, i == 0 ? STDOUT_FILENO : STDERR_FILENO) >= 0 && valid;
                if (file >= 0)
                {
                    close(file);
                }
            }
        }
        if (valid)
        {
            execvp(arguments[0], arguments);
        }
        _exit(127);
    }
    int status = -1;
    const bool valid = child > 0 && wait4(child, &status, 0, usage) == child && WIFEXITED(status) && WEXITSTATUS(status) == 0;
    if (!valid)
    {
        fprintf(stderr, "FAILED command %s, wait status %d\n", arguments[0], status);
    }
    return valid;
}

static bool same_file(const char* left, const char* right)
{
    FILE* a = fopen(left, "rb");
    FILE* b = fopen(right, "rb");
    bool valid = a != 0 && b != 0;
    unsigned char first[65536];
    unsigned char second[65536];
    size_t count = sizeof(first);
    while (valid && count == sizeof(first))
    {
        count = fread(first, 1, sizeof(first), a);
        const size_t other = fread(second, 1, sizeof(second), b);
        valid = count == other && memcmp(first, second, count) == 0 && !ferror(a) && !ferror(b);
    }
    if (a != 0)
    {
        fclose(a);
    }
    if (b != 0)
    {
        fclose(b);
    }
    return valid;
}

static bool verify_case(const Case* test)
{
    const char* sources[] = { "base", "head-final", "clang" };
    char outputs[3][4096];
    bool valid = true;
    for (unsigned i = 0; valid && i < 3; i += 1)
    {
        char executable[4096];
        snprintf(executable, sizeof(executable), "./%s/build/compiler", sources[i]);
        snprintf(outputs[i], sizeof(outputs[i]), "objects/%s-%s.o", test->name, sources[i]);
        char errors[4096];
        snprintf(errors, sizeof(errors), "logs/%s-%s-errors.txt", test->name, sources[i]);
        char* buster[] = { executable, "--lanes", "1", "-c", (char*)test->input, "-o", outputs[i], 0 };
        char* clang[] = { "clang", "-Wno-overlength-strings", "-O0", "-c", (char*)test->input, "-o", outputs[i], 0 };
        struct rusage usage = { 0 };
        valid = run(i == 2 ? clang : buster, "/dev/null", errors, &usage);
        printf("COMPILER_RESOURCE %s %s peak_kib=%ld minor=%ld major=%ld user_us=%ld system_us=%ld\n", test->name, sources[i],
               usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, usage.ru_utime.tv_sec * 1000000L + usage.ru_utime.tv_usec,
               usage.ru_stime.tv_sec * 1000000L + usage.ru_stime.tv_usec);
        char* verify[] = { "./verify", (char*)test->mode, (char*)test->size_text, (char*)test->count_text, outputs[i], 0 };
        valid = valid && run(verify, 0, 0, 0);
        if (valid && i != 2)
        {
            char traffic[4096];
            char probe[4096];
            snprintf(traffic, sizeof(traffic), "logs/%s-%s-traffic.tsv", test->name, sources[i]);
            snprintf(probe, sizeof(probe), "./probe-%s/probe", i == 0 ? "base" : "head");
            char* telemetry[] = { probe, (char*)test->mode, (char*)test->size_text, (char*)test->count_text, 0 };
            valid = run(telemetry, traffic, errors, 0);
            snprintf(errors, sizeof(errors), "logs/%s-%s-stages.txt", test->name, sources[i]);
            char* stages[] = { executable, "--time-stages", "--lanes", "1", "-c", (char*)test->input, "-o", "objects/current.o", 0 };
            valid = valid && run(stages, "/dev/null", errors, 0);
        }
    }
    valid = valid && same_file(outputs[0], outputs[1]);
    printf("CASE_%s %s\n", valid ? "OK" : "FAILED", test->name);
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    Case cases[19] = { 0 };
    const char* modes[] = { "writable", "readonly", "relocation", "literal" };
    const unsigned sizes[] = { 1, 4, 16, 64 };
    char directory[4096];
    valid = valid && getcwd(directory, sizeof(directory)) != 0;
    unsigned count = 0;
    for (unsigned mode = 0; valid && mode < 4; mode += 1)
    {
        for (unsigned size = 0; size < 4; size += 1)
        {
            cases[count].mode = modes[mode];
            cases[count].size = (unsigned long long)sizes[size] * 1024 * 1024;
            cases[count].count = 1;
            snprintf(cases[count].name, sizeof(cases[count].name), "%s-%u", modes[mode], sizes[size]);
            count += 1;
        }
    }
    for (unsigned mode = 0; valid && mode < 3; mode += 1)
    {
        cases[count].mode = modes[mode];
        cases[count].size = 65536;
        cases[count].count = 256;
        snprintf(cases[count].name, sizeof(cases[count].name), "%s-batch", modes[mode]);
        count += 1;
    }
    for (unsigned i = 0; valid && i < count; i += 1)
    {
        snprintf(cases[i].input, sizeof(cases[i].input), "%s/inputs/%s.c", directory, cases[i].name);
        snprintf(cases[i].size_text, sizeof(cases[i].size_text), "%llu", cases[i].size);
        snprintf(cases[i].count_text, sizeof(cases[i].count_text), "%u", cases[i].count);
        printf("MATRIX_CASE %u %s %llu %u\n", i + 1, cases[i].name, cases[i].size, cases[i].count);
    }
    if (valid && strcmp(argv[1], "--verify") == 0)
    {
        for (unsigned i = 0; valid && i < count; i += 1)
        {
            valid = verify_case(cases + i);
        }
    }
    else if (valid && strcmp(argv[1], "--time") == 0)
    {
        char base[4096];
        char head[4096];
        char copies[4096];
        char output[4096];
        snprintf(base, sizeof(base), "%s/base/build/compiler", directory);
        snprintf(head, sizeof(head), "%s/head-final/build/compiler", directory);
        snprintf(copies, sizeof(copies), "%s/copies", directory);
        snprintf(output, sizeof(output), "%s/objects/current.o", directory);
        char* arguments[256] = { head, "time-runs", "--runs", "9", "--warmups", "2", "--copies", "2", "--directory", copies,
                                 "--build", "base", base, "--build", "head", head };
        unsigned at = 16;
        for (unsigned i = 0; i < count; i += 1)
        {
            arguments[at++] = "--list";
            arguments[at++] = "--lanes";
            arguments[at++] = "1";
            arguments[at++] = "-c";
            arguments[at++] = cases[i].input;
            arguments[at++] = "-o";
            arguments[at++] = output;
        }
        arguments[at] = 0;
        valid = run(arguments, 0, 0, 0);
    }
    else
    {
        valid = false;
    }
    printf("MATRIX_%s\n", valid ? "OK" : "FAILED");
    return valid ? 0 : 1;
}
