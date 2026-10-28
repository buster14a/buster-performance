// Original strict validator for one three-run, six-placement, three-copy A/B/A-again cohort.
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
typedef struct Row Row;
struct Row { double field[7]; };
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
    Row rows[3][3][6][3] = { 0 };
    bool seen[3][3][6][3] = { 0 };
    char line[8192];
    unsigned lines = 0;
    bool done = false, missing = false;
    while (fgets(line, sizeof(line), file) != NULL)
    {
        if (strstr(line, "user cycles weren't counted") != NULL) missing = true;
        if (strcmp(line, "time-runs: done, 0 failed processes\n") == 0) done = true;
        if (strncmp(line, "run ", 4) != 0) continue;
        unsigned run = 0, list = 0, placement = 0, copy = 0;
        int status = -1;
        char role_name[32] = { 0 };
        double wall = 0, user = 0, system = 0;
        unsigned long long rss = 0, minor = 0, major = 0, cycles = 0, instructions = 0;
        const int fields = sscanf(line, "run %u list %u %31s placement %u copy %u: %lf ms wall, %lf ms user, %lf ms system, %llu KB peak, %llu minor faults, %llu major, %llu user cycles, %llu instructions, status %d",
            &run, &list, role_name, &placement, &copy, &wall, &user, &system, &rss, &minor, &major, &cycles, &instructions, &status);
        const unsigned role = strcmp(role_name, "base") == 0 ? 0 : strcmp(role_name, "head") == 0 ? 1 : strcmp(role_name, "base-again") == 0 ? 2 : 3;
        if (fields != 14 || run < 1 || run > 3 || list != 1 || placement < 1 || placement > 6 || copy < 1 || copy > 3 || role > 2 ||
            status != 0 || !isfinite(wall) || wall <= 0 || !isfinite(user) || user < 0 || !isfinite(system) || system < 0 ||
            rss == 0 || cycles == 0 || instructions == 0 || seen[run - 1][role][placement - 1][copy - 1]) return 2;
        seen[run - 1][role][placement - 1][copy - 1] = true;
        rows[run - 1][role][placement - 1][copy - 1] = (Row){{wall, user + system, (double)rss, (double)minor, (double)major, (double)cycles, (double)instructions}};
        lines += 1;
    }
    if (ferror(file) || fclose(file) != 0 || lines != 162 || !done || missing) return 2;
    const char* names[3] = { "base", "head", "base-again" };
    const char* metrics[7] = { "wall_ms", "CPU_ms", "RSS_KiB", "minor_faults", "major_faults", "user_cycles", "instructions" };
    for (unsigned field = 0; field < 7; field += 1)
    {
        double role_medians[3], placements[3][6];
        for (unsigned role = 0; role < 3; role += 1)
        {
            double values[54];
            double sum = 0;
            for (unsigned placement = 0; placement < 6; placement += 1)
            {
                double one[9];
                for (unsigned run = 0; run < 3; run += 1)
                {
                    for (unsigned copy = 0; copy < 3; copy += 1)
                    {
                        const double value = rows[run][role][placement][copy].field[field];
                        one[run * 3 + copy] = value;
                        values[placement * 9 + run * 3 + copy] = value;
                        sum += value;
                    }
                }
                placements[role][placement] = median(one, 9);
                printf("field=%s role=%s placement=%u n=9 median=%.6f range=%.6f..%.6f\n", metrics[field], names[role], placement + 1,
                       placements[role][placement], one[0], one[8]);
            }
            role_medians[role] = median(values, 54);
            printf("field=%s role=%s pooled_n=54 median=%.6f range=%.6f..%.6f sum=%.0f\n", metrics[field], names[role], role_medians[role], values[0], values[53], sum);
        }
        if (field == 0 || field == 1 || field == 5 || field == 6)
        {
            double ranges[2][36];
            for (unsigned role = 1; role < 3; role += 1)
                for (unsigned a = 0; a < 6; a += 1)
                    for (unsigned b = 0; b < 6; b += 1) ranges[role - 1][a * 6 + b] = placements[role][a] / placements[0][b];
            median(ranges[0], 36); median(ranges[1], 36);
            printf("field=%s head_over_base_pooled=%.9f AA_over_base_pooled=%.9f cross_placement_head_range=%.9f..%.9f cross_placement_AA_range=%.9f..%.9f\n",
                   metrics[field], role_medians[1] / role_medians[0], role_medians[2] / role_medians[0], ranges[0][0], ranges[0][35], ranges[1][0], ranges[1][35]);
        }
    }
    puts("validated: 162/162 unique measured statuses0 with full counters; all six placements and all copies retained; no major-fault exclusion");
    return 0;
}
