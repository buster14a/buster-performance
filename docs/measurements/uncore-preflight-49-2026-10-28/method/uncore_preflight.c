// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original offline counter qualification.
#define _POSIX_C_SOURCE 200809L
#include "json.h"
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/stat.h>
#include <unistd.h>

#define ROW_LIMIT 256u
#define OBSERVE_LIMIT 16u
#define EXACT_INTEGER_MAX 9007199254740991.0

typedef struct
{
    JsonDoc json;
    const char* status;
} Input;
typedef struct
{
    const JsonDoc* doc;
    const JsonToken* token;
    const char* status;
    double number;
} Value;
typedef struct
{
    const JsonToken* token;
    const JsonToken* name;
    Value count;
    Value metric;
    Value duty;
    uint64_t runtime;
    bool runtime_known;
} Row;
typedef struct
{
    Input perf;
    Input work;
    Row rows[ROW_LIMIT];
    unsigned count;
    bool shape;
    bool duplicate;
    bool workload;
    bool counters;
    bool full_duty;
    bool interval;
    bool duration_window;
    bool work_window;
    bool scope;
    bool arithmetic;
    unsigned df_found;
    unsigned umc_found;
    uint64_t min_runtime;
    uint64_t max_runtime;
    uint64_t umc_runtime;
    Value metric;
    double umc_read;
    double umc_write;
    double recomputed_df;
    bool rates;
    bool ratio_known;
    bool ratio_nonfinite;
    double ratio;
} Run;

static void quote(const char* text)
{
    fputc('"', stdout);
    for (const unsigned char* at = (const unsigned char*)text; *at; at += 1)
    {
        if (*at == '"' || *at == '\\') { fputc('\\', stdout); fputc(*at, stdout); }
        else if (*at < 32) fprintf(stdout, "\\u%04x", *at);
        else fputc(*at, stdout);
    }
    fputc('"', stdout);
}

static void raw(const JsonDoc* doc, const JsonToken* token)
{
    size_t length = 0;
    const char* text = json_raw(doc, token, &length);
    if (text != NULL) fwrite(text, 1, length, stdout);
    else fputs("null", stdout);
}

static Input load(const char* path, bool sequence)
{
    Input result = { .status = "missing_file" };
    const int fd = open(path, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
    if (fd < 0) { result.status = errno == ENOENT ? "missing_file" : "input_open_failed"; return result; }
    struct stat before, after;
    bool valid = fstat(fd, &before) == 0 && S_ISREG(before.st_mode) && before.st_size >= 0 &&
                 (uint64_t)before.st_size <= JSON_INPUT_LIMIT;
    result.status = "invalid_input_file";
    char* data = valid ? malloc((size_t)before.st_size + 1) : NULL;
    valid = data != NULL && valid;
    size_t done = 0;
    while (valid && done < (size_t)before.st_size)
    {
        ssize_t got;
        do { got = read(fd, data + done, (size_t)before.st_size - done); } while (got < 0 && errno == EINTR);
        valid = got > 0;
        done += got > 0 ? (size_t)got : 0;
    }
    valid = valid && fstat(fd, &after) == 0 && before.st_size == after.st_size &&
            before.st_mtim.tv_sec == after.st_mtim.tv_sec && before.st_mtim.tv_nsec == after.st_mtim.tv_nsec &&
            before.st_ctim.tv_sec == after.st_ctim.tv_sec && before.st_ctim.tv_nsec == after.st_ctim.tv_nsec;
    valid = close(fd) == 0 && valid;
    if (valid)
    {
        char error[256];
        bool empty = true;
        for (size_t i = 0; i < done; i += 1) empty = empty && strchr(" \t\r\n", data[i]) != NULL && data[i] != 0;
        if (empty) result.status = "empty";
        else result.status = json_parse(&result.json, data, done, sequence, error, sizeof(error)) ? "parsed" : "malformed_json";
    }
    free(data);
    return result;
}

static bool equal(const JsonDoc* doc, const JsonToken* token, const char* text)
{
    return json_equal(doc, token, text) != 0;
}

static Value value(const JsonDoc* doc, const JsonToken* token)
{
    Value result = { .doc = doc, .token = token, .status = "missing" };
    if (token == NULL) return result;
    result.status = "invalid";
    if (token->type == JSON_NULL) result.status = "null";
    else if (equal(doc, token, "<not supported>")) result.status = "unsupported";
    else if (equal(doc, token, "<not counted>")) result.status = "not_counted";
    else if (json_number(doc, token, &result.number))
    {
        result.status = result.number < 0 ? "negative" : result.number == 0 ? "measured_zero" : "finite";
    }
    else if (token->type == JSON_STRING)
    {
        size_t length = 0;
        const char* text = json_string(doc, token, &length);
        if (length < 128 && memchr(text, 0, length) == NULL)
        {
            char copy[128];
            memcpy(copy, text, length); copy[length] = 0;
            char* end = NULL;
            errno = 0;
            const double number = strtod(copy, &end);
            if (end != copy && *end == 0 && !isfinite(number)) result.status = "nonfinite";
            else if (end != copy && *end == 0 && errno == ERANGE) result.status = "out_of_range";
        }
    }
    return result;
}

static bool numeric(Value v)
{
    return strcmp(v.status, "finite") == 0 || strcmp(v.status, "measured_zero") == 0;
}

/* Counter integrality and full duty are checked in decimal text before
 * floating conversion can round a fractional count or partial duty to full.
 * This narrow format admits perf's fixed decimal strings, not exponents. */
static bool decimal(Value v, uint64_t* whole, bool* fractional)
{
    size_t length = 0;
    const char* text = v.token != NULL && v.token->type == JSON_STRING ? json_string(v.doc, v.token, &length) :
                       json_raw(v.doc, v.token, &length);
    if (text == NULL || length == 0) return false;
    size_t at = 0;
    uint64_t integer = 0;
    while (at < length && text[at] >= '0' && text[at] <= '9')
    {
        const unsigned digit = (unsigned)(text[at++] - '0');
        if (integer > (UINT64_MAX - digit) / 10) return false;
        integer = integer * 10 + digit;
    }
    if (at == 0) return false;
    bool fraction = false;
    if (at < length && text[at] == '.')
    {
        at += 1;
        const size_t start = at;
        while (at < length && text[at] >= '0' && text[at] <= '9')
        {
            fraction = text[at] != '0' || fraction;
            at += 1;
        }
        if (at == start) return false;
    }
    if (at != length) return false;
    *whole = integer; *fractional = fraction;
    return true;
}

static bool counter(Value v)
{
    uint64_t whole = 0; bool fraction = false;
    return numeric(v) && decimal(v, &whole, &fraction) && !fraction && whole <= UINT64_C(9007199254740991);
}

static const char* duty(Value v)
{
    if (!numeric(v)) return strcmp(v.status, "missing") == 0 || strcmp(v.status, "null") == 0 ? "unavailable" : "invalid";
    uint64_t whole = 0; bool fraction = false;
    if (!decimal(v, &whole, &fraction) || whole > 100 || (whole == 100 && fraction)) return "invalid";
    return whole == 100 ? "reported_full" : whole == 0 && !fraction ? "reported_zero" : "reported_partial";
}

static void print_value(Value v)
{
    fputs("{\"status\":", stdout); quote(v.status);
    fputs(",\"raw\":", stdout); raw(v.doc, v.token);
    fputs(",\"finite_value\":", stdout);
    if (numeric(v)) fprintf(stdout, "%.17g", v.number); else fputs("null", stdout);
    fputc('}', stdout);
}

static const JsonToken* cpu_field(const JsonDoc* doc, const char* name, bool* unique)
{
    const JsonToken* root = json_root(doc, 0);
    const JsonToken* list = json_member(doc, root, "lscpu");
    const JsonToken* found = NULL;
    bool seen = false;
    if (list == NULL || list->type != JSON_ARRAY) return NULL;
    for (size_t i = 0; i < list->count; i += 1)
    {
        const JsonToken* item = json_at(doc, list, i);
        if (equal(doc, json_member(doc, item, "field"), name))
        {
            if (seen) *unique = false;
            seen = true;
            found = json_member(doc, item, "data");
        }
    }
    return found;
}

static const char* cpu_status(const Input* input)
{
    if (strcmp(input->status, "parsed") != 0) return input->status;
    bool unique = true;
    const JsonDoc* doc = &input->json;
    const char* names[] = { "Architecture:", "Vendor ID:", "Model name:", "CPU family:", "Model:", "Stepping:" };
    const char* expected[] = { "x86_64", "AuthenticAMD", "AMD Ryzen 7 9700X 8-Core Processor", "26", "68", "0" };
    bool matched = true, missing = false;
    for (unsigned i = 0; i < sizeof(names) / sizeof(names[0]); i += 1)
    {
        const JsonToken* token = cpu_field(doc, names[i], &unique);
        missing = missing || token == NULL || token->type == JSON_NULL;
        matched = matched && equal(doc, token, expected[i]);
    }
    return !unique ? "duplicate_identity_field" : missing ? "missing_identity" : matched ? "matched_9700x_1a_44_0" : "unsupported_cpu_identity";
}

static const JsonToken* catalog_item(const JsonDoc* doc, const char* key, const char* name, bool* unique)
{
    const JsonToken* list = json_root(doc, 0);
    const JsonToken* found = NULL;
    if (list == NULL || list->type != JSON_ARRAY) return NULL;
    for (size_t i = 0; i < list->count; i += 1)
    {
        const JsonToken* item = json_at(doc, list, i);
        if (equal(doc, json_member(doc, item, key), name))
        {
            if (found != NULL) *unique = false;
            found = item;
        }
    }
    return found;
}

static void metric_name(char* text, size_t capacity, const char* direction)
{
    snprintf(text, capacity, "dram_%s_bandwidth_for_local_or_remote_socket", direction);
}

static void df_name(char* text, size_t capacity, const char* direction, unsigned channel)
{
    snprintf(text, capacity, "local_or_remote_socket_%s_data_beats_dram_%u", direction, channel);
}

static const char* catalog_status(const Input* input)
{
    if (strcmp(input->status, "parsed") != 0) return input->status;
    const JsonDoc* doc = &input->json;
    bool unique = true, present = true, matched = true;
    for (unsigned controller = 0; controller < 2; controller += 1)
    {
        for (unsigned wr = 0; wr < 2; wr += 1)
        {
            char name[128], encoding[128];
            snprintf(name, sizeof(name), "amd_umc_%u/umc_cas_cmd.%s/", controller, wr ? "wr" : "rd");
            snprintf(encoding, sizeof(encoding), "amd_umc/event=0xa,rdwrmask=%u/", wr ? 2 : 1);
            const JsonToken* item = catalog_item(doc, "EventName", name, &unique);
            present = present && item != NULL;
            matched = matched && equal(doc, json_member(doc, item, "Unit"), "amd_umc") &&
                      equal(doc, json_member(doc, item, "Encoding"), encoding);
        }
    }
    for (unsigned wr = 0; wr < 2; wr += 1)
    {
        const char* direction = wr ? "write" : "read";
        char expression[2048] = "(";
        size_t used = 1;
        for (unsigned channel = 0; channel < 12; channel += 1)
        {
            char bare[128], name[160], encoding[128];
            df_name(bare, sizeof(bare), direction, channel);
            snprintf(name, sizeof(name), "amd_df/%s/", bare);
            snprintf(encoding, sizeof(encoding), "amd_df/event=0x%x,umask=0xff%c/", 0x1f + channel * 0x40, wr ? 'f' : 'e');
            const JsonToken* item = catalog_item(doc, "EventName", name, &unique);
            present = present && item != NULL;
            matched = matched && equal(doc, json_member(doc, item, "Unit"), "amd_df") &&
                      equal(doc, json_member(doc, item, "Encoding"), encoding);
            const int wrote = snprintf(expression + used, sizeof(expression) - used, "%s%s", channel ? " + " : "", bare);
            if (wrote < 0 || (size_t)wrote >= sizeof(expression) - used) return "internal_expression_bounds";
            used += (size_t)wrote;
        }
        if (snprintf(expression + used, sizeof(expression) - used, ") / duration_time") < 0) return "internal_expression_bounds";
        char name[128]; metric_name(name, sizeof(name), direction);
        const JsonToken* item = catalog_item(doc, "MetricName", name, &unique);
        present = present && item != NULL;
        matched = matched && equal(doc, json_member(doc, item, "MetricExpr"), expression) &&
                  equal(doc, json_member(doc, item, "ScaleUnit"), "6.4e-5MB/s");
    }
    return !unique ? "duplicate_catalog_entry" : !present ? "missing_pmu_or_metric_entry" :
           matched ? "matches_published_exposure_not_semantics" : "encoding_or_unit_or_expression_changed";
}

static bool workload(const Input* input, const char* direction)
{
    const JsonDoc* doc = &input->json;
    const JsonToken* root = json_root(doc, 0);
    char label[64]; snprintf(label, sizeof(label), "df-umc-%s", direction);
    uint64_t jobs = 0, tasks = 0, lanes = 0, failures = 1, bytes = 0, completed = 0, output = 0, errors = 1;
    double wall = 0;
    bool ok = strcmp(input->status, "parsed") == 0 && doc->root_count == 1 &&
              equal(doc, json_member(doc, root, "label"), label) && equal(doc, json_member(doc, root, "stage"), "compile") &&
              json_u64(doc, json_member(doc, root, "jobs"), &jobs) && jobs == 8 &&
              json_u64(doc, json_member(doc, root, "tasks"), &tasks) && tasks == 64 &&
              json_u64(doc, json_member(doc, root, "lanes"), &lanes) && lanes == 1 &&
              json_u64(doc, json_member(doc, root, "failures"), &failures) && failures == 0 &&
              json_u64(doc, json_member(doc, root, "counter_errors"), &errors) && errors == 0 &&
              json_u64(doc, json_member(doc, root, "input_bytes_per_task"), &bytes) && bytes != 0 && bytes <= UINT64_MAX / tasks &&
              json_u64(doc, json_member(doc, root, "completed_bytes"), &completed) && completed == tasks * bytes &&
              json_u64(doc, json_member(doc, root, "output_bytes"), &output) && output != 0 &&
              json_number(doc, json_member(doc, root, "wall_s"), &wall) && wall > 0;
    const JsonToken* cpus = json_member(doc, root, "cpus");
    ok = ok && cpus != NULL && cpus->type == JSON_ARRAY && cpus->count == 8;
    for (unsigned i = 0; ok && i < 8; i += 1)
    {
        uint64_t cpu = 99;
        ok = json_u64(doc, json_at(doc, cpus, i), &cpu) && cpu == i;
    }
    return ok;
}

static void parse_rows(Run* run)
{
    const JsonDoc* doc = &run->perf.json;
    run->shape = strcmp(run->perf.status, "parsed") == 0 && doc->root_count != 0 && doc->root_count <= ROW_LIMIT;
    run->count = doc->root_count < ROW_LIMIT ? (unsigned)doc->root_count : ROW_LIMIT;
    for (unsigned i = 0; i < run->count; i += 1)
    {
        Row* row = run->rows + i;
        row->token = json_root(doc, i);
        row->name = json_member(doc, row->token, "event");
        size_t length = 0;
        const char* name = json_string(doc, row->name, &length);
        run->shape = run->shape && row->token->type == JSON_OBJECT && name != NULL && length != 0 && length < 1024 &&
                     memchr(name, 0, length) == NULL;
        row->count = value(doc, json_member(doc, row->token, "counter-value"));
        row->metric = value(doc, json_member(doc, row->token, "metric-value"));
        row->duty = value(doc, json_member(doc, row->token, "pcnt-running"));
        row->runtime_known = json_u64(doc, json_member(doc, row->token, "event-runtime"), &row->runtime) != 0;
        for (unsigned j = 0; j < i && name != NULL; j += 1)
        {
            size_t other_length = 0;
            const char* other = json_string(doc, run->rows[j].name, &other_length);
            run->duplicate = run->duplicate || (other != NULL && length == other_length && memcmp(name, other, length) == 0);
        }
    }
}

static Row* find(Run* run, const char* name)
{
    for (unsigned i = 0; i < run->count; i += 1) if (equal(&run->perf.json, run->rows[i].name, name)) return run->rows + i;
    return NULL;
}

static void required(Run* run, Row* row, bool umc)
{
    if (row == NULL) { run->counters = false; run->full_duty = false; return; }
    run->counters = run->counters && counter(row->count) && row->runtime_known && row->runtime > 0 &&
                    (double)row->runtime <= EXACT_INTEGER_MAX && equal(&run->perf.json, json_member(&run->perf.json, row->token, "unit"), "");
    run->full_duty = run->full_duty && strcmp(duty(row->duty), "reported_full") == 0;
    if (run->min_runtime == 0 || row->runtime < run->min_runtime) run->min_runtime = row->runtime;
    if (row->runtime > run->max_runtime) run->max_runtime = row->runtime;
    if (umc && row->runtime > run->umc_runtime) run->umc_runtime = row->runtime;
}

static void qualify(Run* run, const char* direction, bool identity, bool catalog)
{
    parse_rows(run);
    run->workload = workload(&run->work, direction);
    run->counters = run->shape && !run->duplicate;
    run->full_duty = true;
    double rd = 0, wr = 0, df = 0;
    for (unsigned controller = 0; controller < 2; controller += 1)
    {
        for (unsigned write = 0; write < 2; write += 1)
        {
            char name[128]; snprintf(name, sizeof(name), "amd_umc_%u/umc_cas_cmd.%s/", controller, write ? "wr" : "rd");
            Row* row = find(run, name); required(run, row, true);
            if (row != NULL) { run->umc_found += 1; if (write) wr += row->count.number; else rd += row->count.number; }
        }
    }
    for (unsigned channel = 0; channel < 12; channel += 1)
    {
        char name[128]; df_name(name, sizeof(name), direction, channel);
        Row* row = find(run, name); required(run, row, false);
        if (row != NULL) { run->df_found += 1; df += row->count.number; }
    }
    Row* duration = find(run, "duration_time");
    run->counters = run->counters && duration != NULL && counter(duration->count) && duration->count.number > 0 &&
                    equal(&run->perf.json, json_member(&run->perf.json, duration->token, "unit"), "") &&
                    duration->runtime_known && duration->runtime == 1 && strcmp(duty(duration->duty), "reported_full") == 0 &&
                    rd <= EXACT_INTEGER_MAX && wr <= EXACT_INTEGER_MAX && df <= EXACT_INTEGER_MAX;
    unsigned metrics = 0, all_metrics = 0;
    bool metric_owner = false;
    char metric[128], label[160]; metric_name(metric, sizeof(metric), direction);
    snprintf(label, sizeof(label), "MB/s  %s", metric);
    run->metric = value(&run->perf.json, NULL);
    for (unsigned i = 0; i < run->count; i += 1)
    {
        Row* row = run->rows + i;
        all_metrics += json_member(&run->perf.json, row->token, "metric-value") != NULL ||
                       json_member(&run->perf.json, row->token, "metric-unit") != NULL;
        if (equal(&run->perf.json, json_member(&run->perf.json, row->token, "metric-unit"), label))
        {
            run->metric = row->metric; metrics += 1;
            for (unsigned channel = 0; channel < 12; channel += 1)
            {
                char name[128]; df_name(name, sizeof(name), direction, channel);
                metric_owner = metric_owner || equal(&run->perf.json, row->name, name);
            }
        }
    }
    run->interval = run->min_runtime != 0 && run->max_runtime != 0 &&
                    (double)(run->max_runtime - run->min_runtime) / (double)run->max_runtime <= 0.01;
    run->duration_window = duration != NULL && counter(duration->count) && run->max_runtime != 0 &&
                           fabs(duration->count.number - (double)run->max_runtime) / (double)run->max_runtime <= 0.01;
    double wall = 0;
    run->work_window = json_number(&run->work.json, json_member(&run->work.json, json_root(&run->work.json, 0), "wall_s"), &wall) &&
                       run->max_runtime != 0 && fabs(wall * 1e9 - (double)run->max_runtime) / (double)run->max_runtime <= 0.01;
    run->scope = run->shape && !run->duplicate && run->count == 17 && run->df_found == 12 && run->umc_found == 4 && metrics == 1 && all_metrics == 1 && metric_owner;
    run->rates = run->counters && run->full_duty && run->interval && run->duration_window && run->work_window && run->scope && run->workload && identity && catalog;
    if (run->rates)
    {
        const double seconds = (double)run->umc_runtime / 1e9;
        run->umc_read = rd * 64 / 1e6 / seconds;
        run->umc_write = wr * 64 / 1e6 / seconds;
        run->recomputed_df = df * 64 / 1e6 / (duration->count.number / 1e9);
        run->arithmetic = numeric(run->metric) && fabs(run->recomputed_df - run->metric.number) <= 0.000001;
        const double denominator = strcmp(direction, "read") == 0 ? run->umc_read : run->umc_write;
        if (numeric(run->metric) && run->arithmetic && denominator > 0)
        {
            run->ratio = run->metric.number / denominator;
            run->ratio_known = isfinite(run->ratio);
            run->ratio_nonfinite = !run->ratio_known;
        }
    }
}

static void print_rows(const Run* run)
{
    fputc('[', stdout);
    for (unsigned i = 0; i < run->count; i += 1)
    {
        const Row* row = run->rows + i;
        if (i) fputc(',', stdout);
        fputs("{\"event\":", stdout); raw(&run->perf.json, row->name);
        fputs(",\"counter\":", stdout); print_value(row->count);
        fputs(",\"duty\":", stdout); quote(duty(row->duty));
        fputs(",\"duty_observation\":", stdout); print_value(row->duty);
        fputs(",\"event_runtime_ns\":", stdout);
        if (row->runtime_known) fprintf(stdout, "%" PRIu64, row->runtime); else fputs("null", stdout);
        fputs(",\"metric\":", stdout); print_value(row->metric);
        fputs(",\"metric_unit\":", stdout); raw(&run->perf.json, json_member(&run->perf.json, row->token, "metric-unit"));
        fputs(",\"semantic_applicability\":\"unvalidated\",\"accepted\":false}", stdout);
    }
    fputc(']', stdout);
}

static void print_run(const Run* run, const char* direction)
{
    quote(direction); fputs(":{\"input_status\":", stdout); quote(run->perf.status);
    fputs(",\"workload_input_status\":", stdout); quote(run->work.status);
    fprintf(stdout, ",\"parsed_rows\":%u,\"row_shape_complete\":%s,\"duplicate_events\":%s,\"workload_complete\":%s,\"expected_df_events_found\":%u,\"expected_umc_events_found\":%u,\"counter_values_and_runtimes_usable\":%s,\"required_counter_duty_reported_100pct\":%s,\"runtime_envelope_within_one_percent\":%s,\"expected_single_stream_scope\":%s,\"minimum_runtime_ns\":%" PRIu64 ",\"maximum_runtime_ns\":%" PRIu64,
            run->count, run->shape ? "true" : "false", run->duplicate ? "true" : "false", run->workload ? "true" : "false",
            run->df_found, run->umc_found, run->counters ? "true" : "false", run->full_duty ? "true" : "false", run->interval ? "true" : "false", run->scope ? "true" : "false", run->min_runtime, run->max_runtime);
    fprintf(stdout, ",\"duration_time_within_one_percent\":%s,\"work_wall_within_one_percent\":%s", run->duration_window ? "true" : "false", run->work_window ? "true" : "false");
    fputs(",\"same_execution_basis\":\"DF_and_both_UMC_directions_must_coexist_in_one_perf_stat_stream;_historical_collector_provenance_required\",\"df_metric\":", stdout); print_value(run->metric);
    fputs(",\"semantic_applicability\":\"unvalidated_client_event_mapping_and_units\",\"accepted\":false,\"conditional_64_bytes_per_CAS\":{\"qualified_comparison_inputs\":", stdout); fputs(run->rates ? "true" : "false", stdout);
    fputs(",\"runtime_basis\":\"maximum_same_stream_UMC_event_runtime_ns\",\"umc_read_MB_s\":", stdout);
    if (run->rates) fprintf(stdout, "%.17g", run->umc_read); else fputs("null", stdout);
    fputs(",\"umc_write_MB_s\":", stdout); if (run->rates) fprintf(stdout, "%.17g", run->umc_write); else fputs("null", stdout);
    fputs(",\"df_counter_arithmetic_matches_printed_metric\":", stdout); fputs(run->rates ? run->arithmetic ? "true" : "false" : "null", stdout);
    fputs(",\"df_to_same_direction_umc_ratio\":", stdout); if (run->ratio_known) fprintf(stdout, "%.17g", run->ratio); else fputs("null", stdout);
    fputs(",\"ratio_status\":", stdout); quote(!run->rates || !numeric(run->metric) ? "unavailable" : !run->arithmetic ? "metric_arithmetic_mismatch" : run->ratio_nonfinite ? "nonfinite_derived_ratio" : run->ratio_known ? "finite_conditional_comparison" : "zero_denominator");
    fputs(",\"accepted_for_physical_bandwidth\":false},\"rows\":", stdout); print_rows(run); fputc('}', stdout);
}

static void print_failure_log(const char* path)
{
    const int fd = open(path, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
    struct stat before, after;
    char bytes[65537];
    bool valid = fd >= 0 && fstat(fd, &before) == 0 && S_ISREG(before.st_mode) && before.st_size >= 0 && before.st_size <= 65536;
    size_t length = 0;
    while (valid && length < (size_t)before.st_size)
    {
        ssize_t got;
        do { got = read(fd, bytes + length, (size_t)before.st_size - length); } while (got < 0 && errno == EINTR);
        valid = got > 0;
        length += got > 0 ? (size_t)got : 0;
    }
    valid = valid && fstat(fd, &after) == 0 && before.st_size == after.st_size &&
            before.st_mtim.tv_sec == after.st_mtim.tv_sec && before.st_mtim.tv_nsec == after.st_mtim.tv_nsec &&
            before.st_ctim.tv_sec == after.st_ctim.tv_sec && before.st_ctim.tv_nsec == after.st_ctim.tv_nsec;
    if (fd >= 0) valid = close(fd) == 0 && valid;
    bytes[length] = 0;
    const bool unsupported = valid && memchr(bytes, 0, length) == NULL && strstr(bytes, "event is not supported") != NULL;
    fputs("{\"status\":", stdout);
    quote(!valid ? "unavailable_failure_log" : length == 0 ? "empty_failure_log" : unsupported ? "collector_reported_unsupported_event" : "collector_diagnostics_present");
    fputs(",\"accepted\":false,\"bytes_hex\":\"", stdout);
    for (size_t i = 0; valid && i < length; i += 1) fprintf(stdout, "%02x", (unsigned char)bytes[i]);
    fputs("\"}", stdout);
}

int main(int argc, char** argv)
{
    const char* paths[6] = { 0 };
    const char* options[] = { "--cpu", "--catalog", "--read", "--read-work", "--write", "--write-work" };
    const char* observe[OBSERVE_LIMIT]; unsigned observe_count = 0;
    const char* failure_logs[OBSERVE_LIMIT]; unsigned failure_count = 0;
    bool valid = true;
    for (int i = 1; valid && i < argc; i += 1)
    {
        bool found = false;
        if (strcmp(argv[i], "--observe") == 0 && i + 1 < argc && observe_count < OBSERVE_LIMIT)
        {
            observe[observe_count++] = argv[++i]; found = true;
        }
        else if (strcmp(argv[i], "--failure-log") == 0 && i + 1 < argc && failure_count < OBSERVE_LIMIT)
        {
            failure_logs[failure_count++] = argv[++i]; found = true;
        }
        else for (unsigned j = 0; !found && j < 6; j += 1)
        {
            if (strcmp(argv[i], options[j]) == 0 && i + 1 < argc && paths[j] == NULL)
            {
                paths[j] = argv[++i]; found = true;
            }
        }
        valid = found;
    }
    for (unsigned i = 0; i < 6; i += 1) valid = valid && paths[i] != NULL;
    if (!valid)
    {
        fputs("usage: uncore_preflight --cpu LSCPU_JSON --catalog PERF_LIST_JSON --read PERF_NDJSON --read-work WORK_JSON --write PERF_NDJSON --write-work WORK_JSON [--observe PERF_NDJSON ...] [--failure-log LOG ...]\n", stderr);
        return 2;
    }
    Input cpu = load(paths[0], false), catalog = load(paths[1], false);
    Run read = { 0 }, write = { 0 };
    read.perf = load(paths[2], true); read.work = load(paths[3], false);
    write.perf = load(paths[4], true); write.work = load(paths[5], false);
    const char* cpu_state = cpu_status(&cpu);
    const char* catalog_state = catalog_status(&catalog);
    const bool identity = strcmp(cpu_state, "matched_9700x_1a_44_0") == 0;
    const bool exposed = strcmp(catalog_state, "matches_published_exposure_not_semantics") == 0;
    qualify(&read, "read", identity, exposed); qualify(&write, "write", identity, exposed);
    fputs("{\"schema\":\"buster_uncore_preflight_1\",\"accepted\":false,\"reason\":\"client_semantic_mapping_not_publicly_validated\",\"cpu_status\":", stdout); quote(cpu_state);
    fputs(",\"expected_cpu\":\"AuthenticAMD_Ryzen_7_9700X_family_26_model_68_stepping_0_decimal__1Ah_44h_0\",\"catalog_status\":", stdout); quote(catalog_state);
    fputs(",\"control_layout_reference\":\"AMD_PPR_57896_Rev3.00_Model44hB0_pages231_237\",\"duty_precision\":\"formatted_percentage_not_exact_enabled_running_tuple\",\"event_and_unit_semantics\":\"unvalidated;_catalog_exposure_and_control_layout_do_not_validate_event_meaning\",\"controls\":{", stdout);
    print_run(&read, "read"); fputc(',', stdout); print_run(&write, "write");
    fputs("},\"additional_observations\":[", stdout);
    for (unsigned i = 0; i < observe_count; i += 1)
    {
        Run other = { 0 }; other.perf = load(observe[i], true); parse_rows(&other);
        if (i) fputc(',', stdout);
        fputs("{\"input_status\":", stdout); quote(other.perf.status);
        fprintf(stdout, ",\"parsed_rows\":%u,\"row_shape_complete\":%s,\"duplicate_events\":%s,\"accepted\":false,\"rows\":", other.count, other.shape ? "true" : "false", other.duplicate ? "true" : "false");
        print_rows(&other); fputc('}', stdout); json_free(&other.perf.json);
    }
    fputs("],\"collection_failure_evidence\":[", stdout);
    for (unsigned i = 0; i < failure_count; i += 1)
    {
        if (i) fputc(',', stdout);
        print_failure_log(failure_logs[i]);
    }
    fputs("]}\n", stdout);
    const bool wrote = fflush(stdout) == 0 && !ferror(stdout);
    json_free(&cpu.json); json_free(&catalog.json); json_free(&read.perf.json); json_free(&read.work.json);
    json_free(&write.perf.json); json_free(&write.work.json);
    return wrote ? 1 : 2; /* No reviewed client event/unit allowlist exists yet. */
}
