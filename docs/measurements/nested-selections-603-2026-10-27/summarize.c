// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original procbench/stage-summary reader for #603.
// summarize RESULTS.tsv CAPTURE_DIRECTORY [--reader]. All non-warm-up statuses and cycle availability are checked.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Group Group;
struct Group
{
    char label[128];
    uint32_t count;
    double wall[128];
    double input[128];
    double cycles[128];
    double instructions[128];
    double rss[128];
};

static double median(double* values, uint32_t count)
{
    for (uint32_t i = 1; i < count; i += 1)
    {
        const double value = values[i];
        uint32_t j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

int main(int argc, char** argv)
{
    static Group groups[64];
    uint32_t group_count = 0;
    uint32_t failures = 0;
    const bool reader = argc == 4 && strcmp(argv[3], "--reader") == 0;
    FILE* input = argc == 3 || reader ? fopen(argv[1], "r") : NULL;
    bool valid = input != NULL;
    char line[16384];
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        char* fields[32];
        char* save = NULL;
        uint32_t count = 0;
        for (char* field = strtok_r(line, "\t\n", &save); field != NULL && count < 32; field = strtok_r(NULL, "\t\n", &save))
        {
            fields[count++] = field;
        }
        if (count < 17 || strcmp(fields[0], "round") == 0)
        {
            continue;
        }
        failures += strtoul(fields[5], NULL, 10) != 0;
        if (strtoul(fields[4], NULL, 10) != 0)
        {
            continue;
        }
        uint32_t group = 0;
        while (group < group_count && strcmp(groups[group].label, fields[2]) != 0)
        {
            group += 1;
        }
        valid = group < 64 && groups[group].count < 128;
        if (valid)
        {
            if (group == group_count)
            {
                snprintf(groups[group].label, sizeof(groups[group].label), "%s", fields[2]);
                group_count += 1;
            }
            Group* record = groups + group;
            const uint32_t sample = record->count++;
            record->wall[sample] = strtod(fields[6], NULL) / 1e6;
            record->rss[sample] = strtod(fields[13], NULL);
            for (uint32_t field = 17; field < count; field += 1)
            {
                if (strncmp(fields[field], "cycles=", 7) == 0)
                {
                    record->cycles[sample] = strtod(fields[field] + 7, NULL);
                }
                if (strncmp(fields[field], "instructions=", 13) == 0)
                {
                    record->instructions[sample] = strtod(fields[field] + 13, NULL);
                }
            }
            char path[4096];
            snprintf(path, sizeof(path), "%s/%s-%s-%s.%s", argv[2], fields[0], fields[2], fields[3], reader ? "out" : "err");
            FILE* capture = fopen(path, "r");
            char stage[4096];
            bool found = false;
            while (capture != NULL && fgets(stage, sizeof(stage), capture) != NULL)
            {
                double milliseconds = 0;
                if (!reader && sscanf(stage, "time-stage\tcheck-input\t%lf", &milliseconds) == 1)
                {
                    record->input[sample] = milliseconds;
                    found = true;
                }
                if (reader)
                {
                    double ns = 0;
                    double low = 0;
                    double high = 0;
                    double cycles = 0;
                    if (sscanf(stage, "check_input: mode=direct ns=%lf min_ns=%lf max_ns=%lf cycles=%lf", &ns, &low, &high, &cycles) == 4)
                    {
                        record->input[sample] = ns / 1e6;
                        record->cycles[sample] = cycles;
                        found = true;
                    }
                }
            }
            if (capture != NULL)
            {
                fclose(capture);
            }
            valid &= found && record->cycles[sample] > 0 && (reader || record->instructions[sample] > 0);
        }
    }
    if (input != NULL)
    {
        fclose(input);
    }
    printf(reader ? "label\tsamples\tbenchmark_process_ms\tcheck_input_ms\tcheck_input_cycles\tbenchmark_maxrss_kb\n" :
                   "label\tsamples\twall_ms\tcheck_input_ms\tcycles\tinstructions\tmaxrss_kb\n");
    for (uint32_t group = 0; valid && group < group_count; group += 1)
    {
        Group* record = groups + group;
        printf("%s\t%u\t%.6f\t%.6f\t%.0f\t", record->label, record->count, median(record->wall, record->count),
               median(record->input, record->count), median(record->cycles, record->count));
        if (!reader)
        {
            printf("%.0f\t", median(record->instructions, record->count));
        }
        printf("%.0f\n", median(record->rss, record->count));
    }
    fprintf(stderr, "summary valid=%u groups=%u failed_processes=%u\n", valid, group_count, failures);
    return valid && group_count != 0 && failures == 0 ? 0 : 1;
}
