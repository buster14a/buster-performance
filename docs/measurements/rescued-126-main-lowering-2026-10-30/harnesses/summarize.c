// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See Buster's LICENSE and LICENSING.md.
//
// Standalone offline reader for the unmodified benchmark's logs.
// cc -std=c17 -O2 -Wall -Wextra -Werror summarize.c -o summarize
// ./summarize process-*.log > summary.tsv
// The observations are paired per-process medians, not the unprinted inner passes.
#include <errno.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { MAX_ROUNDS = 101, MAX_LINE = 32768, FIELDS = 14 };
static const char* const field_names[FIELDS] = {
    "files", "functions_defined", "functions_lowered", "functions_skipped",
    "objects_defined", "objects_lowered", "objects_skipped", "lower_all_functions", "lower_all_objects",
    "referenced_ns", "all_ns", "passes", "failures", "saved_ns"
};

static bool read_count(const char* line, const char* key, uint64_t* value)
{
    char pattern[96];
    snprintf(pattern, sizeof(pattern), " %s=", key);
    const char* text = strstr(line, pattern);
    char* end = NULL;
    errno = 0;
    bool valid = text != NULL;
    if (valid)
    {
        text += strlen(pattern);
        valid = *text >= '0' && *text <= '9';
        if (valid)
        {
            *value = strtoull(text, &end, 10);
            valid = errno == 0 && end != text && (*end == ' ' || *end == '\n' || *end == '\0');
        }
    }
    return valid;
}

static bool read_log(const char* path, uint64_t* fields)
{
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    char line[MAX_LINE];
    unsigned files = 0;
    unsigned totals = 0;
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        if (strncmp(line, "lowering-source:", 16) == 0 && strstr(line, "file=") != NULL)
        {
            files += 1;
            valid = strstr(line, "file=src/buster/compiler/main.c ") != NULL &&
                    strstr(line, " referenced_ns=") != NULL && strstr(line, " all_ns=") != NULL;
        }
        if (strncmp(line, "lowering-source: totals ", 23) == 0)
        {
            totals += 1;
            // saved_ns can be negative; derive the signed difference from the paired observations below.
            for (unsigned field = 0; valid && field + 1 < FIELDS; field += 1)
            {
                valid = read_count(line, field_names[field], fields + field);
            }
        }
    }
    valid = valid && !ferror(input) && files == 1 && totals == 1;
    valid = valid && fields[0] == 1 && fields[12] == 0 && fields[11] != 0 &&
            fields[9] != 0 && fields[10] != 0 &&
            fields[1] == fields[2] + fields[3] && fields[4] == fields[5] + fields[6] &&
            fields[7] >= fields[2] && fields[7] <= fields[1] && fields[8] >= fields[5] && fields[8] <= fields[4];
    if (input != NULL)
    {
        fclose(input);
    }
    return valid;
}

static void ordered(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double value = values[i];
        unsigned at = i;
        while (at != 0 && values[at - 1] > value)
        {
            values[at] = values[at - 1];
            at -= 1;
        }
        values[at] = value;
    }
}

int main(int argc, char** argv)
{
    const unsigned count = argc > 0 ? (unsigned)argc - 1 : 0;
    bool valid = count >= 7 && count <= MAX_ROUNDS && count % 2 == 1;
    uint64_t reference[FIELDS] = { 0 };
    double metrics[4][MAX_ROUNDS] = { { 0 } };
    for (unsigned run = 0; valid && run < count; run += 1)
    {
        uint64_t row[FIELDS] = { 0 };
        valid = read_log(argv[run + 1], row);
        for (unsigned field = 0; valid && field <= 8; field += 1)
        {
            valid = run == 0 || row[field] == reference[field];
        }
        valid = valid && (run == 0 || row[11] == reference[11]);
        if (valid)
        {
            memcpy(reference, row, sizeof(row));
            metrics[0][run] = (double)row[9];
            metrics[1][run] = (double)row[10];
            metrics[2][run] = (double)row[10] - (double)row[9];
            metrics[3][run] = 100.0 * metrics[2][run] / (double)row[10];
        }
        else
        {
            fprintf(stderr, "Invalid, refused, missing, or changed-count result: %s\n", argv[run + 1]);
        }
    }
    if (valid)
    {
        // Exact binomial order-statistic median interval. Choose the tightest central interval
        // with at least 95% nominal coverage under independent, identically distributed rounds.
        double probability = 1.0;
        for (unsigned i = 0; i < count; i += 1)
        {
            probability *= 0.5;
        }
        double tail = 0.0;
        double coverage = 1.0;
        unsigned k = 0;
        for (unsigned i = 0; i < count / 2; i += 1)
        {
            tail += probability;
            const double candidate = 1.0 - 2.0 * tail;
            if (candidate >= 0.95)
            {
                k = i + 1;
                coverage = candidate;
            }
            probability *= (double)(count - i) / (double)(i + 1);
        }
        valid = k != 0;
        if (valid)
        {
            printf("# observations=%u; inner_passes=%" PRIu64 "; interval=binomial median; nominal_coverage=%.9f; ranks=%u,%u\n", count, reference[11], coverage, k, count + 1 - k);
            printf("# Process rounds are the observations. The unprinted inner-pass distribution is not reconstructed.\n");
            for (unsigned field = 0; field <= 8; field += 1)
            {
                printf("# %s=%" PRIu64 "\n", field_names[field], reference[field]);
            }
            const char* const names[4] = { "referenced_ns", "all_ns", "paired_saved_ns", "paired_saved_percent" };
            printf("metric\tmedian\tinterval_low\tinterval_high\tminimum\tmaximum\n");
            for (unsigned metric = 0; metric < 4; metric += 1)
            {
                ordered(metrics[metric], count);
                printf("%s\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\n", names[metric], metrics[metric][count / 2], metrics[metric][k - 1], metrics[metric][count - k], metrics[metric][0], metrics[metric][count - 1]);
            }
        }
    }
    if (!valid)
    {
        fprintf(stderr, "usage: summarize process-*.log (7..101 odd independent successful main.c rounds with fixed counts)\n");
    }
    return valid ? 0 : 1;
}
