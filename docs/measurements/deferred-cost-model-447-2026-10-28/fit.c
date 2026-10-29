// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original offline nonnegative least-squares experiment. Whole translation
// units, not bodies randomly sampled from the same unit, form held-out sets.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_MODEL_MAX_KINDS 128u
#define BUSTER_MODEL_MAX_ROWS 100000u
#define BUSTER_MODEL_SWEEPS 2000u

typedef struct Row Row;
struct Row
{
    double y;
    double tokens;
    double counts[BUSTER_MODEL_MAX_KINDS];
};

typedef struct Data Data;
struct Data
{
    Row* rows;
    uint32_t count;
    uint32_t kinds;
    char names[BUSTER_MODEL_MAX_KINDS][48];
};

static bool number(const char* text, double* value)
{
    char* end = NULL;
    errno = 0;
    *value = text != NULL ? strtod(text, &end) : NAN;
    return text != NULL && end != text && *end == 0 && errno == 0 && isfinite(*value) && *value >= 0;
}

static bool next_is(char** cursor, const char* expected)
{
    const char* field = strtok_r(NULL, "\t", cursor);
    return field != NULL && strcmp(field, expected) == 0;
}

static bool read_data(const char* path, Data* data)
{
    FILE* input = fopen(path, "r");
    char* line = NULL;
    size_t capacity = 0;
    bool valid = input != NULL;
    bool header = false;
    while (valid && getline(&line, &capacity, input) >= 0)
    {
        const size_t bytes = strlen(line);
        if (bytes != 0 && line[bytes - 1] == '\n') line[bytes - 1] = 0;
        char* cursor = NULL;
        char* field = strtok_r(line, "\t", &cursor);
        if (field != NULL && strcmp(field, "file") == 0)
        {
            valid = next_is(&cursor, "body") && next_is(&cursor, "tokens") && next_is(&cursor, "walk_ns");
            uint32_t kinds = 0;
            for (field = strtok_r(NULL, "\t", &cursor); valid && field != NULL; field = strtok_r(NULL, "\t", &cursor))
            {
                valid = kinds < BUSTER_MODEL_MAX_KINDS && strlen(field) < sizeof(data->names[0]);
                if (valid && header) valid = strcmp(data->names[kinds], field) == 0;
                if (valid && !header) strcpy(data->names[kinds], field);
                kinds += 1;
            }
            valid = valid && kinds != 0 && (!header || data->kinds == kinds);
            data->kinds = kinds;
            header = true;
        }
        else
        {
            valid = header && field != NULL && data->count < BUSTER_MODEL_MAX_ROWS;
            Row* row = valid ? data->rows + data->count : NULL;
            double body = 0;
            if (valid) valid = number(strtok_r(NULL, "\t", &cursor), &body) && number(strtok_r(NULL, "\t", &cursor), &row->tokens) &&
                               number(strtok_r(NULL, "\t", &cursor), &row->y) && row->tokens > 0 && row->y > 0;
            double sum = 0;
            for (uint32_t k = 0; valid && k < data->kinds; k += 1)
            {
                valid = number(strtok_r(NULL, "\t", &cursor), row->counts + k);
                sum += row->counts[k];
            }
            valid = valid && strtok_r(NULL, "\t", &cursor) == NULL && sum == row->tokens;
            data->count += valid;
        }
    }
    valid = valid && header && data->count != 0 && !ferror(input);
    if (input != NULL) fclose(input);
    free(line);
    return valid;
}

static double feature(const Row* row, uint32_t column, bool weighted)
{
    return column == 0 ? 1.0 : weighted ? row->counts[column - 1] : row->tokens;
}

static bool fit(const Data* data, bool weighted, double* coefficients)
{
    const uint32_t columns = weighted ? data->kinds + 1 : 2;
    double norm[BUSTER_MODEL_MAX_KINDS + 1] = { 0 };
    double* residual = malloc((size_t)data->count * sizeof(double));
    const bool valid = residual != NULL;
    for (uint32_t row = 0; valid && row < data->count; row += 1)
    {
        residual[row] = data->rows[row].y;
        for (uint32_t c = 0; c < columns; c += 1)
        {
            const double x = feature(data->rows + row, c, weighted);
            norm[c] += x * x;
            residual[row] -= coefficients[c] * x;
        }
    }
    for (uint32_t sweep = 0; valid && sweep < BUSTER_MODEL_SWEEPS; sweep += 1)
    {
        for (uint32_t c = 0; c < columns; c += 1)
        {
            double dot = 0;
            for (uint32_t row = 0; row < data->count; row += 1) dot += feature(data->rows + row, c, weighted) * residual[row];
            const double next = norm[c] != 0 ? fmax(0, coefficients[c] + dot / norm[c]) : 0;
            const double change = next - coefficients[c];
            coefficients[c] = next;
            for (uint32_t row = 0; row < data->count; row += 1) residual[row] -= feature(data->rows + row, c, weighted) * change;
        }
    }
    free(residual);
    return valid;
}

static double loss(const Data* data, const double* coefficients, bool weighted, bool report)
{
    double sse = 0;
    double absolute = 0;
    double total = 0;
    for (uint32_t row = 0; row < data->count; row += 1)
    {
        double prediction = coefficients[0];
        const uint32_t columns = weighted ? data->kinds + 1 : 2;
        for (uint32_t c = 1; c < columns; c += 1) prediction += coefficients[c] * feature(data->rows + row, c, weighted);
        const double difference = prediction - data->rows[row].y;
        sse += difference * difference;
        absolute += fabs(difference);
        total += data->rows[row].y;
    }
    if (report) printf("rows=%u rmse_ns=%.6f weighted_absolute_error=%.6f total_walk_ns=%.0f\n", data->count, sqrt(sse / data->count), absolute / total, total);
    return sse;
}

static bool self_test(void)
{
    Row train_rows[6] = { 0 };
    Row test_rows[3] = { 0 };
    for (uint32_t row = 0; row < 6; row += 1)
    {
        train_rows[row].counts[0] = row + 1;
        train_rows[row].counts[1] = (row * 3 + 1) % 7;
        train_rows[row].tokens = train_rows[row].counts[0] + train_rows[row].counts[1];
        train_rows[row].y = 13 + 2 * train_rows[row].counts[0] + 9 * train_rows[row].counts[1];
    }
    for (uint32_t row = 0; row < 3; row += 1)
    {
        test_rows[row].counts[0] = 20 + row;
        test_rows[row].counts[1] = 2 * row;
        test_rows[row].tokens = test_rows[row].counts[0] + test_rows[row].counts[1];
        test_rows[row].y = 13 + 2 * test_rows[row].counts[0] + 9 * test_rows[row].counts[1];
    }
    const Data train = { .rows = train_rows, .count = 6, .kinds = 2 };
    const Data test = { .rows = test_rows, .count = 3, .kinds = 2 };
    double weights[3] = { 0 };
    double tokens[2] = { 0 };
    const bool fitted = fit(&train, true, weights) && fit(&train, false, tokens);
    double restarted[3] = { tokens[0], tokens[1], tokens[1] };
    const bool refitted = fit(&train, true, restarted);
    double parsed = 0;
    const bool valid = fitted && refitted && loss(&train, restarted, true, false) < 1e-12 && loss(&test, restarted, true, false) < 1e-10 &&
                       loss(&train, weights, true, false) < 1e-12 && loss(&test, weights, true, false) < 1e-10 &&
                       loss(&test, tokens, false, false) > 1 && !number("nan", &parsed) && !number("1x", &parsed) && !number("-1", &parsed);
    printf("model-self-test: exact_known_weights=%s nonnumeric_rejected=%s\n", valid ? "yes" : "no", valid ? "yes" : "no");
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 2 && strcmp(argv[1], "--self-test") == 0;
    if (valid) valid = self_test();
    else if (argc == 3)
    {
        Data train = { .rows = calloc(BUSTER_MODEL_MAX_ROWS, sizeof(Row)) };
        Data test = { .rows = calloc(BUSTER_MODEL_MAX_ROWS, sizeof(Row)) };
        valid = train.rows != NULL && test.rows != NULL && read_data(argv[1], &train) && read_data(argv[2], &test) && train.kinds == test.kinds;
        for (uint32_t kind = 0; valid && kind < train.kinds; kind += 1) valid = strcmp(train.names[kind], test.names[kind]) == 0;
        if (valid)
        {
            double token_model[2] = { 0 };
            double weighted[BUSTER_MODEL_MAX_KINDS + 1] = { 0 };
            valid = fit(&train, false, token_model);
            // The token model is a feasible point of the weighted problem.
            weighted[0] = token_model[0];
            for (uint32_t kind = 0; kind < train.kinds; kind += 1) weighted[kind + 1] = token_model[1];
            valid = valid && fit(&train, true, weighted);
            printf("token train "); loss(&train, token_model, false, true);
            printf("token held_out "); loss(&test, token_model, false, true);
            printf("weighted train "); loss(&train, weighted, true, true);
            printf("weighted held_out "); loss(&test, weighted, true, true);
            printf("token offset=%.9f ns_per_token=%.9f\nweighted offset=%.9f\n", token_model[0], token_model[1], weighted[0]);
            for (uint32_t kind = 0; kind < train.kinds; kind += 1) printf("weight %s %.9f\n", train.names[kind], weighted[kind + 1]);
        }
        free(train.rows);
        free(test.rows);
    }
    else valid = false;
    if (!valid) fprintf(stderr, "usage: fit --self-test | TRAIN.tsv HELD_OUT.tsv; invalid/incompatible data fails\n");
    return valid ? 0 : 1;
}
