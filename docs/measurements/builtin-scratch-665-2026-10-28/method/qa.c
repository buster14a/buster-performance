// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded compile/link/runtime/frame receipt for generated issue665 inputs.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static int run(FILE* receipt, char* const args[], const char* log)
{
    struct timespec start;
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    pid_t child = fork();
    int status = -1;
    struct rusage usage = { 0 };
    if (child == 0)
    {
        int fd = open(log, O_CREAT | O_TRUNC | O_WRONLY, 0666);
        if (fd < 0 || dup2(fd, STDOUT_FILENO) < 0 || dup2(fd, STDERR_FILENO) < 0)
        {
            _exit(126);
        }
        close(fd);
        execvp(args[0], args);
        _exit(127);
    }
    else if (child > 0)
    {
        while (wait4(child, &status, 0, &usage) < 0 && errno == EINTR)
        {
        }
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    const double ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) * 1e-6;
    fprintf(receipt, "status=%d wall_ms=%.6f rss_kib=%ld major=%ld log=%s argv=", status, ms, usage.ru_maxrss, usage.ru_majflt, log);
    for (unsigned i = 0; args[i] != NULL; i += 1)
    {
        fprintf(receipt, "%s%s", i != 0 ? " " : "", args[i]);
    }
    fprintf(receipt, "\n");
    fflush(receipt);
    return status;
}

static bool equal(const char* first, const char* second)
{
    FILE* a = fopen(first, "rb");
    FILE* b = fopen(second, "rb");
    bool same = a != NULL && b != NULL;
    int x = 0;
    int y = 0;
    while (same && x != EOF)
    {
        x = fgetc(a);
        y = fgetc(b);
        same = x == y;
    }
    same = same && !ferror(a) && !ferror(b);
    if (a != NULL)
    {
        fclose(a);
    }
    if (b != NULL)
    {
        fclose(b);
    }
    return same;
}

static bool runtime_valid(const char* path)
{
    const int64_t boundaries[] = { INT32_MIN, INT32_MIN + 1, -1000001, -65536, -127, -1, 0, 1, 2, 31, 127, 65535, 1000001, INT32_MAX - 1, INT32_MAX };
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    uint32_t state = 665;
    for (unsigned i = 0; valid && i < 143; i += 1)
    {
        state = i >= 15 ? state * UINT32_C(1664525) + UINT32_C(1013904223) : state;
        const int64_t expected = i < 15 ? boundaries[i] : (int32_t)state;
        char line[256];
        long long input;
        unsigned long long value;
        char extra;
        valid = fgets(line, sizeof(line), file) != NULL && strchr(line, '\n') != NULL &&
                sscanf(line, "%lld %llu %c", &input, &value, &extra) == 2 && input == expected && value <= UINT32_MAX;
    }
    if (file != NULL)
    {
        valid = valid && fgetc(file) == EOF && !ferror(file);
        fclose(file);
    }
    return valid;
}

static int qa_run(int argc, char** argv)
{
    int status = argc == 6 ? 0 : 1;
    char receipt_path[4096];
    snprintf(receipt_path, sizeof(receipt_path), "%s/qa.log", status == 0 ? argv[5] : "/tmp/invalid");
    FILE* receipt = status == 0 ? fopen(receipt_path, "w") : NULL;
    status = receipt != NULL ? status : 1;
    const unsigned counts[] = { 1, 64, 1000, 2000, 4000, 8000 };
    const char* recipes[] = { "add", "sub", "mul", "popcount", "wide" };
    const char* roles[] = { "clang", "vector", "scalar", "base" };
    unsigned cases = 0;
    for (unsigned recipe = 0; status == 0 && recipe < sizeof(recipes) / sizeof(*recipes); recipe += 1)
    {
        for (unsigned size = 0; status == 0 && size < sizeof(counts) / sizeof(*counts); size += 1)
        {
            char source[4096];
            char reference[4096];
            snprintf(source, sizeof(source), "%s/%s-%u.c", argv[3], recipes[recipe], counts[size]);
            snprintf(reference, sizeof(reference), "%s/%s-%u-clang.txt", argv[5], recipes[recipe], counts[size]);
            for (unsigned role = 0; status == 0 && role < 4; role += 1)
            {
                char object[4096];
                char executable[4096];
                char output[4096];
                char log[4096];
                char link_log[4096];
                char frame[4096];
                snprintf(object, sizeof(object), "%s/%s-%u-%s.o", argv[5], recipes[recipe], counts[size], roles[role]);
                snprintf(executable, sizeof(executable), "%s/%s-%u-%s.exe", argv[5], recipes[recipe], counts[size], roles[role]);
                snprintf(output, sizeof(output), "%s/%s-%u-%s.txt", argv[5], recipes[recipe], counts[size], roles[role]);
                snprintf(log, sizeof(log), "%s/%s-%u-%s.compile.log", argv[5], recipes[recipe], counts[size], roles[role]);
                snprintf(link_log, sizeof(link_log), "%s/%s-%u-%s.link.log", argv[5], recipes[recipe], counts[size], roles[role]);
                snprintf(frame, sizeof(frame), "%s/%s-%u-%s.frame", argv[5], recipes[recipe], counts[size], roles[role]);
                char* clang[] = { "clang", "-std=gnu17", "-O0", "-fwrapv", "-c", source, "-o", object, NULL };
                char* native[] = { role == 3 ? argv[1] : argv[2], "--lanes", "1", "--verify", "-std=gnu17", "-c", source, "-o", object, NULL };
                char* scalar[] = { argv[2], "--lanes", "1", "--verify", "--scalar", "-std=gnu17", "-c", source, "-o", object, NULL };
                status = run(receipt, role == 0 ? clang : role == 2 ? scalar : native, log) != 0 ? 1 : status;
                if (status == 0)
                {
                    char* link[] = { "clang", "-O0", argv[4], object, "-o", executable, NULL };
                    status = run(receipt, link, link_log) != 0 ? 1 : status;
                }
                if (status == 0)
                {
                    char* execute[] = { executable, NULL };
                    status = run(receipt, execute, output) != 0 ? 1 : status;
                }
                if (status == 0)
                {
                    char* disassemble[] = { "objdump", "-d", "--start-address=0", "--stop-address=96", object, NULL };
                    status = run(receipt, disassemble, frame) != 0 ? 1 : status;
                }
                if (status == 0 && role != 0)
                {
                    const bool same = runtime_valid(reference) && runtime_valid(output) && equal(reference, output);
                    fprintf(receipt, "runtime_equal=%u source=%s role=%s inputs=143\n", same, source, roles[role]);
                    status = same ? status : 1;
                }
                if (status == 0 && role == 2)
                {
                    char vector_object[4096];
                    snprintf(vector_object, sizeof(vector_object), "%s/%s-%u-vector.o", argv[5], recipes[recipe], counts[size]);
                    const bool same = equal(vector_object, object);
                    fprintf(receipt, "object_equal=%u source=%s roles=vector,scalar\n", same, source);
                    status = same ? status : 1;
                }
                cases += status == 0;
            }
        }
    }
    if (receipt != NULL)
    {
        fprintf(receipt, "compiled_and_executed=%u status=%d\n", cases, status);
        fclose(receipt);
    }
    return status;
}

int main(int argc, char** argv)
{
    const bool validate = argc == 3 && strcmp(argv[1], "--validate-runtime") == 0;
    const int status = validate ? (runtime_valid(argv[2]) ? 0 : 1) : qa_run(argc, argv);
    return status;
}
