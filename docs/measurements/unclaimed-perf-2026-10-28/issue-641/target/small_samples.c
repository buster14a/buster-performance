// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original fresh-process, paired c-testsuite measurement. Round 0 is a declared warmup.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
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

typedef struct Input
{
    unsigned tokens;
    char bin[32];
    char name[128];
} Input;

static uint64_t now_ns(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC_RAW, &value);
    return (uint64_t)value.tv_sec * UINT64_C(1000000000) + (uint64_t)value.tv_nsec;
}

static bool equal_files(const char* left, const char* right)
{
    FILE* a = fopen(left, "rb");
    FILE* b = fopen(right, "rb");
    bool same = a != NULL && b != NULL;
    uint8_t x[65536], y[65536];
    bool reading = same;
    while (reading)
    {
        const size_t n = fread(x, 1, sizeof(x), a);
        const size_t m = fread(y, 1, sizeof(y), b);
        same = n == m && memcmp(x, y, n) == 0 && !ferror(a) && !ferror(b);
        reading = same && n != 0;
    }
    if (a != NULL) fclose(a);
    if (b != NULL) fclose(b);
    return same;
}

int main(int argc, char** argv)
{
    int result = argc >= 9 ? 0 : 2;
    const unsigned rounds = result == 0 ? (unsigned)strtoul(argv[1], NULL, 10) : 0;
    result = rounds >= 1 && rounds <= 31 ? result : 2;
    FILE* list = result == 0 ? fopen(argv[2], "r") : NULL;
    result = list != NULL ? result : 2;
    Input inputs[512];
    unsigned count = 0;
    char line[8192];
    while (result == 0 && fgets(line, sizeof(line), list) != NULL)
    {
        char path[PATH_MAX];
        Input* input = count < 512 ? inputs + count : NULL;
        result = input != NULL && sscanf(line, "%u %31s %4095s", &input->tokens, input->bin, path) == 3 ? 0 : 2;
        if (result == 0)
        {
            const char* name = strrchr(path, '/');
            name = name != NULL ? name + 1 : path;
            const int length = snprintf(input->name, sizeof(input->name), "%s", name);
            result = length > 0 && (size_t)length < sizeof(input->name) ? 0 : 2;
            count += 1;
        }
    }
    if (list != NULL) fclose(list);
    result = count != 0 ? result : 2;
    if (result == 0) result = mkdir(argv[4], 0755) == 0 || errno == EEXIST ? 0 : 2;
    char** command = result == 0 ? calloc((size_t)argc + 4, sizeof(char*)) : NULL;
    result = command != NULL ? result : 2;
    int quiet = result == 0 ? open("/dev/null", O_WRONLY) : -1;
    result = quiet >= 0 ? result : 2;
    printf("round\trole\tfile\ttokens\tbin\twall_ns\tuser_ns\tsystem_ns\tmaxrss_kb\tminor\tmajor\tstatus\tobject_bytes\n");
    unsigned paired = 0;
    for (unsigned round = 0; result == 0 && round <= rounds; round += 1)
    {
        for (unsigned file = 0; result == 0 && file < count; file += 1)
        {
            char source[PATH_MAX];
            char outputs[2][PATH_MAX];
            char errors[2][PATH_MAX];
            snprintf(source, sizeof(source), "%s/%s", argv[3], inputs[file].name);
            for (unsigned turn = 0; result == 0 && turn < 2; turn += 1)
            {
                const unsigned role = (round + file + turn) % 2;
                snprintf(outputs[role], sizeof(outputs[role]), "%s/r%02u-%s-role%u.o", argv[4], round, inputs[file].name, role);
                snprintf(errors[role], sizeof(errors[role]), "%s/r%02u-%s-role%u.err", argv[4], round, inputs[file].name, role);
                command[0] = argv[5 + role];
                int at = 1;
                for (int a = 7; a < argc; a += 1) command[at++] = argv[a];
                command[at++] = source;
                command[at++] = "-o";
                command[at++] = outputs[role];
                command[at] = NULL;
                const int error = open(errors[role], O_CREAT | O_TRUNC | O_WRONLY, 0644);
                const uint64_t begin = now_ns();
                const pid_t child = error >= 0 ? fork() : -1;
                if (child == 0)
                {
                    if (dup2(quiet, STDOUT_FILENO) < 0 || dup2(error, STDERR_FILENO) < 0) _exit(125);
                    execv(command[0], command);
                    _exit(127);
                }
                int status = 0;
                struct rusage usage = { 0 };
                pid_t waited = -1;
                if (child > 0)
                {
                    do { waited = wait4(child, &status, 0, &usage); } while (waited < 0 && errno == EINTR);
                }
                const uint64_t elapsed = now_ns() - begin;
                if (error >= 0) close(error);
                const int code = child > 0 && waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 125;
                struct stat object;
                const bool written = stat(outputs[role], &object) == 0 && object.st_size > 0;
                result = code == 0 && written ? 0 : 1;
                printf("%u\t%u\t%s\t%u\t%s\t%llu\t%llu\t%llu\t%ld\t%ld\t%ld\t%d\t%lld\n", round, role, inputs[file].name, inputs[file].tokens, inputs[file].bin,
                       (unsigned long long)elapsed, (unsigned long long)usage.ru_utime.tv_sec * 1000000000ULL + (unsigned long long)usage.ru_utime.tv_usec * 1000,
                       (unsigned long long)usage.ru_stime.tv_sec * 1000000000ULL + (unsigned long long)usage.ru_stime.tv_usec * 1000,
                       usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, code, written ? (long long)object.st_size : 0LL);
            }
            if (result == 0)
            {
                result = equal_files(outputs[0], outputs[1]) && equal_files(errors[0], errors[1]) ? 0 : 1;
                paired += result == 0;
            }
        }
        fflush(stdout);
    }
    if (quiet >= 0) close(quiet);
    free(command);
    fprintf(stderr, "small-samples: inputs=%u measured_rounds=%u warmup_rounds=1 byte_identical_object_and_diagnostic_pairs=%u outcome=%s\n", count, rounds, paired, result == 0 ? "passed" : "failed");
    return result;
}
