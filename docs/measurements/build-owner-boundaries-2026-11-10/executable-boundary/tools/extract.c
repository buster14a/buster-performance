// Original one-off extraction of reviewed contiguous source ranges.
#define _POSIX_C_SOURCE 200809L
#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    assert(argc == 4);
    FILE* source = fopen(argv[1], "rb");
    FILE* interface = fopen(argv[2], "wb");
    FILE* implementation = fopen(argv[3], "wb");
    assert(source && interface && implementation);
    fputs("// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception\n"
          "// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.\n"
          "// Private executable writer bodies. executable.c includes these for DYNAMIC, EXECUTABLE and standalone users.\n\n", implementation);
    char* text = 0;
    size_t capacity = 0;
    ssize_t bytes;
    unsigned line = 0;
    while ((bytes = getline(&text, &capacity, source)) >= 0)
    {
        line++;
        bool shared = line <= 656 || (line >= 662 && line <= 834) ||
                      (line >= 1483 && line <= 1536) || (line >= 2038 && line <= 2041) ||
                      (line >= 2851 && line <= 2940) ||
                      (line >= 7553 && line <= 7563);
        if (line == 655)
        {
            fputs("#if !defined(BUSTER_UNIT) || BUSTER_UNIT == BUSTER_UNIT_DYNAMIC || BUSTER_UNIT == BUSTER_UNIT_EXECUTABLE\n", interface);
            assert(fwrite(text, 1, (size_t)bytes, interface) == (size_t)bytes);
            fputs("#else\n"
                  "__attribute__((unused)) bool executable_write(Link* link, const ExecutableOptions* options, ExecutableResult* result);\n"
                  "#endif\n", interface);
        }
        else
        {
            FILE* output = shared ? interface : implementation;
            assert(fwrite(text, 1, (size_t)bytes, output) == (size_t)bytes);
        }
    }
    assert(!ferror(source));
    fputs("\n#if !defined(BUSTER_UNIT) || BUSTER_UNIT == BUSTER_UNIT_DYNAMIC || BUSTER_UNIT == BUSTER_UNIT_EXECUTABLE\n"
          "#include \"executable_impl.c\"\n#endif\n", interface);
    free(text);
    assert(fclose(source) == 0);
    assert(fclose(interface) == 0);
    assert(fclose(implementation) == 0);
    return 0;
}
