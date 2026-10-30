// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Validate four real-input untimed traces, not instruction or total-work counts.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool literal(const char** cursor, const char* value)
{
    const size_t length = strlen(value);
    const bool equal = strncmp(*cursor, value, length) == 0;
    if (equal) *cursor += length;
    return equal;
}

static bool number(const char** cursor, const char* name, uint32_t* value)
{
    bool valid = literal(cursor, name) && **cursor >= '0' && **cursor <= '9';
    if (valid)
    {
        char* end = NULL;
        errno = 0;
        const uintmax_t parsed = strtoumax(*cursor, &end, 10);
        valid = end != *cursor && errno != ERANGE && parsed <= UINT32_MAX;
        if (valid) { *value = (uint32_t)parsed; *cursor = end; }
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 6;
    uint32_t full = 0, compact = 0, errno_index = 0;
    for (unsigned file = 0; valid && file < 4; file += 1)
    {
        FILE* input = fopen(argv[file + 2], "rb");
        valid = input != NULL;
        char* line = NULL;
        size_t capacity = 0;
        unsigned found = 0;
        while (valid && getline(&line, &capacity, input) >= 0)
        {
            if (strncmp(line, "runtime-scan mode=", 18) != 0) continue;
            const char* cursor = line;
            uint32_t scalar = 0, spelled = 0, n = 0, d = 0, visited = 0, slot = 0, oracle = 0;
            valid = ++found == 1 && literal(&cursor, file < 2 ? "runtime-scan mode=base" : "runtime-scan mode=candidate") &&
                number(&cursor, " scalar=", &scalar) && number(&cursor, " spelled=", &spelled) &&
                number(&cursor, " full=", &n) && number(&cursor, " compact=", &d) &&
                number(&cursor, " visited=", &visited) && number(&cursor, " errno-index=", &slot);
            if (valid && file >= 2) valid = number(&cursor, " oracle-equal=", &oracle) && oracle == 1;
            valid = valid && strcmp(cursor, "\n") == 0 && scalar == file % 2 && spelled == 1 && n > 0 && d > 0 && d < n &&
                visited == (file == 2 ? d : n);
            if (valid && file == 0) { full = n; compact = d; errno_index = slot; }
            valid = valid && n == full && d == compact && slot == errno_index;
        }
        if (input != NULL) valid = !ferror(input) && fclose(input) == 0 && found == 1 && valid;
        free(line);
    }
    if (valid)
    {
        printf("corpus,full_token_visits,compact_list_visits,visits_removed,reduction_factor\n");
        printf("%s,%" PRIu32 ",%" PRIu32 ",%" PRIu32 ",%.6f\n", argv[1], full, compact, full - compact, (double)full / compact);
    }
    else fprintf(stderr, "runtime trace rejected: require exercised spelled native/scalar branches, matching cardinalities and full-token oracle\n");
    return valid ? 0 : 1;
}
