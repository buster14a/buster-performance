// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Focused standalone build of the repository's DWARF unit tests.
#include <immintrin.h>
#include <stdbool.h>
#include <stdint.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

typedef struct String8
{
    char* pointer;
    uint64_t length;
} String8;
#define BUSTER_S8(text) ((String8){ .pointer = text, .length = sizeof(text) - 1 })
#define BUSTER_ARRAY_LENGTH(array) (sizeof(array) / sizeof((array)[0]))
#include "buster/src/buster/compiler/debug.c"
#include "debug_tests.inc"

int main(void)
{
    bool valid = debug_test_rows();
    valid &= debug_test_random_rows();
    valid &= debug_test_units();
    valid &= debug_test_plans();
    valid &= debug_test_bases();
    valid &= debug_test_guards();
    printf("DebugPlan bytes: %zu\n", sizeof(DebugPlan));
    return valid ? 0 : 1;
}
