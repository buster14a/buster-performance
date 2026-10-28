// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #657 nested-control fixtures. No external source is incorporated.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int status = 1;
    if (argc == 4)
    {
        const unsigned depth = (unsigned)strtoul(argv[2], 0, 10);
        const int region = strcmp(argv[3], "region") == 0;
        const int switches = strcmp(argv[1], "switch") == 0;
        const int outward = strcmp(argv[1], "outward") == 0;
        printf("int f(int x){%sint y=0;top:;\n", region ? "return ({" : "");
        for (unsigned i = 0; i < depth; i += 1)
        {
            if (switches)
            {
                printf("switch(x&%u){case 0:y+=%u;\n", (i & 7) + 1, i & 3);
            }
            else if (outward)
            {
                printf("{if(x<0)goto top;y+=%u;\n", i & 3);
            }
            else
            {
                printf("{label_%u:if(x<0)goto label_%u;y+=%u;\n", i, i, i & 3);
            }
        }
        for (unsigned i = 0; i < depth; i += 1)
        {
            puts(switches ? "break;default:y-=1;}" : "}");
        }
        puts(region ? "y;});}" : "return y;}");
        status = ferror(stdout) ? 1 : 0;
    }
    return status;
}
