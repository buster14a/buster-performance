// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #673 matched-affinity qualification. Each sample acquires the shared host lock separately and retains
// per-process receipts, wait4 resource records, hardware/process counters and exact-byte object checks.
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

typedef struct MatrixVariant MatrixVariant;
struct MatrixVariant
{
    const char* name;
    bool head;
    const char* lanes;
    const char* cap;
    bool make;
    bool pinned;
};

static const MatrixVariant variants[] = {
    { "base-one", false, "--lanes=1", NULL, false, false },
    { "base-default", false, NULL, NULL, false, false },
    { "base-eight", false, "--lanes=8", NULL, false, false },
    { "head-one", true, "--lanes=1", NULL, false, false },
    { "head-default", true, NULL, NULL, false, false },
    { "head-eight", true, "--lanes=8", NULL, false, false },
    { "head-cap-one", true, "--lanes=8", "--worker-budget=1", false, false },
    { "head-jobserver", true, "--lanes=8", NULL, true, false },
    { "base-pinned-one", false, "--lanes=1", NULL, false, true },
    { "head-pinned-one", true, "--lanes=1", NULL, false, true },
};

static const char* options[] = {
    "-DSQLITE_OMIT_LOAD_EXTENSION", "-DSQLITE_THREADSAFE=0", "-DSQLITE_ENABLE_MEMSYS5", "-DSQLITE_ENABLE_RTREE",
    "-std=gnu17", "--predefines", "corpus/gnu17-pinned-predefines.txt", "--clang-features",
    "--target=x86_64-linux-gnu", "-march=znver5", "-nostdinc", "-isystem", "corpus/headers/usr/lib/clang/23/include",
    "-isystem", "corpus/headers/usr/local/include", "-isystem", "corpus/headers/usr/include", "-Icorpus/sqlite",
};

static bool matrix_equal(const char* first, const char* second)
{
    FILE* left = fopen(first, "rb");
    FILE* right = fopen(second, "rb");
    bool valid = left != NULL && right != NULL;
    bool reading = valid;
    while (reading)
    {
        char a[8192], b[8192];
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
    // OUTDIR BASE HEAD MATCHED_COHORT MAKEFILE ROUNDS; run from the frozen campaign root.
    bool valid = argc == 7;
    const unsigned rounds = valid ? (unsigned)strtoul(argv[6], NULL, 10) : 0;
    valid = valid && rounds > 0 && rounds <= 11 && (mkdir(argv[1], 0755) == 0 || errno == EEXIST);
    char reference[PATH_MAX] = { 0 };
    const unsigned count = sizeof(variants) / sizeof(variants[0]);
    for (unsigned round = 0; valid && round < rounds; round += 1)
    {
        for (unsigned position = 0; valid && position < count * 4; position += 1)
        {
            const unsigned row = (position + round * 13) % (count * 4);
            const MatrixVariant* variant = variants + row % count;
            const unsigned jobs = 1u << (row / count);
            char directory[PATH_MAX], counters[PATH_MAX], receipt_path[PATH_MAX], log_path[PATH_MAX];
            char job_text[16], make_jobs[16], cap[32], make_options[4096], output_directory[PATH_MAX + 16];
            char compiler[PATH_MAX + 16], makefile[PATH_MAX + 16];
            snprintf(directory, sizeof(directory), "%s/r%02u-j%u-%s", argv[1], round, jobs, variant->name);
            valid = mkdir(directory, 0755) == 0;
            snprintf(counters, sizeof(counters), "%s/perf.csv", directory);
            snprintf(receipt_path, sizeof(receipt_path), "%s/argv.txt", directory);
            snprintf(log_path, sizeof(log_path), "%s/collector.stdout", directory);
            snprintf(job_text, sizeof(job_text), "%u", jobs);
            snprintf(make_jobs, sizeof(make_jobs), "-j%u", jobs);
            snprintf(cap, sizeof(cap), "--worker-budget=%u", jobs);
            snprintf(output_directory, sizeof(output_directory), "DIRECTORY=%s", directory);
            snprintf(compiler, sizeof(compiler), "COMPILER=%s", variant->head ? argv[3] : argv[2]);
            snprintf(makefile, sizeof(makefile), "%s", argv[5]);
            char* command[96];
            unsigned n = 0;
            command[n++] = "/home/david/buster-fast-bench/exclusive.sh";
            command[n++] = "taskset"; command[n++] = "-c"; command[n++] = "0-7";
            command[n++] = "/usr/bin/perf"; command[n++] = "stat"; command[n++] = "-x,";
            command[n++] = "-o"; command[n++] = counters;
            command[n++] = "-e"; command[n++] = "task-clock,context-switches,cpu-migrations,cycles,instructions,page-faults";
            command[n++] = "--";
            if (variant->make)
            {
                size_t used = (size_t)snprintf(make_options, sizeof(make_options), "OPTIONS=%s %s", variant->lanes, cap);
                for (unsigned option = 0; valid && option < sizeof(options) / sizeof(options[0]); option += 1)
                {
                    const int length = snprintf(make_options + used, sizeof(make_options) - used, " %s", options[option]);
                    valid = length > 0 && (size_t)length < sizeof(make_options) - used;
                    used += valid ? (size_t)length : 0;
                }
                command[n++] = "/usr/bin/make"; command[n++] = "-s"; command[n++] = make_jobs;
                command[n++] = "--jobserver-style=pipe"; command[n++] = "-f"; command[n++] = makefile;
                command[n++] = compiler; command[n++] = make_options; command[n++] = output_directory;
                command[n++] = "LARGE=corpus/sqlite/sqlite3.c"; command[n++] = "SMALL=corpus/sqlite/sqlite3.c";
                command[n++] = "LARGE_INDICES=0 1 2 3 4 5 6 7";
            }
            else
            {
                command[n++] = argv[4]; command[n++] = variant->pinned ? "pinned" : "shared";
                command[n++] = job_text; command[n++] = "8"; command[n++] = "corpus/sqlite/sqlite3.c";
                command[n++] = directory; command[n++] = variant->head ? argv[3] : argv[2];
                command[n++] = "--time-stages";
                if (variant->lanes != NULL) command[n++] = (char*)variant->lanes;
                if (variant->cap != NULL) command[n++] = (char*)variant->cap;
                for (unsigned option = 0; option < sizeof(options) / sizeof(options[0]); option += 1)
                {
                    command[n++] = (char*)options[option];
                }
                command[n++] = "-c"; command[n++] = "corpus/sqlite/sqlite3.c"; command[n++] = "-o"; command[n++] = "@OUTPUT@";
            }
            command[n] = NULL;
            FILE* receipt = valid ? fopen(receipt_path, "w") : NULL;
            valid = valid && receipt != NULL;
            for (unsigned argument = 0; valid && argument < n; argument += 1)
            {
                valid = fprintf(receipt, "%s\n", command[argument]) > 0;
            }
            if (receipt != NULL) valid = fclose(receipt) == 0 && valid;
            printf("run round=%u jobs=%u variant=%s directory=%s\n", round, jobs, variant->name, directory);
            fflush(stdout);
            const pid_t child = valid ? fork() : -1;
            if (child == 0)
            {
                char title[160];
                snprintf(title, sizeof(title), "Issue 673 matched j%u %s repetition %u", jobs, variant->name, round);
                setenv("EXCLUSIVE_OWNER", "codex-unclaimed-perf", 1);
                setenv("EXCLUSIVE_TITLE", title, 1);
                setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/issues/673", 1);
                unsetenv("MAKEFLAGS");
                const int log = open(log_path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                if (log < 0 || dup2(log, STDOUT_FILENO) < 0 || dup2(log, STDERR_FILENO) < 0) _exit(125);
                if (log > STDERR_FILENO) close(log);
                execv(command[0], command);
                _exit(127);
            }
            int status = 0;
            pid_t waited = -1;
            if (child > 0)
            {
                do { waited = waitpid(child, &status, 0); } while (waited < 0 && errno == EINTR);
            }
            valid = child > 0 && waited == child && WIFEXITED(status) && WEXITSTATUS(status) == 0 && valid;
            for (unsigned object = 0; valid && object < 8; object += 1)
            {
                char path[PATH_MAX];
                snprintf(path, sizeof(path), variant->make ? "%s/%u.o" : "%s/output-%04u.o", directory, object);
                if (reference[0] == 0) snprintf(reference, sizeof(reference), "%s", path);
                valid = matrix_equal(reference, path);
            }
            printf("result round=%u jobs=%u variant=%s objects=%s status=%d\n", round, jobs, variant->name, valid ? "identical" : "FAILED", status);
            fflush(stdout);
        }
    }
    if (!valid) fprintf(stderr, "matrix: failed; expected OUTDIR BASE HEAD MATCHED_COHORT MAKEFILE ROUNDS\n");
    return !valid;
}
