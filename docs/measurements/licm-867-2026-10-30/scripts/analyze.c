// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for the archived LICM process summaries, no statistical independence
// is assigned to the 21 within-process samples; paired process medians are the unit.
#include <dirent.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Row Row;
struct Row
{
    char variant[32];
    char state[32];
    char shape[32];
    char path[16];
    unsigned shift;
    unsigned process;
    unsigned length;
    double ns;
    double minimum;
    double maximum;
};

static Row rows[4096];
static unsigned count;

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned length)
{
    qsort(values, length, sizeof(*values), compare_double);
    return length % 2 ? values[length / 2] : (values[length / 2 - 1] + values[length / 2]) / 2;
}

static int read_directory(const char* directory)
{
    DIR* stream = opendir(directory);
    int valid = stream != NULL;
    struct dirent* entry;
    while (valid && (entry = readdir(stream)) != NULL)
    {
        if (entry->d_name[0] != '.')
        {
            char name[4096];
            valid = snprintf(name, sizeof(name), "%s/%s", directory, entry->d_name) < (int)sizeof(name);
            FILE* file = valid ? fopen(name, "r") : NULL;
            valid = valid && file != NULL;
            char line[8192];
            Row identity = { 0 };
            unsigned measurements = 0;
            const char* length_text = strstr(entry->d_name, "-length");
            identity.length = length_text != NULL ? (unsigned)strtoul(length_text + 7, NULL, 10) : 17;
            while (valid && fgets(line, sizeof(line), file) != NULL)
            {
                if (strncmp(line, "source-variant=", 15) == 0)
                {
                    valid = sscanf(line, "source-variant=%31s placement=%u process=%u cpu=2 state=%31s", identity.variant, &identity.shift, &identity.process, identity.state) == 4;
                }
                Row row = identity;
                unsigned samples = 0;
                unsigned repeats = 0;
                if (sscanf(line, "ir-pass licm %31s %15s samples=%u repeats=%u ns=%lf min=%lf max=%lf", row.shape, row.path, &samples, &repeats, &row.ns, &row.minimum, &row.maximum) == 7)
                {
                    valid = row.variant[0] != 0 && samples == 21 && repeats != 0 && row.ns > 0 && count < sizeof(rows) / sizeof(*rows);
                    if (valid)
                    {
                        rows[count++] = row;
                        measurements += 1;
                    }
                }
            }
            const unsigned expected_measurements = strcmp(identity.state, "isolated") == 0 || strcmp(identity.state, "after-scalar") == 0 ? 3 : 6;
            valid = valid && !ferror(file) && measurements == expected_measurements;
            if (file != NULL)
            {
                fclose(file);
            }
            if (!valid)
            {
                fprintf(stderr, "incomplete or malformed log: %s\n", name);
            }
        }
    }
    if (stream != NULL)
    {
        closedir(stream);
    }
    return valid;
}

static int validate_rows(void)
{
    const int source = count != 0 && strncmp(rows[0].variant, "source-", 7) == 0;
    int valid = count == (source ? 576u : 516u);
    for (unsigned i = 0; valid && i < count; i += 1)
    {
        const Row* a = &rows[i];
        const int baseline = strcmp(a->variant, source ? "source-base" : "base") == 0;
        valid = baseline || strcmp(a->variant, source ? "source-head" : "head") == 0;
        valid = valid && (strcmp(a->shape, "no-loop") == 0 || strcmp(a->shape, "nested-loops") == 0 || strcmp(a->shape, "invariant-chain") == 0);
        valid = valid && (strcmp(a->path, "scalar") == 0 || strcmp(a->path, "vector") == 0);
        const int after = strcmp(a->state, "after-scalar") == 0;
        const int isolated = strcmp(a->state, "isolated") == 0;
        valid = valid && (source ? strcmp(a->state, "source-loop") == 0 || strcmp(a->state, "source-nested") == 0 || strcmp(a->state, "source-noloop") == 0 || strcmp(a->state, "source-sqlite-normalize") == 0 : after || isolated || strcmp(a->state, "interleaved") == 0);
        valid = valid && a->shift <= 192 && a->shift % 64 == 0 && a->process >= 1 && a->process <= 3;
        valid = valid && (!after || (a->process == 1 && (a->shift == 0 || a->shift == 128)));
        valid = valid && (source ? a->length == 17 : after || isolated ? a->length == 4096 : a->length == 17 || a->length == 255 || a->length == 4096);
        valid = valid && (!(after || isolated) || strcmp(a->path, "vector") == 0);
        valid = valid && isfinite(a->minimum) && isfinite(a->ns) && isfinite(a->maximum) && a->minimum > 0 && a->minimum <= a->ns && a->ns <= a->maximum;
        unsigned matches = 0;
        for (unsigned j = 0; valid && j < count; j += 1)
        {
            const Row* b = &rows[j];
            const int same = a->shift == b->shift && a->process == b->process && a->length == b->length && strcmp(a->state, b->state) == 0 && strcmp(a->shape, b->shape) == 0 && strcmp(a->path, b->path) == 0;
            if (same)
            {
                valid = strcmp(a->variant, b->variant) != 0 || i == j;
                matches += strcmp(a->variant, b->variant) != 0;
            }
        }
        valid = valid && matches == 1;
    }
    return valid;
}

int main(int argc, char** argv)
{
    int valid = argc == 4 && read_directory(argv[1]) && validate_rows();
    unsigned summaries = 0;
    FILE* raw = valid ? fopen(argv[2], "w") : NULL;
    FILE* summary = valid ? fopen(argv[3], "w") : NULL;
    valid = valid && raw != NULL && summary != NULL;
    if (valid)
    {
        fputs("variant,shift,process,length,state,shape,path,ns,min,max\n", raw);
        fputs("state,length,shape,path,pairs,base_median_ns,head_median_ns,paired_head_over_base_median,ratio_min,ratio_max\n", summary);
    }
    for (unsigned i = 0; valid && i < count; i += 1)
    {
        const Row* row = &rows[i];
        fprintf(raw, "%s,%u,%u,%u,%s,%s,%s,%.2f,%.2f,%.2f\n", row->variant, row->shift, row->process, row->length, row->state, row->shape, row->path, row->ns, row->minimum, row->maximum);
        const int base = strcmp(row->variant, "base") == 0 || strcmp(row->variant, "source-base") == 0;
        int seen = 0;
        for (unsigned j = 0; j < i; j += 1)
        {
            seen |= strcmp(rows[j].variant, row->variant) == 0 && rows[j].length == row->length && strcmp(rows[j].state, row->state) == 0 && strcmp(rows[j].shape, row->shape) == 0 && strcmp(rows[j].path, row->path) == 0;
        }
        if (base && !seen)
        {
            double baseline[128];
            double candidate[128];
            double ratios[128];
            unsigned pairs = 0;
            for (unsigned j = 0; valid && j < count; j += 1)
            {
                const Row* a = &rows[j];
                if (strcmp(a->variant, row->variant) == 0 && a->length == row->length && strcmp(a->state, row->state) == 0 && strcmp(a->shape, row->shape) == 0 && strcmp(a->path, row->path) == 0)
                {
                    unsigned matches = 0;
                    for (unsigned k = 0; k < count; k += 1)
                    {
                        const Row* b = &rows[k];
                        const char* expected = strcmp(row->variant, "base") == 0 ? "head" : "source-head";
                        if (strcmp(b->variant, expected) == 0 && a->shift == b->shift && a->process == b->process && a->length == b->length && strcmp(a->state, b->state) == 0 && strcmp(a->shape, b->shape) == 0 && strcmp(a->path, b->path) == 0)
                        {
                            valid = pairs < 128;
                            if (valid)
                            {
                                baseline[pairs] = a->ns;
                                candidate[pairs] = b->ns;
                                ratios[pairs++] = b->ns / a->ns;
                                matches += 1;
                            }
                        }
                    }
                    valid = valid && matches == 1;
                }
            }
            if (valid && pairs != 0)
            {
                valid = pairs == (strcmp(row->state, "after-scalar") == 0 ? 2u : 12u);
                const double a = median(baseline, pairs);
                const double b = median(candidate, pairs);
                const double ratio = median(ratios, pairs);
                fprintf(summary, "%s,%u,%s,%s,%u,%.2f,%.2f,%.6f,%.6f,%.6f\n", row->state, row->length, row->shape, row->path, pairs, a, b, ratio, ratios[0], ratios[pairs - 1]);
                summaries += 1;
            }
        }
    }
    valid = valid && summaries == 24;
    if (raw != NULL)
    {
        valid = fclose(raw) == 0 && valid;
    }
    if (summary != NULL)
    {
        valid = fclose(summary) == 0 && valid;
    }
    return valid ? 0 : 1;
}
