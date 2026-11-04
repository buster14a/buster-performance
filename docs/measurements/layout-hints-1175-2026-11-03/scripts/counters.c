// counters.c: summarizes campaign-9700x.sh's perf counts (#1175).
// usage: counters EXPECTED < counters.txt > counters-summary.txt
//   EXPECTED has "BUILD PLACEMENT MODE RUN EVENT" for every intended sample. Its first build is the reference.
//   Require the complete declared grid exactly once before printing any comparison; a missing whole build, mode,
//   placement or event must not silently change the experiment. Runs are consecutive integers starting at 1.
//   Each input line is "BUILD PLACEMENT MODE RUN EVENT VALUE". Per build, mode, event and placement, the least of the
//   runs; per build, mode and event, their mean over the placements. The first build is the reference: each other
//   build's mean is compared with its mean, and its range is each of its placements against each of the reference's,
//   as time-runs compares builds (#509): a placement of one tree isn't the same placement of another, so the range
//   pairs nothing. Non-finite, non-positive and out-of-range counts (including perf's unavailable markers) fail the summary.
#include <errno.h>
#include <math.h>
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
    uint32_t expected_runs;
    uint32_t seen_runs;
} Cell;

static NameTable builds;
static NameTable placements;
static NameTable modes;
static NameTable events;
static Cell cells[BUSTER_COUNTERS_NAMES][BUSTER_COUNTERS_NAMES][BUSTER_COUNTERS_NAMES][BUSTER_COUNTERS_NAMES];

// Find a declared name; only the manifest may append names, in declaration order.
static int name_index(NameTable* table, const char* name, bool add)
{
    int result = -1;
    for (int i = 0; i < table->count && result < 0; i += 1)
    {
        if (strcmp(table->names[i], name) == 0)
        {
            result = i;
        }
    }
    if (add && result < 0 && table->count < BUSTER_COUNTERS_NAMES && strlen(name) < BUSTER_COUNTERS_NAME_BYTES)
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
        if (cell->seen_runs != 0)
        {
            sum += cell->least;
            count += 1;
            for (int other = 0; other < placements.count; other += 1)
            {
                const Cell* reference = &cells[0][other][mode][event];
                if (reference->seen_runs != 0)
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

// Bounded decimal run IDs, kept as bits so duplicate samples cannot replace a previous observation.
static uint32_t run_bit(const char* text)
{
    unsigned run = 0;
    bool valid = text[0] != 0;
    for (int i = 0; text[i] != 0 && valid; i += 1)
    {
        valid = text[i] >= '0' && text[i] <= '9';
        if (valid)
        {
            run = run * 10 + (unsigned)(text[i] - '0');
            valid = run <= 32;
        }
    }
    return valid && run != 0 ? UINT32_C(1) << (run - 1) : 0;
}

static int read_counts(FILE* input, bool expected, FILE* errors)
{
    int status = 0;
    char line[1024];
    unsigned line_number = 0;
    while (status == 0 && fgets(line, sizeof(line), input) != NULL)
    {
        char build[BUSTER_COUNTERS_NAME_BYTES];
        char placement[BUSTER_COUNTERS_NAME_BYTES];
        char mode[BUSTER_COUNTERS_NAME_BYTES];
        char run[BUSTER_COUNTERS_NAME_BYTES];
        char event[BUSTER_COUNTERS_NAME_BYTES];
        char value[BUSTER_COUNTERS_NAME_BYTES] = {0};
        char extra;
        line_number += 1;
        const int fields = expected
            ? sscanf(line, "%63s %63s %63s %63s %63s %c", build, placement, mode, run, event, &extra)
            : sscanf(line, "%63s %63s %63s %63s %63s %63s %c", build, placement, mode, run, event, value, &extra);
        if (fields != (expected ? 5 : 6) || (strchr(line, '\n') == NULL && !feof(input)))
        {
            fprintf(errors, "counters: %s line %u: expected BUILD PLACEMENT MODE RUN EVENT%s\n",
                    expected ? "manifest" : "counts", line_number, expected ? "" : " VALUE");
            status = 1;
        }
        else
        {
            const int b = name_index(&builds, build, expected);
            const int p = name_index(&placements, placement, expected);
            const int m = name_index(&modes, mode, expected);
            const int e = name_index(&events, event, expected);
            const uint32_t bit = run_bit(run);
            char* end = NULL;
            errno = 0;
            const double number = expected ? 1 : strtod(value, &end);
            if (b < 0 || p < 0 || m < 0 || e < 0 || bit == 0)
            {
                fprintf(errors, "counters: line %u: unknown name, too many names, or run outside 1..32\n", line_number);
                status = 1;
            }
            else if (!expected && (errno != 0 || end == value || *end != 0 || !isfinite(number) || number < 1 || number >= 0x1p64))
            {
                fprintf(errors, "counters: line %u: %s %s %s run %s: invalid count for %s (%s)\n",
                        line_number, build, placement, mode, run, event, value);
                status = 1;
            }
            else
            {
                Cell* cell = &cells[b][p][m][e];
                if ((expected && (cell->expected_runs & bit) != 0) ||
                    (!expected && ((cell->expected_runs & bit) == 0 || (cell->seen_runs & bit) != 0)))
                {
                    fprintf(errors, "counters: line %u: duplicate or unexpected sample: %s %s %s %s %s\n",
                            line_number, build, placement, mode, run, event);
                    status = 1;
                }
                else if (expected)
                {
                    cell->expected_runs |= bit;
                }
                else
                {
                    cell->least = cell->seen_runs == 0 || number < cell->least ? number : cell->least;
                    cell->seen_runs |= bit;
                }
            }
        }
    }
    if (ferror(input))
    {
        fprintf(errors, "counters: cannot read %s\n", expected ? "manifest" : "counts");
        status = 1;
    }
    return status;
}

// Every declared build must have the same complete set of modes, events, placements and repetitions.
static int check_grid(bool expected, FILE* errors)
{
    int status = 0;
    const uint32_t runs = cells[0][0][0][0].expected_runs;
    if (builds.count < 2 || runs == 0 || (runs & (runs + UINT32_C(1))) != 0)
    {
        fprintf(errors, "counters: need at least two builds and consecutive runs starting at 1\n");
        status = 1;
    }
    for (int b = 0; b < builds.count && status == 0; b += 1)
    {
        for (int p = 0; p < placements.count && status == 0; p += 1)
        {
            for (int m = 0; m < modes.count && status == 0; m += 1)
            {
                for (int e = 0; e < events.count && status == 0; e += 1)
                {
                    const Cell* cell = &cells[b][p][m][e];
                    const uint32_t actual = expected ? cell->expected_runs : cell->seen_runs;
                    if (actual != runs)
                    {
                        fprintf(errors, "counters: incomplete %s: %s %s %s %s (runs 0x%x, expected 0x%x)\n",
                                expected ? "manifest" : "counts", builds.names[b], placements.names[p],
                                modes.names[m], events.names[e], (unsigned)actual, (unsigned)runs);
                        status = 1;
                    }
                }
            }
        }
    }
    return status;
}

static int counters(FILE* manifest, FILE* input, FILE* output, FILE* errors)
{
    memset(&builds, 0, sizeof(builds));
    memset(&placements, 0, sizeof(placements));
    memset(&modes, 0, sizeof(modes));
    memset(&events, 0, sizeof(events));
    memset(cells, 0, sizeof(cells));
    int status = read_counts(manifest, true, errors);
    if (status == 0)
    {
        status = check_grid(true, errors);
    }
    if (status == 0)
    {
        status = read_counts(input, false, errors);
    }
    if (status == 0)
    {
        status = check_grid(false, errors);
    }
    if (status == 0)
    {
        fprintf(output, "Least of each placement's runs, mean over %d placements; the change against %s, and its range over each placement against each of %s's\n",
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
                    fprintf(output, "%-10s %-20s %-8s %16.0f\n", modes.names[mode], events.names[event], builds.names[0], reference);
                    for (int build = 1; build < builds.count; build += 1)
                    {
                        double mean = 0;
                        if (summarize(build, mode, event, &mean, &low, &high))
                        {
                            fprintf(output, "%-10s %-20s %-8s %16.0f %+8.3f%% (%+.3f%% to %+.3f%%)\n",
                                    modes.names[mode], events.names[event], builds.names[build], mean,
                                    (mean / reference - 1) * 100, low * 100, high * 100);
                        }
                    }
                }
            }
        }
        if (fflush(output) != 0 || ferror(output))
        {
            fprintf(errors, "counters: cannot write summary\n");
            status = 1;
        }
    }
    return status;
}

#ifndef BUSTER_COUNTERS_TEST
int main(int argc, char** argv)
{
    int status = 2;
    if (argc != 2)
    {
        fprintf(stderr, "usage: counters EXPECTED < counters.txt > counters-summary.txt\n");
    }
    else
    {
        FILE* manifest = fopen(argv[1], "r");
        if (manifest == NULL)
        {
            perror("counters: manifest");
        }
        else
        {
            status = counters(manifest, stdin, stdout, stderr);
            if (fclose(manifest) != 0)
            {
                perror("counters: close manifest");
                status = 1;
            }
        }
    }
    return status;
}
#endif
