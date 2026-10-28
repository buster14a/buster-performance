// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused sanitizer adapter; uses repository tests directly, without a copied implementation.
#define BUSTER_UNIT 2
#include "buster/compiler/main.c"

_Thread_local ThreadContext thread_context =
{
    .lane =
    {
        .count = 1,
    },
};

int main(void)
{
    const bool passed = pp_test_diagnostic_buffer();
    scratch_release();
    return !passed;
}
