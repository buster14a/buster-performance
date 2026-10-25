/* Original exact execution-receipt adapter and separate collector-overhead
 * report. No numeric timing is reconstructed from sampled stacks.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
#define BUSTER_HISTORY_NO_MAIN
#include "../performance-first-party-2026-10-25/import.c"

static const char profile_binary[] = "c53ba3994bc64025e7f3fdadadc62ddd2c40a224f5b5e4d65d80131a436400b3";
static const char profile_source[] = "d5aa12b67c129701919a40996bad97236039d858";

static int report_signed_order(const void *left, const void *right)
{
    int64_t a = *(const int64_t *)left;
    int64_t b = *(const int64_t *)right;
    int result = a < b ? -1 : a > b ? 1 : 0;
    return result;
}

static bool report_schema(const char *directory)
{
    const char *names[] = {"execution_id", "pair", "order", "profiled", "warmup", "start_ns", "end_ns", "wall_ns", "user_ns", "system_ns", "peak_rss_kib", "affinity_cpu", "sample_count", "correct", "coverage", "case", "machine", "binary_sha256", "source_receipt"};
    PerfArrowField fields[19] = {0};
    for (size_t i = 0; i < 19; ++i)
    {
        bool small = i == 1 || i == 2 || i == 11 || i == 12;
        bool big = i >= 5 && i <= 10;
        bool boolean = i == 3 || i == 4 || i == 13;
        fields[i] = (PerfArrowField){.name = perf_literal(names[i]), .next = (uint32_t)i + 1, .type = small || big ? 2 : boolean ? 6 : 5, .bit_width = small ? 32 : big ? 64 : 0};
    }
    PerfArrowSchema schema = {.fields = fields, .count = 19, .roots = 19};
    PerfBuffer bytes = {0};
    bool result = perf_arrow_schema_write(&schema, &bytes) && history_write(directory, "executions.schema.arrow", perf_buffer_bytes(&bytes));
    free(bytes.data);
    return result;
}

int main(int argc, char **argv)
{
    bool result = argc == 6 && perf_timestamp(perf_literal(argv[3])) && history_revision(argv[4]) && history_revision(argv[5]) && mkdir(argv[2], 0755) == 0;
    char captures[4096];
    int size = result ? snprintf(captures, sizeof(captures), "%s/captures", argv[2]) : 0;
    result = result && size > 0 && (size_t)size < sizeof(captures) && mkdir(captures, 0755) == 0;
    PerfBuffer rows = {0};
    PerfBuffer resources = {0};
    PerfBuffer contexts = {0};
    int64_t wall[7][2] = {0};
    for (unsigned int pair = 1; pair <= 7 && result; ++pair)
    {
        for (unsigned int mode = 0; mode < 2 && result; ++mode)
        {
            const char *label = mode == 1 ? "profiled" : "unprofiled";
            char directory[4096];
            char source[256];
            char execution[64];
            char receipt_id[64];
            snprintf(source, sizeof(source), "%s-%02u", label, pair);
            snprintf(execution, sizeof(execution), "exec_%s_%02u", label, pair);
            snprintf(receipt_id, sizeof(receipt_id), "receipt_%s_%02u", label, pair);
            size = snprintf(directory, sizeof(directory), "%s/%s", captures, source);
            result = size > 0 && (size_t)size < sizeof(directory) && mkdir(directory, 0755) == 0;
            const char *members[] = {"execution.json", "clock-snapshot.json", "event-attributes.bin", "perf-event-records.bin", "workload.log"};
            for (size_t file = 0; file < 5 && result; ++file)
            {
                char original[512];
                char relative[512];
                char id[96];
                snprintf(original, sizeof(original), "%s/%s", source, members[file]);
                snprintf(relative, sizeof(relative), "captures/%s/%s", source, members[file]);
                snprintf(id, sizeof(id), file == 0 ? "receipt_%s_%02u" : "source_%s_%02u_%zu", label, pair, file);
                PerfBuffer bytes = {0};
                result = history_read(argv[1], original, &bytes) && history_write(argv[2], relative, perf_buffer_bytes(&bytes)) && (resources.size == 0 || perf_buffer_byte(&resources, ',')) && history_resource(&resources, argv[2], id, relative, file < 2 ? "json" : file == 4 ? "text" : "binary", 0, false);
                free(bytes.data);
            }
            char original[512];
            snprintf(original, sizeof(original), "%s/execution.json", source);
            PerfBuffer bytes = {0};
            PerfJson receipt = {0};
            result = result && history_read(argv[1], original, &bytes) && perf_json_parse(&receipt, perf_buffer_bytes(&bytes));
            uint32_t binary = perf_json_find(&receipt, 0, "binary");
            uint32_t command = perf_json_find(&receipt, 0, "argv");
            result = result && perf_json_count(&receipt, command) == 3;
            const char *expected_argv[] = {"./build/compiler", "benchmark-lexer", "src"};
            size_t argument = 0;
            for (uint32_t item = perf_json_first(&receipt, command); item != UINT32_MAX && result; item = perf_json_after(&receipt, command, item))
            {
                result = argument < 3 && perf_json_is(&receipt, item, expected_argv[argument++]);
            }
            result = result && perf_json_is(&receipt, perf_json_find(&receipt, binary, "sha256"), profile_binary) && perf_json_is(&receipt, perf_json_find(&receipt, binary, "unchanged_after_execution"), "true") && perf_json_is(&receipt, perf_json_find(&receipt, 0, "collector_complete"), "true") && perf_json_is(&receipt, perf_json_find(&receipt, 0, "profiled"), mode ? "true" : "false") && perf_json_is(&receipt, perf_json_find(&receipt, 0, "exit_code"), "0") && perf_json_is(&receipt, perf_json_find(&receipt, 0, "affinity_cpu"), "2") && perf_json_is(&receipt, perf_json_find(&receipt, 0, "host"), "benchpress") && perf_json_is(&receipt, perf_json_find(&receipt, 0, "period_ns"), "1000000");
            uint64_t elapsed = 0;
            result = result && perf_uint64(perf_json_text(&receipt, perf_json_find(&receipt, 0, "wall_ns")), &elapsed) && elapsed != 0 && elapsed <= UINT64_C(60000000000);
            uint64_t start = 0;
            uint64_t end = 0;
            result = result && perf_uint64(perf_json_text(&receipt, perf_json_find(&receipt, 0, "start_ns")), &start) && start != 0 && perf_uint64(perf_json_text(&receipt, perf_json_find(&receipt, 0, "end_ns")), &end) && end >= start && end - start == elapsed && perf_json_is(&receipt, perf_json_find(&receipt, 0, "timeout"), "false") && perf_json_is(&receipt, perf_json_find(&receipt, 0, "signal"), "0");
            wall[pair - 1][mode] = (int64_t)elapsed;
            bool first = true;
            result = result && perf_buffer_byte(&rows, '{') && history_string(&rows, "execution_id", perf_literal(execution), &first) && history_count(&rows, "pair", pair, false, &first) && history_count(&rows, "order", pair % 2 == 0 ? mode : 1 - mode, false, &first);
            result = result && history_key(&rows, "profiled", &first) && perf_buffer_append(&rows, perf_literal(mode ? "true" : "false")) && history_key(&rows, "warmup", &first) && perf_buffer_append(&rows, perf_literal(pair == 1 ? "true" : "false"));
            const char *numbers[] = {"start_ns", "end_ns", "wall_ns", "user_ns", "system_ns", "peak_rss_kib"};
            for (size_t field = 0; field < 6 && result; ++field)
            {
                uint64_t number = 0;
                result = perf_uint64(perf_json_text(&receipt, perf_json_find(&receipt, 0, numbers[field])), &number) && history_count(&rows, numbers[field], number, true, &first);
            }
            result = result && history_count(&rows, "affinity_cpu", 2, false, &first) && history_count(&rows, "sample_count", 1, false, &first) && history_key(&rows, "correct", &first) && perf_buffer_append(&rows, perf_literal("true")) && history_string(&rows, "coverage", perf_literal("complete"), &first) && history_string(&rows, "case", perf_literal("benchmark-lexer src; launched leader lifetime"), &first) && history_string(&rows, "machine", perf_literal("benchpress-9700X"), &first) && history_string(&rows, "binary_sha256", perf_literal(profile_binary), &first) && history_string(&rows, "source_receipt", perf_literal(receipt_id), &first) && perf_buffer_append(&rows, perf_literal("}\n"));
            result = result && (contexts.size == 0 || perf_buffer_byte(&contexts, ',')) && perf_buffer_append(&contexts, perf_literal("{\"id\":")) && perf_json_quote(&contexts, perf_literal(execution)) && perf_buffer_append(&contexts, perf_literal(",\"kind\":\"execution\",\"facts\":{\"profiled\":")) && perf_buffer_append(&contexts, perf_literal(mode ? "true" : "false")) && perf_buffer_append(&contexts, perf_literal(",\"command\":[\"./build/compiler\",\"benchmark-lexer\",\"src\"],\"correctness_scope\":\"The command's scalar/vector token cross-checks completed with exit 0; no broader compiler correctness claim.\"},\"evidence\":[")) && perf_json_quote(&contexts, perf_literal(receipt_id)) && perf_buffer_append(&contexts, perf_literal("]}"));
            perf_json_free(&receipt);
            free(bytes.data);
        }
    }
    result = result && history_write(argv[2], "executions.jsonl", perf_buffer_bytes(&rows)) && report_schema(argv[2]);
    PerfBuffer trace = {0};
    result = result && history_read(argv[1], "profiled-01/capture.pftrace", &trace) && history_write(argv[2], "capture.pftrace", perf_buffer_bytes(&trace));
    result = result && perf_buffer_byte(&resources, ',') && history_resource(&resources, argv[2], "executions-jsonl", "executions.jsonl", "jsonl", 14, true) && perf_buffer_byte(&resources, ',') && history_resource(&resources, argv[2], "executions-schema", "executions.schema.arrow", "arrow-ipc-stream", 0, true) && perf_buffer_byte(&resources, ',') && history_resource(&resources, argv[2], "capture", "capture.pftrace", "perfetto-protobuf", 0, false);
    int64_t effects[6] = {0};
    for (size_t i = 0; i < 6; ++i)
    {
        effects[i] = wall[i + 1][1] - wall[i + 1][0];
    }
    int64_t ordered[6];
    memcpy(ordered, effects, sizeof(ordered));
    qsort(ordered, 6, sizeof(*ordered), report_signed_order);
    int64_t estimates[10000];
    uint32_t random = 384;
    for (size_t i = 0; i < 10000; ++i)
    {
        int64_t resample[6];
        for (size_t j = 0; j < 6; ++j)
        {
            random = random * 1664525u + 1013904223u;
            resample[j] = effects[random % 6];
        }
        qsort(resample, 6, sizeof(*resample), report_signed_order);
        estimates[i] = resample[2] + resample[3];
    }
    qsort(estimates, 10000, sizeof(*estimates), report_signed_order);
    char report[2048];
    size = snprintf(report, sizeof(report), "{\"first_party\":true,\"independent_pairs\":6,\"excluded_warmup_pair\":1,\"estimator\":\"median of profiled minus unprofiled leader-wall differences\",\"median_delta_ns\":{\"numerator\":\"%lld\",\"denominator\":\"2\"},\"percentile_95_interval_ns\":[{\"numerator\":\"%lld\",\"denominator\":\"2\"},{\"numerator\":\"%lld\",\"denominator\":\"2\"}],\"bootstrap\":\"10000 resamples of six matched fresh-process pairs; seed 384\",\"order\":\"Pair 1 profiled then unprofiled is excluded as warmup; pairs 2-7 alternate unprofiled-first / profiled-first\",\"conclusion\":\"The observed paired interval includes zero. A positive collection cost is not resolved within this campaign's variability; negative apparent deltas are not an optimization claim.\",\"limitations\":[\"One source/binary/workload/CPU and 1 ms period; not a general overhead bound.\",\"Shared-host lock was released between every run. Inter-run thermal/turbo/cache history is not controlled.\",\"Wall brackets include launch/loader/exit observation. Resource CPU time has microsecond source resolution.\"]}\n", (long long)(ordered[2] + ordered[3]), (long long)estimates[250], (long long)estimates[9749]);
    result = result && estimates[250] <= 0 && estimates[9749] >= 0 && size > 0 && (size_t)size < sizeof(report) && history_write(argv[2], "collection-overhead.json", (PerfBytes){.data = (const unsigned char *)report, .size = size > 0 ? (size_t)size : 0});
    result = result && perf_buffer_byte(&resources, ',') && history_resource(&resources, argv[2], "overhead-report", "collection-overhead.json", "json", 0, false);
    PerfBuffer manifest = {0};
    result = result && perf_buffer_append(&manifest, perf_literal("{\"format\":\"buster-benchmark\",\"version\":1,\"id\":\"first-party-linux-profile-9700x-v1\",\"kind\":\"measured\",\"status\":\"complete\",\"recorded_at\":")) && perf_json_quote(&manifest, perf_literal(argv[3])) && perf_buffer_append(&manifest, perf_literal(",\"producer\":{\"name\":\"buster-execution-receipt-adapter\",\"version\":\"1\",\"revision\":")) && perf_json_quote(&manifest, perf_literal(argv[5])) && perf_buffer_append(&manifest, perf_literal("},\"requires\":[\"arrow-ipc\",\"jsonl.arrow-mapping.v1\",\"perfetto.protobuf\"],\"contexts\":[")) && perf_buffer_append(&manifest, perf_buffer_bytes(&contexts));
    result = result && perf_buffer_append(&manifest, perf_literal(",{\"id\":\"host\",\"kind\":\"environment\",\"facts\":{\"host\":\"benchpress\",\"cpu\":\"AMD Ryzen 7 9700X\",\"affinity_cpu\":2,\"lock\":\"exclusive.sh per run\"},\"unknowns\":{\"thermal_history\":\"not controlled between separately locked runs\"}},{\"id\":\"protocol\",\"kind\":\"protocol\",\"facts\":{\"independent_unit\":\"fresh process execution\",\"pairing\":\"adjacent alternating profiled/unprofiled runs; warmup pair excluded\",\"purpose\":\"separate collector overhead; not compiler optimization acceptance\"}},{\"id\":\"build\",\"kind\":\"build\",\"facts\":{\"source_commit\":")) && perf_json_quote(&manifest, perf_literal(profile_source)) && perf_buffer_append(&manifest, perf_literal(",\"binary_sha256\":")) && perf_json_quote(&manifest, perf_literal(profile_binary)) && perf_buffer_append(&manifest, perf_literal(",\"compiler\":\"Clang 23.1.1\",\"flags\":\"BUSTER_DEBUG_INFO=0; original build.sh plus -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer\"}}],\"metrics\":["));
    const char *metric_ids[] = {"leader.wall", "leader.user", "leader.system", "leader.peak-rss"};
    const char *metric_names[] = {"Observed leader wall time", "Leader resource user CPU time", "Leader resource system CPU time", "Whole-execution peak resident size"};
    const char *columns[] = {"wall_ns", "user_ns", "system_ns", "peak_rss_kib"};
    for (size_t i = 0; i < 4 && result; ++i)
    {
        result = (i == 0 || perf_buffer_byte(&manifest, ',')) && perf_buffer_append(&manifest, perf_literal("{\"id\":")) && perf_json_quote(&manifest, perf_literal(metric_ids[i])) && perf_buffer_append(&manifest, perf_literal(",\"name\":")) && perf_json_quote(&manifest, perf_literal(metric_names[i])) && perf_buffer_append(&manifest, perf_literal(",\"definition\":")) && perf_json_quote(&manifest, perf_literal(metric_names[i])) && perf_buffer_append(&manifest, perf_literal(i == 3 ? ",\"definition_version\":\"1\",\"quantity\":\"memory.peak-resident\",\"unit\":{\"symbol\":\"KiB\",\"dimensions\":{\"byte\":1},\"scale\":{\"numerator\":\"1024\",\"denominator\":\"1\"}},\"direction\":\"lower\",\"aggregation\":\"nonadditive\"}" : ",\"definition_version\":\"1\",\"quantity\":\"duration\",\"unit\":{\"symbol\":\"ns\",\"dimensions\":{\"second\":1},\"scale\":{\"numerator\":\"1\",\"denominator\":\"1000000000\"}},\"direction\":\"lower\",\"aggregation\":\"nonadditive\"}"));
    }
    result = result && perf_buffer_append(&manifest, perf_literal("],\"scopes\":[{\"id\":\"leader\",\"subject\":\"benchmark-lexer src\",\"level\":\"process\",\"description\":\"Observed leader execution, including launch/loader/exit observation; counters/RSS span the whole command.\",\"includes\":[\"exec/loader\",\"complete benchmark command\",\"exit observation\"],\"excludes\":[\"collector setup and binary hashing before launch\",\"unknown descendants after leader exit\"]}],\"instruments\":[{\"id\":\"receipt\",\"kind\":\"os\",\"facts\":{\"wall\":\"CLOCK_MONOTONIC bracket through pidfd-observed leader exit\",\"resources\":\"wait4 rusage; CPU source precision microseconds, peak RSS KiB\"}}],\"resources\":[")) && perf_buffer_append(&manifest, perf_buffer_bytes(&resources)) && perf_buffer_append(&manifest, perf_literal("],\"tables\":[{\"id\":\"executions\",\"data\":[\"executions-jsonl\"],\"schema\":\"executions-schema\",\"primary_key\":[\"execution_id\"],\"dimensions\":[\"profiled\",\"warmup\"],\"bindings\":{\"execution_key\":\"execution_id\",\"build_context\":\"build\",\"environment_context\":\"host\",\"protocol_context\":\"protocol\",\"source_artifact\":\"executions-jsonl\"},\"measurements\":{"));
    for (size_t i = 0; i < 4 && result; ++i)
    {
        result = (i == 0 || perf_buffer_byte(&manifest, ',')) && perf_json_quote(&manifest, perf_literal(columns[i])) && perf_buffer_append(&manifest, perf_literal(":{\"metric_id\":")) && perf_json_quote(&manifest, perf_literal(metric_ids[i])) && perf_buffer_append(&manifest, perf_literal(",\"scope_id\":\"leader\",\"instrument_id\":\"receipt\",\"statistic\":\"observation\",\"sample_level\":\"process\",\"raw_retained\":true,\"sample_count\":{\"column\":\"sample_count\"}}"));
    }
    result = result && perf_buffer_append(&manifest, perf_literal("}}],\"traces\":[{\"id\":\"lexer-profile-01\",\"resource\":\"capture\",\"execution_id\":\"exec_profiled_01\",\"profiler\":{\"name\":\"buster first-party Linux perf_event collector\",\"schema_version\":\"Perfetto v58.2 StackSample\"},\"source_artifacts\":[\"receipt_profiled_01\",\"source_profiled_01_1\",\"source_profiled_01_2\",\"source_profiled_01_3\",\"source_profiled_01_4\"],\"capabilities\":[\"timestamped-stacks\",\"source-period-weights\",\"pid-tid-cpu\",\"matching-elf-symbols\",\"paired-running-intervals\"],\"limitations\":[\"Selected CPU and observed leader lifetime; inherited tasks outside this scope have unknown coverage.\",\"Unknown initial/final scheduling edges, unresolved libraries and unproven unwind completeness remain explicit.\",\"No kernel stacks, DWARF/source/assembly content, direct Superluminal input or general task-reuse reconstruction is claimed.\"]}],\"limitations\":[\"Pair 1 is retained capture/warmup evidence and excluded from the six-pair overhead inference.\",\"Negative apparent profiled-minus-unprofiled deltas do not establish an optimization; the paired interval includes zero.\",\"This campaign deliberately varies profiling state to measure collection overhead separately. It cannot supply a normal compiler-regression label across those states.\"],\"provenance\":{\"reader_revision\":")) && perf_json_quote(&manifest, perf_literal(argv[4])) && perf_buffer_append(&manifest, perf_literal(",\"capture_revision\":")) && perf_json_quote(&manifest, perf_literal(profile_source)) && perf_buffer_append(&manifest, perf_literal("}}\n")) && history_write(argv[2], "manifest.bmf.json", perf_buffer_bytes(&manifest));
    if (result)
    {
        puts("{\"first_party\":true,\"executions\":14,\"overhead_pairs\":6,\"warmup_pair_excluded\":1,\"real_native_samples\":871}");
    }
    else
    {
        fputs("report: incomplete/mismatched execution identity or receipt; generation is not qualified\nusage: report CAPTURE_ROOT NEW_DIR RECORDED_AT READER_REV ADAPTER_REV\n", stderr);
    }
    free(rows.data);
    free(resources.data);
    free(contexts.data);
    free(manifest.data);
    free(trace.data);
    return result ? 0 : 1;
}
