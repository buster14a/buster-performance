// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original local adapter for permanent guarded comma tests and existing prefix/repair semantic oracles.
#define BUSTER_UNIT 2
#include <stdint.h>
static uint64_t diagnostic_walk_failures;
#include "main-standalone.c"
#ifdef BUSTER_529_EXPECT_HOST_VECTOR
_Static_assert(BUSTER_HOST_VECTOR == BUSTER_529_EXPECT_HOST_VECTOR, "oracle host mode must match the requested build");
#endif
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = { .random = 529 };
    check_test_expression_commas(&test);
    check_test_prefixes(&test, "clang");
    check_test_repairs(&test, "clang");
    printf("comma, prefix and repair oracles: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
