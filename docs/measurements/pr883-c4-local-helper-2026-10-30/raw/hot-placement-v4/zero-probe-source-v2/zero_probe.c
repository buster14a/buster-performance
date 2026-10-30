// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Development-only adapter for pinned baseline zero object/linked comparisons.
// File/private-copy/sealed-buffer routines are adapted from first-party
// object_probe.c and normalize_probe.c; proof serialization from hp_receipt.c.
// No mmap or executable mapping is used: ELF/image bytes are read into malloc.
// Inputs stay caller owned and are re-read after the pure-memory comparison.
// The common hash helper executes only /usr/bin/sha256sum. No producer, image,
// hp_method, assembler, linker or remote operation is invoked here. New JSON is
// exclusive; a refusal returns nonzero even when its diagnostic JSON is complete.
#define _GNU_SOURCE
#include "hp_common.h"
#include "hp_linked.h"

#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUSTER_HP_ZERO_OBJECT_SHA "b87831410140924f2cc5caed0ca0bcadc60d477900e309328dd652aa7b875039"
#define BUSTER_HP_ZERO_IMAGE_SHA "db8cbb4409be4ac4e0244c9aed773dcfcb733464d9022160365dc2f386dcb6ea"
#define BUSTER_HP_ZERO_INPUT_COUNT 4
#define BUSTER_HP_ZERO_PROBE_HOT ".text.buster_checker"
#define BUSTER_HP_ZERO_PROBE_ITEM_LIMIT ((size_t)1024 * 1024)

typedef struct HpZeroProbeInput HpZeroProbeInput;
struct HpZeroProbeInput
{
    const char *expected_sha;
    char requested_path[BUSTER_HP_PATH_CAPACITY];
    char path[BUSTER_HP_PATH_CAPACITY];
    char before_sha[65];
    char buffer_sha[65];
    char after_sha[65];
    char error[BUSTER_HP_ERROR_CAPACITY];
    struct stat before_metadata;
    struct stat after_metadata;
    HpBuffer buffer;
    bool before_metadata_read;
    bool before_hash_read;
    bool buffer_read;
    bool buffer_hash_read;
    bool read_valid;
    bool expected_digest;
    bool after_hash_read;
    bool after_buffer_read;
    bool after_metadata_read;
    bool hashes_unchanged;
    bool bytes_unchanged;
    bool metadata_unchanged;
    bool after_valid;
};

static bool zero_probe_path_argument(const char *path, char error[BUSTER_HP_ERROR_CAPACITY])
{
    size_t length = path != NULL ? strnlen(path, BUSTER_HP_PATH_CAPACITY) : 0;
    bool valid = length > 0 && length < BUSTER_HP_PATH_CAPACITY;
    for (size_t i = 0; valid && i < length; i += 1)
    {
        unsigned char byte = (unsigned char)path[i];
        valid = byte >= 32 && byte != 127;
    }
    if (!valid)
    {
        hp_error(error, "path argument is empty, oversized, or contains control bytes");
    }
    return valid;
}

static bool zero_probe_output_path(const char *path, char output[BUSTER_HP_PATH_CAPACITY], char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = zero_probe_path_argument(path, error);
    const char *slash = valid ? strrchr(path, '/') : NULL;
    const char *name = valid ? (slash != NULL ? slash + 1 : path) : "";
    valid = valid && name[0] != 0 && strcmp(name, ".") != 0 && strcmp(name, "..") != 0;
    char parent[BUSTER_HP_PATH_CAPACITY] = { 0 };
    if (valid)
    {
        size_t size = slash != NULL ? (size_t)(slash - path) : 1;
        if (slash == path)
        {
            size = 1;
        }
        memcpy(parent, slash != NULL ? path : ".", size);
    }
    char *canonical_parent = valid ? realpath(parent, NULL) : NULL;
    valid = valid && canonical_parent != NULL;
    if (valid)
    {
        const char *separator = strcmp(canonical_parent, "/") == 0 ? "" : "/";
        int size = snprintf(output, BUSTER_HP_PATH_CAPACITY, "%s%s%s", canonical_parent, separator, name);
        valid = size > 0 && size < BUSTER_HP_PATH_CAPACITY;
    }
    struct stat metadata = { 0 };
    if (valid)
    {
        errno = 0;
        int status = lstat(output, &metadata);
        valid = status < 0 && errno == ENOENT;
    }
    free(canonical_parent);
    if (!valid && error[0] == 0)
    {
        hp_error(error, "output parent/path is invalid or output already exists");
    }
    return valid;
}

static bool zero_probe_metadata_equal(const struct stat *left, const struct stat *right)
{
    bool valid = left->st_dev == right->st_dev && left->st_ino == right->st_ino && left->st_mode == right->st_mode && left->st_nlink == right->st_nlink && left->st_size == right->st_size;
    valid = valid && left->st_mtim.tv_sec == right->st_mtim.tv_sec && left->st_mtim.tv_nsec == right->st_mtim.tv_nsec && left->st_ctim.tv_sec == right->st_ctim.tv_sec && left->st_ctim.tv_nsec == right->st_ctim.tv_nsec;
    return valid;
}

static bool zero_probe_hash_buffer(HpBytes bytes, char digest[65], char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = bytes.size <= BUSTER_HP_FILE_LIMIT && (bytes.size == 0 || bytes.data != NULL);
    int descriptor = valid ? memfd_create("buster-object-comparison-copy", MFD_ALLOW_SEALING) : -1;
    valid = valid && descriptor >= 0;
    if (valid && descriptor < 3)
    {
        int promoted = fcntl(descriptor, F_DUPFD, 3);
        bool closed = close(descriptor) == 0;
        descriptor = promoted;
        valid = descriptor >= 0 && closed;
    }
    size_t used = 0;
    while (valid && used < bytes.size)
    {
        ssize_t size = write(descriptor, bytes.data + used, bytes.size - used);
        if (size < 0 && errno == EINTR)
        {
            continue;
        }
        valid = size > 0;
        if (valid)
        {
            used += (size_t)size;
        }
    }
    if (valid)
    {
        int seals = F_SEAL_WRITE | F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL;
        valid = fcntl(descriptor, F_ADD_SEALS, seals) == 0 && fcntl(descriptor, F_GET_SEALS) == seals;
    }
    char descriptor_path[64] = { 0 };
    if (valid)
    {
        int size = snprintf(descriptor_path, sizeof(descriptor_path), "/proc/self/fd/%d", descriptor);
        valid = size > 0 && (size_t)size < sizeof(descriptor_path);
    }
    if (valid)
    {
        valid = hp_sha256_file(descriptor_path, digest, error);
    }
    if (descriptor >= 0)
    {
        valid = close(descriptor) == 0 && valid;
    }
    if (!valid && error[0] == 0)
    {
        hp_error(error, "cannot hash exact object buffer through a sealed anonymous file");
    }
    return valid;
}

static bool zero_probe_input_read(const char *path, const char *expected_sha, HpZeroProbeInput *input)
{
    input->expected_sha = expected_sha;
    bool valid = zero_probe_path_argument(path, input->error);
    struct stat original = { 0 };
    if (valid)
    {
        memcpy(input->requested_path, path, strlen(path) + 1);
        valid = lstat(path, &original) == 0 && S_ISREG(original.st_mode) && original.st_nlink == 1;
    }
    char *canonical = valid ? realpath(path, NULL) : NULL;
    size_t size = canonical != NULL ? strnlen(canonical, BUSTER_HP_PATH_CAPACITY) : 0;
    valid = valid && size > 0 && size < BUSTER_HP_PATH_CAPACITY;
    if (valid)
    {
        memcpy(input->path, canonical, size + 1);
        input->before_metadata_read = lstat(input->path, &input->before_metadata) == 0;
        valid = input->before_metadata_read && zero_probe_metadata_equal(&original, &input->before_metadata);
    }
    free(canonical);
    if (valid)
    {
        input->before_hash_read = hp_sha256_file(input->path, input->before_sha, input->error);
        valid = input->before_hash_read;
    }
    if (valid)
    {
        input->buffer_read = hp_read_file(input->path, BUSTER_HP_FILE_LIMIT, &input->buffer, input->error);
        valid = input->buffer_read;
    }
    if (valid)
    {
        HpBytes bytes =
        {
            input->buffer.data,
            input->buffer.size
        };
        input->buffer_hash_read = zero_probe_hash_buffer(bytes, input->buffer_sha, input->error);
        valid = input->buffer_hash_read && strcmp(input->before_sha, input->buffer_sha) == 0;
    }
    input->read_valid = valid;
    input->expected_digest = valid && strcmp(input->buffer_sha, input->expected_sha) == 0;
    if (!valid && input->error[0] == 0)
    {
        hp_error(input->error, "input must be one private regular file with stable exact read/hash identity");
    }
    return valid;
}

static bool zero_probe_input_after(HpZeroProbeInput *input)
{
    HpBuffer after = { 0 };
    bool valid = input->read_valid;
    if (valid)
    {
        input->after_hash_read = hp_sha256_file(input->path, input->after_sha, input->error);
        input->after_buffer_read = hp_read_file(input->path, BUSTER_HP_FILE_LIMIT, &after, input->error);
        input->after_metadata_read = lstat(input->path, &input->after_metadata) == 0;
        input->hashes_unchanged = input->after_hash_read && strcmp(input->before_sha, input->after_sha) == 0 && strcmp(input->buffer_sha, input->after_sha) == 0;
        input->bytes_unchanged = input->after_buffer_read && after.size == input->buffer.size && (after.size == 0 || memcmp(after.data, input->buffer.data, after.size) == 0);
        input->metadata_unchanged = input->after_metadata_read && zero_probe_metadata_equal(&input->before_metadata, &input->after_metadata);
        valid = input->hashes_unchanged && input->bytes_unchanged && input->metadata_unchanged;
    }
    input->after_valid = valid;
    hp_buffer_free(&after);
    if (!valid && input->error[0] == 0)
    {
        hp_error(input->error, "object input copy changed or its post-comparison readback was unavailable");
    }
    return valid;
}

static void zero_probe_json_literal(FILE *file, const char *text)
{
    HpString value =
    {
        text,
        strlen(text)
    };
    hp_json_string(file, value);
    return;
}

static void zero_probe_json_nullable(FILE *file, const char *text, bool available)
{
    if (available)
    {
        zero_probe_json_literal(file, text);
    }
    else
    {
        fputs("null", file);
    }
    return;
}

static void zero_probe_json_metadata(FILE *file, const struct stat *metadata, bool available)
{
    if (available)
    {
        fprintf(file, "{\"device\": %ju, \"inode\": %ju, \"mode\": %ju, \"link_count\": %ju, \"size\": %jd, \"mtime_seconds\": %jd, \"mtime_nanoseconds\": %ld, \"ctime_seconds\": %jd, \"ctime_nanoseconds\": %ld}", (uintmax_t)metadata->st_dev, (uintmax_t)metadata->st_ino, (uintmax_t)metadata->st_mode, (uintmax_t)metadata->st_nlink, (intmax_t)metadata->st_size, (intmax_t)metadata->st_mtim.tv_sec, metadata->st_mtim.tv_nsec, (intmax_t)metadata->st_ctim.tv_sec, metadata->st_ctim.tv_nsec);
    }
    else
    {
        fputs("null", file);
    }
    return;
}

static void zero_probe_json_input(FILE *file, const HpZeroProbeInput *input)
{
    fputs("{\"expected_sha256\": ", file);
    zero_probe_json_literal(file, input->expected_sha);
    fputs(", \"requested_path\": ", file);
    zero_probe_json_nullable(file, input->requested_path, input->requested_path[0] != 0);
    fputs(", \"canonical_path\": ", file);
    zero_probe_json_nullable(file, input->path, input->path[0] != 0);
    fputs(", \"path_sha256_before\": ", file);
    zero_probe_json_nullable(file, input->before_sha, input->before_hash_read);
    fputs(", \"exact_sealed_buffer_sha256\": ", file);
    zero_probe_json_nullable(file, input->buffer_sha, input->buffer_hash_read);
    fputs(", \"path_sha256_after\": ", file);
    zero_probe_json_nullable(file, input->after_sha, input->after_hash_read);
    fputs(", \"metadata_before\": ", file);
    zero_probe_json_metadata(file, &input->before_metadata, input->before_metadata_read);
    fputs(", \"metadata_after\": ", file);
    zero_probe_json_metadata(file, &input->after_metadata, input->after_metadata_read);
    fprintf(file, ", \"buffer_bytes\": %zu, \"initial_read_valid\": %s, \"expected_digest\": %s, \"post_readback_available\": %s, \"hashes_unchanged\": %s, \"bytes_unchanged\": %s, \"metadata_unchanged\": %s, \"post_readback_valid\": %s, \"error\": ", input->buffer.size, input->read_valid ? "true" : "false", input->expected_digest ? "true" : "false", input->after_buffer_read ? "true" : "false", input->hashes_unchanged ? "true" : "false", input->bytes_unchanged ? "true" : "false", input->metadata_unchanged ? "true" : "false", input->after_valid ? "true" : "false");
    zero_probe_json_nullable(file, input->error, input->error[0] != 0);
    fputs("}", file);
    return;
}

static const char *zero_probe_disclosure(HpDisclosureKind kind)
{
    const char *text = NULL;
    switch (kind)
    {
        case BUSTER_HP_DISCLOSURE_COMMENT:
        {
            text = "nonalloc .comment producer bytes/presence differ";
        } break;
        case BUSTER_HP_DISCLOSURE_FILE_RECORDS:
        {
            text = "unreferenced STT_FILE producer records differ";
        } break;
        case BUSTER_HP_DISCLOSURE_NORMALIZED_ENCODING:
        {
            text = "normalized symbol/string/RELA encoding differs";
        } break;
    }
    return text;
}

static bool zero_probe_proof_valid(const HpObjectProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = proof->shift == 0 && proof->disclosure_count <= BUSTER_HP_ZERO_PROBE_ITEM_LIMIT && (proof->disclosure_count == 0 || proof->disclosures != NULL);
    for (size_t i = 0; valid && i < proof->disclosure_count; i += 1)
    {
        valid = zero_probe_disclosure(proof->disclosures[i].kind) != NULL;
    }
    if (!valid)
    {
        hp_error(error, "invalid zero-shift object proof receipt metadata");
    }
    return valid;
}

static void zero_probe_json_proof(FILE *file, const HpObjectProof *proof)
{
    fprintf(file, "{\"kind\": \"ET_REL full object structural comparison\", \"hot_section\": \"%s\", \"shift\": %" PRIu64 ", \"hot_bytes_before\": %" PRIu64 ", \"hot_alignment\": %" PRIu64 ", \"symbols_compared\": %zu, \"relocations_compared\": %zu, \"disclosure_count\": %zu, \"disclosed_nonsemantic_differences\": [", BUSTER_HP_ZERO_PROBE_HOT, proof->shift, proof->hot_bytes_before, proof->hot_alignment, proof->symbols_compared, proof->relocations_compared, proof->disclosure_count);
    for (size_t i = 0; i < proof->disclosure_count; i += 1)
    {
        const HpDisclosure *disclosure = &proof->disclosures[i];
        fprintf(file, "%s{\"kind\": %u, \"meaning\": ", i > 0 ? ", " : "", (unsigned)disclosure->kind);
        zero_probe_json_literal(file, zero_probe_disclosure(disclosure->kind));
        fputs(", \"section\": ", file);
        if (disclosure->section == SIZE_MAX)
        {
            fputs("null", file);
        }
        else
        {
            fprintf(file, "%zu", disclosure->section);
        }
        fputs("}", file);
    }
    fputs("]}", file);
    return;
}


typedef struct HpZeroProbeStage HpZeroProbeStage;
struct HpZeroProbeStage
{
    bool attempted;
    bool passed;
    char error[BUSTER_HP_ERROR_CAPACITY];
};

static bool zero_probe_linked_valid(const HpLinkedProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = proof->shift == 0 && proof->function_count <= BUSTER_HP_ZERO_PROBE_ITEM_LIMIT && proof->operand_count <= BUSTER_HP_ZERO_PROBE_ITEM_LIMIT && (proof->function_count == 0 || proof->functions != NULL) && (proof->operand_count == 0 || proof->operands != NULL);
    valid = valid && proof->normal_output_section.size <= BUSTER_HP_FILE_LIMIT && (proof->normal_output_section.size == 0 || proof->normal_output_section.data != NULL) && proof->variant_output_section.size <= BUSTER_HP_FILE_LIMIT && (proof->variant_output_section.size == 0 || proof->variant_output_section.data != NULL);
    for (size_t i = 0; valid && i < proof->function_count; i += 1)
    {
        valid = proof->functions[i].name.size <= BUSTER_HP_FILE_LIMIT && (proof->functions[i].name.size == 0 || proof->functions[i].name.data != NULL);
    }
    if (!valid)
    {
        hp_error(error, "invalid zero-shift linked proof receipt metadata");
    }
    return valid;
}

static void zero_probe_json_linked(FILE *file, const HpLinkedProof *proof)
{
    fprintf(file, "{\"kind\": \"object-qualified linked hot geometry and nonrelocation bytes\", \"shift\": %" PRIu64 ", \"hot_input_base\": %" PRIu64 ", \"hot_bytes\": %" PRIu64 ", \"hot_alignment\": %" PRIu64 ", \"normal_output_section\": ", proof->shift, proof->hot_input_base, proof->hot_bytes, proof->hot_alignment);
    hp_json_string(file, proof->normal_output_section);
    fputs(", \"variant_output_section\": ", file);
    hp_json_string(file, proof->variant_output_section);
    fprintf(file, ", \"function_count\": %zu, \"functions\": [\n", proof->function_count);
    for (size_t i = 0; i < proof->function_count; i += 1)
    {
        const HpLinkedFunction *function = &proof->functions[i];
        fputs("    {\"name\": ", file);
        hp_json_string(file, function->name);
        fprintf(file, ", \"object_symbol\": %zu, \"object_offset\": %" PRIu64 ", \"size\": %" PRIu64 ", \"normal_address\": %" PRIu64 ", \"variant_address\": %" PRIu64 ", \"delta\": %" PRIu64 ", \"normal_residue_4096\": %" PRIu64 ", \"variant_residue_4096\": %" PRIu64 "}%s\n", function->object_symbol, function->object_offset, function->size, function->normal_address, function->variant_address, function->delta, function->normal_residue_4096, function->variant_residue_4096, i + 1 < proof->function_count ? "," : "");
    }
    fprintf(file, "  ], \"operand_count\": %zu, \"masked_operand_bytes\": %" PRIu64 ", \"masked_relocation_operands\": [\n", proof->operand_count, proof->masked_operand_bytes);
    for (size_t i = 0; i < proof->operand_count; i += 1)
    {
        const HpLinkedOperand *operand = &proof->operands[i];
        fprintf(file, "    {\"object_relocation\": %zu, \"offset\": %" PRIu64 ", \"type\": %" PRIu32 ", \"width\": %u}%s\n", operand->object_relocation, operand->offset, operand->type, operand->width, i + 1 < proof->operand_count ? "," : "");
    }
    fputs("  ]}", file);
    return;
}

static void zero_probe_json_stage(FILE *file, const HpZeroProbeStage *stage)
{
    fprintf(file, "{\"attempted\": %s, \"passed\": %s, \"status\": ", stage->attempted ? "true" : "false", stage->passed ? "true" : "false");
    zero_probe_json_literal(file, !stage->attempted ? "unreached" : stage->passed ? "passed" : "refused");
    fputs(", \"refusal\": ", file);
    zero_probe_json_nullable(file, stage->error, stage->error[0] != 0);
    fputs("}", file);
    return;
}

static bool zero_probe_json(bool accepted, bool distinct, bool preserved, const HpZeroProbeInput inputs[BUSTER_HP_ZERO_INPUT_COUNT], const HpZeroProbeStage elf_stages[BUSTER_HP_ZERO_INPUT_COUNT], const HpZeroProbeStage *object_stage, const HpZeroProbeStage *linked_stage, const HpObjectProof *object_proof, const HpLinkedProof *linked_proof, const char *refusal, HpBuffer *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    static const char *names[BUSTER_HP_ZERO_INPUT_COUNT] =
    {
        "direct_object",
        "zero_object",
        "direct_image",
        "zero_image"
    };
    char *text = NULL;
    size_t size = 0;
    FILE *file = open_memstream(&text, &size);
    bool valid = file != NULL;
    if (valid)
    {
        fprintf(file, "{\n  \"schema\": \"buster-hot-zero-development-file-probe-v1\",\n  \"development_only\": true,\n  \"passed\": %s,\n  \"hardcoded_shift\": 0,\n  \"baseline_fragment_required_count\": 0,\n  \"builtin_required_functions\": [\"check_program_emit\", \"check_lower_drain\", \"check_lower_batch_classify\"],\n  \"distinct_private_input_files\": %s,\n  \"all_inputs_preserved\": %s,\n  \"inputs\": {\n", accepted ? "true" : "false", distinct ? "true" : "false", preserved ? "true" : "false");
        for (size_t i = 0; i < BUSTER_HP_ZERO_INPUT_COUNT; i += 1)
        {
            fprintf(file, "    \"%s\": ", names[i]);
            zero_probe_json_input(file, &inputs[i]);
            fprintf(file, "%s\n", i + 1 < BUSTER_HP_ZERO_INPUT_COUNT ? "," : "");
        }
        fputs("  },\n  \"stages\": {\n", file);
        for (size_t i = 0; i < BUSTER_HP_ZERO_INPUT_COUNT; i += 1)
        {
            fprintf(file, "    \"read_%s_elf\": ", names[i]);
            zero_probe_json_stage(file, &elf_stages[i]);
            fputs(",\n", file);
        }
        fputs("    \"object_comparison\": ", file);
        zero_probe_json_stage(file, object_stage);
        fputs(",\n    \"linked_comparison\": ", file);
        zero_probe_json_stage(file, linked_stage);
        fputs("\n  },\n  \"object_proof\": ", file);
        if (preserved && object_stage->passed)
        {
            zero_probe_json_proof(file, object_proof);
        }
        else
        {
            fputs("null", file);
        }
        fputs(",\n  \"linked_proof\": ", file);
        if (preserved && linked_stage->passed)
        {
            zero_probe_json_linked(file, linked_proof);
        }
        else
        {
            fputs("null", file);
        }
        fputs(",\n  \"refusal\": ", file);
        zero_probe_json_nullable(file, refusal, !accepted);
        fputs(",\n  \"scope\": \"development-only baseline zero-shift full object and section-header linked comparisons on four pinned private copies; proof records withheld if any input preservation check fails\",\n  \"limits\": {\"controller_objects_operation_complete\": false, \"source_tool_and_ordered_link_provenance_validated\": false, \"pt_load_validated\": false, \"numeric_resolved_operands_validated\": false, \"runtime_semantics_validated\": false, \"performance_measured\": false}\n}\n", file);
        bool flushed = fflush(file) == 0;
        bool written = ferror(file) == 0;
        bool closed = fclose(file) == 0;
        valid = flushed && written && closed && size <= BUSTER_HP_FILE_LIMIT;
    }
    if (valid)
    {
        output->data = (unsigned char *)text;
        output->size = size;
    }
    else
    {
        free(text);
        hp_error(error, "cannot serialize bounded development zero-comparison JSON");
    }
    return valid;
}
static bool zero_probe_write(const char *path, const HpBuffer *receipt, char digest[65], char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBytes bytes =
    {
        receipt->data,
        receipt->size
    };
    HpBuffer readback = { 0 };
    char file_digest[65] = { 0 };
    bool valid = zero_probe_hash_buffer(bytes, digest, error) && hp_write_file(path, bytes, error) && hp_sha256_file(path, file_digest, error) && hp_read_file(path, BUSTER_HP_FILE_LIMIT, &readback, error);
    valid = valid && strcmp(digest, file_digest) == 0 && readback.size == receipt->size && (readback.size == 0 || memcmp(readback.data, receipt->data, readback.size) == 0);
    hp_buffer_free(&readback);
    if (!valid && error[0] == 0)
    {
        hp_error(error, "exclusive zero comparison JSON write/readback identity failed");
    }
    return valid;
}

int main(int argc, char **argv)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    char write_error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    char output_path[BUSTER_HP_PATH_CAPACITY] = { 0 };
    char output_sha[65] = { 0 };
    HpZeroProbeInput inputs[BUSTER_HP_ZERO_INPUT_COUNT] = { 0 };
    HpElf elfs[BUSTER_HP_ZERO_INPUT_COUNT] = { 0 };
    HpZeroProbeStage elf_stages[BUSTER_HP_ZERO_INPUT_COUNT] = { 0 };
    HpZeroProbeStage object_stage = { 0 };
    HpZeroProbeStage linked_stage = { 0 };
    HpObjectProof object_proof = { 0 };
    HpLinkedProof linked_proof = { 0 };
    HpBuffer receipt = { 0 };
    bool output_valid = argc == 6;
    bool accepted = false;
    bool distinct = true;
    bool preserved = true;
    bool written = false;
    if (output_valid)
    {
        output_valid = zero_probe_output_path(argv[5], output_path, error);
    }
    else
    {
        hp_error(error, "usage: zero_probe NEW_DIRECT_OBJECT_COPY NEW_ZERO_OBJECT_COPY NEW_DIRECT_IMAGE_COPY NEW_ZERO_IMAGE_COPY NEW_JSON_OUTPUT");
    }
    if (output_valid)
    {
        bool prepared = true;
        for (size_t i = 0; i < BUSTER_HP_ZERO_INPUT_COUNT; i += 1)
        {
            const char *expected = i < 2 ? BUSTER_HP_ZERO_OBJECT_SHA : BUSTER_HP_ZERO_IMAGE_SHA;
            bool read = zero_probe_input_read(argv[i + 1], expected, &inputs[i]);
            prepared = read && inputs[i].expected_digest && prepared;
            for (size_t j = 0; j < i; j += 1)
            {
                bool separate = inputs[i].before_metadata_read && inputs[j].before_metadata_read && (inputs[i].before_metadata.st_dev != inputs[j].before_metadata.st_dev || inputs[i].before_metadata.st_ino != inputs[j].before_metadata.st_ino);
                distinct = separate && distinct;
            }
        }
        prepared = prepared && distinct;
        if (prepared)
        {
            for (size_t i = 0; i < BUSTER_HP_ZERO_INPUT_COUNT; i += 1)
            {
                HpBytes bytes =
                {
                    inputs[i].buffer.data,
                    inputs[i].buffer.size
                };
                elf_stages[i].attempted = true;
                elf_stages[i].passed = hp_elf_read(bytes, &elfs[i], elf_stages[i].error);
                prepared = elf_stages[i].passed && prepared;
            }
        }
        if (prepared)
        {
            object_stage.attempted = true;
            object_stage.passed = hp_elf_compare_objects(&elfs[0], &elfs[1], BUSTER_HP_ZERO_PROBE_HOT, 0, &object_proof, object_stage.error) && zero_probe_proof_valid(&object_proof, object_stage.error);
        }
        if (object_stage.passed)
        {
            linked_stage.attempted = true;
            linked_stage.passed = hp_linked_compare(&elfs[0], &elfs[2], &elfs[3], 0, NULL, 0, &linked_proof, linked_stage.error) && zero_probe_linked_valid(&linked_proof, linked_stage.error);
        }
        for (size_t i = 0; i < BUSTER_HP_ZERO_INPUT_COUNT; i += 1)
        {
            bool after = zero_probe_input_after(&inputs[i]);
            preserved = after && preserved;
            if (error[0] == 0 && (!inputs[i].read_valid || !after))
            {
                hp_error(error, "input%zu: %s", i, inputs[i].error);
            }
            if (error[0] == 0 && !inputs[i].expected_digest)
            {
                hp_error(error, "input%zu does not match its hardcoded expected SHA256", i);
            }
            if (error[0] == 0 && elf_stages[i].attempted && !elf_stages[i].passed)
            {
                hp_error(error, "ELF input%zu: %s", i, elf_stages[i].error);
            }
        }
        accepted = distinct && preserved && object_stage.passed && linked_stage.passed;
        if (!accepted && error[0] == 0)
        {
            const char *reason = !distinct ? "four distinct private input copies are required" : object_stage.attempted && !object_stage.passed ? object_stage.error : linked_stage.attempted && !linked_stage.passed ? linked_stage.error : "prerequisite refused; later comparison stages unreached";
            hp_error(error, "%s", reason[0] != 0 ? reason : "zero-comparison refused");
        }
        bool serialized = zero_probe_json(accepted, distinct, preserved, inputs, elf_stages, &object_stage, &linked_stage, &object_proof, &linked_proof, error, &receipt, write_error);
        written = serialized && zero_probe_write(output_path, &receipt, output_sha, write_error);
    }
    hp_buffer_free(&receipt);
    hp_linked_proof_free(&linked_proof);
    hp_object_proof_free(&object_proof);
    for (size_t i = 0; i < BUSTER_HP_ZERO_INPUT_COUNT; i += 1)
    {
        hp_elf_free(&elfs[i]);
        hp_buffer_free(&inputs[i].buffer);
    }
    if (written)
    {
        fprintf(stdout, "development zero comparison=%s; JSON_sha256=%s; exclusive output readback verified; no controller/producer/image/runtime/performance execution\n", accepted ? "passed" : "refused", output_sha);
    }
    if (!accepted || !written)
    {
        fprintf(stderr, "development zero probe refused/failed: %s%s%s\n", error[0] != 0 ? error : "no accepted comparison", write_error[0] != 0 ? "; " : "", write_error);
    }
    return accepted && written ? 0 : 1;
}
