// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Development-only adapter for one pinned, zero-shift object comparison. File,
// private-copy and sealed-buffer hash routines are adapted from first-party
// normalize_probe.c; proof serialization is adapted from hp_receipt.c. Inputs
// stay caller owned and are re-read after the pure-memory comparison. Only
// /usr/bin/sha256sum is executed by the common hash helper: no producer, image,
// hp_method, assembler, linker or remote operation is invoked here. New JSON is
// exclusive; a refusal returns nonzero even when its diagnostic JSON is complete.
#define _GNU_SOURCE
#include "hp_common.h"

#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUSTER_HP_OBJECT_PROBE_SHA "b87831410140924f2cc5caed0ca0bcadc60d477900e309328dd652aa7b875039"
#define BUSTER_HP_OBJECT_PROBE_HOT ".text.buster_checker"
#define BUSTER_HP_OBJECT_PROBE_DISCLOSURE_LIMIT ((size_t)1024 * 1024)

typedef struct HpObjectProbeInput HpObjectProbeInput;
struct HpObjectProbeInput
{
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

static bool object_probe_path_argument(const char *path, char error[BUSTER_HP_ERROR_CAPACITY])
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

static bool object_probe_output_path(const char *path, char output[BUSTER_HP_PATH_CAPACITY], char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = object_probe_path_argument(path, error);
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

static bool object_probe_metadata_equal(const struct stat *left, const struct stat *right)
{
    bool valid = left->st_dev == right->st_dev && left->st_ino == right->st_ino && left->st_mode == right->st_mode && left->st_nlink == right->st_nlink && left->st_size == right->st_size;
    valid = valid && left->st_mtim.tv_sec == right->st_mtim.tv_sec && left->st_mtim.tv_nsec == right->st_mtim.tv_nsec && left->st_ctim.tv_sec == right->st_ctim.tv_sec && left->st_ctim.tv_nsec == right->st_ctim.tv_nsec;
    return valid;
}

static bool object_probe_hash_buffer(HpBytes bytes, char digest[65], char error[BUSTER_HP_ERROR_CAPACITY])
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

static bool object_probe_input_read(const char *path, HpObjectProbeInput *input)
{
    bool valid = object_probe_path_argument(path, input->error);
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
        valid = input->before_metadata_read && object_probe_metadata_equal(&original, &input->before_metadata);
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
        input->buffer_hash_read = object_probe_hash_buffer(bytes, input->buffer_sha, input->error);
        valid = input->buffer_hash_read && strcmp(input->before_sha, input->buffer_sha) == 0;
    }
    input->read_valid = valid;
    input->expected_digest = valid && strcmp(input->buffer_sha, BUSTER_HP_OBJECT_PROBE_SHA) == 0;
    if (!valid && input->error[0] == 0)
    {
        hp_error(input->error, "input must be one private regular file with stable exact read/hash identity");
    }
    return valid;
}

static bool object_probe_input_after(HpObjectProbeInput *input)
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
        input->metadata_unchanged = input->after_metadata_read && object_probe_metadata_equal(&input->before_metadata, &input->after_metadata);
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

static void object_probe_json_literal(FILE *file, const char *text)
{
    HpString value =
    {
        text,
        strlen(text)
    };
    hp_json_string(file, value);
    return;
}

static void object_probe_json_nullable(FILE *file, const char *text, bool available)
{
    if (available)
    {
        object_probe_json_literal(file, text);
    }
    else
    {
        fputs("null", file);
    }
    return;
}

static void object_probe_json_metadata(FILE *file, const struct stat *metadata, bool available)
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

static void object_probe_json_input(FILE *file, const HpObjectProbeInput *input)
{
    fputs("{\"requested_path\": ", file);
    object_probe_json_nullable(file, input->requested_path, input->requested_path[0] != 0);
    fputs(", \"canonical_path\": ", file);
    object_probe_json_nullable(file, input->path, input->path[0] != 0);
    fputs(", \"path_sha256_before\": ", file);
    object_probe_json_nullable(file, input->before_sha, input->before_hash_read);
    fputs(", \"exact_sealed_buffer_sha256\": ", file);
    object_probe_json_nullable(file, input->buffer_sha, input->buffer_hash_read);
    fputs(", \"path_sha256_after\": ", file);
    object_probe_json_nullable(file, input->after_sha, input->after_hash_read);
    fputs(", \"metadata_before\": ", file);
    object_probe_json_metadata(file, &input->before_metadata, input->before_metadata_read);
    fputs(", \"metadata_after\": ", file);
    object_probe_json_metadata(file, &input->after_metadata, input->after_metadata_read);
    fprintf(file, ", \"buffer_bytes\": %zu, \"initial_read_valid\": %s, \"expected_digest\": %s, \"post_readback_available\": %s, \"hashes_unchanged\": %s, \"bytes_unchanged\": %s, \"metadata_unchanged\": %s, \"post_readback_valid\": %s, \"error\": ", input->buffer.size, input->read_valid ? "true" : "false", input->expected_digest ? "true" : "false", input->after_buffer_read ? "true" : "false", input->hashes_unchanged ? "true" : "false", input->bytes_unchanged ? "true" : "false", input->metadata_unchanged ? "true" : "false", input->after_valid ? "true" : "false");
    object_probe_json_nullable(file, input->error, input->error[0] != 0);
    fputs("}", file);
    return;
}

static const char *object_probe_disclosure(HpDisclosureKind kind)
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

static bool object_probe_proof_valid(const HpObjectProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = proof->shift == 0 && proof->disclosure_count <= BUSTER_HP_OBJECT_PROBE_DISCLOSURE_LIMIT && (proof->disclosure_count == 0 || proof->disclosures != NULL);
    for (size_t i = 0; valid && i < proof->disclosure_count; i += 1)
    {
        valid = object_probe_disclosure(proof->disclosures[i].kind) != NULL;
    }
    if (!valid)
    {
        hp_error(error, "invalid zero-shift object proof receipt metadata");
    }
    return valid;
}

static void object_probe_json_proof(FILE *file, const HpObjectProof *proof)
{
    fprintf(file, "{\"kind\": \"ET_REL full object structural comparison\", \"hot_section\": \"%s\", \"shift\": %" PRIu64 ", \"hot_bytes_before\": %" PRIu64 ", \"hot_alignment\": %" PRIu64 ", \"symbols_compared\": %zu, \"relocations_compared\": %zu, \"disclosure_count\": %zu, \"disclosed_nonsemantic_differences\": [", BUSTER_HP_OBJECT_PROBE_HOT, proof->shift, proof->hot_bytes_before, proof->hot_alignment, proof->symbols_compared, proof->relocations_compared, proof->disclosure_count);
    for (size_t i = 0; i < proof->disclosure_count; i += 1)
    {
        const HpDisclosure *disclosure = &proof->disclosures[i];
        fprintf(file, "%s{\"kind\": %u, \"meaning\": ", i > 0 ? ", " : "", (unsigned)disclosure->kind);
        object_probe_json_literal(file, object_probe_disclosure(disclosure->kind));
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

static bool object_probe_json(bool accepted, bool compared, bool distinct, const HpObjectProbeInput *left, const HpObjectProbeInput *right, const HpObjectProof *proof, const char *refusal, HpBuffer *output, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char *text = NULL;
    size_t size = 0;
    FILE *file = open_memstream(&text, &size);
    bool valid = file != NULL;
    if (valid)
    {
        fprintf(file, "{\n  \"schema\": \"buster-hot-object-development-file-probe-v1\",\n  \"development_only\": true,\n  \"passed\": %s,\n  \"comparison_attempted\": %s,\n  \"distinct_private_input_files\": %s,\n  \"expected_input_sha256\": \"%s\",\n  \"hardcoded_shift\": 0,\n  \"left_object_copy\": ", accepted ? "true" : "false", compared ? "true" : "false", distinct ? "true" : "false", BUSTER_HP_OBJECT_PROBE_SHA);
        object_probe_json_input(file, left);
        fputs(",\n  \"right_object_copy\": ", file);
        object_probe_json_input(file, right);
        fputs(",\n  \"object_proof\": ", file);
        if (accepted)
        {
            object_probe_json_proof(file, proof);
        }
        else
        {
            fputs("null", file);
        }
        fputs(",\n  \"refusal\": ", file);
        object_probe_json_nullable(file, refusal, !accepted);
        fputs(",\n  \"scope\": \"development-only full object comparison of two pinned private object copies at shift0; no controller operation or producer/image execution\",\n  \"limits\": {\"linked_geometry_proved\": false, \"normal_zero_image_identity_proved\": false, \"pt_load_validated\": false, \"numeric_resolved_operands_validated\": false, \"runtime_semantics_validated\": false, \"performance_measured\": false}\n}\n", file);
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
        hp_error(error, "cannot serialize bounded development object comparison JSON");
    }
    return valid;
}

static bool object_probe_write(const char *path, const HpBuffer *receipt, char digest[65], char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBytes bytes =
    {
        receipt->data,
        receipt->size
    };
    HpBuffer readback = { 0 };
    char file_digest[65] = { 0 };
    bool valid = object_probe_hash_buffer(bytes, digest, error) && hp_write_file(path, bytes, error) && hp_sha256_file(path, file_digest, error) && hp_read_file(path, BUSTER_HP_FILE_LIMIT, &readback, error);
    valid = valid && strcmp(digest, file_digest) == 0 && readback.size == receipt->size && (readback.size == 0 || memcmp(readback.data, receipt->data, readback.size) == 0);
    hp_buffer_free(&readback);
    if (!valid && error[0] == 0)
    {
        hp_error(error, "exclusive object comparison JSON write/readback identity failed");
    }
    return valid;
}

int main(int argc, char **argv)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    char write_error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    char output_path[BUSTER_HP_PATH_CAPACITY] = { 0 };
    char output_sha[65] = { 0 };
    HpObjectProbeInput left = { 0 };
    HpObjectProbeInput right = { 0 };
    HpElf left_elf = { 0 };
    HpElf right_elf = { 0 };
    HpObjectProof proof = { 0 };
    HpBuffer receipt = { 0 };
    bool output_valid = argc == 4;
    bool compared = false;
    bool accepted = false;
    bool distinct = false;
    bool written = false;
    if (output_valid)
    {
        output_valid = object_probe_output_path(argv[3], output_path, error);
    }
    else
    {
        hp_error(error, "usage: object_probe NEW_LEFT_OBJECT_COPY NEW_RIGHT_OBJECT_COPY NEW_JSON_OUTPUT");
    }
    if (output_valid)
    {
        bool left_read = object_probe_input_read(argv[1], &left);
        bool right_read = object_probe_input_read(argv[2], &right);
        distinct = left_read && right_read && (left.before_metadata.st_dev != right.before_metadata.st_dev || left.before_metadata.st_ino != right.before_metadata.st_ino);
        bool prepared = left_read && right_read && distinct && left.expected_digest && right.expected_digest;
        if (prepared)
        {
            HpBytes left_bytes =
            {
                left.buffer.data,
                left.buffer.size
            };
            HpBytes right_bytes =
            {
                right.buffer.data,
                right.buffer.size
            };
            prepared = hp_elf_read(left_bytes, &left_elf, error) && hp_elf_read(right_bytes, &right_elf, error);
        }
        if (prepared)
        {
            compared = true;
            accepted = hp_elf_compare_objects(&left_elf, &right_elf, BUSTER_HP_OBJECT_PROBE_HOT, 0, &proof, error) && object_probe_proof_valid(&proof, error);
        }
        bool left_after = left_read && object_probe_input_after(&left);
        bool right_after = right_read && object_probe_input_after(&right);
        accepted = accepted && left_after && right_after;
        if (!accepted && error[0] == 0)
        {
            const char *reason = !left_read || !left_after ? left.error : !right_read || !right_after ? right.error : !distinct ? "two distinct private input copies are required" : !left.expected_digest || !right.expected_digest ? "both object copies must match the hardcoded expected SHA256" : "object comparison refused";
            hp_error(error, "%s", reason[0] != 0 ? reason : "object input identity or comparison refused");
        }
        bool serialized = object_probe_json(accepted, compared, distinct, &left, &right, &proof, error, &receipt, write_error);
        written = serialized && object_probe_write(output_path, &receipt, output_sha, write_error);
    }
    hp_buffer_free(&receipt);
    hp_object_proof_free(&proof);
    hp_elf_free(&right_elf);
    hp_elf_free(&left_elf);
    hp_buffer_free(&right.buffer);
    hp_buffer_free(&left.buffer);
    if (written)
    {
        fprintf(stdout, "development object comparison=%s; JSON_sha256=%s; exclusive output readback verified; no controller/producer/image/runtime/performance execution\n", accepted ? "passed" : "refused", output_sha);
    }
    if (!accepted || !written)
    {
        fprintf(stderr, "development object probe refused/failed: %s%s%s\n", error[0] != 0 ? error : "no accepted comparison", write_error[0] != 0 ? "; " : "", write_error);
    }
    return accepted && written ? 0 : 1;
}
