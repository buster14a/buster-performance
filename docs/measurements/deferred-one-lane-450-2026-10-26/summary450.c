// Original campaign reader for #450. No production source changes or external dependencies.
// Usage: summary450 rows|summary paired-ROUND-UNIT-{base,head450}.log sweep-UNIT-{base,head450}.log ...
// Whole times are the benchmark's printed ns/token; derived milliseconds retain that rounding.
#include <errno.h>
#include <inttypes.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ROWS 4096
#define MAX_ROUNDS 16

typedef struct Row Row;
struct Row
{
    const char* log;
    char unit[128];
    uint32_t campaign;
    uint32_t round;
    uint32_t variant;
    uint64_t tokens;
    uint64_t lanes;
    uint64_t active;
    uint64_t copies;
    double whole;
    double source_order;
    double dispatch;
    double wake;
    bool merged;
};

static Row rows[MAX_ROWS];
static uint32_t count;

static bool number(const char* line, const char* key, double* output)
{
    const char* field = strstr(line, key);
    char* end = NULL;
    errno = 0;
    const double value = field != NULL ? strtod(field + strlen(key), &end) : -1;
    const bool valid = field != NULL && end != field + strlen(key) && errno == 0 && isfinite(value) && value >= 0;
    if (valid)
    {
        *output = value;
    }
    return valid;
}

static bool integer(const char* line, const char* key, uint64_t* output)
{
    double value;
    const bool valid = number(line, key, &value) && value < 0x1p53 && floor(value) == value;
    if (valid)
    {
        *output = (uint64_t)value;
    }
    return valid;
}

static bool read_log(const char* path)
{
    Row initial = { .log = path };
    const char* name = strrchr(path, '/');
    name = name != NULL ? name + 1 : path;
    char stem[256];
    bool valid = strlen(name) < sizeof(stem);
    if (valid)
    {
        strcpy(stem, name);
        char* variant = strrchr(stem, '-');
        valid = variant != NULL && (strcmp(variant, "-base.log") == 0 || strcmp(variant, "-head450.log") == 0);
        if (valid)
        {
            initial.variant = strcmp(variant, "-head450.log") == 0;
            *variant = 0;
            const bool paired = strncmp(stem, "paired-", 7) == 0;
            const char* unit = paired ? strchr(stem + 7, '-') : strncmp(stem, "sweep-", 6) == 0 ? stem + 5 : NULL;
            initial.campaign = paired ? 0 : 1;
            initial.round = paired ? (uint32_t)strtoul(stem + 7, NULL, 10) : 1;
            valid = unit != NULL && initial.round >= 1 && initial.round <= MAX_ROUNDS && strlen(unit + 1) < sizeof(initial.unit);
            if (valid)
            {
                strcpy(initial.unit, unit + 1);
            }
        }
    }
    FILE* file = valid ? fopen(path, "r") : NULL;
    valid = valid && file != NULL;
    char line[16384];
    uint32_t headers = 0;
    uint32_t readings = 0;
    const uint32_t start = count;
    while (valid && fgets(line, sizeof(line), file) != NULL)
    {
        if (strncmp(line, "checker-deferred: file=", 23) == 0)
        {
            headers += 1;
            valid = headers == 1 && integer(line, " tokens=", &initial.tokens) && number(line, " source_order=", &initial.source_order) && initial.source_order > 0 &&
                    (strstr(line, " merged=yes") != NULL || strstr(line, " merged=no") != NULL);
            initial.merged = strstr(line, " merged=yes") != NULL;
        }
        else if (strncmp(line, "checker-deferred:   lanes=", 26) == 0)
        {
            Row row = initial;
            valid = headers == 1 && readings < 2 && count < MAX_ROWS && integer(line, " lanes=", &row.lanes) &&
                    integer(line, " active=", &row.active) && integer(line, " copies=", &row.copies) &&
                    number(line, " whole=", &row.whole) && number(line, " dispatch=", &row.dispatch) && number(line, " wake=", &row.wake);
            valid = valid && row.lanes == (readings == 0 ? 1 : 8) && row.active <= row.lanes && row.copies <= row.active &&
                    (row.active != 1 || row.wake == 0) && row.whole > 0;
            if (valid)
            {
                rows[count] = row;
                count += 1;
                readings += 1;
            }
        }
    }
    valid = valid && headers == 1 && readings == 2 && !ferror(file);
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    if (!valid)
    {
        count = start;
        fprintf(stderr, "summary450: malformed or incomplete process log: %s\n", path);
    }
    return valid;
}

static int compare_row(const void* a, const void* b)
{
    const Row* left = a;
    const Row* right = b;
    int result = (left->campaign > right->campaign) - (left->campaign < right->campaign);
    result = result == 0 ? strcmp(left->unit, right->unit) : result;
    result = result == 0 ? (left->lanes > right->lanes) - (left->lanes < right->lanes) : result;
    result = result == 0 ? (left->round > right->round) - (left->round < right->round) : result;
    result = result == 0 ? (left->variant > right->variant) - (left->variant < right->variant) : result;
    return result;
}

static int compare_double(const void* a, const void* b)
{
    const double left = *(const double*)a;
    const double right = *(const double*)b;
    return (left > right) - (left < right);
}

static double median(double* values, uint32_t length)
{
    qsort(values, length, sizeof(*values), compare_double);
    return length % 2 != 0 ? values[length / 2] : (values[length / 2 - 1] + values[length / 2]) / 2;
}

static bool output_summary(void)
{
    bool valid = true;
    printf("campaign\tunit\tlanes\trounds\ttokens\tmerged\tbase_whole_nspt\thead_whole_nspt\tdelta_medians_pct\tpaired_delta_pct\tpaired_min_pct\tpaired_max_pct\tbase_min_nspt\tbase_max_nspt\thead_min_nspt\thead_max_nspt\tbase_dispatch_ns\thead_dispatch_ns\tbase_wake_ns\thead_wake_ns\tbase_active\thead_active\tbase_copies\thead_copies\tbase_whole_ms_from_printed_nspt\thead_whole_ms_from_printed_nspt\tbase_source_order_nspt\thead_source_order_nspt\tsource_order_delta_medians_pct\tpaired_source_delta_pct\tpaired_source_min_pct\tpaired_source_max_pct\tpaired_normalized_whole_pct\tpaired_normalized_min_pct\tpaired_normalized_max_pct\n");
    for (uint32_t begin = 0; valid && begin < count;)
    {
        uint32_t end = begin + 1;
        while (end < count && rows[end].campaign == rows[begin].campaign && strcmp(rows[end].unit, rows[begin].unit) == 0 &&
               rows[end].lanes == rows[begin].lanes)
        {
            end += 1;
        }
        const Row* first = rows + begin;
        const uint32_t pairs = (end - begin) / 2;
        double values[2][6][MAX_ROUNDS] = { 0 };
        double delta[MAX_ROUNDS] = { 0 };
        double source_delta[MAX_ROUNDS] = { 0 };
        double normalized[MAX_ROUNDS] = { 0 };
        valid = pairs == (first->campaign == 0 ? 5u : 1u) && end - begin == pairs * 2;
        for (uint32_t p = 0; valid && p < pairs; p += 1)
        {
            const Row* a = rows + begin + p * 2;
            const Row* b = a + 1;
            valid = a->variant == 0 && b->variant == 1 && a->round == b->round && a->round == p + 1 &&
                    a->tokens == first->tokens && b->tokens == first->tokens && a->merged == first->merged && b->merged == first->merged;
            for (uint32_t variant = 0; variant < 2; variant += 1)
            {
                const Row* row = a + variant;
                values[variant][0][p] = row->whole;
                values[variant][1][p] = row->dispatch;
                values[variant][2][p] = row->wake;
                values[variant][3][p] = (double)row->active;
                values[variant][4][p] = (double)row->copies;
                values[variant][5][p] = row->source_order;
            }
            delta[p] = 100 * (b->whole / a->whole - 1);
            source_delta[p] = 100 * (b->source_order / a->source_order - 1);
            normalized[p] = 100 * ((b->whole / b->source_order) / (a->whole / a->source_order) - 1);
        }
        double medians[2][6] = { 0 };
        for (uint32_t variant = 0; valid && variant < 2; variant += 1)
        {
            for (uint32_t metric = 0; metric < 6; metric += 1)
            {
                medians[variant][metric] = median(values[variant][metric], pairs);
            }
        }
        if (valid)
        {
            const double change = median(delta, pairs);
            const double source_change = median(source_delta, pairs);
            const double normalized_change = median(normalized, pairs);
            printf("%s\t%s\t%" PRIu64 "\t%u\t%" PRIu64 "\t%s\t%.2f\t%.2f\t%.4f\t%.4f\t%.4f\t%.4f\t%.2f\t%.2f\t%.2f\t%.2f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.6f\t%.6f\t%.2f\t%.2f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n",
                   first->campaign == 0 ? "paired" : "sweep", first->unit, first->lanes, pairs, first->tokens, first->merged ? "yes" : "no",
                   medians[0][0], medians[1][0], 100 * (medians[1][0] / medians[0][0] - 1), change, delta[0], delta[pairs - 1],
                   values[0][0][0], values[0][0][pairs - 1], values[1][0][0], values[1][0][pairs - 1], medians[0][1], medians[1][1],
                   medians[0][2], medians[1][2], medians[0][3], medians[1][3], medians[0][4], medians[1][4],
                   medians[0][0] * (double)first->tokens / 1e6, medians[1][0] * (double)first->tokens / 1e6, medians[0][5], medians[1][5],
                   100 * (medians[1][5] / medians[0][5] - 1), source_change, source_delta[0], source_delta[pairs - 1],
                   normalized_change, normalized[0], normalized[pairs - 1]);
        }
        else
        {
            fprintf(stderr, "summary450: missing/duplicate pairs or inconsistent input: %s, lanes=%" PRIu64 "\n", first->unit, first->lanes);
        }
        begin = end;
    }
    return valid;
}

int main(int argc, char** argv)
{
    const bool summary = argc >= 3 && strcmp(argv[1], "summary") == 0;
    bool valid = argc >= 3 && (summary || strcmp(argv[1], "rows") == 0);
    for (int i = 2; valid && i < argc; i += 1)
    {
        valid = read_log(argv[i]);
    }
    if (valid)
    {
        qsort(rows, count, sizeof(*rows), compare_row);
        if (summary)
        {
            valid = output_summary();
        }
        else
        {
            printf("campaign\tunit\tround\tvariant\ttokens\tmerged\tlanes\tactive\tcopies\twhole_nspt\tdispatch_ns\twake_ns\tsource_order_nspt\tlog\n");
            for (uint32_t i = 0; i < count; i += 1)
            {
                const Row* row = rows + i;
                printf("%s\t%s\t%u\t%s\t%" PRIu64 "\t%s\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%.2f\t%.0f\t%.0f\t%.2f\t%s\n",
                       row->campaign == 0 ? "paired" : "sweep", row->unit, row->round, row->variant == 0 ? "base" : "head450", row->tokens,
                       row->merged ? "yes" : "no", row->lanes, row->active, row->copies, row->whole, row->dispatch, row->wake, row->source_order, row->log);
            }
        }
    }
    if (argc < 3)
    {
        fprintf(stderr, "usage: summary450 rows|summary PROCESS.log...\n");
    }
    return valid ? 0 : 1;
}
