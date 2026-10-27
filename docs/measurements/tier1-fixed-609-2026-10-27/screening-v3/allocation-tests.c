// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original entry point for the unchanged production allocation suite, including native/guard/rollback cases.
#include "buster/compiler/lane.c"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/tier1_allocate.c"
#include "buster/compiler/tier1_rematerialize.c"
#include "buster/compiler/tier1_allocate_test.c"

int main(int argc, char** argv)
{
    (void)x86_instruction_is_valid;
    return run_tier1_allocate_tests(argc - 1, argv + 1);
}
