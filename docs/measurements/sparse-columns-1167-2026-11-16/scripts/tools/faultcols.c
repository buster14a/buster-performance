// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// faultcols: the reader's arena of rare columns (buster14a/buster#1167) by column, from one compile's own faults: each
// column's faults and the 4 KB pages they map, for the faults `perf script -F addr` lists (one address a line, in hex),
// recorded in the same process whose columns.patch printed COLUMNS. A column runs from its address to the next
// column's, the last to the arena's pushed end; faults outside the arena are counted apart.
//
//   faultcols COLUMNS ADDRESSES
//
// Writes a line a column with a fault, by address, then the arena's and the rest's totals.

#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FAULTCOLS_COLUMNS 128
#define FAULTCOLS_NAME 64

typedef struct Column Column;
struct Column
{
    char name[FAULTCOLS_NAME];
    uint64_t address;
    uint64_t faults;
};

static Column faultcols[FAULTCOLS_COLUMNS];
static uint32_t faultcol_count;

static int compare_columns(const void* a, const void* b)
{
    const Column* x = a;
    const Column* y = b;
    return (x->address > y->address) - (x->address < y->address);
}

int main(int argc, char** argv)
{
    FILE* columns = argc == 3 ? fopen(argv[1], "r") : NULL;
    FILE* addresses = argc == 3 ? fopen(argv[2], "r") : NULL;
    uint64_t base = 0;
    uint64_t peak = 0;
    char line[512];
    while (columns != NULL && fgets(line, sizeof(line), columns) != NULL)
    {
        char name[FAULTCOLS_NAME];
        unsigned long a = 0;
        unsigned long b = 0;
        unsigned long c = 0;
        unsigned long d = 0;
        if (sscanf(line, "BASE\t%lu\t%lu\t%lu\t%lu", &a, &b, &c, &d) == 4)
        {
            base = a;
            peak = c;
        }
        else if (sscanf(line, "COL\t%63s\t%lu\t%lu", name, &a, &b) == 3 && faultcol_count < FAULTCOLS_COLUMNS && a != 0)
        {
            snprintf(faultcols[faultcol_count].name, FAULTCOLS_NAME, "%s", name);
            faultcols[faultcol_count].address = a;
            faultcols[faultcol_count].faults = 0;
            faultcol_count += 1;
        }
    }
    qsort(faultcols, faultcol_count, sizeof(Column), compare_columns);
    uint64_t inside = 0;
    uint64_t outside = 0;
    while (addresses != NULL && base != 0 && fgets(line, sizeof(line), addresses) != NULL)
    {
        const uint64_t address = strtoull(line, NULL, 16);
        const bool in_arena = address >= base && address < base + peak;
        uint32_t found = faultcol_count;
        for (uint32_t i = 0; in_arena && i < faultcol_count; i += 1)
        {
            const uint64_t end = i + 1 < faultcol_count ? faultcols[i + 1].address : base + peak;
            found = address >= faultcols[i].address && address < end ? i : found;
        }
        faultcols[found < faultcol_count ? found : 0].faults += found < faultcol_count ? 1 : 0;
        inside += in_arena ? 1 : 0;
        outside += in_arena ? 0 : 1;
    }
    const bool ok = columns != NULL && addresses != NULL && base != 0;
    if (ok)
    {
        printf("column\tfaults\n");
        for (uint32_t i = 0; i < faultcol_count; i += 1)
        {
            if (faultcols[i].faults != 0)
            {
                printf("%s\t%lu\n", faultcols[i].name, (unsigned long)faultcols[i].faults);
            }
        }
        printf("the arena\t%lu\nthe rest of the compile\t%lu\n", (unsigned long)inside, (unsigned long)outside);
    }
    if (columns != NULL)
    {
        fclose(columns);
    }
    if (addresses != NULL)
    {
        fclose(addresses);
    }
    return ok ? 0 : 2;
}
