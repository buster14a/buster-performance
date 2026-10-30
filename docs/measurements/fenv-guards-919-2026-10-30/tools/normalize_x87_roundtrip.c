// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Preserve the original object's DC C0 encoding of the unique ambiguous printed
// FADD ST(0),ST(0) in check_test_action_constraints. Clang's assembly printer
// emits a spelling that its assembler encodes D8 C0 instead. This adapter only
// changes that one textual line; whole zero-object equality is mandatory after
// assembly and is stronger than merely asserting the two encodings equivalent.
#define _POSIX_C_SOURCE 200809L
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    bool valid = argc == 3;
    FILE* input = valid ? fopen(argv[1], "rb") : NULL;
    FILE* output = input != NULL ? fopen(argv[2], "wbx") : NULL;
    valid = valid && input != NULL && output != NULL;
    char* line = NULL;
    size_t capacity = 0;
    ssize_t length;
    bool in_function = false;
    unsigned int replacements = 0;
    unsigned int functions = 0;
    unsigned long line_number = 0;
    unsigned long replaced_line = 0;
    while (valid && (length = getline(&line, &capacity, input)) >= 0)
    {
        line_number += 1;
        if (strncmp(line, "check_test_action_constraints:", strlen("check_test_action_constraints:")) == 0)
        {
            in_function = true;
            functions += 1;
        }
        if (strncmp(line, ".Lfunc_end", strlen(".Lfunc_end")) == 0)
        {
            in_function = false;
        }
        const char* printed = "\tfadd\t%st, %st(0)\n";
        if (strcmp(line, printed) == 0)
        {
            valid = in_function && replacements == 0;
            if (valid)
            {
                replacements += 1;
                replaced_line = line_number;
                const char* encoded = "\t.byte\t0xdc, 0xc0\n";
                valid = fwrite(encoded, 1, strlen(encoded), output) == strlen(encoded);
            }
        }
        else
        {
            valid = fwrite(line, 1, (size_t)length, output) == (size_t)length;
        }
    }
    valid = valid && functions == 1 && replacements == 1;
    if (input != NULL)
    {
        valid = !ferror(input) && fclose(input) == 0 && valid;
    }
    if (output != NULL)
    {
        valid = !ferror(output) && fclose(output) == 0 && valid;
    }
    free(line);
    if (valid)
    {
        printf("{\"passed\":true,\"function\":\"check_test_action_constraints\",\"replacements\":%u,\"line\":%lu,\"required_original_bytes\":\"dcc0\",\"zero_object_equality_required\":true}\n", replacements, replaced_line);
    }
    else
    {
        fprintf(stderr, "x87 normalization refused: expected one exact line in one expected function; usage: normalize_x87_roundtrip INPUT OUTPUT\n");
        if (argc == 3 && output != NULL)
        {
            remove(argv[2]);
        }
    }
    return valid ? 0 : 1;
}
