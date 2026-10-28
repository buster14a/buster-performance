// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused adapter for the transactional scratch oracle and guarded recipe API.
#define BUSTER_UNIT 99
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CBuiltinLowerTestTally tally = { 0 };
    cbuiltin_lower_test_guards(&tally);
    cbuiltin_lower_test_wide_refusals(&tally);
    cbuiltin_lower_test_scratch(&tally);
    fprintf(stderr, "focused builtin scratch: %" PRIu64 " checks, %" PRIu64 " failures\n", tally.checks, tally.failures);
    return tally.failures != 0;
}
