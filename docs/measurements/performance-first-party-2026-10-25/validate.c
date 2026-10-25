/* Independent fixture and rejection harness for Buster's original readers.
 * Build with -I /path/to/buster/tools/performance. No extra libraries.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#define main buster_performance_cli
#include "main.c"
#undef main

static bool write_bytes(const char *path, PerfBytes bytes)
{
    FILE *file = fopen(path, "wb");
    bool result = file != NULL;
    if (result)
    {
        result = fwrite(bytes.data, 1, bytes.size, file) == bytes.size;
        result = fclose(file) == 0 && result;
    }
    return result;
}

static bool replace_once(PerfBytes input, const char *before, const char *after, PerfBuffer *output)
{
    size_t size = strlen(before);
    size_t position = 0;
    while (position + size <= input.size && memcmp(input.data + position, before, size) != 0)
    {
        ++position;
    }
    bool result = position + size <= input.size && perf_buffer_append(output, (PerfBytes){.data = input.data, .size = position}) && perf_buffer_append(output, perf_literal(after)) && perf_buffer_append(output, (PerfBytes){.data = input.data + position + size, .size = input.size - position - size});
    return result;
}

static bool load_fixture(const char *root, const char *name, PerfBuffer *bytes)
{
    char path[4096];
    int size = snprintf(path, sizeof(path), "%s/%s", root, name);
    bool result = size > 0 && (size_t)size < sizeof(path) && perf_read_file(path, bytes);
    return result;
}

int main(int argc, char **argv)
{
    bool valid = argc == 4;
    if (!valid)
    {
        fputs("usage: validate REFERENCE_ROOT FROZEN_EVIDENCE_ROOT CANONICAL_SCHEMA\n", stderr);
    }
    if (valid)
    {
        valid = perf_self_test();
    }
    const char *directories[] = {"foreign-strings-example", "foreign-strings-example", "profile-example"};
    const char *names[] = {"link-results", "executions", "arbitrary-custom"};
    uint64_t compared = 0;
    uint64_t accepted_mutations = 0;
    uint64_t mutation_probes = 0;
    for (size_t f = 0; f < 3 && valid; ++f)
    {
        char path[256];
        PerfBuffer source = {0};
        PerfBuffer readable = {0};
        PerfBuffer sidecar = {0};
        snprintf(path, sizeof(path), "%s/%s.arrow", directories[f], names[f]);
        valid = load_fixture(argv[1], path, &source);
        snprintf(path, sizeof(path), "%s/%s.jsonl", directories[f], names[f]);
        valid = valid && load_fixture(argv[1], path, &readable);
        snprintf(path, sizeof(path), "%s/%s.schema.arrow", directories[f], names[f]);
        valid = valid && load_fixture(argv[1], path, &sidecar);
        PerfArrowInfo a = {0};
        PerfArrowInfo b = {0};
        PerfBuffer rows_a = {0};
        PerfBuffer rows_b = {0};
        uint64_t count = 0;
        bool equal = valid && perf_arrow_read(perf_buffer_bytes(&source), &a, &rows_a) && perf_arrow_inspect(perf_buffer_bytes(&sidecar), &b) && b.rows == 0 && perf_arrow_schemas_equal(&a.schema, &b.schema) && perf_jsonl_read(perf_buffer_bytes(&readable), &b.schema, &rows_b, &count) && count == a.rows && perf_bytes_equal(perf_buffer_bytes(&rows_a), perf_buffer_bytes(&rows_b));
        perf_expect(equal, "independent Arrow fixture and JSONL exact typed equivalence");
        PerfBuffer produced = {0};
        PerfArrowInfo reread = {0};
        bool written = equal && perf_arrow_schema_write(&a.schema, &produced) && perf_arrow_inspect(perf_buffer_bytes(&produced), &reread) && reread.rows == 0 && perf_arrow_schemas_equal(&a.schema, &reread.schema);
        perf_expect(written, "first-party zero-row Arrow schema writer preserves the independently produced schema");
        free(reread.schema.fields);
        free(produced.data);
        compared += equal ? count * a.schema.roots : 0;
        PerfBuffer changed = {0};
        bool replaced = replace_once(perf_buffer_bytes(&readable), f == 2 ? "18446744073709551615" : "\"sequence\":1", f == 2 ? "18446744073709551614" : "\"sequence\":2", &changed);
        if (replaced)
        {
            PerfBuffer different = {0};
            uint64_t changed_count = 0;
            bool read = perf_jsonl_read(perf_buffer_bytes(&changed), &a.schema, &different, &changed_count);
            perf_expect(!read || !perf_bytes_equal(perf_buffer_bytes(&different), perf_buffer_bytes(&rows_a)), "exact changed cell cannot pass equivalence");
            free(different.data);
        }
        for (size_t n = 0; n < source.size && valid; n += source.size / 251 + 1)
        {
            PerfArrowInfo truncated = {0};
            bool accepted = perf_arrow_inspect((PerfBytes){.data = source.data, .size = n}, &truncated);
            accepted_mutations += accepted;
            ++mutation_probes;
            free(truncated.schema.fields);
        }
        for (size_t n = 0; n < source.size && valid; n += source.size / 503 + 1)
        {
            source.data[n] ^= 255;
            PerfArrowInfo changed_arrow = {0};
            bool accepted = perf_arrow_inspect(perf_buffer_bytes(&source), &changed_arrow);
            accepted_mutations += accepted;
            ++mutation_probes;
            free(changed_arrow.schema.fields);
            source.data[n] ^= 255;
        }
        unsigned char saved = source.data[4];
        source.data[4] = 255;
        PerfArrowInfo bad_length = {0};
        perf_expect(!perf_arrow_inspect(perf_buffer_bytes(&source), &bad_length), "corrupt IPC framing length rejected");
        free(bad_length.schema.fields);
        source.data[4] = saved;
        free(readable.data);
        free(sidecar.data);
        free(rows_a.data);
        free(rows_b.data);
        free(changed.data);
        if (f == 2)
        {
            PerfBuffer duplicate = {0};
            PerfArrowInfo rejected = {0};
            bool changed_name = replace_once(perf_buffer_bytes(&source), "digest", "reason", &duplicate);
            perf_expect(changed_name && !perf_arrow_inspect(perf_buffer_bytes(&duplicate), &rejected), "duplicate exact Arrow sibling field rejected");
            free(duplicate.data);
            free(rejected.schema.fields);
            PerfBuffer unicode = {0};
            PerfArrowInfo renamed = {0};
            bool changed_unicode = replace_once(perf_buffer_bytes(&source), "digest", "延迟", &unicode);
            perf_expect(changed_unicode && perf_arrow_inspect(perf_buffer_bytes(&unicode), &renamed) && perf_column(&renamed.schema, perf_literal("延迟")) != UINT32_MAX, "native Arrow binding retains exact Unicode bytes");
            free(unicode.data);
            free(renamed.schema.fields);
        }
        free(source.data);
        free(a.schema.fields);
        free(b.schema.fields);
    }
    perf_expect(compared == 7320, "all 7,320 original typed cells retained");
    PerfArrowField float_field = {.name = {.data = (const unsigned char *)"value", .size = 5}, .type = 3, .bit_width = 64, .precision = 2, .next = 1};
    PerfArrowSchema float_schema = {.fields = &float_field, .count = 1, .roots = 1};
    uint64_t infinity_bits = UINT64_C(0x7ff0000000000000);
    PerfArrowArray float_array = {.length = 1, .data = {.data = (const unsigned char *)&infinity_bits, .size = 8}};
    PerfArrowBatch float_batch = {.arrays = &float_array, .rows = 1, .json_mapping = true};
    PerfBuffer native_only = {0};
    perf_expect(perf_arrow_batch_json(&float_schema, &float_batch, &native_only) && !float_batch.json_mapping, "nonfinite Arrow remains native-only; internal placeholders cannot claim JSON equivalence");
    free(native_only.data);
    bool negative = false;
    uint64_t magnitude = 0;
    perf_expect(perf_integer(perf_literal("-9223372036854775808"), 64, true, &negative, &magnitude) && negative && magnitude == (UINT64_C(1) << 63), "int64 minimum stays exact");
    perf_expect(!perf_integer(perf_literal("9223372036854775808"), 64, true, &negative, &magnitude) && !perf_integer(perf_literal("-1"), 64, false, &negative, &magnitude), "signed/unsigned integer boundaries cannot cross");
    const char *integer_bad[] = {".1", "1.", "01", "-", "--1", "+1", "1e", "1e+", "1e-"};
    for (size_t i = 0; i < sizeof(integer_bad) / sizeof(integer_bad[0]); ++i)
    {
        PerfNumber number = {0};
        perf_expect(!perf_number(perf_literal(integer_bad[i]), &number), "malformed exact numeric string rejected");
    }
    PerfArrowField decimal = {.type = 7, .bit_width = 128, .precision = 38, .scale = 6};
    const char *decimal_bad[] = {"1e0", ".1", "01.25", "1.2500001", "100000000000000000000000000000000"};
    for (size_t i = 0; i < sizeof(decimal_bad) / sizeof(decimal_bad[0]); ++i)
    {
        PerfBuffer output = {0};
        perf_expect(!perf_decimal_json(&output, &decimal, perf_literal(decimal_bad[i])), "decimal syntax, scale and precision cannot round");
        free(output.data);
    }
    const char *base64_bad[] = {"A", "AA=", "A===", "AB==", "AAB=", "AA==AAAA", "AA-="};
    for (size_t i = 0; i < sizeof(base64_bad) / sizeof(base64_bad[0]); ++i)
    {
        PerfBuffer output = {0};
        perf_expect(!perf_base64_decode(perf_literal(base64_bad[i]), &output), "noncanonical base64 rejected");
        free(output.data);
    }
    const unsigned char bad_proto[][11] = {{0}, {10, 255}, {10, 2, 8}, {10, 1, 0}, {10, 9, 8, 128, 128, 128, 128, 128, 128, 128, 128}};
    const size_t proto_sizes[] = {1, 2, 3, 3, 11};
    for (size_t i = 0; i < 5; ++i)
    {
        uint64_t count = 0;
        perf_expect(!perf_trace_envelope((PerfBytes){.data = bad_proto[i], .size = proto_sizes[i]}, &count), "malformed native protobuf rejected");
    }
    PerfBuffer original_manifest = {0};
    valid = valid && load_fixture(argv[1], "profile-example/manifest.bmf.json", &original_manifest);
    PerfBuffer schema_bytes = {0};
    PerfJson canonical_schema = {0};
    valid = valid && perf_read_file(argv[3], &schema_bytes) && perf_json_parse(&canonical_schema, perf_buffer_bytes(&schema_bytes));
    const char *before[] = {"\"version\": 1", "\"arrow-ipc\"", "\"execution_id\": \"example-execution\"", "\"resource\": \"capture\"", "\"id\": \"arbitrary-custom-schema\"", "\"recorded_at\": \"2026-10-24T12:53:55.516Z\""};
    const char *after[] = {"\"version\": 2", "\"unknown.required.codec\"", "\"execution_id\": \"missing\"", "\"resource\": \"arbitrary-custom-arrow\"", "\"id\": \"arbitrary-custom-arrow\"", "\"recorded_at\": \"2026-02-29T12:00:00Z\""};
    for (size_t i = 0; i < 6 && valid; ++i)
    {
        PerfBuffer mutated = {0};
        PerfJson manifest = {0};
        bool replaced = replace_once(perf_buffer_bytes(&original_manifest), before[i], after[i], &mutated);
        bool accepted = replaced && perf_json_parse(&manifest, perf_buffer_bytes(&mutated)) && perf_schema_validate(&canonical_schema, &manifest) && perf_metadata(&manifest);
        perf_expect(replaced && !accepted, "unsupported version/capability, bad references, duplicate IDs and calendar dates rejected");
        free(mutated.data);
        perf_json_free(&manifest);
    }
    char scratch[] = "/tmp/buster-first-party-XXXXXX";
    char *directory = valid ? mkdtemp(scratch) : NULL;
    valid = valid && directory != NULL;
    const char *files[] = {"arbitrary-custom.arrow", "arbitrary-custom.jsonl", "arbitrary-custom.schema.arrow", "capture.pftrace"};
    for (size_t i = 0; i < 4 && valid; ++i)
    {
        PerfBuffer bytes = {0};
        char input[256];
        char output[4096];
        snprintf(input, sizeof(input), "profile-example/%s", files[i]);
        snprintf(output, sizeof(output), "%s/%s", directory, files[i]);
        valid = load_fixture(argv[1], input, &bytes) && write_bytes(output, perf_buffer_bytes(&bytes));
        free(bytes.data);
    }
    const char *resource_before[] = {"\"bytes\": \"1104\"", "\"rows\": \"2\"", "d62aa015d1497e505e436e9b54ca1b3ad925edcea5d69a4b0639c1bb77a374e2", "\"path\": \"arbitrary-custom.arrow\"", "\"metric_id\": \"custom-latency\"", "\"status_column\": \"status\""};
    const char *resource_after[] = {"\"bytes\": \"1103\"", "\"rows\": \"3\"", "062aa015d1497e505e436e9b54ca1b3ad925edcea5d69a4b0639c1bb77a374e2", "\"path\": \"../arbitrary-custom.arrow\"", "\"metric_id\": \"missing\"", "\"status_column\": \"unavailable\""};
    char manifest_path[4096];
    snprintf(manifest_path, sizeof(manifest_path), "%s/manifest.bmf.json", directory == NULL ? "/tmp/no-dataset" : directory);
    for (size_t i = 0; i < 6 && valid; ++i)
    {
        PerfBuffer mutated = {0};
        bool replaced = replace_once(perf_buffer_bytes(&original_manifest), resource_before[i], resource_after[i], &mutated);
        PerfDataset dataset = {0};
        bool accepted = replaced && write_bytes(manifest_path, perf_buffer_bytes(&mutated)) && perf_dataset_load(&dataset, manifest_path, argv[3]);
        perf_expect(replaced && !accepted, "wrong size/hash/rows/path/metric/column cannot validate a generation");
        perf_dataset_free(&dataset);
        free(mutated.data);
    }
    if (directory != NULL)
    {
        unlink(manifest_path);
        for (size_t i = 0; i < 4; ++i)
        {
            char path[4096];
            snprintf(path, sizeof(path), "%s/%s", directory, files[i]);
            unlink(path);
        }
        rmdir(directory);
    }
    for (size_t i = 0; i < 2 && valid; ++i)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/%s/manifest.bmf.json", argv[1], i == 0 ? "foreign-strings-example" : "profile-example");
        PerfDataset dataset = {.evidence_root = argv[2]};
        bool accepted = perf_dataset_load(&dataset, path, argv[3]);
        perf_expect(accepted && dataset.rows == (i == 0 ? 300 : 2) && dataset.cells_compared == (i == 0 ? 7308 : 12), "complete reference generation validated independently");
        perf_dataset_free(&dataset);
    }
    perf_json_free(&canonical_schema);
    free(schema_bytes.data);
    free(original_manifest.data);
    valid = valid && perf_failures == 0;
    printf("{\"first_party\":true,\"passed\":%s,\"checks\":%u,\"failures\":%u,\"typed_cells_compared\":\"%llu\",\"mutation_probes\":\"%llu\",\"accepted_mutations\":\"%llu\",\"mutation_note\":\"Some byte mutations change valid values or ignorable padding; these are memory-safety probes, not blanket rejection claims.\"}\n", valid ? "true" : "false", perf_checks, perf_failures, (unsigned long long)compared, (unsigned long long)mutation_probes, (unsigned long long)accepted_mutations);
    return valid ? 0 : 1;
}
