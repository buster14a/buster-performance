// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for the balanced #673 policy controls. Reuse the matrix reader's JSON/counter parsers; its
// alternate entry is never called here. The emitted schedule, exact pair balance, resources and statuses are gates.
#define main policy_unused_matrix_main
#include "matrix_stats.c"
#undef main

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    printf("workload\tpolicy\tn\twall_ms\tmin_ms\tmax_ms\tuser_ms\tsystem_ms\tmaxrss_kib\tminor\tmajor_median\tmajor_sum\tvoluntary\tinvoluntary\ttask_ms\tcontext_switches\tmigrations\tcycles\tinstructions\tperf_faults\n");
    for (unsigned workload = 0; valid && workload < 3; workload += 1)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/673-balanced-w%u.txt", argv[1], workload);
        FILE* stream = fopen(path, "r");
        valid = stream != NULL && valid;
        double values[3][14][12] = { 0 };
        double majors[3] = { 0 };
        unsigned counts[3] = { 0 };
        unsigned pairs[3][3] = { 0 };
        bool seen[36] = { 0 };
        unsigned previous = 3;
        unsigned results = 0;
        char line[8192];
        while (valid && fgets(line, sizeof(line), stream) != NULL)
        {
            unsigned w, index, role, before, identical;
            int status;
            if (sscanf(line, "prime workload=%u case=%u role=%u predecessor=%u", &w, &index, &role, &before) == 4)
            {
                valid = w == workload && role == 2 && before == 2 && previous == 3;
                previous = role;
            }
            else if (sscanf(line, "sample workload=%u case=%u role=%u predecessor=%u", &w, &index, &role, &before) == 4)
            {
                valid = w == workload && index < 36 && role < 3 && before < 3 && before == previous && !seen[index];
                if (valid)
                {
                    const unsigned count = counts[role]++;
                    valid = count < 12;
                    seen[index] = true;
                    pairs[before][role] += 1;
                    previous = role;
                    snprintf(path, sizeof(path), "%s/balanced-w%u/c%02u-r%u/sample.usage", argv[1], workload, index, role);
                    static const char* fields[] = {
                        "wall_s",
                        "user_s",
                        "system_s",
                        "maxrss_kb",
                        "minor_faults",
                        "major_faults",
                        "voluntary_cs",
                        "involuntary_cs",
                    };
                    valid = matrix_json(path, "status") == 0 && valid;
                    for (unsigned field = 0; valid && field < 8; field += 1)
                    {
                        values[role][field][count] = matrix_json(path, fields[field]);
                        valid = values[role][field][count] >= 0;
                    }
                    majors[role] += valid ? values[role][5][count] : 0;
                    snprintf(path, sizeof(path), "%s/balanced-w%u/c%02u-r%u/perf.csv", argv[1], workload, index, role);
                    static const char* counters[] = {
                        "task-clock",
                        "context-switches",
                        "cpu-migrations",
                        "cycles",
                        "instructions",
                        "page-faults",
                    };
                    for (unsigned counter = 0; valid && counter < 6; counter += 1)
                    {
                        values[role][counter + 8][count] = matrix_counter(path, counters[counter]);
                        valid = values[role][counter + 8][count] >= 0;
                    }
                }
            }
            else if (sscanf(line, "result workload=%u case=%u role=%u status=%d identical=%u", &w, &index, &role, &status, &identical) == 5)
            {
                valid = w == workload && index < 36 && role < 3 && status == 0 && identical == 1;
                results += 1;
            }
        }
        if (stream != NULL) valid = !ferror(stream) && fclose(stream) == 0 && valid;
        valid = results == 37 && valid;
        for (unsigned index = 0; index < 36; index += 1) valid = seen[index] && valid;
        for (unsigned before = 0; before < 3; before += 1)
        {
            for (unsigned role = 0; role < 3; role += 1) valid = pairs[before][role] == 4 && valid;
        }
        for (unsigned role = 0; valid && role < 3; role += 1)
        {
            valid = counts[role] == 12;
            double medians[14];
            for (unsigned field = 0; field < 14; field += 1)
            {
                matrix_median(values[role][field], 12);
                medians[field] = (values[role][field][5] + values[role][field][6]) * 0.5;
            }
            printf("%u\t%s\t12\t%.6f\t%.6f\t%.6f\t%.3f\t%.3f\t%.0f\t%.0f\t%.1f\t%.0f\t%.0f\t%.0f\t%.3f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n",
                   workload, role == 0 ? "jobserver" : role == 1 ? "cap1" : "free8", medians[0] * 1000,
                   values[role][0][0] * 1000, values[role][0][11] * 1000, medians[1] * 1000, medians[2] * 1000,
                   medians[3], medians[4], medians[5], majors[role], medians[6], medians[7],
                   medians[8], medians[9], medians[10], medians[11], medians[12], medians[13]);
        }
        if (!valid) fprintf(stderr, "balanced policy invalid or incomplete workload %u\n", workload);
    }
    return !valid;
}
