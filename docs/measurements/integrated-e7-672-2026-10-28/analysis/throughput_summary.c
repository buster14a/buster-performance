// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded validator for the unchanged #672 microarch.c throughput
// method. It reads receipts only, retains invalid rows in the raw report and
// withholds group summaries unless all five rounds qualify.
#define _GNU_SOURCE
#include <stdbool.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <math.h>
#include <limits.h>

#include "vendor/perf_core.c"
#include "vendor/perf_json.c"

#define BUSTER_THROUGHPUT_COHORTS 25u
#define BUSTER_THROUGHPUT_ROUNDS 5u
#define BUSTER_THROUGHPUT_TASKS 60u
#define BUSTER_THROUGHPUT_BYTES UINT64_C(9507037)
#define BUSTER_THROUGHPUT_FILE_LIMIT (1024u * 1024u)
#define BUSTER_THROUGHPUT_COVERAGE 99.999

static const uint32_t worker_counts[5] = { 1, 2, 4, 8, 15 };
static const char child_header[] = "task\tpid\tcpu\tstatus\tuser_s\tsystem_s\tmaxrss_kb\tminor_faults\tmajor_faults\tvoluntary_cs\tinvoluntary_cs\tobject_bytes\n";

typedef struct Cohort Cohort;
struct Cohort
{
    char label[80];
    uint64_t jobs;
    uint64_t tasks;
    uint64_t lanes;
    uint64_t failures;
    uint64_t maxrss;
    uint64_t minor;
    uint64_t major;
    uint64_t voluntary;
    uint64_t involuntary;
    uint64_t source_bytes;
    uint64_t completed_bytes;
    uint64_t output_bytes;
    uint64_t counter_errors;
    uint64_t cycles;
    uint64_t instructions;
    uint64_t branches;
    uint64_t branch_misses;
    uint64_t retired_ops;
    uint64_t raw_count;
    double wall;
    double user;
    double system;
    double reported_mb;
    double reported_cpu_mb;
    double reported_utilization;
    double coverage;
    uint32_t cpus[64];
    uint32_t cpu_count;
    int identity;
    bool valid;
    bool counters_valid;
};

typedef struct Validation Validation;
struct Validation
{
    FILE* report;
    FILE* errors;
    const char* child_root;
    uint64_t object_bytes;
    Cohort rows[BUSTER_THROUGHPUT_COHORTS];
    uint32_t seen[BUSTER_THROUGHPUT_COHORTS];
    uint32_t lines;
    uint32_t failures;
    uint32_t conditional;
};

static bool integer_text(const char* text, uint64_t* result)
{
    uint64_t value = 0;
    bool valid = text != NULL && text[0] != 0;
    for (uint32_t at = 0; valid && text[at] != 0; at += 1)
    {
        const uint8_t byte = (uint8_t)text[at];
        valid = byte >= '0' && byte <= '9' && value <= (UINT64_MAX - (uint64_t)(byte - '0')) / 10;
        if (valid) value = value * 10 + (uint64_t)(byte - '0');
    }
    if (valid) *result = value;
    return valid;
}

static bool decimal_text(const char* text, double* result)
{
    char* end = NULL;
    errno = 0;
    const double value = text != NULL ? strtod(text, &end) : NAN;
    const bool valid = text != NULL && text[0] != 0 && end != text && *end == 0 && errno == 0 && isfinite(value) && value >= 0;
    if (valid) *result = value;
    return valid;
}

static bool json_text(const PerfJson* json, const char* key, PerfJsonKind kind, char* text, size_t capacity)
{
    const uint32_t node = perf_json_find(json, 0, key);
    bool valid = node < json->node_count && json->nodes[node].kind == kind;
    if (valid)
    {
        const PerfBytes bytes = perf_json_text(json, node);
        valid = bytes.size < capacity && memchr(bytes.data, 0, bytes.size) == NULL;
        if (valid)
        {
            memcpy(text, bytes.data, bytes.size);
            text[bytes.size] = 0;
        }
    }
    return valid;
}

static bool json_integer(const PerfJson* json, const char* key, uint64_t* value)
{
    char text[64];
    return json_text(json, key, PERF_JSON_NUMBER, text, sizeof(text)) && integer_text(text, value);
}

static bool json_decimal(const PerfJson* json, const char* key, double* value)
{
    char text[128];
    return json_text(json, key, PERF_JSON_NUMBER, text, sizeof(text)) && decimal_text(text, value);
}

static bool json_false(const PerfJson* json, const char* key)
{
    const uint32_t node = perf_json_find(json, 0, key);
    return node < json->node_count && json->nodes[node].kind == PERF_JSON_BOOLEAN && !json->nodes[node].boolean;
}

static bool expect(Validation* validation, bool condition, const char* label, const char* message)
{
    if (!condition) fprintf(validation->errors, "FAIL %s: %s\n", label, message);
    return condition;
}

static int cohort_identity(const char* label)
{
    int found = -1;
    for (uint32_t round = 0; round < 5; round += 1)
    {
        for (uint32_t worker = 0; worker < 5; worker += 1)
        {
            char expected[80];
            snprintf(expected, sizeof(expected), "suite-throughput-r%u-j%u", round, worker_counts[worker]);
            if (strcmp(expected, label) == 0) found = (int)(round * 5 + worker);
        }
    }
    return found;
}

static bool parse_cohort(PerfBytes line, Cohort* cohort)
{
    PerfJson json = { 0 };
    bool valid = perf_json_parse(&json, line) && json.node_count != 0 && json.nodes[0].kind == PERF_JSON_OBJECT;
    char stage[32];
    char binary[128];
    char event[64];
    valid = valid && json_text(&json, "label", PERF_JSON_STRING, cohort->label, sizeof(cohort->label)) &&
            json_text(&json, "stage", PERF_JSON_STRING, stage, sizeof(stage)) && strcmp(stage, "compile") == 0 &&
            json_text(&json, "binary", PERF_JSON_STRING, binary, sizeof(binary)) && strcmp(binary, "./compiler-native") == 0 &&
            json_text(&json, "raw_event", PERF_JSON_STRING, event, sizeof(event)) && event[0] == 0 &&
            json_false(&json, "scalar") && json_false(&json, "timing");
#define BUSTER_READ_INTEGER(key, field) valid = json_integer(&json, key, &cohort->field) && valid
    BUSTER_READ_INTEGER("jobs", jobs);
    BUSTER_READ_INTEGER("tasks", tasks);
    BUSTER_READ_INTEGER("lanes", lanes);
    BUSTER_READ_INTEGER("failures", failures);
    BUSTER_READ_INTEGER("maxrss_per_process_kb", maxrss);
    BUSTER_READ_INTEGER("minor_faults", minor);
    BUSTER_READ_INTEGER("major_faults", major);
    BUSTER_READ_INTEGER("voluntary_cs", voluntary);
    BUSTER_READ_INTEGER("involuntary_cs", involuntary);
    BUSTER_READ_INTEGER("input_bytes_per_task", source_bytes);
    BUSTER_READ_INTEGER("completed_bytes", completed_bytes);
    BUSTER_READ_INTEGER("output_bytes", output_bytes);
    BUSTER_READ_INTEGER("counter_errors", counter_errors);
    BUSTER_READ_INTEGER("cycles_u", cycles);
    BUSTER_READ_INTEGER("instructions_u", instructions);
    BUSTER_READ_INTEGER("branches_u", branches);
    BUSTER_READ_INTEGER("branch_misses_u", branch_misses);
    BUSTER_READ_INTEGER("retired_ops_u", retired_ops);
    BUSTER_READ_INTEGER("raw_event_count", raw_count);
#undef BUSTER_READ_INTEGER
#define BUSTER_READ_DECIMAL(key, field) valid = json_decimal(&json, key, &cohort->field) && valid
    BUSTER_READ_DECIMAL("wall_s", wall);
    BUSTER_READ_DECIMAL("user_s", user);
    BUSTER_READ_DECIMAL("system_s", system);
    BUSTER_READ_DECIMAL("MB_per_s", reported_mb);
    BUSTER_READ_DECIMAL("CPU_seconds_per_MB", reported_cpu_mb);
    BUSTER_READ_DECIMAL("CPU_utilization", reported_utilization);
    BUSTER_READ_DECIMAL("counter_min_running_pct", coverage);
#undef BUSTER_READ_DECIMAL
    const uint32_t cpus = perf_json_find(&json, 0, "cpus");
    const bool array = cpus < json.node_count && json.nodes[cpus].kind == PERF_JSON_ARRAY && json.nodes[cpus].children <= 64;
    valid = array && valid;
    if (array)
    {
        uint32_t node = cpus + 1;
        cohort->cpu_count = json.nodes[cpus].children;
        for (uint32_t cpu = 0; cpu < cohort->cpu_count; cpu += 1)
        {
            char text[64];
            uint64_t value = 0;
            const PerfBytes bytes = perf_json_text(&json, node);
            bool number = json.nodes[node].kind == PERF_JSON_NUMBER && bytes.size < sizeof(text);
            if (number)
            {
                memcpy(text, bytes.data, bytes.size);
                text[bytes.size] = 0;
                number = integer_text(text, &value) && value < 1024;
            }
            valid = number && valid;
            cohort->cpus[cpu] = (uint32_t)value;
            node = json.nodes[node].next;
        }
    }
    cohort->identity = cohort_identity(cohort->label);
    perf_json_free(&json);
    return valid;
}

static bool children(Validation* validation, const Cohort* cohort)
{
    char path[PATH_MAX];
    const int bytes = snprintf(path, sizeof(path), "%s/%s/children.tsv", validation->child_root, cohort->label);
    PerfBuffer input = { 0 };
    bool valid = bytes >= 0 && (size_t)bytes < sizeof(path) && perf_read_file(path, &input) && input.size <= BUSTER_THROUGHPUT_FILE_LIMIT &&
                 memchr(input.data, 0, input.size) == NULL &&
                 perf_buffer_byte(&input, 0);
    valid = expect(validation, valid, cohort->label, "child receipt is present and bounded") && valid;
    uint64_t statuses[BUSTER_THROUGHPUT_TASKS] = { 0 };
    uint64_t pids[BUSTER_THROUGHPUT_TASKS] = { 0 };
    uint32_t cpu_tasks[64] = { 0 };
    uint64_t rss = 0;
    uint64_t minor = 0;
    uint64_t major = 0;
    uint64_t voluntary = 0;
    uint64_t involuntary = 0;
    uint64_t output = 0;
    uint64_t failures = 0;
    uint32_t count = 0;
    double user = 0;
    double system = 0;
    const size_t header_bytes = strlen(child_header);
    if (valid) valid = input.size > header_bytes && memcmp(input.data, child_header, header_bytes) == 0;
    char* at = valid ? (char*)input.data + header_bytes : NULL;
    while (valid && *at != 0)
    {
        char* end = strchr(at, '\n');
        valid = end != NULL && (size_t)(end - at) < 1024 && count < cohort->tasks;
        if (!valid) break;
        *end = 0;
        char* fields[12] = { 0 };
        uint32_t field_count = 0;
        char* cursor = at;
        for (; cursor != NULL && field_count < 12; field_count += 1) fields[field_count] = strsep(&cursor, "\t");
        valid = field_count == 12 && cursor == NULL;
        uint64_t values[12] = { 0 };
        double child_user = 0;
        double child_system = 0;
        for (uint32_t field = 0; valid && field < 12; field += 1)
        {
            valid = field == 4 ? decimal_text(fields[field], &child_user) : field == 5 ? decimal_text(fields[field], &child_system) : integer_text(fields[field], values + field);
        }
        if (valid)
        {
            const uint64_t task = values[0];
            valid = task < cohort->tasks && statuses[task] == 0 && values[1] != 0 && values[3] <= 255 && values[6] > 0 &&
                    child_user + child_system > 0 && values[7] <= UINT64_MAX / cohort->tasks && values[8] <= UINT64_MAX / cohort->tasks &&
                    values[9] <= UINT64_MAX / cohort->tasks && values[10] <= UINT64_MAX / cohort->tasks;
            for (uint32_t earlier = 0; earlier < count; earlier += 1) valid = values[1] != pids[earlier] && valid;
            int cpu_index = -1;
            for (uint32_t cpu = 0; cpu < cohort->cpu_count; cpu += 1) if (cohort->cpus[cpu] == values[2]) cpu_index = (int)cpu;
            valid = cpu_index >= 0 && valid;
            if (valid)
            {
                cpu_tasks[cpu_index] += 1;
                statuses[task] = 1;
                pids[count] = values[1];
                rss = values[6] > rss ? values[6] : rss;
                minor += values[7];
                major += values[8];
                voluntary += values[9];
                involuntary += values[10];
                output += values[11];
                failures += values[3] != 0;
                user += child_user;
                system += child_system;
                valid = values[11] == (values[3] == 0 ? validation->object_bytes : 0);
            }
            fprintf(validation->report, "child\t%s\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%.6f\t%.6f\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n",
                    cohort->label, values[0], values[1], values[2], values[3], child_user, child_system, values[6], values[7], values[8], values[9], values[10], values[11]);
        }
        count += 1;
        at = end + 1;
    }
    valid = expect(validation, valid, cohort->label, "child rows have exact fields, unique tasks/PIDs, listed CPUs and expected object sizes") && valid;
    for (uint32_t cpu = 0; cpu < cohort->cpu_count; cpu += 1) valid = expect(validation, cpu_tasks[cpu] != 0, cohort->label, "every listed CPU received a child") && valid;
    const double tolerance = (cohort->tasks + 2) * 0.5e-6;
    valid = expect(validation, count == cohort->tasks && failures == cohort->failures && output == cohort->output_bytes && rss == cohort->maxrss &&
                   minor == cohort->minor && major == cohort->major && voluntary == cohort->voluntary && involuntary == cohort->involuntary &&
                   fabs(user - cohort->user) <= tolerance && fabs(system - cohort->system) <= tolerance,
                   cohort->label, "child counts/statuses/resources/output agree with aggregate JSON within its print precision") && valid;
    free(input.data);
    return valid;
}

static bool validate_cohort(Validation* validation, Cohort* cohort)
{
    bool valid = expect(validation, cohort->identity >= 0, cohort->label, "label names one of the required five rounds and worker counts");
    if (valid)
    {
        const uint32_t worker = (uint32_t)cohort->identity % 5;
        valid = expect(validation, cohort->jobs == worker_counts[worker] && cohort->tasks == cohort->jobs * 4 && cohort->lanes == 1,
                       cohort->label, "workers/tasks/lanes match the unchanged method") && valid;
        valid = expect(validation, cohort->cpu_count == cohort->jobs, cohort->label, "actual CPU array has exactly one entry per worker") && valid;
        for (uint32_t cpu = 0; cpu < cohort->cpu_count; cpu += 1)
        {
            for (uint32_t earlier = 0; earlier < cpu; earlier += 1) valid = expect(validation, cohort->cpus[cpu] != cohort->cpus[earlier], cohort->label, "actual CPU array has unique IDs") && valid;
        }
        valid = expect(validation, cohort->jobs != 1 || (cohort->cpu_count == 1 && cohort->cpus[0] == 2), cohort->label, "single-worker run uses the method's CPU 2") && valid;
        valid = expect(validation, cohort->source_bytes == BUSTER_THROUGHPUT_BYTES && cohort->failures <= cohort->tasks &&
                       cohort->completed_bytes == BUSTER_THROUGHPUT_BYTES * (cohort->tasks - cohort->failures) && cohort->raw_count == 0,
                       cohort->label, "source/completed bytes and raw-event mode match") && valid;
        valid = expect(validation, cohort->wall > 0 && cohort->maxrss > 0 && cohort->user + cohort->system > 0 && cohort->coverage <= 100,
                       cohort->label, "wall/RSS/CPU time are positive and coverage is bounded") && valid;
        if (valid)
        {
            const double mb = (double)cohort->completed_bytes / 1e6;
            const double attempted_mb = (double)(cohort->tasks * BUSTER_THROUGHPUT_BYTES) / 1e6;
            valid = expect(validation, fabs(cohort->reported_mb - mb / cohort->wall) <= 0.000002 + fabs(mb / cohort->wall) * 2e-8 &&
                           fabs(cohort->reported_cpu_mb - (cohort->user + cohort->system) / attempted_mb) <= 0.000001 &&
                           fabs(cohort->reported_utilization - (cohort->user + cohort->system) / cohort->wall) <= 0.00001,
                           cohort->label, "reported derived fields agree with rounded raw times") && valid;
            valid = children(validation, cohort) && valid;
        }
        valid = expect(validation, cohort->failures == 0 && cohort->output_bytes == validation->object_bytes * cohort->tasks,
                       cohort->label, "every compile succeeds and emits the qualified object byte count") && valid;
    }
    cohort->valid = valid;
    cohort->counters_valid = valid && cohort->counter_errors == 0 && cohort->coverage >= BUSTER_THROUGHPUT_COVERAGE &&
                             cohort->coverage <= 100 && cohort->instructions > 0 && cohort->cycles > 0;
    return valid;
}

static void triple(FILE* output, const double* input, uint32_t count)
{
    double ordered[5] = { 0 };
    for (uint32_t at = 0; at < count; at += 1)
    {
        uint32_t put = at;
        while (put != 0 && ordered[put - 1] > input[at])
        {
            ordered[put] = ordered[put - 1];
            put -= 1;
        }
        ordered[put] = input[at];
    }
    if (count == 5) fprintf(output, "%.9g [%.9g, %.9g]", ordered[2], ordered[0], ordered[4]);
    else fprintf(output, "NA (%u/5 valid)", count);
}

static void summary(Validation* validation)
{
    fprintf(validation->report, "\nworkers\tMB_per_s median[min,max]\tmax_child_RSS_KiB median[min,max]\tminor_faults_per_child median[min,max]\tmajor_faults_per_child median[min,max]\tuser_s_per_child median[min,max]\tsystem_s_per_child median[min,max]\tuser_plus_system_s_per_child median[min,max]\tinstructions_u_per_source_MB median[min,max]\tcycles_u_per_source_MB median[min,max]\tIPC_u median[min,max]\n");
    for (uint32_t worker = 0; worker < 5; worker += 1)
    {
        double metrics[10][5] = { 0 };
        uint32_t valid = 0;
        uint32_t counters = 0;
        for (uint32_t round = 0; round < 5; round += 1)
        {
            const uint32_t at = round * 5 + worker;
            const Cohort* row = validation->rows + at;
            if (validation->seen[at] == 1 && row->valid)
            {
                metrics[0][valid] = row->completed_bytes / 1e6 / row->wall;
                metrics[1][valid] = (double)row->maxrss;
                metrics[2][valid] = (double)row->minor / row->tasks;
                metrics[3][valid] = (double)row->major / row->tasks;
                metrics[4][valid] = row->user / row->tasks;
                metrics[5][valid] = row->system / row->tasks;
                metrics[6][valid] = (row->user + row->system) / row->tasks;
                valid += 1;
                if (row->counters_valid)
                {
                    metrics[7][counters] = row->instructions / (row->completed_bytes / 1e6);
                    metrics[8][counters] = row->cycles / (row->completed_bytes / 1e6);
                    metrics[9][counters] = (double)row->instructions / row->cycles;
                    counters += 1;
                }
            }
        }
        fprintf(validation->report, "%u", worker_counts[worker]);
        for (uint32_t metric = 0; metric < 10; metric += 1)
        {
            fputc('\t', validation->report);
            triple(validation->report, metrics[metric], metric < 7 ? valid : counters);
        }
        fputc('\n', validation->report);
    }
}

static int validate_file(const char* path, const char* child_root, uint64_t object_bytes, FILE* report, FILE* errors)
{
    Validation validation = { .report = report, .errors = errors, .child_root = child_root, .object_bytes = object_bytes };
    PerfBuffer input = { 0 };
    const bool opened = perf_read_file(path, &input) && input.size <= BUSTER_THROUGHPUT_FILE_LIMIT;
    if (!opened)
    {
        fprintf(errors, "FAIL dataset: cannot read regular JSONL input within the 1 MiB campaign limit: %s\n", path);
        validation.failures += 1;
    }
    fprintf(report, "cohort\tlabel\tvalid\tcounters_valid\tjobs\ttasks\tsuccesses\tfailures\twall_s\tuser_s\tsystem_s\tmax_child_RSS_KiB\tminor_faults\tmajor_faults\tvoluntary_cs\tinvoluntary_cs\tcompleted_bytes\toutput_bytes\traw_MB_per_s\tcomputed_MB_per_s\tcounter_errors\tmin_running_pct\tcycles_u\tinstructions_u\tbranches_u\tbranch_misses_u\tretired_ops_u_unqualified_event\tinstructions_u_per_MB\tcycles_u_per_MB\tIPC_u\tCPUs\n");
    fprintf(report, "child\tlabel\ttask\tpid\tcpu\tstatus\tuser_s\tsystem_s\tmaxRSS_KiB\tminor_faults\tmajor_faults\tvoluntary_cs\tinvoluntary_cs\tobject_bytes\n");
    for (size_t first = 0; opened && first < input.size;)
    {
        size_t end = first;
        while (end < input.size && input.data[end] != '\n') end += 1;
        Cohort row = { .identity = -1 };
        validation.lines += 1;
        const bool parsed = parse_cohort((PerfBytes){ .data = input.data + first, .size = end - first }, &row);
        if (!parsed)
        {
            fprintf(errors, "FAIL line %u: malformed/missing/duplicate JSON fields or unexpected method mode; original line retained in %s\n", validation.lines, path);
            validation.failures += 1;
        }
        else
        {
            const bool valid = validate_cohort(&validation, &row);
            if (!valid) validation.failures += 1;
            if (!row.counters_valid) validation.conditional += 1;
            if (row.identity >= 0)
            {
                const uint32_t at = (uint32_t)row.identity;
                validation.seen[at] += 1;
                validation.rows[at] = row;
            }
            fprintf(report, "cohort\t%s\t%s\t%s\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%.9f\t%.6f\t%.6f\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%.6f\t%.9f\t%" PRIu64 "\t%.5f\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t",
                    row.label, row.valid ? "yes" : "no", row.counters_valid ? "yes" : "no", row.jobs, row.tasks, row.tasks >= row.failures ? row.tasks - row.failures : 0,
                    row.failures, row.wall, row.user, row.system, row.maxrss, row.minor, row.major, row.voluntary, row.involuntary, row.completed_bytes, row.output_bytes,
                    row.reported_mb, row.wall > 0 ? row.completed_bytes / 1e6 / row.wall : 0, row.counter_errors, row.coverage, row.cycles, row.instructions, row.branches, row.branch_misses, row.retired_ops);
            if (row.counters_valid) fprintf(report, "%.9f\t%.9f\t%.9f\t", row.instructions / (row.completed_bytes / 1e6), row.cycles / (row.completed_bytes / 1e6), (double)row.instructions / row.cycles);
            else fprintf(report, "NA\tNA\tNA\t");
            for (uint32_t cpu = 0; cpu < row.cpu_count; cpu += 1) fprintf(report, "%s%u", cpu != 0 ? "," : "", row.cpus[cpu]);
            fputc('\n', report);
        }
        first = end < input.size ? end + 1 : end;
    }
    if (validation.lines != BUSTER_THROUGHPUT_COHORTS)
    {
        fprintf(errors, "FAIL dataset: %u JSON lines, expected exactly 25\n", validation.lines);
        validation.failures += 1;
    }
    for (uint32_t at = 0; at < BUSTER_THROUGHPUT_COHORTS; at += 1)
    {
        if (validation.seen[at] != 1)
        {
            fprintf(errors, "FAIL dataset: round=%u workers=%u has %u records, expected exactly one\n", at / 5, worker_counts[at % 5], validation.seen[at]);
            validation.failures += 1;
        }
    }
    summary(&validation);
    fprintf(report, "\nvalidation\tcohort_failures=%u\tcounter_conditional_rows=%u\tsource_bytes_per_task=%" PRIu64 "\tobject_bytes_expected=%" PRIu64 "\n", validation.failures, validation.conditional, BUSTER_THROUGHPUT_BYTES, object_bytes);
    fprintf(report, "scope\tcurrent-e7 observation only; no causal comparison/additive PR gains; MB=1000000 source bytes; RSS is maximum single-child KiB, never simultaneous/summed peak; no physical traffic estimate; counts unscaled\n");
    free(input.data);
    return (validation.failures != 0 ? 1 : 0) | (validation.conditional != 0 ? 2 : 0);
}

#ifndef BUSTER_THROUGHPUT_NO_MAIN
int main(int argc, char** argv)
{
    uint64_t object_bytes = 0;
    const bool arguments = argc == 4 && integer_text(argv[3], &object_bytes) && object_bytes > 0 && object_bytes <= UINT64_MAX / BUSTER_THROUGHPUT_TASKS;
    int result = 1;
    if (arguments) result = validate_file(argv[1], argv[2], object_bytes, stdout, stderr);
    else fprintf(stderr, "usage: throughput-summary THROUGHPUT.jsonl CHILD_ROOT EXPECTED_OBJECT_BYTES\n");
    return result;
}
#endif
