// #2678 kernels: each sums over n elements; the driver (clang -O2) calls each REPS times. An int constant beside a
// 64-bit or floating operand: the first three are #1386's record's (index, conv, dconv), the last two only this pattern.
unsigned k_index(const unsigned* p, unsigned long n)
{
    unsigned s = 0;
    for (unsigned long i = 0; i < n; i++)
    {
        s += p[i / 8 * 8 + i % 8];
    }
    return s;
}

unsigned long k_conv(const unsigned long* p, long n)
{
    unsigned long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] * 8 + 1;
    }
    return s;
}

double k_dconv(const double* p, long n)
{
    double s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] * 2;
    }
    return s;
}

long k_zero(const long* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += (p[i] == 0) + (p[i] < 0);
    }
    return s;
}

float k_fconv(const float* p, long n)
{
    float s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] * 2 + 1;
    }
    return s;
}
