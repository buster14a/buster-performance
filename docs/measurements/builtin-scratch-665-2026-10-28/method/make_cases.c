// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original generated builtin stress inputs for issue665; no external source is copied.
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

int main(int argc, char** argv)
{
    int status = argc == 2 ? 0 : 1;
    const unsigned counts[] = { 1, 64, 1000, 2000, 4000, 8000 };
    const char* recipes[] = { "add", "sub", "mul", "popcount", "wide" };
    for (unsigned recipe = 0; status == 0 && recipe < sizeof(recipes) / sizeof(*recipes); recipe += 1)
    {
        for (unsigned size = 0; status == 0 && size < sizeof(counts) / sizeof(*counts); size += 1)
        {
            char path[4096];
            snprintf(path, sizeof(path), "%s/%s-%u.c", argv[1], recipes[recipe], counts[size]);
            FILE* file = fopen(path, "w");
            if (file == NULL)
            {
                status = 1;
            }
            else
            {
                fprintf(file, "unsigned tested(int x){unsigned y=(unsigned)x;\n");
                for (unsigned call = 0; call < counts[size]; call += 1)
                {
                    if (recipe < 3)
                    {
                        fprintf(file, "{int r;if(__builtin_%s_overflow(x,%u,&r))y+=1;else y+=(unsigned)r;}\n", recipes[recipe], call * 127u + 1u);
                    }
                    else if (recipe == 3)
                    {
                        fprintf(file, "y+=(unsigned)__builtin_popcount((unsigned)x+%u);\n", call);
                    }
                    else
                    {
                        fprintf(file, "{__int128 r;unsigned __int128 a=(unsigned __int128)(unsigned)x<<96;"
                                      "if(__builtin_mul_overflow(a,(__int128)%u,&r))y+=1;else y+=(unsigned)r;}\n", call * 127u + 1u);
                    }
                }
                fprintf(file, "return y;}\n");
                status = fclose(file) != 0 ? 1 : status;
            }
        }
    }
    if (status == 0)
    {
        char path[4096];
        snprintf(path, sizeof(path), "%s/many-bodies.c", argv[1]);
        FILE* file = fopen(path, "w");
        if (file == NULL)
        {
            status = 1;
        }
        else
        {
            for (unsigned body = 0; body < 8; body += 1)
            {
                fprintf(file, "static unsigned part%u(int x){unsigned y=(unsigned)x;\n", body);
                for (unsigned call = 0; call < 512; call += 1)
                {
                    fprintf(file, "{int r;if(__builtin_mul_overflow(x,%u,&r))y+=1;else y+=(unsigned)r;"
                                  "y+=(unsigned)__builtin_popcount(y);}\n", call * 127u + body);
                }
                fprintf(file, "return y;}\n");
            }
            fprintf(file, "unsigned tested(int x){unsigned y=0;");
            for (unsigned body = 0; body < 8; body += 1)
            {
                fprintf(file, "y+=part%u(x);", body);
            }
            fprintf(file, "return y;}\n");
            status = fclose(file) != 0 ? 1 : status;
        }
    }
    return status;
}
