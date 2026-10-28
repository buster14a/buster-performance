// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader of three fresh-copy two-build time-runs rounds. Wall/rusage only; no PMU claim.
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static double median(double* a)
{
    for (unsigned i = 1; i < 3; i += 1)
    {
        const double value = a[i];
        unsigned at = i;
        while (at != 0 && a[at - 1] > value)
        {
            a[at] = a[at - 1];
            at -= 1;
        }
        a[at] = value;
    }
    return a[1];
}

int main(int argc, char** argv)
{
    FILE* file = argc == 2 ? fopen(argv[1], "r") : NULL;
    int result = file == NULL;
    unsigned round = 0;
    unsigned processes = 0;
    unsigned failed = 0;
    unsigned seen[2][3] = { 0 };
    double values[2][4][3] = { 0 };
    char line[8192];
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        if (sscanf(line, "== round %u tree", &round) == 1)
        {
            result |= round < 1 || round > 3;
        }
        const char* status = strstr(line, "status ");
        if (strncmp(line, "run ", 4) == 0 && status != NULL)
        {
            processes += 1;
            failed += strtol(status + 7, NULL, 10) != 0;
        }
        if (strncmp(line, "list 1 ", 7) == 0 && strstr(line, " copy 1 [") != NULL)
        {
            const unsigned role = strncmp(line + 7, "base ", 5) == 0 ? 0 : 1;
            const char* summary = strstr(line, "]: ");
            unsigned runs = 0;
            double wall = 0, user = 0, system = 0;
            unsigned long rss = 0, minor = 0, major = 0;
            const int parsed = summary != NULL ? sscanf(summary + 3,
                "%u runs, median %lf ms wall (%*f to %*f), %lf ms user, %lf ms system, %lu KB peak, %lu minor faults, %lu major",
                &runs, &wall, &user, &system, &rss, &minor, &major) : 0;
            if (round < 1 || round > 3 || parsed != 7 || runs != 21 || !isfinite(wall) || wall <= 0 || rss == 0)
            {
                result = 1;
            }
            else
            {
                result |= seen[role][round - 1] != 0;
                seen[role][round - 1] += 1;
                values[role][0][round - 1] = wall;
                values[role][1][round - 1] = (double)rss;
                values[role][2][round - 1] = (double)minor;
                values[role][3][round - 1] = (double)major;
            }
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    for (unsigned role = 0; role < 2; role += 1)
    {
        for (unsigned pass = 0; pass < 3; pass += 1)
        {
            result |= seen[role][pass] != 1;
        }
    }
    result |= processes != 126 || failed != 0;
    printf("rounds=3 runs_per_role_per_round=21 timed_processes=%u failures=%u result=%d\n", processes, failed, result);
    const char* names[4] = { "wall_ms", "peak_rss_KiB", "minor_faults", "major_faults" };
    for (unsigned metric = 0; result == 0 && metric < 4; metric += 1)
    {
        const double base = median(values[0][metric]);
        const double other = median(values[1][metric]);
        printf("%s base=%.6f other=%.6f", names[metric], base, other);
        if (base != 0)
        {
            printf(" change=%+.4f%%", 100.0 * (other / base - 1.0));
        }
        putchar('\n');
    }
    return result;
}
