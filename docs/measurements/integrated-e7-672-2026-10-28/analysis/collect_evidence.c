// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original local text-only collection/disposition audit. This never contacts
// the target or follows source symlinks. Every source file gets a disposition.
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
#include <dirent.h>
#include <limits.h>
#include "vendor/perf_core.c"

#define BUSTER_COLLECTION_FILES 8192u
#define BUSTER_COLLECTION_DEPTH 32u

typedef struct Entry Entry;
struct Entry
{
    char* path;
};

static Entry entries[BUSTER_COLLECTION_FILES];
static uint32_t entry_count;

static bool gather(const char* source, const char* relative, uint32_t depth)
{
    char path[PATH_MAX];
    const int bytes = snprintf(path, sizeof(path), "%s/%s", source, relative);
    bool valid = depth < BUSTER_COLLECTION_DEPTH && bytes > 0 && (size_t)bytes < sizeof(path);
    DIR* directory = valid ? opendir(path) : NULL;
    valid = valid && directory != NULL;
    struct dirent* item = NULL;
    while (valid && (item = readdir(directory)) != NULL)
    {
        if (strcmp(item->d_name, ".") == 0 || strcmp(item->d_name, "..") == 0) continue;
        char child[PATH_MAX];
        const int n = snprintf(child, sizeof(child), "%s%s%s", relative, relative[0] != 0 ? "/" : "", item->d_name);
        const int full = snprintf(path, sizeof(path), "%s/%s", source, child);
        struct stat info;
        valid = n > 0 && (size_t)n < sizeof(child) && full > 0 && (size_t)full < sizeof(path) && lstat(path, &info) == 0;
        if (valid && S_ISDIR(info.st_mode)) valid = gather(source, child, depth + 1);
        else if (valid)
        {
            valid = S_ISREG(info.st_mode) && entry_count < BUSTER_COLLECTION_FILES;
            if (valid)
            {
                entries[entry_count].path = strdup(child);
                valid = entries[entry_count].path != NULL;
                entry_count += valid;
            }
        }
    }
    if (directory != NULL) valid = closedir(directory) == 0 && valid;
    return valid;
}

static int order(const void* left, const void* right)
{
    return strcmp(((const Entry*)left)->path, ((const Entry*)right)->path);
}

static bool directories(const char* path)
{
    char text[PATH_MAX];
    bool valid = strlen(path) < sizeof(text);
    if (valid) strcpy(text, path);
    for (uint32_t at = 1; valid && text[at] != 0; at += 1)
    {
        if (text[at] == '/')
        {
            text[at] = 0;
            valid = mkdir(text, 0755) == 0 || errno == EEXIST;
            text[at] = '/';
        }
    }
    return valid;
}

static bool hash_file(const char* path, char digest[65], uint64_t* bytes, bool* elf, bool* text)
{
    FILE* input = fopen(path, "rb");
    bool valid = input != NULL;
    PerfSha256 hash = perf_sha256_start();
    unsigned char block[65536];
    *bytes = 0;
    *elf = false;
    *text = true;
    size_t got = 0;
    while (valid && (got = fread(block, 1, sizeof(block), input)) != 0)
    {
        if (*bytes == 0) *elf = got >= 4 && memcmp(block, "\177ELF", 4) == 0;
        *text = *text && memchr(block, 0, got) == NULL;
        valid = perf_sha256_add(&hash, (PerfBytes){ .data = block, .size = got });
        *bytes += got;
    }
    if (input != NULL)
    {
        const bool read_ok = !ferror(input);
        const bool closed = fclose(input) == 0;
        valid = read_ok && closed && valid;
    }
    if (valid) perf_sha256_finish(&hash, digest);
    return valid;
}

static bool copy_file(const char* source, const char* destination)
{
    bool valid = directories(destination);
    FILE* input = valid ? fopen(source, "rb") : NULL;
    FILE* output = input != NULL ? fopen(destination, "wb") : NULL;
    valid = input != NULL && output != NULL;
    unsigned char block[65536];
    size_t bytes = 0;
    while (valid && (bytes = fread(block, 1, sizeof(block), input)) != 0) valid = fwrite(block, 1, bytes, output) == bytes;
    if (input != NULL)
    {
        const bool read_ok = !ferror(input);
        const bool closed = fclose(input) == 0;
        valid = read_ok && closed && valid;
    }
    if (output != NULL) valid = fclose(output) == 0 && valid;
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 3 && gather(argv[1], "", 0);
    if (valid) qsort(entries, entry_count, sizeof(entries[0]), order);
    char collection[PATH_MAX];
    const int n = valid ? snprintf(collection, sizeof(collection), "%s/COLLECTION.tsv", argv[2]) : -1;
    valid = valid && n > 0 && (size_t)n < sizeof(collection) && directories(collection);
    FILE* manifest = valid ? fopen(collection, "w") : NULL;
    valid = valid && manifest != NULL;
    const int excluded_bytes = valid ? snprintf(collection, sizeof(collection), "%s/EXCLUDED-PAYLOADS.tsv", argv[2]) : -1;
    valid = valid && excluded_bytes > 0 && (size_t)excluded_bytes < sizeof(collection);
    FILE* payloads = valid ? fopen(collection, "w") : NULL;
    valid = valid && payloads != NULL;
    if (valid)
    {
        fprintf(manifest, "source_relative_path\tsize_bytes\tsha256\tdisposition\tpublic_relative_path\n");
        fprintf(payloads, "source_relative_path\tsize_bytes\tsha256\tdisposition\tpublic_relative_path\n");
    }
    uint32_t copied = 0;
    uint32_t excluded = 0;
    uint32_t child_logs = 0;
    uint32_t child_receipts = 0;
    uint32_t elf_headers = 0;
    uint32_t smoke_outputs = 0;
    for (uint32_t at = 0; valid && at < entry_count; at += 1)
    {
        const char* relative = entries[at].path;
        char source[PATH_MAX];
        char destination[PATH_MAX];
        const int count = snprintf(source, sizeof(source), "%s/%s", argv[1], relative);
        char digest[65];
        uint64_t bytes = 0;
        bool elf = false;
        bool text = false;
        valid = count > 0 && (size_t)count < sizeof(source) && hash_file(source, digest, &bytes, &elf, &text);
        const char* disposition = "git-text";
        const char* public_path = relative;
        if (strncmp(relative, "analysis/fixtures-", strlen("analysis/fixtures-")) == 0) disposition = "local-only synthetic fixture payload; reproduce with analysis/throughput_summary_test.c";
        else if (strstr(relative, ".tar") != NULL) disposition = "local-only archive; excluded from Git";
        else if (elf) disposition = strncmp(relative, "target/", 7) == 0 ? "local-and-target-only ELF payload; excluded from Git" : "local-only compiled helper; excluded from Git";
        else if (!text) disposition = "local-only non-text payload; excluded from Git";
        if (strcmp(relative, "README.md") == 0) public_path = "setup/README-original.md";
        if (strcmp(relative, "PLAN.md") == 0) public_path = "setup/PLAN-original.md";
        const bool include = strcmp(disposition, "git-text") == 0;
        if (valid && include)
        {
            const int output = snprintf(destination, sizeof(destination), "%s/%s", argv[2], public_path);
            valid = output > 0 && (size_t)output < sizeof(destination) && copy_file(source, destination);
            char copy_digest[65];
            uint64_t copy_bytes = 0;
            bool copy_elf = false;
            bool copy_text = false;
            valid = valid && hash_file(destination, copy_digest, &copy_bytes, &copy_elf, &copy_text) && bytes == copy_bytes && strcmp(digest, copy_digest) == 0;
            copied += valid;
            if (strncmp(relative, "target/scratch/suite-throughput-", strlen("target/scratch/suite-throughput-")) == 0)
            {
                const char* name = strrchr(relative, '/');
                name = name != NULL ? name + 1 : relative;
                child_logs += strncmp(name, "child-", 6) == 0 && strstr(name, ".log") != NULL;
                child_receipts += strcmp(name, "children.tsv") == 0;
                elf_headers += strcmp(name, "elf-header.txt") == 0;
                smoke_outputs += strcmp(name, "sqlite-smoke.txt") == 0;
            }
        }
        else if (valid) excluded += 1;
        if (valid) valid = fprintf(manifest, "%s\t%" PRIu64 "\t%s\t%s\t%s\n", relative, bytes, digest, disposition, include ? public_path : "-") > 0;
        if (valid && !include) valid = fprintf(payloads, "%s\t%" PRIu64 "\t%s\t%s\t-\n", relative, bytes, digest, disposition) > 0;
    }
    valid = valid && child_logs == 600 && child_receipts == 25 && elf_headers == 25 && smoke_outputs == 25;
    if (manifest != NULL) valid = fclose(manifest) == 0 && valid;
    if (payloads != NULL) valid = fclose(payloads) == 0 && valid;
    for (uint32_t at = 0; at < entry_count; at += 1) free(entries[at].path);
    printf("collection: source_files=%u copied_text=%u excluded_with_hash=%u throughput_child_logs=%u throughput_receipts=%u ELF_headers=%u smoke_outputs=%u valid=%s\n", entry_count, copied, excluded, child_logs, child_receipts, elf_headers, smoke_outputs, valid ? "yes" : "no");
    return valid ? 0 : 1;
}
