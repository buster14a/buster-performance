// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// The smallest program that includes a system header and calls the C library: what a build's fixed costs are measured
// on (process start, the runtime's snapshot, binding, the executable's write).
#include <stdio.h>

int main(void)
{
    puts("hello");
    return 0;
}
