// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Produce a temporary single-unit test adapter from a frozen main.c, leaving compiler module bodies untouched.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    FILE* source = argc == 3 ? fopen(argv[1], "r") : NULL;
    FILE* output = source != NULL ? fopen(argv[2], "w") : NULL;
    bool valid = source != NULL && output != NULL;
    bool ended = false;
    unsigned replacements = 0;
    char* line = NULL;
    size_t capacity = 0;
    while (valid && !ended && getline(&line, &capacity, source) >= 0)
    {
        ended = strncmp(line, "static int main_command(", strlen("static int main_command(")) == 0;
        if (!ended)
        {
            const bool home = strcmp(line, "#define BUSTER_ELSEWHERE inline __attribute__((noinline))\n") == 0;
            const char* text = home ? "#define BUSTER_ELSEWHERE\n" : line;
            valid = fputs(text, output) >= 0;
            replacements += home;
        }
    }
    valid = valid && ended && replacements == 1 && !ferror(source);
    free(line);
    if (output != NULL)
    {
        valid = fclose(output) == 0 && valid;
    }
    if (source != NULL)
    {
        valid = fclose(source) == 0 && valid;
    }
    return valid ? 0 : 1;
}
