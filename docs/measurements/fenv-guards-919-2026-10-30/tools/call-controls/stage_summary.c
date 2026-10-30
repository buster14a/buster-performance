// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original fixed-grid reader for first-party measure-compile reports.
// A zero-failure terminal report implies every child succeeded, every staged
// report was whole, and default/staged objects matched after every round.
#define _POSIX_C_SOURCE 200809L
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RUNS 21
#define ROLES 3
#define STAGES 27
#define FILE_LIMIT (1024 * 1024)

static const char* const roles[ROLES] = { "default", "time-stages", "reference" };
static const char* const stage_names[STAGES] = {
    "setup", "preprocess", "parse", "type-table", "check-input", "check-expressions", "check-declarations", "static-data",
    "check-program", "select", "backend-setup", "lower", "tier0", "emit-setup", "lanes", "branch-sizing", "encode", "unwind",
    "code-atoms", "debug", "publish-data", "object-build", "object-write", "runtime", "executable", "write", "release"
};
static const char* const phases[5] = { "preprocess.read", "preprocess.lex", "preprocess.refine", "preprocess.directives", "preprocess.main-loop" };

typedef struct Report Report;
struct Report
{
    double samples[ROLES][RUNS][6];
    bool seen[ROLES][RUNS];
    double medians[ROLES][6];
    bool summaries[ROLES];
    double stages[STAGES];
    double stage_shares[STAGES];
    double span;
    double sum;
    unsigned rows;
    unsigned phase_rows;
    unsigned raw_rows;
    unsigned memory_rows;
    unsigned system_rows;
    bool header;
    bool cost;
    bool comparison;
    bool stage_header;
    bool span_seen;
    bool outside;
    bool ranked;
    bool complete;
};

static void spaces(const char** cursor)
{
    while (**cursor == ' ' || **cursor == '\t') { *cursor += 1; }
}

static bool literal(const char** cursor, const char* text)
{
    const size_t length = strlen(text);
    const bool valid = strncmp(*cursor, text, length) == 0;
    *cursor += valid ? length : 0;
    return valid;
}

static bool end(const char* cursor)
{
    spaces(&cursor);
    return *cursor == 0;
}

static bool integer(const char** cursor, uint64_t* value)
{
    uint64_t result = 0;
    bool valid = isdigit((unsigned char)**cursor);
    while (valid && isdigit((unsigned char)**cursor))
    {
        const unsigned digit = (unsigned)(**cursor - '0');
        valid = result <= (UINT64_MAX - digit) / 10;
        if (valid) { result = result * 10 + digit; *cursor += 1; }
    }
    *value = result;
    return valid;
}

static bool number(const char** cursor, unsigned places, bool negative, double* value)
{
    const char* start = *cursor;
    if (negative && **cursor == '-') { *cursor += 1; }
    uint64_t whole = 0;
    bool valid = integer(cursor, &whole) && whole <= UINT64_C(1000000000000000);
    if (places != 0) { valid = valid && literal(cursor, "."); }
    for (unsigned i = 0; valid && i < places; i += 1)
    {
        valid = isdigit((unsigned char)**cursor);
        *cursor += valid;
    }
    if (valid)
    {
        char* finish = NULL;
        errno = 0;
        *value = strtod(start, &finish);
        valid = errno == 0 && finish == *cursor && isfinite(*value);
    }
    return valid;
}

static bool token(const char** cursor, char* output, size_t capacity)
{
    size_t size = 0;
    while (**cursor != 0 && !isspace((unsigned char)**cursor) && **cursor != ':')
    {
        if (size + 1 >= capacity) { break; }
        output[size++] = **cursor;
        *cursor += 1;
    }
    output[size] = 0;
    return size != 0;
}

static int named(const char* name, const char* const* names, unsigned count)
{
    int result = -1;
    for (unsigned i = 0; i < count; i += 1) { if (strcmp(name, names[i]) == 0) { result = (int)i; } }
    return result;
}

static double median(double values[RUNS])
{
    for (unsigned i = 1; i < RUNS; i += 1)
    {
        const double value = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > value) { values[j] = values[j - 1]; j -= 1; }
        values[j] = value;
    }
    return values[RUNS / 2];
}

static bool close_value(double a, double b, double tolerance)
{
    return fabs(a - b) <= tolerance;
}

static bool run_row(Report* report, const char* line)
{
    const char* c = line;
    uint64_t run = 0;
    uint64_t counters[3];
    double values[6];
    char role_name[32];
    bool valid = !report->stage_header && !report->summaries[0] && !report->summaries[1] && !report->summaries[2] &&
                 literal(&c, "run ") && integer(&c, &run) && literal(&c, " ") && token(&c, role_name, sizeof(role_name));
    const int role = valid ? named(role_name, roles, ROLES) : -1;
    valid = valid && role >= 0 && run > 0 && run <= RUNS && !report->seen[role][run - 1] && literal(&c, ": ") &&
            number(&c, 3, false, values) && literal(&c, " ms wall, ") && number(&c, 3, false, values + 1) && literal(&c, " ms user, ") &&
            number(&c, 3, false, values + 2) && literal(&c, " ms system, ") && integer(&c, counters) && literal(&c, " KiB wait4 peak, ") &&
            integer(&c, counters + 1) && literal(&c, " minor faults, ") && integer(&c, counters + 2) && literal(&c, " major") && end(c);
    valid = valid && values[0] > 0;
    if (valid)
    {
        for (unsigned i = 0; i < 3; i += 1) { values[i + 3] = (double)counters[i]; }
        memcpy(report->samples[role][run - 1], values, sizeof(values));
        report->seen[role][run - 1] = true;
        report->raw_rows += 1;
    }
    return valid;
}

static bool summary_row(Report* report, unsigned role, const char* c)
{
    uint64_t count = 0;
    double values[6];
    double low = 0;
    double high = 0;
    bool valid = report->raw_rows == ROLES * RUNS && !report->summaries[role] && !report->stage_header &&
                 literal(&c, roles[role]) && literal(&c, ": median of ") && integer(&c, &count) && count == RUNS && literal(&c, ": ") &&
                 number(&c, 3, false, values) && literal(&c, " ms wall (") && number(&c, 3, false, &low) && literal(&c, " to ") &&
                 number(&c, 3, false, &high) && literal(&c, "), ") && number(&c, 3, false, values + 1) && literal(&c, " ms user, ") &&
                 number(&c, 3, false, values + 2) && literal(&c, " ms system, ") && number(&c, 0, false, values + 3) &&
                 literal(&c, " KiB wait4 peak, ") && number(&c, 0, false, values + 4) && literal(&c, " minor faults, ") &&
                 number(&c, 0, false, values + 5) && literal(&c, " major") && end(c);
    for (unsigned field = 0; valid && field < 6; field += 1)
    {
        double raw[RUNS];
        for (unsigned r = 0; r < RUNS; r += 1) { raw[r] = report->samples[role][r][field]; }
        valid = close_value(values[field], median(raw), 0.000001) &&
                (field != 0 || (close_value(low, raw[0], 0.000001) && close_value(high, raw[RUNS - 1], 0.000001)));
    }
    if (valid) { memcpy(report->medians[role], values, sizeof(values)); report->summaries[role] = true; }
    return valid;
}

static bool stage_row(Report* report, const char* line)
{
    const char* c = line;
    char name[32] = { 0 };
    spaces(&c);
    bool valid = report->stage_header && !report->span_seen && token(&c, name, sizeof(name));
    spaces(&c);
    double middle = 0;
    double low = 0;
    double high = 0;
    double share = 0;
    valid = valid && number(&c, 3, false, &middle);
    spaces(&c);
    valid = valid && literal(&c, "(") && number(&c, 3, false, &low) && literal(&c, " to ") && number(&c, 3, false, &high) && literal(&c, ")");
    spaces(&c);
    valid = valid && number(&c, 1, false, &share) && literal(&c, "%") && low <= middle && middle <= high && share <= 100.1;
    const bool phase = strncmp(name, "preprocess.", strlen("preprocess.")) == 0;
    if (phase)
    {
        valid = valid && report->rows == 2 && report->phase_rows < 5 && strcmp(name, phases[report->phase_rows]) == 0 && end(c);
        report->phase_rows += valid;
    }
    else
    {
        double system = 0;
        double faults = 0;
        double peak = 0;
        spaces(&c);
        valid = valid && report->rows < STAGES && strcmp(name, stage_names[report->rows]) == 0 && (report->rows < 2 || report->phase_rows == 5) &&
                number(&c, 3, false, &system);
        spaces(&c);
        valid = valid && number(&c, 0, false, &faults);
        spaces(&c);
        valid = valid && number(&c, 0, true, &peak) && peak >= -1 && end(c);
        if (valid)
        {
            report->stages[report->rows] = middle;
            report->stage_shares[report->rows] = share;
            report->sum += middle;
            report->rows += 1;
        }
    }
    return valid;
}

static bool span_row(Report* report, const char* c, bool outside)
{
    double low = 0;
    double high = 0;
    double middle = 0;
    spaces(&c);
    bool valid = report->rows == STAGES && report->phase_rows == 5 && !report->outside && (!report->span_seen || outside) &&
                 literal(&c, outside ? "outside" : "span");
    spaces(&c);
    valid = valid && number(&c, 3, outside, &middle);
    spaces(&c);
    valid = valid && literal(&c, "(") && number(&c, 3, outside, &low) && literal(&c, " to ") && number(&c, 3, outside, &high) &&
            literal(&c, ")") && low <= middle && middle <= high;
    spaces(&c);
    if (outside)
    {
        valid = valid && report->span_seen && literal(&c, "the process's wall time outside the span") && end(c);
        report->outside = valid;
    }
    else
    {
        double sum = 0;
        valid = valid && literal(&c, "the stages' medians add up to ") && number(&c, 3, false, &sum) && end(c) && middle > 0 &&
                close_value(sum, report->sum, (STAGES + 1) * 0.000501);
        if (valid)
        {
            report->span = middle;
            report->span_seen = true;
            for (unsigned i = 0; valid && i < STAGES; i += 1)
            {
                const double uncertainty = 0.051 + 0.000501 * (100 / middle + report->stages[i] * 100 / (middle * middle));
                valid = report->stages[i] <= middle + 0.000501 &&
                        close_value(report->stage_shares[i], report->stages[i] * 100 / middle, uncertainty);
            }
        }
    }
    return valid;
}

static bool parse_line(Report* r, const char* line)
{
    bool valid = !r->complete;
    const char* c = line;
    if (strncmp(c, "measure-compile: ", 17) == 0 && strstr(c, "warm-ups,") != NULL)
    {
        uint64_t warmups = 0;
        uint64_t runs = 0;
        char reference[4096] = { 0 };
        valid = valid && !r->header && literal(&c, "measure-compile: ") && integer(&c, &warmups) && warmups == 2 && literal(&c, " warm-ups, ") &&
                integer(&c, &runs) && runs == RUNS && literal(&c, " runs, reference ") && token(&c, reference, sizeof(reference));
        const size_t length = strlen(reference);
        valid = valid && length > 1 && reference[length - 1] == ',' && strcmp(reference, "none,") != 0 && literal(&c, " in ") && *c != 0;
        r->header = valid;
    }
    else if (!r->header) { valid = valid && *line != 0; }
    else if (strncmp(c, "memory: ", 8) == 0)
    {
        const char* expected = r->memory_rows == 0 ? "memory: wait4 peaks include pre-exec memory and waited descendants; executable-only peaks are not measured by wait4" :
                              "memory: --time-stages peak growth is approximate post-exec RSS; -1 means unavailable, not zero";
        valid = valid && r->raw_rows == 0 && r->memory_rows < 2 && strcmp(line, expected) == 0;
        r->memory_rows += valid;
    }
    else if (strcmp(c, "stage system time: unqualified getrusage(RUSAGE_SELF) deltas between resource marks; do not subtract them from stage elapsed time or rank stages by them") == 0)
    {
        valid = valid && r->raw_rows == 0 && r->system_rows == 0;
        r->system_rows += valid;
    }
    else if (strncmp(c, "run ", 4) == 0) { valid = valid && r->memory_rows == 2 && run_row(r, line); }
    else if (strncmp(c, "default: median of ", 19) == 0) { valid = valid && summary_row(r, 0, c); }
    else if (strncmp(c, "time-stages: median of ", 23) == 0) { valid = valid && r->summaries[0] && summary_row(r, 1, c); }
    else if (strncmp(c, "reference: median of ", 21) == 0) { valid = valid && r->summaries[1] && summary_row(r, 2, c); }
    else if (strncmp(c, "--time-stages costs ", 20) == 0)
    {
        double difference = 0;
        double percent = 0;
        valid = valid && r->summaries[2] && !r->cost && literal(&c, "--time-stages costs ") && number(&c, 3, true, &difference) &&
                literal(&c, " ms (") && number(&c, 2, true, &percent) && literal(&c, "%) of the default's median wall time") && end(c) &&
                close_value(difference, r->medians[1][0] - r->medians[0][0], 0.00101) &&
                close_value(percent, (r->medians[1][0] / r->medians[0][0] - 1) * 100, 0.006 + 0.101 / r->medians[0][0]);
        r->cost = valid;
    }
    else if (strncmp(c, "default against reference: ", 27) == 0)
    {
        double first = 0;
        double second = 0;
        double ratio = 0;
        double difference = 0;
        valid = valid && r->cost && !r->comparison && literal(&c, "default against reference: ") && number(&c, 3, false, &first) &&
                literal(&c, " ms against ") && number(&c, 3, false, &second) && literal(&c, " ms, ") && number(&c, 2, false, &ratio) &&
                literal(&c, " times, ") && number(&c, 3, true, &difference) && literal(&c, " ms apart") && end(c) &&
                close_value(first, r->medians[0][0], 0.000001) && close_value(second, r->medians[2][0], 0.000001) &&
                close_value(difference, first - second, 0.00101) && close_value(ratio, first / second, 0.006 + 0.00101 / second);
        r->comparison = valid;
    }
    else if (strcmp(c, "--time-stages' stages, medians of 21 runs: ms (range), share of the median span; system ms, minor faults, approximate post-exec peak KiB added (-1 unavailable)") == 0)
    {
        valid = valid && r->comparison && !r->stage_header;
        r->stage_header = valid;
    }
    else if (strstr(c, "the stages' medians add up to") != NULL) { valid = valid && span_row(r, c, false); }
    else if (strstr(c, "the process's wall time outside the span") != NULL) { valid = valid && span_row(r, c, true); }
    else if (strncmp(c, "ranked:", 7) == 0)
    {
        valid = valid && r->outside && !r->ranked && literal(&c, "ranked:");
        bool seen[STAGES] = { false };
        unsigned count = 0;
        while (valid && *c != 0)
        {
            spaces(&c);
            char name[32];
            double share = 0;
            valid = token(&c, name, sizeof(name));
            const int index = valid ? named(name, stage_names, STAGES) : -1;
            valid = valid && index >= 0 && !seen[index] && literal(&c, " ") && number(&c, 1, false, &share) && literal(&c, "%") &&
                    close_value(share, r->stage_shares[index], 0.000001);
            if (valid) { seen[index] = true; count += 1; }
        }
        valid = valid && count > 0;
        r->ranked = valid;
    }
    else if (strcmp(c, "measure-compile: 0 failures") == 0) { valid = valid && r->ranked; r->complete = valid; }
    else { valid = valid && line[0] == ' ' && stage_row(r, line); }
    return valid;
}

static bool read_report(const char* path, Report* report)
{
    FILE* file = fopen(path, "rb");
    bool valid = file != NULL && fseek(file, 0, SEEK_END) == 0;
    const long size = valid ? ftell(file) : -1;
    valid = valid && size > 0 && size <= FILE_LIMIT;
    char* text = valid ? malloc((size_t)size + 1) : NULL;
    valid = valid && text != NULL && fseek(file, 0, SEEK_SET) == 0 && fread(text, 1, (size_t)size, file) == (size_t)size;
    if (file != NULL) { valid = fclose(file) == 0 && valid; }
    if (valid)
    {
        text[size] = 0;
        valid = memchr(text, 0, (size_t)size) == NULL && text[size - 1] == '\n';
    }
    unsigned line_number = 0;
    char* line = text;
    while (valid && *line != 0)
    {
        char* next = strchr(line, '\n');
        valid = next != NULL && next - line < 8192;
        if (valid)
        {
            *next = 0;
            line_number += 1;
            char lower[8192];
            for (size_t i = 0; i <= (size_t)(next - line); i += 1) { lower[i] = (char)tolower((unsigned char)line[i]); }
            valid = line_number <= 4096 && strstr(lower, "failed") == NULL && strstr(lower, "error:") == NULL && strstr(lower, "usage:") == NULL &&
                    strstr(lower, "segmentation fault") == NULL && strstr(lower, "aborted") == NULL && parse_line(report, line);
            line = next + 1;
        }
    }
    valid = valid && report->complete && report->raw_rows == ROLES * RUNS && report->rows == STAGES &&
            report->stages[4] > 0 && report->stages[5] > 0;
    if (!valid) { fprintf(stderr, "stage_summary: rejected %s at/after line %u\n", path, line_number); }
    free(text);
    return valid;
}

int main(int argc, char** argv)
{
    Report reports[2][3][3] = { 0 };
    static const unsigned shifts[3] = { 0, 64, 256 };
    bool valid = argc == 2;
    unsigned recognized = 0;
    unsigned entries = 0;
    DIR* directory = valid ? opendir(argv[1]) : NULL;
    valid = valid && directory != NULL;
    struct dirent* item = NULL;
    errno = 0;
    while (valid && (item = readdir(directory)) != NULL)
    {
        entries += 1;
        valid = entries <= 10000;
        const size_t length = strlen(item->d_name);
        if (strncmp(item->d_name, "stages-", 7) == 0 && length >= 4 && strcmp(item->d_name + length - 4, ".log") == 0)
        {
            bool matched = false;
            for (unsigned role = 0; role < 2; role += 1)
            {
                for (unsigned process = 1; process <= 3; process += 1)
                {
                    for (unsigned placement = 0; placement < 3; placement += 1)
                    {
                        char name[128];
                        snprintf(name, sizeof(name), "stages-%s-p%u-s%u.log", role == 0 ? "base" : "head", process, shifts[placement]);
                        matched = matched || strcmp(name, item->d_name) == 0;
                    }
                }
            }
            valid = matched;
            recognized += matched;
        }
    }
    valid = valid && errno == 0;
    if (directory != NULL) { valid = closedir(directory) == 0 && valid; }
    valid = valid && recognized == 18;
    for (unsigned role = 0; valid && role < 2; role += 1)
    {
        for (unsigned process = 0; valid && process < 3; process += 1)
        {
            for (unsigned placement = 0; valid && placement < 3; placement += 1)
            {
                char path[8192];
                const int size = snprintf(path, sizeof(path), "%s/stages-%s-p%u-s%u.log", argv[1], role == 0 ? "base" : "head", process + 1, shifts[placement]);
                valid = size > 0 && (size_t)size < sizeof(path) && read_report(path, &reports[role][process][placement]);
            }
        }
    }
    if (valid)
    {
        printf("process,placement,base_default_wall_ms,head_default_wall_ms,default_change_percent,base_staged_wall_ms,head_staged_wall_ms,staged_change_percent,base_reference_wall_ms,head_reference_wall_ms,base_check_input_ms,head_check_input_ms,check_input_change_percent,base_check_expressions_ms,head_check_expressions_ms,check_expressions_change_percent,base_check_declarations_ms,head_check_declarations_ms,base_check_program_ms,head_check_program_ms,base_span_ms,head_span_ms\n");
        for (unsigned process = 0; process < 3; process += 1)
        {
            for (unsigned placement = 0; placement < 3; placement += 1)
            {
                const Report* b = &reports[0][process][placement];
                const Report* h = &reports[1][process][placement];
                printf("%u,%u,%.3f,%.3f,%.6f,%.3f,%.3f,%.6f,%.3f,%.3f,%.3f,%.3f,%.6f,%.3f,%.3f,%.6f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f\n",
                       process + 1, shifts[placement], b->medians[0][0], h->medians[0][0], (h->medians[0][0] / b->medians[0][0] - 1) * 100,
                       b->medians[1][0], h->medians[1][0], (h->medians[1][0] / b->medians[1][0] - 1) * 100,
                       b->medians[2][0], h->medians[2][0], b->stages[4], h->stages[4], (h->stages[4] / b->stages[4] - 1) * 100,
                       b->stages[5], h->stages[5], (h->stages[5] / b->stages[5] - 1) * 100, b->stages[6], h->stages[6], b->stages[8], h->stages[8], b->span, h->span);
            }
        }
        fprintf(stderr, "stage_summary: validated all18 logs, 21 samples for each of3 roles, complete stage reports and terminal0-failure contracts\n");
    }
    else { fprintf(stderr, "stage_summary: FAILED (usage: stage_summary RESULTS_DIRECTORY; exact18-file grid required)\n"); }
    return valid ? 0 : 1;
}
