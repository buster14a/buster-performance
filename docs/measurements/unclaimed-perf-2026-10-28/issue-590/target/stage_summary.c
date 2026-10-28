// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original strict reader for raw one-task samples/cohort receipts; preserves failures and checks every object pair.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { LIMIT = 128, FIELDS = 8 };
static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a, y = *(const double*)b;
    return (x > y) - (x < y);
}
static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(*values), compare);
    return count & 1 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) * 0.5;
}
static bool same_file(const char* first, const char* second)
{
    FILE* a = fopen(first, "rb");
    FILE* b = fopen(second, "rb");
    bool same = a != NULL && b != NULL;
    unsigned char left[65536], right[65536];
    bool finished = false;
    while (same && !finished)
    {
        const size_t x = fread(left, 1, sizeof(left), a);
        const size_t y = fread(right, 1, sizeof(right), b);
        same = x == y && memcmp(left, right, x) == 0;
        finished = x != sizeof(left);
    }
    same = same && !ferror(a) && !ferror(b);
    if (a != NULL) fclose(a);
    if (b != NULL) fclose(b);
    return same;
}
int main(int argc, char** argv)
{
    int result = 2;
    if (argc == 4)
    {
        const unsigned runs = (unsigned)strtoul(argv[2], NULL, 10);
        double fields[2][FIELDS][LIMIT] = { 0 };
        unsigned failed[2] = { 0 }, matches = 0, loaded[2] = { 0 };
        unsigned long long majors[2] = { 0 };
        result = runs == 0 || runs > LIMIT;
        for (unsigned run = 0; result == 0 && run < runs; run += 1)
        {
            for (unsigned role = 0; role < 2; role += 1)
            {
                char path[4096];
                snprintf(path, sizeof(path), "%s/r%03u-role%u/stderr-0000.txt", argv[1], run, role);
                FILE* input = fopen(path, "r");
                char* line = NULL;
                size_t capacity = 0;
                bool found = false;
                while (input != NULL && getline(&line, &capacity, input) >= 0)
                {
                    char name[64];
                    double ms, percent, system;
                    unsigned long long minor, added;
                    if (sscanf(line, "time-stage\t%63[^\t]\t%lf\t%lf\t%lf\t%llu\t%llu", name, &ms, &percent, &system, &minor, &added) == 6 &&
                        strcmp(name, argv[3]) == 0)
                    {
                        fields[role][0][run] = ms;
                        fields[role][1][run] = minor;
                        fields[role][2][run] = added;
                        found = true;
                    }
                }
                if (input != NULL) fclose(input);
                free(line);
                snprintf(path, sizeof(path), "%s/r%03u-role%u/children.tsv", argv[1], run, role);
                input = fopen(path, "r");
                line = NULL;
                capacity = 0;
                bool child = false;
                unsigned child_count = 0;
                while (input != NULL && getline(&line, &capacity, input) >= 0)
                {
                    unsigned task, cpu, status;
                    double user, system;
                    unsigned long long rss, minor, major, voluntary, involuntary, bytes;
                    if (sscanf(line, "%u\t%u\t%u\t%lf\t%lf\t%llu\t%llu\t%llu\t%llu\t%llu\t%llu", &task, &cpu, &status,
                               &user, &system, &rss, &minor, &major, &voluntary, &involuntary, &bytes) == 11)
                    {
                        child_count += 1;
                        child = child_count == 1 && task == 0 && cpu == 2 && bytes != 0;
                        failed[role] += status != 0;
                        majors[role] += major;
                        fields[role][3][run] = user * 1000.0;
                        fields[role][4][run] = system * 1000.0;
                        fields[role][5][run] = rss;
                        fields[role][6][run] = minor;
                    }
                }
                if (input != NULL) fclose(input);
                free(line);
                loaded[role] += found && child;
                result |= !found || !child;
                if (!found || !child) fprintf(stderr, "missing/invalid stage or child: run=%u role=%u\n", run, role);
            }
            char base[4096], head[4096];
            snprintf(base, sizeof(base), "%s/r%03u-role0/output-0000.o", argv[1], run);
            snprintf(head, sizeof(head), "%s/r%03u-role1/output-0000.o", argv[1], run);
            const bool same = same_file(base, head);
            matches += same;
            result |= !same;
        }
        char log_path[4096];
        snprintf(log_path, sizeof(log_path), "%s.log", argv[1]);
        FILE* log = fopen(log_path, "r");
        char* log_line = NULL;
        size_t log_capacity = 0;
        unsigned log_run = LIMIT, log_role = 2;
        bool wall_seen[2][LIMIT] = { 0 };
        while (log != NULL && getline(&log_line, &log_capacity, log) >= 0)
        {
            unsigned next_run, next_role;
            if (sscanf(log_line, "sample round=%u role=%u", &next_run, &next_role) == 2)
            {
                log_run = next_run;
                log_role = next_role;
            }
            const char* wall = strstr(log_line, "\"wall_s\":");
            if (wall != NULL && log_run < runs && log_role < 2)
            {
                fields[log_role][7][log_run] = strtod(wall + strlen("\"wall_s\":"), NULL) * 1000.0;
                wall_seen[log_role][log_run] = fields[log_role][7][log_run] > 0;
            }
        }
        if (log != NULL) fclose(log);
        free(log_line);
        double paired[LIMIT];
        unsigned faster = 0;
        for (unsigned run = 0; run < runs && run < LIMIT; run += 1)
        {
            result |= !wall_seen[0][run] || !wall_seen[1][run];
            paired[run] = 100.0 * (fields[1][7][run] / fields[0][7][run] - 1.0);
            faster += paired[run] < 0;
        }
        printf("root=%s stage=%s loaded=%u/%u failed=%u/%u majors=%llu/%llu identical_object_pairs=%u/%u\n",
               argv[1], argv[3], loaded[0], loaded[1], failed[0], failed[1], majors[0], majors[1], matches, runs);
        if (loaded[0] == runs && loaded[1] == runs && runs != 0 && runs <= LIMIT)
        {
            printf("role stage_ms stage_minor stage_peak_added_kb process_user_ms process_system_ms process_rss_kb process_minor cohort_wall_ms\n");
            for (unsigned role = 0; role < 2; role += 1)
            {
                printf("%s", role == 0 ? "base" : "head");
                for (unsigned field = 0; field < FIELDS; field += 1) printf(" %.6f", median(fields[role][field], runs));
                putchar('\n');
            }
            printf("paired_cohort_wall_change_pct=%.6f faster=%u/%u\n", median(paired, runs), faster, runs);
        }
        result |= failed[0] != 0 || failed[1] != 0;
    }
    return result;
}
