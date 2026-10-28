// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded reader for this campaign's cohort JSON records and rotated sample labels.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Sample
{
    double wall;
    double throughput;
    double user;
    double system;
    double rss;
    double minor;
    double major;
    unsigned tasks;
    bool present;
} Sample;

static double field(const char* text, const char* key)
{
    char pattern[80];
    snprintf(pattern, sizeof(pattern), "\"%s\":", key);
    const char* found = strstr(text, pattern);
    return found != NULL ? strtod(found + strlen(pattern), NULL) : -1;
}

static double median(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double value = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
    return count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

int main(int argc, char** argv)
{
    int result = argc == 2 ? 0 : 2;
    FILE* input = result == 0 ? fopen(argv[1], "r") : NULL;
    result = input != NULL ? result : 2;
    Sample samples[2][101] = { 0 };
    unsigned round = 101;
    unsigned role = 2;
    unsigned rounds = 0;
    char line[4096];
    while (result == 0 && fgets(line, sizeof(line), input) != NULL)
    {
        unsigned next_round = 0;
        unsigned next_role = 0;
        if (sscanf(line, "sample round=%u role=%u", &next_round, &next_role) == 2)
        {
            round = next_round;
            role = next_role;
            result = round < 101 && role < 2 ? 0 : 2;
        }
        else if (line[0] == '{')
        {
            const double tasks = field(line, "tasks");
            result = round < 101 && role < 2 && tasks > 0 && field(line, "failures") == 0 ? 0 : 2;
            if (result == 0)
            {
                Sample* sample = &samples[role][round];
                result = sample->present ? 2 : 0;
                *sample = (Sample){ field(line, "wall_s"), field(line, "MB_per_s"), field(line, "user_s"), field(line, "system_s"),
                                    field(line, "maxrss_kb"), field(line, "minor_faults"), field(line, "major_faults"), (unsigned)tasks, true };
                result = sample->wall > 0 && sample->throughput > 0 && sample->rss > 0 && sample->major >= 0 ? result : 2;
                rounds = round + 1 > rounds ? round + 1 : rounds;
            }
        }
    }
    if (input != NULL)
    {
        fclose(input);
    }
    for (unsigned r = 0; result == 0 && r < rounds; r += 1)
    {
        result = samples[0][r].present && samples[1][r].present && samples[0][r].tasks == samples[1][r].tasks ? 0 : 2;
    }
    result = rounds > 1 ? result : 2;
    if (result == 0)
    {
        printf("round\tbase_MB_s\thead_MB_s\thead_over_base\tbase_major\thead_major\n");
        double ratios[101];
        double cpu_ratios[101];
        for (unsigned r = 0; r < rounds; r += 1)
        {
            ratios[r] = samples[1][r].throughput / samples[0][r].throughput;
            printf("%u\t%.6f\t%.6f\t%.9f\t%.0f\t%.0f\n", r, samples[0][r].throughput, samples[1][r].throughput, ratios[r], samples[0][r].major, samples[1][r].major);
        }
        for (unsigned r = 1; r < rounds; r += 1)
        {
            ratios[r - 1] = samples[1][r].throughput / samples[0][r].throughput;
            cpu_ratios[r - 1] = (samples[1][r].user + samples[1][r].system) / (samples[0][r].user + samples[0][r].system);
        }
        printf("round0=warmup measured_rounds=%u paired_throughput_ratio_median=%.9f paired_CPU_cost_ratio_median=%.9f\n", rounds - 1, median(ratios, rounds - 1), median(cpu_ratios, rounds - 1));
        for (unsigned v = 0; v < 2; v += 1)
        {
            double wall[101], throughput[101], user[101], system[101], rss[101], minor[101], major[101];
            double major_total = 0;
            for (unsigned r = 1; r < rounds; r += 1)
            {
                const Sample* s = &samples[v][r];
                wall[r - 1] = s->wall / s->tasks * 1000;
                throughput[r - 1] = s->throughput;
                user[r - 1] = s->user / s->tasks * 1000;
                system[r - 1] = s->system / s->tasks * 1000;
                rss[r - 1] = s->rss;
                minor[r - 1] = s->minor / s->tasks;
                major[r - 1] = s->major / s->tasks;
                major_total += s->major;
            }
            printf("role=%u rounds=%u cohort_wall_ms_per_task=%.6f MB_s=%.6f user_ms=%.6f system_ms=%.6f cohort_max_process_RSS_KiB=%.0f minor_per_compile=%.3f major_per_compile=%.3f total_major_faults=%.0f\n", v, rounds - 1,
                   median(wall, rounds - 1), median(throughput, rounds - 1), median(user, rounds - 1), median(system, rounds - 1), median(rss, rounds - 1), median(minor, rounds - 1), median(major, rounds - 1), major_total);
            printf("role=%u wall_range_ms=%.6f..%.6f RSS_range_KiB=%.0f..%.0f\n", v, wall[0], wall[rounds - 2], rss[0], rss[rounds - 2]);
        }
    }
    if (result != 0)
    {
        fprintf(stderr, "summarize: invalid, incomplete or failed sample records\n");
    }
    return result;
}
