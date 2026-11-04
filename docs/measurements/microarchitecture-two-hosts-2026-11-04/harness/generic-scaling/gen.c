// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Writes a C unit of N functions, each with one _Generic selection and a few
// expressions: the input of the _Generic scaling check.
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char **argv)
{
    int n = argc > 1 ? atoi(argv[1]) : 1000;
    for (int i = 0; i < n; i += 1)
    {
        printf("int f%d(int a, long b) { int x = a * %d + (int)b; int y = _Generic(x, int: x + 1, long: x - 1, default: 0); return x + y; }\n", i, i);
    }
    return 0;
}
