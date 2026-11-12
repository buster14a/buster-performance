// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// A program that needs libm, for the static link by -lm.
#include <math.h>
#include <stdio.h>

int main(int argc, char** argv)
{
    (void)argv;
    printf("%.6f\n", sqrt((double)argc + 1.0));
    return 0;
}
