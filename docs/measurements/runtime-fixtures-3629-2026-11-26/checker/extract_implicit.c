// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        return 1;
    }
    FILE* input = fopen(argv[1], "rb");
    FILE* output = fopen(argv[2], "wb");
    if (input == NULL || output == NULL || fseek(input, 0, SEEK_END) != 0)
    {
        return 1;
    }
    const long size = ftell(input);
    char* text = size > 0 ? malloc((size_t)size + 1) : NULL;
    if (text == NULL || fseek(input, 0, SEEK_SET) != 0 || fread(text, 1, (size_t)size, input) != (size_t)size)
    {
        return 1;
    }
    text[size] = 0;
    const char* names[] = { "implicit_int_source", "implicit_int_program_source", "implicit_int_parameter_source" };
    for (unsigned i = 0; i < sizeof(names) / sizeof(names[0]); i += 1)
    {
        char declaration[128];
        snprintf(declaration, sizeof(declaration), "static const char %s[]", names[i]);
        const char* start = strstr(text, declaration);
        if (start == NULL)
        {
            return 1;
        }
        const char* end = start;
        int quoted = 0;
        while (*end != 0 && (quoted || *end != ';'))
        {
            if (quoted && *end == '\\' && end[1] != 0)
            {
                end += 2;
            }
            else
            {
                quoted ^= *end == '"';
                end += 1;
            }
        }
        if (*end != ';' || fwrite(start, 1, (size_t)(end - start) + 1, output) != (size_t)(end - start) + 1 || fputc('\n', output) == EOF)
        {
            return 1;
        }
    }
    free(text);
    return fclose(input) != 0 || fclose(output) != 0;
}
