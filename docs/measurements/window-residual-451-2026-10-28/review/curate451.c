// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original byte-preserving curator for the frozen #451 record. OpenSSL is an external digest library.
#define _GNU_SOURCE
#include <errno.h>
#include <limits.h>
#include <openssl/evp.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

typedef struct Curate451 Curate451;
struct Curate451
{
    const char* source;
    const char* destination;
    FILE* collection;
    unsigned copied;
    unsigned omitted;
};

static bool digest451(const char* path, char hex[65], unsigned long long* bytes)
{
    FILE* file = fopen(path, "rb");
    EVP_MD_CTX* digest = EVP_MD_CTX_new();
    bool valid = file != NULL && digest != NULL && EVP_DigestInit_ex(digest, EVP_sha256(), NULL) == 1;
    unsigned char buffer[65536];
    size_t count = 0;
    *bytes = 0;
    while (valid && (count = fread(buffer, 1, sizeof(buffer), file)) != 0)
    {
        *bytes += count;
        valid = EVP_DigestUpdate(digest, buffer, count) == 1;
    }
    unsigned char result[EVP_MAX_MD_SIZE];
    unsigned length = 0;
    valid = valid && ferror(file) == 0 && EVP_DigestFinal_ex(digest, result, &length) == 1 && length == 32;
    for (unsigned byte = 0; valid && byte < length; byte += 1)
    {
        snprintf(hex + 2 * byte, 3, "%02x", result[byte]);
    }
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    EVP_MD_CTX_free(digest);
    return valid;
}

static bool suffix451(const char* path, const char* suffix)
{
    const size_t length = strlen(path);
    const size_t tail = strlen(suffix);
    return length >= tail && strcmp(path + length - tail, suffix) == 0;
}

static bool path451(char* path)
{
    bool valid = strlen(path) < PATH_MAX;
    for (char* at = path + (path[0] == '/'); valid && *at != 0; at += 1)
    {
        if (*at == '/')
        {
            *at = 0;
            valid = mkdir(path, 0755) == 0 || errno == EEXIST;
            *at = '/';
        }
    }
    return valid;
}

static bool collect451(Curate451* state, const char* relative, const char* expected)
{
    char input[PATH_MAX];
    char output[PATH_MAX];
    const int in = snprintf(input, sizeof(input), "%s/%s", state->source, relative);
    const int out = snprintf(output, sizeof(output), "%s/%s", state->destination, relative);
    struct stat info;
    bool valid = relative[0] != '/' && strstr(relative, "../") == NULL && strchr(relative, '\t') == NULL &&
                 in > 0 && (unsigned)in < sizeof(input) && out > 0 && (unsigned)out < sizeof(output) &&
                 lstat(input, &info) == 0 && S_ISREG(info.st_mode);
    char actual[65];
    unsigned long long bytes = 0;
    valid = valid && digest451(input, actual, &bytes) && strcmp(actual, expected) == 0;
    FILE* source = valid ? fopen(input, "rb") : NULL;
    unsigned char magic[4] = { 0 };
    const size_t read = source != NULL ? fread(magic, 1, sizeof(magic), source) : 0;
    valid = valid && source != NULL && ferror(source) == 0 && fseek(source, 0, SEEK_SET) == 0;
    const char* disposition = "copied-byte-exact";
    if (read == 4 && memcmp(magic, "\177ELF", 4) == 0)
    {
        disposition = "private-ELF-identity-retained";
    }
    else if (suffix451(relative, ".tar") || suffix451(relative, ".tar.gz"))
    {
        disposition = "private-duplicate-transfer-archive";
    }
    else if (suffix451(relative, ".i"))
    {
        disposition = "private-preprocessed-output-identity-retained";
    }
    else if (bytes > 5ull * 1024 * 1024)
    {
        disposition = "private-large-generated-input-identity-retained";
    }
    const bool copy = strcmp(disposition, "copied-byte-exact") == 0;
    valid = valid && (!copy || path451(output));
    FILE* destination = valid && copy ? fopen(output, "wbx") : NULL;
    valid = valid && (!copy || destination != NULL);
    unsigned char buffer[65536];
    size_t count = 0;
    while (valid && copy && (count = fread(buffer, 1, sizeof(buffer), source)) != 0)
    {
        valid = fwrite(buffer, 1, count, destination) == count;
    }
    if (source != NULL)
    {
        valid = ferror(source) == 0 && valid;
        valid = fclose(source) == 0 && valid;
    }
    if (destination != NULL)
    {
        valid = fclose(destination) == 0 && valid;
    }
    if (valid && copy)
    {
        char copied[65];
        unsigned long long size = 0;
        valid = digest451(output, copied, &size) && bytes == size && strcmp(actual, copied) == 0;
    }
    if (valid)
    {
        valid = fprintf(state->collection, "%s\t%llu\t%s\t%s\n", relative, bytes, actual, disposition) > 0;
        state->copied += copy;
        state->omitted += !copy;
    }
    else
    {
        fprintf(stderr, "curate451: invalid source/copy: %s\n", relative);
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 4;
    Curate451 state = { .source = valid ? argv[1] : NULL, .destination = valid ? argv[2] : NULL };
    char manifest[PATH_MAX];
    char collection[PATH_MAX];
    if (valid)
    {
        const int a = snprintf(manifest, sizeof(manifest), "%s/FINAL-SHA256SUMS", state.source);
        const int b = snprintf(collection, sizeof(collection), "%s/COLLECTION.tsv", state.destination);
        valid = a > 0 && (unsigned)a < sizeof(manifest) && b > 0 && (unsigned)b < sizeof(collection) && path451(collection);
    }
    char expected_manifest[65];
    unsigned long long bytes = 0;
    valid = valid && digest451(manifest, expected_manifest, &bytes) && strcmp(expected_manifest, argv[3]) == 0;
    FILE* input = valid ? fopen(manifest, "r") : NULL;
    state.collection = valid ? fopen(collection, "wx") : NULL;
    valid = valid && input != NULL && state.collection != NULL;
    if (valid)
    {
        valid = fputs("source_path\tbytes\tsha256\tdisposition\n", state.collection) >= 0;
    }
    char* line = NULL;
    size_t capacity = 0;
    unsigned entries = 0;
    while (valid && getline(&line, &capacity, input) >= 0)
    {
        const size_t length = strlen(line);
        valid = length > 69 && line[64] == ' ' && line[65] == ' ' && line[66] == '.' && line[67] == '/' && line[length - 1] == '\n';
        if (valid)
        {
            line[64] = 0;
            line[length - 1] = 0;
            valid = collect451(&state, line + 68, line);
            entries += 1;
        }
    }
    valid = valid && entries == 414 && collect451(&state, "FINAL-SHA256SUMS", expected_manifest);
    if (input != NULL)
    {
        valid = ferror(input) == 0 && valid;
        valid = fclose(input) == 0 && valid;
    }
    if (state.collection != NULL)
    {
        valid = fclose(state.collection) == 0 && valid;
    }
    free(line);
    printf("curate451: %s, frozen payload entries=%u plus source manifest, copied=%u omitted=%u\n", valid ? "pass" : "FAIL", entries, state.copied, state.omitted);
    return !valid;
}
