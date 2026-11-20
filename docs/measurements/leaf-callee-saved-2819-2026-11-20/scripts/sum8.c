long sum8(const long *a, long n)
{
    long s0 = 0, s1 = 0, s2 = 0, s3 = 0, s4 = 0, s5 = 0, s6 = 0, s7 = 0;
    for (long i = 0; i + 8 <= n; i += 8)
    {
        s0 += a[i]; s1 += a[i + 1]; s2 += a[i + 2]; s3 += a[i + 3];
        s4 += a[i + 4]; s5 += a[i + 5]; s6 += a[i + 6]; s7 += a[i + 7];
    }
    return s0 ^ s1 ^ s2 ^ s3 ^ s4 ^ s5 ^ s6 ^ s7;
}
