// #1395's loop-carried chains: s = s * K + p[i] over n elements. Compiled by each configuration under test.
long chain5(const long* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i += 1)
    {
        s = s * 5 + p[i];
    }
    return s;
}

long chain9(const long* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i += 1)
    {
        s = s * 9 + p[i];
    }
    return s;
}

long chain4(const long* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i += 1)
    {
        s = s * 4 + p[i];
    }
    return s;
}

long chain33(const long* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i += 1)
    {
        s = (s * 3) * 3 + p[i];
    }
    return s;
}
