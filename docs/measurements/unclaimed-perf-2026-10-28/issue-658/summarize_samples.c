// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original paired-cohort summary. Raw stdout, per-process counters and outputs remain authoritative.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    double wall[101];
    double rss[101];
    double user[101];
    double system[101];
    unsigned count;
    unsigned failures;
    long long major;
    long long minor;
} Samples;

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return count == 0 ? 0 : count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

int main(int argc, char** argv)
{
    int result = 1;
    FILE* input = argc == 2 ? fopen(argv[1], "r") : NULL;
    Samples roles[2] = {0};
    double paired[101] = {0};
    unsigned role = 2;
    unsigned round = 101;
    unsigned positive = 0;
    bool valid = true;
    char line[8192];
    while (input != NULL && fgets(line, sizeof(line), input) != NULL)
    {
        unsigned current_round = 0;
        unsigned current_role = 0;
        if (sscanf(line, "sample round=%u role=%u", &current_round, &current_role) == 2)
        {
            round = current_round;
            role = current_role;
        }
        else if (line[0] == '{' && role < 2 && round < 101)
        {
            unsigned jobs = 0;
            unsigned tasks = 0;
            unsigned failures = 0;
            long long bytes = 0;
            double wall = 0;
            double throughput = 0;
            double user = 0;
            double system = 0;
            long long rss = 0;
            long long minor = 0;
            long long major = 0;
            const int fields = sscanf(line, "{\"jobs\":%u,\"tasks\":%u,\"failures\":%u,\"source_bytes\":%lld,\"wall_s\":%lf,\"MB_per_s\":%lf,\"user_s\":%lf,\"system_s\":%lf,\"maxrss_kb\":%lld,\"minor_faults\":%lld,\"major_faults\":%lld", &jobs, &tasks, &failures, &bytes, &wall, &throughput, &user, &system, &rss, &minor, &major);
            if (fields != 11 || jobs != 1 || tasks == 0 || roles[role].count >= 101)
            {
                fprintf(stderr, "invalid cohort record\n");
                valid = false;
                break;
            }
            Samples* sample = &roles[role];
            sample->wall[sample->count] = wall / tasks;
            sample->rss[sample->count] = (double)rss;
            sample->user[sample->count] = user / tasks;
            sample->system[sample->count] = system / tasks;
            sample->count += 1;
            sample->failures += failures;
            sample->major += major;
            sample->minor += minor;
        }
    }
    if (input != NULL)
    {
        result = !valid || ferror(input) != 0 || roles[0].count == 0 || roles[0].count != roles[1].count;
        fclose(input);
    }
    if (result == 0)
    {
        for (unsigned i = 0; i < roles[0].count; i += 1)
        {
            paired[i] = roles[0].wall[i] / roles[1].wall[i] - 1;
            positive += paired[i] > 0;
        }
        const double paired_median = median(paired, roles[0].count);
        double wall_median[2] = {0};
        for (unsigned r = 0; r < 2; r += 1)
        {
            Samples* sample = &roles[r];
            wall_median[r] = median(sample->wall, sample->count);
            const double rss_median = median(sample->rss, sample->count);
            printf("role=%u rounds=%u failures=%u wall_median_ms=%.6f wall_min_ms=%.6f wall_max_ms=%.6f rss_median_KiB=%.0f rss_max_KiB=%.0f user_median_ms=%.6f sys_median_ms=%.6f minor_total=%lld major_total=%lld\n", r, sample->count, sample->failures, wall_median[r] * 1000, sample->wall[0] * 1000, sample->wall[sample->count - 1] * 1000, rss_median, sample->rss[sample->count - 1], median(sample->user, sample->count) * 1000, median(sample->system, sample->count) * 1000, sample->minor, sample->major);
            result |= sample->failures != 0;
        }
        printf("median_throughput_change_percent=%.6f paired_median_percent=%.6f positive_pairs=%u/%u\n", (wall_median[0] / wall_median[1] - 1) * 100, paired_median * 100, positive, roles[0].count);
    }
    return result;
}
