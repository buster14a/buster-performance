unsigned sum1(const unsigned *a, unsigned n)
{
    unsigned sum = 0;
    for (int i = 0; i <= (int)(n & 65535u); i += 1)
        sum += a[i];
    return sum;
}

unsigned sum3(const unsigned *a, unsigned n)
{
    unsigned sum = 0;
    for (int i = 0; i <= (int)(n & 65535u); i += 3)
        sum += a[i];
    return sum;
}

unsigned swap1(const unsigned *a, unsigned n)
{
    unsigned sum = 0;
    for (int i = 0; (int)(n & 65535u) >= i; i += 1)
        sum += a[i];
    return sum;
}

unsigned swap3(const unsigned *a, unsigned n)
{
    unsigned sum = 0;
    for (int i = 0; (int)(n & 65535u) >= i; i += 3)
        sum += a[i];
    return sum;
}

unsigned strict1(const unsigned *a, unsigned n)
{
    unsigned sum = 0;
    for (int i = 0; i < (int)(n & 65535u); i += 1)
        sum += a[i];
    return sum;
}

long find1(const unsigned *a, unsigned n, unsigned key)
{
    int i = 0;
    for (; i <= (int)(n & 65535u); i += 1)
        if (a[i] == key)
            break;
    return i;
}

long find3(const unsigned *a, unsigned n, unsigned key)
{
    for (int i = 0; i <= (int)(n & 65535u); i += 3)
        if (a[i] == key)
            return i;
    return -1;
}
