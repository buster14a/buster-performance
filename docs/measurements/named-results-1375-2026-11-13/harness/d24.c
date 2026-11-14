#include <stdio.h>
struct R { long a, b, c; };
struct R k_sret(long x);
int main(void)
{
    long s = 0;
    for (long i = 0; i < 50000000; i++)
    {
        struct R r = k_sret(i);
        s += r.a ^ r.b ^ r.c;
    }
    printf("%ld\n", s);
    return 0;
}
