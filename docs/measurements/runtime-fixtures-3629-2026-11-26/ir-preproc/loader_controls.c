// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#define LOADER_CHECK_NO_MAIN
#include "loader_check.c"
#include <errno.h>

static bool write_file(const char* path, const void* bytes, size_t length)
{
    FILE* file = fopen(path, "wb");
    bool valid = file != NULL && fwrite(bytes, 1, length, file) == length;
    if (file != NULL)
    {
        valid = fclose(file) == 0 && valid;
    }
    return valid;
}

static bool check(Arena* arena, const char* root, const char* suite, bool accepted, uint32_t expected_count, const char* label)
{
    arena->length = 0;
    ir_parse_test_fixture_root = root;
    IrParseTest test = { 0 };
    uint32_t count = 0;
    const IrParseTestCase* rows = ir_parse_test_cases_load(&test, suite, arena, &count);
    const bool valid = accepted ? rows != NULL && test.failures == 0 && count == expected_count : rows == NULL && test.failures == 1 && count == 0;
    printf("%s: %s\n", label, valid ? "PASS" : "FAIL");
    return valid;
}

int main(int argc, char** argv)
{
    Arena arena = { .capacity = UINT64_C(1) << 24 };
    arena.bytes = malloc(arena.capacity);
    bool valid = argc == 2 && arena.bytes != NULL;
    const char* suites[] = { "invalid", "overflow", "reachable", "diagnostics" };
    const uint32_t counts[] = { 53, 5, 4, 6 };
    for (uint32_t i = 0; valid && i < 4; i += 1)
    {
        valid = check(&arena, argv[1], suites[i], true, counts[i], suites[i]);
    }
    char temporary[] = "/tmp/buster-ir-loader-XXXXXX";
    valid = valid && mkdtemp(temporary) != NULL;
    char path[4096];
    snprintf(path, sizeof(path), "%s/ir", temporary);
    valid = valid && mkdir(path, 0700) == 0;
    snprintf(path, sizeof(path), "%s/ir/invalid", temporary);
    valid = valid && mkdir(path, 0700) == 0;
    char input[4096];
    snprintf(input, sizeof(input), "%s/ir/invalid/one.ir", temporary);
    valid = valid && write_file(input, "", 0);
    char catalog[4096];
    snprintf(catalog, sizeof(catalog), "%s/ir/invalid/catalog.tsv", temporary);
    const char* header = "buster-fixtures v1 ir-parser-cases\n";
    const char* one = "buster-fixtures v1 ir-parser-cases\none\tone.ir\tend\t-\t0\t0\n";
    const char* duplicate = "buster-fixtures v1 ir-parser-cases\none\tone.ir\tend\t-\t0\t0\none\tone.ir\tend\t-\t0\t0\n";
    valid = valid && write_file(catalog, one, strlen(one)) && check(&arena, temporary, "invalid", true, 1, "new empty-input case");
    valid = valid && write_file(catalog, duplicate, strlen(duplicate)) && check(&arena, temporary, "invalid", false, 0, "duplicate case");
    valid = valid && write_file(catalog, header, strlen(header)) && check(&arena, temporary, "invalid", false, 0, "empty inventory");
    valid = valid && write_file(catalog, one, strlen(one) - 1) && check(&arena, temporary, "invalid", false, 0, "missing final newline");
    char malformed[512];
    strcpy(malformed, one);
    malformed[5] = 0;
    valid = valid && write_file(catalog, malformed, strlen(one)) && check(&arena, temporary, "invalid", false, 0, "embedded catalog NUL");
    valid = valid && write_file(catalog, one, strlen(one));
    char orphan[4096];
    snprintf(orphan, sizeof(orphan), "%s/ir/invalid/orphan.raw", temporary);
    valid = valid && write_file(orphan, "x", 1) && check(&arena, temporary, "invalid", false, 0, "unlisted non-IR file");
    unlink(orphan);
    unlink(input);
    valid = valid && check(&arena, temporary, "invalid", false, 0, "missing input");
    valid = valid && mkdir(input, 0700) == 0 && check(&arena, temporary, "invalid", false, 0, "directory as input");
    rmdir(input);
    const char* bad_count = "buster-fixtures v1 ir-parser-cases\none\tone.ir\tend\t-\t999999999999999999999999999\t0\n";
    valid = valid && write_file(input, "", 0) && write_file(catalog, bad_count, strlen(bad_count)) && check(&arena, temporary, "invalid", false, 0, "overflowing metadata");
    unlink(catalog);
    valid = valid && check(&arena, temporary, "invalid", false, 0, "missing catalog");
    unlink(input);
    snprintf(path, sizeof(path), "%s/ir/invalid", temporary);
    rmdir(path);
    snprintf(path, sizeof(path), "%s/ir", temporary);
    rmdir(path);
    rmdir(temporary);
    free(arena.bytes);
    return valid ? 0 : 1;
}
