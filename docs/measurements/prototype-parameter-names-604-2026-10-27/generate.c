// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Original #604 inputs and exact-source extraction. No external inputs or implementation.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool generate(const char* directory, uint32_t count, uint32_t form, bool constant)
{
    const char* forms[] = { "named", "unnamed", "early", "late" };
    char path[4096];
    snprintf(path, sizeof(path), "%s/%s%s-%u.c", directory, constant ? "constant-" : "", forms[form], count);
    FILE* file = fopen(path, "w");
    bool valid = file != NULL;
    if (valid)
    {
        fprintf(file, "%s", constant ? "enum { A=sizeof(int (*)(" : "unsigned long f(void) { return sizeof(int (*)(");
        for (uint32_t i = 0; i < count; i += 1)
        {
            const uint32_t name = (form == 2 && i == 1) || (form == 3 && i + 1 == count) ? 0 : i;
            fprintf(file, "%sint", i == 0 ? "" : ", ");
            if (form != 1)
            {
                fprintf(file, " p%u", name);
            }
        }
        fprintf(file, "%s", constant ? ")) }; _Static_assert(A==8,\"prototype pointer\");\n" : ")); }\n");
        valid = fclose(file) == 0;
    }
    return valid;
}

static bool extract(const char* source, const char* directory)
{
    FILE* file = fopen(source, "r");
    bool valid = file != NULL && fseek(file, 0, SEEK_END) == 0;
    const long size = valid ? ftell(file) : -1;
    char* text = size >= 0 ? malloc((size_t)size + 1) : NULL;
    valid = valid && text != NULL && fseek(file, 0, SEEK_SET) == 0 && fread(text, 1, (size_t)size, file) == (size_t)size;
    if (file != NULL)
    {
        fclose(file);
    }
    if (valid)
    {
        text[size] = 0;
        const char* first = strstr(text, "typedef struct CheckConstantPart CheckConstantPart;");
        const char* end = first != NULL ? strstr(first, "typedef struct CheckConstantTypeFrame CheckConstantTypeFrame;") : NULL;
        const char* visit = first != NULL ? strstr(first, "            CheckConstantParameter* previous =") : NULL;
        valid = first != NULL && end != NULL && visit != NULL && visit < end;
        char path[4096];
        snprintf(path, sizeof(path), "%s/parameter-tree.inc", directory);
        FILE* output = valid ? fopen(path, "w") : NULL;
        valid = valid && output != NULL;
        if (valid)
        {
            fprintf(output, "// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception\n// Copyright (c) 2026 David Gonzalez Martin.\n// Extracted from the #604 candidate; only the visits counter is added.\n");
            fwrite(first, 1, (size_t)(visit - first), output);
            fprintf(output, "            visits += 1;\n");
            fwrite(visit, 1, (size_t)(end - visit), output);
            valid = fclose(output) == 0;
        }
    }
    free(text);
    return valid;
}

int main(int argc, char** argv)
{
    const uint32_t counts[] = { 256, 512, 1024, 2048, 4096 };
    bool valid = argc == 3;
    for (uint32_t c = 0; valid && c < sizeof(counts) / sizeof(counts[0]); c += 1)
    {
        for (uint32_t form = 0; valid && form < 4; form += 1)
        {
            valid = generate(argv[2], counts[c], form, false) && generate(argv[2], counts[c], form, true);
        }
    }
    char path[4096];
    snprintf(path, sizeof(path), "%s/small.c", valid ? argv[2] : ".");
    FILE* file = valid ? fopen(path, "w") : NULL;
    valid = valid && file != NULL;
    if (valid)
    {
        fprintf(file, "enum {\n");
        for (uint32_t i = 0; i < 2048; i += 1)
        {
            fprintf(file, "A%u = sizeof(int (*)(int x, int y)),\n", i);
        }
        fprintf(file, "};\n");
        valid = fclose(file) == 0;
    }
    const char* scopes[] = {
        "typedef int T; enum { A=sizeof(int (*)(int (*cb)(int T),T x)) }; _Static_assert(A==8,\"typedef restored\");\n",
        "enum { A=sizeof(int (*)(int x,int x)) };\nint f(void){return missing;}\n",
    };
    for (uint32_t i = 0; valid && i < sizeof(scopes) / sizeof(scopes[0]); i += 1)
    {
        snprintf(path, sizeof(path), "%s/scope-%u.c", argv[2], i);
        file = fopen(path, "w");
        valid = file != NULL;
        if (valid)
        {
            fputs(scopes[i], file);
            valid = fclose(file) == 0;
        }
    }
    valid = valid && extract(argv[1], argv[2]);
    return valid ? 0 : 1;
}
