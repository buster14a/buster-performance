int first(int a)
{
    return a + 1;
}
int conv(double f)
{
    long long n;
    return (f >= -9.2e18 && f < 9.2e18 && (*(&n) = (long long)(f), 1)) ? (int)n : 0;
}
int plain(double f)
{
    unsigned short n = 3;
    *(&n) = 4;
    return *&n + (int)f;
}
