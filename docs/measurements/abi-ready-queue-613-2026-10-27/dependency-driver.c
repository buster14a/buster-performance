// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original targeted entry point for #613's exact in-tree regression fixtures.
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
    return abi_test_dependencies() ? 0 : 1;
}
