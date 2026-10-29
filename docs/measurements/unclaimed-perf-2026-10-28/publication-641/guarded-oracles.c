// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused adapter: retained dense warning, diagnostic-order and sparse initializer oracles.
#include <stdint.h>
static uint64_t diagnostic_walk_failures;
#define main diagnostic_driver_main
#include "main-standalone.c"
#undef main
int main(void)
{
    CheckTest test = { .random = 133 };
    check_init_test_index(&test);
    check_test_warning_ranges(&test);
    check_test_driver_reports(&test);
    printf("post-check guarded oracles: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
