// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Original focused sanitizer adapter for the #603 warning oracle.
// Compile with -I /path/to/pinned/buster/src. These minimal borrowed-column types isolate the production updater.
#define _GNU_SOURCE
#include <immintrin.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#define BUSTER_ARRAY_LENGTH(array) (sizeof(array) / sizeof((array)[0]))
#define BUSTER_CHECK_CONSTANT_BOUND_CONTEXT 2u

typedef struct Parser Parser;
struct Parser
{
    struct
    {
        bool scalar;
    } options;
    struct
    {
        uint32_t count;
    } tokens;
};

typedef struct CheckInput CheckInput;
struct CheckInput
{
    uint8_t* constant_warnings;
    uint8_t* constant_warning_ignored;
};

typedef struct CheckInputReader CheckInputReader;
struct CheckInputReader
{
    const Parser* parser;
    CheckInput* output;
    uint8_t* constant_contexts;
    uint8_t* warning_suppressed;
    uint16_t* warning_index;
    uint32_t warning_index_base;
    bool warning_index_ready;
};

typedef struct CheckTest CheckTest;
struct CheckTest
{
    uint64_t random;
    uint64_t failures;
};

static uint32_t check_test_random(CheckTest* test)
{
    test->random = test->random * UINT64_C(6364136223846793005) + 1;
    return (uint32_t)(test->random >> 32);
}

static void check_test_expect(CheckTest* test, bool valid, const char* description)
{
    if (!valid)
    {
        test->failures += 1;
        fprintf(stderr, "%s\n", description);
    }
}

#include "buster/compiler/c_check_warning_input.c"
#include "buster/compiler/c_check_warning_input_test.c"

int main(void)
{
    CheckTest test = { .random = 603 };
    check_test_warning_ranges(&test);
    printf("guarded warning oracle failures=%llu\n", (unsigned long long)test.failures);
    return test.failures != 0;
}
