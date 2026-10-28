// Original strict validator/summary for the approved one-placement, two-copy time-runs screen.
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Row Row;
struct Row { double wall, cpu, rss, minor, major, cycles, instructions; };

static double median(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double value = values[i];
        unsigned at = i;
        while (at != 0 && values[at - 1] > value) { values[at] = values[at - 1]; at -= 1; }
        values[at] = value;
    }
    return count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

int main(int argc, char** argv)
{
    if (argc != 2) return 2;
    FILE* file = fopen(argv[1], "r");
    if (file == NULL) return 2;
    Row rows[11][3][2] = { 0 };
    bool seen[11][3][2] = { 0 };
    char line[8192];
    unsigned lines = 0;
    bool done = false, missing_counters = false;
    while (fgets(line, sizeof(line), file) != NULL)
    {
        if (strstr(line, "user cycles weren't counted") != NULL) missing_counters = true;
        if (strcmp(line, "time-runs: done, 0 failed processes\n") == 0) done = true;
        if (strncmp(line, "run ", 4) != 0) continue;
        unsigned run = 0, list = 0, copy = 0;
        int status = -1;
        char name[32] = { 0 };
        double wall = 0, user = 0, system = 0;
        unsigned long long rss = 0, minor = 0, major = 0, cycles = 0, instructions = 0;
        const int fields = sscanf(line, "run %u list %u %31s copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d",
                                  &run, &list, name, &copy, &wall, &user, &system, &rss, &minor, &major, &cycles, &instructions, &status);
        const unsigned role = strcmp(name, "base") == 0 ? 0 : strcmp(name, "head") == 0 ? 1 : strcmp(name, "base-again") == 0 ? 2 : 3;
        if (fields != 13 || run == 0 || run > 11 || list != 1 || role > 2 || copy == 0 || copy > 2 || status != 0 ||
            !isfinite(wall) || wall <= 0 || !isfinite(user) || user < 0 || !isfinite(system) || system < 0 ||
            rss == 0 || cycles == 0 || instructions == 0 || seen[run - 1][role][copy - 1]) return 2;
        seen[run - 1][role][copy - 1] = true;
        rows[run - 1][role][copy - 1] = (Row){wall, user + system, (double)rss, (double)minor, (double)major, (double)cycles, (double)instructions};
        lines += 1;
    }
    if (ferror(file) || fclose(file) != 0 || lines != 66 || !done || missing_counters) return 2;
    const char* names[3] = { "base", "head", "base-again" };
    const char* fields[7] = { "wall_ms", "CPU_ms", "RSS_KiB", "minor_faults", "major_faults", "user_cycles", "instructions" };
    for (unsigned field = 0; field < 7; field += 1)
    {
        double medians[3] = { 0 };
        double paired[2][22];
        for (unsigned role = 0; role < 3; role += 1)
        {
            double values[22];
            double sum = 0;
            for (unsigned run = 0; run < 11; run += 1)
            {
                for (unsigned copy = 0; copy < 2; copy += 1)
                {
                    const Row* row = &rows[run][role][copy];
                    const double members[7] = { row->wall, row->cpu, row->rss, row->minor, row->major, row->cycles, row->instructions };
                    values[run * 2 + copy] = members[field];
                    sum += members[field];
                }
            }
            medians[role] = median(values, 22);
            printf("field=%s role=%s n=22 median=%.6f range=%.6f..%.6f sum=%.0f\n", fields[field], names[role], medians[role], values[0], values[21], sum);
        }
        if (field == 0 || field == 1 || field == 5 || field == 6)
        {
            for (unsigned run = 0; run < 11; run += 1)
            {
                for (unsigned copy = 0; copy < 2; copy += 1)
                {
                    for (unsigned role = 1; role < 3; role += 1)
                    {
                        const Row* base = &rows[run][0][copy];
                        const Row* other = &rows[run][role][copy];
                        const double a = field == 0 ? base->wall : field == 1 ? base->cpu : field == 5 ? base->cycles : base->instructions;
                        const double b = field == 0 ? other->wall : field == 1 ? other->cpu : field == 5 ? other->cycles : other->instructions;
                        paired[role - 1][run * 2 + copy] = b / a;
                    }
                }
            }
            printf("field=%s head_over_base_medians=%.9f AA_over_base_medians=%.9f paired_head_ratio_median=%.9f paired_AA_ratio_median=%.9f\n",
                   fields[field], medians[1] / medians[0], medians[2] / medians[0], median(paired[0], 22), median(paired[1], 22));
        }
    }
    puts("validated: 66/66 measured statuses0, cycles+instructions present, no automatic major-fault exclusion");
    return 0;
}
