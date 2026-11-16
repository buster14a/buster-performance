// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// krows: item 1's rows (buster14a/buster#2873) from kcensus's CAUSES table (OUT-causes.tsv): the kernel's cycles of a
// recorded compile by cause, grouped as the record's README gives them, each with its cycles, its share of the compile's
// own (the compile's processes from its exec to the end of its exit helper, less what the recording, the stage clock and
// the census patch did), and its cycles a token at SCALE (an unrecorded compile's cycles over the recorded one's own).
// What is outside the compile (the harness, the parent, other tasks) and what is set apart follow the rows.
//
//   krows CAUSES SCALE TOKENS

#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define KROWS_LINE 4096
#define KROWS_ROWS 128
#define KROWS_NAME 160

typedef struct Row Row;
struct Row
{
    char name[KROWS_NAME];
    double cycles;
    bool own;
};

static Row krows[KROWS_ROWS];
static uint32_t krow_count;

static void add(const char* name, double cycles, bool own)
{
    Row* row = NULL;
    for (uint32_t i = 0; i < krow_count && row == NULL; i += 1)
    {
        row = strcmp(krows[i].name, name) == 0 ? &krows[i] : NULL;
    }
    if (row == NULL && krow_count < KROWS_ROWS)
    {
        row = &krows[krow_count];
        snprintf(row->name, sizeof(row->name), "%s", name);
        row->cycles = 0;
        row->own = own;
        krow_count += 1;
    }
    if (row != NULL)
    {
        row->cycles += cycles;
    }
}

static bool starts(const char* text, const char* prefix)
{
    return strncmp(text, prefix, strlen(prefix)) == 0;
}

static bool is(const char* text, const char* name)
{
    return strcmp(text, name) == 0;
}

static int compare_rows(const void* a, const void* b)
{
    const Row* x = a;
    const Row* y = b;
    int result = (int)y->own - (int)x->own;
    return result != 0 ? result : (x->cycles < y->cycles) - (x->cycles > y->cycles);
}

int main(int argc, char** argv)
{
    FILE* file = argc == 4 ? fopen(argv[1], "r") : NULL;
    const double scale = argc == 4 ? strtod(argv[2], NULL) : 0;
    const double tokens = argc == 4 ? strtod(argv[3], NULL) : 0;
    char line[KROWS_LINE];
    bool header = true;
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        // phase, cause, detail, part, cycles-a-compile, ...
        char* fields[8] = { 0 };
        uint32_t count = 0;
        char* at = line;
        while (at != NULL && count < 8)
        {
            fields[count] = at;
            count += 1;
            char* tab = strchr(at, '\t');
            at = tab != NULL ? tab + 1 : NULL;
            if (tab != NULL)
            {
                *tab = 0;
            }
        }
        if (header || count < 5)
        {
            header = false;
            continue;
        }
        const char* phase = fields[0];
        const char* cause = fields[1];
        const char* detail = fields[2];
        const double cycles = strtod(fields[4], NULL);
        const bool compile = is(phase, "start") || is(phase, "compile") || is(phase, "exit");
        char name[KROWS_NAME];
        bool own = compile;
        if (!compile)
        {
            snprintf(name, sizeof(name), "outside the compile: %s", phase);
        }
        else if (is(cause, "perf's own") || is(cause, "the stage clock's own"))
        {
            snprintf(name, sizeof(name), "set apart: %s", cause);
            own = false;
        }
        else if (is(phase, "exit") && is(cause, "system call") && is(detail, "munmap"))
        {
            // The census patch's report buffer, freed in the report (c_check_clock.c's patch).
            snprintf(name, sizeof(name), "set apart: the census patch's report buffer (munmap)");
            own = false;
        }
        else if (is(phase, "start"))
        {
            snprintf(name, sizeof(name), "the process's start (exec to the stage clock's start)");
        }
        else if (is(phase, "exit") && starts(cause, "the address space's teardown"))
        {
            snprintf(name, sizeof(name), "the exit: the address space's teardown");
        }
        else if (is(phase, "exit"))
        {
            snprintf(name, sizeof(name), "the exit: the rest (the helper's start, exit_group, exit)");
        }
        else if (is(cause, "page fault"))
        {
            snprintf(name, sizeof(name), "page faults (by owner: owners.tsv)");
        }
        else if (is(cause, "system call") &&
                 (starts(detail, "mmap: a source") || strstr(detail, "include search") != NULL || is(detail, "pread64") || is(detail, "getdents64") ||
                  is(detail, "newfstat") || is(detail, "newfstatat") || is(detail, "fstatfs") || is(detail, "readlinkat") || is(detail, "read")))
        {
            snprintf(name, sizeof(name), "the source's read: %s", starts(detail, "mmap: a source") ? "its mapping, populated" : "the include search");
        }
        else if (is(cause, "system call") && strstr(detail, "the object") != NULL)
        {
            snprintf(name, sizeof(name), "the object's write");
        }
        else if (is(cause, "system call") &&
                 (is(detail, "munmap") || is(detail, "madvise") || is(detail, "mprotect") || starts(detail, "mmap: a reservation") || is(detail, "brk")))
        {
            snprintf(name, sizeof(name), "the arenas' system calls: %s", starts(detail, "mmap") ? "mmap" : detail);
        }
        else if (is(cause, "interrupt"))
        {
            snprintf(name, sizeof(name), "interrupts: %s", detail);
        }
        else if (is(cause, "system call"))
        {
            snprintf(name, sizeof(name), "unattributed: a system call (%s)", detail);
        }
        else
        {
            snprintf(name, sizeof(name), "unattributed: %s", cause);
        }
        add(name, cycles, own);
    }
    if (file != NULL)
    {
        fclose(file);
        qsort(krows, krow_count, sizeof(Row), compare_rows);
        double own = 0;
        for (uint32_t i = 0; i < krow_count; i += 1)
        {
            own += krows[i].own ? krows[i].cycles : 0;
        }
        printf("row\tcycles-M a recorded compile\tshare of the compile's own\tcycles a token at the scale\n");
        for (uint32_t i = 0; i < krow_count; i += 1)
        {
            printf("%s\t%.3f\t%.2f%%\t%.2f\n", krows[i].name, krows[i].cycles / 1e6, krows[i].own ? krows[i].cycles * 100.0 / own : 0.0,
                   krows[i].cycles * scale / tokens);
        }
        printf("the compile's own\t%.3f\t100.00%%\t%.2f\n", own / 1e6, own * scale / tokens);
    }
    return file != NULL ? 0 : 2;
}
