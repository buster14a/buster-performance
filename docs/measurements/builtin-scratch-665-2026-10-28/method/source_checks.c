// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused unity adapter. GNU inline emission supplies the ordinary split-unit entry points in this one
// test translation unit; frontend owns the immutable ISA tables. No production build flags or source are changed.
#define BUSTER_UNIT BUSTER_UNIT_FRONTEND
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    const bool epoch = oracle_epoch_begin();
    CheckTest test = { .random = 665 };
    check_test_expect(&test, !BUSTER_HOST_VECTOR, "generic composition uses the scalar host contract");
    check_test_program_builtin_scratch(&test, "clang");
    check_test_program_build_release();
    oracle_epoch_end(epoch);
    scratch_release();
    fprintf(stderr, "focused builtin source scalar host: %" PRIu64 " checks, %" PRIu64 " failures\n", test.checks, test.failures);
    return test.failures != 0;
}
