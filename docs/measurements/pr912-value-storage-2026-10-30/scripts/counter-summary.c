/* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 * Copyright (c) 2026 David Gonzalez Martin.
 * Require the complete eleven-round grid and four unique numeric fully
 * scheduled events in every CSV before summarizing the phase subtraction.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(const double* source)
{
    double values[11];
    memcpy(values, source, sizeof(values));
    qsort(values, 11, sizeof(values[0]), compare_double);
    return values[5];
}

int main(int argc, char** argv)
{
    const char* variants[] = { "base", "candidate" };
    const char* modes[] = { "preprocess", "syntax", "compile" };
    const char* events[] = { "instructions:u", "cycles:u", "ex_ret_ucode_ops:u", "ex_ret_ucode_instr:u" };
    double observations[11][2][3][4] = { 0 };
    int valid = argc == 2;
    for (int round = 0; valid && round < 11; round += 1)
    {
        for (int variant = 0; valid && variant < 2; variant += 1)
        {
            for (int mode = 0; valid && mode < 3; mode += 1)
            {
                char path[4096];
                const int bytes = snprintf(path, sizeof(path), "%s/counters-%d-%s-%s.csv", argv[1], round + 1, variants[variant], modes[mode]);
                FILE* input = bytes > 0 && (size_t)bytes < sizeof(path) ? fopen(path, "r") : NULL;
                unsigned seen = 0;
                unsigned long long duration = 0;
                char line[4096];
                while (input != NULL && fgets(line, sizeof(line), input) != NULL && valid)
                {
                    if (line[0] != '#' && line[0] != '\n' && line[0] != '\r')
                    {
                        unsigned long long value = 0;
                        unsigned long long runtime = 0;
                        double scheduled = 0;
                        char event[64];
                        const int fields = sscanf(line, "%llu,,%63[^,],%llu,%lf", &value, event, &runtime, &scheduled);
                        int index = -1;
                        for (int e = 0; fields == 4 && e < 4; e += 1)
                        {
                            if (strcmp(event, events[e]) == 0) { index = e; }
                        }
                        valid = fields == 4 && index >= 0 && value > 0 && value < 9000000000000000ull && runtime > 0 && runtime < 1000000000000000ull && isfinite(scheduled) && scheduled == 100.0;
                        if (valid)
                        {
                            valid = (seen & (1u << index)) == 0 && (duration == 0 || duration == runtime);
                            duration = runtime;
                            seen |= 1u << index;
                            observations[round][variant][mode][index] = (double)value;
                        }
                    }
                }
                valid = valid && input != NULL && !ferror(input) && seen == 15;
                if (input != NULL) { fclose(input); }
                if (!valid) { fprintf(stderr, "invalid/missing/incomplete/unavailable/multiplexed counter file: %s\n", path); }
            }
        }
    }
    if (valid)
    {
        double rates[2][11];
        for (int variant = 0; variant < 2; variant += 1)
        {
            for (int round = 0; round < 11; round += 1)
            {
                const double instructions = observations[round][variant][1][0] - observations[round][variant][0][0];
                const double ops = observations[round][variant][1][2] - observations[round][variant][0][2];
                valid = valid && instructions > 0 && ops >= 0;
                rates[variant][round] = instructions > 0 ? 1000.0 * ops / instructions : 0;
                printf("check-phase round=%d variant=%s instructions=%.0f ucode_ops=%.0f ucode_ops_per_1000_instructions=%.9f\n", round + 1, variants[variant], instructions, ops, rates[variant][round]);
            }
        }
        if (valid)
        {
            const double base = median(rates[0]);
            const double candidate = median(rates[1]);
            valid = base > 0;
            printf("%s complete_grid=66 files events_per_file=4 scheduling=100.00_percent_at_perf_CSV_precision\n", valid ? "PASS" : "FAIL");
            printf("check-phase median base=%.9f candidate=%.9f reduction_percent=%.6f\n", base, candidate, base > 0 ? 100.0 * (base - candidate) / base : 0);
            for (int variant = 0; variant < 2; variant += 1)
            {
                for (int mode = 0; mode < 3; mode += 1)
                {
                    for (int event = 0; event < 4; event += 1)
                    {
                        double values[11];
                        for (int round = 0; round < 11; round += 1) { values[round] = observations[round][variant][mode][event]; }
                        printf("median variant=%s mode=%s event=%s value=%.0f\n", variants[variant], modes[mode], events[event], median(values));
                    }
                }
            }
        }
    }
    return valid ? 0 : 1;
}
