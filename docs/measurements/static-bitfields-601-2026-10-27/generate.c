// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #601 measurement input generator; no external fixture source.
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

static bool generate(const char* directory, const char* name, uint32_t count, uint32_t kind)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/%s-%u.c", directory, name, count);
    FILE* output = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "w") : NULL;
    bool valid = output != NULL;
    if (valid)
    {
        if (kind == 0 || kind == 4)
        {
            fputs("struct B{unsigned a:31;unsigned b:31;};\n", output);
        }
        else if (kind == 1)
        {
            fputs("struct __attribute__((packed)) B{unsigned a:3;long long b:64;unsigned c:5;};\n", output);
        }
        else if (kind == 2)
        {
            fputs("struct __attribute__((packed)) B{unsigned a:3;unsigned __int128 b:128;unsigned c:5;};\n", output);
        }
        else
        {
            fputs("struct __attribute__((packed)) B{unsigned a:7,b:8,c:9,d:15,e:16,f:17,g:31;unsigned long long h:32,i:33,j:63,k:64;};\n", output);
        }
        fprintf(output, "struct B data[%u]={\n", count);
        for (uint32_t i = 0; i < count; i += 1)
        {
            if (kind == 0)
            {
                fputs("{1,2},\n", output);
            }
            else if (kind == 1)
            {
                fputs("{5,-3,19},\n", output);
            }
            else if (kind == 2)
            {
                fputs("{5,-1,19},\n", output);
            }
            else if (kind == 4)
            {
                fputs("{.a=1,.b=2,.a={}},\n", output);
            }
            else
            {
                fputs("{1,2,3,4,5,6,7,8,9,10,11},\n", output);
            }
        }
        fputs("};\n", output);
        valid = !ferror(output);
        valid = fclose(output) == 0 && valid;
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    const uint32_t counts[] = {1024,4096,16384,65536};
    for (uint32_t i = 0; valid && i < 4; i += 1)
    {
        valid = generate(argv[1], "plain", counts[i], 0);
    }
    valid = valid && generate(argv[1], "packed", 16384, 1);
    valid = valid && generate(argv[1], "wide", 16384, 2);
    valid = valid && generate(argv[1], "mixed", 4096, 3);
    valid = valid && generate(argv[1], "clear", 16384, 4);
    return valid ? 0 : 1;
}
