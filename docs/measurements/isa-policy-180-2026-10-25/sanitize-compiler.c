// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
// Original driver adapter: append sanitizer flags to every build.sh compile/link.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    int status = 1;
    static const char* const flags[] =
    {
        "-O1",
        "-fsanitize=address,undefined",
        "-fno-omit-frame-pointer",
        "-fno-sanitize-recover=all",
    };
    if (argc > 0 && argc <= 4096)
    {
        const size_t count = sizeof(flags) / sizeof(flags[0]);
        char** arguments = calloc((size_t)argc + count + 1, sizeof(*arguments));
        if (arguments != 0)
        {
            arguments[0] = "/usr/bin/clang";
            for (int i = 1; i < argc; i += 1)
            {
                arguments[i] = argv[i];
            }
            for (size_t i = 0; i < count; i += 1)
            {
                arguments[(size_t)argc + i] = (char*)flags[i];
            }
            execv(arguments[0], arguments);
            perror("sanitizer clang exec");
            free(arguments);
        }
    }
    return status;
}
