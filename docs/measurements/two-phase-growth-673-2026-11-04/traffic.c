// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// #673's physical traffic: every policy of #695's matched-affinity and real-make controls, each sample under its own
// lock hold, with both memory controllers' CAS commands counted system-wide around it (buster-performance#49's UMC
// path, read and write apart) and the commands' own counters inside. Adapted from #695's frozen matrix.c and
// policy_balanced.c (evidence-673-spawn). An idle case gives the background's rate. Objects are compared byte for byte
// against each workload's first, outside the counted command.
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

typedef enum TrafficKind
{
    TRAFFIC_IDLE,
    TRAFFIC_DIRECT,
    TRAFFIC_MAKE,
} TrafficKind;

typedef struct TrafficCase TrafficCase;
struct TrafficCase
{
    const char* name;
    TrafficKind kind;
    // Direct cohorts (matched_cohort): pinned or shared affinity, the lane option and the cap, if any.
    bool pinned;
    const char* lanes;
    const char* cap;
    // Make cohorts (compile-budget.mk under make -j8): the workload (0 eight SQLite, 1 eight tiny, 2 two SQLite and six
    // tiny) and the role (0 jobserver with cap eight, 1 cap one, 2 free eight without MAKEFLAGS).
    unsigned workload;
    unsigned role;
};

static const TrafficCase cases[] = {
    { "idle", TRAFFIC_IDLE, false, NULL, NULL, 0, 0 },
    { "pinned-one", TRAFFIC_DIRECT, true, "--lanes=1", NULL, 0, 0 },
    { "shared-one", TRAFFIC_DIRECT, false, "--lanes=1", NULL, 0, 0 },
    { "shared-default", TRAFFIC_DIRECT, false, NULL, NULL, 0, 0 },
    { "shared-eight", TRAFFIC_DIRECT, false, "--lanes=8", NULL, 0, 0 },
    { "shared-cap-one", TRAFFIC_DIRECT, false, "--lanes=8", "--worker-budget=1", 0, 0 },
    { "sqlite-jobserver", TRAFFIC_MAKE, false, NULL, NULL, 0, 0 },
    { "sqlite-cap1", TRAFFIC_MAKE, false, NULL, NULL, 0, 1 },
    { "sqlite-free8", TRAFFIC_MAKE, false, NULL, NULL, 0, 2 },
    { "tiny-jobserver", TRAFFIC_MAKE, false, NULL, NULL, 1, 0 },
    { "tiny-cap1", TRAFFIC_MAKE, false, NULL, NULL, 1, 1 },
    { "tiny-free8", TRAFFIC_MAKE, false, NULL, NULL, 1, 2 },
    { "uneven-jobserver", TRAFFIC_MAKE, false, NULL, NULL, 2, 0 },
    { "uneven-cap1", TRAFFIC_MAKE, false, NULL, NULL, 2, 1 },
    { "uneven-free8", TRAFFIC_MAKE, false, NULL, NULL, 2, 2 },
};

static const char* options[] = {
    "-DSQLITE_OMIT_LOAD_EXTENSION", "-DSQLITE_THREADSAFE=0", "-DSQLITE_ENABLE_MEMSYS5", "-DSQLITE_ENABLE_RTREE",
    "-std=gnu17", "--predefines", "corpus/gnu17-pinned-predefines.txt", "--clang-features",
    "--target=x86_64-linux-gnu", "-march=znver5", "-nostdinc", "-isystem", "corpus/headers/usr/lib/clang/23/include",
    "-isystem", "corpus/headers/usr/local/include", "-isystem", "corpus/headers/usr/include", "-Icorpus/sqlite",
};

static bool traffic_equal(const char* first, const char* second)
{
    FILE* left = fopen(first, "rb");
    FILE* right = fopen(second, "rb");
    bool valid = left != NULL && right != NULL;
    bool reading = valid;
    while (reading)
    {
        char a[8192];
        char b[8192];
        const size_t ac = fread(a, 1, sizeof(a), left);
        const size_t bc = fread(b, 1, sizeof(b), right);
        valid = ac == bc && memcmp(a, b, ac) == 0 && valid;
        reading = valid && ac == sizeof(a);
    }
    if (left != NULL)
    {
        valid = !ferror(left) && fclose(left) == 0 && valid;
    }
    if (right != NULL)
    {
        valid = !ferror(right) && fclose(right) == 0 && valid;
    }
    return valid;
}

int main(int argc, char** argv)
{
    // OUTDIR COMPILER MATCHED_COHORT MAKEFILE USAGE_RECORD ROUNDS TAG; run from the frozen campaign root.
    bool valid = argc == 8;
    const unsigned rounds = valid ? (unsigned)strtoul(argv[6], NULL, 10) : 0;
    valid = valid && rounds > 0 && rounds <= 32 && (mkdir(argv[1], 0755) == 0 || errno == EEXIST);
    const unsigned count = sizeof(cases) / sizeof(cases[0]);
    // Each workload's first objects, the references: the direct cohorts' and SQLite make cohorts' are one SQLite object.
    char references[3][PATH_MAX] = { { 0 } };
    for (unsigned round = 0; valid && round < rounds; round += 1)
    {
        for (unsigned position = 0; valid && position < count; position += 1)
        {
            const unsigned row = (position + round * 4) % count;
            const TrafficCase* each = cases + row;
            char directory[PATH_MAX];
            char traffic[PATH_MAX];
            char counters[PATH_MAX];
            char receipt_path[PATH_MAX];
            char log_path[PATH_MAX];
            char usage[PATH_MAX];
            char make_options[4096];
            char output_directory[PATH_MAX + 16];
            char compiler[PATH_MAX + 16];
            snprintf(directory, sizeof(directory), "%s/r%02u-%s", argv[1], round, each->name);
            valid = mkdir(directory, 0755) == 0;
            snprintf(traffic, sizeof(traffic), "%s/umc.csv", directory);
            snprintf(counters, sizeof(counters), "%s/perf.csv", directory);
            snprintf(receipt_path, sizeof(receipt_path), "%s/argv.txt", directory);
            snprintf(log_path, sizeof(log_path), "%s/collector.stdout", directory);
            snprintf(usage, sizeof(usage), "%s/cohort.usage", directory);
            snprintf(output_directory, sizeof(output_directory), "DIRECTORY=%s", directory);
            snprintf(compiler, sizeof(compiler), "COMPILER=%s", argv[2]);
            char* command[96];
            unsigned n = 0;
            command[n++] = "/home/david/buster-fast-bench/exclusive.sh";
            command[n++] = "taskset";
            command[n++] = "-c";
            command[n++] = "0-7";
            command[n++] = "/usr/bin/perf";
            command[n++] = "stat";
            command[n++] = "-a";
            command[n++] = "-x,";
            command[n++] = "-o";
            command[n++] = traffic;
            command[n++] = "-e";
            command[n++] = "duration_time,amd_umc_0/umc_cas_cmd.rd/,amd_umc_0/umc_cas_cmd.wr/,amd_umc_1/umc_cas_cmd.rd/,amd_umc_1/umc_cas_cmd.wr/";
            command[n++] = "--";
            if (each->kind == TRAFFIC_IDLE)
            {
                command[n++] = "/usr/bin/sleep";
                command[n++] = "0.4";
            }
            else
            {
                command[n++] = "/usr/bin/perf";
                command[n++] = "stat";
                command[n++] = "-x,";
                command[n++] = "-o";
                command[n++] = counters;
                command[n++] = "-e";
                command[n++] = "task-clock,context-switches,cpu-migrations,cycles,instructions,page-faults";
                command[n++] = "--";
            }
            if (each->kind == TRAFFIC_DIRECT)
            {
                command[n++] = argv[3];
                command[n++] = each->pinned ? "pinned" : "shared";
                command[n++] = "8";
                command[n++] = "8";
                command[n++] = "corpus/sqlite/sqlite3.c";
                command[n++] = directory;
                command[n++] = argv[2];
                command[n++] = "--time-stages";
                if (each->lanes != NULL)
                {
                    command[n++] = (char*)each->lanes;
                }
                if (each->cap != NULL)
                {
                    command[n++] = (char*)each->cap;
                }
                for (unsigned option = 0; option < sizeof(options) / sizeof(options[0]); option += 1)
                {
                    command[n++] = (char*)options[option];
                }
                command[n++] = "-c";
                command[n++] = "corpus/sqlite/sqlite3.c";
                command[n++] = "-o";
                command[n++] = "@OUTPUT@";
            }
            else if (each->kind == TRAFFIC_MAKE)
            {
                size_t used = (size_t)snprintf(make_options, sizeof(make_options), "OPTIONS=--lanes=8 --worker-budget=%u", each->role == 1 ? 1 : 8);
                for (unsigned option = 0; valid && option < sizeof(options) / sizeof(options[0]); option += 1)
                {
                    const int length = snprintf(make_options + used, sizeof(make_options) - used, " %s", options[option]);
                    valid = length > 0 && (size_t)length < sizeof(make_options) - used;
                    used += valid ? (size_t)length : 0;
                }
                command[n++] = argv[5];
                command[n++] = usage;
                command[n++] = "/usr/bin/make";
                command[n++] = "-s";
                command[n++] = "-j8";
                command[n++] = "--jobserver-style=pipe";
                command[n++] = "-f";
                command[n++] = argv[4];
                command[n++] = compiler;
                command[n++] = make_options;
                command[n++] = output_directory;
                command[n++] = "LARGE=corpus/sqlite/sqlite3.c";
                command[n++] = "SMALL=issue673-spawn-1d/evidence-673-spawn/tiny.c";
                command[n++] = each->workload == 0 ? "LARGE_INDICES=0 1 2 3 4 5 6 7" : each->workload == 1 ? "LARGE_INDICES=" : "LARGE_INDICES=0 4";
                if (each->role == 2)
                {
                    command[n++] = "LAUNCH=env -u MAKEFLAGS";
                }
            }
            command[n] = NULL;
            FILE* receipt = valid ? fopen(receipt_path, "w") : NULL;
            valid = valid && receipt != NULL;
            for (unsigned argument = 0; valid && argument < n; argument += 1)
            {
                valid = fprintf(receipt, "%s\n", command[argument]) > 0;
            }
            if (receipt != NULL)
            {
                valid = fclose(receipt) == 0 && valid;
            }
            printf("run tag=%s round=%u case=%s directory=%s\n", argv[7], round, each->name, directory);
            fflush(stdout);
            const pid_t child = valid ? fork() : -1;
            if (child == 0)
            {
                char title[160];
                snprintf(title, sizeof(title), "673 traffic %s %s round %u", argv[7], each->name, round);
                setenv("EXCLUSIVE_OWNER", "claude-673", 1);
                setenv("EXCLUSIVE_TITLE", title, 1);
                setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/issues/673", 1);
                unsetenv("MAKEFLAGS");
                const int log = open(log_path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                if (log < 0 || dup2(log, STDOUT_FILENO) < 0 || dup2(log, STDERR_FILENO) < 0)
                {
                    _exit(125);
                }
                if (log > STDERR_FILENO)
                {
                    close(log);
                }
                execv(command[0], command);
                _exit(127);
            }
            int status = 0;
            pid_t waited = -1;
            if (child > 0)
            {
                do
                {
                    waited = waitpid(child, &status, 0);
                } while (waited < 0 && errno == EINTR);
            }
            valid = child > 0 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0 && valid;
            // The objects against their workload's first: SQLite for the direct cohorts and the SQLite make cohorts,
            // each index its own for the tiny and uneven ones.
            for (unsigned object = 0; valid && each->kind != TRAFFIC_IDLE && object < 8; object += 1)
            {
                char path[PATH_MAX];
                snprintf(path, sizeof(path), each->kind == TRAFFIC_MAKE ? "%s/%u.o" : "%s/output-%04u.o", directory, object);
                const unsigned workload = each->kind == TRAFFIC_MAKE ? each->workload : 0;
                char reference[PATH_MAX];
                if (references[workload][0] == 0)
                {
                    snprintf(references[workload], sizeof(references[workload]), "%s", directory);
                }
                const bool direct_reference = strstr(references[workload], "-shared-") != NULL || strstr(references[workload], "-pinned-") != NULL;
                const unsigned compared = workload == 0 ? 0 : object;
                snprintf(reference, sizeof(reference), direct_reference ? "%s/output-%04u.o" : "%s/%u.o", references[workload], compared);
                valid = traffic_equal(reference, path);
            }
            printf("result tag=%s round=%u case=%s status=%d identical=%u\n", argv[7], round, each->name, status, valid);
            fflush(stdout);
        }
    }
    if (!valid)
    {
        fprintf(stderr, "traffic: failed; expected OUTDIR COMPILER MATCHED_COHORT MAKEFILE USAGE_RECORD ROUNDS TAG\n");
    }
    return !valid;
}
