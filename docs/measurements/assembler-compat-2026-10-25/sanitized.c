// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Focused memory/undefined-behavior instrumentation of the real assembly unit. Compile from the named Buster source
// root with -Isrc. The ordinary complete executable supplies command/preprocessing/corpus qualification separately.
#define BUSTER_UNIT BUSTER_UNIT_ASSEMBLER
#include "buster/compiler/main.c"

int main(int argc, char** argv)
{
    bool found = false;
    int result = main_unit_assembler(argc, argv, &found);
    if (!found)
    {
        result = 2;
    }
    return result;
}
