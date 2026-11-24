long double affine(const int* p, int count)
{
    long double s = 0;
    for (int i = 0; i < count; ++i)
    {
        s = s * 0.5L + p[i];
    }
    return s;
}

long double sum(const long double* p, int count)
{
    long double s = 0;
    for (int i = 0; i < count; ++i)
    {
        s += p[i];
    }
    return s;
}

long double dot(const long double* p, const long double* q, int count)
{
    long double s = 0;
    for (int i = 0; i < count; ++i)
    {
        s += p[i] * q[i];
    }
    return s;
}
