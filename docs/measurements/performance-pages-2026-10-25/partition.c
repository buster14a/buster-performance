/* Original lossless physical partitioner for the reviewed frozen source census.
 * Schema stays Arrow; JSONL parts preserve exact source row bytes and order.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
#define BUSTER_HISTORY_NO_MAIN
#include "../performance-first-party-2026-10-25/import.c"

typedef struct CensusPart CensusPart;
struct CensusPart
{
    char path[160];
    size_t family;
    uint64_t rows;
};

static bool census_manifest(const char *root, const char *file, size_t family, const CensusPart *parts, size_t count, const char *recorded, const char *reader, const char *adapter)
{
    bool whole = family == SIZE_MAX;
    char id[160];
    snprintf(id, sizeof(id), "frozen-source-%s", whole ? "all-partitioned-v1" : history_families[family].name);
    PerfBuffer output = {0};
    bool first = true;
    bool result = perf_buffer_byte(&output, '{') && history_string(&output, "format", perf_literal("buster-benchmark"), &first) && history_count(&output, "version", 1, false, &first) && history_string(&output, "id", perf_literal(id), &first) && history_string(&output, "kind", perf_literal("imported"), &first) && history_string(&output, "status", perf_literal("complete"), &first) && history_string(&output, "recorded_at", perf_literal(recorded), &first);
    result = result && history_key(&output, "producer", &first) && perf_buffer_append(&output, perf_literal("{\"name\":\"buster-census-partitioner\",\"version\":\"1\",\"revision\":")) && perf_json_quote(&output, perf_literal(adapter)) && perf_buffer_byte(&output, '}');
    result = result && history_key(&output, "resources", &first) && perf_buffer_byte(&output, '[') && history_resource(&output, root, "schema", "source-cells.schema.arrow", "arrow-ipc-stream", 0, true) && perf_buffer_byte(&output, ',') && history_resource(&output, root, "families", "family-census.json", "json", 0, false);
    for (size_t i = 0; i < count && result; ++i)
    {
        if (!whole && parts[i].family != family)
        {
            continue;
        }
        char part_id[32];
        snprintf(part_id, sizeof(part_id), "part-%03zu", i);
        result = perf_buffer_byte(&output, ',') && history_resource(&output, root, part_id, parts[i].path, "jsonl", parts[i].rows, true);
    }
    char paths[160];
    snprintf(paths, sizeof(paths), whole ? "source-paths.jsonl" : "families/%s/paths.jsonl", whole ? "" : history_families[family].name);
    result = result && perf_buffer_byte(&output, ',') && history_resource(&output, root, "paths", paths, "jsonl", whole ? 1043 : history_families[family].expected_files, true);
    result = result && perf_buffer_append(&output, perf_literal("],\"tables\":[{\"id\":\"source-cells\",\"data\":["));
    bool first_part = true;
    for (size_t i = 0; i < count && result; ++i)
    {
        if (whole || parts[i].family == family)
        {
            char part_id[32];
            snprintf(part_id, sizeof(part_id), "part-%03zu", i);
            result = (first_part || perf_buffer_byte(&output, ',')) && perf_json_quote(&output, perf_literal(part_id));
            first_part = false;
        }
    }
    result = result && perf_buffer_append(&output, perf_literal("],\"schema\":\"schema\",\"primary_key\":[\"path\",\"source_row\"],\"dimensions\":[\"family\",\"path\",\"disposition\"],\"metadata\":{\"row_meaning\":\"Opaque retained source rows, including headers and comments. No invented numeric performance semantics.\"}}],\"limitations\":[\"Complete declared source inventory does not mean complete semantic measurement import.\",\"Protocol-only, failed, partial and unsupported dispositions remain explicit in family-census.json. No timing observations are invented.\"],\"provenance\":{\"repository\":\"buster14a/buster-performance\",\"commit\":")) && perf_json_quote(&output, perf_literal(history_pin)) && perf_buffer_append(&output, perf_literal(",\"reader_revision\":")) && perf_json_quote(&output, perf_literal(reader)) && perf_buffer_append(&output, perf_literal(",\"partition_rule\":\"Original source order; family boundaries; at most 128 KiB per JSONL part except one oversized original row; no duplicated observations.\"}}\n")) && history_write(root, file, perf_buffer_bytes(&output));
    free(output.data);
    return result;
}

static bool census_checked_read(const char *root, const char *file, const char *digest, PerfBuffer *output)
{
    char actual[65];
    bool result = history_read(root, file, output) && perf_sha256(perf_buffer_bytes(output), actual) && strcmp(actual, digest) == 0;
    return result;
}

int main(int argc, char **argv)
{
    bool result = argc == 6 && perf_timestamp(perf_literal(argv[3])) && history_revision(argv[4]) && history_revision(argv[5]);
    PerfBuffer source = {0};
    PerfBuffer paths = {0};
    PerfBuffer families = {0};
    PerfBuffer schema = {0};
    result = result && census_checked_read(argv[1], "source-cells.jsonl", "e4990dbcbdd5ffd610e64290275025be07911cf3a6ece3a70126eb1ee46fc2e0", &source) && census_checked_read(argv[1], "source-paths.jsonl", "53ce91d240149609773eb805373ae24aff6db6938b07fc6496dc939763cf53ad", &paths) && census_checked_read(argv[1], "family-census.json", "70ab4620973ef3351fb2b883d8ce1847deaf9f88a185b4374c0dab9be55da721", &families) && census_checked_read(argv[1], "source-cells.schema.arrow", "57175a9a39595040c0e9b46865c7ef254f4522a820c2e72d751eb475dcf6de4b", &schema);
    char directory[4096];
    result = result && mkdir(argv[2], 0755) == 0;
    int size = result ? snprintf(directory, sizeof(directory), "%s/families", argv[2]) : 0;
    result = result && size > 0 && (size_t)size < sizeof(directory) && mkdir(directory, 0755) == 0;
    for (size_t f = 0; f < 19 && result; ++f)
    {
        size = snprintf(directory, sizeof(directory), "%s/families/%s", argv[2], history_families[f].name);
        result = size > 0 && (size_t)size < sizeof(directory) && mkdir(directory, 0755) == 0;
    }
    result = result && history_write(argv[2], "source-cells.schema.arrow", perf_buffer_bytes(&schema)) && history_write(argv[2], "family-census.json", perf_buffer_bytes(&families)) && history_write(argv[2], "source-paths.jsonl", perf_buffer_bytes(&paths));
    CensusPart parts[256] = {0};
    size_t count = 0;
    size_t cursor = 0;
    uint64_t rows = 0;
    uint64_t cells = 0;
    for (size_t family = 0; family < 19 && result; ++family)
    {
        PerfBuffer family_paths = {0};
        uint64_t file_count = 0;
        for (size_t at = 0; at < paths.size && result;)
        {
            size_t end = at;
            while (end < paths.size && paths.data[end] != '\n')
            {
                ++end;
            }
            PerfJson row = {0};
            result = end < paths.size && perf_json_parse(&row, (PerfBytes){.data = paths.data + at, .size = end - at});
            if (result && perf_json_is(&row, perf_json_find(&row, 0, "family"), history_families[family].name))
            {
                result = perf_buffer_append(&family_paths, (PerfBytes){.data = paths.data + at, .size = end - at + 1});
                ++file_count;
            }
            perf_json_free(&row);
            at = end + 1;
        }
        char file[160];
        snprintf(file, sizeof(file), "families/%s/paths.jsonl", history_families[family].name);
        result = result && file_count == history_families[family].expected_files && history_write(argv[2], file, perf_buffer_bytes(&family_paths));
        free(family_paths.data);
    }
    while (cursor < source.size && result)
    {
        size_t begin = cursor;
        size_t family = SIZE_MAX;
        uint64_t part_rows = 0;
        while (cursor < source.size && result)
        {
            size_t end = cursor;
            while (end < source.size && source.data[end] != '\n')
            {
                ++end;
            }
            PerfJson row = {0};
            result = end < source.size && perf_json_parse(&row, (PerfBytes){.data = source.data + cursor, .size = end - cursor});
            size_t f = SIZE_MAX;
            for (size_t i = 0; i < 19 && result; ++i)
            {
                if (perf_json_is(&row, perf_json_find(&row, 0, "family"), history_families[i].name))
                {
                    f = i;
                }
            }
            result = result && f != SIZE_MAX;
            bool boundary = part_rows != 0 && (family != f || end + 1 - begin > 131072);
            if (result && !boundary)
            {
                family = f;
                uint32_t array = perf_json_find(&row, 0, "cells");
                result = array < row.node_count && row.nodes[array].kind == PERF_JSON_ARRAY;
                for (uint32_t c = perf_json_first(&row, array); c != UINT32_MAX && result; c = perf_json_after(&row, array, c))
                {
                    ++cells;
                }
                cursor = end + 1;
                ++part_rows;
                ++rows;
            }
            perf_json_free(&row);
            if (boundary)
            {
                break;
            }
        }
        result = result && count < 256;
        if (result)
        {
            CensusPart *part = &parts[count];
            part->family = family;
            part->rows = part_rows;
            snprintf(part->path, sizeof(part->path), "families/%s/part-%03zu.jsonl", history_families[family].name, count);
            result = history_write(argv[2], part->path, (PerfBytes){.data = source.data + begin, .size = cursor - begin});
            ++count;
        }
    }
    for (size_t family = 0; family < 19 && result; ++family)
    {
        bool present = false;
        for (size_t i = 0; i < count; ++i)
        {
            present = present || parts[i].family == family;
        }
        if (!present)
        {
            result = count < 256;
            if (result)
            {
                parts[count].family = family;
                snprintf(parts[count].path, sizeof(parts[count].path), "families/%s/part-%03zu.jsonl", history_families[family].name, count);
                result = history_write(argv[2], parts[count].path, (PerfBytes){0});
                ++count;
            }
        }
        char file[160];
        snprintf(file, sizeof(file), "%s.bmf.json", history_families[family].name);
        result = result && census_manifest(argv[2], file, family, parts, count, argv[3], argv[4], argv[5]);
    }
    result = result && rows == 17789 && cells == 191789 && census_manifest(argv[2], "manifest.bmf.json", SIZE_MAX, parts, count, argv[3], argv[4], argv[5]);
    if (result)
    {
        printf("{\"first_party\":true,\"families\":19,\"partitions\":%zu,\"source_rows\":\"%llu\",\"source_cells\":\"%llu\",\"ordered_bytes_unchanged\":true}\n", count, (unsigned long long)rows, (unsigned long long)cells);
    }
    else
    {
        fputs("partition: frozen source or output rejected; generation is not sealed\nusage: partition CENSUS_DIR NEW_DIR RECORDED_AT BUSTER_REVISION ADAPTER_REVISION\n", stderr);
    }
    free(source.data);
    free(paths.data);
    free(families.data);
    free(schema.data);
    return result ? 0 : 1;
}
