// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original bounded source-loop control for PR915 qualification.
unsigned long source_loop(unsigned long x)
{
    unsigned long result = 0;
    for (unsigned long i = 0; i < (x & 7); i += 1)
    {
        unsigned long invariant = (x + 13) * 7;
        result += invariant ^ i;
    }
    return result;
}
