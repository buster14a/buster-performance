// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original inputs for the #507 checker diagnostic: identical direct-member address shapes, with no packing,
// a packed member converted to void *, and a packed member whose address retains its natural pointer type.
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main(int argc, char** argv)
{
    const unsigned count = argc == 3 ? (unsigned)strtoul(argv[2], NULL, 10) : 2048;
    bool valid = argc >= 2 && argc <= 3 && count != 0 && count <= 100000;
    const char* names[] = { "plain.c", "packed-suppressed.c", "packed-warning.c", "packed-locals.c", "packed-unused.c" };
    for (unsigned kind = 0; valid && kind < 5; kind += 1)
    {
        char path[4096];
        const int length = snprintf(path, sizeof(path), "%s/%s", argv[1], names[kind]);
        valid = length > 0 && (size_t)length < sizeof(path);
        FILE* file = valid ? fopen(path, "w") : NULL;
        valid &= file != NULL;
        if (file != NULL)
        {
            if (kind == 4)
            {
                valid &= fprintf(file, "struct __attribute__((packed)) Unused {char c;int w;};\n") > 0;
            }
            else if (kind != 3)
            {
                valid &= fprintf(file, "struct %sP {char c;int w;};\n", kind == 0 ? "" : "__attribute__((packed)) ") > 0;
            }
            for (unsigned i = 0; valid && i < count; i += 1)
            {
                valid &= kind == 4 ? fprintf(file, "int*f%u(void){static int local;return &local;}\n", i) > 0 :
                         kind == 3 ? fprintf(file, "int*f%u(void){static struct __attribute__((packed)){char c;int w;} p;return &p.w;}\n", i) > 0 :
                         fprintf(file, "%s*f%u(struct P*p){return &p->w;}\n", kind == 1 ? "void" : "int", i) > 0;
            }
            valid = fclose(file) == 0 && valid;
        }
    }
    if (!valid)
    {
        fprintf(stderr, "usage: generate DIRECTORY [FUNCTIONS 1..100000]\n");
    }
    return valid ? 0 : 1;
}
