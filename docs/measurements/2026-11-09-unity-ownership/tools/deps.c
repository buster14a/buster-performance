// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

typedef struct File File;
struct File { char* path; uint64_t mask[2]; };
static File files[16384];
static char* units[64];
static uint32_t count;
static uint32_t unit_count;

static void read_graph(const char* path, uint32_t graph)
{
    FILE* input = fopen(path, "r");
    if (input == 0) { perror(path); exit(2); }
    char* line = 0;
    size_t capacity = 0;
    uint64_t owner = 0;
    while (getline(&line, &capacity, input) > 0)
    {
        line[strcspn(line, "\n")] = 0;
        if (line[0] != ' ')
        {
            owner = 0;
            char* marker = strstr(line, ": #deps ");
            if (marker != 0 && strstr(line, "/Release/") != 0)
            {
                *marker = 0;
                char* name = strrchr(line, '/') + 1;
                uint32_t unit = 0;
                while (unit < unit_count && strcmp(units[unit], name) != 0) { unit += 1; }
                if (unit == unit_count) { units[unit_count++] = strdup(name); }
                owner = UINT64_C(1) << unit;
            }
        }
        else if (owner != 0)
        {
            char* name = line + strspn(line, " ");
            const char* local = strstr(name, "/src/");
            if (local != 0) { name = (char*)local + 1; }
            uint32_t file = 0;
            while (file < count && strcmp(files[file].path, name) != 0) { file += 1; }
            if (file == count) { files[count++].path = strdup(name); }
            files[file].mask[graph] |= owner;
        }
    }
    free(line);
    fclose(input);
}

static void names(uint64_t mask)
{
    for (uint32_t i = 0; i < unit_count; i += 1)
    {
        if ((mask & (UINT64_C(1) << i)) != 0) { printf("%s,", units[i]); }
    }
}

int main(int argc, char** argv)
{
    if (argc != 2 && argc != 3) { return 2; }
    read_graph(argv[1], 0);
    if (argc == 3) { read_graph(argv[2], 1); }
    uint64_t removed = 0;
    uint64_t added = 0;
    int64_t work = 0;
    uint64_t changed = 0;
    uint64_t source_bytes = 0;
    for (uint32_t i = 0; i < count; i += 1)
    {
        const File* file = &files[i];
        const uint32_t old = (uint32_t)__builtin_popcountll(file->mask[0]);
        const uint32_t now = (uint32_t)__builtin_popcountll(file->mask[1]);
        struct stat status = { 0 };
        stat(file->path, &status);
        if (argc == 2 || file->mask[0] != file->mask[1])
        {
            printf("%s\t%ld\t%u\t%u\t", file->path, status.st_size, old, now);
            names(file->mask[0]);
            printf("\t");
            names(file->mask[1]);
            printf("\n");
            changed += 1;
            source_bytes += (uint64_t)status.st_size;
            removed += (uint64_t)__builtin_popcountll(file->mask[0] & ~file->mask[1]);
            added += (uint64_t)__builtin_popcountll(file->mask[1] & ~file->mask[0]);
            if (strncmp(file->path, "src/", 4) == 0)
            {
                work += status.st_size * ((int64_t)old - (int64_t)now);
            }
        }
    }
    fprintf(stderr, "%u units, %lu changed paths, %lu bytes in changed paths, %lu edges removed, %lu edges added, %ld fewer repeated source bytes\n",
            unit_count, changed, source_bytes, removed, added, work);
    for (uint32_t unit = 0; unit < unit_count; unit += 1)
    {
        uint64_t bytes = 0;
        uint32_t dependencies = 0;
        for (uint32_t i = 0; i < count; i += 1)
        {
            if (strncmp(files[i].path, "src/", 4) == 0 && (files[i].mask[argc == 3] & (UINT64_C(1) << unit)) != 0)
            {
                struct stat status = { 0 };
                stat(files[i].path, &status);
                bytes += (uint64_t)status.st_size;
                dependencies += 1;
            }
        }
        fprintf(stderr, "%s %u dependencies %lu source bytes\n", units[unit], dependencies, bytes);
    }
    return 0;
}
