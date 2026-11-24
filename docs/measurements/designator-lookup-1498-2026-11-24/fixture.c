// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and THIRD_PARTY_NOTICES.md.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static unsigned field_value(unsigned field, unsigned row)
{
    return (field + 13 * row) % 251 + 1;
}

int main(int argc, char** argv)
{
    if (argc != 5)
    {
        return 1;
    }
    const unsigned fields = (unsigned)strtoul(argv[1], NULL, 10);
    const unsigned rows = (unsigned)strtoul(argv[2], NULL, 10);
    const unsigned group = (unsigned)strtoul(argv[3], NULL, 10);
    if (fields == 0 || fields > 65536 || rows == 0 || rows > 512 || group > fields || (group && fields % group))
    {
        return 1;
    }
    if (strcmp(argv[4], "bytes") == 0)
    {
        for (unsigned row = 0; row < rows; row++)
        {
            for (unsigned i = 0; i < fields; i++)
            {
                putchar((int)field_value(i, row));
            }
        }
    }
    else if (strcmp(argv[4], "source") == 0)
    {
        puts("struct Record {");
        for (unsigned i = 0; i < fields; i++)
        {
            if (group && i % group == 0)
            {
                puts("struct {");
            }
            printf("unsigned char f%u;\n", i);
            if (group && i % group == group - 1)
            {
                puts("};");
            }
        }
        printf("};\nstruct Record records[%u] = {\n", rows);
        for (unsigned row = 0; row < rows; row++)
        {
            puts("{");
            for (unsigned i = fields; i > 0; i--)
            {
                printf(".f%u = %u,\n", i - 1, field_value(i - 1, row));
            }
            puts("},");
        }
        puts("};");
    }
    else
    {
        return 1;
    }
    return fflush(stdout) == EOF || ferror(stdout);
}
