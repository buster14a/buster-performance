// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for the fixed #673 matrix. Print matched-affinity policy screens with every resource field;
// three repetitions and fixed executable placements are characterization, not a broad precise speedup claim.
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static double matrix_json(const char* path, const char* key)
{
    FILE* stream = fopen(path, "r");
    char line[2048] = { 0 };
    bool valid = stream != NULL && fgets(line, sizeof(line), stream) != NULL;
    if (stream != NULL) valid = fclose(stream) == 0 && valid;
    char pattern[80];
    snprintf(pattern, sizeof(pattern), "\"%s\":", key);
    const char* found = valid ? strstr(line, pattern) : NULL;
    const double result = found != NULL ? strtod(found + strlen(pattern), NULL) : -1;
    return isfinite(result) ? result : -1;
}

static double matrix_counter(const char* path, const char* name)
{
    FILE* stream = fopen(path, "r");
    double result = -1;
    char line[1024];
    while (stream != NULL && fgets(line, sizeof(line), stream) != NULL)
    {
        char* unit = strchr(line, ',');
        char* event = unit != NULL ? strchr(unit + 1, ',') : NULL;
        const size_t length = strlen(name);
        if (event != NULL && strncmp(event + 1, name, length) == 0 && event[length + 1] == ',')
        {
            char* end = NULL;
            const double parsed = strtod(line, &end);
            const char* runtime = strchr(event + 1, ',');
            const char* percentage = runtime != NULL ? strchr(runtime + 1, ',') : NULL;
            const double counted = percentage != NULL ? strtod(percentage + 1, NULL) : -1;
            result = end == unit && isfinite(parsed) && parsed >= 0 && counted == 100.0 ? parsed : -1;
        }
    }
    if (stream != NULL) result = ferror(stream) || fclose(stream) != 0 ? -1 : result;
    return result;
}

static double matrix_median(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double item = values[i];
        unsigned at = i;
        while (at > 0 && values[at - 1] > item)
        {
            values[at] = values[at - 1];
            at -= 1;
        }
        values[at] = item;
    }
    return values[count / 2];
}

int main(int argc, char** argv)
{
    static const char* variants[] = { "base-one", "base-default", "base-eight", "head-one", "head-default", "head-eight",
                                      "head-cap-one", "head-jobserver", "base-pinned-one", "head-pinned-one" };
    static const char* fields[] = { "wall_s", "user_s", "system_s", "maxrss_kb", "minor_faults", "major_faults", "voluntary_cs", "involuntary_cs" };
    static const char* counters[] = { "task-clock", "context-switches", "cpu-migrations", "cycles", "instructions", "page-faults" };
    bool valid = argc == 3;
    const unsigned rounds = valid ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    valid = valid && rounds > 0 && rounds <= 11 && rounds % 2 == 1;
    printf("jobs\tpolicy\tn\tMB_per_s\twall_ms\tmin_ms\tmax_ms\tuser_ms\tsystem_ms\tmaxrss_kb\tminor\tmajor_median\tmajor_sum\tvoluntary\tinvoluntary\ttask_ms\tcontext_switches\tmigrations\tcycles\tinstructions\tperf_faults\n");
    for (unsigned jobs = 1; valid && jobs <= 8; jobs *= 2)
    {
        for (unsigned variant = 0; valid && variant < sizeof(variants) / sizeof(variants[0]); variant += 1)
        {
            double values[14][11] = { 0 };
            double major_sum = 0;
            for (unsigned round = 0; valid && round < rounds; round += 1)
            {
                char directory[4096], path[4096];
                snprintf(directory, sizeof(directory), "%s/r%02u-j%u-%s", argv[1], round, jobs, variants[variant]);
                snprintf(path, sizeof(path), "%s/%s", directory, variant == 7 ? "cohort.usage" : "summary.json");
                for (unsigned field = 0; field < 8; field += 1)
                {
                    values[field][round] = matrix_json(path, fields[field]);
                    valid = values[field][round] >= 0 && valid;
                }
                major_sum += values[5][round];
                if (variant == 7) valid = matrix_json(path, "status") == 0 && valid;
                else valid = matrix_json(path, "jobs") == jobs && matrix_json(path, "tasks") == 8 &&
                             matrix_json(path, "finished") == 8 && matrix_json(path, "failures") == 0 && valid;
                snprintf(path, sizeof(path), "%s/perf.csv", directory);
                for (unsigned counter = 0; counter < 6; counter += 1)
                {
                    values[counter + 8][round] = matrix_counter(path, counters[counter]);
                    valid = values[counter + 8][round] >= 0 && valid;
                }
                if (!valid) fprintf(stderr, "matrix stats: incomplete or invalid %s\n", directory);
            }
            if (valid)
            {
                double medians[14];
                for (unsigned field = 0; field < 14; field += 1) medians[field] = matrix_median(values[field], rounds);
                const double rate = 9507037.0 * 8 / medians[0] / 1e6;
                printf("%u\t%s\t%u\t%.6f\t%.6f\t%.6f\t%.6f\t%.3f\t%.3f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.3f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n",
                       jobs, variants[variant], rounds, rate, medians[0] * 1000, values[0][0] * 1000, values[0][rounds - 1] * 1000,
                       medians[1] * 1000, medians[2] * 1000, medians[3], medians[4], medians[5], major_sum,
                       medians[6], medians[7], medians[8], medians[9], medians[10], medians[11], medians[12], medians[13]);
            }
        }
    }
    return !valid;
}
