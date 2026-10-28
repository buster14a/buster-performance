// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original source equivalent of the pool-only exact-work fixture.
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv)
{
    const unsigned count = argc == 2 ? (unsigned)strtoul(argv[1], NULL, 10) : 32;
    for (unsigned i = 0; i < count; i += 1)
    {
        printf("struct R%u { char bytes[131]; };\n", i);
    }
    for (unsigned i = 0; i < count; i += 1)
    {
        printf("int f%u(void) { struct R%u value = {\"", i, i);
        for (unsigned b = 0; b < 130; b += 1)
        {
            putchar('a' + b % 26);
        }
        printf("\"}; return value.bytes[0] + value.bytes[130]; }\n");
    }
    return ferror(stdout) != 0;
}
