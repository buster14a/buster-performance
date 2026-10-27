// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#define _POSIX_C_SOURCE 200809L
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Summary Summary;
struct Summary
{
    char name[128];
    uint64_t values[4][16];
    uint32_t count;
    uint32_t seen;
};

static int compare(const void* a, const void* b)
{
    const uint64_t x = *(const uint64_t*)a;
    const uint64_t y = *(const uint64_t*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    Summary groups[8] = { 0 };
    uint32_t group_count = 0;
    bool result = argc > 1;
    for (int file = 1; result && file < argc; file += 1)
    {
        FILE* stream = fopen(argv[file], "r");
        result = stream != 0;
        char line[4096];
        while (result && fgets(line, sizeof(line), stream) != 0)
        {
            char* fields[19];
            uint32_t count = 0;
            char* state = 0;
            for (char* field = strtok_r(line, "\t\n", &state); field != 0 && count < 19; field = strtok_r(0, "\t\n", &state))
            {
                fields[count] = field;
                count += 1;
            }
            result = count == 19 && strcmp(fields[5], "0") == 0 && strchr(fields[17], '*') == 0 && strchr(fields[18], '*') == 0 &&
                     strncmp(fields[17], "cycles=", 7) == 0 && strncmp(fields[18], "instructions=", 13) == 0;
            result = result && strtoull(fields[6], 0, 10) != 0 && strtoull(fields[17] + 7, 0, 10) != 0 && strtoull(fields[18] + 13, 0, 10) != 0;
            if (result)
            {
                uint32_t group = 0;
                while (group < group_count && strcmp(groups[group].name, fields[2]) != 0)
                {
                    group += 1;
                }
                result = group < 8 && strlen(fields[2]) < sizeof(groups[0].name);
                if (result && group == group_count)
                {
                    strcpy(groups[group].name, fields[2]);
                    group_count += 1;
                }
                result = result && groups[group].count < 16;
                if (result && groups[group].seen != 0)
                {
                    Summary* summary = &groups[group];
                    summary->values[0][summary->count] = strtoull(fields[6], 0, 10);
                    summary->values[1][summary->count] = strtoull(fields[17] + 7, 0, 10);
                    summary->values[2][summary->count] = strtoull(fields[18] + 13, 0, 10);
                    summary->values[3][summary->count] = strtoull(fields[13], 0, 10);
                    result = summary->values[0][summary->count] != 0 && summary->values[1][summary->count] != 0 && summary->values[2][summary->count] != 0;
                    summary->count += 1;
                }
                if (result)
                {
                    // stdout rows are written before releasing the exclusive lock: discard each label's first
                    // actual execution, even if the kernel woke lock waiters out of submission-round order.
                    groups[group].seen += 1;
                }
            }
        }
        if (stream != 0)
        {
            result = !ferror(stream) && result;
            result = fclose(stream) == 0 && result;
        }
    }
    puts("label\tn\twall_ms\tmin_ms\tmax_ms\tcycles_u\tinstructions_u\tmedian_maxrss_kib\tmin_maxrss_kib\tmax_maxrss_kib");
    for (uint32_t g = 0; result && g < group_count; g += 1)
    {
        Summary* summary = &groups[g];
        const uint32_t expected = strncmp(summary->name, "scale-", 6) == 0 ? 5 : 11;
        if (summary->count != expected)
        {
            result = false;
        }
        for (uint32_t column = 0; column < 4; column += 1)
        {
            qsort(summary->values[column], summary->count, sizeof(uint64_t), compare);
        }
        const uint32_t mid = summary->count / 2;
        const uint32_t last = summary->count != 0 ? summary->count - 1 : 0;
        printf("%s\t%u\t%.6f\t%.6f\t%.6f\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", summary->name, summary->count,
               summary->values[0][mid] / 1e6, summary->values[0][0] / 1e6, summary->values[0][last] / 1e6,
               summary->values[1][mid], summary->values[2][mid], summary->values[3][mid], summary->values[3][0], summary->values[3][last]);
    }
    return result && group_count != 0 ? 0 : 1;
}
