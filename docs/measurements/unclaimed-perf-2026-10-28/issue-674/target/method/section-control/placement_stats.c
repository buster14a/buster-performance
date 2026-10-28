// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for placement_samples output. Cross-placement ranges deliberately pair no offsets.
#include <stdbool.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static double value(const char* line, const char* key)
{
    const char* found = strstr(line, key);
    return found != NULL ? strtod(found + strlen(key), NULL) : -1;
}

static double median(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double item = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > item)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = item;
    }
    return count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) * 0.5;
}

int main(int argc, char** argv)
{
    int result = argc != 4;
    double rates[3][6][2][3] = { 0 };
    bool seen[3][6][2][3] = { 0 };
    double major[3] = { 0 };
    unsigned expected_jobs = 0;
    double expected_tasks = 0;
    double expected_source = 0;
    unsigned predecessors[3][3][3] = { 0 };
    unsigned copy_predecessors[3][6][2][3] = { 0 };
    const unsigned shifts[6] = { 0, 688, 1376, 2064, 2752, 3440 };
    for (int input = 1; result == 0 && input < argc; input += 1)
    {
        FILE* file = fopen(argv[input], "r");
        if (file == NULL)
        {
            perror(argv[input]);
            result = 1;
        }
        else
        {
            char line[8192];
            unsigned pass = 0, index = 0, role = 0, shift = 0, copy = 0, jobs = 0;
            bool active = false;
            unsigned previous = 3;
            while (fgets(line, sizeof(line), file) != NULL)
            {
                if (sscanf(line, "prime pass=%u case=%u role=%u shift=%u copy=%u jobs=%u", &pass, &index, &role, &shift, &copy, &jobs) == 6)
                {
                    previous = role;
                }
                else if (sscanf(line, "matrix pass=%u case=%u role=%u shift=%u copy=%u jobs=%u", &pass, &index, &role, &shift, &copy, &jobs) == 6)
                {
                    active = true;
                }
                else if (line[0] == '{' && strstr(line, "\"MB_per_s\":") != NULL)
                {
                    result |= value(line, "\"failures\":") != 0;
                    if (active)
                    {
                        unsigned placement = 6;
                        for (unsigned p = 0; p < 6; p += 1)
                        {
                            placement = shifts[p] == shift ? p : placement;
                        }
                        const double rate = value(line, "\"MB_per_s\":");
                        const double tasks = value(line, "\"tasks\":");
                        const double source = value(line, "\"source_bytes\":");
                        const double faults = value(line, "\"major_faults\":");
                        if (expected_jobs == 0)
                        {
                            expected_jobs = jobs;
                            expected_tasks = tasks;
                            expected_source = source;
                        }
                        if (jobs == 0 || jobs > 8 || jobs != expected_jobs || value(line, "\"jobs\":") != jobs ||
                            !isfinite(tasks) || tasks < jobs || tasks != expected_tasks ||
                            !isfinite(source) || source <= 0 || source != expected_source ||
                            !isfinite(faults) || faults < 0 || !isfinite(rate) ||
                            pass >= 3 || role >= 3 || previous >= 3 || placement >= 6 || copy >= 2 || rate <= 0 ||
                            seen[role][placement][copy][pass])
                        {
                            result = 1;
                        }
                        else
                        {
                            rates[role][placement][copy][pass] = rate;
                            seen[role][placement][copy][pass] = true;
                            major[role] += faults;
                            predecessors[pass][previous][role] += 1;
                            copy_predecessors[role][placement][copy][previous] += 1;
                            previous = role;
                        }
                        active = false;
                    }
                }
                result |= strstr(line, "verified=0") != NULL || strstr(line, "equal=0") != NULL;
            }
            fclose(file);
        }
    }
    double overall[3] = { 0 };
    double placement_rates[3][6] = { 0 };
    double copy_rates[3][12] = { 0 };
    for (unsigned pass = 0; pass < 3; pass += 1)
    {
        for (unsigned before = 0; before < 3; before += 1)
        {
            for (unsigned role = 0; role < 3; role += 1)
            {
                result |= predecessors[pass][before][role] != 4;
            }
        }
    }
    for (unsigned role = 0; result == 0 && role < 3; role += 1)
    {
        double all[36];
        unsigned count = 0;
        for (unsigned p = 0; p < 6; p += 1)
        {
            double placement[6];
            unsigned n = 0;
            for (unsigned c = 0; c < 2; c += 1)
            {
                double copies[3];
                for (unsigned r = 0; r < 3; r += 1)
                {
                    result |= !seen[role][p][c][r];
                    result |= copy_predecessors[role][p][c][r] != 1;
                    copies[r] = rates[role][p][c][r];
                    placement[n++] = copies[r];
                    all[count++] = copies[r];
                }
                copy_rates[role][p * 2 + c] = median(copies, 3);
            }
            placement_rates[role][p] = median(placement, 6);
        }
        overall[role] = median(all, 36);
    }
    if (result == 0)
    {
        printf("cohort jobs=%u tasks=%.0f source_bytes=%.0f\n", expected_jobs, expected_tasks, expected_source);
        printf("order verified: each predecessor/current role pair occurs 4 times per pass; every role/placement/copy follows each predecessor once\n");
    }
    for (unsigned role = 0; result == 0 && role < 3; role += 1)
    {
        double smallest = placement_rates[role][0];
        double largest = smallest;
        double low = 1e30, high = -1e30;
        double copy_low = 1e30, copy_high = -1e30;
        double copy_spread = 0;
        for (unsigned p = 0; p < 6; p += 1)
        {
            const double rate = placement_rates[role][p];
            smallest = rate < smallest ? rate : smallest;
            largest = rate > largest ? rate : largest;
            const double x = copy_rates[role][p * 2];
            const double y = copy_rates[role][p * 2 + 1];
            const double spread = 100.0 * ((x > y ? x / y : y / x) - 1.0);
            copy_spread = spread > copy_spread ? spread : copy_spread;
            for (unsigned b = 0; b < 6; b += 1)
            {
                const double change = 100.0 * (rate / placement_rates[0][b] - 1.0);
                low = change < low ? change : low;
                high = change > high ? change : high;
            }
        }
        for (unsigned c = 0; c < 12; c += 1)
        {
            for (unsigned b = 0; b < 12; b += 1)
            {
                const double change = 100.0 * (copy_rates[role][c] / copy_rates[0][b] - 1.0);
                copy_low = change < copy_low ? change : copy_low;
                copy_high = change > copy_high ? change : copy_high;
            }
        }
        printf("role=%u n=36 median=%.6f MB/s against-base=%+.4f%% placement-spread=%.4f%% max-copy-spread=%.4f%% over-placements=[%+.4f%%,%+.4f%%] over-copies=[%+.4f%%,%+.4f%%] major=%.0f placements=",
               role, overall[role], 100.0 * (overall[role] / overall[0] - 1.0), 100.0 * (largest / smallest - 1.0),
               copy_spread, low, high, copy_low, copy_high, major[role]);
        for (unsigned p = 0; p < 6; p += 1)
        {
            printf("%s%u:%.6f", p != 0 ? "," : "", shifts[p], placement_rates[role][p]);
        }
        putchar('\n');
    }
    return result;
}
