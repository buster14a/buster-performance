// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md in buster14a/buster.
// A bit-manipulation kernel of the x86 builtins (#141): a 64-bit Morton (Z-order) encode and decode of random 32-bit
// coordinates by pdep and pext, and a bit-field walk by bextr and bzhi, iterated; prints a hash so every result is used.
#include <stdio.h>

static unsigned long long morton_encode(unsigned x, unsigned y)
{
    return __builtin_ia32_pdep_di(x, 0x5555555555555555ull) | __builtin_ia32_pdep_di(y, 0xaaaaaaaaaaaaaaaaull);
}

static unsigned morton_x(unsigned long long code)
{
    return (unsigned)__builtin_ia32_pext_di(code, 0x5555555555555555ull);
}

static unsigned morton_y(unsigned long long code)
{
    return (unsigned)__builtin_ia32_pext_di(code, 0xaaaaaaaaaaaaaaaaull);
}

static unsigned long long fields(unsigned long long word, unsigned start)
{
    unsigned long long sum = 0;
    for (unsigned s = start & 7; s < 64; s += 9)
    {
        sum += __builtin_ia32_bextr_u64(word, s | (7u << 8)) + __builtin_ia32_bzhi_di(word >> s, 5);
    }
    return sum;
}

int main(int argc, char** argv)
{
    unsigned long long state = 0x9e3779b97f4a7c15ull + (unsigned long long)argc;
    unsigned long long hash = 0;
    const long iterations = argc > 1 && argv[1][0] == 's' ? 1000000 : 20000000;
    for (long i = 0; i < iterations; i += 1)
    {
        state ^= state << 13;
        state ^= state >> 7;
        state ^= state << 17;
        const unsigned long long code = morton_encode((unsigned)state, (unsigned)(state >> 32));
        hash = hash * 31 + (morton_x(code) ^ morton_y(code)) + fields(code, (unsigned)i);
    }
    printf("%llx\n", hash);
    return 0;
}
