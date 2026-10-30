// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Development-only file adapter for the pure-memory normalization guard. Inputs
// are private copies supplied by the caller. Exact buffers are hashed through
// sealed memfds; input paths are independently checked before and after use.
// This adapter never assembles, links, executes an image, or invokes hp_method.
// New outputs are exclusive, and failed/partial evidence is retained on error.
#define _GNU_SOURCE
#include "hp_normalize.h"

#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct HpProbeInput HpProbeInput;
struct HpProbeInput
{
    char path[BUSTER_HP_PATH_CAPACITY];
    char before_sha[65];
    char buffer_sha[65];
    char after_sha[65];
    struct stat before_metadata;
    struct stat after_metadata;
    HpBuffer buffer;
};

static bool hp_probe_path_argument(const char *path, char error[BUSTER_HP_ERROR_CAPACITY])
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

static bool hp_probe_output_path(const char *path, char output[BUSTER_HP_PATH_CAPACITY], char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = hp_probe_path_argument(path, error);
    const char *slash = valid ? strrchr(path, '/') : NULL;
    const char *name = valid ? (slash != NULL ? slash + 1 : path) : "";
    valid = valid && name[0] != 0 && strcmp(name, ".") != 0 && strcmp(name, "..") != 0;
    char parent[BUSTER_HP_PATH_CAPACITY] = { 0 };
    if (valid)
    {
        size_t parent_size = slash != NULL ? (size_t)(slash - path) : 1;
        if (slash == path)
        {
            parent_size = 1;
        }
        memcpy(parent, slash != NULL ? path : ".", parent_size);
    }
    char *canonical_parent = valid ? realpath(parent, NULL) : NULL;
    valid = valid && canonical_parent != NULL;
    if (valid)
    {
        const char *separator = strcmp(canonical_parent, "/") == 0 ? "" : "/";
        int length = snprintf(output, BUSTER_HP_PATH_CAPACITY, "%s%s%s", canonical_parent, separator, name);
        valid = length > 0 && length < BUSTER_HP_PATH_CAPACITY;
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

static bool hp_probe_metadata_equal(const struct stat *left, const struct stat *right)
{
    bool valid = left->st_dev == right->st_dev && left->st_ino == right->st_ino && left->st_mode == right->st_mode && left->st_nlink == right->st_nlink && left->st_size == right->st_size;
    valid = valid && left->st_mtim.tv_sec == right->st_mtim.tv_sec && left->st_mtim.tv_nsec == right->st_mtim.tv_nsec && left->st_ctim.tv_sec == right->st_ctim.tv_sec && left->st_ctim.tv_nsec == right->st_ctim.tv_nsec;
    return valid;
}

// A sealed anonymous file gives sha256sum the exact immutable memory preimage,
// independently of path replacement or writes to the caller's input copies.
static bool hp_probe_hash_buffer(HpBytes bytes, char digest[65], char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = bytes.size <= BUSTER_HP_FILE_LIMIT && (bytes.size == 0 || bytes.data != NULL);
    int descriptor = valid ? memfd_create("buster-normalization-copy", MFD_ALLOW_SEALING) : -1;
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
        ssize_t count = write(descriptor, bytes.data + used, bytes.size - used);
        if (count < 0 && errno == EINTR)
        {
            continue;
        }
        valid = count > 0;
        if (valid)
        {
            used += (size_t)count;
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
        int length = snprintf(descriptor_path, sizeof(descriptor_path), "/proc/self/fd/%d", descriptor);
        valid = length > 0 && (size_t)length < sizeof(descriptor_path);
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
        hp_error(error, "cannot hash exact normalization buffer through a sealed anonymous file");
    }
    return valid;
}

static bool hp_probe_input_read(const char *path, HpProbeInput *input, char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool valid = hp_probe_path_argument(path, error);
    struct stat original = { 0 };
    valid = valid && lstat(path, &original) == 0 && S_ISREG(original.st_mode) && original.st_nlink == 1;
    char *canonical = valid ? realpath(path, NULL) : NULL;
    size_t length = canonical != NULL ? strnlen(canonical, BUSTER_HP_PATH_CAPACITY) : 0;
    valid = valid && length > 0 && length < BUSTER_HP_PATH_CAPACITY;
    if (valid)
    {
        memcpy(input->path, canonical, length + 1);
        valid = lstat(input->path, &input->before_metadata) == 0 && hp_probe_metadata_equal(&original, &input->before_metadata);
    }
    free(canonical);
    if (valid)
    {
        valid = hp_sha256_file(input->path, input->before_sha, error) && hp_read_file(input->path, BUSTER_HP_FILE_LIMIT, &input->buffer, error);
    }
    if (valid)
    {
        HpBytes bytes =
        {
            input->buffer.data,
            input->buffer.size
        };
        valid = hp_probe_hash_buffer(bytes, input->buffer_sha, error) && strcmp(input->before_sha, input->buffer_sha) == 0;
    }
    if (!valid && error[0] == 0)
    {
        hp_error(error, "input must be one private regular file with stable exact read/hash identity");
    }
    return valid;
}

static bool hp_probe_input_after(HpProbeInput *input, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer after = { 0 };
    bool valid = hp_sha256_file(input->path, input->after_sha, error) && hp_read_file(input->path, BUSTER_HP_FILE_LIMIT, &after, error);
    valid = valid && strcmp(input->before_sha, input->after_sha) == 0 && after.size == input->buffer.size && memcmp(after.data, input->buffer.data, after.size) == 0;
    valid = valid && lstat(input->path, &input->after_metadata) == 0 && hp_probe_metadata_equal(&input->before_metadata, &input->after_metadata);
    hp_buffer_free(&after);
    if (!valid && error[0] == 0)
    {
        hp_error(error, "normalization input copy changed during the development check");
    }
    return valid;
}

static void hp_probe_json_literal(FILE *file, const char *text)
{
    HpString value =
    {
        text,
        strlen(text)
    };
    hp_json_string(file, value);
    return;
}

static void hp_probe_json_input(FILE *file, const HpProbeInput *input)
{
    fputs("{\"path\": ", file);
    hp_probe_json_literal(file, input->path);
    fprintf(file, ", \"bytes\": %zu, \"device\": %ju, \"inode\": %ju, \"path_sha256_before\": ", input->buffer.size, (uintmax_t)input->before_metadata.st_dev, (uintmax_t)input->before_metadata.st_ino);
    hp_probe_json_literal(file, input->before_sha);
    fputs(", \"exact_buffer_sha256\": ", file);
    hp_probe_json_literal(file, input->buffer_sha);
    fputs(", \"path_sha256_after\": ", file);
    hp_probe_json_literal(file, input->after_sha);
    fputs(", \"bytes_unchanged\": true, \"metadata_unchanged\": true}", file);
    return;
}

static bool hp_probe_receipt(const char *path, const char *canonical_path, const HpProbeInput *raw, const HpProbeInput *object, const HpBuffer *canonical, const char canonical_sha[65], const HpNormalizationProof *proof, char error[BUSTER_HP_ERROR_CAPACITY])
{
    int descriptor = open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600);
    FILE *file = descriptor >= 0 ? fdopen(descriptor, "w") : NULL;
    bool valid = file != NULL;
    if (file == NULL && descriptor >= 0)
    {
        close(descriptor);
    }
    if (valid)
    {
        fputs("{\n  \"schema\": \"buster-hot-normalization-development-file-probe-v1\",\n  \"passed\": true,\n  \"development_only\": true,\n  \"raw_assembly_copy\": ", file);
        hp_probe_json_input(file, raw);
        fputs(",\n  \"direct_object_copy\": ", file);
        hp_probe_json_input(file, object);
        fputs(",\n  \"canonical_output\": {\"path\": ", file);
        hp_probe_json_literal(file, canonical_path);
        fprintf(file, ", \"bytes\": %zu, \"sha256\": ", canonical->size);
        hp_probe_json_literal(file, canonical_sha);
        fputs(", \"exclusive_creation\": true, \"written_bytes_verified\": true},\n  \"normalization\": ", file);
        valid = hp_normalization_write(file, proof, raw->buffer_sha, canonical_sha, object->buffer_sha, error);
        if (valid)
        {
            fputs(",\n  \"scope\": \"guarded assembly-text normalization on supplied private copies only; source tuple is a pinned caller argument\",\n  \"limits\": {\"reassembled_object_proved\": false, \"linked_geometry_proved\": false, \"normal_zero_image_identity_proved\": false, \"runtime_semantics_validated\": false, \"performance_measured\": false}\n}\n", file);
        }
        bool flushed = fflush(file) == 0;
        bool written = ferror(file) == 0;
        bool closed = fclose(file) == 0;
        valid = flushed && written && closed && valid;
    }
    if (!valid && error[0] == 0)
    {
        hp_error(error, "cannot create/complete exclusive development normalization receipt");
    }
    return valid;
}

int main(int argc, char **argv)
{
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    HpProbeInput raw = { 0 };
    HpProbeInput object = { 0 };
    HpBuffer canonical = { 0 };
    HpBuffer written = { 0 };
    HpNormalizationProof proof = { 0 };
    char canonical_path[BUSTER_HP_PATH_CAPACITY] = { 0 };
    char receipt_path[BUSTER_HP_PATH_CAPACITY] = { 0 };
    char canonical_sha[65] = { 0 };
    char output_sha[65] = { 0 };
    bool valid = argc == 7;
    if (!valid)
    {
        hp_error(error, "usage: normalize_probe RAW_S_COPY DIRECT_OBJECT_COPY SOURCE_MANIFEST_SHA256 QUALIFIED_NORMAL_SHA256 NEW_CANONICAL_OUTPUT NEW_RECEIPT_OUTPUT");
    }
    if (valid)
    {
        valid = hp_normalize_pair_supported(argv[3], argv[4]);
        if (!valid)
        {
            hp_error(error, "source/normal SHA256 pair is not an authorized normalization profile");
        }
    }
    if (valid)
    {
        valid = hp_probe_output_path(argv[5], canonical_path, error) && hp_probe_output_path(argv[6], receipt_path, error) && strcmp(canonical_path, receipt_path) != 0;
    }
    if (valid)
    {
        valid = hp_probe_input_read(argv[1], &raw, error) && hp_probe_input_read(argv[2], &object, error);
    }
    if (valid)
    {
        valid = (raw.before_metadata.st_dev != object.before_metadata.st_dev || raw.before_metadata.st_ino != object.before_metadata.st_ino) && strcmp(canonical_path, raw.path) != 0 && strcmp(canonical_path, object.path) != 0 && strcmp(receipt_path, raw.path) != 0 && strcmp(receipt_path, object.path) != 0;
    }
    if (valid)
    {
        HpBytes raw_bytes =
        {
            raw.buffer.data,
            raw.buffer.size
        };
        HpBytes object_bytes =
        {
            object.buffer.data,
            object.buffer.size
        };
        valid = hp_normalize_checker(raw_bytes, object_bytes, argv[3], argv[4], &canonical, &proof, error);
    }
    if (valid)
    {
        HpBytes canonical_bytes =
        {
            canonical.data,
            canonical.size
        };
        valid = hp_probe_hash_buffer(canonical_bytes, canonical_sha, error) && hp_probe_input_after(&raw, error) && hp_probe_input_after(&object, error);
        valid = valid && hp_write_file(canonical_path, canonical_bytes, error);
    }
    if (valid)
    {
        valid = hp_sha256_file(canonical_path, output_sha, error) && strcmp(canonical_sha, output_sha) == 0 && hp_read_file(canonical_path, BUSTER_HP_FILE_LIMIT, &written, error);
        valid = valid && written.size == canonical.size && memcmp(written.data, canonical.data, written.size) == 0;
    }
    if (valid)
    {
        valid = hp_probe_receipt(receipt_path, canonical_path, &raw, &object, &canonical, canonical_sha, &proof, error);
    }
    hp_buffer_free(&written);
    hp_buffer_free(&canonical);
    hp_buffer_free(&object.buffer);
    hp_buffer_free(&raw.buffer);
    if (!valid)
    {
        fprintf(stderr, "development normalization probe failed: %s\n", error[0] != 0 ? error : "input/output identity or normalization guard refused");
    }
    else
    {
        fprintf(stdout, "development normalization only: canonical_sha256=%s; no producer/image/runtime/performance gate executed\n", canonical_sha);
    }
    return valid ? 0 : 1;
}
