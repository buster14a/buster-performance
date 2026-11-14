#include <stdio.h>
struct Big { long a[N]; };
void k_cold(struct Big *out, const struct Big *in);
static struct Big table[64];
static struct Big outs[64];
int main(void)
{
    for (int t = 0; t < 64; t++) for (int i = 0; i < N; i++) table[t].a[i] = t * 100 + i;
    long s = 0;
    for (long i = 0; i < 20000000; i++) { k_cold(&outs[i & 63], &table[(i * 7) & 63]); s += outs[(i - 32) & 63].a[N - 1]; }
    printf("%ld\n", s);
    return 0;
}
