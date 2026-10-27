// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original generated inputs for Buster #593. No external fixture or implementation is incorporated.
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int status = 1;
    char* end = NULL;
    errno = 0;
    const unsigned long count = argc == 3 ? strtoul(argv[2], &end, 10) : 0;
    const char* kind = argc == 3 ? argv[1] : "";
    const bool strings = strcmp(kind, "strings") == 0;
    const bool repeated = strcmp(kind, "repeated") == 0;
    const bool wide = strcmp(kind, "wide") == 0;
    const bool records = strcmp(kind, "records") == 0;
    const bool pointers = strcmp(kind, "pointers") == 0;
    const bool characters = strcmp(kind, "characters") == 0;
    const bool integers = strcmp(kind, "integers") == 0;
    if (errno == 0 && end != NULL && *end == 0 && count != 0 && count <= 160000 &&
        (strings || repeated || wide || records || pointers || characters || integers))
    {
        static char buffer[1048576];
        setvbuf(stdout, buffer, _IOFBF, sizeof(buffer));
        if (records)
        {
            puts("struct Row { int id; const char* text; double value; short pair[2]; };\nstatic const struct Row t[]={");
        }
        else if (!pointers && !characters)
        {
            puts(integers ? "static const int t[]={" : wide ? "static const int* const t[]={" : "static const char* const t[]={");
        }
        for (unsigned long i = 0; i < count; i += 1)
        {
            if (records)
            {
                printf("{%lu,\"string number %lu of the table\",%lu.25,{%lu,%lu}},\n", i, i, i, i % 30000, (i + 1) % 30000);
            }
            else if (pointers || characters)
            {
                printf(pointers ? "const char* p_%lu=\"string number %lu of the table\";\n" :
                                  "static const char s_%lu[]=\"string number %lu of the table\";\n", i, i);
            }
            else if (integers)
            {
                printf("%lu,\n", i);
            }
            else
            {
                printf("%s\"string number %lu of the table\",\n", wide ? "L" : "", repeated ? 0 : i);
            }
        }
        if (pointers || characters)
        {
            printf("const char* get(int i){return i?%s_%lu:%s_0;}\n", pointers ? "p" : "s", count - 1, pointers ? "p" : "s");
        }
        else
        {
            printf("};\n%s get(int i){return %st[i];}\n", records ? "const struct Row*" : wide ? "const int*" : integers ? "int" : "const char*", records ? "&" : "");
        }
        status = fflush(stdout) == 0 && !ferror(stdout) ? 0 : 1;
    }
    if (status != 0)
    {
        fputs("usage: generate strings|repeated|wide|records|pointers|characters|integers 1..160000\n", stderr);
    }
    return status;
}
