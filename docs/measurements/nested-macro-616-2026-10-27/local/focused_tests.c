// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#define BUSTER_UNIT BUSTER_UNIT_FRONTEND
#define main_unit_frontend __attribute__((unused)) static focused_unused
#include "buster/compiler/main.c"

_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(void)
{
    char directory[] = "/tmp/buster-616-focused-XXXXXX";
    bool passed = mkdtemp(directory) != 0;
    passed = pp_test_argument_links() && passed;
    passed = pp_test_nested_arguments() && passed;
    passed = pp_test_argument_slice_semantics(directory, true) && passed;
    return !passed;
}
