// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
// Original inputs for the post-review capacity/residency screen; no external code is incorporated.
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    const unsigned depth = argc > 1 ? (unsigned)strtoul(argv[1], NULL, 10) : 0;
    if (depth == 0)
    {
        puts("int f(int x) { return x * 3 + 1; }");
    }
    else
    {
        puts("struct Chain {");
        for (unsigned level = 0; level < depth; level += 1)
        {
            puts("struct {");
        }
        puts("int value;");
        for (unsigned level = 0; level < depth; level += 1)
        {
            puts("};");
        }
        puts("}; int f(struct Chain* p) { return p->value; }");
    }
    return ferror(stdout) != 0;
}
