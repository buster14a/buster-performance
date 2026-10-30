// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Both caller routes occur under nested policy changes and restored policy.
#pragma STDC FENV_ACCESS ON
double scoped(double x)
{
    double on = x + 0.5;
    {
#pragma STDC FENV_ACCESS OFF
        unsigned value;
        int overflow = __builtin_add_overflow(1u, 2u, &value);
        on += (double)(__builtin_bswap32(value) == 0x03000000u && !overflow);
    }
    return on + 0.25;
}
#pragma STDC FENV_ACCESS OFF
int main(void)
{
    unsigned value;
    int overflow = __builtin_add_overflow(2u, 3u, &value);
    return scoped(1.0) != 2.75 || overflow || __builtin_bswap32(value) != 0x05000000u;
}
