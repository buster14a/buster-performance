// #1385's kernels: each a loop over n elements of one overflow builtin, the issue's two (signed longs' running sum and
// products) and an int's sum and product and an unsigned long's product beside them.
long add_long(const long* p, unsigned n)
{
    long s = 0;
    int ov = 0;
    for (unsigned i = 0; i < n; i += 1)
    {
        ov += __builtin_add_overflow(s, p[i], &s);
    }
    return (long)((unsigned long)s + (unsigned long)ov);
}

long mul_long(const long* p, unsigned n)
{
    long r = 0;
    int ov = 0;
    for (unsigned i = 0; i < n; i += 1)
    {
        ov += __builtin_mul_overflow(p[i], p[n - 1 - i], &r);
        ov ^= r;
    }
    return ov;
}

long add_int(const long* p, unsigned n)
{
    int s = 0;
    int ov = 0;
    for (unsigned i = 0; i < n; i += 1)
    {
        ov += __builtin_add_overflow(s, (int)p[i], &s);
    }
    return (long)s + ov;
}

long mul_int(const long* p, unsigned n)
{
    int r = 0;
    int ov = 0;
    for (unsigned i = 0; i < n; i += 1)
    {
        ov += __builtin_mul_overflow((int)p[i], (int)p[n - 1 - i], &r);
        ov ^= r;
    }
    return ov;
}

long mul_ulong(const long* p, unsigned n)
{
    unsigned long r = 0;
    int ov = 0;
    for (unsigned i = 0; i < n; i += 1)
    {
        ov += __builtin_mul_overflow((unsigned long)p[i], (unsigned long)p[n - 1 - i], &r);
        ov ^= (int)r;
    }
    return ov;
}
