// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original independent reader: reject incomplete, reordered, failed or nonfinite samples; retain all faults.
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Sample Sample;
struct Sample
{
    double wall;
    double rss;
    double minor;
    double lower;
    double tier0;
    double backend;
};

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return count & 1 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) * .5;
}

static bool phases(const char* table, unsigned index, unsigned role, Sample* sample)
{
    char path[4096];
    snprintf(path, sizeof(path), "%s", table);
    char* slash = strrchr(path, '/');
    bool valid = slash != NULL;
    FILE* file = NULL;
    if (valid)
    {
        snprintf(slash + 1, sizeof(path) - (size_t)(slash + 1 - path), "r%04u-role%u.log", index, role);
        file = fopen(path, "r");
        valid = file != NULL;
    }
    const char* included[] = { "backend-setup", "lower", "tier0", "emit-setup", "branch-sizing", "encode", "unwind", "code-atoms", "debug" };
    unsigned seen = 0;
    char line[8192];
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        char stage[128];
        double ms = 0;
        if (sscanf(line, "time-stage %127s %lf", stage, &ms) == 2)
        {
            valid = isfinite(ms) && ms >= 0;
            for (unsigned i = 0; valid && i < sizeof(included) / sizeof(*included); i += 1)
            {
                if (strcmp(stage, included[i]) == 0)
                {
                    valid = (seen & (1u << i)) == 0;
                    seen |= 1u << i;
                    sample->backend += ms;
                    sample->lower = i == 1 ? ms : sample->lower;
                    sample->tier0 = i == 2 ? ms : sample->tier0;
                }
            }
        }
    }
    if (file != NULL)
    {
        valid &= !ferror(file);
        fclose(file);
    }
    return valid && seen == (1u << (sizeof(included) / sizeof(*included))) - 1;
}

int main(int argc, char** argv)
{
    int result = argc > 1 ? 0 : 1;
    printf("file samples_per_role wall_base_ms wall_head_ms delta_percent rss_base_kib rss_head_kib minor_base minor_head major_base major_head lower_base_ms lower_head_ms tier0_base_ms tier0_head_ms lower_backend_base_ms lower_backend_head_ms\n");
    for (int input = 1; result == 0 && input < argc; input += 1)
    {
        FILE* file = fopen(argv[input], "r");
        bool valid = file != NULL;
        bool timed = false;
        bool ended = false;
        unsigned rows = 0;
        unsigned expected_cycles = 0;
        unsigned previous = 0;
        unsigned counts[2] = { 0 };
        unsigned pairs[2][2] = { 0 };
        unsigned long long major[2] = { 0 };
        Sample samples[2][200] = { 0 };
        double previous_end = 0;
        char line[16384];
        while (valid && fgets(line, sizeof(line), file) != NULL)
        {
            if (line[0] == '#')
            {
                timed |= strstr(line, "--time-stages") != NULL;
                if (strncmp(line, "# cycles ", 9) == 0)
                {
                    unsigned cycles = 0;
                    char extra;
                    valid = expected_cycles == 0 && sscanf(line, "# cycles %u %c", &cycles, &extra) == 1 && cycles > 0 && cycles <= 100;
                    expected_cycles = cycles;
                }
                if (strcmp(line, "# status 0\n") == 0)
                {
                    valid = !ended;
                    ended = true;
                }
            }
            else
            {
                unsigned index, warm, role, predecessor;
                double start, end, wall, user, system, rss, minor, faults;
                int status;
                long long bytes;
                char extra;
                const int fields = sscanf(line, "%u %u %u %u %lf %lf %lf %lf %lf %lf %lf %lf %d %lld %c", &index, &warm, &role, &predecessor,
                                          &start, &end, &wall, &user, &system, &rss, &minor, &faults, &status, &bytes, &extra);
                const unsigned order[4] = { 0, 1, 1, 0 };
                const unsigned primers[3] = { 0, 1, 0 };
                valid = fields == 14 && !ended && index == rows && warm == (rows < 3) && role < 2 &&
                        role == (rows < 3 ? primers[rows] : order[(rows - 3) % 4]) && predecessor == previous &&
                        isfinite(start) && isfinite(end) && start >= previous_end && end >= start &&
                        isfinite(wall) && wall > 0 && isfinite(user) && user >= 0 && isfinite(system) && system >= 0 &&
                        isfinite(rss) && rss >= 0 && isfinite(minor) && minor >= 0 && isfinite(faults) && faults >= 0 && status == 0 && bytes > 0;
                if (valid && !warm)
                {
                    valid = counts[role] < 200;
                    if (valid)
                    {
                        Sample* sample = &samples[role][counts[role]++];
                        *sample = (Sample){ .wall = wall, .rss = rss, .minor = minor };
                        pairs[predecessor][role] += 1;
                        major[role] += (unsigned long long)faults;
                        valid = !timed || phases(argv[input], index, role, sample);
                    }
                }
                if (valid)
                {
                    previous = role;
                    previous_end = end;
                }
                rows += 1;
            }
        }
        if (file != NULL)
        {
            valid &= !ferror(file);
            fclose(file);
        }
        valid &= ended && expected_cycles > 0 && rows == 3 + expected_cycles * 4 && counts[0] == expected_cycles * 2 && counts[1] == expected_cycles * 2 &&
                 pairs[0][0] == pairs[0][1] && pairs[0][0] == pairs[1][0] && pairs[0][0] == pairs[1][1];
        if (!valid)
        {
            fprintf(stderr, "invalid or incomplete measurement: %s rows=%u\n", argv[input], rows);
            result = 1;
        }
        else
        {
            double values[2][6];
            for (unsigned role = 0; role < 2; role += 1)
            {
                double fields[6][200];
                for (unsigned i = 0; i < counts[role]; i += 1)
                {
                    fields[0][i] = samples[role][i].wall;
                    fields[1][i] = samples[role][i].rss;
                    fields[2][i] = samples[role][i].minor;
                    fields[3][i] = samples[role][i].lower;
                    fields[4][i] = samples[role][i].tier0;
                    fields[5][i] = samples[role][i].backend;
                }
                for (unsigned field = 0; field < 6; field += 1)
                {
                    values[role][field] = median(fields[field], counts[role]);
                }
            }
            printf("%s %u %.6f %.6f %.6f %.0f %.0f %.0f %.0f %llu %llu %.6f %.6f %.6f %.6f %.6f %.6f\n", argv[input], counts[0], values[0][0], values[1][0],
                   (values[1][0] / values[0][0] - 1) * 100, values[0][1], values[1][1], values[0][2], values[1][2], major[0], major[1],
                   values[0][3], values[1][3], values[0][4], values[1][4], values[0][5], values[1][5]);
        }
    }
    return result;
}
