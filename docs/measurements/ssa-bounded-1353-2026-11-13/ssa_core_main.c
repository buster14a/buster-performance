// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original standalone entry point for Buster's existing SSA test suite.
#define _GNU_SOURCE
#include "lane.c"
#include "dataflow.c"
#include "dominators.c"
#include "ssa.c"
#include "ssa_program.c"
#include "ssa_test.c"
int main(int argc, char** argv)
{
    return run_ssa_tests(argc - 1, argv + 1);
}
