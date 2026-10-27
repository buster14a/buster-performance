// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Fresh-process measurements. Pin this controller to CPU 2 under the shared 9700X lock, once per round.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
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
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &time);
    return (uint64_t)time.tv_sec * UINT64_C(1000000000) + (uint64_t)time.tv_nsec;
}

static bool compile(const char* compiler, const char* input, const char* object, const char* log,
                    unsigned round, const char* mode, uint64_t size, unsigned role, int repetition, bool stages)
{
    const uint64_t start = now();
    const pid_t child = fork();
    if (child == 0)
    {
        const int output = open(log, O_WRONLY | O_CREAT | O_TRUNC, 0600);
        if (output < 0 || dup2(output, STDERR_FILENO) < 0 || dup2(output, STDOUT_FILENO) < 0)
        {
            _exit(126);
        }
        close(output);
        if (stages)
        {
            execl(compiler, compiler, "--lanes", "1", "--time-stages", "-c", input, "-o", object, (char*)NULL);
        }
        else
        {
            execl(compiler, compiler, "--lanes", "1", "-c", input, "-o", object, (char*)NULL);
        }
        _exit(127);
    }
    struct rusage usage = { 0 };
    int status = -1;
    pid_t waited = -1;
    do
    {
        waited = child > 0 ? wait4(child, &status, 0, &usage) : -1;
    }
    while (waited == -1 && errno == EINTR && child > 0);
    const uint64_t elapsed = now() - start;
    const int exit_status = waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 128;
    if (!stages)
    {
        printf("%u\t%s\t%" PRIu64 "\t%s\t%d\t%" PRIu64 "\t%lld\t%ld\t%ld\t%ld\t%d\n", round, mode, size,
               role != 0 ? "head" : "base", repetition, elapsed,
               (long long)usage.ru_stime.tv_sec * 1000000 + usage.ru_stime.tv_usec,
               usage.ru_minflt, usage.ru_majflt, usage.ru_maxrss, exit_status);
        fflush(stdout);
    }
    return exit_status == 0;
}

int main(int argc, char** argv)
{
    bool valid = argc == 6 || argc == 7;
    if (valid)
    {
        const char* modes[] = { "bss", "zero", "tls", "designated", "overwrite", "bits", "reloc", "const" };
        const uint64_t sizes[] = { 1048576, 4194304, 16777216, 67108864, 268435456 };
        const unsigned round = (unsigned)strtoul(argv[5], NULL, 10);
        puts("round\tcase\tN\trole\trepetition\twall_ns\tsystem_us\tminor_faults\tmajor_faults\tpeak_rss_kb\tstatus");
        for (unsigned index = 0; valid && index < 43; index += 1)
        {
            const unsigned case_index = (index + round * 7) % 43;
            const char* mode = case_index < 40 ? modes[case_index / 5] : case_index == 40 ? "negative" : case_index == 41 ? "dense" : "dense-tail-zero";
            const uint64_t size = case_index < 40 ? sizes[case_index % 5] : case_index == 40 ? 16 : 65536;
            char input[1024];
            snprintf(input, sizeof(input), "%s/%s-%" PRIu64 ".c", argv[3], mode, size);
            for (int repetition = -1; valid && repetition < 7; repetition += 1)
            {
                for (unsigned order = 0; valid && order < 2; order += 1)
                {
                    const unsigned role = (order + (unsigned)(repetition + 1) + round) % 2;
                    char object[1024];
                    char log[1024];
                    snprintf(object, sizeof(object), "%s/%s-%" PRIu64 "-%s.o", argv[4], mode, size, role != 0 ? "head" : "base");
                    snprintf(log, sizeof(log), "%s/compile.err", argv[4]);
                    valid = compile(argv[1 + role], input, object, log, round, mode, size, role, repetition, false);
                }
            }
            for (unsigned role = 0; valid && role < 2; role += 1)
            {
                char object[1024];
                char log[1024];
                snprintf(object, sizeof(object), "%s/%s-%" PRIu64 "-%s.o", argv[4], mode, size, role != 0 ? "head" : "base");
                snprintf(log, sizeof(log), "%s/stages-%u-%s-%" PRIu64 "-%s.txt", argv[4], round, mode, size, role != 0 ? "head" : "base");
                valid = compile(argv[1 + role], input, object, log, round, mode, size, role, -1, true);
            }
        }
        for (int repetition = -1; valid && argc == 7 && repetition < 7; repetition += 1)
        {
            for (unsigned order = 0; valid && order < 2; order += 1)
            {
                const unsigned role = (order + (unsigned)(repetition + 1) + round) % 2;
                char object[1024];
                snprintf(object, sizeof(object), "%s/sqlite-%s.o", argv[4], role != 0 ? "head" : "base");
                valid = compile(argv[1 + role], argv[6], object, "/dev/null", round, "sqlite", 0, role, repetition, false);
            }
        }
    }
    return valid && !ferror(stdout) ? 0 : 1;
}
