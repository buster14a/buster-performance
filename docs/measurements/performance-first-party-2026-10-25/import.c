/* Frozen archive import using original C readers and a first-party Arrow
 * schema writer. JSONL is the producer format; no external library is used.
 * CSV cells retain source-row identity; uninterpreted evidence is never a
 * fabricated performance observation. Main: inventory, census, foreign.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#define main buster_performance_library_cli
#include "main.c"
#undef main
#include "families.inc"

static const char history_pin[] = "d3453eb2099d1e4dcd9c997720fcf6e0d86b81ea";
static const char history_inventory_hash[] = "5b3df89f6dae9185b4ff38dbef20005ef488cd2b78128ea6631a3a2208990905";
static const char history_reference_hash[] = "408d97a4462bd301ada89baa3e5c7d6f6c9ebbadd0401dc14f2c28347341ce91";

static bool history_write(const char *root, const char *name, PerfBytes bytes)
{
    char path[4096];
    int length = snprintf(path, sizeof(path), "%s/%s", root, name);
    FILE *file = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "wb") : NULL;
    bool result = file != NULL;
    if (file != NULL)
    {
        result = fwrite(bytes.data, 1, bytes.size, file) == bytes.size;
        result = fclose(file) == 0 && result;
    }
    return result;
}

static bool history_read(const char *root, const char *name, PerfBuffer *bytes)
{
    bool result = perf_read_below(root, perf_literal(name), bytes);
    return result;
}

static bool history_key(PerfBuffer *output, const char *key, bool *first)
{
    bool result = (*first || perf_buffer_byte(output, ',')) && perf_json_quote(output, perf_literal(key)) && perf_buffer_byte(output, ':');
    *first = false;
    return result;
}

static bool history_string(PerfBuffer *output, const char *key, PerfBytes text, bool *first)
{
    bool result = history_key(output, key, first) && perf_json_quote(output, text);
    return result;
}

static bool history_count(PerfBuffer *output, const char *key, uint64_t value, bool quoted, bool *first)
{
    bool result = history_key(output, key, first) && perf_integer_emit(output, value, false, quoted);
    return result;
}

static bool history_resource(PerfBuffer *output, const char *root, const char *id, const char *path, const char *format, uint64_t rows, bool has_rows)
{
    PerfBuffer bytes = {0};
    char digest[65];
    bool first = true;
    bool result = history_read(root, path, &bytes) && perf_sha256(perf_buffer_bytes(&bytes), digest) && perf_buffer_byte(output, '{') && history_string(output, "id", perf_literal(id), &first) && history_string(output, "format", perf_literal(format), &first) && history_string(output, "path", perf_literal(path), &first) && history_string(output, "sha256", perf_literal(digest), &first) && history_count(output, "bytes", bytes.size, true, &first);
    result = result && (!has_rows || history_count(output, "rows", rows, true, &first)) && perf_buffer_byte(output, '}');
    free(bytes.data);
    return result;
}

/* Git's legacy object identity uses SHA-1. This original implementation is
 * used only to verify frozen blob IDs, alongside SHA-256 resource identities. */
static uint32_t history_rotate_left(uint32_t value, unsigned int count)
{
    uint32_t result = value << count | value >> (32 - count);
    return result;
}

static void history_sha1_block(uint32_t state[5], const unsigned char bytes[64])
{
    uint32_t words[80];
    for (size_t i = 0; i < 16; ++i)
    {
        words[i] = (uint32_t)bytes[i * 4] << 24 | (uint32_t)bytes[i * 4 + 1] << 16 | (uint32_t)bytes[i * 4 + 2] << 8 | bytes[i * 4 + 3];
    }
    for (size_t i = 16; i < 80; ++i)
    {
        words[i] = history_rotate_left(words[i - 3] ^ words[i - 8] ^ words[i - 14] ^ words[i - 16], 1);
    }
    uint32_t a = state[0];
    uint32_t b = state[1];
    uint32_t c = state[2];
    uint32_t d = state[3];
    uint32_t e = state[4];
    for (size_t i = 0; i < 80; ++i)
    {
        uint32_t choose = i < 20 ? (b & c) | (~b & d) : i < 40 || i >= 60 ? b ^ c ^ d : (b & c) | (b & d) | (c & d);
        uint32_t constant = i < 20 ? 0x5a827999 : i < 40 ? 0x6ed9eba1 : i < 60 ? 0x8f1bbcdc : 0xca62c1d6;
        uint32_t next = history_rotate_left(a, 5) + choose + e + constant + words[i];
        e = d;
        d = c;
        c = history_rotate_left(b, 30);
        b = a;
        a = next;
    }
    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += e;
}

static bool history_git_blob(PerfBytes bytes, PerfBytes expected)
{
    char header[64];
    int length = snprintf(header, sizeof(header), "blob %zu", bytes.size);
    bool result = length > 0 && (size_t)length < sizeof(header) && expected.size == 40;
    uint32_t state[5] = {0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0};
    unsigned char block[64] = {0};
    uint64_t total = result ? (uint64_t)length + 1 + bytes.size : 0;
    uint64_t padded = (total + 9 + 63) / 64 * 64;
    for (uint64_t start = 0; start < padded && result; start += 64)
    {
        for (size_t i = 0; i < 64; ++i)
        {
            uint64_t at = start + i;
            block[i] = at < (uint64_t)length + 1 ? (unsigned char)header[at] : at < total ? bytes.data[at - (uint64_t)length - 1] : at == total ? 128 : at >= padded - 8 ? (unsigned char)((total * 8) >> ((padded - at - 1) * 8)) : 0;
        }
        history_sha1_block(state, block);
    }
    char digest[41];
    static const char hex[] = "0123456789abcdef";
    for (size_t i = 0; i < 20; ++i)
    {
        unsigned int byte = state[i / 4] >> (24 - (i % 4) * 8) & 255;
        digest[i * 2] = hex[byte >> 4];
        digest[i * 2 + 1] = hex[byte & 15];
    }
    digest[40] = 0;
    result = result && perf_bytes_equal(perf_literal(digest), expected);
    return result;
}

typedef struct HistoryCell HistoryCell;
struct HistoryCell
{
    uint32_t offset;
    uint32_t size;
};

typedef struct HistoryCsv HistoryCsv;
struct HistoryCsv
{
    PerfBuffer strings;
    HistoryCell *cells;
    uint32_t *rows;
    size_t count;
    size_t row_count;
    size_t capacity;
};

static PerfBytes history_cell(const HistoryCsv *csv, size_t index)
{
    PerfBytes result = index < csv->count ? (PerfBytes){.data = csv->strings.data == NULL ? (const unsigned char *)"" : csv->strings.data + csv->cells[index].offset, .size = csv->cells[index].size} : (PerfBytes){0};
    return result;
}

static bool history_csv(PerfBytes input, unsigned char delimiter, HistoryCsv *csv)
{
    csv->capacity = input.size + 1 < BUSTER_PERF_NODE_LIMIT ? input.size + 1 : BUSTER_PERF_NODE_LIMIT;
    csv->cells = calloc(csv->capacity, sizeof(*csv->cells));
    csv->rows = calloc(csv->capacity + 1, sizeof(*csv->rows));
    bool result = csv->cells != NULL && csv->rows != NULL;
    bool quoted = false;
    bool closed = false;
    bool pending = false;
    size_t cell_start = 0;
    for (size_t i = 0; i <= input.size && result; ++i)
    {
        unsigned char byte = i == input.size ? '\n' : input.data[i];
        if (quoted)
        {
            result = i != input.size;
            if (byte == '"' && i + 1 < input.size && input.data[i + 1] == '"')
            {
                result = result && perf_buffer_byte(&csv->strings, '"');
                ++i;
            }
            else if (byte == '"')
            {
                quoted = false;
                closed = true;
            }
            else
            {
                result = result && perf_buffer_byte(&csv->strings, byte);
            }
        }
        else if (byte == '"' && csv->strings.size == cell_start && !closed)
        {
            quoted = true;
            pending = true;
        }
        else if (byte == delimiter || byte == '\n' || byte == '\r')
        {
            if (i == input.size && !pending && csv->strings.size == cell_start && csv->count == csv->rows[csv->row_count])
            {
                break;
            }
            result = csv->count < csv->capacity;
            if (result)
            {
                csv->cells[csv->count++] = (HistoryCell){.offset = (uint32_t)cell_start, .size = (uint32_t)(csv->strings.size - cell_start)};
                result = perf_utf8(history_cell(csv, csv->count - 1));
                cell_start = csv->strings.size;
                closed = false;
                pending = byte == delimiter;
                if (byte == '\n' || byte == '\r')
                {
                    result = result && csv->row_count < csv->capacity;
                    csv->rows[++csv->row_count] = (uint32_t)csv->count;
                    pending = false;
                    if (byte == '\r' && i + 1 < input.size && input.data[i + 1] == '\n')
                    {
                        ++i;
                    }
                }
            }
        }
        else
        {
            /* Opaque historical TSV/log cells contain literal quotes inside
             * unquoted fields. Preserve that frozen dialect verbatim. A quote
             * at the beginning of a field still opens an escaped CSV field. */
            result = !closed && perf_buffer_byte(&csv->strings, byte);
            pending = true;
        }
    }
    result = result && !quoted;
    return result;
}

static void history_csv_free(HistoryCsv *csv)
{
    free(csv->strings.data);
    free(csv->cells);
    free(csv->rows);
}

static HistoryFamily *history_family(PerfBytes path)
{
    HistoryFamily *result = NULL;
    const char prefix[] = "docs/measurements/";
    for (size_t i = 0; i < sizeof(history_families) / sizeof(history_families[0]); ++i)
    {
        size_t name_size = strlen(history_families[i].name);
        size_t start = sizeof(prefix) - 1;
        if (path.size > start + name_size && memcmp(path.data, prefix, start) == 0 && memcmp(path.data + start, history_families[i].name, name_size) == 0 && path.data[start + name_size] == '/')
        {
            result = &history_families[i];
        }
    }
    return result;
}

static bool history_census(const char *frozen, const char *inventory_path, const char *directory, uint64_t *source_rows, uint64_t *source_cells)
{
    PerfBuffer inventory = {0};
    char digest[65];
    bool result = perf_read_file(inventory_path, &inventory) && perf_sha256(perf_buffer_bytes(&inventory), digest) && strcmp(digest, history_inventory_hash) == 0;
    PerfBuffer paths = {0};
    PerfBuffer cells = {0};
    size_t cursor = 0;
    size_t file_count = 0;
    PerfBytes previous = {0};
    while (cursor < inventory.size && result)
    {
        size_t start = cursor;
        while (cursor < inventory.size && inventory.data[cursor] != '\n')
        {
            ++cursor;
        }
        PerfBytes line = {.data = inventory.data + start, .size = cursor - start};
        cursor += cursor < inventory.size;
        size_t first_tab = 0;
        while (first_tab < line.size && line.data[first_tab] != '\t')
        {
            ++first_tab;
        }
        size_t second_tab = first_tab + 1;
        while (second_tab < line.size && line.data[second_tab] != '\t')
        {
            ++second_tab;
        }
        result = first_tab == 40 && second_tab < line.size;
        if (!result)
        {
            break;
        }
        PerfBytes blob = {.data = line.data, .size = first_tab};
        PerfBytes size_text = {.data = line.data + first_tab + 1, .size = second_tab - first_tab - 1};
        PerfBytes path = {.data = line.data + second_tab + 1, .size = line.size - second_tab - 1};
        HistoryFamily *family = history_family(path);
        uint64_t expected_size = 0;
        result = family != NULL && perf_resource_path(path) && perf_uint64(size_text, &expected_size) && expected_size <= BUSTER_PERF_BYTE_LIMIT && (file_count == 0 || perf_json_key_compare(&previous, &path) < 0);
        previous = path;
        PerfBuffer bytes = {0};
        result = result && perf_read_below(frozen, path, &bytes) && expected_size == bytes.size && history_git_blob(perf_buffer_bytes(&bytes), blob) && perf_sha256(perf_buffer_bytes(&bytes), digest);
        if (result)
        {
            ++file_count;
            ++family->files;
            PerfBuffer url = {0};
            result = perf_buffer_append(&url, perf_literal("https://raw.githubusercontent.com/buster14a/buster-performance/")) && perf_buffer_append(&url, perf_literal(history_pin)) && perf_buffer_byte(&url, '/') && perf_buffer_append(&url, path);
            bool first = true;
            result = result && perf_buffer_byte(&paths, '{') && history_string(&paths, "family", perf_literal(family->name), &first) && history_string(&paths, "path", path, &first) && history_string(&paths, "git_blob", blob, &first) && history_string(&paths, "sha256", perf_literal(digest), &first) && history_string(&paths, "source", perf_buffer_bytes(&url), &first) && history_count(&paths, "bytes", bytes.size, true, &first) && history_string(&paths, "disposition", perf_literal(family->disposition), &first) && history_string(&paths, "reason", perf_literal(family->reason), &first) && history_string(&paths, "scope", perf_literal(family->scope), &first) && perf_buffer_append(&paths, perf_literal("}\n"));
            free(url.data);
            bool csv_file = path.size >= 4 && memcmp(path.data + path.size - 4, ".csv", 4) == 0;
            bool tsv_file = path.size >= 4 && memcmp(path.data + path.size - 4, ".tsv", 4) == 0;
            if (result && (csv_file || tsv_file))
            {
                HistoryCsv csv = {0};
                result = history_csv(perf_buffer_bytes(&bytes), tsv_file ? '\t' : ',', &csv);
                bool converted = perf_bytes_equal(path, perf_literal("docs/measurements/foreign-strings-2026-10-23/raw/samples.csv")) || perf_bytes_equal(path, perf_literal("docs/measurements/foreign-strings-2026-10-23/raw/processes.csv"));
                for (size_t row = 0; row < csv.row_count && result; ++row)
                {
                    bool first_cell = true;
                    result = perf_buffer_byte(&cells, '{') && history_string(&cells, "family", perf_literal(family->name), &first_cell) && history_string(&cells, "path", path, &first_cell) && history_count(&cells, "source_row", row + 1, true, &first_cell) && history_key(&cells, "cells", &first_cell) && perf_buffer_byte(&cells, '[');
                    for (size_t c = csv.rows[row]; c < csv.rows[row + 1] && result; ++c)
                    {
                        result = (c == csv.rows[row] || perf_buffer_byte(&cells, ',')) && perf_json_quote(&cells, history_cell(&csv, c));
                    }
                    result = result && perf_buffer_byte(&cells, ']') && history_string(&cells, "disposition", perf_literal(converted ? "imported" : "unsupported"), &first_cell) && history_string(&cells, "reason", perf_literal(converted ? "Original source row retained; header and blank records are evidence, not observations. foreign-strings.v2 converts measurement records only." : "Opaque source cells, including headers/comments. Numeric types, counters, independence and timing windows are not inferred."), &first_cell) && perf_buffer_append(&cells, perf_literal("}\n"));
                    ++*source_rows;
                    *source_cells += csv.rows[row + 1] - csv.rows[row];
                    ++family->source_rows;
                    family->source_cells += csv.rows[row + 1] - csv.rows[row];
                }
                history_csv_free(&csv);
            }
        }
        if (!result)
        {
            fprintf(stderr, "Frozen source rejected: %.*s\n", (int)path.size, path.data);
        }
        free(bytes.data);
    }
    PerfBuffer families = {0};
    result = result && file_count == 1043 && perf_buffer_byte(&families, '[');
    for (size_t i = 0; i < sizeof(history_families) / sizeof(history_families[0]) && result; ++i)
    {
        const HistoryFamily *family = &history_families[i];
        bool first = true;
        result = family->files == family->expected_files && (i == 0 || perf_buffer_byte(&families, ',')) && perf_buffer_byte(&families, '{') && history_string(&families, "family", perf_literal(family->name), &first) && history_count(&families, "files", family->files, false, &first) && history_count(&families, "source_rows", family->source_rows, false, &first) && history_count(&families, "source_cells", family->source_cells, false, &first) && history_string(&families, "disposition", perf_literal(family->disposition), &first) && history_string(&families, "reason", perf_literal(family->reason), &first) && history_string(&families, "scope", perf_literal(family->scope), &first) && perf_buffer_byte(&families, '}');
    }
    result = result && perf_buffer_append(&families, perf_literal("]\n")) && history_write(directory, "family-census.json", perf_buffer_bytes(&families)) && history_write(directory, "source-paths.jsonl", perf_buffer_bytes(&paths)) && history_write(directory, "source-cells.jsonl", perf_buffer_bytes(&cells));
    free(inventory.data);
    free(paths.data);
    free(cells.data);
    free(families.data);
    return result;
}

static bool history_census_schema(const char *directory)
{
    const char *names[] = {"family", "path", "source_row", "cells", "item", "disposition", "reason"};
    PerfArrowField fields[7] = {0};
    for (uint32_t i = 0; i < 7; ++i)
    {
        fields[i].name = perf_literal(names[i]);
        fields[i].next = i + 1;
        fields[i].type = i == 2 ? 2 : i == 3 ? 12 : 5;
        fields[i].bit_width = i == 2 ? 64 : 0;
    }
    fields[3].next = 5;
    fields[3].children = 1;
    PerfArrowSchema schema = {.fields = fields, .count = 7, .roots = 6};
    PerfBuffer bytes = {0};
    bool result = perf_arrow_schema_write(&schema, &bytes) && history_write(directory, "source-cells.schema.arrow", perf_buffer_bytes(&bytes));
    free(bytes.data);
    return result;
}

static bool history_census_manifest(const char *directory, const char *recorded_at, const char *reader_revision, const char *adapter_revision, uint64_t rows, uint64_t cells)
{
    PerfBuffer manifest = {0};
    bool first = true;
    bool result = perf_buffer_byte(&manifest, '{');
    result = result && history_string(&manifest, "format", perf_literal("buster-benchmark"), &first);
    result = result && history_count(&manifest, "version", 1, false, &first);
    result = result && history_string(&manifest, "id", perf_literal("frozen-history-census-first-party-v2"), &first);
    result = result && history_string(&manifest, "kind", perf_literal("imported"), &first);
    result = result && history_string(&manifest, "status", perf_literal("complete"), &first);
    result = result && history_string(&manifest, "recorded_at", perf_literal(recorded_at), &first);
    result = result && history_key(&manifest, "producer", &first) && perf_buffer_byte(&manifest, '{');
    bool producer_first = true;
    result = result && history_string(&manifest, "name", perf_literal("buster-history-first-party"), &producer_first);
    result = result && history_string(&manifest, "version", perf_literal("2"), &producer_first);
    result = result && history_string(&manifest, "revision", perf_literal(adapter_revision), &producer_first) && perf_buffer_byte(&manifest, '}');
    result = result && history_key(&manifest, "resources", &first) && perf_buffer_byte(&manifest, '[');
    const char *files[] = {"family-census.json", "source-paths.jsonl", "source-cells.jsonl", "source-cells.schema.arrow"};
    const char *ids[] = {"families", "paths", "source-cells-jsonl", "source-cells-schema"};
    const char *formats[] = {"json", "jsonl", "jsonl", "arrow-ipc-stream"};
    for (size_t i = 0; i < 4 && result; ++i)
    {
        result = (i == 0 || perf_buffer_byte(&manifest, ',')) && history_resource(&manifest, directory, ids[i], files[i], formats[i], i == 1 ? 1043 : i == 2 ? rows : 0, i != 0);
    }
    result = result && perf_buffer_byte(&manifest, ']') && history_key(&manifest, "tables", &first);
    result = result && perf_buffer_append(&manifest, perf_literal("[{\"id\":\"source-cells\",\"data\":[\"source-cells-jsonl\"],\"schema\":\"source-cells-schema\",\"primary_key\":[\"path\",\"source_row\"],\"dimensions\":[\"family\",\"path\",\"disposition\"],\"metadata\":{\"row_meaning\":\"opaque original evidence row; headers/comments retained; no invented timing observation\"}}]"));
    result = result && history_key(&manifest, "limitations", &first);
    result = result && perf_buffer_append(&manifest, perf_literal("[\"Complete frozen inventory, not complete semantic timing conversion. Every family, file and retained structured source row has an explicit disposition.\",\"Original bytes remain at the frozen source commit. Protocol-only families produce no measurement rows. Unknown sentinel, timing and independence interpretations remain unavailable.\"]"));
    result = result && history_key(&manifest, "provenance", &first) && perf_buffer_byte(&manifest, '{');
    bool provenance_first = true;
    result = result && history_string(&manifest, "repository", perf_literal("buster14a/buster-performance"), &provenance_first);
    result = result && history_string(&manifest, "commit", perf_literal(history_pin), &provenance_first);
    result = result && history_string(&manifest, "adapter", perf_literal("history-census.first-party.v2"), &provenance_first);
    result = result && history_string(&manifest, "reader_revision", perf_literal(reader_revision), &provenance_first) && perf_buffer_byte(&manifest, '}');
    result = result && history_key(&manifest, "census", &first) && perf_buffer_byte(&manifest, '{');
    bool census_first = true;
    result = result && history_count(&manifest, "families", 19, false, &census_first);
    result = result && history_count(&manifest, "tracked_paths", 1043, false, &census_first);
    result = result && history_count(&manifest, "retained_source_rows", rows, false, &census_first);
    result = result && history_count(&manifest, "retained_source_cells", cells, false, &census_first);
    result = result && perf_buffer_append(&manifest, perf_literal("}}\n"));
    result = result && history_write(directory, "manifest.bmf.json", perf_buffer_bytes(&manifest));
    free(manifest.data);
    return result;
}

typedef struct HistoryPatch HistoryPatch;
struct HistoryPatch
{
    uint32_t node;
    PerfBuffer bytes;
};

static bool history_patched(const PerfJson *document, HistoryPatch *patches, size_t count, PerfBuffer *output)
{
    bool result = true;
    for (size_t a = 1; a < count; ++a)
    {
        for (size_t b = a; b > 0 && document->nodes[patches[b - 1].node].raw_offset > document->nodes[patches[b].node].raw_offset; --b)
        {
            HistoryPatch swap = patches[b - 1];
            patches[b - 1] = patches[b];
            patches[b] = swap;
        }
    }
    size_t cursor = 0;
    for (size_t i = 0; i < count && result; ++i)
    {
        const PerfJsonNode *node = &document->nodes[patches[i].node];
        result = node->raw_offset >= cursor && perf_buffer_append(output, (PerfBytes){.data = document->source.data + cursor, .size = node->raw_offset - cursor}) && perf_buffer_append(output, perf_buffer_bytes(&patches[i].bytes));
        cursor = (size_t)node->raw_offset + node->raw_size;
    }
    result = result && perf_buffer_append(output, (PerfBytes){.data = document->source.data + cursor, .size = document->source.size - cursor});
    return result;
}

static bool history_foreign(const char *archive, const char *frozen, const char *directory, const char *recorded_at, const char *revision, const char *adapter_revision)
{
    const char *reference = "docs/measurements/performance-format-2026-10-24/foreign-strings-example/";
    const char *names[] = {"link-results", "executions"};
    const char *sources[] = {"samples.csv", "processes.csv"};
    uint64_t converted_cells = 0;
    PerfBuffer manifest_bytes = {0};
    PerfJson manifest = {0};
    char manifest_path[512];
    snprintf(manifest_path, sizeof(manifest_path), "%smanifest.bmf.json", reference);
    char reference_digest[65];
    bool result = history_read(archive, manifest_path, &manifest_bytes) && perf_sha256(perf_buffer_bytes(&manifest_bytes), reference_digest) && strcmp(reference_digest, history_reference_hash) == 0 && perf_json_parse(&manifest, perf_buffer_bytes(&manifest_bytes));
    for (size_t t = 0; t < 2 && result; ++t)
    {
        char name[512];
        PerfBuffer reference_bytes = {0};
        snprintf(name, sizeof(name), "%s%s.arrow", reference, names[t]);
        result = history_read(archive, name, &reference_bytes);
        char resource_id[256];
        snprintf(resource_id, sizeof(resource_id), "%s-arrow", names[t]);
        uint32_t reference_resource = perf_identity(&manifest, "resources", perf_literal(resource_id));
        char actual_digest[65];
        result = result && perf_sha256(perf_buffer_bytes(&reference_bytes), actual_digest) && perf_bytes_equal(perf_literal(actual_digest), perf_json_text(&manifest, perf_json_find(&manifest, reference_resource, "sha256")));
        PerfArrowInfo info = {0};
        PerfBuffer expected = {0};
        result = result && perf_arrow_read(perf_buffer_bytes(&reference_bytes), &info, &expected) && info.json_mapping;
        snprintf(name, sizeof(name), "%s.arrow", names[t]);
        result = result && history_write(directory, name, perf_buffer_bytes(&reference_bytes));
        PerfBuffer schema = {0};
        result = result && perf_arrow_schema_write(&info.schema, &schema);
        snprintf(name, sizeof(name), "%s.schema.arrow", names[t]);
        result = result && history_write(directory, name, perf_buffer_bytes(&schema));
        PerfBuffer source = {0};
        snprintf(name, sizeof(name), "docs/measurements/foreign-strings-2026-10-23/raw/%s", sources[t]);
        result = result && history_read(frozen, name, &source);
        HistoryCsv csv = {0};
        result = result && history_csv(perf_buffer_bytes(&source), ',', &csv) && csv.row_count > 0 && csv.rows[1] == info.schema.roots;
        size_t field = 0;
        for (size_t c = 0; c < info.schema.roots && result; ++c)
        {
            result = perf_bytes_equal(history_cell(&csv, c), info.schema.fields[field].name);
            field = info.schema.fields[field].next;
        }
        PerfBuffer converted = {0};
        uint64_t rows = 0;
        for (size_t row = 1; row < csv.row_count && result; ++row)
        {
            uint32_t start = csv.rows[row];
            uint32_t end = csv.rows[row + 1];
            if (end - start == 1 && history_cell(&csv, start).size == 0)
            {
                continue;
            }
            result = end - start == info.schema.roots && perf_buffer_byte(&converted, '{');
            field = 0;
            for (uint32_t cell = start; cell < end && result; ++cell)
            {
                const PerfArrowField *type = &info.schema.fields[field];
                PerfBytes text = history_cell(&csv, cell);
                result = (cell == start || perf_buffer_byte(&converted, ',')) && perf_json_quote(&converted, type->name) && perf_buffer_byte(&converted, ':');
                if (type->type == 2)
                {
                    uint64_t magnitude = 0;
                    bool negative = false;
                    result = result && perf_integer(text, type->bit_width, type->is_signed, &negative, &magnitude) && perf_integer_emit(&converted, magnitude, negative, type->bit_width == 64);
                }
                else if (type->type == 7)
                {
                    result = result && perf_decimal_json(&converted, type, text);
                }
                else
                {
                    result = result && type->type == 5 && perf_json_quote(&converted, text);
                }
                field = type->next;
                ++converted_cells;
            }
            result = result && perf_buffer_append(&converted, perf_literal("}\n"));
            ++rows;
        }
        snprintf(name, sizeof(name), "%s.jsonl", names[t]);
        result = result && rows == (t == 0 ? 288 : 12) && perf_bytes_equal(perf_buffer_bytes(&converted), perf_buffer_bytes(&expected)) && history_write(directory, name, perf_buffer_bytes(&converted));
        free(reference_bytes.data);
        free(info.schema.fields);
        free(expected.data);
        free(schema.data);
        free(source.data);
        free(converted.data);
        history_csv_free(&csv);
    }
    result = result && converted_cells == 7308;
    HistoryPatch patches[10] = {0};
    size_t patch_count = 0;
    const char *keys[] = {"id", "recorded_at", "producer", "resources", "provenance"};
    for (size_t i = 0; i < 5 && result; ++i)
    {
        patches[patch_count++].node = perf_json_find(&manifest, 0, keys[i]);
        result = patches[i].node < manifest.node_count;
    }
    result = result && perf_json_quote(&patches[0].bytes, perf_literal("foreign-strings-frozen-first-party-v2")) && perf_json_quote(&patches[1].bytes, perf_literal(recorded_at)) && perf_buffer_append(&patches[2].bytes, perf_literal("{\"name\":\"buster-history-first-party\",\"version\":\"2\",\"revision\":")) && perf_json_quote(&patches[2].bytes, perf_literal(adapter_revision)) && perf_buffer_byte(&patches[2].bytes, '}') && perf_buffer_byte(&patches[3].bytes, '[');
    uint32_t resources = perf_json_find(&manifest, 0, "resources");
    size_t resource_index = 0;
    for (uint32_t definition = perf_json_first(&manifest, resources); definition != UINT32_MAX && result; definition = perf_json_after(&manifest, resources, definition))
    {
        PerfBuffer *output = &patches[3].bytes;
        result = resource_index++ == 0 || perf_buffer_byte(output, ',');
        uint32_t local = perf_json_find(&manifest, definition, "path");
        if (local == UINT32_MAX)
        {
            const PerfJsonNode *node = &manifest.nodes[definition];
            result = result && perf_buffer_append(output, (PerfBytes){.data = manifest.source.data + node->raw_offset, .size = node->raw_size});
        }
        else
        {
            char file[256];
            char id[256];
            char format[64];
            PerfBytes file_name = perf_json_text(&manifest, local);
            PerfBytes resource_id = perf_json_text(&manifest, perf_json_find(&manifest, definition, "id"));
            PerfBytes resource_format = perf_json_text(&manifest, perf_json_find(&manifest, definition, "format"));
            result = result && file_name.size < sizeof(file) && resource_id.size < sizeof(id) && resource_format.size < sizeof(format);
            if (result)
            {
                memcpy(file, file_name.data, file_name.size);
                file[file_name.size] = 0;
                memcpy(id, resource_id.data, resource_id.size);
                id[resource_id.size] = 0;
                memcpy(format, resource_format.data, resource_format.size);
                format[resource_format.size] = 0;
                uint64_t count = 0;
                PerfBuffer resource_json = {0};
                result = perf_uint64(perf_json_text(&manifest, perf_json_find(&manifest, definition, "rows")), &count) && history_resource(&resource_json, directory, id, file, format, count, true);
                if (result)
                {
                    --resource_json.size;
                }
                for (uint32_t key = perf_json_first(&manifest, definition); key != UINT32_MAX && result; key = perf_json_after(&manifest, definition, key))
                {
                    if (perf_json_is(&manifest, key, "id") || perf_json_is(&manifest, key, "format") || perf_json_is(&manifest, key, "path") || perf_json_is(&manifest, key, "sha256") || perf_json_is(&manifest, key, "bytes") || perf_json_is(&manifest, key, "rows"))
                    {
                        continue;
                    }
                    const PerfJsonNode *node = &manifest.nodes[key + 1];
                    result = perf_buffer_byte(&resource_json, ',') && perf_json_quote(&resource_json, perf_json_text(&manifest, key)) && perf_buffer_byte(&resource_json, ':') && perf_buffer_append(&resource_json, (PerfBytes){.data = manifest.source.data + node->raw_offset, .size = node->raw_size});
                }
                result = result && perf_buffer_byte(&resource_json, '}') && perf_buffer_append(output, perf_buffer_bytes(&resource_json));
                free(resource_json.data);
            }
        }
    }
    result = result && perf_buffer_byte(&patches[3].bytes, ']');
    if (result)
    {
        const PerfJsonNode *provenance = &manifest.nodes[patches[4].node];
        result = provenance->kind == PERF_JSON_OBJECT && provenance->raw_size > 1 && perf_buffer_append(&patches[4].bytes, (PerfBytes){.data = manifest.source.data + provenance->raw_offset, .size = provenance->raw_size - 1});
        bool first = provenance->children == 0;
        result = result && history_string(&patches[4].bytes, "adapter", perf_literal("foreign-strings.first-party.v2"), &first) && history_string(&patches[4].bytes, "reader_revision", perf_literal(revision), &first) && history_string(&patches[4].bytes, "reference_manifest_sha256", perf_literal(history_reference_hash), &first) && history_string(&patches[4].bytes, "source_cell_equivalence", perf_literal("7308 original decoded CSV cells; source spelling and precision remain in the frozen originals and row census. JSONL is produced from original CSV; Arrow alternatives are independently encoded reference artifacts. Inner 11 observations are not reconstructed."), &first) && perf_buffer_byte(&patches[4].bytes, '}');
    }
    uint32_t tables = perf_json_find(&manifest, 0, "tables");
    size_t table_index = 0;
    for (uint32_t table = perf_json_first(&manifest, tables); table != UINT32_MAX && result; table = perf_json_after(&manifest, tables, table))
    {
        patches[patch_count].node = perf_json_find(&manifest, table, "data");
        result = perf_buffer_append(&patches[patch_count++].bytes, perf_literal(table_index == 0 ? "[\"link-results-jsonl\"]" : "[\"executions-jsonl\"]"));
        patches[patch_count].node = perf_json_find(&manifest, table, "alternatives");
        result = result && perf_buffer_append(&patches[patch_count++].bytes, perf_literal(table_index == 0 ? "[[\"link-results-arrow\"]]" : "[[\"executions-arrow\"]]"));
        ++table_index;
    }
    PerfBuffer produced = {0};
    result = result && table_index == 2 && history_patched(&manifest, patches, patch_count, &produced) && history_write(directory, "manifest.bmf.json", perf_buffer_bytes(&produced));
    for (size_t i = 0; i < 10; ++i)
    {
        free(patches[i].bytes.data);
    }
    free(produced.data);
    free(manifest_bytes.data);
    perf_json_free(&manifest);
    return result;
}

static bool history_revision(const char *revision)
{
    bool result = strlen(revision) == 40;
    bool nonzero = false;
    for (size_t i = 0; i < 40 && result; ++i)
    {
        result = (revision[i] >= '0' && revision[i] <= '9') || (revision[i] >= 'a' && revision[i] <= 'f');
        nonzero = nonzero || revision[i] != '0';
    }
    result = result && nonzero;
    return result;
}

int history_import_run(int argc, char **argv)
{
    bool result = argc == 8 && perf_timestamp(perf_literal(argv[5])) && history_revision(argv[6]) && history_revision(argv[7]);
    if (!result)
    {
        fputs("usage: import ARCHIVE_ROOT FROZEN_ROOT INVENTORY_TSV NEW_OUTPUT_DIR RECORDED_AT BUSTER_REVISION ADAPTER_REVISION\n", stderr);
    }
    char census[4096];
    char foreign[4096];
    if (result)
    {
        int a = snprintf(census, sizeof(census), "%s/census", argv[4]);
        int b = snprintf(foreign, sizeof(foreign), "%s/foreign-strings", argv[4]);
        result = a > 0 && (size_t)a < sizeof(census) && b > 0 && (size_t)b < sizeof(foreign) && mkdir(argv[4], 0755) == 0 && mkdir(census, 0755) == 0 && mkdir(foreign, 0755) == 0;
    }
    uint64_t rows = 0;
    uint64_t cells = 0;
    result = result && history_census(argv[2], argv[3], census, &rows, &cells) && rows == 17789 && cells == 191789 && history_census_schema(census) && history_census_manifest(census, argv[5], argv[6], argv[7], rows, cells) && history_foreign(argv[1], argv[2], foreign, argv[5], argv[6], argv[7]);
    if (result)
    {
        printf("{\"first_party\":true,\"families\":19,\"paths\":1043,\"opaque_source_rows\":\"%llu\",\"opaque_source_cells\":\"%llu\",\"foreign_rows\":300,\"foreign_source_cells\":7308}\n", (unsigned long long)rows, (unsigned long long)cells);
    }
    else
    {
        fputs("Frozen inventory, source cells or typed conversion rejected; output is not a sealed generation\n", stderr);
    }
    return result ? 0 : 1;
}

#ifndef BUSTER_HISTORY_NO_MAIN
int main(int argc, char **argv)
{
    int result = history_import_run(argc, argv);
    return result;
}
#endif
