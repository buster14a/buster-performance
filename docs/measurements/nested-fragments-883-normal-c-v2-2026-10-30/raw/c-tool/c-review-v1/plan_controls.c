// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Fresh synthetic C plan controls. No source files, producer, assembler,
// remote host, subprocess or image instructions are used by this program.
#include "hp_plan.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>

#define BUSTER_PLAN_ARRAY_COUNT(values) (sizeof(values) / sizeof((values)[0]))
#define BUSTER_PLAN_CC "/private cache/clang23/bin/clang-23"

typedef struct PlanSuite PlanSuite;
struct PlanSuite
{
    size_t count;
    size_t failures;
};

static void plan_record(PlanSuite *suite, const char *name, bool passed, const char *error)
{
    suite->count += 1;
    suite->failures += !passed;
    printf("%s %s", passed ? "PASS" : "FAIL", name);
    if (!passed && error[0] != 0)
    {
        printf(" [%s]", error);
    }
    printf("\n");
    return;
}

static bool plan_zero(const void *data, size_t size)
{
    const unsigned char *bytes = data;
    bool valid = true;
    for (size_t index = 0; valid && index < size; index += 1)
    {
        valid = bytes[index] == 0;
    }
    return valid;
}

static void plan_source_case(PlanSuite *suite, const char *name, char **values, size_t count, bool expected)
{
    HpArguments input =
    {
        .values = values,
        .count = count
    };
    HpSourcePlan output;
    memset(&output, 0x5a, sizeof(output));
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    bool accepted = hp_plan_sources(&input, &output, error);
    bool passed = accepted == expected;
    if (accepted)
    {
        passed = passed && output.count == count && output.checker_index < count;
        for (size_t index = 0; passed && index < count; index += 1)
        {
            passed = output.values[index] == values[index];
        }
        if (passed)
        {
            const char *source = output.values[output.checker_index];
            const char *slash = strrchr(source, '/');
            passed = strcmp(slash != NULL ? slash + 1 : source, "main_unit_checker.c") == 0 && error[0] == 0;
        }
    }
    else
    {
        passed = passed && plan_zero(&output, sizeof(output)) && error[0] != 0;
    }
    plan_record(suite, name, passed, error);
    return;
}

static void plan_source_controls(PlanSuite *suite)
{
    char *valid[] =
    {
        "src/first.c",
        "src/main_unit_checker.c",
        "src/last-module.v2_1.c"
    };
    plan_source_case(suite, "relative-source-order-and-checker-index", valid, BUSTER_PLAN_ARRAY_COUNT(valid), true);
    char *one[] =
    {
        "main_unit_checker.c"
    };
    plan_source_case(suite, "single-top-level-checker", one, 1, true);
    static const struct
    {
        const char *name;
        char *value;
    } bad[] =
    {
        {
            "source-empty-value",
            ""
        },
        {
            "source-absolute",
            "/private/unit.c"
        },
        {
            "source-leading-option",
            "-unit.c"
        },
        {
            "source-response-file",
            "@unit.c"
        },
        {
            "source-dotdot-leading",
            "../unit.c"
        },
        {
            "source-dotdot-inner",
            "src/../unit.c"
        },
        {
            "source-dot-leading",
            "./unit.c"
        },
        {
            "source-dot-inner",
            "src/./unit.c"
        },
        {
            "source-empty-component",
            "src//unit.c"
        },
        {
            "source-space",
            "src/unit name.c"
        },
        {
            "source-tab",
            "src/unit\tname.c"
        },
        {
            "source-newline",
            "src/unit\nname.c"
        },
        {
            "source-CR",
            "src/unit\rname.c"
        },
        {
            "source-DEL",
            "src/unit\x7fname.c"
        },
        {
            "source-high-byte",
            "src/unit\xffname.c"
        },
        {
            "source-backslash",
            "src\\unit.c"
        },
        {
            "source-quote",
            "src/unit\"name.c"
        },
        {
            "source-single-quote",
            "src/unit'name.c"
        },
        {
            "source-dollar",
            "src/$(unit).c"
        },
        {
            "source-backtick",
            "src/`unit`.c"
        },
        {
            "source-semicolon",
            "src/unit;name.c"
        },
        {
            "source-star",
            "src/*.c"
        },
        {
            "source-hash",
            "src/#unit.c"
        },
        {
            "source-colon",
            "src/unit:name.c"
        },
        {
            "source-no-c-suffix",
            "src/unit.h"
        },
        {
            "source-uppercase-C-suffix",
            "src/unit.C"
        },
        {
            "source-suffix-not-final",
            "src/unit.c.more"
        },
        {
            "source-NULL-entry",
            NULL
        }
    };
    for (size_t index = 0; index < BUSTER_PLAN_ARRAY_COUNT(bad); index += 1)
    {
        char *values[] =
        {
            "main_unit_checker.c",
            bad[index].value
        };
        plan_source_case(suite, bad[index].name, values, BUSTER_PLAN_ARRAY_COUNT(values), false);
    }
    char *duplicate[] =
    {
        "src/main_unit_checker.c",
        "src/other.c",
        "src/other.c"
    };
    plan_source_case(suite, "source-duplicate-path", duplicate, BUSTER_PLAN_ARRAY_COUNT(duplicate), false);
    duplicate[2] = "elsewhere/main_unit_checker.c";
    plan_source_case(suite, "source-duplicate-checker-basename", duplicate, BUSTER_PLAN_ARRAY_COUNT(duplicate), false);
    char *no_checker[] =
    {
        "not_main_unit_checker.c",
        "src/main_unit_checker.c.more.c"
    };
    plan_source_case(suite, "source-checker-basename-must-be-exact", no_checker, BUSTER_PLAN_ARRAY_COUNT(no_checker), false);
    plan_source_case(suite, "source-empty-list", NULL, 0, false);
    plan_source_case(suite, "source-NULL-vector-nonzero-count", NULL, 1, false);
    plan_source_case(suite, "source-count-overflow", one, SIZE_MAX, false);
    char names[BUSTER_HP_SOURCE_LIMIT + 1][64] = { 0 };
    char *many[BUSTER_HP_SOURCE_LIMIT + 1] = { 0 };
    for (size_t index = 0; index < BUSTER_PLAN_ARRAY_COUNT(names); index += 1)
    {
        int size = snprintf(names[index], sizeof(names[index]), "src/unit%zu.c", index);
        assert(size > 0 && (size_t)size < sizeof(names[index]));
        many[index] = names[index];
    }
    many[173] = "src/main_unit_checker.c";
    plan_source_case(suite, "source-exact-256-entry-bound", many, BUSTER_HP_SOURCE_LIMIT, true);
    plan_source_case(suite, "source-over-256-entry-bound", many, BUSTER_HP_SOURCE_LIMIT + 1, false);
    char long_source[BUSTER_HP_PATH_CAPACITY + 1];
    memset(long_source, 'a', sizeof(long_source));
    long_source[BUSTER_HP_PATH_CAPACITY - 3] = '.';
    long_source[BUSTER_HP_PATH_CAPACITY - 2] = 'c';
    long_source[BUSTER_HP_PATH_CAPACITY - 1] = 0;
    char *long_values[] =
    {
        "main_unit_checker.c",
        long_source
    };
    plan_source_case(suite, "source-exact-4095-byte-string-bound", long_values, BUSTER_PLAN_ARRAY_COUNT(long_values), true);
    long_source[BUSTER_HP_PATH_CAPACITY - 3] = 'a';
    long_source[BUSTER_HP_PATH_CAPACITY - 2] = '.';
    long_source[BUSTER_HP_PATH_CAPACITY - 1] = 'c';
    long_source[BUSTER_HP_PATH_CAPACITY] = 0;
    plan_source_case(suite, "source-over-string-bound", long_values, BUSTER_PLAN_ARRAY_COUNT(long_values), false);
    HpArguments input =
    {
        .values = one,
        .count = 1
    };
    HpSourcePlan output = { 0 };
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    bool accepted = hp_plan_sources(NULL, &output, error);
    plan_record(suite, "source-NULL-input-rejected", !accepted && plan_zero(&output, sizeof(output)) && error[0] != 0, error);
    accepted = hp_plan_sources(&input, NULL, error);
    plan_record(suite, "source-NULL-output-rejected", !accepted && error[0] != 0, error);
    return;
}

static void plan_decimal_controls(PlanSuite *suite)
{
    static const struct
    {
        const char *name;
        const char *text;
        uint64_t maximum;
        uint64_t value;
        bool expected;
    } cases[] =
    {
        {
            "decimal-zero-at-zero-bound",
            "0",
            0,
            0,
            true
        },
        {
            "decimal-leading-zeroes-are-base10",
            "00016",
            2048,
            16,
            true
        },
        {
            "decimal-exact-bound",
            "2048",
            2048,
            2048,
            true
        },
        {
            "decimal-over-bound",
            "2049",
            2048,
            0,
            false
        },
        {
            "decimal-UINT64-MAX",
            "18446744073709551615",
            UINT64_MAX,
            UINT64_MAX,
            true
        },
        {
            "decimal-over-UINT64-MAX",
            "18446744073709551616",
            UINT64_MAX,
            0,
            false
        },
        {
            "decimal-long-overflow",
            "999999999999999999999999999999999999",
            UINT64_MAX,
            0,
            false
        },
        {
            "decimal-nonzero-at-zero-bound",
            "1",
            0,
            0,
            false
        },
        {
            "decimal-plus-sign",
            "+16",
            2048,
            0,
            false
        },
        {
            "decimal-minus-sign",
            "-1",
            2048,
            0,
            false
        },
        {
            "decimal-empty",
            "",
            2048,
            0,
            false
        },
        {
            "decimal-NULL",
            NULL,
            2048,
            0,
            false
        },
        {
            "decimal-leading-space",
            " 16",
            2048,
            0,
            false
        },
        {
            "decimal-trailing-space",
            "16 ",
            2048,
            0,
            false
        },
        {
            "decimal-final-newline",
            "16\n",
            2048,
            0,
            false
        },
        {
            "decimal-hex-prefix",
            "0x10",
            2048,
            0,
            false
        },
        {
            "decimal-exponent",
            "1e2",
            2048,
            0,
            false
        },
        {
            "decimal-fraction",
            "1.5",
            2048,
            0,
            false
        }
    };
    for (size_t index = 0; index < BUSTER_PLAN_ARRAY_COUNT(cases); index += 1)
    {
        uint64_t output = 123;
        char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
        bool accepted = hp_plan_decimal(cases[index].text, cases[index].maximum, &output, error);
        bool passed = accepted == cases[index].expected && output == cases[index].value && (accepted ? error[0] == 0 : error[0] != 0);
        plan_record(suite, cases[index].name, passed, error);
    }
    uint64_t output = 123;
    char text[BUSTER_HP_PATH_CAPACITY + 1];
    memset(text, '0', sizeof(text));
    text[BUSTER_HP_PATH_CAPACITY - 1] = 0;
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    bool accepted = hp_plan_decimal(text, 0, &output, error);
    plan_record(suite, "decimal-exact-string-bound", accepted && output == 0 && error[0] == 0, error);
    text[BUSTER_HP_PATH_CAPACITY - 1] = '0';
    text[BUSTER_HP_PATH_CAPACITY] = 0;
    accepted = hp_plan_decimal(text, 0, &output, error);
    plan_record(suite, "decimal-over-string-bound", !accepted && output == 0 && error[0] != 0, error);
    accepted = hp_plan_decimal("1", 1, NULL, error);
    plan_record(suite, "decimal-NULL-output-rejected", !accepted && error[0] != 0, error);
    return;
}

static bool plan_argv_equal(const HpPlanArguments *actual, const char *const *expected, size_t count)
{
    bool valid = actual->count == count && count <= BUSTER_HP_ARGUMENT_LIMIT && actual->values[count] == NULL;
    for (size_t index = 0; valid && index < count; index += 1)
    {
        valid = actual->values[index] != NULL && strcmp(actual->values[index], expected[index]) == 0;
    }
    return valid;
}

static void plan_rejected(PlanSuite *suite, const char *name, bool accepted, const HpPlanArguments *output, const char *error)
{
    plan_record(suite, name, !accepted && plan_zero(output, sizeof(*output)) && error[0] != 0, error);
    return;
}

static void plan_argv_controls(PlanSuite *suite)
{
    char *flag_values[] =
    {
        "-march=znver5",
        "-Isrc",
        "-fwrapv",
        "-funsigned-char",
        "-fno-strict-aliasing",
        "-Wall",
        "-Werror",
        "-DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\"",
        "-O3"
    };
    HpArguments flags =
    {
        .values = flag_values,
        .count = BUSTER_PLAN_ARRAY_COUNT(flag_values)
    };
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    HpPlanArguments plan = { 0 };
    const char *direct[] =
    {
        BUSTER_PLAN_CC,
        "-c",
        "src/main_unit_checker.c",
        "-o",
        "/private output/direct.o",
        "-MJ",
        "/private output/direct.json",
        "-march=znver5",
        "-Isrc",
        "-fwrapv",
        "-funsigned-char",
        "-fno-strict-aliasing",
        "-Wall",
        "-Werror",
        "-DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\"",
        "-O3"
    };
    bool accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/main_unit_checker.c", "/private output/direct.o", "/private output/direct.json", &flags, &plan, error);
    bool flags_unchanged = flags.count == BUSTER_PLAN_ARRAY_COUNT(flag_values);
    for (size_t index = 0; flags_unchanged && index < flags.count; index += 1)
    {
        flags_unchanged = plan.values[index + 7] == flag_values[index];
    }
    plan_record(suite, "direct-compile-exact-prefix-flags-order-and-borrowed-strings", accepted && flags_unchanged && plan_argv_equal(&plan, direct, BUSTER_PLAN_ARRAY_COUNT(direct)), error);
    const char *assembly[] =
    {
        BUSTER_PLAN_CC,
        "-S",
        "src/main_unit_checker.c",
        "-o",
        "/private output/checker.s",
        "-march=znver5",
        "-Isrc",
        "-fwrapv",
        "-funsigned-char",
        "-fno-strict-aliasing",
        "-Wall",
        "-Werror",
        "-DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\"",
        "-O3"
    };
    accepted = hp_plan_assembly(BUSTER_PLAN_CC, "src/main_unit_checker.c", "/private output/checker.s", &flags, &plan, error);
    plan_record(suite, "assembly-emission-exact-order-identical-C-flags", accepted && plan_argv_equal(&plan, assembly, BUSTER_PLAN_ARRAY_COUNT(assembly)), error);
    const char *assembler[] =
    {
        BUSTER_PLAN_CC,
        "-c",
        "-x",
        "assembler",
        "--target=x86_64-unknown-linux-gnu",
        "-march=znver5",
        "/private output/checker.s",
        "-o",
        "/private output/checker.o"
    };
    accepted = hp_plan_assemble(BUSTER_PLAN_CC, "/private output/checker.s", "/private output/checker.o", &plan, error);
    plan_record(suite, "assembler-exact-target-ISA-with-no-C-only-flags", accepted && plan_argv_equal(&plan, assembler, BUSTER_PLAN_ARRAY_COUNT(assembler)), error);
    char *object_values[] =
    {
        "/private output/first.o",
        "/private output/checker.o",
        "/private output/last.o"
    };
    HpArguments objects =
    {
        .values = object_values,
        .count = BUSTER_PLAN_ARRAY_COUNT(object_values)
    };
    const char *link[] =
    {
        BUSTER_PLAN_CC,
        "-no-pie",
        "--ld-path=/usr/bin/wild",
        "/private output/first.o",
        "/private output/checker.o",
        "/private output/last.o",
        "-lm",
        "-ldl",
        "-o",
        "/private output/compiler"
    };
    accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, 1, NULL, "/private output/compiler", &plan, error);
    plan_record(suite, "normal-link-pinned-linker-libraries-and-original-object-order", accepted && plan_argv_equal(&plan, link, BUSTER_PLAN_ARRAY_COUNT(link)), error);
    for (size_t checker = 0; checker < objects.count; checker += 1)
    {
        const char *replacement = "/private output/checker-shift16.o";
        accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, checker, replacement, "/private output/compiler", &plan, error);
        bool order = accepted && plan.count == objects.count + 7 && plan.values[plan.count] == NULL;
        for (size_t index = 0; order && index < objects.count; index += 1)
        {
            order = plan.values[index + 3] == (index == checker ? replacement : object_values[index]);
        }
        const char *name = checker == 0 ? "replace-only-first-object-slot" : checker == 1 ? "replace-only-middle-checker-slot" : "replace-only-last-object-slot";
        plan_record(suite, name, order, error);
    }
    HpArguments empty = { 0 };
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &empty, &plan, error);
    plan_record(suite, "construction-allows-empty-flags-separate-semantic-allowlist-required", accepted && plan.count == 7 && plan.values[7] == NULL, error);
    char *literal_values[] =
    {
        "-DVALUE=$(never);`never` \"literal\""
    };
    HpArguments literal =
    {
        .values = literal_values,
        .count = 1
    };
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &literal, &plan, error);
    plan_record(suite, "argument-metacharacters-remain-one-unevaluated-argv-entry", accepted && plan.count == 8 && plan.values[7] == literal_values[0] && strcmp(plan.values[7], literal_values[0]) == 0, error);
    accepted = hp_plan_compile("clang", "src/unit.c", "unit.o", "unit.json", &flags, &plan, error);
    plan_rejected(suite, "relative-producer-path-refused", accepted, &plan, error);
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "/src/unit.c", "unit.o", "unit.json", &flags, &plan, error);
    plan_rejected(suite, "direct-source-must-be-project-relative", accepted, &plan, error);
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "@unit.c", "unit.o", "unit.json", &flags, &plan, error);
    plan_rejected(suite, "direct-source-response-file-refused", accepted, &plan, error);
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "@unit.o", "unit.json", &flags, &plan, error);
    plan_rejected(suite, "direct-object-response-file-refused", accepted, &plan, error);
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "", &flags, &plan, error);
    plan_rejected(suite, "direct-empty-JSON-refused", accepted, &plan, error);
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", NULL, &plan, error);
    plan_rejected(suite, "NULL-flags-refused", accepted, &plan, error);
    HpArguments invalid =
    {
        .count = 1
    };
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &invalid, &plan, error);
    plan_rejected(suite, "NULL-flag-vector-refused", accepted, &plan, error);
    char *bad_flag_values[] =
    {
        NULL
    };
    invalid.values = bad_flag_values;
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &invalid, &plan, error);
    plan_rejected(suite, "NULL-flag-entry-refused", accepted, &plan, error);
    bad_flag_values[0] = "-DVALUE=a\nb";
    accepted = hp_plan_assembly(BUSTER_PLAN_CC, "src/unit.c", "unit.s", &invalid, &plan, error);
    plan_rejected(suite, "control-byte-in-C-flag-refused", accepted, &plan, error);
    accepted = hp_plan_assembly(BUSTER_PLAN_CC, "src/../unit.c", "unit.s", &flags, &plan, error);
    plan_rejected(suite, "assembly-source-dotdot-refused", accepted, &plan, error);
    accepted = hp_plan_assemble(BUSTER_PLAN_CC, "-unit.s", "unit.o", &plan, error);
    plan_rejected(suite, "assembler-input-leading-option-refused", accepted, &plan, error);
    accepted = hp_plan_assemble(BUSTER_PLAN_CC, "unit.s", "@unit.o", &plan, error);
    plan_rejected(suite, "assembler-output-response-value-refused", accepted, &plan, error);
    accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, 3, NULL, "compiler", &plan, error);
    plan_rejected(suite, "link-checker-index-out-of-range", accepted, &plan, error);
    accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, SIZE_MAX, "checker.o", "compiler", &plan, error);
    plan_rejected(suite, "link-checker-index-overflow", accepted, &plan, error);
    accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, 1, "", "compiler", &plan, error);
    plan_rejected(suite, "link-empty-checker-replacement-refused", accepted, &plan, error);
    accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, 1, "@checker.o", "compiler", &plan, error);
    plan_rejected(suite, "link-response-checker-replacement-refused", accepted, &plan, error);
    accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, 1, NULL, "-compiler", &plan, error);
    plan_rejected(suite, "link-leading-option-image-refused", accepted, &plan, error);
    accepted = hp_plan_link(BUSTER_PLAN_CC, &empty, 0, NULL, "compiler", &plan, error);
    plan_rejected(suite, "link-empty-inventory-refused", accepted, &plan, error);
    accepted = hp_plan_link(BUSTER_PLAN_CC, NULL, 0, NULL, "compiler", &plan, error);
    plan_rejected(suite, "link-NULL-inventory-refused", accepted, &plan, error);
    object_values[0] = "-first.o";
    accepted = hp_plan_link(BUSTER_PLAN_CC, &objects, 1, NULL, "compiler", &plan, error);
    plan_rejected(suite, "link-source-order-object-leading-option-refused", accepted, &plan, error);
    object_values[0] = "/private output/first.o";
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &flags, NULL, error);
    plan_record(suite, "NULL-command-output-refused", !accepted && error[0] != 0, error);
    return;
}

static void plan_capacity_controls(PlanSuite *suite)
{
    char *values[BUSTER_HP_ARGUMENT_LIMIT + 1] = { 0 };
    for (size_t index = 0; index < BUSTER_PLAN_ARRAY_COUNT(values); index += 1)
    {
        values[index] = "-Wall";
    }
    HpArguments flags =
    {
        .values = values,
        .count = BUSTER_HP_ARGUMENT_LIMIT - 7
    };
    HpPlanArguments plan = { 0 };
    char error[BUSTER_HP_ERROR_CAPACITY] = { 0 };
    bool accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &flags, &plan, error);
    bool complete = accepted && plan.count == BUSTER_HP_ARGUMENT_LIMIT && plan.values[BUSTER_HP_ARGUMENT_LIMIT] == NULL;
    for (size_t index = 7; complete && index < plan.count; index += 1)
    {
        complete = plan.values[index] == values[index - 7];
    }
    plan_record(suite, "direct-exact-4096-argument-bound", complete, error);
    flags.count += 1;
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &flags, &plan, error);
    plan_rejected(suite, "direct-over-argument-bound", accepted, &plan, error);
    flags.count = BUSTER_HP_ARGUMENT_LIMIT - 5;
    accepted = hp_plan_assembly(BUSTER_PLAN_CC, "src/unit.c", "unit.s", &flags, &plan, error);
    complete = accepted && plan.count == BUSTER_HP_ARGUMENT_LIMIT && plan.values[BUSTER_HP_ARGUMENT_LIMIT] == NULL;
    for (size_t index = 5; complete && index < plan.count; index += 1)
    {
        complete = plan.values[index] == values[index - 5];
    }
    plan_record(suite, "assembly-exact-4096-argument-bound", complete, error);
    flags.count += 1;
    accepted = hp_plan_assembly(BUSTER_PLAN_CC, "src/unit.c", "unit.s", &flags, &plan, error);
    plan_rejected(suite, "assembly-over-argument-bound", accepted, &plan, error);
    flags.count = SIZE_MAX;
    accepted = hp_plan_compile(BUSTER_PLAN_CC, "src/unit.c", "unit.o", "unit.json", &flags, &plan, error);
    plan_rejected(suite, "command-argument-count-overflow", accepted, &plan, error);
    char names[BUSTER_HP_SOURCE_LIMIT + 1][64] = { 0 };
    char *objects[BUSTER_HP_SOURCE_LIMIT + 1] = { 0 };
    for (size_t index = 0; index < BUSTER_PLAN_ARRAY_COUNT(names); index += 1)
    {
        int size = snprintf(names[index], sizeof(names[index]), "objects/unit%zu.o", index);
        assert(size > 0 && (size_t)size < sizeof(names[index]));
        objects[index] = names[index];
    }
    HpArguments inventory =
    {
        .values = objects,
        .count = BUSTER_HP_SOURCE_LIMIT
    };
    const char *replacement = "objects/checker-inside16.o";
    accepted = hp_plan_link(BUSTER_PLAN_CC, &inventory, 173, replacement, "compiler", &plan, error);
    complete = accepted && plan.count == BUSTER_HP_SOURCE_LIMIT + 7 && plan.values[plan.count] == NULL;
    for (size_t index = 0; complete && index < inventory.count; index += 1)
    {
        complete = plan.values[index + 3] == (index == 173 ? replacement : objects[index]);
    }
    plan_record(suite, "link-exact-256-source-order-objects-and-one-replacement", complete, error);
    inventory.count += 1;
    accepted = hp_plan_link(BUSTER_PLAN_CC, &inventory, 173, replacement, "compiler", &plan, error);
    plan_rejected(suite, "link-over-object-inventory-bound", accepted, &plan, error);
    char long_value[BUSTER_HP_PATH_CAPACITY + 1];
    memset(long_value, 'a', sizeof(long_value));
    long_value[BUSTER_HP_PATH_CAPACITY - 1] = 0;
    accepted = hp_plan_assemble(BUSTER_PLAN_CC, long_value, "unit.o", &plan, error);
    plan_record(suite, "assembler-operand-exact-string-bound", accepted && plan.count == 9 && plan.values[6] == long_value, error);
    long_value[BUSTER_HP_PATH_CAPACITY - 1] = 'a';
    long_value[BUSTER_HP_PATH_CAPACITY] = 0;
    accepted = hp_plan_assemble(BUSTER_PLAN_CC, long_value, "unit.o", &plan, error);
    plan_rejected(suite, "assembler-operand-over-string-bound", accepted, &plan, error);
    return;
}

int main(void)
{
    PlanSuite suite = { 0 };
    plan_source_controls(&suite);
    plan_decimal_controls(&suite);
    plan_argv_controls(&suite);
    plan_capacity_controls(&suite);
    printf("Pure-C plan controls: %zu cases, %zu failures; synthetic strings and pointer arrays only, no producer or subprocess.\n", suite.count, suite.failures);
    return suite.failures != 0;
}
