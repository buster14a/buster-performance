// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #673 real-make policy control. Run one workload under one shared lock: a full-size primer and four
// cyclic nine-edge role sequences balance every predecessor/current pair. Each case keeps counters, wait4 resources,
// exact argv, worker receipts and output bytes. Byte comparisons stay inside the same locked group, outside timing.
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

static bool policy_equal(const char* first, const char* second)
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
    if (left != NULL) valid = !ferror(left) && fclose(left) == 0 && valid;
    if (right != NULL) valid = !ferror(right) && fclose(right) == 0 && valid;
    return valid;
}

int main(int argc, char** argv)
{
    // OUTROOT WORKLOAD COMPILER MAKEFILE USAGE_RECORD; run inside exclusive.sh from the frozen campaign root.
    bool valid = argc == 6;
    char* parsed = NULL;
    const unsigned workload = valid ? (unsigned)strtoul(argv[2], &parsed, 10) : 3;
    valid = valid && parsed != argv[2] && *parsed == 0 && workload < 3 &&
            (mkdir(argv[1], 0755) == 0 || errno == EEXIST);
    static const unsigned pattern[] = {
        0,
        0,
        1,
        0,
        2,
        1,
        1,
        2,
        2,
    };
    static const char flags[] =
        "-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "
        "-std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu "
        "-march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include "
        "-isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite";
    unsigned pairs[3][3] = { 0 };
    unsigned previous = 2;
    char reference[PATH_MAX] = { 0 };
    for (unsigned turn = 0; valid && turn <= 36; turn += 1)
    {
        const bool primer = turn == 0;
        const unsigned role = primer ? 2 : pattern[(turn - 1) % 9];
        char directory[PATH_MAX], usage[PATH_MAX], counters[PATH_MAX], log_path[PATH_MAX], receipt_path[PATH_MAX];
        snprintf(directory, sizeof(directory), "%s/%c%02u-r%u", argv[1], primer ? 'p' : 'c', primer ? 0 : turn - 1, role);
        valid = mkdir(directory, 0755) == 0;
        snprintf(usage, sizeof(usage), "%s/sample.usage", directory);
        snprintf(counters, sizeof(counters), "%s/perf.csv", directory);
        snprintf(log_path, sizeof(log_path), "%s/collector.stdout", directory);
        snprintf(receipt_path, sizeof(receipt_path), "%s/argv.txt", directory);
        char compiler[PATH_MAX + 16], output_directory[PATH_MAX + 16], options[4096];
        snprintf(compiler, sizeof(compiler), "COMPILER=%s", argv[3]);
        snprintf(output_directory, sizeof(output_directory), "DIRECTORY=%s", directory);
        snprintf(options, sizeof(options), "OPTIONS=--lanes=8 --worker-budget=%u %s", role == 1 ? 1 : 8, flags);
        char* command[40];
        unsigned n = 0;
        command[n++] = "/usr/bin/perf";
        command[n++] = "stat";
        command[n++] = "-x,";
        command[n++] = "-o";
        command[n++] = counters;
        command[n++] = "-e";
        command[n++] = "task-clock,context-switches,cpu-migrations,cycles,instructions,page-faults";
        command[n++] = "--";
        command[n++] = argv[5];
        command[n++] = usage;
        command[n++] = "/usr/bin/make";
        command[n++] = "-s";
        command[n++] = "-j8";
        command[n++] = "--jobserver-style=pipe";
        command[n++] = "-f";
        command[n++] = argv[4];
        command[n++] = compiler;
        command[n++] = options;
        command[n++] = output_directory;
        command[n++] = "LARGE=corpus/sqlite/sqlite3.c";
        command[n++] = "SMALL=issue673-spawn-1d/evidence-673-spawn/tiny.c";
        command[n++] = workload == 0 ? "LARGE_INDICES=0 1 2 3 4 5 6 7" : workload == 1 ? "LARGE_INDICES=" : "LARGE_INDICES=0 4";
        if (role == 2) command[n++] = "LAUNCH=env -u MAKEFLAGS";
        command[n] = NULL;
        FILE* receipt = valid ? fopen(receipt_path, "w") : NULL;
        valid = receipt != NULL && valid;
        for (unsigned a = 0; valid && a < n; a += 1) valid = fprintf(receipt, "%s\n", command[a]) > 0;
        if (receipt != NULL) valid = fclose(receipt) == 0 && valid;
        printf("%s workload=%u case=%u role=%u predecessor=%u directory=%s\n", primer ? "prime" : "sample", workload, primer ? 0 : turn - 1, role, previous, directory);
        fflush(stdout);
        const pid_t child = valid ? fork() : -1;
        if (child == 0)
        {
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
        if (primer) snprintf(reference, sizeof(reference), "%s", directory);
        for (unsigned object = 0; valid && object < 8; object += 1)
        {
            char first[PATH_MAX], second[PATH_MAX];
            snprintf(first, sizeof(first), "%s/%u.o", reference, object);
            snprintf(second, sizeof(second), "%s/%u.o", directory, object);
            valid = policy_equal(first, second);
        }
        if (!primer) pairs[previous][role] += 1;
        previous = role;
        printf("result workload=%u case=%u role=%u status=%d identical=%u\n", workload, primer ? 0 : turn - 1, role, status, valid);
        fflush(stdout);
    }
    for (unsigned before = 0; before < 3; before += 1)
    {
        for (unsigned role = 0; role < 3; role += 1)
        {
            printf("pair predecessor=%u role=%u count=%u\n", before, role, pairs[before][role]);
            valid = pairs[before][role] == 4 && valid;
        }
    }
    if (!valid) fprintf(stderr, "balanced policy failed; expected OUTROOT WORKLOAD COMPILER MAKEFILE USAGE_RECORD\n");
    return !valid;
}
