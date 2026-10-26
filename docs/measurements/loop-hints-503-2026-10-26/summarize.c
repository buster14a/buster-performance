// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Summarize successful-process CSV files from measure.c without discarding rows.
#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static bool summarize(const char* path)
{
    FILE* file = fopen(path, "rb");
    char line[512];
    bool valid = file != NULL && fgets(line, sizeof(line), file) != NULL;
    double walls[2][12] = { 0 };
    double blocks[6][2] = { 0 };
    long rss_min[2] = { LONG_MAX, LONG_MAX };
    long rss_max[2] = { 0 };
    unsigned counts[2] = { 0 };
    bool seen[6][4] = { 0 };
    unsigned rows = 0;
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        unsigned block = 0;
        unsigned slot = 0;
        char name[16];
        unsigned long long wall = 0;
        long long user = 0;
        long long system = 0;
        long rss = 0;
        valid = sscanf(line, "%u,%u,%15[^,],%llu,%lld,%lld,%ld", &block, &slot, name, &wall, &user, &system, &rss) == 7 &&
                block < 6 && slot < 4 && wall != 0 && rss > 0 && (strcmp(name, "base") == 0 || strcmp(name, "head") == 0);
        const unsigned tree = valid && strcmp(name, "head") == 0;
        valid = valid && !seen[block][slot] && counts[tree] < 12;
        if (valid)
        {
            seen[block][slot] = true;
            walls[tree][counts[tree]++] = wall;
            blocks[block][tree] += wall;
            rss_min[tree] = rss < rss_min[tree] ? rss : rss_min[tree];
            rss_max[tree] = rss > rss_max[tree] ? rss : rss_max[tree];
            rows += 1;
        }
    }
    if (file != NULL)
    {
        valid = !ferror(file) && fclose(file) == 0 && valid;
    }
    valid = valid && rows == 24 && counts[0] == 12 && counts[1] == 12;
    double ratios[6] = { 0 };
    double sum = 0;
    for (unsigned block = 0; valid && block < 6; block += 1)
    {
        valid = blocks[block][0] > 0 && blocks[block][1] > 0;
        ratios[block] = valid ? (blocks[block][1] / blocks[block][0] - 1) * 100 : 0;
        sum += ratios[block];
    }
    for (unsigned tree = 0; valid && tree < 2; tree += 1)
    {
        for (unsigned i = 1; i < 12; i += 1)
        {
            unsigned at = i;
            const double value = walls[tree][i];
            while (at != 0 && walls[tree][at - 1] > value)
            {
                walls[tree][at] = walls[tree][at - 1];
                at -= 1;
            }
            walls[tree][at] = value;
        }
    }
    if (valid)
    {
        const double mean = sum / 6;
        double squares = 0;
        for (unsigned block = 0; block < 6; block += 1)
        {
            squares += (ratios[block] - mean) * (ratios[block] - mean);
        }
        const double interval = 2.571 * sqrt(squares / 30);
        const char* name = strrchr(path, '/');
        printf("| %s | %.3f | %.3f | %+.3f [%.3f, %.3f] | %ld–%ld / %ld–%ld |\n", name != NULL ? name + 1 : path,
               (walls[0][5] + walls[0][6]) / 2000000, (walls[1][5] + walls[1][6]) / 2000000,
               mean, mean - interval, mean + interval, rss_min[0], rss_max[0], rss_min[1], rss_max[1]);
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc > 1;
    puts("| Input/path | Parent median ms | Candidate median ms | Paired wall % [t95] | Peak RSS KiB, parent / candidate |\n"
         "|---|---:|---:|---:|---|");
    for (int i = 1; valid && i < argc; i += 1)
    {
        valid = summarize(argv[i]);
    }
    return valid ? 0 : 1;
}
