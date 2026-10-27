// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #599 source-path acceptance input, also covered by test-checker's fixtures.
unsigned char a[512], b[512];
int effects[3];
int tested_wide(int n)
{
    unsigned k = (unsigned)n % 300;
    for (unsigned i = 0; i < 512; i++) a[i] = (unsigned char)(1 + i % 255);
    __builtin_memset(b, 0x180, 512);
    __builtin_memcpy(b + 3, a + 1, k);
    __builtin_memmove(b + 4, b + 3, k);
    __builtin_memmove(b + 2, b + 4, k);
    b[k + 2] = 0;
    return (int)__builtin_strlen((char *)b + 2) + __builtin_memcmp(a + 1, b + 2, k) + b[400];
}
int tested_small(int n)
{
    effects[0] = effects[1] = effects[2] = 0;
    for (unsigned i = 0; i < 128; i++) a[i] = (unsigned char)(i + n);
    __builtin_memset(b, 0x1a5, 33);
    __builtin_memcpy(b, a, 32);
    __builtin_memmove(b + 1, b, 15);
    __builtin_memmove(b, b + 1, 16);
    __builtin_memcpy((effects[0]++, b + 40), (effects[1]++, a + 40), (effects[2]++, 8));
    int r = __builtin_memcmp(a + 40, b + 40, 8);
    __builtin_memset((effects[0]++, b), 7, (0));
    return r + effects[0] + effects[1] * 10 + effects[2] * 100 + b[7] + b[15] + b[32] + __builtin_memcmp(a, b, 1) + __builtin_memcmp(a, b, 0);
}
