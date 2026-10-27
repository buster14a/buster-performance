// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// One shared-host lock per fresh-process sample. Run outside exclusive.sh from the campaign directory.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    const bool sqlite = argc == 2 && strcmp(argv[1], "sqlite") == 0;
    const bool scale = argc == 2 && strcmp(argv[1], "scale") == 0;
    bool result = sqlite || scale;
    char directory[PATH_MAX];
    result = result && getcwd(directory, sizeof(directory)) != 0;
    const uint32_t count = sqlite ? 2 : 6;
    const uint32_t rounds = sqlite ? 12 : 6;
    const uint32_t depths[] = { 1000, 2000, 4000 };
    char lists[6][PATH_MAX];
    for (uint32_t i = 0; result && i < count; i += 1)
    {
        const char* variant = (i & 1) != 0 ? "head" : "base";
        const uint32_t depth = sqlite ? 0 : depths[i / 2];
        const int bytes = snprintf(lists[i], sizeof(lists[i]), "%s/%s-%s-%u.list", directory, argv[1], variant, depth);
        FILE* file = bytes > 0 && (size_t)bytes < sizeof(lists[i]) ? fopen(lists[i], "w") : 0;
        result = file != 0;
        if (result)
        {
            fprintf(file, "%s-%s-%u|runs=1,cpu=2,norandom,events=cycles:instructions|%s/%s/build/compiler -E -P ", argv[1], variant, depth, directory, variant);
            if (sqlite)
            {
                const char* corpus = "/var/lib/buster-9700x/corpora/preprocessor-391e729af658";
                fprintf(file, "-march=znver5 -std=gnu17 -nostdinc -isystem %s/headers/usr/lib/clang/23/include -isystem %s/headers/usr/local/include -isystem %s/headers/usr/include %s/sqlite/sqlite3.c -o /dev/null\n", corpus, corpus, corpus, corpus);
            }
            else
            {
                fprintf(file, "%s/nested-%u.c -o /dev/null\n", directory, depth);
            }
            result = !ferror(file) && result;
            result = fclose(file) == 0 && result;
        }
    }
    char lock[PATH_MAX];
    const char* home = getenv("HOME");
    const int bytes = home != 0 ? snprintf(lock, sizeof(lock), "%s/buster-fast-bench/exclusive.sh", home) : -1;
    result = bytes > 0 && (size_t)bytes < sizeof(lock) && result;
    result = setenv("EXCLUSIVE_OWNER", "codex-616", 1) == 0 && result;
    result = setenv("EXCLUSIVE_TITLE", "Buster #616 nested macro comparison", 1) == 0 && result;
    result = setenv("EXCLUSIVE_LINK", "https://github.com/buster14a/buster/issues/616", 1) == 0 && result;
    // Queue independent samples in advance: each still acquires/releases the host lock itself. Waiting for every
    // preceding sample before submitting the next would make each tiny command rejoin a long shared queue.
    pid_t children[72];
    uint32_t child_count = 0;
    for (uint32_t round = 0; result && round < rounds; round += 1)
    {
        for (uint32_t order = 0; result && order < count; order += 1)
        {
            const uint32_t index = (order + round) % count;
            char first[32];
            snprintf(first, sizeof(first), "%u", round + 1);
            const pid_t child = fork();
            if (child == 0)
            {
                execl(lock, lock, "./procbench", "--rounds", "1", "--first", first, "--no-header", lists[index], (char*)0);
                _exit(127);
            }
            result = child > 0;
            if (result)
            {
                children[child_count] = child;
                child_count += 1;
                fprintf(stderr, "submitted %s round %u order %u label %u pid %ld\n", argv[1], round + 1, order, index, (long)child);
            }
            struct timespec pause = { .tv_nsec = 50000000 };
            while (nanosleep(&pause, &pause) != 0 && errno == EINTR)
            {
            }
        }
        if (round == 0)
        {
            // Let every warm-up enter the lock queue before any timed sample is submitted.
            struct timespec pause = { .tv_sec = 2 };
            while (nanosleep(&pause, &pause) != 0 && errno == EINTR)
            {
            }
        }
    }
    for (uint32_t i = 0; i < child_count; i += 1)
    {
        int status = 0;
        pid_t waited;
        do
        {
            waited = waitpid(children[i], &status, 0);
        }
        while (waited < 0 && errno == EINTR);
        result = waited == children[i] && WIFEXITED(status) && WEXITSTATUS(status) == 0 && result;
    }
    return result ? 0 : 1;
}
