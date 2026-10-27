// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #611 executable oracle; Clang is an external compiler, not an incorporated implementation.
extern int printf(const char*, ...);
int parameter(int n, int (*p)[n++])
{
    n *= 3;
    return n * 100 + (int)sizeof *p;
}
int tested(int n)
{
    n += 10;
    typedef int A[n++];
    A a;
    int x = n;
    {
        A b;
        __typeof__(int[n++]) c, d;
        x += (int)sizeof b + (int)sizeof c + (int)sizeof d;
    }
    int (*p)[n++], (*q)[n++];
    return x + n + (int)sizeof a + (int)sizeof *p + (int)sizeof *q;
}
int main(void)
{
    for (int n = 0; n < 8; n += 1)
    {
        printf("%d %d\n", tested(n), parameter(n + 2, 0));
    }
    return 0;
}
