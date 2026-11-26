// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#include <stdio.h>
#include <string.h>
#include "implicit_literals.inc"

int main(int argc, char** argv)
{
    if (argc != 2)
    {
        return 1;
    }
    const char* names[] = { "implicit-int", "implicit-int-program", "implicit-int-parameters" };
    const char* sources[] = { implicit_int_source, implicit_int_program_source, implicit_int_parameter_source };
    const size_t lengths[] = { sizeof(implicit_int_source) - 1, sizeof(implicit_int_program_source) - 1, sizeof(implicit_int_parameter_source) - 1 };
    char path[4096];
    snprintf(path, sizeof(path), "%s/catalog.tsv", argv[1]);
    FILE* catalog = fopen(path, "wb");
    if (catalog == NULL)
    {
        return 1;
    }
    fprintf(catalog, "buster-fixtures v1 checker-sources\n");
    for (unsigned i = 0; i < sizeof(names) / sizeof(names[0]); i += 1)
    {
        snprintf(path, sizeof(path), "%s/%s.c", argv[1], names[i]);
        FILE* file = fopen(path, "wb");
        if (file == NULL || fwrite(sources[i], 1, lengths[i], file) != lengths[i] || fclose(file) != 0)
        {
            return 1;
        }
        fprintf(catalog, "%s\t%s.c\tgnu89\t%s\n", names[i], names[i], names[i]);
        printf("%s\t%zu bytes\t%s-c89\t%s-gnu89\n", names[i], lengths[i], names[i], names[i]);
    }
    return fclose(catalog) != 0;
}
