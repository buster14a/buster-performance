#include <stdarg.h>
struct pair { long x; long y; };
static struct pair swap_pair(struct pair p)
{
    struct pair q = { p.y, p.x };
    return q;
}
static long sum_values(int count, ...)
{
    va_list list;
    va_start(list, count);
    long total = 0;
    for (int i = 0; i < count; i += 1)
    {
        total += va_arg(list, long);
    }
    va_end(list);
    return total;
}
static long f0(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    return r;
}
static long f1(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f2(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f3(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    r ^= f0(a + 1, b);
    return r;
}
static long f4(long a, long b)
{
    static long counter = 4;
    counter += a & 3;
    static const char text[] = "lanes 4";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    r ^= f3(a + 1, b);
    return r;
}
static long f5(long a, long b)
{
    _Complex double z = a;
    __imag__ z = (double)b;
    z = z * z;
    long r = (long)__real__ z - (long)__imag__ z;
    return r;
}
static long f6(long a, long b)
{
    static long counter = 6;
    counter += a & 3;
    static const char text[] = "lanes 6";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f7(long a, long b)
{
    __int128 x = (__int128)a * 3 + b;
    double d = (double)x;
    __int128 y = (__int128)(d * 0.5);
    long r = (long)y;
    r ^= f5(a + 1, b);
    return r;
}
static long f8(long a, long b)
{
    long image[65] = { [0 ... 64] = 17 };
    long r = 0;
    switch (a & 7)
    {
        case 0: r = b; break;
        case 1: r = b * 2; break;
        case 2: r = b - a; break;
        case 3: r = a * a; break;
        case 5: r = b ^ 5; break;
        default: r = -b; break;
    }
    r += image[(unsigned long)b & 63];
    r ^= f3(a + 1, b);
    return r;
}
static long f9(long a, long b)
{
    static void* targets[] = { &&first, &&second, &&third };
    long r = a;
    long i = 0;
    goto *targets[b & 1];
first:
    r += 3;
    i += 1;
    if (i < 3)
    {
        goto *targets[2];
    }
    goto done;
second:
    r *= 2;
    goto first;
third:
    r -= 1;
    goto *targets[0];
done:
    return r;
}
static long f10(long a, long b)
{
    static void* targets[] = { &&first, &&second, &&third };
    long r = a;
    long i = 0;
    goto *targets[b & 1];
first:
    r += 3;
    i += 1;
    if (i < 3)
    {
        goto *targets[2];
    }
    goto done;
second:
    r *= 2;
    goto first;
third:
    r -= 1;
    goto *targets[0];
done:
    return r;
}
static long f11(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f12(long a, long b)
{
    static void* targets[] = { &&first, &&second, &&third };
    long r = a;
    long i = 0;
    goto *targets[b & 1];
first:
    r += 3;
    i += 1;
    if (i < 3)
    {
        goto *targets[2];
    }
    goto done;
second:
    r *= 2;
    goto first;
third:
    r -= 1;
    goto *targets[0];
done:
    r ^= f1(a + 1, b);
    return r;
}
static long f13(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    return r;
}
static long f14(long a, long b)
{
    long image[65] = { [0 ... 64] = 17 };
    long r = 0;
    switch (a & 7)
    {
        case 0: r = b; break;
        case 1: r = b * 2; break;
        case 2: r = b - a; break;
        case 3: r = a * a; break;
        case 5: r = b ^ 5; break;
        default: r = -b; break;
    }
    r += image[(unsigned long)b & 63];
    return r;
}
static long f15(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    r ^= f14(a + 1, b);
    return r;
}
static long f16(long a, long b)
{
    static void* targets[] = { &&first, &&second, &&third };
    long r = a;
    long i = 0;
    goto *targets[b & 1];
first:
    r += 3;
    i += 1;
    if (i < 3)
    {
        goto *targets[2];
    }
    goto done;
second:
    r *= 2;
    goto first;
third:
    r -= 1;
    goto *targets[0];
done:
    r ^= f1(a + 1, b);
    return r;
}
static long f17(long a, long b)
{
    _Complex double z = a;
    __imag__ z = (double)b;
    z = z * z;
    long r = (long)__real__ z - (long)__imag__ z;
    return r;
}
static long f18(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    return r;
}
static long f19(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    return r;
}
static long f20(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    return r;
}
static long f21(long a, long b)
{
    static void* targets[] = { &&first, &&second, &&third };
    long r = a;
    long i = 0;
    goto *targets[b & 1];
first:
    r += 3;
    i += 1;
    if (i < 3)
    {
        goto *targets[2];
    }
    goto done;
second:
    r *= 2;
    goto first;
third:
    r -= 1;
    goto *targets[0];
done:
    return r;
}
static long f22(long a, long b)
{
    static long counter = 22;
    counter += a & 3;
    static const char text[] = "lanes 22";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f23(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    return r;
}
int main(void)
{
    long total = 0;
    for (long i = 0; i < 3; i += 1)
    {
        total = total * 31 + f0(i, total & 255);
        total = total * 31 + f1(i, total & 255);
        total = total * 31 + f2(i, total & 255);
        total = total * 31 + f3(i, total & 255);
        total = total * 31 + f4(i, total & 255);
        total = total * 31 + f5(i, total & 255);
        total = total * 31 + f6(i, total & 255);
        total = total * 31 + f7(i, total & 255);
        total = total * 31 + f8(i, total & 255);
        total = total * 31 + f9(i, total & 255);
        total = total * 31 + f10(i, total & 255);
        total = total * 31 + f11(i, total & 255);
        total = total * 31 + f12(i, total & 255);
        total = total * 31 + f13(i, total & 255);
        total = total * 31 + f14(i, total & 255);
        total = total * 31 + f15(i, total & 255);
        total = total * 31 + f16(i, total & 255);
        total = total * 31 + f17(i, total & 255);
        total = total * 31 + f18(i, total & 255);
        total = total * 31 + f19(i, total & 255);
        total = total * 31 + f20(i, total & 255);
        total = total * 31 + f21(i, total & 255);
        total = total * 31 + f22(i, total & 255);
        total = total * 31 + f23(i, total & 255);
    }
    return (int)(total & 127);
}
