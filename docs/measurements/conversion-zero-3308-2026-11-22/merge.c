// cvtsi2sd's merge dependency on Zen 5 (#3308): A()'s tail and its caller's product, in a loop, where xmm1 carries the
// previous iteration's divsd and mulsd into the conversion; with and without the xorps that breaks it.
#include <stdio.h>
#include <stdint.h>
#include <time.h>
static double run(int zero, long n)
{
    double s = 0.0, v = 1.0000001, one = 1.0;
    struct timespec a, b;
    clock_gettime(CLOCK_MONOTONIC, &a);
    for (long i = 0; i < n; i++)
    {
        double q = one;
        int k = (int)(i & 1023) + 3;
        if (zero)
            __asm__ volatile("xorps %%xmm1, %%xmm1\n\tcvtsi2sd %1, %%xmm1\n\tdivsd %%xmm1, %0\n\tmovapd %0, %%xmm1\n\tmulsd %2, %%xmm1\n\taddsd %%xmm1, %3" : "+x"(q) : "r"(k), "x"(v), "x"(s) : "xmm1");
        else
            __asm__ volatile("cvtsi2sd %1, %%xmm1\n\tdivsd %%xmm1, %0\n\tmovapd %0, %%xmm1\n\tmulsd %2, %%xmm1\n\taddsd %%xmm1, %3" : "+x"(q) : "r"(k), "x"(v), "x"(s) : "xmm1");
    }
    clock_gettime(CLOCK_MONOTONIC, &b);
    return ((b.tv_sec - a.tv_sec) * 1e9 + (b.tv_nsec - a.tv_nsec)) / n;
}
int main(void)
{
    const long n = 20000000;
    double best[2] = { 1e9, 1e9 };
    for (int r = 0; r < 7; r++)
        for (int z = 0; z < 2; z++)
        {
            double t = run(z, n);
            best[z] = t < best[z] ? t : best[z];
        }
    printf("ns per iteration, best of 7 x 2e7: merged %.3f, zeroed %.3f, ratio %.2f\n", best[0], best[1], best[0] / best[1]);
    return 0;
}
