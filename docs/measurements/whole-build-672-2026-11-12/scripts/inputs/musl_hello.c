// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// The program the musl link checks itself with: it prints through stdio, formats a floating-point number and a
// string, allocates, and sorts, so that the link's output has to hold a working C library.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int compare(const void* left, const void* right)
{
    return *(const int*)left - *(const int*)right;
}

int main(int argc, char** argv)
{
    int* values = malloc(8 * sizeof(int));
    int result = values == 0;
    for (int i = 0; values != 0 && i < 8; i += 1)
    {
        values[i] = (i * 5 + 3) % 8;
    }
    if (values != 0)
    {
        qsort(values, 8, sizeof(int), compare);
        printf("hello from %s: %d %d %.3f %zu\n", argc > 0 ? "musl" : "?", values[0], values[7], 1.0 / 3.0, strlen(argv[0]) > 0 ? (size_t)42 : (size_t)0);
        free(values);
    }
    return result;
}
