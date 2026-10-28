// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #658 large literal-array workload generator; no imported corpus.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int result = 1;
    if (argc == 4 && (strcmp(argv[1], "uchar") == 0 || strcmp(argv[1], "int") == 0 || strcmp(argv[1], "zero") == 0 ||
                     strcmp(argv[1], "ulongneg") == 0 || strcmp(argv[1], "invalid") == 0 || strcmp(argv[1], "volatile") == 0 || strcmp(argv[1], "float") == 0))
    {
        const unsigned count = (unsigned)strtoul(argv[2], NULL, 0);
        FILE* file = count != 0 && count <= 8000000 ? fopen(argv[3], "w") : NULL;
        if (file != NULL)
        {
            const bool integer = strcmp(argv[1], "int") == 0;
            const bool negative = strcmp(argv[1], "ulongneg") == 0;
            const bool invalid = strcmp(argv[1], "invalid") == 0;
            const bool floating = strcmp(argv[1], "float") == 0;
            const bool volatile_elements = strcmp(argv[1], "volatile") == 0;
            fprintf(file, "static const %s table[] = {\n", floating ? "float" : volatile_elements ? "volatile unsigned char" : negative ? "long" : integer ? "int" : "unsigned char");
            for (unsigned i = 0; i < count; i += 1)
            {
                const unsigned value = strcmp(argv[1], "zero") == 0 ? 0 : integer ? (i * UINT32_C(1664525) + UINT32_C(1013904223)) & INT32_MAX : (i * 37 + 13) & 255;
                if (floating)
                {
                    fprintf(file, "%u.25f%s", value, i + 1 == count ? "" : ",");
                }
                else if (negative)
                {
                    fprintf(file, "-5U%s", i + 1 == count ? "" : ",");
                }
                else if (invalid && i + 1 == count)
                {
                    fprintf(file, "1zz");
                }
                else if (integer)
                {
                    fprintf(file, "%u%s", value, i + 1 == count ? "" : ",");
                }
                else
                {
                    fprintf(file, "0x%02x%s", value, i + 1 == count ? "" : ",");
                }
                if (i % 12 == 11)
                {
                    fputc('\n', file);
                }
            }
            fprintf(file, "\n};\nint tested(unsigned n) { return table[n %% %u]; }\n", count);
            result = ferror(file) != 0;
            result |= fclose(file) != 0;
        }
    }
    else
    {
        fprintf(stderr, "usage: generate_table uchar|int|zero|ulongneg|invalid|volatile|float COUNT OUTPUT.c\n");
    }
    return result;
}
