// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#include <stdint.h>
#include <stdio.h>
#include <string.h>

void tier1_schedule_live_flags(const uint64_t*, const uint64_t*, uint32_t, uint64_t*);
void clang_live_flags(const uint64_t*, const uint64_t*, uint32_t, uint64_t*);

int main(void)
{
    uint64_t reads[98];
    uint64_t original[196];
    uint64_t actual[196];
    uint64_t expected[196];
    uint64_t state = 2755;
    for (uint32_t i = 0; i < 196; i += 1)
    {
        state = state * UINT64_C(6364136223846793005) + 1;
        original[i] = state;
        if (i < 98)
        {
            reads[i] = (state >> 1) & (state >> 3);
        }
    }
    const uint32_t offsets[] = { 0, 1, 2, 98 };
    uint32_t cases = 0;
    uint32_t failures = 0;
    for (uint32_t n = 0; n <= 96; n += 1)
    {
        for (uint32_t j = 0; j < 4; j += 1)
        {
            memcpy(actual, original, sizeof(actual));
            memcpy(expected, original, sizeof(expected));
            tier1_schedule_live_flags(reads, actual + 1, n, actual + offsets[j]);
            clang_live_flags(reads, expected + 1, n, expected + offsets[j]);
            failures += memcmp(actual, expected, sizeof(actual)) != 0;
            cases += 1;
        }
    }
    printf("scheduler/Clang: %u array comparisons, %u failures\n", cases, failures);
    return failures != 0;
}
