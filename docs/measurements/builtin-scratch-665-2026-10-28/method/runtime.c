// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original consumer; compiled by Clang and linked separately with each tested object.
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
extern unsigned tested(int value);
int main(void)
{
    const int values[] = { INT_MIN, INT_MIN + 1, -1000001, -65536, -127, -1, 0, 1, 2, 31, 127, 65535, 1000001, INT_MAX - 1, INT_MAX };
    for (unsigned i = 0; i < sizeof(values) / sizeof(*values); i += 1)
    {
        printf("%d %u\n", values[i], tested(values[i]));
    }
    uint32_t state = UINT32_C(665);
    for (unsigned i = 0; i < 128; i += 1)
    {
        state = state * UINT32_C(1664525) + UINT32_C(1013904223);
        printf("%d %u\n", (int)state, tested((int)state));
    }
    return 0;
}
