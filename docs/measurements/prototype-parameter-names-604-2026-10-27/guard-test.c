// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Run the exact repository membership fixture with ASan/UBSan, independent of the full compiler build.
#define _GNU_SOURCE
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
typedef uint32_t TypeId;
static uint64_t visits;
#include "parameter-tree.inc"
typedef struct CheckTest CheckTest;
struct CheckTest
{
    uint32_t checks;
    uint32_t failures;
};
static void check_test_expect(CheckTest* test, bool valid, const char* description)
{
    test->checks += 1;
    test->failures += !valid;
    if (!valid)
    {
        fprintf(stderr, "%s\n", description);
    }
}
#include "tree-test.inc"
int main(void)
{
    CheckTest test = { 0 };
    check_test_constant_parameter_names(&test);
    check_test_expect(&test, visits <= UINT64_C(33) * 1024, "membership visits exceed the bit-width bound");
    printf("guarded-membership: checks=%u failures=%u visits=%" PRIu64 " part_bytes=%zu parameter_bytes=%zu\n", test.checks, test.failures,
           visits, sizeof(CheckConstantPart), sizeof(CheckConstantParameter));
    return test.failures != 0;
}
