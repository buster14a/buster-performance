// #2843: a load whose extension to 64 bits a select reads while its comparison reads the load (#2838's arms), and
// controls whose code the change leaves alone; the driver (clang -O2) calls each REPS times over N elements whose
// comparisons' outcomes repeat every four (predictable).
long k_one(const int* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 0 ? p[i] : 1;
    }
    return s;
}

unsigned long k_unsigned(const unsigned* p, long n)
{
    unsigned long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 7u ? p[i] : 1u;
    }
    return s;
}

long k_half(const unsigned short* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 300 ? p[i] : 2;
    }
    return s;
}

long k_both(const int* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 0 ? 1 : 2;
    }
    return s;
}

long k_logic(const int* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 0 && p[i] < 1000;
    }
    return s;
}
