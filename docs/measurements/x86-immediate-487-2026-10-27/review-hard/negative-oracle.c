// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Negative control: retain the expected status and location but substitute an unrelated diagnostic.
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    bool quiet = false;
    for (int i = 1; i < argc; i += 1)
    {
        quiet |= strcmp(argv[i], "-w") == 0;
    }
    const char* source = NULL;
    for (int i = 1; quiet && source == NULL && i < argc; i += 1)
    {
        const size_t length = strlen(argv[i]);
        FILE* file = length >= 2 && strcmp(argv[i] + length - 2, ".c") == 0 ? fopen(argv[i], "r") : NULL;
        char line[2048];
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            if (strstr(line, "unsigned f(V a,int n){return __builtin_ia32_cmpb128_mask(a,a,n,65535);}") != NULL)
            {
                source = argv[i];
            }
        }
        if (file != NULL)
        {
            fclose(file);
        }
    }
    int result = 1;
    if (source != NULL)
    {
        fprintf(stderr, "%s:4:30: error: injected unrelated diagnostic\n", source);
    }
    else
    {
        argv[0] = "/usr/bin/clang";
        execv(argv[0], argv);
        perror("execv clang");
        result = 127;
    }
    return result;
}
