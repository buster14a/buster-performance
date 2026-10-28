// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded reader for the nine rotated per-process perf instruction pairs.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool read_count(const char* path, uint64_t* count)
{
    FILE* input = fopen(path, "r");
    bool valid = input != NULL;
    unsigned found = 0;
    char line[1024];
    while (valid && fgets(line, sizeof(line), input) != NULL)
    {
        char* fields[8] = { line };
        unsigned columns = 1;
        for (char* at = line; *at != 0 && columns < 8; at += 1)
        {
            if (*at == ',')
            {
                *at = 0;
                fields[columns++] = at + 1;
            }
        }
        if (columns >= 5 && strcmp(fields[2], "instructions:u") == 0)
        {
            char* end = NULL;
            *count = strtoull(fields[0], &end, 10);
            const double duty = strtod(fields[4], NULL);
            valid = found == 0 && end != fields[0] && *end == 0 && *count != 0 && duty >= 99.999;
            found += 1;
        }
    }
    if (input != NULL)
    {
        valid = valid && !ferror(input) && found == 1;
        fclose(input);
    }
    return valid;
}

static int compare_counts(const void* left, const void* right)
{
    const uint64_t a = *(const uint64_t*)left;
    const uint64_t b = *(const uint64_t*)right;
    return (a > b) - (a < b);
}

static int compare_ratios(const void* left, const void* right)
{
    const double a = *(const double*)left;
    const double b = *(const double*)right;
    return (a > b) - (a < b);
}

int main(int argc, char** argv)
{
    uint64_t counts[2][9] = { { 0 } };
    double paired[9] = { 0 };
    bool valid = argc == 2;
    for (unsigned round = 0; valid && round < 9; round += 1)
    {
        for (unsigned role = 0; valid && role < 2; role += 1)
        {
            char path[4096];
            const int used = snprintf(path, sizeof(path), "%s/r%u-role%u.csv", argv[1], round, role);
            valid = used > 0 && (size_t)used < sizeof(path) && read_count(path, &counts[role][round]);
        }
        if (valid)
        {
            paired[round] = ((double)counts[1][round] / (double)counts[0][round] - 1) * 100;
            printf("round=%u role0=%llu role1=%llu role1_change_percent=%.6f\n", round,
                   (unsigned long long)counts[0][round], (unsigned long long)counts[1][round], paired[round]);
        }
    }
    if (valid)
    {
        qsort(counts[0], 9, sizeof(uint64_t), compare_counts);
        qsort(counts[1], 9, sizeof(uint64_t), compare_counts);
        qsort(paired, 9, sizeof(double), compare_ratios);
        printf("retired_user_instructions role0_median=%llu role1_median=%llu role1_change_percent=%.6f paired_median_percent=%.6f duty_minimum=99.999%%\n",
               (unsigned long long)counts[0][4], (unsigned long long)counts[1][4],
               ((double)counts[1][4] / (double)counts[0][4] - 1) * 100, paired[4]);
    }
    return !valid;
}
