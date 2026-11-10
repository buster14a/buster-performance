// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Original source input for the existing BACKEND-to-CHECKER preparation entry.
typedef int ProbeVector __attribute__((vector_size(16)));

int probe_add(int a, int b)
{
    return a * 3 + b;
}

ProbeVector probe_vector(ProbeVector a, ProbeVector b)
{
    return a + b;
}

int main(void)
{
    return probe_add(4, 8) == 20 ? 0 : 1;
}
