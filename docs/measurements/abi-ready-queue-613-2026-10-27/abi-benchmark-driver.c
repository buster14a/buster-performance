// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original entry point for screening the unchanged in-tree benchmark against scheduler variants.
#include "buster/compiler/calling_convention_benchmark.c"

int main(int argc, char** argv)
{
    return run_calling_convention_benchmark(argc, argv);
}
