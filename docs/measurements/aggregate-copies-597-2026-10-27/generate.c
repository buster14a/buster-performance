// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #597 input generator; no external source or generated corpus.
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    char* end = NULL;
    errno = 0;
    const unsigned long size = argc >= 2 ? strtoul(argv[1], &end, 10) : 0;
    const int valid = argc >= 2 && argc <= 3 && errno == 0 && size > 0 && size <= UINT32_MAX && *end == 0;
    if (valid)
    {
        const char* mode = argc == 3 ? argv[2] : "all";
        printf("struct S{unsigned char bytes[%lu];};\n", size);
        if (strcmp(mode, "forced") == 0)
        {
            puts("extern void*memmove(void*,const void*,unsigned long);");
            printf("void copy(struct S*d,const struct S*s){memmove(d,s,%luUL);}\n", size);
            printf("unsigned char kept(struct S*d,const struct S*s){return ((unsigned char*)memmove(d,s,%luUL))[%lu];}\n", size, size - 1);
            printf("void same(struct S*d){memmove(d,d,%luUL);}\n", size);
        }
        if (strcmp(mode, "all") == 0 || strcmp(mode, "copy") == 0)
        {
            puts("void copy(struct S*d,const struct S*s){*d=*s;}");
        }
        if (strcmp(mode, "all") == 0 || strcmp(mode, "kept") == 0)
        {
            printf("unsigned char kept(struct S*d,const struct S*s){return (*d=*s).bytes[%lu];}\n", size - 1);
        }
        if (strcmp(mode, "all") == 0 || strcmp(mode, "same") == 0)
        {
            puts("void same(struct S*d){*d=*d;}");
        }
    }
    return valid ? 0 : 1;
}
