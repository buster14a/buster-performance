// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Independent unsigned semantics for generate_builtin.c. COUNT and OP (0 popcount, 1 overflow, 2 expect) name its input.
#include <stdint.h>
#include <stdio.h>

extern unsigned probe(unsigned x);

int main(void)
{
    unsigned failures = 0;
    for (unsigned sample = 0; sample < 257; sample += 1)
    {
        const unsigned x = sample == 0 ? 0 : sample == 1 ? UINT32_MAX : sample == 2 ? UINT32_MAX - COUNT / 2 : sample * UINT32_C(0x9e3779b9);
        unsigned expected = 0;
        for (unsigned i = 0; i < COUNT; i += 1)
        {
            unsigned value = x + i;
            if (OP == 0)
            {
                while (value != 0)
                {
                    expected += value & 1;
                    value >>= 1;
                }
            }
            else if (OP == 1)
            {
                expected += value < x ? 1 : value;
            }
            else
            {
                expected += value;
            }
        }
        const unsigned actual = probe(x);
        if (actual != expected)
        {
            fprintf(stderr, "sample %u, x=%u: %u != %u\n", sample, x, actual, expected);
            failures += 1;
        }
    }
    printf("builtin native: OP=%u COUNT=%u, 257 cases, %u failures\n", OP, COUNT, failures);
    return failures != 0;
}
