// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// Matched-affinity compile cohorts for #673, adapted from this campaign's first-party cohort.c. Physical CPUs come
// only from the current affinity grant and sysfs. Shared cohorts give every compiler that same whole physical mask,
// independently of --lanes; pinned controls give one physical CPU per file worker. Raw wait4 and compiler stderr
// records are retained. Hardware traffic/migration counters and output-byte comparisons are separate controls.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <sched.h>
#include <signal.h>
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

#define COHORT_MAX_WORKERS 8u

static double cohort_seconds(void)
{
    struct timespec value;
    clock_gettime(CLOCK_MONOTONIC, &value);
    return (double)value.tv_sec + (double)value.tv_nsec / 1000000000.0;
}

static bool cohort_unsigned(const char* text, unsigned maximum, unsigned* value)
{
    char* end = NULL;
    errno = 0;
    const unsigned long parsed = strtoul(text, &end, 10);
    const bool valid = text[0] >= '0' && text[0] <= '9' && end != text && *end == 0 && errno == 0 && parsed > 0 && parsed <= maximum;
    *value = valid ? (unsigned)parsed : 0;
    return valid;
}

static unsigned cohort_cpus(int* cpus)
{
    cpu_set_t allowed;
    char identities[COHORT_MAX_WORKERS][128];
    unsigned count = 0;
    const bool valid = sched_getaffinity(0, sizeof(allowed), &allowed) == 0;
    // CPU 2 is the dedicated 9700X timing CPU. Prefer it only when the current grant permits it.
    for (int position = 0; valid && position <= CPU_SETSIZE && count < COHORT_MAX_WORKERS; position += 1)
    {
        const int cpu = position == 0 ? 2 : position - 1;
        if ((position != 0 && cpu == 2) || !CPU_ISSET(cpu, &allowed))
        {
            continue;
        }
        char path[128];
        snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/topology/core_cpus_list", cpu);
        FILE* stream = fopen(path, "r");
        char identity[128];
        const bool read = stream != NULL && fgets(identity, sizeof(identity), stream) != NULL;
        if (stream != NULL)
        {
            fclose(stream);
        }
        if (read)
        {
            bool duplicate = false;
            for (unsigned prior = 0; prior < count; prior += 1)
            {
                duplicate = duplicate || strcmp(identities[prior], identity) == 0;
            }
            if (!duplicate)
            {
                memcpy(identities[count], identity, strlen(identity) + 1);
                cpus[count++] = cpu;
            }
        }
    }
    return count;
}

static void cohort_mask_text(char* text, size_t capacity, const int* cpus, unsigned count, bool shared, unsigned slot)
{
    size_t used = 0;
    text[0] = 0;
    for (unsigned index = 0; index < (shared ? count : 1); index += 1)
    {
        const int cpu = cpus[shared ? index : slot];
        const int written = snprintf(text + used, capacity - used, "%s%d", index != 0 ? "," : "", cpu);
        if (written > 0 && (size_t)written < capacity - used)
        {
            used += (size_t)written;
        }
    }
}

int main(int argc, char** argv)
{
    int result = 2;
    unsigned jobs = 0, tasks = 0;
    const bool shared = argc >= 2 && strcmp(argv[1], "shared") == 0;
    const bool mode = argc >= 2 && (shared || strcmp(argv[1], "pinned") == 0);
    struct stat input;
    int cpus[COHORT_MAX_WORKERS];
    const unsigned cpu_count = cohort_cpus(cpus);
    bool valid = argc >= 9 && mode && cohort_unsigned(argv[2], COHORT_MAX_WORKERS, &jobs) &&
                 cohort_unsigned(argv[3], 10000, &tasks) && tasks >= jobs && jobs <= cpu_count && stat(argv[4], &input) == 0;
    if (valid)
    {
        const size_t length = strlen(argv[5]);
        const bool unique = length >= 6 && strcmp(argv[5] + length - 6, "XXXXXX") == 0;
        valid = unique ? mkdtemp(argv[5]) != NULL : mkdir(argv[5], 0755) == 0 || errno == EEXIST;
    }
    FILE* details = NULL;
    if (valid)
    {
        char path[PATH_MAX];
        const int length = snprintf(path, sizeof(path), "%s/children.tsv", argv[5]);
        details = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "w") : NULL;
        valid = details != NULL && fcntl(fileno(details), F_SETFD, FD_CLOEXEC) == 0;
    }
    if (valid)
    {
        pid_t running[COHORT_MAX_WORKERS] = { 0 };
        unsigned indices[COHORT_MAX_WORKERS] = { 0 };
        unsigned launched = 0, finished = 0, failed = 0;
        bool fatal = false;
        double user = 0, system = 0;
        long rss = 0, minor = 0, major = 0, voluntary = 0, involuntary = 0;
        uint64_t output_bytes = 0;
        fprintf(details, "task\taffinity\tstatus\tuser_s\tsystem_s\tmaxrss_kb\tminor_faults\tmajor_faults\tvoluntary_cs\tinvoluntary_cs\tobject_bytes\n");
        const double begin = cohort_seconds();
        while (finished < tasks && !fatal)
        {
            for (unsigned slot = 0; slot < jobs && launched < tasks && !fatal; slot += 1)
            {
                if (running[slot] != 0)
                {
                    continue;
                }
                const unsigned index = launched;
                const pid_t child = fork();
                if (child == 0)
                {
                    cpu_set_t set;
                    CPU_ZERO(&set);
                    for (unsigned cpu = 0; cpu < (shared ? cpu_count : 1); cpu += 1)
                    {
                        CPU_SET(cpus[shared ? cpu : slot], &set);
                    }
                    if (sched_setaffinity(0, sizeof(set), &set) != 0)
                    {
                        _exit(125);
                    }
                    char output[PATH_MAX], error[PATH_MAX];
                    const int out_length = snprintf(output, sizeof(output), "%s/output-%04u.o", argv[5], index);
                    const int err_length = snprintf(error, sizeof(error), "%s/stderr-%04u.txt", argv[5], index);
                    if (out_length <= 0 || (size_t)out_length >= sizeof(output) || err_length <= 0 || (size_t)err_length >= sizeof(error))
                    {
                        _exit(125);
                    }
                    if (unlink(output) != 0 && errno != ENOENT)
                    {
                        _exit(125);
                    }
                    const int error_fd = open(error, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                    const int quiet_fd = open("/dev/null", O_WRONLY);
                    if (error_fd < 0 || quiet_fd < 0 || dup2(error_fd, STDERR_FILENO) < 0 || dup2(quiet_fd, STDOUT_FILENO) < 0)
                    {
                        _exit(125);
                    }
                    close(error_fd);
                    close(quiet_fd);
                    char** command = calloc((size_t)argc, sizeof(char*));
                    if (command == NULL)
                    {
                        _exit(125);
                    }
                    for (int argument = 6; argument < argc; argument += 1)
                    {
                        command[argument - 6] = strcmp(argv[argument], "@OUTPUT@") == 0 ? output : argv[argument];
                    }
                    execv(command[0], command);
                    _exit(127);
                }
                fatal = child < 0;
                if (!fatal)
                {
                    running[slot] = child;
                    indices[slot] = index;
                    launched += 1;
                }
            }
            if (!fatal)
            {
                int status = 0;
                struct rusage usage;
                pid_t child;
                do
                {
                    child = wait4(-1, &status, 0, &usage);
                }
                while (child < 0 && errno == EINTR);
                fatal = child < 0;
                bool found = false;
                for (unsigned slot = 0; !fatal && slot < jobs; slot += 1)
                {
                    if (running[slot] != child)
                    {
                        continue;
                    }
                    found = true;
                    int code = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
                    char output[PATH_MAX];
                    snprintf(output, sizeof(output), "%s/output-%04u.o", argv[5], indices[slot]);
                    struct stat object;
                    const uint64_t bytes = stat(output, &object) == 0 ? (uint64_t)object.st_size : 0;
                    code = bytes == 0 && code == 0 ? 124 : code;
                    failed += code != 0;
                    const double u = (double)usage.ru_utime.tv_sec + (double)usage.ru_utime.tv_usec / 1000000.0;
                    const double s = (double)usage.ru_stime.tv_sec + (double)usage.ru_stime.tv_usec / 1000000.0;
                    user += u;
                    system += s;
                    rss = usage.ru_maxrss > rss ? usage.ru_maxrss : rss;
                    minor += usage.ru_minflt;
                    major += usage.ru_majflt;
                    voluntary += usage.ru_nvcsw;
                    involuntary += usage.ru_nivcsw;
                    output_bytes += bytes;
                    char mask[64];
                    cohort_mask_text(mask, sizeof(mask), cpus, cpu_count, shared, slot);
                    fprintf(details, "%u\t%s\t%d\t%.6f\t%.6f\t%ld\t%ld\t%ld\t%ld\t%ld\t%llu\n", indices[slot], mask, code, u, s,
                            usage.ru_maxrss, usage.ru_minflt, usage.ru_majflt, usage.ru_nvcsw, usage.ru_nivcsw, (unsigned long long)bytes);
                    running[slot] = 0;
                    finished += 1;
                }
                fatal = fatal || !found;
            }
        }
        // A collector failure must not leave compiler children running after the host's per-run lock is released.
        for (unsigned slot = 0; slot < jobs; slot += 1)
        {
            if (running[slot] > 0)
            {
                kill(running[slot], SIGKILL);
                pid_t waited;
                do
                {
                    waited = waitpid(running[slot], NULL, 0);
                }
                while (waited < 0 && errno == EINTR);
            }
        }
        const double elapsed = cohort_seconds() - begin;
        fatal = fclose(details) != 0 || fatal;
        details = NULL;
        char summary_path[PATH_MAX];
        const int summary_length = snprintf(summary_path, sizeof(summary_path), "%s/summary.json", argv[5]);
        FILE* summary = summary_length > 0 && (size_t)summary_length < sizeof(summary_path) ? fopen(summary_path, "w") : NULL;
        fatal = summary == NULL || fatal;
        FILE* report = summary != NULL ? summary : stdout;
        fprintf(report, "{\"affinity\":\"%s\",\"cpus\":[", shared ? "shared" : "pinned");
        for (unsigned cpu = 0; cpu < cpu_count; cpu += 1)
        {
            fprintf(report, "%s%d", cpu != 0 ? "," : "", cpus[cpu]);
        }
        fprintf(report, "],\"jobs\":%u,\"tasks\":%u,\"launched\":%u,\"finished\":%u,\"failures\":%u,\"collector_failure\":%s,\"source_bytes\":%lld,\"wall_s\":%.9f,\"MB_per_s\":%.6f,\"user_s\":%.6f,\"system_s\":%.6f,\"maxrss_kb\":%ld,\"minor_faults\":%ld,\"major_faults\":%ld,\"voluntary_cs\":%ld,\"involuntary_cs\":%ld,\"output_bytes\":%llu}\n",
               jobs, tasks, launched, finished, failed, fatal ? "true" : "false", (long long)input.st_size, elapsed,
               elapsed > 0 ? (double)input.st_size * (finished - failed) / elapsed / 1000000.0 : 0, user, system, rss, minor, major, voluntary, involuntary,
               (unsigned long long)output_bytes);
        if (summary != NULL)
        {
            fatal = fclose(summary) != 0 || fatal;
            printf("%s\n", summary_path);
        }
        result = fatal ? 2 : failed != 0;
    }
    if (details != NULL)
    {
        fclose(details);
    }
    if (result == 2)
    {
        fprintf(stderr, "usage: matched_cohort pinned|shared JOBS TASKS INPUT OUTDIR BINARY ARG... -o @OUTPUT@\n");
        fprintf(stderr, "requested workers must fit the current grant's discovered physical CPUs (up to 8)\n");
    }
    return result;
}
