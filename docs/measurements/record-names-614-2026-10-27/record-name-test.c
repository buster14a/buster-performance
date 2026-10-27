// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original standalone adapter for the committed record namespace regressions. This supplies only the reader fields
// used by that routine; the complete test-checker command separately verifies integration with the real reader.
#define _GNU_SOURCE
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <inttypes.h>
typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#define BUSTER_CHECK_NONE UINT32_MAX
#include "buster/compiler/lane.c"
#include "buster/compiler/c_types.c"
typedef struct CheckInput CheckInput;
struct CheckInput
{
    bool resource;
};
typedef struct CheckInputReader CheckInputReader;
struct CheckInputReader
{
    Arena* scratch;
    TypeTable* types;
    CheckInput* output;
};
#ifndef BUSTER_RECORD_INPUT_SOURCE
#define BUSTER_RECORD_INPUT_SOURCE "buster/compiler/c_check_record_input.c"
#endif
#include BUSTER_RECORD_INPUT_SOURCE
typedef struct CheckTest CheckTest;
struct CheckTest
{
    uint64_t checks;
    uint64_t failures;
};
typedef struct CheckTestTypes CheckTestTypes;
struct CheckTestTypes
{
    TypeTable table;
    Arena arena;
    Arena index;
};
static bool check_test_types_open(CheckTestTypes* types)
{
    const TypeCapacity capacity = { .types = 4096, .parameters = 8192, .tags = 512, .members = 4096 };
    types->arena = arena_reserve(type_capacity_bytes(capacity));
    types->index = arena_reserve(type_index_capacity_bytes(capacity));
    return type_initialize(&types->table, &types->arena, &types->index, capacity);
}
static void check_test_types_close(CheckTestTypes* types)
{
    arena_release(&types->index);
    arena_release(&types->arena);
}
static void check_test_expect(CheckTest* test, bool condition, const char* description)
{
    test->checks += 1;
    test->failures += !condition;
    if (!condition && test->failures <= 8)
    {
        fprintf(stderr, "%s\n", description);
    }
}
#include "buster/compiler/c_check_record_input_test.c"
int main(void)
{
    CheckTest test = { 0 };
    check_test_record_names(&test);
    printf("record-name-test: %" PRIu64 " checks, %" PRIu64 " failures\n", test.checks, test.failures);
    return test.failures != 0;
}
