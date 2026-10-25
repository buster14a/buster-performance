// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// External c-testsuite adapter: preserve its arguments, adding one explicit generated-code ISA. This is an evidence
// harness, not compiler production code. Build on the approved 9700X under its shared lock.
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    const char* compiler = getenv("ISA180_COMPILER");
    const char* profile = getenv("ISA180_PROFILE");
    const bool valid = compiler != 0 && profile != 0 &&
        (strcmp(profile, "x86-64") == 0 || strcmp(profile, "x86-64-v3") == 0 || strcmp(profile, "x86-64-v4") == 0);
    int result = 2;
    char** arguments = valid ? calloc((size_t)argc + 2, sizeof(char*)) : 0;
    if (arguments != 0)
    {
        char march[64];
        snprintf(march, sizeof(march), "-march=%s", profile);
        arguments[0] = (char*)compiler;
        arguments[1] = march;
        for (int i = 1; i < argc; i += 1)
        {
            arguments[i + 1] = argv[i];
        }
        execv(compiler, arguments);
        perror("profile compiler");
        result = 127;
    }
    else
    {
        fprintf(stderr, "set ISA180_COMPILER to an absolute compiler path and ISA180_PROFILE to x86-64, x86-64-v3 or x86-64-v4\n");
    }
    free(arguments);
    return result;
}
