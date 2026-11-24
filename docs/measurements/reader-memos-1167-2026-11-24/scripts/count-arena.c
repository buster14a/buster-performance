// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.
//
// Usage: zcat compiler-faults.txt.gz | ./count-arena range.txt
// Input is perf script --ns -F pid,time,addr, retained for the inferior's PID.
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    FILE* ranges = argc == 2 ? fopen(argv[1], "r") : NULL;
    if (ranges == NULL)
    {
        return 1;
    }
    char line[1024];
    uint64_t start = 0, end = 0, base = 0, length = 0;
    int pid = 0;
    while (fgets(line, sizeof(line), ranges) != NULL)
    {
        if (strncmp(line, "ARENA_BEGIN ", 12) == 0)
        {
            if (sscanf(line + 12, "%" SCNu64 " %d", &start, &pid) != 2)
            {
                return 1;
            }
        }
        if (strncmp(line, "ARENA_END ", 10) == 0)
        {
            if (sscanf(line + 10, "%" SCNu64 " %" SCNu64 " %" SCNu64, &end, &base, &length) != 3)
            {
                return 1;
            }
        }
    }
    fclose(ranges);
    if (pid <= 0 || start == 0 || end < start || base == 0 || length == 0 || length > UINT64_MAX - base)
    {
        return 1;
    }
    const uint64_t first_page = base / 4096;
    const uint64_t page_count = (base + length - 1) / 4096 - first_page + 1;
    uint8_t* seen = calloc(page_count, sizeof(*seen));
    if (seen == NULL)
    {
        return 1;
    }
    uint64_t count = 0, unique = 0;
    while (fgets(line, sizeof(line), stdin) != NULL)
    {
        int task = 0;
        uint64_t sec = 0, ns = 0, address = 0;
        if (sscanf(line, "%d %" SCNu64 ".%9" SCNu64 ": %" SCNx64, &task, &sec, &ns, &address) != 4)
        {
            free(seen);
            return 1;
        }
        const uint64_t stamp = sec * UINT64_C(1000000000) + ns;
        if (task == pid && start <= stamp && stamp <= end && base <= address && address - base < length)
        {
            const uint64_t page = address / 4096 - first_page;
            unique += seen[page] == 0;
            seen[page] = 1;
            count += 1;
        }
    }
    free(seen);
    printf("%" PRIu64 " faults, %" PRIu64 " distinct 4 KiB pages\n", count, unique);
    return ferror(stdin) != 0;
}
