// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Fresh, first-party C receipt controls. Proof records are synthetic fixtures;
// no object image, producer, assembler or remote service is read or executed.
// Actual write failures use only a private child's RLIMIT_FSIZE, restored by
// process exit, with the parent limits checked unchanged afterwards.
#define _GNU_SOURCE
#include "hp_receipt.h"

#include <assert.h>
#include <errno.h>
#include <inttypes.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUSTER_RECEIPT_CONTROL_LIMIT 128U
#define BUSTER_RECEIPT_DIGEST "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
#define BUSTER_RECEIPT_ARRAY_COUNT(values) (sizeof(values) / sizeof((values)[0]))

typedef struct ReceiptResult ReceiptResult;
struct ReceiptResult
{
    const char *name;
    bool passed;
    char error[BUSTER_HP_ERROR_CAPACITY];
};

typedef struct ReceiptSuite ReceiptSuite;
struct ReceiptSuite
{
    ReceiptResult results[BUSTER_RECEIPT_CONTROL_LIMIT];
    size_t count;
    size_t failures;
    char root[BUSTER_HP_PATH_CAPACITY];
};

static void receipt_record(ReceiptSuite *suite, const char *name, bool passed, const char *error)
{
    assert(suite->count < BUSTER_RECEIPT_ARRAY_COUNT(suite->results));
    ReceiptResult *result = &suite->results[suite->count++];
    result->name = name;
    result->passed = passed;
    snprintf(result->error, sizeof(result->error), "%s", error);
    suite->failures += !passed;
    printf("%s %s%s%s\n", passed ? "PASS" : "FAIL", name, !passed ? ": " : "", !passed ? error : "");
    return;
}

static void receipt_path(ReceiptSuite *suite, char path[BUSTER_HP_PATH_CAPACITY], const char *leaf)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool valid = hp_join_path(path, suite->root, leaf, error);
    assert(valid);
    return;
}

static HpBuffer receipt_read(const char *path)
{
    HpBuffer bytes = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool valid = hp_read_file(path, 1024 * 1024, &bytes, error);
    assert(valid);
    return bytes;
}

static const char *receipt_field(const HpBuffer *json, const char *key, size_t occurrence)
{
    char needle[128];
    int count = snprintf(needle, sizeof(needle), "\"%s\"", key);
    assert(count > 0 && (size_t)count < sizeof(needle));
    const char *cursor = (const char *)json->data;
    const char *result = NULL;
    size_t seen = 0;
    while (cursor != NULL)
    {
        const char *found = strstr(cursor, needle);
        cursor = found != NULL ? found + count : NULL;
        if (found != NULL)
        {
            while (*cursor == ' ' || *cursor == '\t' || *cursor == '\n')
            {
                cursor += 1;
            }
            if (*cursor == ':')
            {
                cursor += 1;
                while (*cursor == ' ' || *cursor == '\t' || *cursor == '\n')
                {
                    cursor += 1;
                }
                if (seen == occurrence)
                {
                    result = cursor;
                    cursor = NULL;
                }
                seen += 1;
            }
        }
    }
    return result;
}

static bool receipt_value(const HpBuffer *json, const char *key, size_t occurrence, const char *expected)
{
    const char *value = receipt_field(json, key, occurrence);
    size_t size = strlen(expected);
    bool valid = value != NULL && strncmp(value, expected, size) == 0;
    if (valid)
    {
        char next = value[size];
        valid = next == ',' || next == '}' || next == ']' || next == ' ' || next == '\t' || next == '\n';
    }
    return valid;
}

static bool receipt_number(const HpBuffer *json, const char *key, size_t occurrence, uint64_t expected)
{
    char text[32];
    int count = snprintf(text, sizeof(text), "%" PRIu64, expected);
    assert(count > 0 && (size_t)count < sizeof(text));
    return receipt_value(json, key, occurrence, text);
}

static bool receipt_count(const HpBuffer *json, const char *key, size_t expected)
{
    return (expected == 0 || receipt_field(json, key, expected - 1) != NULL) && receipt_field(json, key, expected) == NULL;
}

static bool receipt_envelope(const HpBuffer *json)
{
    bool valid = json->size >= 4 && json->data[0] == '{' && json->data[json->size - 2] == '}' && json->data[json->size - 1] == '\n' && memchr(json->data, 0, json->size) == NULL;
    valid = valid && receipt_value(json, "schema", 0, "\"buster-hot-placement-proof-v1\"") && receipt_value(json, "passed", 0, "true") && receipt_count(json, "schema", 1) && receipt_count(json, "passed", 1);
    return valid;
}

static bool receipt_limits(const HpBuffer *json)
{
    return receipt_count(json, "limits", 1) && receipt_value(json, "pt_load_validated", 0, "false") && receipt_value(json, "numeric_resolved_operands_validated", 0, "false") && receipt_value(json, "runtime_semantics_validated", 0, "false");
}

static HpObjectProof receipt_object_fixture(HpDisclosure disclosures[3])
{
    disclosures[0].kind = BUSTER_HP_DISCLOSURE_COMMENT;
    disclosures[0].section = 42;
    disclosures[1].kind = BUSTER_HP_DISCLOSURE_FILE_RECORDS;
    disclosures[1].section = SIZE_MAX;
    disclosures[2].kind = BUSTER_HP_DISCLOSURE_NORMALIZED_ENCODING;
    disclosures[2].section = 17;
    HpObjectProof proof = {0};
    proof.shift = 16;
    proof.hot_bytes_before = 1234567890123;
    proof.hot_alignment = 4096;
    proof.symbols_compared = 35791;
    proof.relocations_compared = 24680;
    proof.disclosures = disclosures;
    proof.disclosure_count = 3;
    return proof;
}

static HpLinkedProof receipt_linked_fixture(HpLinkedFunction functions[2], HpLinkedOperand operands[2])
{
    static const char escaped_name[] =
    {
        'e',
        'm',
        'i',
        't',
        '"',
        '\\',
        '\n',
        '\t',
        0,
        (char)0xff
    };
    memset(functions, 0, sizeof(*functions) * 2);
    functions[0].name.data = escaped_name;
    functions[0].name.size = sizeof(escaped_name);
    functions[0].object_symbol = 103;
    functions[0].object_offset = 4097;
    functions[0].size = 251;
    functions[0].normal_address = UINT64_C(9223372036854775811);
    functions[0].variant_address = UINT64_C(9223372036854775827);
    functions[0].delta = 16;
    functions[0].normal_residue_4096 = 3;
    functions[0].variant_residue_4096 = 19;
    functions[1].name.data = "drain second";
    functions[1].name.size = strlen(functions[1].name.data);
    functions[1].object_symbol = 207;
    functions[1].object_offset = 12345;
    functions[1].size = 0;
    functions[1].normal_address = UINT64_MAX - 16;
    functions[1].variant_address = UINT64_MAX;
    functions[1].delta = 16;
    functions[1].normal_residue_4096 = 4079;
    functions[1].variant_residue_4096 = 4095;
    operands[0].object_relocation = 301;
    operands[0].offset = 4001;
    operands[0].type = 2;
    operands[0].width = 4;
    operands[1].object_relocation = 401;
    operands[1].offset = 5001;
    operands[1].type = 1;
    operands[1].width = 8;
    HpLinkedProof proof = {0};
    proof.shift = 16;
    proof.hot_input_base = UINT64_C(9223372036854771712);
    proof.hot_bytes = 65537;
    proof.hot_alignment = 4096;
    proof.normal_output_section.data = ".text\"\\normal";
    proof.normal_output_section.size = strlen(proof.normal_output_section.data);
    proof.variant_output_section.data = ".text shifted";
    proof.variant_output_section.size = strlen(proof.variant_output_section.data);
    proof.functions = functions;
    proof.function_count = 2;
    proof.operands = operands;
    proof.operand_count = 2;
    proof.masked_operand_bytes = 12;
    return proof;
}

static void receipt_object_cases(ReceiptSuite *suite)
{
    HpDisclosure disclosures[3];
    HpObjectProof proof = receipt_object_fixture(disclosures);
    char path[BUSTER_HP_PATH_CAPACITY];
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    receipt_path(suite, path, "object proof.json");
    bool written = hp_receipt_object(path, &proof, error);
    receipt_record(suite, "object-exclusive-write", written, error);
    HpBuffer json = receipt_read(path);
    receipt_record(suite, "object-envelope-and-kind", receipt_envelope(&json) && receipt_value(&json, "kind", 0, "\"ET_REL hot-section structural translation\""), error);
    receipt_record(suite, "object-all-scalar-counts", receipt_number(&json, "shift", 0, proof.shift) && receipt_number(&json, "hot_bytes_before", 0, proof.hot_bytes_before) && receipt_number(&json, "hot_alignment", 0, proof.hot_alignment) && receipt_number(&json, "symbols_compared", 0, proof.symbols_compared) && receipt_number(&json, "relocations_compared", 0, proof.relocations_compared) && receipt_number(&json, "disclosure_count", 0, 3), error);
    receipt_record(suite, "object-all-disclosure-kinds-and-sections", receipt_count(&json, "section", 3) && receipt_count(&json, "kind", 4) && receipt_number(&json, "kind", 1, 0) && receipt_number(&json, "section", 0, 42) && receipt_number(&json, "kind", 2, 1) && receipt_value(&json, "section", 1, "null") && receipt_number(&json, "kind", 3, 2) && receipt_number(&json, "section", 2, 17), error);
    receipt_record(suite, "object-disclosure-meanings-retained", receipt_value(&json, "meaning", 0, "\"nonalloc .comment producer bytes/presence differ\"") && receipt_value(&json, "meaning", 1, "\"unreferenced STT_FILE producer records differ\"") && receipt_value(&json, "meaning", 2, "\"normalized symbol/string/RELA encoding differs\""), error);
    receipt_record(suite, "object-explicit-semantic-limits", receipt_limits(&json) && receipt_count(&json, "scope", 1), error);
    struct stat state;
    receipt_record(suite, "receipt-no-group-or-world-permissions", stat(path, &state) == 0 && (state.st_mode & 0077) == 0, error);
    bool refused = !hp_receipt_object(path, &proof, error);
    HpBuffer after = receipt_read(path);
    receipt_record(suite, "object-existing-file-refused-and-preserved", refused && after.size == json.size && memcmp(after.data, json.data, json.size) == 0, error);
    hp_buffer_free(&after);
    hp_buffer_free(&json);
    receipt_path(suite, path, "object-no-disclosures.json");
    proof.disclosures = NULL;
    proof.disclosure_count = 0;
    written = hp_receipt_object(path, &proof, error);
    json = receipt_read(path);
    receipt_record(suite, "object-empty-disclosure-vector", written && receipt_number(&json, "disclosure_count", 0, 0) && receipt_count(&json, "section", 0) && strstr((const char *)json.data, "\"disclosed_nonsemantic_differences\": [\n  ]") != NULL, error);
    hp_buffer_free(&json);
    receipt_path(suite, path, "object-numeric-max.json");
    proof.hot_bytes_before = UINT64_MAX;
    proof.symbols_compared = SIZE_MAX;
    proof.relocations_compared = SIZE_MAX;
    written = hp_receipt_object(path, &proof, error);
    json = receipt_read(path);
    receipt_record(suite, "object-numeric-full-width-no-truncation", written && receipt_number(&json, "hot_bytes_before", 0, UINT64_MAX) && receipt_number(&json, "symbols_compared", 0, SIZE_MAX) && receipt_number(&json, "relocations_compared", 0, SIZE_MAX), error);
    hp_buffer_free(&json);
    return;
}

static void receipt_linked_cases(ReceiptSuite *suite)
{
    HpLinkedFunction functions[2];
    HpLinkedOperand operands[2];
    HpLinkedProof proof = receipt_linked_fixture(functions, operands);
    char path[BUSTER_HP_PATH_CAPACITY];
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    receipt_path(suite, path, "linked proof.json");
    bool written = hp_receipt_linked(path, &proof, error);
    receipt_record(suite, "linked-exclusive-write", written, error);
    HpBuffer json = receipt_read(path);
    receipt_record(suite, "linked-envelope-and-kind", receipt_envelope(&json) && receipt_value(&json, "kind", 0, "\"object-qualified linked hot geometry and nonrelocation bytes\""), error);
    receipt_record(suite, "linked-root-geometry-and-counts-complete", receipt_number(&json, "shift", 0, proof.shift) && receipt_number(&json, "hot_input_base", 0, proof.hot_input_base) && receipt_number(&json, "hot_bytes", 0, proof.hot_bytes) && receipt_number(&json, "hot_alignment", 0, proof.hot_alignment) && receipt_number(&json, "function_count", 0, 2) && receipt_number(&json, "operand_count", 0, 2) && receipt_number(&json, "masked_operand_bytes", 0, 12), error);
    receipt_record(suite, "linked-section-names-escaped-and-retained", receipt_value(&json, "normal_output_section", 0, "\".text\\\"\\\\normal\"") && receipt_value(&json, "variant_output_section", 0, "\".text shifted\""), error);
    receipt_record(suite, "linked-function-name-all-byte-escapes", receipt_value(&json, "name", 0, "\"emit\\\"\\\\\\u000a\\u0009\\u0000\\u00ff\"") && receipt_value(&json, "name", 1, "\"drain second\"") && receipt_count(&json, "name", 2), error);
    static const char *const keys[] =
    {
        "object_symbol",
        "object_offset",
        "size",
        "normal_address",
        "variant_address",
        "delta",
        "normal_residue_4096",
        "variant_residue_4096"
    };
    for (size_t i = 0; i < 2; i += 1)
    {
        uint64_t values[] =
        {
            functions[i].object_symbol,
            functions[i].object_offset,
            functions[i].size,
            functions[i].normal_address,
            functions[i].variant_address,
            functions[i].delta,
            functions[i].normal_residue_4096,
            functions[i].variant_residue_4096
        };
        bool complete = true;
        for (size_t j = 0; j < BUSTER_RECEIPT_ARRAY_COUNT(keys); j += 1)
        {
            complete = complete && receipt_count(&json, keys[j], 2) && receipt_number(&json, keys[j], i, values[j]);
        }
        receipt_record(suite, i == 0 ? "linked-first-function-complete-geometry" : "linked-zero-size-second-function-and-max-address", complete, error);
    }
    receipt_record(suite, "linked-all-relocation-operands-complete", receipt_count(&json, "object_relocation", 2) && receipt_number(&json, "object_relocation", 0, 301) && receipt_number(&json, "offset", 0, 4001) && receipt_number(&json, "type", 0, 2) && receipt_number(&json, "width", 0, 4) && receipt_number(&json, "object_relocation", 1, 401) && receipt_number(&json, "offset", 1, 5001) && receipt_number(&json, "type", 1, 1) && receipt_number(&json, "width", 1, 8), error);
    bool explicit_requires = strstr((const char *)json.data, "separate full object relocation translation proof") != NULL && strstr((const char *)json.data, "pinned producer/linker and exact ordered link inputs") != NULL && strstr((const char *)json.data, "normal/zero full image SHA256 identity") != NULL && strstr((const char *)json.data, "per-image output preservation controls before timing") != NULL;
    receipt_record(suite, "linked-explicit-proof-limits-and-required-gates", receipt_limits(&json) && explicit_requires && receipt_count(&json, "scope", 1) && receipt_count(&json, "requires", 1), error);
    bool refused = !hp_receipt_linked(path, &proof, error);
    HpBuffer after = receipt_read(path);
    receipt_record(suite, "linked-existing-file-refused-and-preserved", refused && after.size == json.size && memcmp(after.data, json.data, json.size) == 0, error);
    hp_buffer_free(&after);
    hp_buffer_free(&json);
    receipt_path(suite, path, "linked-no-operands.json");
    proof.operand_count = 0;
    proof.operands = NULL;
    proof.masked_operand_bytes = 0;
    written = hp_receipt_linked(path, &proof, error);
    json = receipt_read(path);
    receipt_record(suite, "linked-empty-operand-vector", written && receipt_number(&json, "operand_count", 0, 0) && receipt_number(&json, "masked_operand_bytes", 0, 0) && receipt_count(&json, "object_relocation", 0), error);
    hp_buffer_free(&json);
    return;
}

static void receipt_identity_cases(ReceiptSuite *suite)
{
    char path[BUSTER_HP_PATH_CAPACITY];
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    receipt_path(suite, path, "identity proof.json");
    const char *image = "/private image/clang\"quote\\slash\n";
    const char *scope = "identity scope \"quoted\"\\\t";
    bool written = hp_receipt_identity(path, image, BUSTER_RECEIPT_DIGEST, scope, error);
    receipt_record(suite, "identity-exclusive-write", written, error);
    HpBuffer json = receipt_read(path);
    bool escaped = receipt_value(&json, "image", 0, "\"/private image/clang\\\"quote\\\\slash\\u000a\"") && receipt_value(&json, "scope", 0, "\"identity scope \\\"quoted\\\"\\\\\\u0009\"");
    receipt_record(suite, "identity-escaped-image-and-scope", escaped, error);
    receipt_record(suite, "identity-full-SHA-and-limits", receipt_envelope(&json) && receipt_value(&json, "sha256", 0, "\"" BUSTER_RECEIPT_DIGEST "\"") && receipt_value(&json, "kind", 0, "\"file SHA256 identity\"") && receipt_limits(&json), error);
    bool refused = !hp_receipt_identity(path, image, BUSTER_RECEIPT_DIGEST, scope, error);
    HpBuffer after = receipt_read(path);
    receipt_record(suite, "identity-existing-file-refused-and-preserved", refused && after.size == json.size && memcmp(after.data, json.data, json.size) == 0, error);
    hp_buffer_free(&after);
    hp_buffer_free(&json);
    char link[BUSTER_HP_PATH_CAPACITY];
    receipt_path(suite, link, "existing symlink.json");
    assert(symlink(path, link) == 0);
    receipt_record(suite, "receipt-existing-symlink-refused", !hp_receipt_identity(link, image, BUSTER_RECEIPT_DIGEST, scope, error), error);
    receipt_path(suite, path, "missing-parent/identity.json");
    receipt_record(suite, "receipt-missing-parent-refused", !hp_receipt_identity(path, image, BUSTER_RECEIPT_DIGEST, scope, error), error);
    return;
}

static void receipt_invalid_cases(ReceiptSuite *suite)
{
    HpDisclosure disclosures[3];
    HpObjectProof object = receipt_object_fixture(disclosures);
    HpLinkedFunction functions[2];
    HpLinkedOperand operands[2];
    HpLinkedProof linked = receipt_linked_fixture(functions, operands);
    char path[BUSTER_HP_PATH_CAPACITY];
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    struct stat state;
    receipt_path(suite, path, "invalid-no-create.json");
    bool refused = !hp_receipt_object(path, NULL, error);
    receipt_record(suite, "NULL-object-proof-rejected-before-create", refused && lstat(path, &state) != 0 && errno == ENOENT, error);
    refused = !hp_receipt_linked(path, NULL, error);
    receipt_record(suite, "NULL-linked-proof-rejected-before-create", refused && lstat(path, &state) != 0 && errno == ENOENT, error);
    object.disclosures = NULL;
    refused = !hp_receipt_object(path, &object, error);
    receipt_record(suite, "object-NULL-disclosure-array-rejected", refused && lstat(path, &state) != 0, error);
    object.disclosures = disclosures;
    disclosures[1].kind = (HpDisclosureKind)99;
    refused = !hp_receipt_object(path, &object, error);
    receipt_record(suite, "object-unknown-disclosure-kind-rejected", refused && lstat(path, &state) != 0, error);
    object.disclosure_count = SIZE_MAX;
    refused = !hp_receipt_object(path, &object, error);
    receipt_record(suite, "object-overflow-disclosure-count-rejected", refused && lstat(path, &state) != 0, error);
    linked.functions = NULL;
    refused = !hp_receipt_linked(path, &linked, error);
    receipt_record(suite, "linked-NULL-function-array-rejected", refused && lstat(path, &state) != 0, error);
    linked.functions = functions;
    linked.operands = NULL;
    refused = !hp_receipt_linked(path, &linked, error);
    receipt_record(suite, "linked-NULL-operand-array-rejected", refused && lstat(path, &state) != 0, error);
    linked.operands = operands;
    linked.function_count = SIZE_MAX;
    refused = !hp_receipt_linked(path, &linked, error);
    receipt_record(suite, "linked-overflow-function-count-rejected", refused && lstat(path, &state) != 0, error);
    linked.function_count = 2;
    linked.operand_count = SIZE_MAX;
    refused = !hp_receipt_linked(path, &linked, error);
    receipt_record(suite, "linked-overflow-operand-count-rejected", refused && lstat(path, &state) != 0, error);
    linked.operand_count = 2;
    functions[0].name.data = NULL;
    refused = !hp_receipt_linked(path, &linked, error);
    receipt_record(suite, "linked-NULL-nonempty-name-rejected", refused && lstat(path, &state) != 0, error);
    functions[0].name.data = "x";
    functions[0].name.size = SIZE_MAX;
    refused = !hp_receipt_linked(path, &linked, error);
    receipt_record(suite, "linked-overflow-name-slice-rejected", refused && lstat(path, &state) != 0, error);
    static const struct
    {
        const char *name;
        const char *image;
        const char *digest;
        const char *scope;
    } bad[] =
    {
        {
            "identity-NULL-image-rejected",
            NULL,
            BUSTER_RECEIPT_DIGEST,
            "scope"
        },
        {
            "identity-NULL-digest-rejected",
            "image",
            NULL,
            "scope"
        },
        {
            "identity-NULL-scope-rejected",
            "image",
            BUSTER_RECEIPT_DIGEST,
            NULL
        },
        {
            "identity-short-digest-rejected",
            "image",
            "1234",
            "scope"
        },
        {
            "identity-uppercase-digest-rejected",
            "image",
            "ABCDEF0123456789abcdef0123456789abcdef0123456789abcdef0123456789ab",
            "scope"
        },
        {
            "identity-empty-image-rejected",
            "",
            BUSTER_RECEIPT_DIGEST,
            "scope"
        },
        {
            "identity-empty-scope-rejected",
            "image",
            BUSTER_RECEIPT_DIGEST,
            ""
        }
    };
    for (size_t i = 0; i < BUSTER_RECEIPT_ARRAY_COUNT(bad); i += 1)
    {
        refused = !hp_receipt_identity(path, bad[i].image, bad[i].digest, bad[i].scope, error);
        receipt_record(suite, bad[i].name, refused && lstat(path, &state) != 0, error);
    }
    char huge[BUSTER_HP_PATH_CAPACITY + 1];
    memset(huge, 'x', sizeof(huge) - 1);
    huge[sizeof(huge) - 1] = 0;
    refused = !hp_receipt_identity(path, huge, BUSTER_RECEIPT_DIGEST, "scope", error);
    receipt_record(suite, "identity-overlong-image-rejected", refused && lstat(path, &state) != 0, error);
    refused = !hp_receipt_identity(path, "image", BUSTER_RECEIPT_DIGEST, huge, error);
    receipt_record(suite, "identity-overlong-scope-rejected", refused && lstat(path, &state) != 0, error);
    receipt_record(suite, "receipt-NULL-path-rejected", !hp_receipt_identity(NULL, "image", BUSTER_RECEIPT_DIGEST, "scope", error), error);
    return;
}

static void receipt_failed_write_cases(ReceiptSuite *suite)
{
    struct rlimit before;
    struct rlimit after;
    assert(getrlimit(RLIMIT_FSIZE, &before) == 0);
    for (size_t i = 0; i < 3; i += 1)
    {
        char path[BUSTER_HP_PATH_CAPACITY];
        receipt_path(suite, path, i == 0 ? "failed-object-write.json" : i == 1 ? "failed-linked-write.json" : "failed-identity-write.json");
        pid_t child = fork();
        assert(child >= 0);
        if (child == 0)
        {
            struct rlimit limited = before;
            limited.rlim_cur = i == 0 ? 0 : i == 1 ? 127 : 1;
            bool ready = signal(SIGXFSZ, SIG_IGN) != SIG_ERR && setrlimit(RLIMIT_FSIZE, &limited) == 0;
            char error[BUSTER_HP_ERROR_CAPACITY] = {0};
            HpDisclosure disclosures[3];
            HpObjectProof object = receipt_object_fixture(disclosures);
            HpLinkedFunction functions[2];
            HpLinkedOperand operands[2];
            HpLinkedProof linked = receipt_linked_fixture(functions, operands);
            bool written = ready && (i == 0 ? hp_receipt_object(path, &object, error) : i == 1 ? hp_receipt_linked(path, &linked, error) : hp_receipt_identity(path, "image", BUSTER_RECEIPT_DIGEST, "scope", error));
            struct stat state;
            bool retained = stat(path, &state) == 0 && (i == 0 ? state.st_size == 0 : state.st_size > 0 && (uint64_t)state.st_size <= limited.rlim_cur);
            _exit(ready && !written && error[0] != 0 && retained ? 0 : 31);
        }
        char error[BUSTER_HP_ERROR_CAPACITY] = {0};
        int code = -1;
        bool waited = hp_wait(child, &code, error);
        receipt_record(suite, i == 0 ? "object-real-write-flush-failure-retained" : i == 1 ? "linked-real-partial-write-failure-retained" : "identity-real-partial-write-failure-retained", waited && code == 0, error);
    }
    assert(getrlimit(RLIMIT_FSIZE, &after) == 0);
    receipt_record(suite, "failed-write-parent-file-limits-unchanged", before.rlim_cur == after.rlim_cur && before.rlim_max == after.rlim_max, "");
    return;
}

static bool receipt_results(ReceiptSuite *suite)
{
    char path[BUSTER_HP_PATH_CAPACITY];
    receipt_path(suite, path, "results.json");
    FILE *file = fopen(path, "wx");
    bool valid = file != NULL;
    if (valid)
    {
        fprintf(file, "{\n  \"kind\": \"fresh C proof receipt controls\",\n  \"cases\": %zu,\n  \"failures\": %zu,\n  \"results\": [\n", suite->count, suite->failures);
        for (size_t i = 0; i < suite->count; i += 1)
        {
            ReceiptResult *result = &suite->results[i];
            HpString name =
            {
                result->name,
                strlen(result->name)
            };
            fputs("    {\"name\": ", file);
            hp_json_string(file, name);
            fprintf(file, ", \"passed\": %s, \"error\": ", result->passed ? "true" : "false");
            HpString error =
            {
                result->error,
                strlen(result->error)
            };
            hp_json_string(file, error);
            fprintf(file, "}%s\n", i + 1 < suite->count ? "," : "");
        }
        fputs("  ]\n}\n", file);
        valid = ferror(file) == 0;
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

int main(int argc, char **argv)
{
    int status = 2;
    if (argc == 3 && strcmp(argv[1], "--output") == 0)
    {
        ReceiptSuite suite = {0};
        bool ready = mkdir(argv[2], 0700) == 0 && realpath(argv[2], suite.root) != NULL;
        if (ready)
        {
            receipt_object_cases(&suite);
            receipt_linked_cases(&suite);
            receipt_identity_cases(&suite);
            receipt_invalid_cases(&suite);
            receipt_failed_write_cases(&suite);
            bool written = receipt_results(&suite);
            printf("Synthetic C receipt controls: %zu cases, %zu failures; no producer or external executable invoked.\n", suite.count, suite.failures);
            status = suite.failures != 0 || !written ? 1 : 0;
        }
        else
        {
            perror("create fresh receipt-control output");
        }
    }
    else
    {
        fprintf(stderr, "usage: receipt-controls --output NEW_DIRECTORY\n");
    }
    return status;
}
