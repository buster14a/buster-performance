// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Isolated execution of two existing program fixtures against the unchanged parent source.
#define BUSTER_UNIT BUSTER_UNIT_CHECKER
#include "main-smoke.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = { .random = 612 };
    check_test_program_source(&test,
        "int seen;int mark(int n){seen=seen*10+n;return n;}int tested(int n){seen=0;"
        "double x=n<0?__builtin_nan(\"\"):n==0?0.0:n==1?__builtin_inf():n==2?0x1p-1074:(double)n;"
        "int r=__builtin_fpclassify(mark(1),mark(2),mark(3),mark(4),mark(5),x);return seen*10+r;}",
        "fpclassify-conditional-selector-effects", "clang");
    check_test_program_source(&test,
        "int seen;int mark(int n){seen=seen*10+n;return n;}int tested(int n){seen=0;"
        "int r=__builtin_fpclassify(mark(1),mark(2),mark(3),mark(4),mark(5),(seen++,1.0));return seen*10+r+n;}",
        "fpclassify-known-category-effects", "clang");
    check_test_program_build_release();
    fprintf(stderr, "parent-fpclassify: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 4;
}
