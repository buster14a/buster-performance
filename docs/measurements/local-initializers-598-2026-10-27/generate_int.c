// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original signed-int reproduction of #598's brace-list comment, with a bounded input index.
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    const unsigned n = argc == 2 ? (unsigned)strtoul(argv[1], NULL, 10) : 0;
    int status = n < 2 || n > 1000000;
    if (!status)
    {
        printf("unsigned initialized(unsigned i){int a[%u]={", n);
        for (unsigned i = 0; i < n; i += 1)
        {
            printf("%s%u", i ? "," : "", i * 7 + 1);
        }
        printf("};return (unsigned)a[i%%%u];}\n", n);
    }
    return status || ferror(stdout);
}
