// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Prepared diagnostic derivative. It never runs a produced compiler or timings.
#define _GNU_SOURCE
#include "hp_common.h"
#include "hp_driver.h"
#include "hp_linked.h"
#include "hp_pad.h"
#include "hp_plan.h"
#include "hp_receipt.h"
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <sched.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define BUSTER_HP_CLANG_SHA "c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67"
#define BUSTER_HP_LICENSE_SHA "8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee"
#define BUSTER_HP_WILD_SHA "8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51"
#define BUSTER_HP_HOT ".text.buster_checker"

typedef struct HpMethod HpMethod;
struct HpMethod
{
    char tree[BUSTER_HP_PATH_CAPACITY];
    char root[BUSTER_HP_PATH_CAPACITY];
    char tc[BUSTER_HP_PATH_CAPACITY];
    char cc[BUSTER_HP_PATH_CAPACITY];
    char manifest[BUSTER_HP_PATH_CAPACITY];
    char manifest_sha[65];
    char normal_sha[65];
    HpArguments flags;
    HpArguments sources;
    HpArguments objects;
    HpSourcePlan plan;
    HpDriverIsa c_isa;
    bool fragment;
};

static bool method_digest(const char* value)
{
    bool result = value != NULL && strlen(value) == 64;
    for (size_t i = 0; result && i < 64; ++i)
    {
        result = (value[i] >= '0' && value[i] <= '9') || (value[i] >= 'a' && value[i] <= 'f');
    }
    return result;
}

static bool method_canonical(const char* input, char output[BUSTER_HP_PATH_CAPACITY], char error[BUSTER_HP_ERROR_CAPACITY])
{
    bool result = input != NULL && input[0] == '/' && realpath(input, output) != NULL;
    if (!result)
    {
        hp_error(error, "absolute existing canonical path required: %s", input != NULL ? input : "(null)");
    }
    return result;
}

static bool method_new_path(const char* input, char output[BUSTER_HP_PATH_CAPACITY], char error[BUSTER_HP_ERROR_CAPACITY])
{
    char parent[BUSTER_HP_PATH_CAPACITY] = {0};
    char canonical[BUSTER_HP_PATH_CAPACITY] = {0};
    bool result = input != NULL && input[0] == '/' && strlen(input) < sizeof(parent);
    if (result)
    {
        strcpy(parent, input);
        char* slash = strrchr(parent, '/');
        result = slash != NULL && slash[1] != '\0' && strcmp(slash + 1, ".") != 0 && strcmp(slash + 1, "..") != 0;
        if (result)
        {
            char name[BUSTER_HP_PATH_CAPACITY] = {0};
            strcpy(name, slash + 1);
            slash[1] = '\0';
            result = method_canonical(parent, canonical, error) && hp_join_path(output, canonical, name, error);
        }
    }
    if (!result && error[0] == '\0')
    {
        hp_error(error, "fresh absolute output with an existing parent required");
    }
    return result;
}

static bool method_hash(const char* path, const char* expected, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char digest[65] = {0};
    bool result = method_digest(expected) && hp_sha256_file(path, digest, error);
    if (result && strcmp(digest, expected) != 0)
    {
        result = hp_error(error, "SHA256 mismatch: %s", path);
    }
    return result;
}

static bool method_path(char output[BUSTER_HP_PATH_CAPACITY], const HpMethod* method, const char* name, char error[BUSTER_HP_ERROR_CAPACITY])
{
    return hp_join_path(output, method->root, name, error);
}

static bool method_identity(HpMethod* method, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char license[BUSTER_HP_PATH_CAPACITY] = {0};
    const char* held = getenv("BUSTER_9700X_HELD");
    bool result = held != NULL && strcmp(held, "1") == 0;
    if (!result)
    {
        hp_error(error, "requires inherited existing shared-host lock; never set HELD manually");
    }
    if (result)
    {
        result = hp_join_path(method->cc, method->tc, "bin/clang", error) &&
            hp_join_path(license, method->tc, "LICENSE.TXT", error) &&
            method_hash(method->cc, BUSTER_HP_CLANG_SHA, error) &&
            method_hash(license, BUSTER_HP_LICENSE_SHA, error) &&
            method_hash("/usr/bin/wild", BUSTER_HP_WILD_SHA, error) &&
            hp_prepare_environment(method->tc, error);
    }
    return result;
}

static bool method_load_arguments(const char* path, HpArguments* arguments, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer bytes = {0};
    bool result = hp_read_file(path, 1024 * 1024, &bytes, error) &&
        hp_arguments_read((HpBytes){bytes.data, bytes.size}, arguments, error);
    hp_buffer_free(&bytes);
    return result;
}

static bool method_copy(const char* from, const char* to, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer bytes = {0};
    bool result = hp_read_file(from, BUSTER_HP_FILE_LIMIT, &bytes, error) &&
        hp_write_file(to, (HpBytes){bytes.data, bytes.size}, error);
    hp_buffer_free(&bytes);
    return result;
}

static bool method_run(const HpPlanArguments* argv, const char* cwd, const char* stem, char error[BUSTER_HP_ERROR_CAPACITY])
{
    int status = -1;
    bool result = hp_run(argv->values, cwd, stem, true, &status, error);
    return result;
}

static bool method_driver(const HpPlanArguments* argv, const char* mode, const HpMethod* method, const char* stem, HpDriverIsa* isa, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpPlanArguments receipt = {0};
    HpBuffer log = {0};
    char path[BUSTER_HP_PATH_CAPACITY] = {0};
    char actual[BUSTER_HP_PATH_CAPACITY] = {0};
    char expected[BUSTER_HP_PATH_CAPACITY] = {0};
    bool result = argv->count + 1 < BUSTER_HP_ARGUMENT_LIMIT;
    if (result)
    {
        receipt.values[0] = argv->values[0];
        receipt.values[1] = "-###";
        for (size_t i = 1; i < argv->count; ++i)
        {
            receipt.values[i + 1] = argv->values[i];
        }
        receipt.count = argv->count + 1;
        result = method_run(&receipt, method->tree, stem, error);
    }
    if (result && mode != NULL)
    {
        int length = snprintf(path, sizeof(path), "%s.stderr", stem);
        result = length > 0 && (size_t)length < sizeof(path) &&
            hp_read_file(path, BUSTER_HP_DRIVER_LOG_LIMIT, &log, error) &&
            hp_driver_isa((HpBytes){log.data, log.size}, mode, isa, error) &&
            method_canonical(isa->executable, actual, error) && method_canonical(method->cc, expected, error);
        if (result && strcmp(actual, expected) != 0)
        {
            result = hp_error(error, "effective internal driver is not pinned Clang");
        }
    }
    if (!result && error[0] == '\0')
    {
        hp_error(error, "effective-driver receipt failed");
    }
    hp_buffer_free(&log);
    return result;
}

static bool method_default(const HpMethod* method, const char* stem, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpPlanArguments argv = {0};
    HpBuffer bytes = {0};
    char path[BUSTER_HP_PATH_CAPACITY] = {0};
    argv.values[0] = method->cc;
    argv.values[1] = "-dumpmachine";
    argv.count = 2;
    int length = snprintf(path, sizeof(path), "%s.stdout", stem);
    bool result = length > 0 && (size_t)length < sizeof(path) && method_run(&argv, method->tree, stem, error) &&
        hp_read_file(path, 1024, &bytes, error) && hp_driver_default_target((HpBytes){bytes.data, bytes.size}, error);
    hp_buffer_free(&bytes);
    return result;
}

static bool method_api(HpMethod* method, const char* name, const char* action, const char* reference, HpArguments* arguments, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char script[BUSTER_HP_PATH_CAPACITY] = {0};
    char stem[BUSTER_HP_PATH_CAPACITY] = {0};
    char stdout_path[BUSTER_HP_PATH_CAPACITY] = {0};
    char saved[BUSTER_HP_PATH_CAPACITY] = {0};
    HpPlanArguments argv = {0};
    bool result = hp_join_path(script, method->tree, "build.sh", error);
    int length = snprintf(stem, sizeof(stem), "%s/logs/%s-api", method->root, name);
    int stdout_length = snprintf(stdout_path, sizeof(stdout_path), "%s.stdout", stem);
    int saved_length = snprintf(saved, sizeof(saved), "%s/%s.nul", method->root, name);
    result = result && length > 0 && (size_t)length < sizeof(stem) && stdout_length > 0 && (size_t)stdout_length < sizeof(stdout_path) && saved_length > 0 && (size_t)saved_length < sizeof(saved);
    argv.values[0] = "/bin/bash";
    argv.values[1] = script;
    argv.values[2] = action;
    argv.count = 3;
    if (result)
    {
        result = method_run(&argv, method->tree, stem, error) && hp_files_equal(stdout_path, reference, error) &&
            method_copy(stdout_path, saved, error) && method_load_arguments(saved, arguments, error);
    }
    return result;
}

static bool method_objects(HpMethod* method, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char* storage = calloc(method->sources.count, BUSTER_HP_PATH_CAPACITY);
    char** values = calloc(method->sources.count + 1, sizeof(char*));
    bool result = storage != NULL && values != NULL;
    if (!result)
    {
        hp_error(error, "object argument allocation failed");
    }
    for (size_t i = 0; result && i < method->sources.count; ++i)
    {
        values[i] = storage + i * BUSTER_HP_PATH_CAPACITY;
        int length = snprintf(values[i], BUSTER_HP_PATH_CAPACITY, "%s/objects/%zu.o", method->root, i);
        result = length > 0 && length < BUSTER_HP_PATH_CAPACITY;
    }
    if (result)
    {
        method->objects = (HpArguments){storage, values, method->sources.count};
    }
    else
    {
        free(storage);
        free(values);
    }
    return result;
}

static bool method_manifest_has(HpBytes manifest, const char* name)
{
    bool found = false;
    size_t position = 0;
    size_t size = strlen(name);
    while (position < manifest.size)
    {
        size_t start = position;
        while (position < manifest.size && manifest.data[position] != '\n')
        {
            ++position;
        }
        size_t row_size = position - start;
        found = found || (row_size == size + 66 && memcmp(manifest.data + start + 66, name, size) == 0);
        position += position < manifest.size;
    }
    return found;
}

static bool method_manifest_inputs(const HpMethod* method, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer bytes = {0};
    bool result = hp_read_file(method->manifest, 4 * 1024 * 1024, &bytes, error) &&
        method_manifest_has((HpBytes){bytes.data, bytes.size}, "build.sh");
    for (size_t i = 0; result && i < method->sources.count; ++i)
    {
        result = method_manifest_has((HpBytes){bytes.data, bytes.size}, method->sources.values[i]);
    }
    if (!result && error[0] == '\0')
    {
        hp_error(error, "qualified source manifest must include build.sh and every API translation unit");
    }
    hp_buffer_free(&bytes);
    return result;
}

static bool method_environment_receipt(const HpMethod* method, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char path[BUSTER_HP_PATH_CAPACITY] = {0};
    const char* values[BUSTER_HP_ARGUMENT_LIMIT + 1] = {0};
    const char* selected[] = {"PATH", "LD_LIBRARY_PATH", "BUSTER_CLANG_RESOURCE_DIR", "BUSTER_HOST_ARCH", "BUSTER_DEBUG_INFO", "BUSTER_SANITIZER", "BUSTER_LINKER", "LC_ALL", "LC_NUMERIC", "SOURCE_DATE_EPOCH", "BUSTER_9700X_HELD"};
    size_t count = 0;
    values[count++] = "clang";
    values[count++] = method->cc;
    values[count++] = BUSTER_HP_CLANG_SHA;
    values[count++] = "LICENSE.TXT";
    values[count++] = BUSTER_HP_LICENSE_SHA;
    values[count++] = "/usr/bin/wild";
    values[count++] = BUSTER_HP_WILD_SHA;
    bool result = true;
    for (size_t i = 0; result && i < sizeof(selected) / sizeof(selected[0]); ++i)
    {
        const char* value = getenv(selected[i]);
        result = value != NULL && value[0] != '\0';
        if (result)
        {
            values[count++] = selected[i];
            values[count++] = value;
        }
    }
    if (result)
    {
        result = method_path(path, method, "toolchain-environment.nul", error) && hp_record_arguments(path, values, error);
    }
    if (!result && error[0] == '\0')
    {
        hp_error(error, "selected toolchain environment unavailable");
    }
    return result;
}

static bool method_jobs(size_t source_count, size_t* jobs, char error[BUSTER_HP_ERROR_CAPACITY])
{
    cpu_set_t affinity;
    char groups[CPU_SETSIZE][128] = {{0}};
    size_t count = 0;
    CPU_ZERO(&affinity);
    bool result = sched_getaffinity(0, sizeof(affinity), &affinity) == 0;
    for (size_t cpu = 0; result && cpu < CPU_SETSIZE; ++cpu)
    {
        if (CPU_ISSET((int)cpu, &affinity))
        {
            char path[128] = {0};
            HpBuffer bytes = {0};
            int length = snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%zu/topology/core_cpus_list", cpu);
            result = length > 0 && (size_t)length < sizeof(path) && hp_read_file(path, 127, &bytes, error) && bytes.size > 0;
            if (result)
            {
                while (bytes.size > 0 && (bytes.data[bytes.size - 1] == '\n' || bytes.data[bytes.size - 1] == '\r'))
                {
                    bytes.data[--bytes.size] = '\0';
                }
                result = bytes.size > 0 && memchr(bytes.data, '\0', bytes.size) == NULL;
                bool found = false;
                for (size_t i = 0; result && i < count; ++i)
                {
                    found = found || strcmp(groups[i], (const char*)bytes.data) == 0;
                }
                if (result && !found)
                {
                    strcpy(groups[count++], (const char*)bytes.data);
                }
            }
            hp_buffer_free(&bytes);
        }
    }
    if (result && count > 0)
    {
        *jobs = count < source_count ? count : source_count;
    }
    else
    {
        result = hp_error(error, "physical core_cpus_list budget unavailable");
    }
    return result;
}

static bool method_compiles(HpMethod* method, size_t jobs, char error[BUSTER_HP_ERROR_CAPACITY])
{
    pid_t children[BUSTER_HP_SOURCE_LIMIT] = {0};
    bool result = jobs > 0 && jobs <= BUSTER_HP_SOURCE_LIMIT;
    for (size_t i = 0; result && i < method->sources.count; ++i)
    {
        size_t slot = i % jobs;
        if (children[slot] > 0)
        {
            int status = -1;
            result = hp_wait(children[slot], &status, error) && status == 0;
            children[slot] = 0;
        }
        if (result)
        {
            pid_t child = fork();
            if (child == 0)
            {
                char local_error[BUSTER_HP_ERROR_CAPACITY] = {0};
                char json[BUSTER_HP_PATH_CAPACITY] = {0};
                char stem[BUSTER_HP_PATH_CAPACITY] = {0};
                HpPlanArguments argv = {0};
                int length = snprintf(json, sizeof(json), "%s/objects/%zu.json", method->root, i);
                int stem_length = snprintf(stem, sizeof(stem), "%s/logs/compile-%zu", method->root, i);
                bool ok = length > 0 && (size_t)length < sizeof(json) && stem_length > 0 && (size_t)stem_length < sizeof(stem) &&
                    hp_plan_compile(method->cc, method->sources.values[i], method->objects.values[i], json, &method->flags, &argv, local_error) &&
                    method_run(&argv, method->tree, stem, local_error);
                if (!ok)
                {
                    fprintf(stderr, "compile %zu: %s\n", i, local_error);
                }
                _exit(ok ? 0 : 1);
            }
            if (child < 0)
            {
                result = hp_error(error, "compile wrapper fork failed");
            }
            else
            {
                children[slot] = child;
            }
        }
    }
    for (size_t slot = 0; slot < jobs && slot < BUSTER_HP_SOURCE_LIMIT; ++slot)
    {
        if (children[slot] > 0)
        {
            int status = -1;
            bool waited = hp_wait(children[slot], &status, error);
            result = waited && status == 0 && result;
        }
    }
    if (!result && error[0] == '\0')
    {
        hp_error(error, "at least one source compile failed; preserved individual receipts");
    }
    return result;
}

static bool method_prove(const HpMethod* method, const char* variant_object, const char* variant_image, uint64_t shift, const char* object_receipt, const char* linked_receipt, char error[BUSTER_HP_ERROR_CAPACITY])
{
    HpBuffer object_bytes = {0}, variant_bytes = {0}, normal_bytes = {0}, image_bytes = {0};
    HpElf object = {0}, variant = {0}, normal = {0}, image = {0};
    HpObjectProof object_proof = {0};
    HpLinkedProof linked_proof = {0};
    const char* required[] = {"check_lower_fragment"};
    char normal_path[BUSTER_HP_PATH_CAPACITY] = {0};
    bool result = method_path(normal_path, method, "direct-normal", error) &&
        hp_read_file(method->objects.values[method->plan.checker_index], BUSTER_HP_FILE_LIMIT, &object_bytes, error) &&
        hp_read_file(variant_object, BUSTER_HP_FILE_LIMIT, &variant_bytes, error) &&
        hp_elf_read((HpBytes){object_bytes.data, object_bytes.size}, &object, error) &&
        hp_elf_read((HpBytes){variant_bytes.data, variant_bytes.size}, &variant, error) &&
        hp_elf_compare_objects(&object, &variant, BUSTER_HP_HOT, shift, &object_proof, error) &&
        hp_receipt_object(object_receipt, &object_proof, error) &&
        hp_read_file(normal_path, BUSTER_HP_FILE_LIMIT, &normal_bytes, error) &&
        hp_read_file(variant_image, BUSTER_HP_FILE_LIMIT, &image_bytes, error) &&
        hp_elf_read((HpBytes){normal_bytes.data, normal_bytes.size}, &normal, error) &&
        hp_elf_read((HpBytes){image_bytes.data, image_bytes.size}, &image, error) &&
        hp_linked_compare(&object, &normal, &image, shift, required, method->fragment ? 1 : 0, &linked_proof, error) &&
        hp_receipt_linked(linked_receipt, &linked_proof, error);
    hp_object_proof_free(&object_proof);
    hp_linked_proof_free(&linked_proof);
    hp_elf_free(&object);
    hp_elf_free(&variant);
    hp_elf_free(&normal);
    hp_elf_free(&image);
    hp_buffer_free(&object_bytes);
    hp_buffer_free(&variant_bytes);
    hp_buffer_free(&normal_bytes);
    hp_buffer_free(&image_bytes);
    return result;
}

static bool method_snapshot_directory(FILE* output, const char* root, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char (*pending)[BUSTER_HP_PATH_CAPACITY] = calloc(1024, BUSTER_HP_PATH_CAPACITY);
    size_t count = 1;
    bool result = pending != NULL;
    for (size_t current = 0; result && current < count; ++current)
    {
        char path[BUSTER_HP_PATH_CAPACITY] = {0};
        result = hp_join_path(path, root, pending[current], error);
        DIR* directory = result ? opendir(path) : NULL;
        if (directory == NULL)
        {
            result = hp_error(error, "snapshot directory unavailable");
        }
        bool ended = false;
        while (result && !ended)
        {
            errno = 0;
            struct dirent* entry = readdir(directory);
            ended = entry == NULL;
            if (ended && errno != 0)
            {
                result = hp_error(error, "snapshot directory read failed");
            }
            if (!ended && strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0)
            {
                char name[BUSTER_HP_PATH_CAPACITY] = {0};
                char full[BUSTER_HP_PATH_CAPACITY] = {0};
                struct stat info;
                int length = pending[current][0] == '\0' ? snprintf(name, sizeof(name), "%s", entry->d_name) : snprintf(name, sizeof(name), "%s/%s", pending[current], entry->d_name);
                result = length > 0 && (size_t)length < sizeof(name) && hp_join_path(full, root, name, error) && lstat(full, &info) == 0;
                if (result && S_ISDIR(info.st_mode))
                {
                    result = count < 1024;
                    if (result)
                    {
                        strcpy(pending[count++], name);
                    }
                }
                else if (result && S_ISREG(info.st_mode))
                {
                    if (strcmp(name, "snapshot.sha256") != 0 && strcmp(name, "prepared.json") != 0 && strcmp(name, "ready.nul") != 0)
                    {
                        char digest[65] = {0};
                        result = strchr(name, '\n') == NULL && hp_sha256_file(full, digest, error) && fprintf(output, "%s  %s\n", digest, name) > 0;
                    }
                }
                else if (result)
                {
                    result = hp_error(error, "snapshot rejects nonregular artifact");
                }
            }
        }
        if (directory != NULL && closedir(directory) != 0)
        {
            result = hp_error(error, "snapshot directory close failed");
        }
    }
    free(pending);
    return result;
}

static bool method_snapshot(const HpMethod* method, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char path[BUSTER_HP_PATH_CAPACITY] = {0};
    bool result = method_path(path, method, "snapshot.sha256", error);
    int descriptor = result ? open(path, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    FILE* output = descriptor >= 0 ? fdopen(descriptor, "w") : NULL;
    if (output == NULL)
    {
        if (descriptor >= 0)
        {
            close(descriptor);
        }
        result = hp_error(error, "exclusive snapshot creation failed");
    }
    if (result)
    {
        result = method_snapshot_directory(output, method->root, error);
    }
    if (output != NULL)
    {
        bool flushed = fflush(output) == 0 && ferror(output) == 0;
        bool closed = fclose(output) == 0;
        result = flushed && closed && result;
    }
    return result;
}

static bool method_settings(HpMethod* method, size_t jobs, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char index[32] = {0}, count[32] = {0}, budget[32] = {0};
    char path[BUSTER_HP_PATH_CAPACITY] = {0};
    snprintf(index, sizeof(index), "%zu", method->plan.checker_index);
    snprintf(count, sizeof(count), "%zu", method->plan.count);
    snprintf(budget, sizeof(budget), "%zu", jobs);
    const char* values[] = {method->tree, method->tc, method->manifest, method->manifest_sha, method->normal_sha, index, count, method->fragment ? "1" : "0", budget, NULL};
    bool result = method_path(path, method, "settings.nul", error) && hp_record_arguments(path, values, error);
    return result;
}

static bool method_complete(const HpMethod* method, const char* directory, const char* marker, const char* image_name, const char* scope, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char path[BUSTER_HP_PATH_CAPACITY] = {0}, image[BUSTER_HP_PATH_CAPACITY] = {0}, digest[65] = {0};
    bool result = hp_join_path(path, directory, marker, error) && hp_join_path(image, directory, image_name, error) &&
        hp_sha256_file(image, digest, error) && hp_receipt_identity(path, image, digest, scope, error);
    (void)method;
    return result;
}

static bool method_inside_build(HpMethod* method, uint64_t shift, bool zero, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char directory[BUSTER_HP_PATH_CAPACITY] = {0}, name[32] = {0};
    char assembly[BUSTER_HP_PATH_CAPACITY] = {0}, object[BUSTER_HP_PATH_CAPACITY] = {0}, image[BUSTER_HP_PATH_CAPACITY] = {0};
    char original[BUSTER_HP_PATH_CAPACITY] = {0}, anchor_path[BUSTER_HP_PATH_CAPACITY] = {0};
    char stem[BUSTER_HP_PATH_CAPACITY] = {0}, object_receipt[BUSTER_HP_PATH_CAPACITY] = {0}, linked_receipt[BUSTER_HP_PATH_CAPACITY] = {0};
    HpBuffer original_bytes = {0};
    unsigned char* padded = NULL;
    size_t padded_size = 0, anchor = 0;
    HpPlanArguments argv = {0};
    HpDriverIsa assembler_isa = {0};
    snprintf(name, sizeof(name), "inside-%" PRIu64, shift);
    bool result = method_path(directory, method, name, error) && hp_mkdir_new(directory, error) &&
        hp_join_path(assembly, directory, "checker.s", error) && hp_join_path(object, directory, "checker.o", error) &&
        hp_join_path(image, directory, "compiler", error) && hp_join_path(anchor_path, directory, "anchor.nul", error) &&
        hp_join_path(object_receipt, directory, "object-proof.json", error) && hp_join_path(linked_receipt, directory, "linked-proof.json", error) &&
        method_path(original, method, "checker.s", error) && hp_read_file(original, BUSTER_HP_FILE_LIMIT, &original_bytes, error) &&
        hp_pad_hot((HpBytes){original_bytes.data, original_bytes.size}, shift, &padded, &padded_size, &anchor, error) &&
        hp_write_file(assembly, (HpBytes){padded, padded_size}, error);
    if (result)
    {
        char anchor_text[32] = {0};
        snprintf(anchor_text, sizeof(anchor_text), "%zu", anchor);
        const char* record[] = {anchor_text, name, NULL};
        result = hp_record_arguments(anchor_path, record, error) && hp_plan_assemble(method->cc, assembly, object, &argv, error) &&
            hp_join_path(stem, directory, "effective-assembler-driver", error) && method_driver(&argv, "-cc1as", method, stem, &assembler_isa, error);
        if (result && !hp_driver_equal(&method->c_isa, &assembler_isa))
        {
            result = hp_error(error, "effective C/assembler target/CPU/ordered features differ");
        }
    }
    if (result)
    {
        result = hp_join_path(stem, directory, "assemble", error) && method_run(&argv, method->tree, stem, error) &&
            hp_plan_link(method->cc, &method->objects, method->plan.checker_index, object, image, &argv, error) &&
            hp_join_path(stem, directory, "effective-link-driver", error) && method_driver(&argv, NULL, method, stem, NULL, error) &&
            hp_join_path(stem, directory, "link", error) && method_run(&argv, method->tree, stem, error);
    }
    if (result && zero)
    {
        result = method_hash(image, method->normal_sha, error);
    }
    if (result)
    {
        result = method_prove(method, object, image, shift, object_receipt, linked_receipt, error) && hp_verify_sources(method->tree, method->manifest, error);
    }
    if (result && !zero)
    {
        result = method_complete(method, directory, "complete.json", "compiler", "structural placement only; per-image output controls required; no target execution or timings", error);
    }
    hp_driver_free(&assembler_isa);
    hp_buffer_free(&original_bytes);
    free(padded);
    return result;
}

static bool method_prepare(HpMethod* method, const char* normal, const char* flags_reference, const char* sources_reference, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char path[BUSTER_HP_PATH_CAPACITY] = {0}, stem[BUSTER_HP_PATH_CAPACITY] = {0};
    HpPlanArguments argv = {0};
    struct stat info;
    size_t jobs = 0;
    bool result = hp_verify_sources(method->tree, method->manifest, error) && method_hash(normal, method->normal_sha, error) &&
        hp_sha256_file(method->manifest, method->manifest_sha, error) && method_identity(method, error);
    if (result)
    {
        size_t tree_length = strlen(method->tree);
        result = strncmp(method->root, method->tree, tree_length) != 0 || (method->root[tree_length] != '/' && method->root[tree_length] != '\0');
        if (!result)
        {
            hp_error(error, "output must be outside the source tree");
        }
    }
    if (result)
    {
        result = hp_mkdir_new(method->root, error) && method_path(path, method, "objects", error) && hp_mkdir_new(path, error) &&
            method_path(path, method, "logs", error) && hp_mkdir_new(path, error) && method_environment_receipt(method, error) && method_path(stem, method, "logs/default-target", error) && method_default(method, stem, error) &&
            method_api(method, "flags", "print-compile-flags", flags_reference, &method->flags, error) && hp_validate_flags(&method->flags, error) &&
            method_api(method, "sources", "print-sources", sources_reference, &method->sources, error) && hp_plan_sources(&method->sources, &method->plan, error) && method_manifest_inputs(method, error) && method_objects(method, error) &&
            method_jobs(method->sources.count, &jobs, error);
    }
    if (result)
    {
        result = hp_join_path(path, method->tree, "src/buster/compiler/c_check_program_fragment.c", error);
        method->fragment = result && lstat(path, &info) == 0 && S_ISREG(info.st_mode);
        result = result && method_settings(method, jobs, error) &&
            hp_plan_compile(method->cc, method->sources.values[method->plan.checker_index], method->objects.values[method->plan.checker_index], "/dev/null", &method->flags, &argv, error) &&
            method_path(stem, method, "logs/effective-c-driver", error) && method_driver(&argv, "-cc1", method, stem, &method->c_isa, error) &&
            method_compiles(method, jobs, error);
    }
    if (result)
    {
        result = method_path(path, method, "checker.s", error) && hp_plan_assembly(method->cc, method->sources.values[method->plan.checker_index], path, &method->flags, &argv, error) &&
            method_path(stem, method, "logs/checker-assembly", error) && method_run(&argv, method->tree, stem, error) &&
            method_path(path, method, "direct-normal", error) && hp_plan_link(method->cc, &method->objects, method->plan.checker_index, NULL, path, &argv, error) &&
            method_path(stem, method, "logs/effective-direct-link-driver", error) && method_driver(&argv, NULL, method, stem, NULL, error) &&
            method_path(stem, method, "logs/link-direct-normal", error) && method_run(&argv, method->tree, stem, error) && method_hash(path, method->normal_sha, error) &&
            method_inside_build(method, 0, true, error) && hp_verify_sources(method->tree, method->manifest, error) && method_snapshot(method, error) &&
            method_complete(method, method->root, "prepared.json", "direct-normal", "objects and zero control only; no target execution or timings", error);
    }
    if (result)
    {
        char snapshot_sha[65] = {0};
        result = method_path(path, method, "snapshot.sha256", error) && hp_sha256_file(path, snapshot_sha, error);
        const char* ready[] = {"buster-hot-placement-c-v1", method->normal_sha, method->manifest_sha, snapshot_sha, NULL};
        result = result && method_path(path, method, "ready.nul", error) && hp_record_arguments(path, ready, error);
    }
    return result;
}

static bool method_resume(HpMethod* method, uint64_t shift, char error[BUSTER_HP_ERROR_CAPACITY])
{
    char path[BUSTER_HP_PATH_CAPACITY] = {0};
    char canonical[BUSTER_HP_PATH_CAPACITY] = {0};
    HpArguments settings = {0};
    HpArguments ready = {0};
    HpBuffer receipt = {0};
    uint64_t index = 0, count = 0, jobs = 0, fragment = 0;
    bool result = shift == 16 || shift == 64 || shift == 256 || shift == 1024 || shift == 2048;
    if (!result)
    {
        hp_error(error, "inside accepts only16,64,256,1024,2048; zero belongs to objects");
    }
    if (result)
    {
        result = method_path(path, method, "ready.nul", error) && method_load_arguments(path, &ready, error) && ready.count == 4 &&
            strcmp(ready.values[0], "buster-hot-placement-c-v1") == 0 &&
            method_path(path, method, "snapshot.sha256", error) && method_hash(path, ready.values[3], error) && hp_verify_sources(method->root, path, error) &&
            method_path(path, method, "settings.nul", error) && method_load_arguments(path, &settings, error) && settings.count == 9;
    }
    if (result)
    {
        result = method_canonical(settings.values[0], method->tree, error) && method_canonical(settings.values[1], method->tc, error) &&
            method_canonical(settings.values[2], method->manifest, error) && method_digest(settings.values[3]) && method_digest(settings.values[4]) &&
            hp_plan_decimal(settings.values[5], BUSTER_HP_SOURCE_LIMIT - 1, &index, error) && hp_plan_decimal(settings.values[6], BUSTER_HP_SOURCE_LIMIT, &count, error) && count > 0 && index < count &&
            hp_plan_decimal(settings.values[7], 1, &fragment, error) && hp_plan_decimal(settings.values[8], BUSTER_HP_SOURCE_LIMIT, &jobs, error) && jobs > 0;
        if (result)
        {
            strcpy(method->manifest_sha, settings.values[3]);
            strcpy(method->normal_sha, settings.values[4]);
            method->fragment = fragment == 1;
            result = strcmp(ready.values[1], method->normal_sha) == 0 && strcmp(ready.values[2], method->manifest_sha) == 0 &&
                strcmp(method->tree, settings.values[0]) == 0 && strcmp(method->tc, settings.values[1]) == 0 && strcmp(method->manifest, settings.values[2]) == 0 &&
                method_hash(method->manifest, method->manifest_sha, error) && hp_verify_sources(method->tree, method->manifest, error) && method_identity(method, error) &&
                method_path(path, method, "flags.nul", error) && method_load_arguments(path, &method->flags, error) && hp_validate_flags(&method->flags, error) &&
                method_path(path, method, "sources.nul", error) && method_load_arguments(path, &method->sources, error) && hp_plan_sources(&method->sources, &method->plan, error) &&
                method->plan.checker_index == index && method->plan.count == count && method_manifest_inputs(method, error) && method_objects(method, error) &&
                method_path(path, method, "direct-normal", error) && method_hash(path, method->normal_sha, error) &&
                method_path(path, method, "inside-0/compiler", error) && method_hash(path, method->normal_sha, error) &&
                method_path(path, method, "logs/effective-c-driver.stderr", error) && hp_read_file(path, BUSTER_HP_DRIVER_LOG_LIMIT, &receipt, error) &&
                hp_driver_isa((HpBytes){receipt.data, receipt.size}, "-cc1", &method->c_isa, error) &&
                method_canonical(method->c_isa.executable, canonical, error);
        }
        if (result)
        {
            char cc[BUSTER_HP_PATH_CAPACITY] = {0};
            result = method_canonical(method->cc, cc, error) && strcmp(canonical, cc) == 0;
        }
    }
    if (result)
    {
        char name[64] = {0};
        snprintf(name, sizeof(name), "default-target-inside-%" PRIu64, shift);
        result = method_path(path, method, name, error) && method_default(method, path, error) && method_inside_build(method, shift, false, error);
    }
    if (!result && error[0] == '\0')
    {
        hp_error(error, "prepared metadata, identities or structure failed");
    }
    hp_arguments_free(&settings);
    hp_arguments_free(&ready);
    hp_buffer_free(&receipt);
    return result;
}

static void method_free(HpMethod* method)
{
    hp_arguments_free(&method->flags);
    hp_arguments_free(&method->sources);
    hp_arguments_free(&method->objects);
    hp_driver_free(&method->c_isa);
}

int main(int argc, char** argv)
{
    HpMethod method = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    const char* options[8] = {0};
    const char* names[] = {"--tree", "--out", "--normal", "--manifest", "--flags-reference", "--sources-reference", "--tc", "--normal-sha256"};
    bool result = argc >= 2;
    if (result && strcmp(argv[1], "objects") == 0)
    {
        result = argc == 18;
        for (int i = 2; result && i < argc; i += 2)
        {
            size_t found = 8;
            for (size_t j = 0; j < 8; ++j)
            {
                if (strcmp(argv[i], names[j]) == 0)
                {
                    found = j;
                }
            }
            result = found < 8 && options[found] == NULL;
            if (result)
            {
                options[found] = argv[i + 1];
            }
        }
        if (result)
        {
            char normal[BUSTER_HP_PATH_CAPACITY] = {0}, flags[BUSTER_HP_PATH_CAPACITY] = {0}, sources[BUSTER_HP_PATH_CAPACITY] = {0};
            result = method_canonical(options[0], method.tree, error) && method_new_path(options[1], method.root, error) &&
                method_canonical(options[2], normal, error) && method_canonical(options[3], method.manifest, error) &&
                method_canonical(options[4], flags, error) && method_canonical(options[5], sources, error) && method_canonical(options[6], method.tc, error) && method_digest(options[7]);
            if (result)
            {
                strcpy(method.normal_sha, options[7]);
                result = method_prepare(&method, normal, flags, sources, error);
            }
        }
    }
    else if (result && strcmp(argv[1], "inside") == 0)
    {
        uint64_t shift = 0;
        result = argc == 6 && strcmp(argv[2], "--objects") == 0 && strcmp(argv[4], "--shift") == 0 &&
            method_canonical(argv[3], method.root, error) && hp_plan_decimal(argv[5], 2048, &shift, error) && method_resume(&method, shift, error);
    }
    else
    {
        result = false;
    }
    if (!result)
    {
        fprintf(stderr, "hot-placement: %s\n", error[0] != '\0' ? error : "invalid arguments or failed gate; preserved receipts");
    }
    else
    {
        puts("{\"passed\":true,\"timing_run\":false,\"target_execution\":false}");
    }
    method_free(&method);
    return result ? 0 : 1;
}
