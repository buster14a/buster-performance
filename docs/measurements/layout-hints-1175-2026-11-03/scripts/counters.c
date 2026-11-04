// counters.c: summarizes campaign-9700x.sh's perf counts (#1175).
// usage: counters < counters.txt > counters-summary.txt
//   Each input line is "BUILD PLACEMENT MODE RUN EVENT VALUE". Per build, mode, event and placement, the least of the
//   runs; per build, mode and event, their mean over the placements. The first build is the reference: each other
//   build's mean is compared with its mean, and its range is each of its placements against each of the reference's,
//   as time-runs compares builds (#509): a placement of one tree isn't the same placement of another, so the range
//   pairs nothing. A value that isn't a number (perf's "<not counted>" or "<not supported>") fails the summary.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_COUNTERS_NAMES 16
#define BUSTER_COUNTERS_NAME_BYTES 64

typedef struct
{
    char names[BUSTER_COUNTERS_NAMES][BUSTER_COUNTERS_NAME_BYTES];
    int count;
} NameTable;

typedef struct
{
    double least;
    bool present;
} Cell;

static NameTable builds;
static NameTable placements;
static NameTable modes;
static NameTable events;
static Cell cells[BUSTER_COUNTERS_NAMES][BUSTER_COUNTERS_NAMES][BUSTER_COUNTERS_NAMES][BUSTER_COUNTERS_NAMES];

// The name's index in the table, added in input order; -1 when the table is full or the name too long.
static int name_index(NameTable* table, const char* name)
{
    int result = -1;
    for (int i = 0; i < table->count && result < 0; i += 1)
    {
        if (strcmp(table->names[i], name) == 0)
        {
            result = i;
        }
    }
    if (result < 0 && table->count < BUSTER_COUNTERS_NAMES && strlen(name) < BUSTER_COUNTERS_NAME_BYTES)
    {
        strcpy(table->names[table->count], name);
        result = table->count;
        table->count += 1;
    }
    return result;
}

// The build's mean over its placements, and the least and greatest change of one of its placements against one of the
// reference's (build 0); false when either has none.
static bool summarize(int build, int mode, int event, double* mean, double* low, double* high)
{
    double sum = 0;
    int count = 0;
    bool any = false;
    *low = 0;
    *high = 0;
    for (int placement = 0; placement < placements.count; placement += 1)
    {
        const Cell* cell = &cells[build][placement][mode][event];
        if (cell->present)
        {
            sum += cell->least;
            count += 1;
            for (int other = 0; other < placements.count; other += 1)
            {
                const Cell* reference = &cells[0][other][mode][event];
                if (reference->present)
                {
                    const double change = cell->least / reference->least - 1;
                    *low = !any || change < *low ? change : *low;
                    *high = !any || change > *high ? change : *high;
                    any = true;
                }
            }
        }
    }
    *mean = count != 0 ? sum / count : 0;
    return any;
}

int main(void)
{
    int status = 0;
    char line[1024];
    int line_number = 0;
    while (status == 0 && fgets(line, sizeof(line), stdin) != NULL)
    {
        char build[BUSTER_COUNTERS_NAME_BYTES];
        char placement[BUSTER_COUNTERS_NAME_BYTES];
        char mode[BUSTER_COUNTERS_NAME_BYTES];
        char run[BUSTER_COUNTERS_NAME_BYTES];
        char event[BUSTER_COUNTERS_NAME_BYTES];
        char value[BUSTER_COUNTERS_NAME_BYTES];
        line_number += 1;
        if (sscanf(line, "%63s %63s %63s %63s %63s %63s", build, placement, mode, run, event, value) != 6)
        {
            fprintf(stderr, "counters: line %d: expected BUILD PLACEMENT MODE RUN EVENT VALUE\n", line_number);
            status = 1;
        }
        else
        {
            char* end = NULL;
            const double number = strtod(value, &end);
            const int b = name_index(&builds, build);
            const int p = name_index(&placements, placement);
            const int m = name_index(&modes, mode);
            const int e = name_index(&events, event);
            if (end == value || *end != 0)
            {
                fprintf(stderr, "counters: line %d: %s %s %s run %s: %s isn't counted (%s)\n", line_number, build, placement, mode, run, event, value);
                status = 1;
            }
            else if (b < 0 || p < 0 || m < 0 || e < 0)
            {
                fprintf(stderr, "counters: line %d: more than %d names in a column\n", line_number, BUSTER_COUNTERS_NAMES);
                status = 1;
            }
            else
            {
                Cell* cell = &cells[b][p][m][e];
                cell->least = !cell->present || number < cell->least ? number : cell->least;
                cell->present = true;
            }
        }
    }
    if (status == 0 && builds.count == 0)
    {
        fprintf(stderr, "counters: no counts\n");
        status = 1;
    }
    if (status == 0)
    {
        printf("Least of each placement's runs, mean over %d placements; the change against %s, and its range over each placement against each of %s's\n",
               placements.count, builds.names[0], builds.names[0]);
        for (int mode = 0; mode < modes.count; mode += 1)
        {
            for (int event = 0; event < events.count; event += 1)
            {
                double reference = 0;
                double low = 0;
                double high = 0;
                if (summarize(0, mode, event, &reference, &low, &high))
                {
                    printf("%-10s %-20s %-8s %16.0f\n", modes.names[mode], events.names[event], builds.names[0], reference);
                    for (int build = 1; build < builds.count; build += 1)
                    {
                        double mean = 0;
                        if (summarize(build, mode, event, &mean, &low, &high))
                        {
                            printf("%-10s %-20s %-8s %16.0f %+8.3f%% (%+.3f%% to %+.3f%%)\n", modes.names[mode], events.names[event], builds.names[build], mean,
                                   (mean / reference - 1) * 100, low * 100, high * 100);
                        }
                    }
                }
            }
        }
    }
    return status;
}
