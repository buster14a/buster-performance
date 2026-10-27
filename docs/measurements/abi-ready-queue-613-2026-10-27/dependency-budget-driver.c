// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original single-case mutation entry point for #613's classification CPU budget.
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
    alarm(60);
    return abi_test_dependency_graph(131072, false, false) ? 0 : 1;
}
