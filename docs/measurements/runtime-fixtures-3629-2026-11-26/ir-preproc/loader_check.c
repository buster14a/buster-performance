// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <limits.h>
#include <sys/stat.h>
#include <unistd.h>
#include "test_paths.h"
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a) / sizeof((a)[0]))
#define BUSTER_IR_PARSE_TEST_CASES 1024

typedef struct
{
    char* pointer;
    uint64_t length;
} String8;

typedef struct
{
    uint8_t* bytes;
    uint64_t length;
    uint64_t capacity;
} Arena;

static void* arena_push(Arena* arena, uint64_t length, uint64_t alignment)
{
    const uint64_t start = (arena->length + alignment - 1) & ~(alignment - 1);
    void* result = NULL;
    if (start <= arena->capacity && length <= arena->capacity - start)
    {
        result = arena->bytes + start;
        arena->length = start + length;
    }
    return result;
}

typedef struct
{
    uint64_t failures;
} IrParseTest;

static void ir_parse_test_expect(IrParseTest* test, bool valid, const char* message)
{
    if (!valid)
    {
        test->failures += 1;
        fprintf(stderr, "%s\n", message);
    }
}

typedef enum
{
    IR_PARSE_OK,
    IR_PARSE_END,
    IR_PARSE_SYNTAX,
    IR_PARSE_LIMIT,
    IR_PARSE_MEMORY,
    IR_PARSE_VERIFY,
} IrParseError;

static const char* ir_parse_test_fixture_root;
#include "read.inc"
#include "word.inc"
#include "loader.inc"

#ifndef LOADER_CHECK_NO_MAIN
int main(int argc, char** argv)
{
    bool valid = argc == 3;
    Arena arena = { .capacity = UINT64_C(1) << 24 };
    arena.bytes = malloc(arena.capacity);
    valid = valid && arena.bytes != NULL;
    IrParseTest test = { 0 };
    uint32_t count = 0;
    if (valid)
    {
        ir_parse_test_fixture_root = argv[1];
        const IrParseTestCase* rows = ir_parse_test_cases_load(&test, argv[2], &arena, &count);
        valid = rows != NULL && test.failures == 0;
        for (uint32_t i = 0; valid && i < count; i += 1)
        {
            valid = rows[i].source.pointer != NULL && rows[i].source.length <= arena.capacity;
        }
    }
    free(arena.bytes);
    return valid ? 0 : 1;
}
#endif
