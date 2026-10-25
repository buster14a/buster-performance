// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original log publication filter. Copyright (c) 2026 David Gonzalez Martin.
#define _POSIX_C_SOURCE 200809L
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool public_copy(const char* directory, const char* path)
{
    const char* leaf = strrchr(path, '/');
    leaf = leaf != NULL ? leaf + 1 : path;
    const size_t size = strlen(directory) + strlen(leaf) + 2;
    char* destination = malloc(size);
    FILE* input = fopen(path, "r");
    FILE* output = NULL;
    bool valid = destination != NULL && input != NULL;
    if (valid)
    {
        snprintf(destination, size, "%s/%s", directory, leaf);
        output = fopen(destination, "w");
        valid = output != NULL;
    }
    char* line = NULL;
    size_t capacity = 0;
    bool lock_block = false;
    unsigned removed = 0;
    while (valid && getline(&line, &capacity, input) >= 0)
    {
        const bool owner = strncmp(line, "exclusive.sh: waiting", 21) == 0;
        const bool continuation = lock_block && (strncmp(line, "  title:", 8) == 0 || strncmp(line, "  link:", 7) == 0 || strncmp(line, "  pull request:", 15) == 0);
        if (owner || continuation)
        {
            lock_block = true;
            removed += 1;
        }
        else
        {
            lock_block = false;
            const size_t length = strlen(line);
            valid = fwrite(line, 1, length, output) == length;
        }
    }
    if (input != NULL)
    {
        valid = !ferror(input) && valid;
        valid = fclose(input) == 0 && valid;
    }
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    fprintf(stderr, "%s: %s; removed %u lock-owner lines\n", path, valid ? "copied" : "FAILED", removed);
    free(line);
    free(destination);
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc >= 3;
    for (int i = 2; i < argc; i += 1)
    {
        valid = public_copy(argv[1], argv[i]) && valid;
    }
    return valid ? 0 : 1;
}
