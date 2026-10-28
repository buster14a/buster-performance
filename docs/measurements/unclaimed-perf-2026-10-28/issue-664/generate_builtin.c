// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #664 scaling input generator. No third-party input or implementation.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int result = 1;
    if (argc == 4 && (strcmp(argv[1], "popcount") == 0 || strcmp(argv[1], "overflow") == 0 || strcmp(argv[1], "expect") == 0))
    {
        const unsigned count = (unsigned)strtoul(argv[2], 0, 0);
        FILE* file = fopen(argv[3], "w");
        if (file != 0 && count != 0 && count <= 100000)
        {
            fprintf(file, "unsigned probe(unsigned x)\n{\n    unsigned y = 0;\n");
            for (unsigned i = 0; i < count; i += 1)
            {
                if (strcmp(argv[1], "popcount") == 0)
                {
                    fprintf(file, "    y += __builtin_popcount(x + %uu);\n", i);
                }
                else if (strcmp(argv[1], "overflow") == 0)
                {
                    fprintf(file, "    { unsigned r; if (__builtin_add_overflow(x, %uu, &r)) y += 1; else y += r; }\n", i);
                }
                else
                {
                    fprintf(file, "    y += __builtin_expect(x + %uu, 0);\n", i);
                }
            }
            fprintf(file, "    return y;\n}\n");
            result = ferror(file) == 0 && fclose(file) == 0 ? 0 : 1;
        }
        else if (file != 0)
        {
            fclose(file);
        }
    }
    else
    {
        fprintf(stderr, "usage: generate_builtin popcount|overflow|expect COUNT OUTPUT.c\n");
    }
    return result;
}
