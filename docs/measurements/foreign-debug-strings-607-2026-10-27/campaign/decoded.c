// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Retain every decoded quoted value from llvm-dwarfdump's info/line output,
// independent of offsets and machine addresses printed outside the quotes.
#define _POSIX_C_SOURCE 200809L
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
int main(void)
{
    char* line = 0;
    size_t capacity = 0;
    ssize_t size = 0;
    bool valid = true;
    while (valid && (size = getline(&line, &capacity, stdin)) >= 0)
    {
        bool quoted = false;
        bool escape = false;
        for (ssize_t i = 0; i < size; i += 1)
        {
            const char byte = line[i];
            if (byte == '"' && !escape)
            {
                quoted = !quoted;
                putchar(byte);
                if (!quoted)
                {
                    putchar('\n');
                }
            }
            else if (quoted)
            {
                putchar(byte);
            }
            escape = quoted && byte == '\\' && !escape;
        }
        valid = !quoted;
    }
    valid = valid && !ferror(stdin) && !ferror(stdout);
    free(line);
    return valid ? 0 : 1;
}
