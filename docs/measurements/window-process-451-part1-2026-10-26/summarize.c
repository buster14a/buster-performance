// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original Buster #451 part 1 report reader. Reads only completed exit=0 logs; verifies timed process statuses,
// retains round medians, and summarizes their medians and ranges. EXPECTED_ROUNDS=0 permits a partial snapshot.
// Usage: summarize RAW_DIRECTORY OUTPUT_PREFIX EXPECTED_ROUNDS
#define _POSIX_C_SOURCE 200809L
#include <dirent.h>
#include <errno.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum
{
    PROCESS,
    PHASE,
    MAX_ROWS = 128,
    MAX_FIELDS = 15
};
static const char* const process_fields[] =
{
    "wall_ms",
    "wall_min_ms",
    "wall_max_ms",
    "user_ms",
    "system_ms",
    "peak_kib",
    "minor_faults",
    "major_faults"
};
static const char* const phase_fields[] =
{
    "total_ms",
    "cycles_per_input",
    "cycles_per_output",
    "instructions_per_input",
    "ipc",
    "read_ms",
    "lex_ms",
    "refine_ms",
    "directives_ms",
    "main_setup_ms",
    "release_ms",
    "with_printing_ms",
    "printing_ms",
    "input_tokens",
    "output_tokens"
};
typedef struct Row Row;
struct Row
{
    unsigned kind;
    char workload[64];
    unsigned round;
    unsigned whole;
    unsigned passes;
    double values[MAX_FIELDS];
};
static Row rows[MAX_ROWS];
static unsigned row_count;

static int compare_double(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static int compare_row(const void* a, const void* b)
{
    const Row* x = a;
    const Row* y = b;
    int result = (x->kind > y->kind) - (x->kind < y->kind);
    if (result == 0)
    {
        result = strcmp(x->workload, y->workload);
    }
    if (result == 0)
    {
        result = (x->round > y->round) - (x->round < y->round);
    }
    if (result == 0)
    {
        result = (x->whole > y->whole) - (x->whole < y->whole);
    }
    return result;
}

static bool read_log(const char* path, unsigned kind, const char* workload, unsigned round, unsigned whole)
{
    FILE* file = fopen(path, "r");
    Row found[2] =
    {
        {
            .kind = kind,
            .round = round,
            .whole = whole
        }
    };
    unsigned count = 0;
    unsigned timed = 0;
    unsigned phase_parts = 0;
    bool done = false;
    bool statuses = true;
    bool complete = false;
    bool failed_exit = false;
    char line[16384];
    bool result = file != 0;
    while (file != 0 && fgets(line, sizeof(line), file) != 0)
    {
        complete = strncmp(line, "exit=0 end:", 11) == 0;
        failed_exit |= strncmp(line, "exit=", 5) == 0 && !complete;
        if (kind == PROCESS && strncmp(line, "run ", 4) == 0)
        {
            const char* status = strstr(line, ", status ");
            int value = -1;
            statuses = statuses && status != 0 && sscanf(status, ", status %d", &value) == 1 && value == 0;
            timed += 1;
        }
        done |= strcmp(line, "time-runs: done, 0 failed processes\n") == 0;
        const char* summary = kind == PROCESS && strncmp(line, "list ", 5) == 0 ? strstr(line, "]: ") : 0;
        if (summary != 0 && count < 2)
        {
            Row* row = &found[count];
            row->kind = kind;
            row->round = round;
            row->whole = strstr(line, "--window-bytes 2000000000") != 0;
            double* v = row->values;
            const int fields =
                sscanf(summary, "]: %u runs, median %lf ms wall (%lf to %lf), %lf ms user, %lf ms system, %lf KB peak, %lf minor faults, %lf major",
                       &row->passes, &v[0], &v[1], &v[2], &v[3], &v[4], &v[5], &v[6], &v[7]);
            statuses = statuses && fields == 9 && row->passes == 21;
            count += 1;
        }
        if (kind == PHASE)
        {
            double* v = found[0].values;
            if (sscanf(line, "1 files, %lf input tokens, %lf output tokens; %u passes, medians:", &v[13], &v[14], &found[0].passes) == 3)
            {
                phase_parts |= 1;
            }
            if (sscanf(line, " vectorized %lf ms %lf cycles/input token %lf cycles/output token %lf instructions/input token IPC %lf", &v[0], &v[1], &v[2],
                       &v[3], &v[4]) == 5)
            {
                phase_parts |= 2;
            }
            if (sscanf(line, " read %lf ms lex %lf ms refine %lf ms directives %lf ms main loop/setup %lf ms", &v[5], &v[6], &v[7], &v[8], &v[9]) == 5)
            {
                phase_parts |= 4;
            }
            if (sscanf(line, " then the release %lf ms", &v[10]) == 1)
            {
                phase_parts |= 8;
            }
            if (sscanf(line, " -E -P with printing %lf ms (printing %lf ms)", &v[11], &v[12]) == 2)
            {
                phase_parts |= 16;
            }
        }
    }
    if (file != 0)
    {
        result = fclose(file) == 0 && result;
    }
    result = result && !failed_exit;
    if (result && complete)
    {
        count = kind == PHASE ? 1 : count;
        result = statuses && (kind == PROCESS ? count == 2 && timed == 42 && done : phase_parts == 31 && found[0].passes == 21);
        if (!result)
        {
            fprintf(stderr, "invalid completed report: %s\n", path);
        }
        for (unsigned i = 0; result && i < count; i += 1)
        {
            for (unsigned f = 0; f < (kind == PROCESS ? 8u : 15u); f += 1)
            {
                result = result && isfinite(found[i].values[f]) && found[i].values[f] >= 0;
            }
            snprintf(found[i].workload, sizeof(found[i].workload), "%s", workload);
            result = row_count < MAX_ROWS;
            if (result)
            {
                rows[row_count++] = found[i];
            }
        }
    }
    return result;
}

static bool read_directory(const char* path)
{
    DIR* directory = opendir(path);
    bool result = directory != 0;
    for (struct dirent* entry = directory != 0 ? readdir(directory) : 0; result && entry != 0; entry = readdir(directory))
    {
        unsigned round = 0;
        char workload[64];
        char variant[16];
        int used = 0;
        bool wanted = false;
        unsigned kind = PROCESS;
        unsigned whole = 0;
        if (sscanf(entry->d_name, "process-%u-%63[^.].log%n", &round, workload, &used) == 2 && entry->d_name[used] == 0)
        {
            wanted = strcmp(workload, "sqlite-e") == 0 || strcmp(workload, "sqlite-check") == 0 || strcmp(workload, "main-e") == 0 ||
                     strcmp(workload, "main-parse") == 0;
        }
        else if (sscanf(entry->d_name, "phase-%u-%63[^-]-%15[^.].log%n", &round, workload, variant, &used) == 3 && entry->d_name[used] == 0)
        {
            kind = PHASE;
            whole = strcmp(variant, "whole") == 0;
            wanted = (strcmp(workload, "sqlite") == 0 || strcmp(workload, "main") == 0) && (whole || strcmp(variant, "windows") == 0);
        }
        if (wanted)
        {
            char file[4096];
            result = snprintf(file, sizeof(file), "%s/%s", path, entry->d_name) < (int)sizeof(file) && round > 0;
            if (result)
            {
                result = read_log(file, kind, workload, round, whole);
            }
        }
    }
    if (directory != 0)
    {
        result = closedir(directory) == 0 && result;
    }
    qsort(rows, row_count, sizeof(rows[0]), compare_row);
    for (unsigned i = 1; result && i < row_count; i += 1)
    {
        result = compare_row(&rows[i - 1], &rows[i]) != 0;
    }
    for (unsigned i = 0; result && i < row_count; i += 1)
    {
        for (unsigned j = i + 1; result && rows[i].kind == PHASE && j < row_count; j += 1)
        {
            if (rows[j].kind == PHASE && strcmp(rows[i].workload, rows[j].workload) == 0)
            {
                result = rows[i].values[13] == rows[j].values[13] && rows[i].values[14] == rows[j].values[14];
            }
        }
    }
    return result;
}

static FILE* output_file(const char* prefix, const char* suffix)
{
    char path[4096];
    FILE* result = 0;
    if (snprintf(path, sizeof(path), "%s%s", prefix, suffix) < (int)sizeof(path))
    {
        result = fopen(path, "w");
    }
    return result;
}

static bool report(const char* prefix, unsigned expected)
{
    FILE* process = output_file(prefix, "-process-rounds.tsv");
    FILE* phase = output_file(prefix, "-phase-rounds.tsv");
    FILE* summary = output_file(prefix, "-summary.tsv");
    FILE* comparison = output_file(prefix, "-comparison.tsv");
    FILE* outputs[] =
    {
        process,
        phase,
        summary,
        comparison
    };
    bool result = process != 0 && phase != 0 && summary != 0 && comparison != 0;
    if (result)
    {
        for (unsigned kind = PROCESS; kind <= PHASE; kind += 1)
        {
            FILE* file = kind == PROCESS ? process : phase;
            const char* const* fields = kind == PROCESS ? process_fields : phase_fields;
            const unsigned count = kind == PROCESS ? 8 : 15;
            fprintf(file, "workload\tround\tvariant\tpasses");
            for (unsigned field = 0; field < count; field += 1)
            {
                fprintf(file, "\t%s", fields[field]);
            }
            fprintf(file, "\n");
            for (unsigned i = 0; i < row_count; i += 1)
            {
                const Row* row = &rows[i];
                if (row->kind == kind)
                {
                    fprintf(file, "%s\t%u\t%s\t%u", row->workload, row->round, row->whole ? "whole" : "windows", row->passes);
                    for (unsigned field = 0; field < count; field += 1)
                    {
                        fprintf(file, "\t%.6f", row->values[field]);
                    }
                    fprintf(file, "\n");
                }
            }
        }
        fprintf(summary, "kind\tworkload\tvariant\tmetric\trounds\tmedian\tminimum\tmaximum\n");
        fprintf(comparison, "kind\tworkload\tmetric\twhole\twindows\tdifference\tpercent\n");
        static const char* const workloads[] =
        {
            "sqlite-e",
            "sqlite-check",
            "main-e",
            "main-parse",
            "sqlite",
            "main"
        };
        for (unsigned w = 0; result && w < 6; w += 1)
        {
            const unsigned kind = w < 4 ? PROCESS : PHASE;
            const unsigned count = kind == PROCESS ? 8 : 15;
            const char* const* fields = kind == PROCESS ? process_fields : phase_fields;
            double medians[2][MAX_FIELDS] = {{0}};
            unsigned sizes[2] = {0};
            for (unsigned whole = 0; result && whole < 2; whole += 1)
            {
                for (unsigned field = 0; field < count; field += 1)
                {
                    double values[MAX_ROWS];
                    unsigned n = 0;
                    for (unsigned i = 0; i < row_count; i += 1)
                    {
                        const Row* row = &rows[i];
                        if (row->kind == kind && row->whole == whole && strcmp(row->workload, workloads[w]) == 0)
                        {
                            values[n++] = row->values[field];
                            result = result && (expected == 0 || row->round <= expected);
                        }
                    }
                    sizes[whole] = n;
                    result = result && (expected == 0 || n == expected);
                    if (n != 0)
                    {
                        qsort(values, n, sizeof(values[0]), compare_double);
                        medians[whole][field] = values[n / 2];
                        fprintf(summary, "%s\t%s\t%s\t%s\t%u\t%.6f\t%.6f\t%.6f\n", kind == PROCESS ? "process" : "phase", workloads[w],
                                whole ? "whole" : "windows", fields[field], n, values[n / 2], values[0], values[n - 1]);
                    }
                }
            }
            for (unsigned field = 0; sizes[0] != 0 && sizes[1] != 0 && field < count; field += 1)
            {
                const double whole = medians[1][field];
                const double windows = medians[0][field];
                fprintf(comparison, "%s\t%s\t%s\t%.6f\t%.6f\t%.6f\t", kind == PROCESS ? "process" : "phase", workloads[w], fields[field], whole, windows,
                        windows - whole);
                if (whole != 0)
                {
                    fprintf(comparison, "%.6f\n", 100.0 * (windows / whole - 1));
                }
                else
                {
                    fprintf(comparison, "n/a\n");
                }
            }
        }
    }
    for (unsigned i = 0; i < 4; i += 1)
    {
        if (outputs[i] != 0)
        {
            result = fclose(outputs[i]) == 0 && result;
        }
    }
    return result;
}

int main(int argc, char** argv)
{
    char* end = 0;
    errno = 0;
    const unsigned long expected = argc == 4 ? strtoul(argv[3], &end, 10) : 0;
    const bool arguments = argc == 4 && end != argv[3] && *end == 0 && errno == 0 && expected <= 8;
    const bool read = arguments && read_directory(argv[1]);
    const bool passed = read && report(argv[2], (unsigned)expected);
    if (!passed)
    {
        fprintf(stderr, "summarize: failed (usage: RAW_DIRECTORY OUTPUT_PREFIX EXPECTED_ROUNDS; 0 permits partial snapshots)\n");
    }
    else
    {
        printf("summarize: %u completed rows; expected rounds %lu; statuses passed\n", row_count, expected);
    }
    return passed ? 0 : 1;
}
