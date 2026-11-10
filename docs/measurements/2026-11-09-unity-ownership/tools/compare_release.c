// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.
#include <glob.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static bool equal_bytes(const char* first, const char* last)
{
    FILE* a = fopen(first, "rb");
    FILE* b = fopen(last, "rb");
    bool same = a != 0 && b != 0;
    size_t amount = 1;
    while (same && amount != 0)
    {
        unsigned char before[65536];
        unsigned char after[65536];
        amount = fread(before, 1, sizeof(before), a);
        const size_t other = fread(after, 1, sizeof(after), b);
        same = amount == other && memcmp(before, after, amount) == 0;
    }
    same = same && !ferror(a) && !ferror(b);
    if (a != 0)
    {
        fclose(a);
    }
    if (b != 0)
    {
        fclose(b);
    }
    printf("%s\t%s\n", same ? "identical" : "different", last);
    return same;
}

int main(void)
{
    static const char prefix[] = "../baseline-release/";
    glob_t before = { 0 };
    glob_t after = { 0 };
    const bool found_before = glob("../baseline-release/build/cmake/x86-64-g0/CMakeFiles/*/Release/src/buster/compiler/*.o", 0, 0, &before) == 0;
    const bool found_after = glob("build/cmake/x86-64-g0/CMakeFiles/*/Release/src/buster/compiler/*.o", 0, 0, &after) == 0;
    bool same = found_before && found_after && before.gl_pathc == 43 && after.gl_pathc == 43;
    for (size_t i = 0; i < before.gl_pathc; i += 1)
    {
        same = equal_bytes(before.gl_pathv[i], before.gl_pathv[i] + sizeof(prefix) - 1) && same;
    }
    same = equal_bytes("../baseline-release/compiler", "build/cmake/x86-64-g0/Release/compiler") && same;
    printf("%zu baseline objects, %zu final objects, compiler: %s\n", before.gl_pathc, after.gl_pathc, same ? "all byte-identical" : "failed");
    globfree(&before);
    globfree(&after);
    return !same;
}
