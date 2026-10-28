// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Focused entry point for the compiler's actual guarded template/codec tests. See guarded-sanitizer.sh.
#define BUSTER_UNIT BUSTER_UNIT_CHECKER
#include "main-batch-test.inc"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = { 0 };
    check_test_program_batch(&test);
    printf("batch tests: checks=%llu failures=%llu\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
