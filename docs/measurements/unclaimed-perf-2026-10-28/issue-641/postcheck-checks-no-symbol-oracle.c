// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused #641 adapter. main-standalone.c is this tree's main.c with BUSTER_ELSEWHERE empty so the
// module entry points emit in one translation unit; the unused renamed driver is removed by section GC.
#define main buster_unused_main
#include "main-standalone.c"
#undef main
int main(void)
{
    CheckTest test = { .random = 641 };
    check_init_test_index(&test);
    check_test_program_definition_index(&test);
    check_test_initializers(&test, "/usr/bin/clang");
    check_test_program_selection(&test, NULL);
    check_test_driver_reports(&test);
    printf("postcheck-641: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
