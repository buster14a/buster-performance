// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original offline policy controls.
#define _GNU_SOURCE
#include "json.h"
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static unsigned checks, failures;
static const char* suffixes[] = {
    "hardware/9700x-lscpu.json", "hardware/9700x-perf-list-uncore.json",
    "raw/9700x/df-umc-read.perf.json", "raw/9700x/df-umc-read.work.json",
    "raw/9700x/df-umc-write.perf.json", "raw/9700x/df-umc-write.work.json",
};
static void expect(bool ok, const char* label)
{
    checks += 1; failures += !ok;
    if (!ok) fprintf(stderr, "preflight: %s\n", label);
}
static char* read_text(const char* path, size_t* length)
{
    FILE* f = fopen(path, "rb");
    if (f == NULL || fseek(f, 0, SEEK_END) != 0) { if (f != NULL) fclose(f); return NULL; }
    const long size = ftell(f);
    if (size < 0 || size > JSON_INPUT_LIMIT || fseek(f, 0, SEEK_SET) != 0) { fclose(f); return NULL; }
    char* data = malloc((size_t)size + 1);
    bool ok = data != NULL && fread(data, 1, (size_t)size, f) == (size_t)size && !ferror(f);
    ok = fclose(f) == 0 && ok;
    if (!ok) { free(data); return NULL; }
    data[size] = 0; *length = (size_t)size; return data;
}
static bool write_text(const char* path, const char* text, size_t length)
{
    FILE* f = fopen(path, "wb");
    bool ok = f != NULL && fwrite(text, 1, length, f) == length;
    if (f != NULL) ok = fclose(f) == 0 && ok;
    return ok;
}
static bool copy(const char* from, const char* to)
{
    size_t length = 0; char* text = read_text(from, &length);
    const bool ok = text != NULL && write_text(to, text, length);
    free(text); return ok;
}
static bool replace(const char* path, const char* old, const char* new_text)
{
    size_t length = 0; char* text = read_text(path, &length);
    char* at = text != NULL ? strstr(text, old) : NULL;
    bool ok = at != NULL;
    if (ok)
    {
        const size_t prefix = (size_t)(at - text), old_length = strlen(old), new_length = strlen(new_text);
        char* changed = malloc(length - old_length + new_length + 1);
        ok = changed != NULL;
        if (ok)
        {
            memcpy(changed, text, prefix); memcpy(changed + prefix, new_text, new_length);
            memcpy(changed + prefix + new_length, at + old_length, length - prefix - old_length);
            ok = write_text(path, changed, length - old_length + new_length);
        }
        free(changed);
    }
    free(text); return ok;
}
static int invoke(const char* tool, char paths[6][PATH_MAX], const char* output, const char* error)
{
    const pid_t child = fork();
    if (child == 0)
    {
        const int out = open(output, O_WRONLY | O_CREAT | O_EXCL, 0600);
        const int err = open(error, O_WRONLY | O_CREAT | O_EXCL, 0600);
        if (out < 0 || err < 0 || dup2(out, 1) < 0 || dup2(err, 2) < 0) _exit(125);
        close(out); close(err); alarm(15);
        execl(tool, tool, "--cpu", paths[0], "--catalog", paths[1], "--read", paths[2], "--read-work", paths[3],
              "--write", paths[4], "--write-work", paths[5], NULL);
        _exit(127);
    }
    int status = 0; pid_t got;
    do { got = waitpid(child, &status, 0); } while (got < 0 && errno == EINTR);
    return child > 0 && got == child && WIFEXITED(status) ? WEXITSTATUS(status) : 128;
}
static const JsonToken* lookup(const JsonDoc* doc, const char* path)
{
    char text[512];
    if (strlen(path) >= sizeof(text)) return NULL;
    strcpy(text, path);
    const JsonToken* token = json_root(doc, 0);
    char* state = NULL;
    for (char* part = strtok_r(text, "/", &state); part != NULL; part = strtok_r(NULL, "/", &state))
    {
        if (token != NULL && token->type == JSON_ARRAY)
        {
            char* end = NULL; const unsigned long index = strtoul(part, &end, 10);
            token = end != part && *end == 0 ? json_at(doc, token, (size_t)index) : NULL;
        }
        else token = json_member(doc, token, part);
    }
    return token;
}
static bool reset(const char* historic, const char* directory, char paths[6][PATH_MAX])
{
    bool ok = true;
    for (unsigned i = 0; i < 6; i += 1)
    {
        char from[PATH_MAX];
        snprintf(from, sizeof(from), "%s/%s", historic, suffixes[i]);
        snprintf(paths[i], PATH_MAX, "%s/input-%u.json", directory, i);
        ok = copy(from, paths[i]) && ok;
    }
    return ok;
}
static JsonDoc run(const char* tool, char paths[6][PATH_MAX], const char* directory, const char* name)
{
    char output[PATH_MAX], error[PATH_MAX];
    snprintf(output, sizeof(output), "%s/%s.json", directory, name);
    snprintf(error, sizeof(error), "%s/%s.stderr", directory, name);
    expect(invoke(tool, paths, output, error) == 1, name);
    size_t length = 0; char* text = read_text(output, &length);
    char why[256]; JsonDoc doc = { 0 };
    expect(text != NULL && json_parse(&doc, text, length, 0, why, sizeof(why)), "receipt is complete strict JSON");
    free(text);
    const JsonToken* accepted = lookup(&doc, "accepted");
    expect(accepted != NULL && accepted->type == JSON_FALSE, "no semantic acceptance without reviewed client mapping");
    size_t errors = 0; text = read_text(error, &errors);
    expect(text != NULL && errors == 0, "bounded disposition emits no unexpected errors"); free(text);
    return doc;
}
static void field_is(const JsonDoc* doc, const char* path, const char* expected)
{
    expect(json_equal(doc, lookup(doc, path), expected), path);
}
static void field_bool(const JsonDoc* doc, const char* path, bool expected)
{
    const JsonToken* t = lookup(doc, path);
    expect(t != NULL && t->type == (expected ? JSON_TRUE : JSON_FALSE), path);
}
static void field_null(const JsonDoc* doc, const char* path)
{
    const JsonToken* t = lookup(doc, path); expect(t != NULL && t->type == JSON_NULL, path);
}
static void close_doc(JsonDoc* doc) { json_free(doc); }

typedef struct
{
    const char* name;
    unsigned input;
    const char* before;
    const char* after;
    const char* field;
    const char* expected;
    bool boolean;
} Mutation;
int main(int argc, char** argv)
{
    if (argc != 3) { fputs("usage: preflight_test PREFLIGHT HISTORICAL_MEASUREMENT_DIRECTORY\n", stderr); return 2; }
    char directory[] = "preflight-test-XXXXXX";
    expect(mkdtemp(directory) != NULL, "private fixture directory");
    char paths[6][PATH_MAX];
    expect(reset(argv[2], directory, paths), "preserved fixtures copied without writes to originals");
    JsonDoc baseline = run(argv[1], paths, directory, "frozen");
    field_is(&baseline, "cpu_status", "matched_9700x_1a_44_0");
    field_is(&baseline, "catalog_status", "matches_published_exposure_not_semantics");
    field_bool(&baseline, "controls/read/conditional_64_bytes_per_CAS/qualified_comparison_inputs", true);
    field_bool(&baseline, "controls/write/conditional_64_bytes_per_CAS/qualified_comparison_inputs", true);
    const char* rates[] = { "controls/read/conditional_64_bytes_per_CAS/umc_read_MB_s", "controls/read/conditional_64_bytes_per_CAS/umc_write_MB_s", "controls/write/conditional_64_bytes_per_CAS/umc_read_MB_s", "controls/write/conditional_64_bytes_per_CAS/umc_write_MB_s" };
    const double expected[] = { 31654.565245885075, 19430.601803715897, 31553.06099788236, 19372.279043968338 };
    for (unsigned i = 0; i < 4; i += 1)
    {
        double actual = 0;
        expect(json_number(&baseline, lookup(&baseline, rates[i]), &actual) && fabs(actual - expected[i]) < 1e-8, rates[i]);
    }
    field_is(&baseline, "controls/read/df_metric/status", "finite");
    field_is(&baseline, "controls/read/semantic_applicability", "unvalidated_client_event_mapping_and_units");
    close_doc(&baseline);
    const Mutation mutations[] = {
        { "cpu-model", 0, "\"data\": \"68\"", "\"data\": \"80\"", "cpu_status", "unsupported_cpu_identity", false },
        { "cpu-stepping", 0, "\"data\": \"0\"", "\"data\": \"1\"", "cpu_status", "unsupported_cpu_identity", false },
        { "cpu-missing", 0, "\"CPU family:\"", "\"other:\"", "cpu_status", "missing_identity", false },
        { "cpu-duplicate", 0, "\"field\": \"Model:\",\n         \"data\": \"68\"", "\"field\": \"Model:\", \"data\": \"68\"}, {\"field\": \"Model:\", \"data\": \"68\"", "cpu_status", "duplicate_identity_field", false },
        { "cpu-duplicate-missing-data", 0, "\"field\": \"Model:\",\n         \"data\": \"68\"", "\"field\": \"Model:\"}, {\"field\": \"Model:\", \"data\": \"68\"", "cpu_status", "duplicate_identity_field", false },
        { "cpu-vendor", 0, "AuthenticAMD", "GenuineIntel", "cpu_status", "unsupported_cpu_identity", false },
        { "missing-pmu", 1, "amd_umc_0/umc_cas_cmd.rd/", "missing/umc_cas_cmd.rd/", "catalog_status", "missing_pmu_or_metric_entry", false },
        { "umc-encoding", 1, "amd_umc/event=0xa,rdwrmask=1/", "amd_umc/event=0xa,rdwrmask=3/", "catalog_status", "encoding_or_unit_or_expression_changed", false },
        { "df-encoding", 1, "amd_df/event=0x1f,umask=0xffe/", "amd_df/event=0x20,umask=0xffe/", "catalog_status", "encoding_or_unit_or_expression_changed", false },
        { "metric-expression", 1, "(local_or_remote_socket_read_data_beats_dram_0 +", "(local_or_remote_socket_read_data_beats_dram_1 +", "catalog_status", "encoding_or_unit_or_expression_changed", false },
        { "missing-metric", 1, "\"dram_read_bandwidth_for_local_or_remote_socket\"", "\"other_metric\"", "catalog_status", "missing_pmu_or_metric_entry", false },
        { "unsupported-counter", 2, "792151560.000000", "<not supported>", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "null-counter", 2, "\"counter-value\" : \"792151560.000000\"", "\"counter-value\" : null", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "missing-counter", 2, "\"counter-value\" : \"792151560.000000\"", "\"other-counter\" : \"792151560.000000\"", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "not-counted", 2, "792151560.000000", "<not counted>", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "nan-counter", 2, "792151560.000000", "NaN", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "negative-counter", 2, "792151560.000000", "-1", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "fraction-counter", 2, "792151560.000000", "792151560.5", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "rounded-fraction-counter", 2, "792151560.000000", "1000000000000000.01", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "count-precision", 2, "792151560.000000", "9007199254740992", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "count-exponent", 2, "792151560.000000", "1e3", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "partial-duty", 2, "\"pcnt-running\" : 100.00", "\"pcnt-running\" : 99.99", "controls/read/required_counter_duty_reported_100pct", "false", true },
        { "rounded-partial-duty", 2, "\"pcnt-running\" : 100.00", "\"pcnt-running\" : 99.99999999999999999999", "controls/read/required_counter_duty_reported_100pct", "false", true },
        { "rounded-excess-duty", 2, "\"pcnt-running\" : 100.00", "\"pcnt-running\" : 100.000000000000000001", "controls/read/required_counter_duty_reported_100pct", "false", true },
        { "zero-duty", 2, "\"pcnt-running\" : 100.00", "\"pcnt-running\" : 0", "controls/read/required_counter_duty_reported_100pct", "false", true },
        { "null-duty", 2, "\"pcnt-running\" : 100.00", "\"pcnt-running\" : null", "controls/read/required_counter_duty_reported_100pct", "false", true },
        { "missing-duty", 2, "\"pcnt-running\" : 100.00", "\"other-duty\" : 100.00", "controls/read/required_counter_duty_reported_100pct", "false", true },
        { "runtime-zero", 2, "\"event-runtime\" : 3202164608", "\"event-runtime\" : 0", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "runtime-mismatch", 2, "\"event-runtime\" : 3202164608", "\"event-runtime\" : 9000000000", "controls/read/runtime_envelope_within_one_percent", "false", true },
        { "duration-unit", 2, "\"counter-value\" : \"3202094779.000000\", \"unit\" : \"\"", "\"counter-value\" : \"3202094779.000000\", \"unit\" : \"seconds\"", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "duration-runtime", 2, "\"event-runtime\" : 1,", "\"event-runtime\" : 2,", "controls/read/counter_values_and_runtimes_usable", "false", true },
        { "duration-mismatch", 2, "3202094779.000000", "1.000000", "controls/read/duration_time_within_one_percent", "false", true },
        { "work-clock-mismatch", 3, "3.194061257", "0.001", "controls/read/work_wall_within_one_percent", "false", true },
        { "work-failures", 3, "\"failures\":0", "\"failures\":1", "controls/read/workload_complete", "false", true },
        { "work-collector-errors", 3, "\"counter_errors\":0", "\"counter_errors\":1", "controls/read/workload_complete", "false", true },
        { "work-completed-bytes", 3, "\"completed_bytes\":608450368", "\"completed_bytes\":1", "controls/read/workload_complete", "false", true },
        { "work-cpus", 3, "\"cpus\":[0,1,2,3,4,5,6,7]", "\"cpus\":[0,1,2,3,4,5,6,8]", "controls/read/workload_complete", "false", true },
        { "wrong-direction", 3, "df-umc-read", "df-umc-write", "controls/read/workload_complete", "false", true },
        { "nan-metric", 2, "85075.956450", "NaN", "controls/read/df_metric/status", "nonfinite", false },
        { "infinity-metric", 2, "85075.956450", "inf", "controls/read/df_metric/status", "nonfinite", false },
        { "range-metric", 2, "85075.956450", "1e-9999", "controls/read/df_metric/status", "out_of_range", false },
        { "zero-metric", 2, "85075.956450", "0.000000", "controls/read/df_metric/status", "measured_zero", false },
        { "arithmetic-mismatch", 2, "85075.956450", "1.000000", "controls/read/conditional_64_bytes_per_CAS/ratio_status", "metric_arithmetic_mismatch", false },
        { "missing-metric-value", 2, "\"metric-value\"", "\"other-value\"", "controls/read/df_metric/status", "missing", false },
        { "unsupported-metric", 2, "85075.956450", "<not supported>", "controls/read/df_metric/status", "unsupported", false },
        { "embedded-zero-count", 2, "792151560.000000", "0\\u0000100", "controls/read/counter_values_and_runtimes_usable", "false", true },
    };
    for (unsigned i = 0; i < sizeof(mutations) / sizeof(mutations[0]); i += 1)
    {
        const Mutation* m = mutations + i;
        expect(reset(argv[2], directory, paths) && replace(paths[m->input], m->before, m->after), m->name);
        JsonDoc doc = run(argv[1], paths, directory, m->name);
        if (m->boolean) field_bool(&doc, m->field, false); else field_is(&doc, m->field, m->expected);
        if (m->boolean || m->input < 2) field_bool(&doc, "controls/read/conditional_64_bytes_per_CAS/qualified_comparison_inputs", false);
        const char* scalar_status = strcmp(m->name, "unsupported-counter") == 0 ? "unsupported" :
                                    strcmp(m->name, "not-counted") == 0 ? "not_counted" :
                                    strcmp(m->name, "nan-counter") == 0 ? "nonfinite" :
                                    strcmp(m->name, "negative-counter") == 0 ? "negative" :
                                    strcmp(m->name, "null-counter") == 0 ? "null" :
                                    strcmp(m->name, "missing-counter") == 0 ? "missing" : NULL;
        if (scalar_status != NULL)
        {
            field_is(&doc, "controls/read/rows/0/counter/status", scalar_status);
            field_null(&doc, "controls/read/rows/0/counter/finite_value");
        }
        if (strcmp(m->name, "rounded-partial-duty") == 0) field_is(&doc, "controls/read/rows/0/duty", "reported_partial");
        close_doc(&doc);
    }
    expect(reset(argv[2], directory, paths), "zero denominator reset");
    expect(replace(paths[2], "792151560.000000", "0.000000") && replace(paths[2], "791647323.000000", "0.000000"), "zero denominator controls");
    JsonDoc zero = run(argv[1], paths, directory, "zero-denominator");
    field_is(&zero, "controls/read/rows/0/counter/status", "measured_zero");
    field_is(&zero, "controls/read/conditional_64_bytes_per_CAS/ratio_status", "zero_denominator");
    field_null(&zero, "controls/read/conditional_64_bytes_per_CAS/df_to_same_direction_umc_ratio");
    close_doc(&zero);
    expect(reset(argv[2], directory, paths), "metric owner reset");
    expect(replace(paths[2], "\"metric-value\" : \"85075.956450\", \"metric-unit\" : \"MB/s  dram_read_bandwidth_for_local_or_remote_socket\"", "\"moved\":true") &&
           replace(paths[2], "\"event\" : \"duration_time\",", "\"event\" : \"duration_time\", \"metric-value\" : \"85075.956450\", \"metric-unit\" : \"MB/s  dram_read_bandwidth_for_local_or_remote_socket\","), "metric moved to software duration row");
    JsonDoc owner = run(argv[1], paths, directory, "wrong-metric-owner");
    field_bool(&owner, "controls/read/expected_single_stream_scope", false);
    field_bool(&owner, "controls/read/conditional_64_bytes_per_CAS/qualified_comparison_inputs", false); close_doc(&owner);
    expect(reset(argv[2], directory, paths), "separate write role reset");
    expect(replace(paths[4], "791910515.000000", "<not supported>"), "write-only unsupported counter");
    JsonDoc independent = run(argv[1], paths, directory, "separate-read-write");
    field_bool(&independent, "controls/read/conditional_64_bytes_per_CAS/qualified_comparison_inputs", true);
    field_bool(&independent, "controls/write/conditional_64_bytes_per_CAS/qualified_comparison_inputs", false); close_doc(&independent);
    expect(reset(argv[2], directory, paths) && copy(paths[2], paths[4]), "read stream substituted for write stream");
    JsonDoc role = run(argv[1], paths, directory, "wrong-stream-role");
    field_bool(&role, "controls/read/conditional_64_bytes_per_CAS/qualified_comparison_inputs", true);
    field_bool(&role, "controls/write/conditional_64_bytes_per_CAS/qualified_comparison_inputs", false); close_doc(&role);
    const char* bad[] = { "", "{", "[]", "{}\n{}", "{\"event\":\"a\",\"event\":\"b\"}\n" };
    const char* states[] = { "empty", "malformed_json", "parsed", "parsed", "malformed_json" };
    for (unsigned i = 0; i < 5; i += 1)
    {
        char name[64]; snprintf(name, sizeof(name), "bad-stream-%u", i);
        expect(reset(argv[2], directory, paths) && write_text(paths[2], bad[i], strlen(bad[i])), name);
        JsonDoc doc = run(argv[1], paths, directory, name);
        field_is(&doc, "controls/read/input_status", states[i]);
        field_bool(&doc, "controls/read/conditional_64_bytes_per_CAS/qualified_comparison_inputs", false);
        close_doc(&doc);
    }
    expect(reset(argv[2], directory, paths), "missing file reset");
    expect(unlink(paths[2]) == 0, "missing file authored");
    JsonDoc missing = run(argv[1], paths, directory, "missing-file"); field_is(&missing, "controls/read/input_status", "missing_file"); close_doc(&missing);
    expect(reset(argv[2], directory, paths), "nonregular reset");
    expect(unlink(paths[2]) == 0 && mkfifo(paths[2], 0600) == 0, "FIFO fixture does not block loader");
    JsonDoc fifo = run(argv[1], paths, directory, "fifo"); field_is(&fifo, "controls/read/input_status", "invalid_input_file"); close_doc(&fifo);
    unlink(paths[2]);
    printf("uncore preflight: %u checks, %u failures; retained %s\n", checks, failures, directory);
    return failures != 0;
}
