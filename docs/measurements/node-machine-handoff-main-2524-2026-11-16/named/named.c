struct Wide
{
    long a;
    long b;
    long c;
};

struct Wide make(long x)
{
    struct Wide result;
    result.a = x;
    result.b = x + 1;
    result.c = x + 2;
    if (result.a > 3)
    {
        result.c = 0;
    }
    return result;
}

struct Wide copy(long x)
{
    struct Wide first;
    struct Wide second;
    first.a = x;
    second.a = x + 1;
    if (x > 3)
    {
        return first;
    }
    return second;
}
