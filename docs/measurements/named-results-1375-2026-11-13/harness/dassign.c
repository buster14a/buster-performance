#include <stdio.h>
struct Big { long a[N]; };
void k_assign(struct Big *out, long x);
int main(void)
{
    static struct Big g;
    long s = 0;
    for (long i = 0; i < 20000000; i++) { k_assign(&g, i); s += g.a[N - 1]; }
    printf("%ld\n", s);
    return 0;
}
