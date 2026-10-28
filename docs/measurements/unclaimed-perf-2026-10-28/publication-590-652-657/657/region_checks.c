// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused adapter for #657. main-standalone.c is the repository main.c with BUSTER_ELSEWHERE empty,
// making its module entry points available to this single-translation-unit test. The renamed driver is discarded.
#define main buster_unused_main
#include "main-standalone.c"
#undef main
int main(void)
{
    CheckTest test = { 0 };
    check_test_source_region_transfers(&test);
    printf("region-transfers: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
