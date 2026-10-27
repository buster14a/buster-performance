// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #598 raw-record summarizer. Medians retain failed compile counts separately.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Row Row;
struct Row
{
    char variant[16];
    char kind[16];
    unsigned size;
    double wall[16];
    double lower[16];
    double tier0[16];
    double encode[16];
    double rss[16];
    double runtime[16];
    unsigned compiles;
    unsigned failures;
    unsigned runs;
};

static Row rows[128];
static unsigned row_count;
static const char* log_directory = "logs";

static Row* row(const char* variant, const char* kind, unsigned size)
{
    unsigned i = 0;
    while (i < row_count && (strcmp(rows[i].variant, variant) != 0 || strcmp(rows[i].kind, kind) != 0 || rows[i].size != size))
    {
        i += 1;
    }
    if (i == row_count && row_count < 128)
    {
        snprintf(rows[i].variant, sizeof(rows[i].variant), "%s", variant);
        snprintf(rows[i].kind, sizeof(rows[i].kind), "%s", kind);
        rows[i].size = size;
        row_count += 1;
    }
    return i < 128 ? rows + i : NULL;
}

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return count != 0 ? values[count / 2] : -1;
}

static void stages(Row* record, unsigned round, unsigned sample)
{
    record->lower[sample] = -1;
    record->tier0[sample] = -1;
    record->encode[sample] = -1;
    char path[512];
    snprintf(path, sizeof(path), "%s/%s-%s-%u-%u.log", log_directory, record->variant, record->kind, record->size, round);
    FILE* file = fopen(path, "r");
    char line[1024];
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        char name[64];
        double ms = 0;
        if (sscanf(line, "time-stage\t%63s\t%lf", name, &ms) == 2)
        {
            if (strcmp(name, "lower") == 0)
            {
                record->lower[sample] = ms;
            }
            else if (strcmp(name, "tier0") == 0)
            {
                record->tier0[sample] = ms;
            }
            else if (strcmp(name, "encode") == 0)
            {
                record->encode[sample] = ms;
            }
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
}

int main(int argc, char** argv)
{
    FILE* input = argc == 2 || argc == 3 ? fopen(argv[1], "r") : NULL;
    log_directory = argc == 3 ? argv[2] : log_directory;
    int failed = input == NULL;
    char line[2048];
    while (!failed && fgets(line, sizeof(line), input) != NULL)
    {
        char variant[16];
        char kind[16];
        unsigned size = 0;
        unsigned round = 0;
        unsigned iterations = 0;
        unsigned long long wall = 0, user = 0, system = 0, checksum = 0;
        long rss = 0;
        int status = 0;
        if (sscanf(line, "compile,%15[^,],%15[^,],%u,%u,%llu,%llu,%llu,%ld,%d", variant, kind, &size, &round, &wall, &user, &system, &rss, &status) == 9)
        {
            Row* record = row(variant, kind, size);
            failed = record == NULL || record->compiles >= 16;
            if (!failed && status == 0)
            {
                const unsigned sample = record->compiles++;
                record->wall[sample] = (double)wall / 1e6;
                record->rss[sample] = rss;
                stages(record, round, sample);
            }
            else if (!failed)
            {
                record->failures += 1;
            }
        }
        else if (sscanf(line, "runtime,%15[^,],%15[^,],%u,%u,%u,%llu,%llu", variant, kind, &size, &round, &iterations, &wall, &checksum) == 7)
        {
            Row* record = row(variant, kind, size);
            failed = record == NULL || record->runs >= 16 || iterations == 0;
            if (!failed)
            {
                record->runtime[record->runs++] = (double)wall / iterations;
            }
        }
    }
    if (input != NULL)
    {
        fclose(input);
    }
    puts("variant,kind,size,successes,failures,wall_ms,lower_ms,tier0_ms,encode_ms,peak_rss_kb,text_bytes,rodata_bytes,entries,records,runtime_ns");
    for (unsigned i = 0; !failed && i < row_count; i += 1)
    {
        Row* record = rows + i;
        char path[512];
        long long text = -1, data = -1, entries = -1, records = -1;
        snprintf(path, sizeof(path), "%s/%s-%s-%u.sections", log_directory, record->variant, record->kind, record->size);
        FILE* file = fopen(path, "r");
        if (file != NULL)
        {
            text = 0;
            data = 0;
        }
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            char name[64];
            unsigned long long bytes = 0;
            if (sscanf(line, "%63s %llu", name, &bytes) == 2)
            {
                text += strncmp(name, ".text", 5) == 0 ? bytes : 0;
                data += strncmp(name, ".rodata", 7) == 0 ? bytes : 0;
            }
        }
        if (file != NULL)
        {
            fclose(file);
        }
        snprintf(path, sizeof(path), "%s/%s-%s-%u.backend", log_directory, record->variant, record->kind, record->size);
        file = fopen(path, "r");
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            const char* counts = strstr(line, " entries=");
            if (counts != NULL)
            {
                unsigned long long typed = 0, machine = 0;
                if (sscanf(counts, " entries=%llu records=%llu", &typed, &machine) == 2)
                {
                    entries = (long long)typed;
                    records = (long long)machine;
                }
            }
        }
        if (file != NULL)
        {
            fclose(file);
        }
        printf("%s,%s,%u,%u,%u,%.6f,%.6f,%.6f,%.6f,%.0f,%lld,%lld,%lld,%lld,%.6f\n", record->variant, record->kind, record->size,
               record->compiles, record->failures, median(record->wall, record->compiles), median(record->lower, record->compiles),
               median(record->tier0, record->compiles), median(record->encode, record->compiles), median(record->rss, record->compiles),
               text, data, entries, records, median(record->runtime, record->runs));
    }
    return failed;
}
