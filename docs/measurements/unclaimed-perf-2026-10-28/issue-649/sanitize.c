// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original adapter to the actual permanent printer tests.
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
    char directory[] = "/tmp/buster-printer-649-XXXXXX";
    bool result = mkdtemp(directory) != 0 && pp_test_print_offsets();
    result = result && pp_test_print_batches(directory);
    rmdir(directory);
    scratch_release();
    return !result;
}
