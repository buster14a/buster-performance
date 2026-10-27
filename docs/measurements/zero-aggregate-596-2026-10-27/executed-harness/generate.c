// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original synthetic inputs for Buster #596; no external fixtures or implementation.
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    const char* mode = argc > 1 ? argv[1] : "";
    const uint64_t size = argc > 2 ? strtoull(argv[2], NULL, 10) : 0;
    int status = size == 0 ? 1 : 0;
    if (status == 0 && (strcmp(mode, "dense") == 0 || strcmp(mode, "dense-tail-zero") == 0))
    {
        printf("unsigned char a[%llu]={", (unsigned long long)size);
        for (uint64_t i = 0; i < size; i += 1)
        {
            printf("%s%u", i != 0 ? "," : "", i + 1 == size && strcmp(mode, "dense-tail-zero") == 0 ? 0 : (unsigned)(i % 251) + 1);
        }
        puts("}; unsigned char *get(void){return a;}");
    }
    else if (status == 0 && strcmp(mode, "bits") == 0)
    {
        printf("struct S{unsigned v:9;unsigned char pad[%llu];} a={.v=511,.v=0,.pad[%llu]=0};\n", (unsigned long long)size, (unsigned long long)(size - 1));
        puts("unsigned char *get(void){return (unsigned char *)&a;}");
    }
    else if (status == 0 && strcmp(mode, "reloc") == 0)
    {
        printf("extern int target;union U{int *p;unsigned char pad[%llu];} a={.p=&target,.pad={0}};\n", (unsigned long long)size);
        puts("unsigned char *get(void){return (unsigned char *)&a;}");
    }
    else if (status == 0 && strcmp(mode, "negative") == 0)
    {
        puts("double a[2]={-0.0,0.0};unsigned char *get(void){return (unsigned char *)a;}");
    }
    else if (status == 0)
    {
        const char* qualifier = strcmp(mode, "tls") == 0 ? "_Thread_local " : strcmp(mode, "const") == 0 ? "const " : "";
        printf("%sunsigned char a[%llu]", qualifier, (unsigned long long)size);
        if (strcmp(mode, "zero") == 0 || strcmp(mode, "tls") == 0 || strcmp(mode, "const") == 0)
        {
            printf("={0}");
        }
        else if (strcmp(mode, "designated") == 0)
        {
            printf("={[%llu]=0}", (unsigned long long)(size - 1));
        }
        else if (strcmp(mode, "overwrite") == 0)
        {
            printf("={[%llu]=255,[%llu]=0}", (unsigned long long)(size - 1), (unsigned long long)(size - 1));
        }
        else if (strcmp(mode, "bss") != 0)
        {
            status = 1;
        }
        puts(";unsigned char *get(void){return (unsigned char *)a;}");
    }
    if (status == 0)
    {
        puts("unsigned long get_size(void){return sizeof a;}");
    }
    return status != 0 || ferror(stdout);
}
