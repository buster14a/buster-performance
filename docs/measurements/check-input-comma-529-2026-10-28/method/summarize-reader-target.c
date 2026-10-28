// Original strict three-role direct-reader screen summary. Round zero is retained, excluded as warm-up.
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
    const char* metrics[] = { "RSS_KiB=", "minor=", "major=", "cycles=", "instructions=" };
    const char* hashes[] = {
        "06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e",
        "3f162da86b82260fe26c443932cbcb0f9ea5d308641fef9eae01639edb044ec7",
        "06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e" };
    uint64_t reference[6] = { 0 };
    double times[3][4], inner_cycles[3][4], outer[3][5][4], ratios[2][4];
    for (unsigned round = 0; round < 5; round += 1)
    {
        uint64_t pair[3] = { 0 };
        for (unsigned role = 0; role < 3; role += 1)
        {
            char path[4096], line[4096], hash[65] = { 0 };
            snprintf(path, sizeof(path), "%s/r%u-role%u.SHA256", argv[1], round, role);
            FILE* input = fopen(path, "r");
            if (input == NULL || fgets(line, sizeof(line), input) == NULL || sscanf(line, "%64s", hash) != 1 ||
                strcmp(hash, hashes[role]) != 0 || fclose(input) != 0) return 2;
            snprintf(path, sizeof(path), "%s/r%u-role%u.time", argv[1], round, role);
            input = fopen(path, "r");
            uint64_t counted = 0, status = 99;
            if (input == NULL || fgets(line, sizeof(line), input) == NULL ||
                !field(line, "counted=", &counted) || counted != 1 || !field(line, "status=", &status) || status != 0) return 2;
            for (unsigned metric = 0; metric < 5; metric += 1)
            {
                uint64_t value = 0;
                if (!field(line, metrics[metric], &value) || ((metric == 0 || metric >= 3) && value == 0)) return 2;
                if (round != 0) outer[role][metric][round - 1] = (double)value;
            }
            if (fclose(input) != 0) return 2;
            snprintf(path, sizeof(path), "%s/r%u-role%u.out", argv[1], round, role);
            input = fopen(path, "r");
            if (input == NULL) return 2;
            unsigned found = 0;
            uint64_t ns = 0, cycle = 0;
            while (fgets(line, sizeof(line), input) != NULL)
            {
                if (strncmp(line, "check_input: mode=direct ", 25) == 0)
                {
                    found += 1;
                    if (!field(line, "ns=", &ns) || !field(line, "cycles=", &cycle) || ns == 0 || cycle == 0) return 2;
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
            if (round != 0) { times[role][round - 1] = (double)ns; inner_cycles[role][round - 1] = (double)cycle; }
        }
        printf("round=%u base_ns=%llu head_ns=%llu base_again_ns=%llu head_ratio=%.9f AA_ratio=%.9f\n", round,
               (unsigned long long)pair[0], (unsigned long long)pair[1], (unsigned long long)pair[2],
               (double)pair[1] / (double)pair[0], (double)pair[2] / (double)pair[0]);
        if (round != 0)
        {
            ratios[0][round - 1] = (double)pair[1] / (double)pair[0];
            ratios[1][round - 1] = (double)pair[2] / (double)pair[0];
        }
    }
    printf("round0=warmup measured_triples=4 head_paired_time_ratio_median=%.9f AA_paired_time_ratio_median=%.9f\n", median(ratios[0], 4), median(ratios[1], 4));
    for (unsigned role = 0; role < 3; role += 1)
    {
        const double time = median(times[role], 4);
        const double cycle = median(inner_cycles[role], 4);
        printf("role=%u reader_ns_median=%.0f range=%.0f..%.0f reader_cycles_median=%.0f\n", role, time, times[role][0], times[role][3], cycle);
        for (unsigned metric = 0; metric < 5; metric += 1)
        {
            double sum = 0;
            for (unsigned round = 0; round < 4; round += 1) sum += outer[role][metric][round];
            printf("role=%u process_%smedian=%.0f sum=%.0f\n", role, metrics[metric], median(outer[role][metric], 4), sum);
        }
    }
    for (unsigned key = 0; key < 6; key += 1) printf("identical_%s%llu\n", keys[key], (unsigned long long)reference[key]);
    return 0;
}
