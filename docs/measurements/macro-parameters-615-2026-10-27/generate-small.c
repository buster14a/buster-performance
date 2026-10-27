// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original ordinary-macro controls: COUNT definitions/invocations, PARAMETERS names each.
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    const unsigned parameters = argc == 3 ? (unsigned)strtoul(argv[1], 0, 10) : 5;
    const unsigned count = argc == 3 ? (unsigned)strtoul(argv[2], 0, 10) : 0;
    int result = parameters <= 4 && count != 0 ? 0 : 2;
    for (unsigned macro = 0; result == 0 && macro < count; macro += 1)
    {
        printf("#define F%u(", macro);
        for (unsigned p = 0; p < parameters; p += 1)
        {
            printf("%sp%u", p != 0 ? "," : "", p);
        }
        printf(") ");
        if (parameters == 0)
        {
            printf("1");
        }
        for (unsigned p = 0; p < parameters; p += 1)
        {
            printf("%sp%u", p != 0 ? "+" : "", p);
        }
        printf("\nF%u(", macro);
        for (unsigned p = 0; p < parameters; p += 1)
        {
            printf("%s%u", p != 0 ? "," : "", p + 1);
        }
        printf(")\n");
    }
    result = ferror(stdout) ? 1 : result;
    return result;
}
