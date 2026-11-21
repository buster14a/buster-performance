// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.

int probe(void)
{
    return ({
        extern int a __attribute__((availability(haiku, introduced=1)));
        a + 1;
    });
}
