// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original seven-round paired whole-process reader. Round 0 is a declared warmup, retained and validated.
#define main unused_sample_reader_main
#include "summarize.c"
#undef main

typedef struct Unit
{
    char name[128];
    unsigned group;
    unsigned tokens;
    double wall[2][8];
    double rss[2][8];
    bool present[2][8];
} Unit;

int main(int argc, char** argv)
{
    static const char* groups[] = { "under300", "middle", "atleast3000", "all" };
    Unit* units = calloc(512, sizeof(Unit));
    FILE* input = argc == 2 ? fopen(argv[1], "r") : NULL;
    int result = units != NULL && input != NULL ? 0 : 2;
    unsigned count = 0;
    unsigned records = 0;
    char line[4096];
    while (result == 0 && fgets(line, sizeof(line), input) != NULL)
    {
        if (strncmp(line, "round", 5) == 0) continue;
        unsigned r, v, tokens;
        char name[128], bin[32];
        unsigned long long wall, user, system;
        long rss, minor, major;
        int status;
        long long bytes;
        const int read = sscanf(line, "%u %u %127s %u %31s %llu %llu %llu %ld %ld %ld %d %lld", &r, &v, name, &tokens, bin,
                                &wall, &user, &system, &rss, &minor, &major, &status, &bytes);
        result = read == 13 && r < 8 && v < 2 && status == 0 && bytes > 0 && wall > 0 && rss > 0 ? 0 : 2;
        if (result == 0)
        {
            unsigned at = 0;
            while (at < count && strcmp(units[at].name, name) != 0) at += 1;
            if (at == count && count < 512)
            {
                snprintf(units[at].name, sizeof(units[at].name), "%s", name);
                units[at].tokens = tokens;
                units[at].group = tokens < 300 ? 0 : tokens >= 3000 ? 2 : 1;
                count += 1;
            }
            result = at < count && strcmp(bin, groups[units[at].group]) == 0 && units[at].tokens == tokens && !units[at].present[v][r] ? 0 : 2;
            if (result == 0)
            {
                units[at].wall[v][r] = (double)wall / 1000000;
                units[at].rss[v][r] = (double)rss;
                units[at].present[v][r] = true;
                records += 1;
            }
        }
    }
    if (input != NULL) fclose(input);
    for (unsigned i = 0; result == 0 && i < count; i += 1)
    {
        for (unsigned v = 0; v < 2; v += 1)
        {
            for (unsigned r = 0; r < 8; r += 1) result = units[i].present[v][r] ? result : 2;
        }
    }
    result = count == 220 && records == 3520 ? result : 2;
    if (result == 0)
    {
        printf("bin\tfiles\tbase_sum_unit_median_ms\thead_sum_unit_median_ms\thead_cost_change_percent\tbase_unit_peakRSS_median_KiB\thead_unit_peakRSS_median_KiB\tbase_peakRSS_max_KiB\thead_peakRSS_max_KiB\tpaired_round_sum_ratio_median\n");
        for (unsigned group = 0; group < 4; group += 1)
        {
            unsigned files = 0;
            double total[2] = { 0 };
            double maxrss[2] = { 0 };
            double unitrss[2][512];
            double rounds[2][7] = { { 0 } };
            for (unsigned i = 0; i < count; i += 1)
            {
                if (group == 3 || units[i].group == group)
                {
                    for (unsigned v = 0; v < 2; v += 1)
                    {
                        double times[7], rss[7];
                        for (unsigned r = 1; r < 8; r += 1)
                        {
                            times[r - 1] = units[i].wall[v][r];
                            rss[r - 1] = units[i].rss[v][r];
                            rounds[v][r - 1] += times[r - 1];
                            maxrss[v] = rss[r - 1] > maxrss[v] ? rss[r - 1] : maxrss[v];
                        }
                        total[v] += median(times, 7);
                        unitrss[v][files] = median(rss, 7);
                    }
                    files += 1;
                }
            }
            double ratios[7];
            for (unsigned r = 0; r < 7; r += 1) ratios[r] = rounds[1][r] / rounds[0][r];
            printf("%s\t%u\t%.6f\t%.6f\t%.6f\t%.0f\t%.0f\t%.0f\t%.0f\t%.9f\n", groups[group], files, total[0], total[1],
                   (total[1] / total[0] - 1) * 100, median(unitrss[0], files), median(unitrss[1], files), maxrss[0], maxrss[1], median(ratios, 7));
        }
    }
    else
    {
        fprintf(stderr, "small-summary: incomplete or failed 220-unit eight-round record\n");
    }
    free(units);
    return result;
}
