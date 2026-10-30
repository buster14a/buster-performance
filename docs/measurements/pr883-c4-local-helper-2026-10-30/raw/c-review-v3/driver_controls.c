// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Fresh C-only synthetic driver receipts. No driver, compiler, assembler,
// subprocess or target image is invoked by this control executable.
#include "hp_driver.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#define BUSTER_DRIVER_CONTROL_LIMIT 128U
#define BUSTER_DRIVER_EXECUTABLE "/private cache/clang23/bin/clang-23"
#define BUSTER_DRIVER_BASE "\"" BUSTER_DRIVER_EXECUTABLE "\" \"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\""
#define BUSTER_DRIVER_ASM "\"" BUSTER_DRIVER_EXECUTABLE "\" \"-cc1as\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\""
#define BUSTER_DRIVER_FEATURES " \"-target-feature\" \"+avx2\" \"-target-feature\" \"-avx512f\" \"-target-feature\" \"+64bit\""
#define BUSTER_DRIVER_HEADER "clang version 23.1.4 (official synthetic receipt)\nTarget: " BUSTER_HP_DRIVER_TARGET "\nThread model: posix\nInstalledDir: /private cache/clang23/bin\n (in-process)\n"
#define BUSTER_DRIVER_ARRAY_COUNT(values) (sizeof(values) / sizeof((values)[0]))

typedef struct DriverResult DriverResult;
struct DriverResult
{
    const char *name;
    bool expected;
    bool accepted;
    bool passed;
    char error[BUSTER_HP_ERROR_CAPACITY];
};

typedef struct DriverSuite DriverSuite;
struct DriverSuite
{
    DriverResult results[BUSTER_DRIVER_CONTROL_LIMIT];
    size_t count;
    size_t failures;
};

typedef struct DriverBuffer DriverBuffer;
struct DriverBuffer
{
    unsigned char *data;
    size_t size;
    size_t capacity;
};

static void driver_record(DriverSuite *suite, const char *name, bool expected, bool accepted, const char *error)
{
    assert(suite->count < BUSTER_DRIVER_ARRAY_COUNT(suite->results));
    DriverResult *result = &suite->results[suite->count++];
    result->name = name;
    result->expected = expected;
    result->accepted = accepted;
    result->passed = expected == accepted;
    snprintf(result->error, sizeof(result->error), "%s", error);
    suite->failures += !result->passed;
    printf("%s %s%s%s\n", result->passed ? "PASS" : "FAIL", name, !result->passed ? ": " : "", !result->passed ? error : "");
    return;
}

static HpBytes driver_bytes(const char *text)
{
    HpBytes bytes =
    {
        (const unsigned char *)text,
        strlen(text)
    };
    return bytes;
}

static void driver_case_bytes(DriverSuite *suite, const char *name, HpBytes bytes, const char *mode, bool expected)
{
    HpDriverIsa isa = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool accepted = hp_driver_isa(bytes, mode, &isa, error);
    driver_record(suite, name, expected, accepted, error);
    if (!accepted)
    {
        bool empty = isa.executable[0] == 0 && isa.triple[0] == 0 && isa.cpu[0] == 0 && isa.features.storage == NULL && isa.features.values == NULL && isa.features.count == 0;
        assert(empty && error[0] != 0);
    }
    hp_driver_free(&isa);
    return;
}

static void driver_case(DriverSuite *suite, const char *name, const char *text, const char *mode, bool expected)
{
    driver_case_bytes(suite, name, driver_bytes(text), mode, expected);
    return;
}

static void driver_fixed_cases(DriverSuite *suite)
{
    driver_case(suite, "C-receipt-with-real-shaped-headers", BUSTER_DRIVER_HEADER " " BUSTER_DRIVER_BASE BUSTER_DRIVER_FEATURES " \"-emit-obj\" \"-o\" \"/private output/file.o\" \"-x\" \"c\" \"input file.c\"\n", "-cc1", true);
    driver_case(suite, "ASM-receipt-with-headers", BUSTER_DRIVER_HEADER "\t" BUSTER_DRIVER_ASM BUSTER_DRIVER_FEATURES " \"-filetype\" \"obj\" \"-o\" \"output file.o\" \"input file.s\"\n", "-cc1as", true);
    driver_case(suite, "no-final-newline", BUSTER_DRIVER_BASE BUSTER_DRIVER_FEATURES, "-cc1", true);
    driver_case(suite, "zero-explicit-features-retains-CPU", BUSTER_DRIVER_BASE, "-cc1", true);
    driver_case(suite, "blank-lines-and-horizontal-whitespace", "\n \t\n\t " BUSTER_DRIVER_BASE " \t\n\n", "-cc1", true);
    driver_case(suite, "known-GCC-and-build-headers", "Build config: +assertions\nFound candidate GCC installation: /usr/lib/gcc/x86_64-linux-gnu/15\nSelected GCC installation: /usr/lib/gcc/x86_64-linux-gnu/15\nCandidate multilib: .;@m64\nSelected multilib: .;@m64\n" BUSTER_DRIVER_BASE, "-cc1", true);
    driver_case(suite, "literal-shell-metacharacters-are-quoted-data", BUSTER_DRIVER_BASE " \"-D\" \"TEXT=$(nothing);`nothing`*\"", "-cc1", true);
    driver_case(suite, "escaped-quote-and-backslash-in-extra-value", BUSTER_DRIVER_BASE " \"-D\" \"TEXT=\\\"quoted\\\"\\\\path\"", "-cc1", true);
    driver_case(suite, "feature-multiplicity-retained", BUSTER_DRIVER_BASE " \"-target-feature\" \"+avx2\" \"-target-feature\" \"+avx2\"", "-cc1", true);
    static const struct
    {
        const char *name;
        const char *text;
        const char *mode;
    } bad[] =
    {
        {
            "missing-internal-command",
            BUSTER_DRIVER_HEADER,
            "-cc1"
        },
        {
            "duplicate-internal-command",
            BUSTER_DRIVER_BASE "\n" BUSTER_DRIVER_BASE,
            "-cc1"
        },
        {
            "extra-unrelated-quoted-command",
            BUSTER_DRIVER_BASE "\n\"/usr/bin/wild\" \"input.o\"",
            "-cc1"
        },
        {
            "wrong-internal-mode",
            BUSTER_DRIVER_ASM,
            "-cc1"
        },
        {
            "unsupported-requested-mode",
            BUSTER_DRIVER_BASE,
            "-cc2"
        },
        {
            "NULL-requested-mode",
            BUSTER_DRIVER_BASE,
            NULL
        },
        {
            "mode-in-wrong-position",
            "\"/clang\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\" \"-cc1\"",
            "-cc1"
        },
        {
            "duplicate-mode-token",
            BUSTER_DRIVER_BASE " \"-cc1\"",
            "-cc1"
        },
        {
            "mixed-internal-modes",
            BUSTER_DRIVER_BASE " \"-cc1as\"",
            "-cc1"
        },
        {
            "missing-CPU",
            "\"/clang\" \"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\"",
            "-cc1"
        },
        {
            "duplicate-CPU",
            BUSTER_DRIVER_BASE " \"-target-cpu\" \"znver5\"",
            "-cc1"
        },
        {
            "wrong-CPU",
            "\"/clang\" \"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver4\"",
            "-cc1"
        },
        {
            "missing-triple",
            "\"/clang\" \"-cc1\" \"-target-cpu\" \"znver5\"",
            "-cc1"
        },
        {
            "duplicate-triple",
            BUSTER_DRIVER_BASE " \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\"",
            "-cc1"
        },
        {
            "wrong-triple",
            "\"/clang\" \"-cc1\" \"-triple\" \"x86_64-pc-linux-gnu\" \"-target-cpu\" \"znver5\"",
            "-cc1"
        },
        {
            "truncated-CPU-option",
            BUSTER_DRIVER_BASE " \"-target-cpu\"",
            "-cc1"
        },
        {
            "truncated-triple-option",
            BUSTER_DRIVER_BASE " \"-triple\"",
            "-cc1"
        },
        {
            "truncated-feature-option",
            BUSTER_DRIVER_BASE " \"-target-feature\"",
            "-cc1"
        },
        {
            "missing-feature-value-before-next-option",
            BUSTER_DRIVER_BASE " \"-target-feature\" \"-target-feature\" \"+avx2\"",
            "-cc1"
        },
        {
            "empty-feature-value",
            BUSTER_DRIVER_BASE " \"-target-feature\" \"\"",
            "-cc1"
        },
        {
            "feature-sign-only",
            BUSTER_DRIVER_BASE " \"-target-feature\" \"+\"",
            "-cc1"
        },
        {
            "feature-without-sign",
            BUSTER_DRIVER_BASE " \"-target-feature\" \"avx2\"",
            "-cc1"
        },
        {
            "feature-with-space",
            BUSTER_DRIVER_BASE " \"-target-feature\" \"+avx 2\"",
            "-cc1"
        },
        {
            "feature-with-decoded-quote",
            BUSTER_DRIVER_BASE " \"-target-feature\" \"+avx\\\"2\"",
            "-cc1"
        },
        {
            "unknown-escape-q",
            BUSTER_DRIVER_BASE " \"value\\q\"",
            "-cc1"
        },
        {
            "unsupported-escape-n",
            BUSTER_DRIVER_BASE " \"value\\n\"",
            "-cc1"
        },
        {
            "unsupported-hex-escape",
            BUSTER_DRIVER_BASE " \"value\\x41\"",
            "-cc1"
        },
        {
            "unsupported-escaped-space",
            BUSTER_DRIVER_BASE " \"value\\ space\"",
            "-cc1"
        },
        {
            "truncated-escape",
            BUSTER_DRIVER_BASE " \"value\\",
            "-cc1"
        },
        {
            "unterminated-quote",
            BUSTER_DRIVER_BASE " \"value",
            "-cc1"
        },
        {
            "unquoted-trailing-junk",
            BUSTER_DRIVER_BASE " ; true",
            "-cc1"
        },
        {
            "quote-concatenated-unquoted-junk",
            BUSTER_DRIVER_BASE " \"value\"x",
            "-cc1"
        },
        {
            "adjacent-quoted-token-without-separator",
            BUSTER_DRIVER_BASE " \"value\"\"other\"",
            "-cc1"
        },
        {
            "single-quoted-token",
            BUSTER_DRIVER_BASE " 'value'",
            "-cc1"
        },
        {
            "multiline-quoted-token",
            BUSTER_DRIVER_BASE " \"value\nother\"",
            "-cc1"
        },
        {
            "unknown-header-or-diagnostic",
            "unexpected diagnostic\n" BUSTER_DRIVER_BASE,
            "-cc1"
        },
        {
            "wrong-version-header",
            "clang version 23.1.3\n" BUSTER_DRIVER_BASE,
            "-cc1"
        },
        {
            "wrong-target-header",
            "Target: aarch64-unknown-linux-gnu\n" BUSTER_DRIVER_BASE,
            "-cc1"
        },
        {
            "relative-executable",
            "\"clang\" \"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\"",
            "-cc1"
        },
        {
            "empty-executable",
            "\"\" \"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\"",
            "-cc1"
        },
        {
            "CRLF-format-refused",
            BUSTER_DRIVER_BASE "\r\n",
            "-cc1"
        }
    };
    for (size_t i = 0; i < BUSTER_DRIVER_ARRAY_COUNT(bad); i += 1)
    {
        driver_case(suite, bad[i].name, bad[i].text, bad[i].mode, false);
    }
    HpBytes null_bytes =
    {
        NULL,
        5
    };
    driver_case_bytes(suite, "NULL-log-nonzero-size", null_bytes, "-cc1", false);
    null_bytes.data = (const unsigned char *)"x";
    null_bytes.size = SIZE_MAX;
    driver_case_bytes(suite, "log-size-overflow", null_bytes, "-cc1", false);
    driver_case(suite, "empty-log", "", "-cc1", false);
    static const unsigned char nul[] = BUSTER_DRIVER_BASE "\0trailing bytes";
    HpBytes embedded =
    {
        nul,
        sizeof(nul) - 1
    };
    driver_case_bytes(suite, "embedded-NUL", embedded, "-cc1", false);
    driver_case(suite, "control-byte", BUSTER_DRIVER_BASE "\x01", "-cc1", false);
    driver_case(suite, "DEL-byte", BUSTER_DRIVER_BASE "\x7f", "-cc1", false);
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool accepted = hp_driver_isa(driver_bytes(BUSTER_DRIVER_BASE), "-cc1", NULL, error);
    driver_record(suite, "NULL-output-rejected", false, accepted, error);
    return;
}

static void driver_buffer_init(DriverBuffer *buffer)
{
    buffer->capacity = BUSTER_HP_DRIVER_LOG_LIMIT + 2;
    buffer->data = calloc(buffer->capacity, 1);
    assert(buffer->data != NULL);
    return;
}

static void driver_append(DriverBuffer *buffer, const void *bytes, size_t size)
{
    assert(size <= buffer->capacity - buffer->size);
    memcpy(buffer->data + buffer->size, bytes, size);
    buffer->size += size;
    return;
}

static void driver_append_text(DriverBuffer *buffer, const char *text)
{
    driver_append(buffer, text, strlen(text));
    return;
}

static void driver_append_quote(DriverBuffer *buffer, const char *text)
{
    driver_append_text(buffer, "\"");
    for (size_t i = 0; text[i] != 0; i += 1)
    {
        if (text[i] == '"' || text[i] == '\\')
        {
            driver_append_text(buffer, "\\");
        }
        driver_append(buffer, text + i, 1);
    }
    driver_append_text(buffer, "\" ");
    return;
}

static void driver_boundary_cases(DriverSuite *suite)
{
    DriverBuffer buffer = {0};
    driver_buffer_init(&buffer);
    char *long_value = malloc(BUSTER_HP_PATH_CAPACITY + 1);
    assert(long_value != NULL);
    memset(long_value, 'a', BUSTER_HP_PATH_CAPACITY);
    long_value[0] = '/';
    long_value[BUSTER_HP_PATH_CAPACITY - 1] = 0;
    driver_append_quote(&buffer, long_value);
    driver_append_text(&buffer, "\"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\"");
    HpBytes bytes =
    {
        buffer.data,
        buffer.size
    };
    driver_case_bytes(suite, "executable-exact-capacity-minus-one", bytes, "-cc1", true);
    buffer.size = 0;
    long_value[BUSTER_HP_PATH_CAPACITY - 1] = 'a';
    long_value[BUSTER_HP_PATH_CAPACITY] = 0;
    driver_append_quote(&buffer, long_value);
    driver_append_text(&buffer, "\"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\"");
    bytes.size = buffer.size;
    driver_case_bytes(suite, "executable-over-capacity-no-truncation", bytes, "-cc1", false);
    buffer.size = 0;
    driver_append_text(&buffer, BUSTER_DRIVER_BASE " \"-target-feature\" ");
    long_value[0] = '+';
    long_value[BUSTER_HP_PATH_CAPACITY - 1] = 0;
    driver_append_quote(&buffer, long_value);
    bytes.size = buffer.size;
    driver_case_bytes(suite, "feature-exact-token-bound", bytes, "-cc1", true);
    buffer.size = 0;
    driver_append_text(&buffer, BUSTER_DRIVER_BASE " \"-target-feature\" ");
    long_value[BUSTER_HP_PATH_CAPACITY - 1] = 'a';
    driver_append_quote(&buffer, long_value);
    bytes.size = buffer.size;
    driver_case_bytes(suite, "feature-over-token-bound-no-truncation", bytes, "-cc1", false);
    free(long_value);
    buffer.size = 0;
    driver_append_text(&buffer, BUSTER_DRIVER_BASE);
    for (size_t i = 6; i < BUSTER_HP_ARGUMENT_LIMIT; i += 1)
    {
        driver_append_text(&buffer, " \"x\"");
    }
    bytes.size = buffer.size;
    driver_case_bytes(suite, "exact-command-token-bound", bytes, "-cc1", true);
    driver_append_text(&buffer, " \"x\"");
    bytes.size = buffer.size;
    driver_case_bytes(suite, "over-command-token-bound", bytes, "-cc1", false);
    size_t command_size = strlen(BUSTER_DRIVER_BASE);
    memset(buffer.data, ' ', BUSTER_HP_DRIVER_LOG_LIMIT - command_size);
    memcpy(buffer.data + BUSTER_HP_DRIVER_LOG_LIMIT - command_size, BUSTER_DRIVER_BASE, command_size);
    bytes.size = BUSTER_HP_DRIVER_LOG_LIMIT;
    driver_case_bytes(suite, "exact-log-byte-bound", bytes, "-cc1", true);
    buffer.data[BUSTER_HP_DRIVER_LOG_LIMIT] = '\n';
    bytes.size += 1;
    driver_case_bytes(suite, "over-log-byte-bound", bytes, "-cc1", false);
    free(buffer.data);
    return;
}

static void driver_contract_cases(DriverSuite *suite)
{
    HpDriverIsa c = {0};
    HpDriverIsa assembler = {0};
    HpDriverIsa other = {0};
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    bool parsed = hp_driver_isa(driver_bytes(BUSTER_DRIVER_BASE BUSTER_DRIVER_FEATURES), "-cc1", &c, error);
    bool parsed_asm = hp_driver_isa(driver_bytes(BUSTER_DRIVER_ASM BUSTER_DRIVER_FEATURES), "-cc1as", &assembler, error);
    driver_record(suite, "C-and-ASM-ordered-ISA-equal", true, parsed && parsed_asm && hp_driver_equal(&c, &assembler), error);
    bool fields = parsed && strcmp(c.executable, BUSTER_DRIVER_EXECUTABLE) == 0 && strcmp(c.triple, BUSTER_HP_DRIVER_TARGET) == 0 && strcmp(c.cpu, "znver5") == 0 && c.features.count == 3 && strcmp(c.features.values[0], "+avx2") == 0 && strcmp(c.features.values[1], "-avx512f") == 0 && strcmp(c.features.values[2], "+64bit") == 0 && c.features.values[3] == NULL;
    driver_record(suite, "decoded-fields-complete-ordered-and-terminated", true, fields, error);
    bool parsed_other = hp_driver_isa(driver_bytes(BUSTER_DRIVER_ASM " \"-target-feature\" \"-avx512f\" \"-target-feature\" \"+avx2\" \"-target-feature\" \"+64bit\""), "-cc1as", &other, error);
    driver_record(suite, "feature-reordering-is-not-equal", true, parsed && parsed_other && !hp_driver_equal(&c, &other), error);
    hp_driver_free(&other);
    parsed_other = hp_driver_isa(driver_bytes(BUSTER_DRIVER_ASM " \"-target-feature\" \"+avx2\" \"-target-feature\" \"-avx512f\" \"-target-feature\" \"-64bit\""), "-cc1as", &other, error);
    driver_record(suite, "feature-value-change-is-not-equal", true, parsed && parsed_other && !hp_driver_equal(&c, &other), error);
    hp_driver_free(&other);
    parsed_other = hp_driver_isa(driver_bytes(BUSTER_DRIVER_ASM BUSTER_DRIVER_FEATURES " \"-target-feature\" \"+64bit\""), "-cc1as", &other, error);
    driver_record(suite, "duplicate-feature-count-is-not-equal", true, parsed && parsed_other && !hp_driver_equal(&c, &other), error);
    hp_driver_free(&other);
    static const char escaped[] = "\"/private path/clang\\\"quote\\\\slash\" \"-cc1\" \"-triple\" \"" BUSTER_HP_DRIVER_TARGET "\" \"-target-cpu\" \"znver5\"" BUSTER_DRIVER_FEATURES;
    parsed_other = hp_driver_isa(driver_bytes(escaped), "-cc1", &other, error);
    bool decoded = parsed_other && strcmp(other.executable, "/private path/clang\"quote\\slash") == 0;
    driver_record(suite, "decoded-executable-quotes-and-backslashes", true, decoded, error);
    driver_record(suite, "executable-identity-remains-separate-caller-gate", true, parsed && parsed_other && hp_driver_equal(&c, &other), error);
    if (parsed_other)
    {
        other.cpu[0] = 'x';
    }
    driver_record(suite, "equality-compares-CPU", true, parsed && parsed_other && !hp_driver_equal(&c, &other), error);
    if (parsed_other)
    {
        memcpy(other.cpu, BUSTER_HP_DRIVER_CPU, sizeof(BUSTER_HP_DRIVER_CPU));
        other.triple[0] = 'y';
    }
    driver_record(suite, "equality-compares-triple", true, parsed && parsed_other && !hp_driver_equal(&c, &other), error);
    hp_driver_free(&other);
    char mutable[] = BUSTER_DRIVER_BASE BUSTER_DRIVER_FEATURES;
    char before[sizeof(mutable)];
    memcpy(before, mutable, sizeof(mutable));
    parsed_other = hp_driver_isa(driver_bytes(mutable), "-cc1", &other, error);
    bool immutable = parsed_other && memcmp(before, mutable, sizeof(mutable)) == 0;
    memset(mutable, 'X', sizeof(mutable));
    bool owns = parsed_other && strcmp(other.executable, BUSTER_DRIVER_EXECUTABLE) == 0 && other.features.count == 3 && strcmp(other.features.values[0], "+avx2") == 0 && hp_driver_equal(&c, &other);
    driver_record(suite, "input-immutable-output-owns-decoded-data", true, immutable && owns, error);
    hp_driver_free(&other);
    driver_record(suite, "free-clears-owned-metadata", true, other.executable[0] == 0 && other.triple[0] == 0 && other.cpu[0] == 0 && other.features.storage == NULL && other.features.values == NULL && other.features.count == 0, "");
    driver_record(suite, "equality-NULL-inputs-fail", false, hp_driver_equal(&c, NULL) || hp_driver_equal(NULL, &c), "");
    hp_driver_free(&c);
    hp_driver_free(&assembler);
    hp_driver_free(NULL);
    return;
}

static void driver_default_cases(DriverSuite *suite)
{
    static const struct
    {
        const char *name;
        const char *text;
        bool expected;
    } cases[] =
    {
        {
            "default-target-exact-no-newline",
            BUSTER_HP_DRIVER_TARGET,
            true
        },
        {
            "default-target-exact-one-LF",
            BUSTER_HP_DRIVER_TARGET "\n",
            true
        },
        {
            "default-target-two-LFs",
            BUSTER_HP_DRIVER_TARGET "\n\n",
            false
        },
        {
            "default-target-CRLF",
            BUSTER_HP_DRIVER_TARGET "\r\n",
            false
        },
        {
            "default-target-leading-space",
            " " BUSTER_HP_DRIVER_TARGET "\n",
            false
        },
        {
            "default-target-trailing-space",
            BUSTER_HP_DRIVER_TARGET " \n",
            false
        },
        {
            "default-target-wrong-triple",
            "x86_64-pc-linux-gnu\n",
            false
        },
        {
            "default-target-duplicate",
            BUSTER_HP_DRIVER_TARGET "\n" BUSTER_HP_DRIVER_TARGET "\n",
            false
        },
        {
            "default-target-junk",
            BUSTER_HP_DRIVER_TARGET "junk",
            false
        },
        {
            "default-target-empty",
            "",
            false
        }
    };
    for (size_t i = 0; i < BUSTER_DRIVER_ARRAY_COUNT(cases); i += 1)
    {
        char error[BUSTER_HP_ERROR_CAPACITY] = {0};
        bool accepted = hp_driver_default_target(driver_bytes(cases[i].text), error);
        driver_record(suite, cases[i].name, cases[i].expected, accepted, error);
    }
    char error[BUSTER_HP_ERROR_CAPACITY] = {0};
    HpBytes bytes =
    {
        NULL,
        sizeof(BUSTER_HP_DRIVER_TARGET) - 1
    };
    driver_record(suite, "default-target-NULL-nonzero", false, hp_driver_default_target(bytes, error), error);
    bytes.data = (const unsigned char *)"x";
    bytes.size = SIZE_MAX;
    driver_record(suite, "default-target-size-overflow", false, hp_driver_default_target(bytes, error), error);
    static const unsigned char nul[] = BUSTER_HP_DRIVER_TARGET "\0";
    bytes.data = nul;
    bytes.size = sizeof(nul) - 1;
    driver_record(suite, "default-target-embedded-final-NUL", false, hp_driver_default_target(bytes, error), error);
    return;
}

static bool driver_results(const DriverSuite *suite, const char *path)
{
    FILE *file = fopen(path, "wx");
    bool valid = file != NULL;
    if (valid)
    {
        fprintf(file, "{\n  \"kind\": \"fresh C synthetic Clang receipt controls\",\n  \"cases\": %zu,\n  \"failures\": %zu,\n  \"results\": [\n", suite->count, suite->failures);
        for (size_t i = 0; i < suite->count; i += 1)
        {
            const DriverResult *result = &suite->results[i];
            fputs("    {\"name\": ", file);
            HpString name =
            {
                result->name,
                strlen(result->name)
            };
            hp_json_string(file, name);
            fprintf(file, ", \"expected_accept\": %s, \"accepted\": %s, \"passed\": %s, \"error\": ", result->expected ? "true" : "false", result->accepted ? "true" : "false", result->passed ? "true" : "false");
            HpString error =
            {
                result->error,
                strlen(result->error)
            };
            hp_json_string(file, error);
            fprintf(file, "}%s\n", i + 1 < suite->count ? "," : "");
        }
        fputs("  ]\n}\n", file);
        valid = ferror(file) == 0;
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

int main(int argc, char **argv)
{
    int status = 2;
    bool valid = argc == 3 && strcmp(argv[1], "--output") == 0;
    if (valid)
    {
        DriverSuite suite = {0};
        driver_fixed_cases(&suite);
        driver_boundary_cases(&suite);
        driver_contract_cases(&suite);
        driver_default_cases(&suite);
        bool written = driver_results(&suite, argv[2]);
        printf("Synthetic C driver controls: %zu cases, %zu failures; no subprocess or producer executed.\n", suite.count, suite.failures);
        status = suite.failures != 0 || !written ? 1 : 0;
    }
    else
    {
        fprintf(stderr, "usage: driver-controls --output NEW_RESULTS_FILE\n");
    }
    return status;
}
