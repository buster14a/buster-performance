// #2678's second part: a conditional's or a logical operator's int value, converted after its arms join, beside a long
// or a double; the driver (clang -O2) calls each REPS times over n elements whose signs repeat every four (predictable).
long k_both(const int* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 0 ? 1 : 2;
    }
    return s;
}

long k_one(const int* p, long n)
{
    long s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 0 ? p[i] : 1;
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

double k_dboth(const int* p, long n)
{
    double s = 0;
    for (long i = 0; i < n; i++)
    {
        s += p[i] > 0 ? 3 : 1;
    }
    return s;
}
