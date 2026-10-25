// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original bounded C workload for compiler -> assembly -> section/CFI -> ELF measurements. It is synthetic;
// the independently executed GCC/Clang correctness corpus is retained separately, with its own source hashes.
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    int result = 1;
    char* end = 0;
    const unsigned long count = argc == 3 ? strtoul(argv[1], &end, 10) : 0;
    FILE* output = count != 0 && count <= 4096 && end != 0 && *end == 0 ? fopen(argv[2], "w") : 0;
    if (output != 0)
    {
        int written = fprintf(output, "/* Original generated measurement input, Apache-2.0 WITH LLVM-exception. */\nextern long stage_external(long);\n");
        for (unsigned long i = 0; written >= 0 && i < count; i += 1)
        {
            written = fprintf(output, "long stage_%lu(long x)\n{\n    long y = stage_external(x + %lu);\n    if (y < %lu)\n    {\n        y -= x;\n    }\n    return (y ^ %lu) + %lu;\n}\n", i, i + 17, i + 11, i * 37 + 3, i);
        }
        const int closed = fclose(output);
        result = written >= 0 && closed == 0 ? 0 : 1;
    }
    return result;
}
