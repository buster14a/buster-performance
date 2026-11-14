// #1386 kernels: each sums over n elements; the driver (clang -O2) calls each REPS times.
unsigned k_udiv(const unsigned* p, unsigned n)
{
    unsigned s = 0;
    for (unsigned i = 0; i < n; i++)
    {
        s += p[i] / 16u;
    }
    return s;
}

unsigned k_umod(const unsigned* p, unsigned n)
{
    unsigned s = 0;
    for (unsigned i = 0; i < n; i++)
    {
        s += p[i] % 64u;
    }
    return s;
}

unsigned k_index(const unsigned* p, unsigned long n)
{
    unsigned s = 0;
    for (unsigned long i = 0; i < n; i++)
    {
        s += p[i / 8 * 8 + i % 8];
    }
    return s;
}

int k_sdiv(const int* p, int n)
{
    int s = 0;
    for (int i = 0; i < n; i++)
    {
        s += p[i] / 16;
    }
    return s;
}

int k_smod(const int* p, int n)
{
    int s = 0;
    for (int i = 0; i < n; i++)
    {
        s += p[i] % 64;
    }
    return s;
}

long k_ldiv(const long* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] / 8;
    }
    return s;
}

long k_pdiff(const unsigned* const* p, const unsigned* base, int n)
{
    long s = 0;
    for (int i = 0; i < n; i++)
    {
        s += p[i] - base;
    }
    return s;
}

int k_bytes(const unsigned char* p, int n)
{
    int s = 0;
    for (int i = 0; i < n; i++)
    {
        s += p[i] / 16 + p[i] % 16;
    }
    return s;
}

// Not #1386's: an int constant converted to the other operand's type (the follow-up's kernels).
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
