// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded fresh-exec measurement helper. One child at a time on one CPU.
// Usage: fresh_process CPU REPEATS LIST NEW_OUTDIR COMPILER OPTIONS... @INPUT@ -o @OUTPUT@
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <sched.h>
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

static double seconds(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC_RAW, &value);
    return (double)value.tv_sec + (double)value.tv_nsec / 1000000000.0;
}

int main(int argc, char** argv)
{
    bool valid = argc >= 9 && argc <= 96;
    char* end = 0;
    const long cpu = valid ? strtol(argv[1], &end, 10) : -1;
    valid = valid && end != argv[1] && *end == 0 && cpu >= 0 && cpu < CPU_SETSIZE;
    const long repeats = valid ? strtol(argv[2], &end, 10) : 0;
    valid = valid && end != argv[2] && *end == 0 && repeats >= 1 && repeats <= 1024;
    char (*inputs)[PATH_MAX] = calloc(512, PATH_MAX);
    FILE* list = valid ? fopen(argv[3], "r") : 0;
    valid = valid && inputs != 0 && list != 0;
    unsigned count = 0;
    char* line = 0;
    size_t room = 0;
    ssize_t bytes;
    while (valid && (bytes = getline(&line, &room, list)) >= 0)
    {
        if (bytes > 0 && line[bytes - 1] == '\n') bytes -= 1;
        valid = bytes > 0 && (size_t)bytes < PATH_MAX && count < 512 && memchr(line, 0, (size_t)bytes) == 0;
        if (valid)
        {
            memcpy(inputs[count], line, (size_t)bytes);
            struct stat input;
            valid = stat(inputs[count], &input) == 0 && S_ISREG(input.st_mode);
            count += 1;
        }
    }
    valid = valid && !ferror(list) && count != 0 && count * (unsigned)repeats <= 4096;
    if (list != 0) fclose(list);
    free(line);
    bool input_placeholder = false;
    bool output_placeholder = false;
    for (int at = 6; valid && at < argc; at += 1)
    {
        input_placeholder = input_placeholder || strcmp(argv[at], "@INPUT@") == 0;
        output_placeholder = output_placeholder || strcmp(argv[at], "@OUTPUT@") == 0;
    }
    valid = valid && input_placeholder && output_placeholder && mkdir(argv[4], 0755) == 0;
    if (valid)
    {
        printf("task\tinput\tcpu\tstatus\twall_s\tuser_s\tsystem_s\tmaxrss_kb\tminor_faults\tmajor_faults\tvoluntary_cs\tinvoluntary_cs\tobject_bytes\n");
    }
    const double start = seconds();
    unsigned finished = 0;
    for (unsigned repetition = 0; valid && repetition < (unsigned)repeats; repetition += 1)
    {
        for (unsigned input = 0; valid && input < count; input += 1)
        {
            char output[PATH_MAX];
            char error[PATH_MAX];
            int out_length = snprintf(output, sizeof(output), "%s/output-%04u.o", argv[4], finished);
            int err_length = snprintf(error, sizeof(error), "%s/stderr-%04u.txt", argv[4], finished);
            valid = out_length > 0 && (size_t)out_length < sizeof(output) && err_length > 0 && (size_t)err_length < sizeof(error);
            const double begin = seconds();
            const pid_t child = valid ? fork() : -1;
            if (child == 0)
            {
                cpu_set_t set;
                CPU_ZERO(&set);
                CPU_SET((unsigned)cpu, &set);
                if (sched_setaffinity(0, sizeof(set), &set) != 0) _exit(125);
                int errors = open(error, O_WRONLY | O_CREAT | O_EXCL, 0644);
                int quiet = open("/dev/null", O_WRONLY);
                if (errors < 0 || quiet < 0 || dup2(errors, 2) < 0 || dup2(quiet, 1) < 0) _exit(125);
                close(errors);
                close(quiet);
                char* command[96] = { 0 };
                for (int at = 5; at < argc; at += 1)
                {
                    command[at - 5] = strcmp(argv[at], "@INPUT@") == 0 ? inputs[input] :
                                        strcmp(argv[at], "@OUTPUT@") == 0 ? output : argv[at];
                }
                execv(command[0], command);
                _exit(127);
            }
            struct rusage usage = { 0 };
            int status = 0;
            pid_t waited = -1;
            if (child > 0)
            {
                do { waited = wait4(child, &status, 0, &usage); } while (waited < 0 && errno == EINTR);
            }
            const double elapsed = seconds() - begin;
            const int code = waited == child && child > 0 ? (WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status)) : 125;
            struct stat object = { 0 };
            const bool has_object = stat(output, &object) == 0 && S_ISREG(object.st_mode) && object.st_size > 0;
            printf("%u\t%u\t%ld\t%d\t%.9f\t%.9f\t%.9f\t%ld\t%ld\t%ld\t%ld\t%ld\t%lld\n", finished, input, cpu, code, elapsed,
                   usage.ru_utime.tv_sec + usage.ru_utime.tv_usec / 1e6, usage.ru_stime.tv_sec + usage.ru_stime.tv_usec / 1e6,
                   usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, usage.ru_nvcsw, usage.ru_nivcsw, (long long)object.st_size);
            fflush(stdout);
            valid = valid && code == 0 && has_object;
            finished += 1;
        }
    }
    fprintf(stderr, "fresh-process count=%u inputs=%u repeats=%ld wall_s=%.9f result=%s\n", finished, count, repeats, seconds() - start, valid ? "passed" : "FAILED");
    free(inputs);
    return valid ? 0 : 1;
}
