// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused sanitizer adapter for permanent empty-column and guarded scalar/vector regressions.
#define main buster_unused_main
#include "main416-standalone.c"
#undef main

int main(void)
{
    CheckTest test = { .random = 628 };
    const bool initialized = x86_encoder_initialize() && x86_semantics_initialize() && tier0_initialize();
    check_test_expect(&test, initialized, "backend tables initialize");
    if (initialized)
    {
        check_test_input_scans(&test);
        check_test_asm_empty_column(&test);
    }
    printf("asm-column628 focused: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
