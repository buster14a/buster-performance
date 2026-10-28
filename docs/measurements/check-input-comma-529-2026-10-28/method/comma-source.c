// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original function-body control, distinct from compact static integer initializer tables.
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    char* end = NULL;
    const unsigned long count = argc == 2 ? strtoul(argv[1], &end, 10) : 0;
    if (argc != 2 || end == argv[1] || *end != 0 || count > 8192) return 2;
    puts("extern int printf(const char*, ...);\n"
         "static unsigned mix(unsigned x, unsigned y) { return x * 1664525u + y + 1013904223u; }\n"
         "unsigned comma_body(unsigned x) {");
    for (unsigned long i = 0; i < count; i += 1)
    {
        printf(" { for (unsigned j=0,k=2; j<2; j++,k--) x=mix((x+=%luu,x),(j,k));\n"
               " x=(x&1u)?(x+=3u,x):(x^=2654435769u,x);\n"
               " x+=(unsigned)sizeof((x+=99u,x));\n"
               " unsigned a[2]={x,x^%luu}; x=a[((x>>1u),x&1u)]; }\n", i + 1, i + 17);
    }
    puts(" return x; }\nint main(void) { printf(\"%u\\n\",comma_body(42)); return 0; }");
    return ferror(stdout) != 0;
}
