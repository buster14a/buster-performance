// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded reader for non-timed helper-entry receipts from matched probes.
#include <ctype.h>
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Counts Counts;
struct Counts
{
    uint64_t total;
    uint64_t on;
    uint64_t off;
    uint64_t diagnostic;
    uint64_t compute;
    uint64_t builtin;
};

static bool parse_line(const char* line, Counts* counts)
{
    static const char* const names[] = { "total=", "access_on=", "access_off=", "diagnostic=", "compute=", "builtin=" };
    uint64_t values[6];
    const char* cursor = line + strlen("buster919-fenv ");
    bool valid = true;
    for (unsigned i = 0; valid && i < 6; i += 1)
    {
        const size_t length = strlen(names[i]);
        valid = strncmp(cursor, names[i], length) == 0;
        cursor += valid ? length : 0;
        valid = valid && isdigit((unsigned char)*cursor);
        if (valid)
        {
            errno = 0;
            char* end = NULL;
            const unsigned long long value = strtoull(cursor, &end, 10);
            valid = errno == 0 && end != cursor && value <= UINT64_MAX;
            values[i] = (uint64_t)value;
            cursor = end;
            if (i != 5)
            {
                valid = valid && *cursor == ' ';
                cursor += *cursor == ' ';
            }
        }
    }
    while (valid && isspace((unsigned char)*cursor))
    {
        cursor += 1;
    }
    valid = valid && *cursor == 0;
    if (valid)
    {
        *counts = (Counts){ values[0], values[1], values[2], values[3], values[4], values[5] };
        valid = counts->on <= UINT64_MAX - counts->off && counts->total == counts->on + counts->off &&
                counts->compute <= UINT64_MAX - counts->builtin && counts->total == counts->compute + counts->builtin &&
                counts->diagnostic <= counts->total;
    }
    return valid;
}

static bool read_counts(const char* path, Counts* counts)
{
    FILE* file = fopen(path, "rb");
    bool valid = file != NULL;
    unsigned receipts = 0;
    unsigned lines = 0;
    char line[4096];
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        lines += 1;
        valid = lines <= 10000 && (strchr(line, '\n') != NULL || feof(file));
        if (valid && strncmp(line, "buster919-fenv ", strlen("buster919-fenv ")) == 0)
        {
            receipts += 1;
            valid = receipts == 1 && parse_line(line, counts);
        }
    }
    if (file != NULL)
    {
        valid = !ferror(file) && fclose(file) == 0 && valid;
    }
    valid = valid && receipts == 1;
    return valid;
}

int main(int argc, char** argv)
{
    Counts base = { 0 };
    Counts head = { 0 };
    bool valid = argc == 4 && read_counts(argv[2], &base) && read_counts(argv[3], &head);
    const bool off = valid && strcmp(argv[1], "off") == 0;
    const bool on = valid && strcmp(argv[1], "on") == 0;
    const bool mixed = valid && strcmp(argv[1], "mixed") == 0;
    const bool invalid_on = valid && strcmp(argv[1], "invalid-on") == 0;
    valid = valid && (off || on || mixed || invalid_on) && base.total > 0 && head.off == 0 && head.on == base.on && head.total == base.on;
    if (off)
    {
        valid = valid && base.off > 0 && base.on == 0 && head.total == 0;
    }
    if (on)
    {
        valid = valid && base.on > 0 && head.on > 0 && base.builtin > 0 && head.builtin > 0;
    }
    if (mixed)
    {
        valid = valid && base.on > 0 && base.off > 0;
    }
    if (invalid_on)
    {
        valid = valid && base.on > 0 && base.diagnostic > 0 && head.diagnostic == base.diagnostic;
    }
    printf("{\"valid\":%s,\"base_total\":%llu,\"head_total\":%llu,\"base_on\":%llu,\"head_on\":%llu,\"base_off\":%llu,\"head_off\":%llu,\"base_diagnostic\":%llu,\"head_diagnostic\":%llu,\"base_compute\":%llu,\"head_compute\":%llu,\"base_builtin\":%llu,\"head_builtin\":%llu}\n",
           valid ? "true" : "false", (unsigned long long)base.total, (unsigned long long)head.total,
           (unsigned long long)base.on, (unsigned long long)head.on, (unsigned long long)base.off, (unsigned long long)head.off,
           (unsigned long long)base.diagnostic, (unsigned long long)head.diagnostic,
           (unsigned long long)base.compute, (unsigned long long)head.compute, (unsigned long long)base.builtin, (unsigned long long)head.builtin);
    if (!valid)
    {
        fprintf(stderr, "#919 call receipt FAILED (usage: validate_counts off|on|mixed|invalid-on BASE_LOG HEAD_LOG)\n");
    }
    return valid ? 0 : 1;
}
