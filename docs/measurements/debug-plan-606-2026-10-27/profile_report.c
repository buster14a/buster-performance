// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Verify traversal counters and summarize measured (non-warm-up) -g attribution logs.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static double values[3][2][8][100];
static unsigned counts[3][2];
static unsigned functions[3], rows[3], raw_rows[3];
static const char* const names[] = { "sqlite", "lines", "small" };

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

int main(int argc, char** argv)
{
    int result = 0;
    for (int arg = 1; arg < argc; arg += 1)
    {
        FILE* file = fopen(argv[arg], "r");
        unsigned workload = 3;
        for (unsigned name = 0; name < 3; name += 1)
        {
            workload = strstr(argv[arg], names[name]) != NULL ? name : workload;
        }
        bool seen = false;
        unsigned variant = 0, sample = 0;
        double stages[3] = { 0 };
        char line[2048];
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            char flow[16], stage[64];
            unsigned f, r, raw;
            unsigned long long t[10];
            double ms;
            if (sscanf(line, "profile-606 %15s %u %u %u %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu", flow, &f, &r, &raw,
                       &t[0], &t[1], &t[2], &t[3], &t[4], &t[5], &t[6], &t[7], &t[8], &t[9]) == 14)
            {
                variant = strcmp(flow, "old") == 0 ? 0 : 1;
                const unsigned expected = variant == 0 ? 2 : 1;
                const bool valid = workload < 3 && !seen && t[1] == expected && t[2] == (uint64_t)r * expected &&
                                   t[4] == expected && t[5] == (uint64_t)r * expected && t[7] == 1 && t[8] == r &&
                                   (functions[workload] == 0 || (functions[workload] == f && rows[workload] == r && raw_rows[workload] == raw));
                result |= !valid;
                if (valid)
                {
                    sample = counts[workload][variant]++;
                    result |= sample >= 100;
                    if (sample < 100)
                    {
                        functions[workload] = f;
                        rows[workload] = r;
                        raw_rows[workload] = raw;
                        values[workload][variant][0][sample] = t[0] / 1e6;
                        values[workload][variant][1][sample] = t[3] / 1e6;
                        values[workload][variant][2][sample] = t[6] / 1e6;
                        values[workload][variant][3][sample] = t[9] / 1e6;
                        values[workload][variant][4][sample] = (t[0] - t[3] - t[6] - t[9]) / 1e6;
                    }
                }
                seen = valid;
            }
            else if (sscanf(line, "time-stage %63s %lf", stage, &ms) == 2)
            {
                if (strcmp(stage, "debug") == 0) { stages[0] = ms; }
                if (strcmp(stage, "object-build") == 0) { stages[1] = ms; }
                if (strcmp(stage, "object-write") == 0) { stages[2] = ms; }
            }
        }
        if (seen && sample < 100)
        {
            for (unsigned stage = 0; stage < 3; stage += 1)
            {
                values[workload][variant][5 + stage][sample] = stages[stage];
            }
        }
        result |= !seen;
        if (file != NULL) { fclose(file); }
    }
    for (unsigned workload = 0; workload < 3; workload += 1)
    {
        for (unsigned variant = 0; variant < 2; variant += 1)
        {
            const unsigned count = counts[workload][variant];
            if (count != 0 && count <= 100)
            {
                printf("%s %s samples=%u functions=%u rows=%u raw=%u ms[whole,validate,size,write,residual,debug-stage,object-build,object-write]", names[workload],
                       variant == 0 ? "old" : "new", count, functions[workload], rows[workload], raw_rows[workload]);
                for (unsigned metric = 0; metric < 8; metric += 1)
                {
                    double* set = values[workload][variant][metric];
                    qsort(set, count, sizeof(*set), compare);
                    printf(" %.6f", (set[(count - 1) / 2] + set[count / 2]) / 2);
                }
                puts("");
            }
        }
    }
    return result;
}
