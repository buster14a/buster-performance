#include <stdio.h>
// spectral-norm's A() without the accumulator: each product goes to memory, so the only loop-carried chain is the one
// through xmm1 that cvtsi2sd's merge makes (the previous call's divsd, then mulsd into xmm1).
static double A(int i, int j) { return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1); }
static void products(int n, const double *v, double *t) { for (int i = 0; i < n; i++) { for (int j = 0; j < n; j++) t[j] = A(i, j) * v[j]; } }
static double v[700], t[700];
int main(void)
{
    int n = 700;
    for (int i = 0; i < n; i++) v[i] = 1.0 + i;
    for (int k = 0; k < 12; k++) products(n, v, t);
    double sum = 0;
    for (int i = 0; i < n; i++) sum += t[i];
    printf("%.9f\n", sum);
    return 0;
}
