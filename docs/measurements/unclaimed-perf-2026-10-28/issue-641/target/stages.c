// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded stage reader. Sums are formed per process before taking medians.
#define main unused_sample_reader_main
#include "summarize.c"
#undef main

int main(int argc, char** argv)
{
    static const char* names[] = { "check-input", "check-expressions", "check-declarations", "static-data", "check-program", "select", "emit-setup", "lower", "total" };
    double values[2][11][7] = { 0 };
    int result = argc == 2 ? 0 : 2;
    for (unsigned role = 0; result == 0 && role < 2; role += 1)
    {
        for (unsigned round = 0; result == 0 && round < 7; round += 1)
        {
            char path[4096];
            snprintf(path, sizeof(path), "%s/r%03u-role%u/stderr-0000.txt", argv[1], round, role);
            FILE* input = fopen(path, "r");
            result = input != NULL ? 0 : 2;
            unsigned found = 0;
            char line[4096];
            while (result == 0 && fgets(line, sizeof(line), input) != NULL)
            {
                char name[64];
                double ms = 0;
                if (sscanf(line, "time-stage\t%63s\t%lf", name, &ms) == 2)
                {
                    for (unsigned stage = 0; stage < 9; stage += 1)
                    {
                        if (strcmp(name, names[stage]) == 0)
                        {
                            values[role][stage][round] = ms;
                            found |= 1u << stage;
                        }
                    }
                }
            }
            if (input != NULL) fclose(input);
            result = found == 511 ? result : 2;
            for (unsigned stage = 0; stage < 8; stage += 1)
            {
                values[role][9][round] += stage >= 2 ? values[role][stage][round] : 0;
                values[role][10][round] += values[role][stage][round];
            }
        }
    }
    if (result == 0)
    {
        printf("stage\tbase_median_ms\thead_median_ms\thead_cost_change_percent\tpaired_head_over_base_median\n");
        for (unsigned stage = 0; stage < 11; stage += 1)
        {
            double ratios[7];
            double a[7], b[7];
            for (unsigned round = 0; round < 7; round += 1)
            {
                a[round] = values[0][stage][round];
                b[round] = values[1][stage][round];
                ratios[round] = b[round] / a[round];
            }
            const double before = median(a, 7);
            const double after = median(b, 7);
            printf("%s\t%.6f\t%.6f\t%.6f\t%.9f\n", stage < 9 ? names[stage] : stage == 9 ? "post-check-through-lower-sum" : "warning-producers-through-lower-sum",
                   before, after, (after / before - 1) * 100, median(ratios, 7));
        }
    }
    else
    {
        fprintf(stderr, "stages: incomplete seven-round stage receipts\n");
    }
    return result;
}
