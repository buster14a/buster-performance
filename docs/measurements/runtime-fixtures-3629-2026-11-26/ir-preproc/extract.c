// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original pre-migration C literals from buster 8e4d32879e17b7d9548cad54257a2f8461328366.
// The host C compiler, not Buster, decodes every source and expected diagnostic.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <errno.h>

typedef enum
{
    IR_PARSE_OK,
    IR_PARSE_END,
    IR_PARSE_SYNTAX,
    IR_PARSE_LIMIT,
    IR_PARSE_MEMORY,
    IR_PARSE_VERIFY,
} IrParseError;

typedef struct IrParseTestCase IrParseTestCase;
struct IrParseTestCase
{
    const char* text;
    IrParseError error;
};

typedef struct PPNamedUcnCase PPNamedUcnCase;
struct PPNamedUcnCase
{
    const char* name;
    const char* source;
    const char* standard;
    const char* expected;
    const char* options;
    bool warnings;
};

#include "named_ucns.inc"
#include "invalid.inc"
#include "overflow.inc"
#include "reachable.inc"
#include "diagnostics.inc"

static bool make_directory(const char* root, const char* relative)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/%s", root, relative);
    const bool valid = length > 0 && (size_t)length < sizeof(path) && (mkdir(path, 0700) == 0 || errno == EEXIST);
    return valid;
}

static bool write_bytes(const char* root, const char* relative, const char* bytes, size_t length)
{
    char path[4096];
    const int size = snprintf(path, sizeof(path), "%s/%s", root, relative);
    FILE* stream = size > 0 && (size_t)size < sizeof(path) ? fopen(path, "wb") : NULL;
    bool valid = stream != NULL;
    if (valid)
    {
        valid = fwrite(bytes, 1, length, stream) == length;
        valid = fclose(stream) == 0 && valid;
    }
    return valid;
}

static FILE* catalog_open(const char* root, const char* suite, const char* header)
{
    char path[4096];
    const int length = snprintf(path, sizeof(path), "%s/%s/catalog.tsv", root, suite);
    FILE* stream = length > 0 && (size_t)length < sizeof(path) ? fopen(path, "wb") : NULL;
    if (stream != NULL && fprintf(stream, "%s\n", header) <= 0)
    {
        fclose(stream);
        stream = NULL;
    }
    return stream;
}

static bool dump_named_ucns(const char* root)
{
    bool valid = make_directory(root, "preprocessor") && make_directory(root, "preprocessor/named-ucns");
    FILE* catalog = valid ? catalog_open(root, "preprocessor/named-ucns", "buster-fixtures v1 preprocessor-named-ucns") : NULL;
    valid = catalog != NULL;
    for (size_t i = 0; valid && i < sizeof(named_ucns) / sizeof(named_ucns[0]); i += 1)
    {
        const PPNamedUcnCase* row = &named_ucns[i];
        if (i == 4)
        {
            valid = fprintf(catalog, "# -Wunicode: an incomplete named UCN retains its backslash; definitions warn once, skipped groups never.\n") > 0;
        }
        else if (i == 5)
        {
            valid = fprintf(catalog, "# Incomplete or empty numeric UCNs retain their letter, including at line splices and in skipped groups.\n") > 0;
        }
        else if (i == 6)
        {
            valid = fprintf(catalog, "# Complete numeric UCNs for basic/control characters and surrogates diagnose at the backslash.\n") > 0;
        }
        else if (i == 7)
        {
            valid = fprintf(catalog, "# -pedantic reports a named UCN extension before its character error, once per macro definition.\n") > 0;
        }
        else if (i == 10)
        {
            valid = fprintf(catalog, "# -Wunicode options, -w and pragmas: suppression, promotion, silence and source-ordered mapping.\n") > 0;
        }
        char path[256];
        snprintf(path, sizeof(path), "preprocessor/named-ucns/%04zu.c", i + 1);
        valid = write_bytes(root, path, row->source, strlen(row->source));
        snprintf(path, sizeof(path), "preprocessor/named-ucns/%04zu.expected", i + 1);
        valid = valid && write_bytes(root, path, row->expected, strlen(row->expected));
        valid = valid && fprintf(catalog, "%04zu\t%s\t%s\t%s\t%s\n", i + 1, row->standard,
                                 row->warnings ? "warnings" : "-", row->options != NULL ? row->options : "-", row->name) > 0;
    }
    if (catalog != NULL)
    {
        valid = fclose(catalog) == 0 && valid;
    }
    return valid;
}

static bool dump_ir(const char* root, const char* name, uint32_t count, uint32_t kind)
{
    char suite[128];
    snprintf(suite, sizeof(suite), "ir/%s", name);
    bool valid = make_directory(root, suite);
    FILE* catalog = valid ? catalog_open(root, suite, "buster-fixtures v1 ir-parser-cases") : NULL;
    valid = catalog != NULL;
    const char* const errors[] = { "ok", "end", "syntax", "limit", "memory", "verify" };
    for (uint32_t i = 0; valid && i < count; i += 1)
    {
        if (kind == 0 && i == 24)
        {
            valid = fprintf(catalog, "# An intrinsic operation has its own name, result type and operand types.\n") > 0;
        }
        else if (kind == 0 && i == 46)
        {
            valid = fprintf(catalog, "# Atomic accesses need natural alignment for x86 single-copy atomicity.\n") > 0;
        }
        else if (kind == 0 && i == 48)
        {
            valid = fprintf(catalog, "# A segment override belongs to a load or store alone.\n") > 0;
        }
        else if (kind == 0 && i == 50)
        {
            valid = fprintf(catalog, "# Compare-exchange needs a desired value of the right type; exchange has none.\n") > 0;
        }
        const char* source = kind == 0 ? invalid_cases[i].text : kind == 1 ? overflows[i] : kind == 2 ? reachable_cases[i].text : names[i].text;
        const char* error = kind == 0 ? errors[invalid_cases[i].error] : kind == 1 ? "limit-or-syntax" : kind == 2 ? errors[reachable_cases[i].error] : "syntax";
        char path[256];
        snprintf(path, sizeof(path), "%s/%04u.ir", suite, i + 1);
        valid = write_bytes(root, path, source, strlen(source));
        valid = valid && fprintf(catalog, "%04u\t%04u.ir\t%s\t%s\t%u\t%u\n", i + 1, i + 1, error,
                                 kind == 3 ? names[i].rejected : "-", kind == 3 ? names[i].line : 0, kind == 3 ? names[i].column : 0) > 0;
    }
    if (catalog != NULL)
    {
        valid = fclose(catalog) == 0 && valid;
    }
    return valid;
}

int main(int argc, char** argv)
{
    bool valid = argc == 2;
    if (valid)
    {
        valid = (mkdir(argv[1], 0700) == 0 || errno == EEXIST) && dump_named_ucns(argv[1]) && make_directory(argv[1], "ir") &&
                dump_ir(argv[1], "invalid", sizeof(invalid_cases) / sizeof(invalid_cases[0]), 0) &&
                dump_ir(argv[1], "overflow", sizeof(overflows) / sizeof(overflows[0]), 1) &&
                dump_ir(argv[1], "reachable", sizeof(reachable_cases) / sizeof(reachable_cases[0]), 2) &&
                dump_ir(argv[1], "diagnostics", sizeof(names) / sizeof(names[0]), 3) &&
                write_bytes(argv[1], "ir/parser-digest.expected", "4aa02a17eaaa7b67\n", 17);
    }
    if (valid)
    {
        printf("15 named UCN cases; 53 invalid, 5 overflow, 4 reachable and 6 IR diagnostic cases extracted\n");
    }
    return valid ? 0 : 1;
}
