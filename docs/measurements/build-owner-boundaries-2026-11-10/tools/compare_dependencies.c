// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Compare complete collect_build_inputs captures. Report changed repository
// dependency edges and exact source owners, including standalone consumers.
#define _POSIX_C_SOURCE 200809L
#include <ctype.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Dependency Dependency;
struct Dependency
{
    char* path;
    uint64_t owners[2];
};

static Dependency dependencies[8192];
static uint32_t dependency_count;

static char* read_all(const char* path, size_t* length)
{
    FILE* file = fopen(path, "rb");
    if (file == NULL || fseek(file, 0, SEEK_END) != 0)
    {
        perror(path);
        exit(1);
    }
    const long size = ftell(file);
    if (size < 0 || size > 16 * 1024 * 1024 || fseek(file, 0, SEEK_SET) != 0)
    {
        fprintf(stderr, "invalid file size: %s\n", path);
        exit(1);
    }
    char* text = calloc((size_t)size + 1, 1);
    if (text == NULL || fread(text, 1, (size_t)size, file) != (size_t)size || fclose(file) != 0)
    {
        fprintf(stderr, "cannot read: %s\n", path);
        exit(1);
    }
    *length = (size_t)size;
    return text;
}

static int compare_paths(const void* a, const void* b)
{
    return strcmp(((const Dependency*)a)->path, ((const Dependency*)b)->path);
}

static void print_owners(uint64_t mask, char** sources, uint32_t count)
{
    bool first = true;
    for (uint32_t i = 0; i < count; i += 1)
    {
        if ((mask & (UINT64_C(1) << i)) != 0)
        {
            const char* base = strrchr(sources[i], '/');
            printf("%s%s", first ? "" : " ", base != NULL ? base + 1 : sources[i]);
            first = false;
        }
    }
}

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        fprintf(stderr, "usage: compare-dependencies BASE_CAPTURE CANDIDATE_CAPTURE\n");
        exit(2);
    }
    char* sources[64];
    uint32_t source_count = 0;
    char* inventories[2];
    size_t sizes[2];
    for (uint32_t role = 0; role < 2; role += 1)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/sources.argv", argv[role + 1]);
        inventories[role] = read_all(path, &sizes[role]);
    }
    if (sizes[0] != sizes[1] || memcmp(inventories[0], inventories[1], sizes[0]) != 0 || sizes[0] == 0 || inventories[0][sizes[0] - 1] != '\0')
    {
        fprintf(stderr, "source inventories differ or are invalid\n");
        exit(1);
    }
    for (size_t offset = 0; offset < sizes[0];)
    {
        if (source_count == 64 || inventories[0][offset] == '\0')
        {
            fprintf(stderr, "invalid source count\n");
            exit(1);
        }
        sources[source_count++] = inventories[0] + offset;
        offset += strlen(inventories[0] + offset) + 1;
    }
    for (uint32_t role = 0; role < 2; role += 1)
    {
        for (uint32_t source = 0; source < source_count; source += 1)
        {
            const char* base = strrchr(sources[source], '/');
            char path[4096];
            snprintf(path, sizeof(path), "%s/%s.d", argv[role + 1], base != NULL ? base + 1 : sources[source]);
            size_t length;
            char* text = read_all(path, &length);
            char* position = strchr(text, ':');
            if (position == NULL)
            {
                fprintf(stderr, "missing dependency target: %s\n", path);
                exit(1);
            }
            position += 1;
            while (*position != '\0')
            {
                while (isspace((unsigned char)*position) || *position == '\\')
                {
                    position += 1;
                }
                char* token = position;
                while (*position != '\0' && !isspace((unsigned char)*position) && *position != '\\')
                {
                    position += 1;
                }
                const char saved = *position;
                *position = '\0';
                if (strncmp(token, "src/", 4) == 0 || strncmp(token, "tests/", 6) == 0 || strncmp(token, "tools/", 6) == 0)
                {
                    uint32_t i = 0;
                    while (i < dependency_count && strcmp(dependencies[i].path, token) != 0)
                    {
                        i += 1;
                    }
                    if (i == dependency_count)
                    {
                        if (dependency_count == 8192 || (dependencies[i].path = strdup(token)) == NULL)
                        {
                            fprintf(stderr, "dependency inventory capacity exhausted\n");
                            exit(1);
                        }
                        dependency_count += 1;
                    }
                    dependencies[i].owners[role] |= UINT64_C(1) << source;
                }
                *position = saved;
                if (saved != '\0')
                {
                    position += 1;
                }
            }
            free(text);
        }
    }
    qsort(dependencies, dependency_count, sizeof(dependencies[0]), compare_paths);
    uint64_t edges[2] = { 0 };
    uint64_t removed = 0;
    uint64_t added = 0;
    uint32_t changed = 0;
    printf("path\tbase_count\tcandidate_count\tbase_owners\tcandidate_owners\n");
    for (uint32_t i = 0; i < dependency_count; i += 1)
    {
        const uint64_t a = dependencies[i].owners[0];
        const uint64_t b = dependencies[i].owners[1];
        edges[0] += (uint32_t)__builtin_popcountll(a);
        edges[1] += (uint32_t)__builtin_popcountll(b);
        removed += (uint32_t)__builtin_popcountll(a & ~b);
        added += (uint32_t)__builtin_popcountll(b & ~a);
        if (a != b)
        {
            changed += 1;
            printf("%s\t%d\t%d\t", dependencies[i].path, __builtin_popcountll(a), __builtin_popcountll(b));
            print_owners(a, sources, source_count);
            putchar('\t');
            print_owners(b, sources, source_count);
            putchar('\n');
        }
        free(dependencies[i].path);
    }
    fprintf(stderr, "sources=%u changed_paths=%u base_edges=%llu candidate_edges=%llu removed_edges=%llu added_edges=%llu\n",
            source_count, changed, (unsigned long long)edges[0], (unsigned long long)edges[1],
            (unsigned long long)removed, (unsigned long long)added);
    free(inventories[0]);
    free(inventories[1]);
    return 0;
}
