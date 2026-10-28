// Original #653 cohort summary. Project-default contribution terms.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int compare_double(const void* a, const void* b)
{
    const double left = *(const double*)a;
    const double right = *(const double*)b;
    return (left > right) - (left < right);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare_double);
    return count % 2 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) / 2;
}

static double field(const char* line, const char* key)
{
    const char* at = strstr(line, key);
    return at != 0 ? strtod(at + strlen(key), 0) : -1;
}

int main(int argc, char** argv)
{
    bool success = argc > 1;
    puts("path\trounds\tbase_ms\thead_ms\tratio_pct\tpaired_median_pct\tpaired_min_pct\tpaired_max_pct\tbase_user_ms\thead_user_ms\tbase_system_ms\thead_system_ms\tmajor_faults\tfailures");
    for (int arg = 1; arg < argc; arg += 1)
    {
        FILE* file = fopen(argv[arg], "r");
        double wall[2][128] = { 0 };
        double user[2][128] = { 0 };
        double system[2][128] = { 0 };
        unsigned counts[2] = { 0 };
        unsigned round = 128;
        unsigned role = 2;
        double faults = 0;
        double failures = 0;
        char line[4096];
        bool valid = file != 0;
        while (file != 0 && fgets(line, sizeof(line), file) != 0)
        {
            unsigned next_round = 0;
            unsigned next_role = 0;
            if (sscanf(line, "sample round=%u role=%u", &next_round, &next_role) == 2)
            {
                round = next_round;
                role = next_role;
            }
            else if (line[0] == '{')
            {
                const double tasks = field(line, "\"tasks\":");
                valid = valid && round < 128 && role < 2 && tasks > 0 && wall[role][round] == 0;
                if (valid)
                {
                    wall[role][round] = 1000 * field(line, "\"wall_s\":") / tasks;
                    user[role][round] = 1000 * field(line, "\"user_s\":") / tasks;
                    system[role][round] = 1000 * field(line, "\"system_s\":") / tasks;
                    faults += field(line, "\"major_faults\":");
                    failures += field(line, "\"failures\":");
                    counts[role] += 1;
                }
            }
        }
        if (file != 0)
        {
            valid = fclose(file) == 0 && valid;
        }
        valid = valid && counts[0] > 0 && counts[0] == counts[1];
        double paired[128];
        const unsigned count = counts[0];
        for (unsigned n = 0; valid && n < count; n += 1)
        {
            valid = wall[0][n] > 0 && wall[1][n] > 0;
            paired[n] = 100 * (wall[1][n] / wall[0][n] - 1);
        }
        if (valid)
        {
            const double base = median(wall[0], count);
            const double head = median(wall[1], count);
            const double pair = median(paired, count);
            printf("%s\t%u\t%.9f\t%.9f\t%.6f\t%.6f\t%.6f\t%.6f\t%.9f\t%.9f\t%.9f\t%.9f\t%.0f\t%.0f\n", argv[arg], count, base, head, 100 * (head / base - 1), pair,
                   paired[0], paired[count - 1], median(user[0], count), median(user[1], count), median(system[0], count), median(system[1], count), faults, failures);
        }
        else
        {
            fprintf(stderr, "incomplete or invalid cohort: %s\n", argv[arg]);
        }
        success = success && valid && failures == 0;
    }
    return success ? 0 : 1;
}
