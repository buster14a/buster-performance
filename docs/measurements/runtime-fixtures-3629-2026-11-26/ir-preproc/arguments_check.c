// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BUSTER_PP_TEST_MAX_ARGUMENTS 32
typedef struct { const char* name; const char* standard; const char* options; } PPTestCase;
#include "arguments.inc"
static unsigned checks;
static unsigned failures;
static void expect(bool passed, const char* name)
{
    checks += 1;
    failures += !passed;
    printf("%s %s\n", passed ? "PASS" : "FAIL", name);
}
int main(void)
{
    char text[16384];
    char* arguments[BUSTER_PP_TEST_MAX_ARGUMENTS + 1];
    PPTestCase test = { .name = "argument boundary", .standard = "gnu17" };
    expect(pp_test_arguments(&test, "/temp", "input.c", text, sizeof(text), arguments) == 1 &&
           strcmp(arguments[0], "-std=gnu17") == 0 && strcmp(arguments[1], "input.c") == 0, "default arguments retained");
    char options[256] = { 0 };
    for (unsigned i = 0; i < 30; i += 1)
    {
        strcat(options, "-w ");
    }
    test.options = options;
    expect(pp_test_arguments(&test, "/temp", "input.c", text, sizeof(text), arguments) == 31 &&
           strcmp(arguments[30], "-w") == 0 && strcmp(arguments[31], "input.c") == 0, "last allowed option retained");
    strcat(options, "-funknown-runtime-fixture-option");
    expect(pp_test_arguments(&test, "/temp", "input.c", text, sizeof(text), arguments) == -1, "excess final option refused");
    char large[20000];
    memset(large, 'a', sizeof(large) - 1);
    large[sizeof(large) - 1] = 0;
    test.options = large;
    expect(pp_test_arguments(&test, "/temp", "input.c", text, sizeof(text), arguments) == -1, "oversized option text refused");
    test.options = NULL;
    expect(pp_test_arguments(&test, "/temp", "input.c", text, strlen("-std=gnu17") + 1, arguments) == 1, "exact standard buffer accepted");
    expect(pp_test_arguments(&test, "/temp", "input.c", text, strlen("-std=gnu17"), arguments) == -1, "truncated standard refused");
    test.options = "-I%d";
    expect(pp_test_arguments(&test, "/a path", "input.c", text, sizeof(text), arguments) == 2 &&
           strcmp(arguments[1], "-I/a path") == 0, "directory expansion preserves spaces");
    expect(pp_test_arguments(&test, large, "input.c", text, sizeof(text), arguments) == -1, "oversized directory expansion refused");
    printf("argument controls: %u checks, %u failures\n", checks, failures);
    return failures == 0 ? 0 : 1;
}
