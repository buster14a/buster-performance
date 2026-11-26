// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define BUSTER_ARRAY_LENGTH(a) (sizeof(a) / sizeof((a)[0]))
typedef struct CheckTest { unsigned count; } CheckTest;
typedef struct CheckDriverDefaultWarningFixture CheckDriverDefaultWarningFixture;
struct CheckDriverDefaultWarningFixture
{
    const char* name;
    const char* source;
    const char* options[4];
    uint32_t warnings;
    uint32_t errors;
    uint32_t notes;
    bool c23;
    bool compare_warning_text;
    bool compare_node_window;
    bool syntax_only;
    const void* baseline_spellings;
    uint64_t source_length;
};

static void check_test_driver_warning_fixtures_dealt(CheckTest* test, const char* clang, const char* executable, const char* directory,
                                                    const CheckDriverDefaultWarningFixture* fixtures, uint32_t count, bool deal)
{
    (void)clang;
    (void)executable;
    if (!deal || mkdir(directory, 0755) != 0)
    {
        exit(1);
    }
    char path[4096];
    snprintf(path, sizeof(path), "%s/catalog.tsv", directory);
    FILE* catalog = fopen(path, "wb");
    if (catalog == NULL)
    {
        exit(1);
    }
    fprintf(catalog, "buster-fixtures v2 checker-warnings\n");
    for (uint32_t i = 0; i < count; i += 1)
    {
        const CheckDriverDefaultWarningFixture* fixture = fixtures + i;
        const size_t length = strlen(fixture->source);
        if (fixture->baseline_spellings != NULL || fixture->source_length != 0)
        {
            exit(1);
        }
        snprintf(path, sizeof(path), "%s/%04u.c", directory, i + 1);
        FILE* source = fopen(path, "wb");
        if (source == NULL || fwrite(fixture->source, 1, length, source) != length || fclose(source) != 0)
        {
            exit(1);
        }
        fprintf(catalog, "%04u\t%04u.c\t%u\t%u\t%u\t", i + 1, i + 1, fixture->warnings, fixture->errors, fixture->notes);
        const bool flags[] = { fixture->c23, fixture->compare_warning_text, fixture->compare_node_window, fixture->syntax_only };
        const char* names[] = { "c23", "warning-text", "node-window", "syntax-only" };
        bool any = false;
        for (uint32_t f = 0; f < BUSTER_ARRAY_LENGTH(flags); f += 1)
        {
            if (flags[f])
            {
                fprintf(catalog, "%s%s", any ? "," : "", names[f]);
                any = true;
            }
        }
        fprintf(catalog, "%s\t", any ? "" : "-");
        any = false;
        for (uint32_t option = 0; option < BUSTER_ARRAY_LENGTH(fixture->options); option += 1)
        {
            if (fixture->options[option] != NULL)
            {
                fprintf(catalog, "%s%s", any ? " " : "", fixture->options[option]);
                any = true;
            }
        }
        fprintf(catalog, "%s\t%s\n", any ? "" : "-", fixture->name);
        test->count += 1;
        printf("%s/%04u.c\t%zu\t%s\n", directory, i + 1, length, fixture->name);
    }
    if (fclose(catalog) != 0)
    {
        exit(1);
    }
}

#include "original/c_check_call_warnings_driver_test.c"
#include "original/c_check_expression_warnings_driver_test.c"
#include "original/c_check_syntax_warning_driver_test.c"

int main(int argc, char** argv)
{
    CheckTest test = { 0 };
    if (argc != 2)
    {
        return 1;
    }
    char path[4096];
    snprintf(path, sizeof(path), "%s/call-warnings", argv[1]);
    check_test_driver_call_warnings(&test, NULL, NULL, path);
    snprintf(path, sizeof(path), "%s/expression-warnings", argv[1]);
    check_test_driver_expression_warnings(&test, NULL, NULL, path);
    snprintf(path, sizeof(path), "%s/syntax-warnings", argv[1]);
    check_test_driver_syntax_warnings(&test, NULL, NULL, path);
    fprintf(stderr, "dumped %u warning cases\n", test.count);
    return test.count == 42 ? 0 : 1;
}
