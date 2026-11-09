// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#define _GNU_SOURCE
#include <dirent.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
int main(int argc, char** argv)
{
    if (argc != 2) { return 1; }
    char root[PATH_MAX];
    if (getcwd(root, sizeof(root)) == 0) { return 2; }
    DIR* directory = opendir(argv[1]);
    if (directory == 0) { return 3; }
    for (struct dirent* entry = readdir(directory); entry != 0; entry = readdir(directory))
    {
        const char* tail = strstr(entry->d_name, ".znver5.d");
        if (tail == 0 || tail[9] != 0) { continue; }
        char name[256];
        snprintf(name, sizeof(name), "%.*s", (int)(tail - entry->d_name), entry->d_name);
        char path[PATH_MAX];
        snprintf(path, sizeof(path), "%s/%s", argv[1], entry->d_name);
        FILE* file = fopen(path, "r");
        if (file == 0) { return 4; }
        fseek(file, 0, SEEK_END);
        const size_t size = (size_t)ftell(file);
        rewind(file);
        char* text = calloc(size + 1, 1);
        if (text == 0 || fread(text, 1, size, file) != size) { return 5; }
        fclose(file);
        for (size_t i = 0; i < size; i += 1) { if (text[i] == '\\' && text[i + 1] == '\n') { text[i] = ' '; } }
        char* colon = strchr(text, ':');
        if (colon == 0) { return 6; }
        char* paths[4096];
        unsigned count = 0;
        char* saved = 0;
        for (char* word = strtok_r(colon + 1, " \t\r\n", &saved); word != 0; word = strtok_r(0, " \t\r\n", &saved))
        {
            if (count == 4096) { return 7; }
            paths[count++] = word;
        }
        printf("CMakeFiles/buster_%.*s.dir/Release/src/buster/compiler/%s.o: #deps %u, deps mtime 1 (VALID)\n", (int)strlen(name) - 2, name, name, count);
        for (unsigned i = 0; i < count; i += 1)
        {
            printf("    %s%s%s\n", paths[i][0] == '/' ? "" : root, paths[i][0] == '/' ? "" : "/", paths[i]);
        }
        putchar('\n');
        free(text);
    }
    closedir(directory);
    return 0;
}
