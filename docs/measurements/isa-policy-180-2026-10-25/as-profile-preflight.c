// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original diagnostic-only adapter. Preflight the corrected GAS SSE3/FISTTP taxonomy against an already built
// compiler before another complete build. Final compiler qualification uses /usr/bin/as directly, without this.
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    char* replacement = 0;
    bool valid = true;
    for (int i = 1; valid && i < argc; i += 1)
    {
        static const char prefix[] = "-march=generic64+sse3";
        if (strncmp(argv[i], prefix, sizeof(prefix) - 1) == 0 && (argv[i][sizeof(prefix) - 1] == '+' || argv[i][sizeof(prefix) - 1] == 0))
        {
            valid = replacement == 0;
            if (valid)
            {
                static const char cpu[] = "-march=nocona+nomonitor+sse3";
                const char* tail = argv[i] + sizeof(prefix) - 1;
                const size_t length = strlen(tail) + 1;
                replacement = malloc(sizeof(cpu) - 1 + length);
                valid = replacement != 0;
                if (valid)
                {
                    memcpy(replacement, cpu, sizeof(cpu) - 1);
                    memcpy(replacement + sizeof(cpu) - 1, tail, length);
                    argv[i] = replacement;
                }
            }
        }
    }
    if (valid)
    {
        execv("/usr/bin/as", argv);
        perror("as profile preflight");
    }
    free(replacement);
    return 1;
}
