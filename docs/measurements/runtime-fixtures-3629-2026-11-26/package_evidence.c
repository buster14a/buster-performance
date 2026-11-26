// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Package an explicit evidence manifest. Raw data/logs stay byte-identical. C sources without license headers get
// only comments, and one recorded absolute helper include is relocated to its bundled, unchanged header.
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

static bool parents(const char* file)
{
    char path[4096];
    bool valid = strlen(file) < sizeof(path);
    if (valid)
    {
        strcpy(path, file);
        for (char* at = path + 1; valid && *at != 0; at += 1)
        {
            if (*at == '/')
            {
                *at = 0;
                valid = mkdir(path, 0755) == 0 || errno == EEXIST;
                *at = '/';
            }
        }
    }
    return valid;
}

static bool package(const char* from, const char* to, const char* relative, FILE* report)
{
    FILE* input = fopen(from, "rb");
    bool valid = input != NULL && fseek(input, 0, SEEK_END) == 0;
    const long length = valid ? ftell(input) : -1;
    valid = valid && length >= 0 && length <= (1 << 24) && fseek(input, 0, SEEK_SET) == 0;
    char* text = valid ? malloc((size_t)length + 1) : NULL;
    valid = valid && text != NULL && fread(text, 1, (size_t)length, input) == (size_t)length;
    if (input != NULL)
    {
        valid = fclose(input) == 0 && valid;
    }
    size_t bytes = valid ? (size_t)length : 0;
    bool relocated = false;
    bool licensed = false;
    if (valid)
    {
        text[bytes] = 0;
        valid = memchr(text, 0, bytes) == NULL;
    }
    if (valid && strcmp(relative, "ir-preproc/loader_check.c") == 0)
    {
        static const char original[] = "#include \"/tmp/buster-3629/src/buster/compiler/test_paths.h\"";
        static const char bundled[] = "#include \"test_paths.h\"";
        char* found = strstr(text, original);
        valid = found != NULL && strstr(found + sizeof(original) - 1, original) == NULL;
        if (valid)
        {
            const size_t offset = (size_t)(found - text);
            memcpy(found, bundled, sizeof(bundled) - 1);
            memmove(found + sizeof(bundled) - 1, text + offset + sizeof(original) - 1, bytes - offset - sizeof(original) + 2);
            bytes -= sizeof(original) - sizeof(bundled);
            relocated = true;
        }
    }
    FILE* output = valid && parents(to) ? fopen(to, "wb") : NULL;
    valid = valid && output != NULL;
    if (valid)
    {
        const char* extension = strrchr(relative, '.');
        const bool source = extension != NULL && (strcmp(extension, ".c") == 0 || strcmp(extension, ".h") == 0 || strcmp(extension, ".inc") == 0);
        licensed = source && strstr(text, "SPDX-License-Identifier:") == NULL;
        static const char license[] = "// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception\n"
                                      "// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.\n";
        valid = !licensed || fwrite(license, 1, sizeof(license) - 1, output) == sizeof(license) - 1;
        valid = valid && fwrite(text, 1, bytes, output) == bytes;
        const size_t total = bytes + (licensed ? sizeof(license) - 1 : 0);
        valid = valid && fprintf(report, "%s\t%ld\t%zu\t%s\t%s\n", relative, length, total,
                                 licensed ? "SPDX comments added" : "unchanged header", relocated ? "helper include relocated" : "unchanged content") > 0;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    if (!valid)
    {
        fprintf(stderr, "could not package %s\n", from);
    }
    free(text);
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 4;
    FILE* manifest = valid ? fopen(argv[3], "rb") : NULL;
    char report_path[4096];
    const int named = valid ? snprintf(report_path, sizeof(report_path), "%s/packaging.tsv", argv[2]) : -1;
    valid = valid && manifest != NULL && named > 0 && (size_t)named < sizeof(report_path) && parents(report_path);
    FILE* report = valid ? fopen(report_path, "wb") : NULL;
    valid = valid && report != NULL;
    if (valid)
    {
        fprintf(report, "path\toriginal_bytes\tpackaged_bytes\tlicense\tcontent\n");
    }
    char relative[2048];
    unsigned count = 0;
    while (valid && fgets(relative, sizeof(relative), manifest) != NULL)
    {
        const size_t length = strlen(relative);
        valid = length != 0 && relative[length - 1] == '\n' && relative[0] != '/' && strstr(relative, "..") == NULL;
        if (valid)
        {
            relative[length - 1] = 0;
            char from[4096];
            char to[4096];
            const int from_length = snprintf(from, sizeof(from), "%s/%s", argv[1], relative);
            const int to_length = snprintf(to, sizeof(to), "%s/%s", argv[2], relative);
            valid = from_length > 0 && (size_t)from_length < sizeof(from) && to_length > 0 && (size_t)to_length < sizeof(to) &&
                    package(from, to, relative, report);
            count += valid;
        }
    }
    if (manifest != NULL)
    {
        valid = !ferror(manifest) && fclose(manifest) == 0 && valid;
    }
    if (report != NULL)
    {
        valid = fclose(report) == 0 && valid;
    }
    printf("packaged %u files: %s\n", count, valid ? "success" : "failure");
    return valid ? 0 : 1;
}
