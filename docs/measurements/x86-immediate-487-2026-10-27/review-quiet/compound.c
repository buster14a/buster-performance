// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
typedef char V __attribute__((vector_size(16)));
unsigned f(V a)
{
    return (unsigned){ __builtin_ia32_cmpb128_mask(a, a, 8, 65535) };
}
