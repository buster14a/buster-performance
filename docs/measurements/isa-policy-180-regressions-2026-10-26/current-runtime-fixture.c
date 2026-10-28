// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Frozen original generated-program workload. Unsigned arithmetic has a completely defined result. Compare
// baseline/v3/v4, both compiler revisions and Clang's output; retain executable/text identities beside timings.
#include <stdint.h>
#include <stdio.h>

static __attribute__((noinline)) uint64_t kernel(uint64_t state)
{
    for (uint32_t i = 0; i < 2000000; i += 1)
    {
        state ^= state << 7;
        state ^= state >> 9;
        state += UINT64_C(0x9e3779b97f4a7c15) + i;
    }
    return state;
}

int main(void)
{
    printf("%llu\n", (unsigned long long)kernel(180));
    return 0;
}
