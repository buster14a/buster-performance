// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #613 synthetic controls. The chain's declarations reproduce audit-generate.c from
// buster-performance 7d25666880d5bbdce838bab7e0f79a31d70d4c78; its retained notice and source are beside this file.
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    const char* shape = argc == 4 ? argv[1] : "";
    const unsigned count = argc == 4 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    const bool body = argc == 4 && strcmp(argv[3], "body") == 0;
    int result = 0;
    if (count == 0 || (strcmp(shape, "chain") != 0 && strcmp(shape, "reverse") != 0 && strcmp(shape, "wide") != 0 && strcmp(shape, "large-chain") != 0))
    {
        result = 2;
    }
    else
    {
        if (strcmp(shape, "reverse") == 0)
        {
            for (unsigned i = 0; i < count; i += 1)
            {
                printf("struct S%u;\n", i);
            }
            printf("struct S%u { int leaf; };\n", count - 1);
            for (unsigned i = count - 1; i > 0; i -= 1)
            {
                printf("struct S%u { struct S%u member; };\n", i - 1, i);
            }
        }
        else if (strcmp(shape, "chain") == 0 || strcmp(shape, "large-chain") == 0)
        {
            puts(strcmp(shape, "large-chain") == 0 ? "struct S0 { int leaf[32]; };" : "struct S0 { int leaf; };");
            for (unsigned i = 1; i < count; i += 1)
            {
                printf("struct S%u { struct S%u member; };\n", i, i - 1);
            }
        }
        else
        {
            for (unsigned i = 0; i < count; i += 1)
            {
                printf("struct S%u { int leaf; };\n", i);
            }
        }
        if (body)
        {
            const unsigned last = strcmp(shape, "reverse") == 0 ? 0 : count - 1;
            printf("struct S%u identity(struct S%u value) { return value; }\n", last, last);
        }
    }
    result = ferror(stdout) ? 1 : result;
    return result;
}
