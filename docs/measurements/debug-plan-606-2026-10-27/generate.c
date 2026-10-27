// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original #606 workloads: many small functions or many distinct lines per function, with unsigned operations.
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    int result = argc == 3 ? 0 : 1;
    if (result == 0)
    {
        const unsigned functions = (unsigned)strtoul(argv[1], NULL, 10);
        const unsigned rows = (unsigned)strtoul(argv[2], NULL, 10);
        for (unsigned function = 0; function < functions; function += 1)
        {
            printf("unsigned function_%u(unsigned x)\n{\n", function);
            for (unsigned row = 0; row < rows; row += 1)
            {
                printf("    x = (x ^ %uu) + %uu;\n", 1 + row % 127, 1 + (row * 17) % 1023);
            }
            puts("    return x;\n}");
        }
        result = ferror(stdout) != 0;
    }
    return result;
}
