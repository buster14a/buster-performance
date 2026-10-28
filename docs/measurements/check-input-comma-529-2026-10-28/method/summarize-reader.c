// Original local five-pair reader screen summary; round zero is a declared warm-up.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

static bool field(const char* line, const char* key, uint64_t* result)
{
    const char* begin = strstr(line, key);
    char* end = NULL;
    if (begin == NULL) return false;
    begin += strlen(key);
    *result = strtoull(begin, &end, 10);
    return end != begin && (*end == ' ' || *end == '\n' || *end == 0);
}

int main(int argc, char** argv)
{
    if (argc != 2) return 2;
    const char* keys[] = { "retained_bytes=", "written_bytes_available=", "output_written_bytes=", "scratch_written_bytes=",
                           "resolve_visits=", "expression_visits=" };
    uint64_t reference[6] = { 0 };
    double times[2][4], cycles[2][4], ratios[4];
    for (unsigned round = 0; round < 5; round += 1)
    {
        uint64_t pair[2] = { 0 };
        for (unsigned role = 0; role < 2; role += 1)
        {
            char path[4096], line[4096];
            snprintf(path, sizeof(path), "%s/r%u-role%u.out", argv[1], round, role);
            FILE* input = fopen(path, "r");
            if (input == NULL) return 2;
            unsigned found = 0;
            uint64_t ns = 0, cycle = 0;
            while (fgets(line, sizeof(line), input) != NULL)
            {
                if (strncmp(line, "check_input: mode=direct ", 25) == 0)
                {
                    found += 1;
                    if (!field(line, "ns=", &ns) || !field(line, "cycles=", &cycle) || ns == 0) return 2;
                    for (unsigned key = 0; key < 6; key += 1)
                    {
                        uint64_t value = 0;
                        if (!field(line, keys[key], &value)) return 2;
                        if (round == 0 && role == 0) reference[key] = value;
                        if (reference[key] != value) return 2;
                    }
                }
            }
            if (ferror(input) || fclose(input) != 0 || found != 1) return 2;
            pair[role] = ns;
            if (round != 0) { times[role][round - 1] = (double)ns; cycles[role][round - 1] = (double)cycle; }
        }
        const double ratio = (double)pair[1] / (double)pair[0];
        printf("round=%u base_ns=%llu head_ns=%llu head_over_base=%.9f\n", round,
               (unsigned long long)pair[0], (unsigned long long)pair[1], ratio);
        if (round != 0) ratios[round - 1] = ratio;
    }
    printf("round0=warmup measured_pairs=4 paired_time_ratio_median=%.9f\n", median(ratios, 4));
    for (unsigned role = 0; role < 2; role += 1)
    {
        const double time = median(times[role], 4);
        const double cycle = median(cycles[role], 4);
        printf("role=%u reader_ns_median=%.0f range=%.0f..%.0f reader_cycles_median=%.0f\n",
               role, time, times[role][0], times[role][3], cycle);
    }
    for (unsigned key = 0; key < 6; key += 1) printf("identical_%s%llu\n", keys[key], (unsigned long long)reference[key]);
    return 0;
}
