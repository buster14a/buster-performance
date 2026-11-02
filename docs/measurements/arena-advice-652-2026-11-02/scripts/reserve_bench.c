// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// reserve_bench.c: what reserving a small unit's ~90 arenas costs, by layout (#652). Each sample forks a child that
// reserves ARENAS arenas of 64 GB, commits each one's first 64 KB and touches its first page, then exits; the parent
// times fork to wait4. Strategies:
//   956     mmap PROT_NONE, madvise NOHUGEPAGE prefix + HUGEPAGE rest, mprotect the prefix (main since #956)
//   lazy    mmap PROT_NONE, mprotect the prefix (no advice; #652's head)
//   rw      mmap RW|NORESERVE, madvise NOHUGEPAGE prefix + HUGEPAGE rest (before #956)
//   fixed   mmap PROT_NONE at a chosen address (MAP_FIXED_NOREPLACE, base at the mapping's start), mprotect the prefix
//   two     at a chosen address: mmap RW the prefix, mmap PROT_NONE the rest (no mprotect)
//   slab    one PROT_NONE slab, each arena a slice; mprotect the prefix
// Usage: reserve_bench STRATEGY ARENAS SAMPLES
#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/wait.h>

#ifndef MAP_FIXED_NOREPLACE
#define MAP_FIXED_NOREPLACE 0x100000
#endif

#define PAGE (4ull << 10)
#define HUGE (2ull << 20)
#define SMALL (64ull << 10)
#define CAPACITY (64ull << 30)

static uint64_t now_ns(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (uint64_t)t.tv_sec * 1000000000ull + (uint64_t)t.tv_nsec;
}

static int run(const char* strategy, int arenas)
{
    int failures = 0;
    const uint64_t length = CAPACITY + HUGE;
    uint8_t* cursor = 0;
    uint8_t* slab = 0;
    if (strcmp(strategy, "slab") == 0)
    {
        slab = mmap(0, (uint64_t)arenas * length + HUGE, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
        failures += slab == MAP_FAILED;
        cursor = (uint8_t*)(((uintptr_t)slab + HUGE - 1) & ~(HUGE - 1));
    }
    for (int i = 0; i < arenas; i += 1)
    {
        uint8_t* base = 0;
        if (strcmp(strategy, "956") == 0 || strcmp(strategy, "lazy") == 0 || strcmp(strategy, "rw") == 0)
        {
            const int rw = strcmp(strategy, "rw") == 0;
            uint8_t* mapping = mmap(0, length, rw ? PROT_READ | PROT_WRITE : PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | (rw ? MAP_NORESERVE : 0), -1, 0);
            failures += mapping == MAP_FAILED;
            const uintptr_t huge = ((uintptr_t)mapping + PAGE + SMALL + HUGE - 1) & ~(HUGE - 1);
            base = (uint8_t*)(huge - SMALL);
            if (strcmp(strategy, "lazy") != 0)
            {
                madvise(mapping, huge - (uintptr_t)mapping, MADV_NOHUGEPAGE);
                madvise((void*)huge, (uintptr_t)mapping + length - huge, MADV_HUGEPAGE);
            }
            if (!rw)
            {
                failures += mprotect(base, SMALL, PROT_READ | PROT_WRITE) != 0;
            }
        }
        else if (strcmp(strategy, "fixed") == 0 || strcmp(strategy, "two") == 0)
        {
            // Top-down below the last arena, base at the mapping's start and base + SMALL on a huge page boundary.
            uint8_t* want = 0;
            if (cursor != 0)
            {
                want = (uint8_t*)((((uintptr_t)cursor - CAPACITY + SMALL) & ~(HUGE - 1)) - SMALL);
            }
            uint8_t* mapping = MAP_FAILED;
            if (want != 0 && strcmp(strategy, "two") == 0)
            {
                mapping = mmap(want, SMALL, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE, -1, 0);
                uint8_t* rest = mapping == want ? mmap(want + SMALL, CAPACITY - SMALL, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE, -1, 0) : MAP_FAILED;
                failures += mapping != want || rest != want + SMALL;
                base = want;
            }
            else if (want != 0)
            {
                mapping = mmap(want, CAPACITY, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE, -1, 0);
                failures += mapping != want;
                base = want;
                failures += mprotect(base, SMALL, PROT_READ | PROT_WRITE) != 0;
            }
            else
            {
                mapping = mmap(0, length, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
                const uintptr_t huge = ((uintptr_t)mapping + PAGE + SMALL + HUGE - 1) & ~(HUGE - 1);
                base = (uint8_t*)(huge - SMALL);
                failures += mprotect(base, SMALL, PROT_READ | PROT_WRITE) != 0;
            }
            // The lowest address of this arena's mapping: the next one goes below it.
            cursor = want != 0 ? want : mapping;
        }
        else
        {
            base = cursor + HUGE - SMALL;
            cursor += length;
            failures += mprotect(base, SMALL, PROT_READ | PROT_WRITE) != 0;
        }
        base[0] = 1;
    }
    return failures;
}

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

int main(int count, char** arguments)
{
    int result = 1;
    if (count == 4)
    {
        const int arenas = atoi(arguments[2]);
        const int samples = atoi(arguments[3]);
        uint64_t* times = calloc((size_t)samples, sizeof(uint64_t));
        int failed = 0;
        for (int s = 0; s < samples; s += 1)
        {
            const uint64_t begin = now_ns();
            const pid_t child = fork();
            if (child == 0)
            {
                _exit(run(arguments[1], arenas) != 0);
            }
            int status = 0;
            waitpid(child, &status, 0);
            times[s] = now_ns() - begin;
            failed += !WIFEXITED(status) || WEXITSTATUS(status) != 0;
        }
        qsort(times, (size_t)samples, sizeof(uint64_t), compare);
        printf("%-6s %d arenas: median %.1f us, p10 %.1f, p90 %.1f, %d failed samples\n", arguments[1], arenas, times[samples / 2] / 1000.0,
               times[samples / 10] / 1000.0, times[samples * 9 / 10] / 1000.0, failed);
        result = failed != 0;
    }
    else
    {
        fprintf(stderr, "usage: reserve_bench 956|lazy|rw|fixed|two|slab ARENAS SAMPLES\n");
    }
    return result;
}
