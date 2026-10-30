// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Matched small compile/control: only the following ACCESS policy differs.
#pragma STDC FENV_ACCESS ON
double ratio(double x, int n)
{
    double y = (double)n;
    return (x + y) / (y + 3.0);
}
unsigned swapped(unsigned x)
{
    unsigned y;
    int overflow = __builtin_add_overflow(x, 3u, &y);
    return __builtin_bswap32(y) ^ (unsigned)overflow;
}
int main(void)
{
    return ratio(6.0, 3) != 1.5 || swapped(0) != 0x03000000u;
}
