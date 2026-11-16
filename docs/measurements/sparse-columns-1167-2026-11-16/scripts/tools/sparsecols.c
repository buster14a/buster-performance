// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// sparsecols: the reader's arena of rare columns (check_input_sparse_arena, buster14a/buster#1167) by column, from
// sparse.gdb's dump at check_input_run's end: for each column, its bytes, its entries (elements with a byte other than
// zero), the 4 KB pages that hold one (the pages its writes took, as nearly as a dump says: a write of zero leaves no
// trace), and the entries a written page holds. A column runs from its address to the next column's (its alignment's
// padding with it), the last to the arena's pushed end; a page that two columns share counts for each.
//
//   sparsecols COLUMNS DUMP
//
// COLUMNS is sparse-dump.sh's columns.txt (BASE, COL, END lines). Writes a line a column, by address, then the totals.

#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SPARSECOLS_COLUMNS 128
#define SPARSECOLS_NAME 64
#define SPARSECOLS_PAGE 4096u

typedef struct Column Column;
struct Column
{
    char name[SPARSECOLS_NAME];
    uint64_t address;
    uint64_t size;
};

static Column sparsecols[SPARSECOLS_COLUMNS];
static uint32_t sparsecol_count;

static int compare_columns(const void* a, const void* b)
{
    const Column* x = a;
    const Column* y = b;
    return (x->address > y->address) - (x->address < y->address);
}

static bool nonzero(const uint8_t* bytes, uint64_t count)
{
    bool result = false;
    for (uint64_t i = 0; i < count && !result; i += 1)
    {
        result = bytes[i] != 0;
    }
    return result;
}

int main(int argc, char** argv)
{
    FILE* columns = argc == 3 ? fopen(argv[1], "r") : NULL;
    FILE* dump = argc == 3 ? fopen(argv[2], "rb") : NULL;
    uint64_t base = 0;
    uint64_t peak = 0;
    uint64_t small = 0;
    char line[512];
    while (columns != NULL && fgets(line, sizeof(line), columns) != NULL)
    {
        char name[SPARSECOLS_NAME];
        unsigned long a = 0;
        unsigned long b = 0;
        unsigned long c = 0;
        unsigned long d = 0;
        if (sscanf(line, "BASE\t%lu\t%lu\t%lu\t%lu", &a, &b, &c, &d) == 4)
        {
            base = a;
            peak = c;
            small = d;
        }
        else if (sscanf(line, "COL\t%63s\t%lu\t%lu", name, &a, &b) == 3 && sparsecol_count < SPARSECOLS_COLUMNS && a != 0)
        {
            snprintf(sparsecols[sparsecol_count].name, SPARSECOLS_NAME, "%s", name);
            sparsecols[sparsecol_count].address = a;
            sparsecols[sparsecol_count].size = b;
            sparsecol_count += 1;
        }
    }
    uint8_t* bytes = peak != 0 ? malloc(peak) : NULL;
    const bool read = bytes != NULL && dump != NULL && fread(bytes, 1, peak, dump) == peak;
    if (read)
    {
        qsort(sparsecols, sparsecol_count, sizeof(Column), compare_columns);
        printf("column\telement bytes\tMB\tentries\twritten 4 KB pages\tentries a written page\tbase pages (in the arena's small prefix)\n");
        uint64_t pages_total = 0;
        uint64_t entries_total = 0;
        for (uint32_t i = 0; i < sparsecol_count; i += 1)
        {
            const uint64_t begin = sparsecols[i].address - base;
            const uint64_t end = i + 1 < sparsecol_count ? sparsecols[i + 1].address - base : peak;
            const uint64_t size = sparsecols[i].size;
            uint64_t entries = 0;
            for (uint64_t at = begin; at + size <= end; at += size)
            {
                entries += nonzero(bytes + at, size);
            }
            uint64_t pages = 0;
            for (uint64_t page = begin / SPARSECOLS_PAGE * SPARSECOLS_PAGE; page < end; page += SPARSECOLS_PAGE)
            {
                const uint64_t from = page > begin ? page : begin;
                const uint64_t to = page + SPARSECOLS_PAGE < end ? page + SPARSECOLS_PAGE : end;
                pages += nonzero(bytes + from, to - from);
            }
            pages_total += pages;
            entries_total += entries;
            printf("%s\t%lu\t%.2f\t%lu\t%lu\t%.1f\t%s\n", sparsecols[i].name, (unsigned long)size, (double)(end - begin) / 1048576.0, (unsigned long)entries,
                   (unsigned long)pages, pages != 0 ? (double)entries / (double)pages : 0.0, begin < small ? "yes" : "no");
        }
        // Every written page of the arena once, whatever column it is in.
        uint64_t written = 0;
        for (uint64_t page = 0; page < peak; page += SPARSECOLS_PAGE)
        {
            written += nonzero(bytes + page, page + SPARSECOLS_PAGE < peak ? SPARSECOLS_PAGE : peak - page);
        }
        printf("all columns\t\t%.2f\t%lu\t%lu\t%.1f\t\n", (double)peak / 1048576.0, (unsigned long)entries_total, (unsigned long)pages_total,
               pages_total != 0 ? (double)entries_total / (double)pages_total : 0.0);
        printf("the arena's written pages, each once\t\t%.2f\t\t%lu\t\t\n", (double)written * SPARSECOLS_PAGE / 1048576.0, (unsigned long)written);
    }
    free(bytes);
    if (columns != NULL)
    {
        fclose(columns);
    }
    if (dump != NULL)
    {
        fclose(dump);
    }
    return read ? 0 : 2;
}
