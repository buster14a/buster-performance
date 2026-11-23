// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// brips.c: perf's samples by address, with a sample that fell in libc's memory and string functions charged to the
// instruction that called it (buster#2874's census).
//
//   perf script -i DATA --comm compiler -F period,ip,brstack | brips RANGES > IPS
//   brips --merge IPS... > IPS
//
// The compiler is linked statically, so memset, memmove and memcmp are its own text, and a sample there says nothing of
// who asked for the bytes. Each sample was recorded with its branch stack (perf record -b: the last 16 taken branches,
// the newest first). RANGES lists the transparent functions' addresses, a line each: START END NAME, in hexadecimal,
// sorted or not. A sample whose address is in one is charged to its caller, found one of two ways:
//
// - The stack ends outside the ranges. On the 9700X the stack stops at the counter's overflow and the sampled address
//   is some tens of instructions later, so a sample that lands early in memcmp has a stack whose newest branch is still
//   in the caller, before the call (and an older call into the ranges, if the stack holds one, is another's). The
//   sample is charged to that newest branch's target: the caller's code just before the call.
// - The stack ends inside the ranges. The sample is charged to the source of the newest branch that enters them from
//   outside: the call's own address (an ifunc's stub is in the ranges, so that is the call into the stub).
//
// Either address is one the debug information gives the caller's inline chain for. A sample whose 16 branches are all
// inside the ranges (a long copy's loop) keeps its own address: libc-callers.sh says whose bytes those calls are.
//
// The output is a line an address and a way: ADDRESS WAY PERIODS SAMPLES, with WAY 0 for a sample's own address, 1 for
// a call's address found in the branch stack, 3 for the target of a stack's newest branch where the stack ends before
// the call, and 2 for a transparent function's own address whose caller the stack didn't hold; PERIODS the sum of the
// samples' periods (the event's count) and SAMPLES their number. --merge adds such files.
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BRIPS_RANGES_MOST 4096
#define BRIPS_LINE_MOST (1u << 16)

typedef struct BripsRange BripsRange;
struct BripsRange
{
    uint64_t start;
    uint64_t end;
};

typedef struct BripsSlot BripsSlot;
struct BripsSlot
{
    uint64_t address;
    uint64_t periods;
    uint64_t samples;
    uint8_t way;
    bool used;
};

static BripsRange brips_ranges[BRIPS_RANGES_MOST];
static uint32_t brips_range_count;
static BripsSlot* brips_slots;
static uint64_t brips_capacity;
static uint64_t brips_count;

static bool brips_transparent(uint64_t address)
{
    bool inside = false;
    for (uint32_t r = 0; r < brips_range_count && !inside; r += 1)
    {
        inside = address >= brips_ranges[r].start && address < brips_ranges[r].end;
    }
    return inside;
}

static uint64_t brips_hash(uint64_t address, uint8_t way)
{
    uint64_t h = (address ^ ((uint64_t)way << 56)) * UINT64_C(0x9e3779b97f4a7c15);
    return h ^ (h >> 29);
}

static void brips_add(uint64_t address, uint8_t way, uint64_t periods, uint64_t samples);

static void brips_grow(void)
{
    BripsSlot* old = brips_slots;
    const uint64_t old_capacity = brips_capacity;
    brips_capacity = old_capacity == 0 ? 1u << 16 : old_capacity * 2;
    brips_slots = calloc(brips_capacity, sizeof(BripsSlot));
    if (brips_slots == NULL)
    {
        fprintf(stderr, "brips: no memory\n");
        exit(1);
    }
    brips_count = 0;
    for (uint64_t i = 0; i < old_capacity; i += 1)
    {
        if (old[i].used)
        {
            brips_add(old[i].address, old[i].way, old[i].periods, old[i].samples);
        }
    }
    free(old);
}

static void brips_add(uint64_t address, uint8_t way, uint64_t periods, uint64_t samples)
{
    if ((brips_count + 1) * 2 > brips_capacity)
    {
        brips_grow();
    }
    uint64_t at = brips_hash(address, way) & (brips_capacity - 1);
    while (brips_slots[at].used && !(brips_slots[at].address == address && brips_slots[at].way == way))
    {
        at = (at + 1) & (brips_capacity - 1);
    }
    if (!brips_slots[at].used)
    {
        brips_slots[at].used = true;
        brips_slots[at].address = address;
        brips_slots[at].way = way;
        brips_count += 1;
    }
    brips_slots[at].periods += periods;
    brips_slots[at].samples += samples;
}

static int brips_compare(const void* a, const void* b)
{
    const BripsSlot* x = a;
    const BripsSlot* y = b;
    return x->address < y->address ? -1 : x->address > y->address ? 1 : (int)x->way - (int)y->way;
}

static void brips_print(void)
{
    BripsSlot* sorted = malloc((brips_count + 1) * sizeof(BripsSlot));
    uint64_t n = 0;
    for (uint64_t i = 0; sorted != NULL && i < brips_capacity; i += 1)
    {
        if (brips_slots[i].used)
        {
            sorted[n++] = brips_slots[i];
        }
    }
    if (sorted != NULL)
    {
        qsort(sorted, n, sizeof(BripsSlot), brips_compare);
    }
    for (uint64_t i = 0; i < n; i += 1)
    {
        printf("%" PRIx64 " %u %" PRIu64 " %" PRIu64 "\n", sorted[i].address, sorted[i].way, sorted[i].periods, sorted[i].samples);
    }
    free(sorted);
}

int main(int argc, char** argv)
{
    static char line[BRIPS_LINE_MOST];
    int status = 0;
    if (argc >= 3 && strcmp(argv[1], "--merge") == 0)
    {
        for (int f = 2; f < argc && status == 0; f += 1)
        {
            FILE* file = fopen(argv[f], "r");
            status = file != NULL ? 0 : 1;
            uint64_t address = 0;
            uint64_t periods = 0;
            uint64_t samples = 0;
            unsigned way = 0;
            while (file != NULL && fscanf(file, "%" SCNx64 " %u %" SCNu64 " %" SCNu64, &address, &way, &periods, &samples) == 4)
            {
                brips_add(address, (uint8_t)way, periods, samples);
            }
            if (file != NULL)
            {
                fclose(file);
            }
        }
    }
    else if (argc == 2)
    {
        FILE* ranges = fopen(argv[1], "r");
        status = ranges != NULL ? 0 : 1;
        while (ranges != NULL && fgets(line, sizeof(line), ranges) != NULL && brips_range_count < BRIPS_RANGES_MOST)
        {
            uint64_t start = 0;
            uint64_t end = 0;
            if (sscanf(line, "%" SCNx64 " %" SCNx64, &start, &end) == 2 && end > start)
            {
                brips_ranges[brips_range_count++] = (BripsRange){ start, end };
            }
        }
        if (ranges != NULL)
        {
            fclose(ranges);
        }
        uint64_t lines = 0;
        uint64_t unparsed = 0;
        while (status == 0 && fgets(line, sizeof(line), stdin) != NULL)
        {
            char* cursor = line;
            const uint64_t period = strtoull(cursor, &cursor, 10);
            char* after = cursor;
            const uint64_t ip = strtoull(cursor, &after, 16);
            if (after == cursor || period == 0)
            {
                unparsed += line[0] != '\n' ? 1 : 0;
                continue;
            }
            lines += 1;
            cursor = after;
            uint64_t address = ip;
            uint8_t way = 0;
            if (brips_transparent(ip))
            {
                way = 2;
                bool found = false;
                bool newest = true;
                while (!found && *cursor != 0)
                {
                    char* entry = strstr(cursor, "0x");
                    if (entry == NULL)
                    {
                        break;
                    }
                    char* slash = NULL;
                    const uint64_t from = strtoull(entry, &slash, 16);
                    if (slash == NULL || *slash != '/')
                    {
                        break;
                    }
                    char* rest = NULL;
                    const uint64_t to = strtoull(slash + 1, &rest, 16);
                    if (newest && !brips_transparent(to))
                    {
                        // The stack ends before the call the sample is in.
                        address = to;
                        way = 3;
                        found = true;
                    }
                    else if (brips_transparent(to) && !brips_transparent(from))
                    {
                        address = from;
                        way = 1;
                        found = true;
                    }
                    newest = false;
                    // The entry's flags have no "0x": the next one starts at the next "0x".
                    cursor = rest != NULL ? rest : entry + 2;
                }
            }
            brips_add(address, way, period, 1);
        }
        fprintf(stderr, "brips: %" PRIu64 " samples, %" PRIu64 " lines not parsed, %" PRIu64 " addresses\n", lines, unparsed, brips_count);
    }
    else
    {
        fprintf(stderr, "usage: brips RANGES < perf-script-output ; brips --merge IPS...\n");
        status = 1;
    }
    if (status == 0)
    {
        brips_print();
    }
    return status;
}
