// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused adapter for the permanent literal-table regressions.
// main-standalone.c copies this checkout's main.c with BUSTER_ELSEWHERE empty; section GC drops the renamed driver.
#define main buster_unused_main
#include "main-standalone.c"
#undef main
int main(void)
{
    CheckTest test = { .random = 658 };
    const bool initialized = x86_encoder_initialize() && x86_semantics_initialize() && tier0_initialize();
    check_test_expect(&test, initialized, "native backend tables initialize");
    if (initialized)
    {
        check_test_literal_tables(&test, "/usr/bin/clang");
    }
    check_test_program_build_release();
    printf("literal-tables-658: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
