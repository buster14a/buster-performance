// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Run the production validator's focused regression suite under sanitizers.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <inttypes.h>
#include <string.h>
typedef struct String8 String8;
struct String8 { char* pointer; uint64_t length; };
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/link.c"
#include "buster/compiler/x86_semantics.c"
#include "buster/compiler/c_types.c"
#include "buster/compiler/calling_convention.c"
#include "buster/compiler/tier0.c"
#define BUSTER_TIER0_TEST_PAGE 4096

typedef struct Tier0TestTally Tier0TestTally;
struct Tier0TestTally { uint64_t checks; uint64_t failures; };
static bool tier0_test_expect(Tier0TestTally* tally, bool condition, const char* check, const char* format, ...)
{
    tally->checks += 1;
    if (!condition)
    {
        tally->failures += 1;
        va_list args;
        va_start(args, format);
        fprintf(stderr, "%s: ", check);
        vfprintf(stderr, format, args);
        fprintf(stderr, "\n");
        va_end(args);
    }
    return condition;
}
#include "buster/compiler/tier0_validate_test.c"
int main(void)
{
    Tier0TestTally tally = { 0 };
    tier0_test_validation(&tally);
    printf("focused validator: %" PRIu64 " checks, %" PRIu64 " failures\n", tally.checks, tally.failures);
    scratch_release();
    return tally.failures != 0;
}
