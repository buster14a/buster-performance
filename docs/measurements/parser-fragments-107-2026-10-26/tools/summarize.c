// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
//
// The summary of buster14a/buster#107's benchmark logs: each path's median over the processes of each measure's
// per-process median (benchmark-parser --expressions prints one per path and process), with the processes' lowest and
// highest, and each path's change from postorder (A). Usage: summarize LOG...
//
// A log's lines `path=NAME variant=V measure/token=MEDIAN [FASTEST SLOWEST] ...` are read; everything else is skipped.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PATHS 4
#define MEASURES 16
#define PROCESSES 64

static const char* const paths[PATHS] = { "postorder", "prefix", "fragments", "sorted" };
static char measures[MEASURES][64];
static unsigned measure_count;
static double values[PATHS][MEASURES][PROCESSES];
static unsigned counts[PATHS][MEASURES];

static int compare(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return x < y ? -1 : x > y ? 1 : 0;
}

static unsigned measure_index(const char* name, size_t length)
{
    unsigned index = measure_count;
    for (unsigned m = 0; m < measure_count; m += 1)
    {
        if (strlen(measures[m]) == length && memcmp(measures[m], name, length) == 0)
        {
            index = m;
        }
    }
    if (index == measure_count && measure_count < MEASURES && length < sizeof(measures[0]))
    {
        memcpy(measures[measure_count], name, length);
        measures[measure_count][length] = 0;
        measure_count += 1;
    }
    return index;
}

static double median(double* data, unsigned count)
{
    qsort(data, count, sizeof(double), compare);
    return count == 0 ? 0 : count % 2 ? data[count / 2] : (data[count / 2 - 1] + data[count / 2]) / 2;
}

int main(int argc, char** argv)
{
    for (int a = 1; a < argc; a += 1)
    {
        FILE* file = fopen(argv[a], "r");
        char line[16384];
        while (file != 0 && fgets(line, sizeof(line), file) != 0)
        {
            unsigned path = PATHS;
            for (unsigned p = 0; p < PATHS; p += 1)
            {
                const size_t length = strlen(paths[p]);
                if (strncmp(line, "path=", 5) == 0 && strncmp(line + 5, paths[p], length) == 0 && line[5 + length] == ' ')
                {
                    path = p;
                }
            }
            for (char* at = path < PATHS ? strstr(line, "/token=") : 0; at != 0; at = strstr(at + 1, "/token="))
            {
                char* start = at;
                while (start > line && start[-1] != ' ')
                {
                    start -= 1;
                }
                const unsigned m = measure_index(start, (size_t)(at - start));
                if (m < MEASURES && counts[path][m] < PROCESSES)
                {
                    values[path][m][counts[path][m]] = strtod(at + 7, 0);
                    counts[path][m] += 1;
                }
            }
        }
        if (file != 0)
        {
            fclose(file);
        }
    }
    double reference[MEASURES] = { 0 };
    for (unsigned p = 0; p < PATHS; p += 1)
    {
        for (unsigned m = 0; m < measure_count && counts[p][m] != 0; m += 1)
        {
            double sorted[PROCESSES];
            memcpy(sorted, values[p][m], counts[p][m] * sizeof(double));
            const double middle = median(sorted, counts[p][m]);
            reference[m] = p == 0 ? middle : reference[m];
            printf("%-9s %-22s %10.3f  [%.3f %.3f]  processes=%u", paths[p], measures[m], middle, sorted[0], sorted[counts[p][m] - 1], counts[p][m]);
            if (p != 0 && reference[m] != 0)
            {
                printf("  %+.1f%% from postorder", 100.0 * (middle - reference[m]) / reference[m]);
            }
            printf("\n");
        }
    }
    return 0;
}
