// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original entry point for exact in-tree ABI oracles without the cross-unit command dispatcher.
#define BUSTER_UNIT BUSTER_UNIT_TYPES
#include "buster/compiler/main.c"

_Thread_local ThreadContext thread_context = {
    .lane = {
        .index = 0,
        .count = 1,
        .group = 0,
    },
};

int main(void)
{
    bool passed = abi_test_merge();
    passed = abi_test_dependencies() && passed;
    passed = abi_test_fixtures() && passed;
    passed = abi_test_worlds(1, 2000) && passed;
    passed = abi_test_gcc_bit_fields() && passed;
    passed = abi_test_assignment(1, 2000) && passed;
    return passed ? 0 : 1;
}
