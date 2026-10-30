// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original preparation tool for Buster #868/#883, 2026-10-30.
// Aggregate attempted-root diagnostics from the exact fragment trace schema. This program deliberately has no
// all-expression denominator, deduplication by root ID, timing output or source/function attribution.
#define _POSIX_C_SOURCE 200809L
#include <ctype.h>
#include <errno.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

#define INVENTORY_RESULTS 9u
#define INVENTORY_NODES 16u

typedef struct Outcome Outcome;
struct Outcome
{
    uint64_t count;
    uint64_t visited;
    uint64_t entries;
    uint64_t sizes[INVENTORY_NODES + 1];
};

static bool parse_record(const char* line, uint32_t values[4])
{
    static const char* const labels[] = { "lower-fragment root=", " visited=", " result=", " entries=" };
    const char* cursor = line;
    bool valid = true;
    for (uint32_t field = 0; valid && field < 4; field += 1)
    {
        const size_t length = strlen(labels[field]);
        valid = strncmp(cursor, labels[field], length) == 0;
        if (valid)
        {
            cursor += length;
            valid = isdigit((unsigned char)*cursor) != 0;
        }
        if (valid)
        {
            char* end = NULL;
            errno = 0;
            const unsigned long long value = strtoull(cursor, &end, 10);
            valid = errno != ERANGE && value <= UINT32_MAX && end != cursor;
            values[field] = valid ? (uint32_t)value : 0;
            cursor = end;
        }
    }
    while (valid && *cursor != 0)
    {
        valid = isspace((unsigned char)*cursor) != 0;
        cursor += 1;
    }
    return valid;
}

int main(int argc, char** argv)
{
    static const char prefix[] = "lower-fragment ";
    static const char* const names[INVENTORY_RESULTS] = {
        "ok", "order", "bound", "operator", "effect", "type", "conversion", "payload", "capacity",
    };
    Outcome outcomes[INVENTORY_RESULTS] = { 0 };
    uint64_t entry_sizes[INVENTORY_NODES + 1] = { 0 };
    uint64_t lines = 0;
    uint64_t other = 0;
    uint64_t attempts = 0;
    uint64_t visited_total = 0;
    uint64_t entries_total = 0;
    FILE* input = stdin;
    int status = 0;
    if (argc > 2)
    {
        fprintf(stderr, "usage: fragment-inventory [TRACE_STDERR_FILE]\n");
        status = 1;
    }
    else if (argc == 2)
    {
        input = fopen(argv[1], "r");
        if (input == NULL)
        {
            perror(argv[1]);
            status = 1;
        }
    }
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length = 0;
    while (status == 0 && (length = getline(&line, &capacity, input)) >= 0)
    {
        lines += 1;
        if (memchr(line, 0, (size_t)length) != NULL)
        {
            fprintf(stderr, "fragment-inventory: embedded NUL at line %" PRIu64 "\n", lines);
            status = 1;
        }
        else if (strncmp(line, prefix, sizeof(prefix) - 1) != 0)
        {
            other += 1;
        }
        else
        {
            uint32_t fields[4] = { 0 };
            bool valid = parse_record(line, fields);
            const uint32_t visited = fields[1];
            const uint32_t result = fields[2];
            const uint32_t entries = fields[3];
            valid = valid && result < INVENTORY_RESULTS && visited <= INVENTORY_NODES && entries <= visited;
            valid = valid && (result == 0 ? visited >= 3 && entries > 0 : entries == 0);
            if (!valid)
            {
                fprintf(stderr, "fragment-inventory: malformed trace record at line %" PRIu64 "\n", lines);
                status = 1;
            }
            else if (attempts == UINT64_MAX || UINT64_MAX - visited_total < visited || UINT64_MAX - entries_total < entries)
            {
                fprintf(stderr, "fragment-inventory: count overflow\n");
                status = 1;
            }
            else
            {
                Outcome* outcome = &outcomes[result];
                outcome->count += 1;
                outcome->visited += visited;
                outcome->entries += entries;
                outcome->sizes[visited] += 1;
                entry_sizes[entries] += result == 0;
                attempts += 1;
                visited_total += visited;
                entries_total += entries;
            }
        }
    }
    if (status == 0 && !feof(input))
    {
        fprintf(stderr, "fragment-inventory: input read failed: %s\n", strerror(errno));
        status = 1;
    }
    if (status == 0 && attempts == 0)
    {
        fprintf(stderr, "fragment-inventory: no attempted-root records; verify vector build, trace define and lowering command\n");
        status = 2;
    }
    if (status == 0)
    {
        printf("kind\tlabel\tvalue\tcount\tvisited_sum\tentries_sum\n");
        printf("summary\tattempted_roots\t0\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", attempts, visited_total, entries_total);
        printf("summary\tother_stderr_lines\t0\t%" PRIu64 "\t0\t0\n", other);
        for (uint32_t result = 0; result < INVENTORY_RESULTS; result += 1)
        {
            const Outcome* outcome = &outcomes[result];
            printf("outcome\t%s\t%u\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n", names[result], result,
                   outcome->count, outcome->visited, outcome->entries);
            for (uint32_t visited = 0; visited <= INVENTORY_NODES; visited += 1)
            {
                if (outcome->sizes[visited] != 0)
                {
                    printf("visited\t%s\t%u\t%" PRIu64 "\t0\t0\n", names[result], visited, outcome->sizes[visited]);
                }
            }
        }
        for (uint32_t entries = 1; entries <= INVENTORY_NODES; entries += 1)
        {
            if (entry_sizes[entries] != 0)
            {
                printf("accepted_entries\tok\t%u\t%" PRIu64 "\t0\t0\n", entries, entry_sizes[entries]);
            }
        }
        if (fflush(stdout) != 0 || ferror(stdout))
        {
            fprintf(stderr, "fragment-inventory: output write failed\n");
            status = 1;
        }
    }
    free(line);
    if (input != stdin && input != NULL)
    {
        if (fclose(input) != 0)
        {
            status = 1;
        }
    }
    return status;
}
