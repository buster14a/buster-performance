// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #597 fresh-process matrix. A single sweep is a bounded benchmark run.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static const unsigned sizes[] = { 16, 32, 64, 128, 255, 256, 257, 512, 1024, 4096, 8192, 16384, 65536, 262144 };

static uint64_t now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC_RAW, &t);
    return (uint64_t)t.tv_sec * UINT64_C(1000000000) + (uint64_t)t.tv_nsec;
}

static int command(char* const* arguments, const char* output, const char* errors, uint64_t* elapsed, struct rusage* usage)
{
    const uint64_t begin = now();
    const pid_t child = fork();
    if (child == 0)
    {
        const int out = open(output, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        const int err = open(errors, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (out >= 0 && err >= 0 && dup2(out, STDOUT_FILENO) >= 0 && dup2(err, STDERR_FILENO) >= 0)
        {
            execvp(arguments[0], arguments);
        }
        _exit(127);
    }
    int status = -1;
    pid_t waited = -1;
    do
    {
        waited = child > 0 ? wait4(child, &status, 0, usage) : -1;
    } while (waited < 0 && errno == EINTR);
    *elapsed = now() - begin;
    return waited == child && WIFEXITED(status) ? WEXITSTATUS(status) : 128;
}

static unsigned compare_runtime(unsigned pass)
{
    static const char* const candidates[] = { "base", "head", "forced" };
    unsigned failures = 0;
    for (unsigned s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s += 1)
    {
        for (unsigned position = 0; position < 3; position += 1)
        {
            const unsigned v = pass % 2 ? 2 - position : position;
            char executable[96], output[128], errors[128];
            snprintf(executable, sizeof(executable), "runs/%s-%u", candidates[v], sizes[s]);
            if (access(executable, X_OK) == 0)
            {
                snprintf(output, sizeof(output), "logs/runtime-%s-%u-%u.log", candidates[v], sizes[s], pass);
                snprintf(errors, sizeof(errors), "logs/runtime-%s-%u-%u.err", candidates[v], sizes[s], pass);
                char* const run[] = { executable, NULL };
                uint64_t elapsed = 0;
                struct rusage usage = { 0 };
                const int status = command(run, output, errors, &elapsed, &usage);
                fprintf(stderr, "runtime pass=%u size=%u version=%s status=%d wall_ns=%" PRIu64 "\n", pass, sizes[s], candidates[v], status, elapsed);
                failures += status != 0;
            }
        }
    }
    return failures;
}

int main(int argc, char** argv)
{
    const unsigned pass = argc >= 2 ? (unsigned)strtoul(argv[1], NULL, 10) : 0;
    const int runtime = argc == 3 && strcmp(argv[2], "runtime") == 0;
    const int full = argc == 3 && strcmp(argv[2], "full") == 0;
    static const char* const modes[] = { "copy", "kept", "same" };
    static const char* const versions[] = { "base", "head" };
    unsigned failures = 0;
    if (runtime)
    {
        failures += compare_runtime(pass);
    }
    else
    {
        puts("pass,size,mode,version,sample,status,wall_ns,user_us,system_us,peak_kb,minor_faults");
    }
    for (unsigned s = 0; !runtime && s < sizeof(sizes) / sizeof(sizes[0]); s += 1)
    {
        for (unsigned m = 0; m < 3; m += 1)
        {
            unsigned accepted[2] = { 0, 0 };
            for (unsigned sample = 0; sample < (full ? 35u : 13u); sample += 1)
            {
                for (unsigned position = 0; position < 2; position += 1)
                {
                    const unsigned v = (position + sample + pass) % 2;
                    char compiler[96], input[96], object[96], errors[128];
                    snprintf(compiler, sizeof(compiler), "../%s/build/compiler", versions[v]);
                    snprintf(input, sizeof(input), "inputs/%u-%s.c", sizes[s], modes[m]);
                    snprintf(object, sizeof(object), "objects/%s-%u-%s.o", versions[v], sizes[s], modes[m]);
                    snprintf(errors, sizeof(errors), "logs/compile-%s-%u-%s-%u.err", versions[v], sizes[s], modes[m], pass);
                    char* const arguments[] = { compiler, "--lanes", "1", "-c", input, "-o", object, NULL };
                    uint64_t elapsed = 0;
                    struct rusage usage = { 0 };
                    const int status = command(arguments, "/dev/null", errors, &elapsed, &usage);
                    accepted[v] = status == 0;
                    failures += v == 1 && status != 0;
                    if (sample >= 2)
                    {
                        printf("%u,%u,%s,%s,%u,%d,%" PRIu64 ",%ld,%ld,%ld,%ld\n", pass, sizes[s], modes[m], versions[v], sample - 2, status,
                               elapsed, usage.ru_utime.tv_sec * 1000000L + usage.ru_utime.tv_usec,
                               usage.ru_stime.tv_sec * 1000000L + usage.ru_stime.tv_usec, usage.ru_maxrss, usage.ru_minflt);
                    }
                }
            }
            for (unsigned v = 0; pass == 0 && v < 2; v += 1)
            {
                char compiler[96], input[96], object[96], output[128], errors[128];
                snprintf(compiler, sizeof(compiler), "../%s/build/compiler", versions[v]);
                snprintf(input, sizeof(input), "inputs/%u-%s.c", sizes[s], modes[m]);
                snprintf(object, sizeof(object), "objects/%s-%u-%s.o", versions[v], sizes[s], modes[m]);
                snprintf(output, sizeof(output), "logs/shape-%s-%u-%s.out", versions[v], sizes[s], modes[m]);
                snprintf(errors, sizeof(errors), "logs/stages-%s-%u-%s.err", versions[v], sizes[s], modes[m]);
                char* const stages[] = { compiler, "--lanes", "1", "--verify", "--time-stages", "-c", input, "-o", object, NULL };
                uint64_t elapsed = 0;
                struct rusage usage = { 0 };
                command(stages, output, errors, &elapsed, &usage);
                if (accepted[v])
                {
                    snprintf(errors, sizeof(errors), "logs/counts-%s-%u-%s.err", versions[v], sizes[s], modes[m]);
                    char* const counts[] = { compiler, "benchmark-backend-source", "--only", "vector", input, NULL };
                    command(counts, output, errors, &elapsed, &usage);
                }
            }
        }
    }
    if (full && failures == 0)
    {
        char* const build[] = { "bash", "build-runtime.sh", NULL };
        uint64_t elapsed = 0;
        struct rusage usage = { 0 };
        failures += command(build, "logs/build-runtime.log", "logs/build-runtime.err", &elapsed, &usage) != 0;
        for (unsigned round = 0; failures == 0 && round < 3; round += 1)
        {
            failures += compare_runtime(round);
        }
    }
    fprintf(stderr, "qualification_failures=%u\n", failures);
    return failures == 0 ? 0 : 1;
}
