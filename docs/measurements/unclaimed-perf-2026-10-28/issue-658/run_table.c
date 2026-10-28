// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original independent index/value oracle for generate_table.c. OP: 0 byte, 1 int, 2 zero, 3 widened -5U.
#include <stdint.h>
#include <stdio.h>

extern int tested(unsigned n);

int main(void)
{
    unsigned failures = 0;
    for (unsigned sample = 0; sample < 1025; sample += 1)
    {
        const unsigned n = sample == 0 ? 0 : sample == 1 ? COUNT - 1 : sample == 2 ? COUNT : sample == 3 ? UINT32_MAX : sample * UINT32_C(0x9e3779b9);
        const unsigned index = n % COUNT;
        const unsigned expected = OP == 3 ? UINT32_MAX - 4 : OP == 2 ? 0 : OP == 1 ? (index * UINT32_C(1664525) + UINT32_C(1013904223)) & INT32_MAX : (index * 37 + 13) & 255;
        const unsigned actual = (unsigned)tested(n);
        if (actual != expected)
        {
            fprintf(stderr, "index %u: %u != %u\n", index, actual, expected);
            failures += 1;
        }
    }
    printf("table native: OP=%u COUNT=%u,1025 cases,%u failures\n", (unsigned)OP, (unsigned)COUNT, failures);
    return failures != 0;
}
