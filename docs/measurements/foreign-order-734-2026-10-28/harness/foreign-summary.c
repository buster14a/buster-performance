// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original bounded comparison reader for this record.

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PHASE_ROWS 320
#define WHOLE_ROWS 24

typedef struct PhaseRow PhaseRow;
struct PhaseRow
{
    unsigned int functions;
    char kind[16];
    unsigned int lanes;
    char path[16];
    char metric[16];
    unsigned long long median;
};

typedef struct WholeRow WholeRow;
struct WholeRow
{
    unsigned int functions;
    char kind[16];
    char placement[64];
    double minimum;
    double median;
    double maximum;
    unsigned long long bytes;
    unsigned long long faults;
    double resident;
};

static bool phase_read(const char* directory, const char* name, PhaseRow* rows)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/foreign-%s.csv", directory, name);
    FILE* file = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "r") : 0;
    bool valid = file != 0;
    char line[4096];
    unsigned int count = 0;
    valid = valid && fgets(line, sizeof(line), file) != 0 && strncmp(line, "dataset,functions,", 18) == 0;
    while (valid && fgets(line, sizeof(line), file) != 0)
    {
        char dataset[32];
        unsigned int runs = 0;
        unsigned long long minimum = 0;
        unsigned long long maximum = 0;
        double mean = 0;
        char tail = 0;
        valid = count < PHASE_ROWS;
        if (valid)
        {
            PhaseRow* row = &rows[count];
            const int fields = sscanf(line, "%31[^,],%u,%15[^,],%u,%15[^,],%15[^,],%u,%llu,%llu,%llu,%lf %c", dataset, &row->functions, row->kind,
                                      &row->lanes, row->path, row->metric, &runs, &minimum, &row->median, &maximum, &mean, &tail);
            valid = fields == 11 && strcmp(dataset, name) == 0 && runs == 21 && minimum <= row->median && row->median <= maximum;
            count += 1;
        }
    }
    if (file != 0)
    {
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    valid = count == PHASE_ROWS && valid;
    return valid;
}

static bool whole_read(const char* directory, const char* name, WholeRow* rows)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/link-%s.stdout", directory, name);
    FILE* file = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "r") : 0;
    bool valid = file != 0;
    char line[4096];
    unsigned int count = 0;
    unsigned int functions = 0;
    char kind[16] = { 0 };
    while (valid && fgets(line, sizeof(line), file) != 0)
    {
        unsigned int found = 0;
        if (sscanf(line, "%u worker", &found) == 1)
        {
            functions = found;
            const bool dynamic = strstr(line, "dynamic PIE:") != 0;
            const bool fixed = strstr(line, "static executable:") != 0;
            valid = (dynamic || fixed) && (functions == 1 || functions == 2000 || functions == 102400);
            snprintf(kind, sizeof(kind), "%s", dynamic ? "dynamic" : "static");
        }
        else if (strncmp(line, "  link-foreign, ", 16) == 0)
        {
            valid = count < WHOLE_ROWS && functions != 0;
            if (valid)
            {
                WholeRow* row = &rows[count];
                unsigned int runs = 0;
                char tail = 0;
                // Placement labels contain digits, so split timing at the explicit unit.
                const char* unit = strstr(line, " us:");
                const char* number = unit;
                while (number != 0 && number > line && number[-1] != ' ')
                {
                    number -= 1;
                }
                const size_t label = number != 0 ? (size_t)(number - (line + 16)) : sizeof(row->placement);
                valid = unit != 0 && label < sizeof(row->placement);
                if (valid)
                {
                    memcpy(row->placement, line + 16, label);
                    row->placement[label] = 0;
                    size_t end = label;
                    while (end > 0 && row->placement[end - 1] == ' ')
                    {
                        row->placement[--end] = 0;
                    }
                    const int values = sscanf(number, "%lf us: min %lf, max %lf of %u runs; %llu bytes, %llu page faults, %lf MB peak resident %c",
                                              &row->median, &row->minimum, &row->maximum, &runs, &row->bytes, &row->faults, &row->resident, &tail);
                    valid = values == 7 && runs == 7 && row->minimum <= row->median && row->median <= row->maximum;
                    row->functions = functions;
                    snprintf(row->kind, sizeof(row->kind), "%s", kind);
                }
                count += 1;
            }
        }
    }
    if (file != 0)
    {
        valid = !ferror(file) && valid;
        valid = fclose(file) == 0 && valid;
    }
    valid = count == WHOLE_ROWS && valid;
    return valid;
}

static double difference(double base, double candidate)
{
    return 100.0 * (candidate - base) / base;
}

int main(int argc, char** argv)
{
    static const char* const names[] = { "base-1", "candidate-1", "base-2", "candidate-2", "base-3", "candidate-3" };
    PhaseRow phases[6][PHASE_ROWS] = { 0 };
    WholeRow whole[4][WHOLE_ROWS] = { 0 };
    bool valid = argc == 2;
    for (unsigned int input = 0; valid && input < 6; input += 1)
    {
        valid = phase_read(argv[1], names[input], phases[input]);
        for (unsigned int row = 0; valid && row < PHASE_ROWS; row += 1)
        {
            valid = phases[input][row].functions == phases[0][row].functions && phases[input][row].lanes == phases[0][row].lanes &&
                    strcmp(phases[input][row].kind, phases[0][row].kind) == 0 && strcmp(phases[input][row].path, phases[0][row].path) == 0 &&
                    strcmp(phases[input][row].metric, phases[0][row].metric) == 0 && phases[input][row].median > 0;
        }
    }
    for (unsigned int input = 0; valid && input < 4; input += 1)
    {
        valid = whole_read(argv[1], names[input], whole[input]);
        for (unsigned int row = 0; valid && row < WHOLE_ROWS; row += 1)
        {
            valid = whole[input][row].functions == whole[0][row].functions && strcmp(whole[input][row].kind, whole[0][row].kind) == 0 &&
                    strcmp(whole[input][row].placement, whole[0][row].placement) == 0 && whole[input][row].bytes == whole[0][row].bytes && whole[input][row].median > 0;
        }
    }
    char path[4096];
    FILE* output = 0;
    if (valid)
    {
        const int length = snprintf(path, sizeof(path), "%s/phase-comparison.csv", argv[1]);
        output = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "w") : 0;
        valid = output != 0;
    }
    if (valid)
    {
        fprintf(output, "functions,kind,lanes,path,metric,base1_ns,candidate1_ns,base2_ns,candidate2_ns,base3_ns,candidate3_ns,pair1_delta_ns,pair1_percent,pair2_delta_ns,pair2_percent,pair3_delta_ns,pair3_percent,base2_vs_base1_percent,base3_vs_base1_percent,base1_phase_fraction_percent\n");
        for (unsigned int row = 0; row < PHASE_ROWS; row += 1)
        {
            const PhaseRow* first = &phases[0][row];
            fprintf(output, "%u,%s,%u,%s,%s", first->functions, first->kind, first->lanes, first->path, first->metric);
            for (unsigned int input = 0; input < 6; input += 1)
            {
                fprintf(output, ",%llu", phases[input][row].median);
            }
            for (unsigned int input = 0; input < 6; input += 2)
            {
                const double base = (double)phases[input][row].median;
                const double candidate = (double)phases[input + 1][row].median;
                fprintf(output, ",%.0f,%.6f", candidate - base, difference(base, candidate));
            }
            fprintf(output, ",%.6f,%.6f,%.6f\n", difference((double)first->median, (double)phases[2][row].median),
                    difference((double)first->median, (double)phases[4][row].median), 100.0 * (double)first->median / (double)phases[0][row - row % 10].median);
        }
        valid = !ferror(output);
        valid = fclose(output) == 0 && valid;
    }
    output = 0;
    if (valid)
    {
        const int length = snprintf(path, sizeof(path), "%s/whole-command.csv", argv[1]);
        output = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "w") : 0;
        valid = output != 0;
    }
    if (valid)
    {
        fprintf(output, "dataset,functions,kind,placement,runs,min_us,median_us,max_us,bytes,page_faults,peak_resident_mb\n");
        for (unsigned int input = 0; input < 4; input += 1)
        {
            for (unsigned int row = 0; row < WHOLE_ROWS; row += 1)
            {
                const WholeRow* value = &whole[input][row];
                fprintf(output, "%s,%u,%s,\"%s\",7,%.1f,%.1f,%.1f,%llu,%llu,%.2f\n", names[input], value->functions, value->kind, value->placement,
                        value->minimum, value->median, value->maximum, value->bytes, value->faults, value->resident);
            }
        }
        valid = !ferror(output);
        valid = fclose(output) == 0 && valid;
    }
    output = 0;
    if (valid)
    {
        const int length = snprintf(path, sizeof(path), "%s/whole-comparison.csv", argv[1]);
        output = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "w") : 0;
        valid = output != 0;
    }
    if (valid)
    {
        fprintf(output, "functions,kind,placement,base1_us,candidate1_us,base2_us,candidate2_us,pair1_delta_us,pair1_percent,pair2_delta_us,pair2_percent,base2_vs_base1_percent,candidate2_vs_candidate1_percent\n");
        for (unsigned int row = 0; row < WHOLE_ROWS; row += 1)
        {
            const WholeRow* first = &whole[0][row];
            fprintf(output, "%u,%s,\"%s\"", first->functions, first->kind, first->placement);
            for (unsigned int input = 0; input < 4; input += 1)
            {
                fprintf(output, ",%.1f", whole[input][row].median);
            }
            fprintf(output, ",%.1f,%.6f,%.1f,%.6f,%.6f,%.6f\n", whole[1][row].median - first->median, difference(first->median, whole[1][row].median),
                    whole[3][row].median - whole[2][row].median, difference(whole[2][row].median, whole[3][row].median),
                    difference(first->median, whole[2][row].median), difference(whole[1][row].median, whole[3][row].median));
        }
        valid = !ferror(output);
        valid = fclose(output) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "foreign-summary: rejected incomplete or incompatible comparison inputs\n");
    }
    return valid ? 0 : 1;
}
