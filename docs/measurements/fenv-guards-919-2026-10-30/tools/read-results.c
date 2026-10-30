// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original bounded reader for #919's shipping time-runs qualification. It accepts
// exactly 3 processes x 3 requested shifts x 3 source lists x 2 builds x 2 fresh
// copies x 21 samples. All records and completion markers must validate before
// any CSV is emitted. Caller-owned manifests bind source, input and image hashes.
// Wall values retain the producer's printed 1us precision. Combined 42-sample
// medians average the two middle values; per-copy medians each contain 21 samples.
#define _POSIX_C_SOURCE 200809L
#include <dirent.h>
#include <errno.h>
#include <float.h>
#include <inttypes.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RESULT_PROCESSES 3u
#define RESULT_LAYOUTS 3u
#define RESULT_SOURCES 3u
#define RESULT_BUILDS 2u
#define RESULT_COPIES 2u
#define RESULT_RUNS 21u
#define RESULT_FILE_SAMPLES (RESULT_SOURCES * RESULT_BUILDS * RESULT_COPIES * RESULT_RUNS)
#define RESULT_FILE_CAPACITY (UINT64_C(8) * 1024 * 1024)

// This x86-64 qualification reader needs exact integer and half-integer medians.
// Bounded signed-64-bit positive counters and >=64-bit precision also make each
// pair's sum exact before dividing by two. Real compile counts are far smaller.
_Static_assert(LDBL_MANT_DIG >= 64, "reader requires extended-precision long double");

static const uint32_t result_shifts[RESULT_LAYOUTS] = { 0, 64, 256 };
static const char* const result_sources[RESULT_SOURCES] = { "sqlite", "access-off", "access-on" };
static const char* const result_builds[RESULT_BUILDS] = { "base", "head" };

typedef struct ResultSample ResultSample;
struct ResultSample
{
    uint64_t wall_ns;
    uint64_t cycles;
    uint64_t instructions;
    bool seen;
};

static ResultSample result_samples[RESULT_PROCESSES][RESULT_LAYOUTS][RESULT_SOURCES][RESULT_BUILDS][RESULT_COPIES][RESULT_RUNS];

static bool result_filename(char* destination, size_t capacity, const char* directory, uint32_t process, uint32_t layout)
{
    const int written = snprintf(destination, capacity, "%s/time-p%u-s%u.log", directory, process + 1, result_shifts[layout]);
    const bool valid = written >= 0 && (size_t)written < capacity;
    return valid;
}

static bool result_directory(const char* path)
{
    DIR* directory = opendir(path);
    bool valid = directory != NULL;
    uint32_t found = 0;
    while (valid)
    {
        errno = 0;
        struct dirent* entry = readdir(directory);
        if (entry == NULL)
        {
            valid = errno == 0;
            break;
        }
        const size_t length = strlen(entry->d_name);
        if (length >= 10 && strncmp(entry->d_name, "time-p", 6) == 0 && strcmp(entry->d_name + length - 4, ".log") == 0)
        {
            bool expected = false;
            for (uint32_t process = 0; process < RESULT_PROCESSES; process += 1)
            {
                for (uint32_t layout = 0; layout < RESULT_LAYOUTS; layout += 1)
                {
                    char name[64];
                    const int written = snprintf(name, sizeof(name), "time-p%u-s%u.log", process + 1, result_shifts[layout]);
                    expected |= written > 0 && (size_t)written < sizeof(name) && strcmp(entry->d_name, name) == 0;
                }
            }
            valid = expected;
            found += expected;
        }
    }
    if (directory != NULL)
    {
        valid = closedir(directory) == 0 && valid;
    }
    valid = valid && found == RESULT_PROCESSES * RESULT_LAYOUTS;
    return valid;
}

static bool result_take(const char** cursor, const char* text)
{
    const size_t length = strlen(text);
    const bool valid = strncmp(*cursor, text, length) == 0;
    if (valid)
    {
        *cursor += length;
    }
    return valid;
}

// Parse decimal integers without scanf's undefined out-of-range conversions.
static bool result_unsigned(const char** cursor, uint64_t maximum, uint64_t* output)
{
    const char* input = *cursor;
    uint64_t value = 0;
    bool valid = *input >= '0' && *input <= '9';
    while (valid && *input >= '0' && *input <= '9')
    {
        const uint64_t digit = (uint64_t)(*input - '0');
        valid = value <= maximum / 10 && (value != maximum / 10 || digit <= maximum % 10);
        if (valid)
        {
            value = value * 10 + digit;
            input += 1;
        }
    }
    if (valid)
    {
        *cursor = input;
        *output = value;
    }
    return valid;
}

static bool result_decimal3(const char** cursor, uint64_t maximum_whole, uint64_t* output)
{
    uint64_t whole = 0;
    bool valid = result_unsigned(cursor, maximum_whole, &whole) && result_take(cursor, ".");
    uint64_t fraction = 0;
    for (uint32_t digit = 0; valid && digit < 3; digit += 1)
    {
        const char value = **cursor;
        valid = value >= '0' && value <= '9';
        if (valid)
        {
            fraction = fraction * 10 + (uint64_t)(value - '0');
            *cursor += 1;
        }
    }
    if (valid)
    {
        *output = whole * 1000 + fraction;
    }
    return valid;
}

// Producer values have exactly three decimal places in milliseconds: preserve
// those printed microseconds exactly, with no floating conversion or rounding.
static bool result_milliseconds(const char** cursor, uint64_t* output)
{
    uint64_t microseconds = 0;
    const bool valid = result_decimal3(cursor, UINT64_C(3600000), &microseconds) && microseconds <= UINT64_C(3600000000);
    if (valid)
    {
        *output = microseconds * 1000;
    }
    return valid;
}

static bool result_build(const char** cursor, uint32_t* build)
{
    const bool base = result_take(cursor, "base");
    const bool valid = base || result_take(cursor, "head");
    *build = base ? 0 : 1;
    return valid;
}

static bool result_record(const char* line, uint32_t process, uint32_t layout)
{
    const char* cursor = line;
    uint64_t run = 0;
    uint64_t list = 0;
    uint64_t copy = 0;
    uint32_t build = 0;
    uint64_t wall_ns = 0;
    uint64_t ignored = 0;
    uint64_t cycles = 0;
    uint64_t instructions = 0;
    bool valid = result_take(&cursor, "run ") && result_unsigned(&cursor, RESULT_RUNS, &run) && run != 0 &&
                 result_take(&cursor, " list ") && result_unsigned(&cursor, RESULT_SOURCES, &list) && list != 0 &&
                 result_take(&cursor, " ") && result_build(&cursor, &build) && result_take(&cursor, " copy ") &&
                 result_unsigned(&cursor, RESULT_COPIES, &copy) && copy != 0 && result_take(&cursor, ": ") &&
                 result_milliseconds(&cursor, &wall_ns) && wall_ns != 0 && result_take(&cursor, " ms wall, ") &&
                 result_milliseconds(&cursor, &ignored) && result_take(&cursor, " ms user, ") &&
                 result_milliseconds(&cursor, &ignored) && result_take(&cursor, " ms system, ") &&
                 result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " KiB wait4 peak, ") &&
                 result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " minor faults, ") &&
                 result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " major, ") &&
                 result_unsigned(&cursor, INT64_MAX, &cycles) && cycles != 0 && result_take(&cursor, " user cycles, ") &&
                 result_unsigned(&cursor, INT64_MAX, &instructions) && instructions != 0 &&
                 result_take(&cursor, " instructions, status 0\n") && *cursor == '\0';
    if (valid)
    {
        ResultSample* sample = &result_samples[process][layout][list - 1][build][copy - 1][run - 1];
        valid = !sample->seen;
        if (valid)
        {
            sample->wall_ns = wall_ns;
            sample->cycles = cycles;
            sample->instructions = instructions;
            sample->seen = true;
        }
    }
    return valid;
}

static bool result_percent(const char** cursor, bool sign)
{
    if (sign && !result_take(cursor, "+") && !result_take(cursor, "-"))
    {
        return false;
    }
    uint64_t ignored = 0;
    bool valid = result_unsigned(cursor, UINT64_MAX, &ignored) && result_take(cursor, ".");
    for (uint32_t digit = 0; valid && digit < 2; digit += 1)
    {
        valid = **cursor >= '0' && **cursor <= '9';
        *cursor += valid;
    }
    return valid && result_take(cursor, "%");
}

// Only the first-party producer's known auxiliary report shapes are permitted.
// Their medians are not used: all reported values are recomputed from raw rows.
static bool result_auxiliary(const char* line, uint32_t process)
{
    const char* cursor = line;
    uint64_t list = 0;
    uint64_t copy = 0;
    uint64_t ignored = 0;
    uint32_t build = 0;
    bool valid = false;
    if (result_take(&cursor, "list ") && result_unsigned(&cursor, RESULT_SOURCES, &list) && list != 0)
    {
        if (*cursor == ',')
        {
            valid = (result_take(&cursor, ", wall time (ms):\n") || result_take(&cursor, ", user cycles (millions):\n")) && *cursor == '\0';
        }
        else if (result_take(&cursor, " ") && result_build(&cursor, &build) && result_take(&cursor, " copy ") &&
                 result_unsigned(&cursor, RESULT_COPIES, &copy) && copy != 0 && result_take(&cursor, " ["))
        {
            const char* arguments_end = strstr(cursor, "]: 21 runs, median ");
            if (arguments_end != NULL)
            {
                cursor = arguments_end + strlen("]: 21 runs, median ");
                valid = result_milliseconds(&cursor, &ignored) && result_take(&cursor, " ms wall (") &&
                        result_milliseconds(&cursor, &ignored) && result_take(&cursor, " to ") &&
                        result_milliseconds(&cursor, &ignored) && result_take(&cursor, "), ") &&
                        result_milliseconds(&cursor, &ignored) && result_take(&cursor, " ms user, ") &&
                        result_milliseconds(&cursor, &ignored) && result_take(&cursor, " ms system, ") &&
                        result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " KiB wait4 peak, ") &&
                        result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " minor faults, ") &&
                        result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " major, ") &&
                        result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " user cycles, ") &&
                        result_unsigned(&cursor, UINT64_MAX, &ignored) && result_take(&cursor, " instructions\n") && *cursor == '\0';
            }
        }
    }
    else
    {
        cursor = line;
        if (result_take(&cursor, "  ") && result_build(&cursor, &build) && result_take(&cursor, ": 42 runs, median "))
        {
            valid = result_decimal3(&cursor, UINT64_MAX / 1000 - 1, &ignored) && result_take(&cursor, "; copies within ") && result_percent(&cursor, false);
            const uint32_t reference = process == 1 ? 1 : 0;
            if (valid && build != reference)
            {
                valid = result_take(&cursor, reference == 0 ? "; against base " : "; against head ") && result_percent(&cursor, true) && result_take(&cursor, " (over copies ") &&
                        result_percent(&cursor, true) && result_take(&cursor, " to ") && result_percent(&cursor, true) && result_take(&cursor, ")");
            }
            valid = valid && result_take(&cursor, "\n") && *cursor == '\0';
        }
    }
    return valid;
}

static bool result_file(const char* path, uint32_t process, uint32_t layout)
{
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    char line[8192];
    uint32_t records = 0;
    uint32_t completions = 0;
    uint64_t bytes = 0;
    uint32_t line_number = 0;
    bool memory_header = false;
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        line_number += 1;
        const size_t length = strlen(line);
        bytes += length;
        valid = length != 0 && line[length - 1] == '\n' && bytes <= RESULT_FILE_CAPACITY;
        valid = valid && completions == 0;
        if (valid && strncmp(line, "run ", 4) == 0)
        {
            valid = completions == 0 && result_record(line, process, layout);
            records += valid;
        }
        else if (valid && strncmp(line, "time-runs: done,", strlen("time-runs: done,")) == 0)
        {
            valid = strcmp(line, "time-runs: done, 0 failed processes\n") == 0 && records == RESULT_FILE_SAMPLES && completions == 0;
            completions += valid;
        }
        else if (valid && strcmp(line, "memory: wait4 peaks include pre-exec memory and waited descendants; executable-only peak unavailable (not measured)\n") == 0)
        {
            valid = !memory_header && records == 0;
            memory_header = true;
        }
        else if (valid)
        {
            valid = records == RESULT_FILE_SAMPLES && strstr(line, "uncounted") == NULL && strstr(line, "FAILED") == NULL && result_auxiliary(line, process);
        }
    }
    if (file != NULL)
    {
        const bool clean = !ferror(file);
        valid = fclose(file) == 0 && clean && valid;
    }
    valid = valid && records == RESULT_FILE_SAMPLES && completions == 1;
    if (!valid)
    {
        fprintf(stderr, "result reader refused %s at/before line %u: incomplete, duplicated, failed, uncounted or malformed data\n", path, line_number);
    }
    return valid;
}

static uint64_t result_field(const ResultSample* sample, uint32_t field)
{
    const uint64_t value = field == 0 ? sample->wall_ns : field == 1 ? sample->cycles : sample->instructions;
    return value;
}

static long double result_median(const ResultSample samples[RESULT_COPIES][RESULT_RUNS], uint32_t field, uint32_t first_copy, uint32_t copies)
{
    uint64_t values[RESULT_COPIES * RESULT_RUNS];
    uint32_t count = 0;
    for (uint32_t copy = first_copy; copy < first_copy + copies; copy += 1)
    {
        for (uint32_t run = 0; run < RESULT_RUNS; run += 1)
        {
            const uint64_t value = result_field(&samples[copy][run], field);
            uint32_t place = count;
            while (place != 0 && values[place - 1] > value)
            {
                values[place] = values[place - 1];
                place -= 1;
            }
            values[place] = value;
            count += 1;
        }
    }
    const long double median = count % 2 == 0 ? ((long double)values[count / 2 - 1] + (long double)values[count / 2]) / 2 : (long double)values[count / 2];
    return median;
}

static void result_write_samples(void)
{
    printf("process,requested_shift,source,build,copy,run,wall_ns_from_printed_1us_values,user_cycles,instructions\n");
    for (uint32_t process = 0; process < RESULT_PROCESSES; process += 1)
    {
        for (uint32_t layout = 0; layout < RESULT_LAYOUTS; layout += 1)
        {
            for (uint32_t source = 0; source < RESULT_SOURCES; source += 1)
            {
                for (uint32_t build = 0; build < RESULT_BUILDS; build += 1)
                {
                    for (uint32_t copy = 0; copy < RESULT_COPIES; copy += 1)
                    {
                        for (uint32_t run = 0; run < RESULT_RUNS; run += 1)
                        {
                            const ResultSample* sample = &result_samples[process][layout][source][build][copy][run];
                            printf("%u,%u,%s,%s,%u,%u,%" PRIu64 ",%" PRIu64 ",%" PRIu64 "\n", process + 1, result_shifts[layout], result_sources[source], result_builds[build], copy + 1, run + 1, sample->wall_ns, sample->cycles, sample->instructions);
                        }
                    }
                }
            }
        }
    }
}

static void result_write_medians(void)
{
    printf("process,requested_shift,source,build,copies,samples,median_wall_ns_from_printed_1us_values,median_user_cycles,median_instructions,copy1_median_wall_ns,copy2_median_wall_ns,copy1_median_user_cycles,copy2_median_user_cycles,copy1_median_instructions,copy2_median_instructions,head_vs_base_wall_percent,head_vs_base_cycles_percent,head_vs_base_instructions_percent\n");
    for (uint32_t process = 0; process < RESULT_PROCESSES; process += 1)
    {
        for (uint32_t layout = 0; layout < RESULT_LAYOUTS; layout += 1)
        {
            for (uint32_t source = 0; source < RESULT_SOURCES; source += 1)
            {
                long double reference[3];
                for (uint32_t field = 0; field < 3; field += 1)
                {
                    reference[field] = result_median(result_samples[process][layout][source][0], field, 0, RESULT_COPIES);
                }
                for (uint32_t build = 0; build < RESULT_BUILDS; build += 1)
                {
                    const ResultSample (*samples)[RESULT_RUNS] = result_samples[process][layout][source][build];
                    long double medians[3];
                    for (uint32_t field = 0; field < 3; field += 1)
                    {
                        medians[field] = result_median(samples, field, 0, RESULT_COPIES);
                    }
                    printf("%u,%u,%s,%s,%u,%u,%.1Lf,%.1Lf,%.1Lf,%.1Lf,%.1Lf,%.1Lf,%.1Lf,%.1Lf,%.1Lf,%.9Lf,%.9Lf,%.9Lf\n",
                           process + 1, result_shifts[layout], result_sources[source], result_builds[build], RESULT_COPIES, RESULT_COPIES * RESULT_RUNS,
                           medians[0], medians[1], medians[2], result_median(samples, 0, 0, 1), result_median(samples, 0, 1, 1),
                           result_median(samples, 1, 0, 1), result_median(samples, 1, 1, 1), result_median(samples, 2, 0, 1), result_median(samples, 2, 1, 1),
                           100 * (medians[0] / reference[0] - 1), 100 * (medians[1] / reference[1] - 1), 100 * (medians[2] / reference[2] - 1));
                }
            }
        }
    }
}

int main(int argc, char** argv)
{
    const bool raw = argc == 3 && strcmp(argv[2], "--samples") == 0;
    bool valid = (argc == 2 || raw) && result_directory(argv[1]);
    for (uint32_t process = 0; valid && process < RESULT_PROCESSES; process += 1)
    {
        for (uint32_t layout = 0; valid && layout < RESULT_LAYOUTS; layout += 1)
        {
            char path[PATH_MAX];
            valid = result_filename(path, sizeof(path), argv[1], process, layout) && result_file(path, process, layout);
        }
    }
    if (valid)
    {
        if (raw)
        {
            result_write_samples();
        }
        else
        {
            result_write_medians();
        }
        valid = fflush(stdout) == 0 && !ferror(stdout);
    }
    if (!valid)
    {
        fprintf(stderr, "usage: read-results DIRECTORY [--samples]; requires nine time-pP-sS.log files, 2,268 successful counted samples and nine clean completion markers\n");
    }
    return valid ? 0 : 1;
}
