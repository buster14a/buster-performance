// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Diagnostic driver: append the frozen x86_target_test_gas function and the main below to this preamble.
// It isolates the repository's exact architecture differential from unrelated frontend/backend compilation.
#include <errno.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wmissing-field-initializers"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_64_encoder_test.c"
#include "buster/compiler/x86_target_forms.c"
#pragma clang diagnostic pop

static bool pp_test_read_output(FILE* file, char** text, size_t* length)
{
    bool passed = fflush(file) == 0 && fseek(file, 0, SEEK_END) == 0;
    const long bytes = passed ? ftell(file) : -1;
    passed &= bytes >= 0 && bytes < 16 * 1024 * 1024;
    char* buffer = passed ? malloc((size_t)bytes + 1) : 0;
    passed &= buffer != 0;
    if (passed)
    {
        passed = fseek(file, 0, SEEK_SET) == 0 && fread(buffer, 1, (size_t)bytes, file) == (size_t)bytes && !ferror(file);
    }
    if (passed)
    {
        buffer[bytes] = 0;
        *text = buffer;
        *length = (size_t)bytes;
    }
    else
    {
        free(buffer);
    }
    return passed;
}
