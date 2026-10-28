// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original paired analysis of time-runs receipts. Copies are averaged within a round; all majors/statuses retained.
#define _GNU_SOURCE
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { LISTS = 16, RUNS = 128, FIELDS = 8, BOOTSTRAPS = 10000 };
typedef struct Row Row;
struct Row
{
    double sum[FIELDS];
    unsigned count;
    unsigned failed;
    unsigned long long major;
};
static Row rows[LISTS][RUNS][2];
static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}
static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return count & 1 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) * 0.5;
}
static uint64_t random_word(uint64_t* state)
{
    uint64_t value = *state;
    value ^= value << 13;
    value ^= value >> 7;
    value ^= value << 17;
    *state = value;
    return value;
}
int main(int argc, char** argv)
{
    int result = 2;
    if (argc == 4)
    {
        FILE* input = fopen(argv[1], "r");
        if (input != NULL)
        {
            char* line = NULL;
            size_t capacity = 0;
            unsigned loaded = 0;
            while (getline(&line, &capacity, input) >= 0)
            {
                unsigned run, list;
                char label[64], build[64];
                double wall, user, system;
                unsigned long long rss, minor, major, cycles, instructions;
                int status;
                if (sscanf(line, "run %u list %u %63[^:]: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d",
                           &run, &list, label, &wall, &user, &system, &rss, &minor, &major, &cycles, &instructions, &status) == 12 &&
                    sscanf(label, "%63s", build) == 1 && list > 0 && list <= LISTS && run > 0 && run <= RUNS)
                {
                    const int role = strcmp(build, argv[2]) == 0 ? 0 : strcmp(build, argv[3]) == 0 ? 1 : -1;
                    if (role >= 0)
                    {
                        Row* row = &rows[list - 1][run - 1][role];
                        const double fields[FIELDS] = { wall, user, system, rss, minor, major, cycles, instructions };
                        for (unsigned field = 0; field < FIELDS; field += 1) row->sum[field] += fields[field];
                        row->count += 1;
                        row->failed += status != 0;
                        row->major += major;
                        loaded += 1;
                    }
                }
            }
            free(line);
            fclose(input);
            result = loaded == 0;
            printf("loaded=%u base=%s candidate=%s\n", loaded, argv[2], argv[3]);
            for (unsigned list = 0; list < LISTS; list += 1)
            {
                double values[2][FIELDS][RUNS];
                double ratios[RUNS];
                unsigned count = 0, faster = 0, failed[2] = { 0 }, copies[2] = { 0 };
                unsigned long long majors[2] = { 0 };
                for (unsigned run = 0; run < RUNS; run += 1)
                {
                    const Row* base = &rows[list][run][0];
                    const Row* candidate = &rows[list][run][1];
                    if (base->count != 0 && candidate->count != 0)
                    {
                        for (unsigned role = 0; role < 2; role += 1)
                        {
                            const Row* row = &rows[list][run][role];
                            for (unsigned field = 0; field < FIELDS; field += 1) values[role][field][count] = row->sum[field] / row->count;
                            failed[role] += row->failed;
                            majors[role] += row->major;
                            copies[role] += row->count;
                        }
                        ratios[count] = 100.0 * (values[1][0][count] / values[0][0][count] - 1.0);
                        faster += ratios[count] < 0;
                        count += 1;
                    }
                    else if (base->count != 0 || candidate->count != 0)
                    {
                        fprintf(stderr, "unpaired list=%u run=%u\n", list + 1, run + 1);
                        result = 1;
                    }
                }
                if (count != 0)
                {
                    double bootstraps[BOOTSTRAPS], sample[RUNS], ratio_copy[RUNS];
                    uint64_t state = UINT64_C(0x657590652);
                    for (unsigned draw = 0; draw < BOOTSTRAPS; draw += 1)
                    {
                        for (unsigned item = 0; item < count; item += 1) sample[item] = ratios[random_word(&state) % count];
                        bootstraps[draw] = median(sample, count);
                    }
                    memcpy(ratio_copy, ratios, count * sizeof(double));
                    const double paired = median(ratio_copy, count);
                    qsort(bootstraps, BOOTSTRAPS, sizeof(double), compare);
                    printf("list=%u rounds=%u processes=%u/%u failed=%u/%u majors=%llu/%llu paired_change_pct=%.4f bootstrap95=[%.4f,%.4f] faster=%u/%u\n",
                           list + 1, count, copies[0], copies[1], failed[0], failed[1], majors[0], majors[1], paired,
                           bootstraps[BOOTSTRAPS / 40], bootstraps[BOOTSTRAPS - BOOTSTRAPS / 40 - 1], faster, count);
                    printf("  medians wall_ms user_ms system_ms rss_kb minor major cycles instructions\n");
                    for (unsigned role = 0; role < 2; role += 1)
                    {
                        printf("  %s", role == 0 ? argv[2] : argv[3]);
                        for (unsigned field = 0; field < FIELDS; field += 1) printf(" %.6f", median(values[role][field], count));
                        putchar('\n');
                    }
                    result |= failed[0] != 0 || failed[1] != 0;
                }
            }
        }
    }
    return result;
}
