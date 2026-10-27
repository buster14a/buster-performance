// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Validate all timed receipts and recompute medians from the retained fresh-process samples.
#define _GNU_SOURCE
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Sample Sample;
struct Sample
{
    uint64_t wall;
    uint64_t system;
    uint64_t faults;
    uint64_t rss;
};

typedef struct Group Group;
struct Group
{
    char mode[64];
    uint64_t size;
    uint32_t seen[2];
    Sample samples[2][21];
};

static Group groups[44];

static uint64_t median(const Sample* samples, unsigned begin, unsigned count, unsigned field)
{
    uint64_t ordered[21];
    for (unsigned i = 0; i < count; i += 1)
    {
        const Sample* sample = &samples[begin + i];
        const uint64_t value = field == 0 ? sample->wall : field == 1 ? sample->system : field == 2 ? sample->faults : sample->rss;
        unsigned at = i;
        while (at != 0 && ordered[at - 1] > value)
        {
            ordered[at] = ordered[at - 1];
            at -= 1;
        }
        ordered[at] = value;
    }
    return ordered[count / 2];
}

int main(int argc, char** argv)
{
    bool valid = argc == 4;
    unsigned count = 0;
    unsigned rows = 0;
    unsigned warmups = 0;
    char* line = NULL;
    size_t capacity = 0;
    for (unsigned file = 0; valid && file < 3; file += 1)
    {
        FILE* input = fopen(argv[file + 1], "r");
        valid = input != NULL && getline(&line, &capacity, input) > 0 && strncmp(line, "round\tcase\tN\trole", 17) == 0;
        while (valid && getline(&line, &capacity, input) > 0)
        {
            unsigned round = 0;
            char mode[64];
            char role[16];
            uint64_t size = 0;
            int repetition = -2;
            Sample sample = { 0 };
            uint64_t major = 0;
            int status = -1;
            int consumed = 0;
            const int fields = sscanf(line, "%u\t%63s\t%" SCNu64 "\t%15s\t%d\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%" SCNu64 "\t%d%n",
                                      &round, mode, &size, role, &repetition, &sample.wall, &sample.system, &sample.faults, &major, &sample.rss, &status, &consumed);
            valid = fields == 11 && line[consumed] == '\n' && line[consumed + 1] == 0 && round == file &&
                    repetition >= -1 && repetition < 7 && sample.wall > 0 && sample.rss > 0 && (repetition < 0 || major == 0) && status == 0 &&
                    (strcmp(role, "base") == 0 || strcmp(role, "head") == 0);
            unsigned at = 0;
            while (valid && at < count && (strcmp(groups[at].mode, mode) != 0 || groups[at].size != size))
            {
                at += 1;
            }
            if (valid && at == count)
            {
                valid = count < 44;
                if (valid)
                {
                    strcpy(groups[at].mode, mode);
                    groups[at].size = size;
                    count += 1;
                }
            }
            if (valid && repetition >= 0)
            {
                const unsigned side = strcmp(role, "head") == 0;
                const unsigned index = round * 7 + (unsigned)repetition;
                const uint32_t bit = UINT32_C(1) << index;
                valid = (groups[at].seen[side] & bit) == 0;
                groups[at].seen[side] |= bit;
                groups[at].samples[side][index] = sample;
                rows += 1;
            }
            else if (valid)
            {
                warmups += 1;
            }
        }
        if (input != NULL)
        {
            valid = !ferror(input) && fclose(input) == 0 && valid;
        }
    }
    valid = valid && rows == 1848 && warmups == 264 && count == 44;
    for (unsigned i = 0; valid && i < count; i += 1)
    {
        valid = groups[i].seen[0] == ((UINT32_C(1) << 21) - 1) && groups[i].seen[1] == ((UINT32_C(1) << 21) - 1);
    }
    if (valid)
    {
        puts("case\tN\tround\tbase_ms\thead_ms\twall_change_percent\tbase_system_us\thead_system_us\tbase_minor\thead_minor\tbase_rss_kb\thead_rss_kb");
    }
    for (unsigned i = 0; valid && i < count; i += 1)
    {
        for (unsigned round = 0; round < 4; round += 1)
        {
            const unsigned begin = round < 3 ? round * 7 : 0;
            const unsigned samples = round < 3 ? 7 : 21;
            const double base = (double)median(groups[i].samples[0], begin, samples, 0) / 1e6;
            const double head = (double)median(groups[i].samples[1], begin, samples, 0) / 1e6;
            printf("%s\t%" PRIu64 "\t%u\t%.6f\t%.6f\t%.3f", groups[i].mode, groups[i].size, round, base, head, (head / base - 1) * 100);
            for (unsigned field = 1; field < 4; field += 1)
            {
                printf("\t%" PRIu64 "\t%" PRIu64, median(groups[i].samples[0], begin, samples, field), median(groups[i].samples[1], begin, samples, field));
            }
            putchar('\n');
        }
    }
    free(line);
    fprintf(stderr, "receipts: %u timed rows, %u discarded warmups, %u cases, %s\n", rows, warmups, count, valid ? "valid" : "INVALID");
    return valid && !ferror(stdout) ? 0 : 1;
}
