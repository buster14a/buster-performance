// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Exercise the committed regression's shape checks against retained and deliberately corrupted assembly.
#define main patterns_supervisor_main
#include "tests/driver/tier1_patterns.c"
#undef main

int main(int argc, char** argv)
{
    const bool valid = argc == 2 && patterns_shapes(argv[1], true);
    return valid ? 0 : 1;
}
