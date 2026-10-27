// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #598 measurement input generator. No external source fixtures.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    const unsigned n = argc == 3 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    int status = n < 2 || n > 1000000;
    if (!status && strcmp(argv[1], "string") == 0)
    {
        printf("unsigned initialized(unsigned i){unsigned char a[%u]=\"", n);
        for (unsigned i = 0; i + 1 < n; i += 1)
        {
            putchar('a' + i % 26);
        }
        printf("\";return a[i%%%u];}\n", n);
    }
    else if (!status && strcmp(argv[1], "list") == 0)
    {
        printf("unsigned initialized(unsigned i){unsigned a[%u]={", n);
        for (unsigned i = 0; i < n; i += 1)
        {
            printf("%s%u", i ? "," : "", (i * 7 + 1) % 65536);
        }
        printf("};return a[i%%%u];}\n", n);
    }
    else
    {
        status = 1;
    }
    return status || ferror(stdout);
}
