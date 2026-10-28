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
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f1(long a, long b)
{
    static long counter = 1;
    counter += a & 3;
    static const char text[] = "lanes 1";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f2(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    return r;
}
static long f3(long a, long b)
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
static long f4(long a, long b)
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
    r ^= f3(a + 1, b);
    return r;
}
static long f5(long a, long b)
{
    static long counter = 5;
    counter += a & 3;
    static const char text[] = "lanes 5";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    r ^= f3(a + 1, b);
    return r;
}
static long f6(long a, long b)
{
    __int128 x = (__int128)a * 3 + b;
    double d = (double)x;
    __int128 y = (__int128)(d * 0.5);
    long r = (long)y;
    return r;
}
static long f7(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    return r;
}
static long f8(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
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
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    return r;
}
static long f11(long a, long b)
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
static long f12(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    return r;
}
static long f13(long a, long b)
{
    __int128 x = (__int128)a * 3 + b;
    double d = (double)x;
    __int128 y = (__int128)(d * 0.5);
    long r = (long)y;
    return r;
}
static long f14(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    return r;
}
static long f15(long a, long b)
{
    long r = a;
    for (int i = 0; i < 5; i += 1)
    {
        r = r * 3 + b - i;
        if (r > 100000)
        {
            r -= 99991;
        }
    }
    r ^= f3(a + 1, b);
    return r;
}
static long f16(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    return r;
}
static long f17(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    return r;
}
static long f18(long a, long b)
{
    _Complex double z = a;
    __imag__ z = (double)b;
    z = z * z;
    long r = (long)__real__ z - (long)__imag__ z;
    r ^= f16(a + 1, b);
    return r;
}
static long f19(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    r ^= f13(a + 1, b);
    return r;
}
static long f20(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    r ^= f11(a + 1, b);
    return r;
}
static long f21(long a, long b)
{
    static long counter = 21;
    counter += a & 3;
    static const char text[] = "lanes 21";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f22(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    return r;
}
static long f23(long a, long b)
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
    r ^= f17(a + 1, b);
    return r;
}
static long f24(long a, long b)
{
    static long counter = 24;
    counter += a & 3;
    static const char text[] = "lanes 24";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    r ^= f1(a + 1, b);
    return r;
}
static long f25(long a, long b)
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
static long f26(long a, long b)
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
static long f27(long a, long b)
{
    long r = a;
    for (int i = 0; i < 5; i += 1)
    {
        r = r * 3 + b - i;
        if (r > 100000)
        {
            r -= 99991;
        }
    }
    return r;
}
static long f28(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    return r;
}
static long f29(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    r ^= f7(a + 1, b);
    return r;
}
static long f30(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    return r;
}
static long f31(long a, long b)
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
static long f32(long a, long b)
{
    static long counter = 32;
    counter += a & 3;
    static const char text[] = "lanes 32";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    r ^= f21(a + 1, b);
    return r;
}
static long f33(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    r ^= f9(a + 1, b);
    return r;
}
static long f34(long a, long b)
{
    static long counter = 34;
    counter += a & 3;
    static const char text[] = "lanes 34";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f35(long a, long b)
{
    static long counter = 35;
    counter += a & 3;
    static const char text[] = "lanes 35";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f36(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    return r;
}
static long f37(long a, long b)
{
    _Complex double z = a;
    __imag__ z = (double)b;
    z = z * z;
    long r = (long)__real__ z - (long)__imag__ z;
    return r;
}
static long f38(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    r ^= f3(a + 1, b);
    return r;
}
static long f39(long a, long b)
{
    _Complex double z = a;
    __imag__ z = (double)b;
    z = z * z;
    long r = (long)__real__ z - (long)__imag__ z;
    return r;
}
static long f40(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    return r;
}
static long f41(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    return r;
}
static long f42(long a, long b)
{
    _Complex double z = a;
    __imag__ z = (double)b;
    z = z * z;
    long r = (long)__real__ z - (long)__imag__ z;
    return r;
}
static long f43(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    r ^= f6(a + 1, b);
    return r;
}
static long f44(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    return r;
}
static long f45(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    return r;
}
static long f46(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    return r;
}
static long f47(long a, long b)
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
    r ^= f23(a + 1, b);
    return r;
}
static long f48(long a, long b)
{
    long r = a;
    for (int i = 0; i < 5; i += 1)
    {
        r = r * 3 + b - i;
        if (r > 100000)
        {
            r -= 99991;
        }
    }
    r ^= f34(a + 1, b);
    return r;
}
static long f49(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    r ^= f41(a + 1, b);
    return r;
}
static long f50(long a, long b)
{
    __int128 x = (__int128)a * 3 + b;
    double d = (double)x;
    __int128 y = (__int128)(d * 0.5);
    long r = (long)y;
    r ^= f3(a + 1, b);
    return r;
}
static long f51(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    r ^= f1(a + 1, b);
    return r;
}
static long f52(long a, long b)
{
    _Complex double z = a;
    __imag__ z = (double)b;
    z = z * z;
    long r = (long)__real__ z - (long)__imag__ z;
    return r;
}
static long f53(long a, long b)
{
    long r = a;
    for (int i = 0; i < 5; i += 1)
    {
        r = r * 3 + b - i;
        if (r > 100000)
        {
            r -= 99991;
        }
    }
    r ^= f25(a + 1, b);
    return r;
}
static long f54(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    return r;
}
static long f55(long a, long b)
{
    unsigned __int128 x = (unsigned __int128)(unsigned long)a * 77777 + (unsigned long)b;
    long r = (long)(x / ((unsigned long)b | 3)) ^ (long)(x % 7);
    r ^= f44(a + 1, b);
    return r;
}
static long f56(long a, long b)
{
    __int128 x = (__int128)a * 3 + b;
    double d = (double)x;
    __int128 y = (__int128)(d * 0.5);
    long r = (long)y;
    r ^= f54(a + 1, b);
    return r;
}
static long f57(long a, long b)
{
    __int128 x = (__int128)a * 3 + b;
    double d = (double)x;
    __int128 y = (__int128)(d * 0.5);
    long r = (long)y;
    return r;
}
static long f58(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f59(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    return r;
}
static long f60(long a, long b)
{
    __int128 x = (__int128)a * 3 + b;
    double d = (double)x;
    __int128 y = (__int128)(d * 0.5);
    long r = (long)y;
    r ^= f39(a + 1, b);
    return r;
}
static long f61(long a, long b)
{
    static long counter = 61;
    counter += a & 3;
    static const char text[] = "lanes 61";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f62(long a, long b)
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
    r ^= f48(a + 1, b);
    return r;
}
static long f63(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    return r;
}
static long f64(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    return r;
}
static long f65(long a, long b)
{
    static long counter = 65;
    counter += a & 3;
    static const char text[] = "lanes 65";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    return r;
}
static long f66(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    return r;
}
static long f67(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    return r;
}
static long f68(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    r ^= f64(a + 1, b);
    return r;
}
static long f69(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f70(long a, long b)
{
    static long counter = 70;
    counter += a & 3;
    static const char text[] = "lanes 70";
    long r = counter + text[(unsigned long)b % (sizeof(text) - 1)];
    r ^= f54(a + 1, b);
    return r;
}
static long f71(long a, long b)
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
    r ^= f51(a + 1, b);
    return r;
}
static long f72(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    return r;
}
static long f73(long a, long b)
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
static long f74(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f75(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    r ^= f56(a + 1, b);
    return r;
}
static long f76(long a, long b)
{
    struct pair p = { a, b };
    struct pair q = swap_pair(p);
    long r = q.x * 2 - q.y;
    r ^= f33(a + 1, b);
    return r;
}
static long f77(long a, long b)
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
    r ^= f8(a + 1, b);
    return r;
}
static long f78(long a, long b)
{
    long r = a;
    for (int i = 0; i < 5; i += 1)
    {
        r = r * 3 + b - i;
        if (r > 100000)
        {
            r -= 99991;
        }
    }
    r ^= f25(a + 1, b);
    return r;
}
static long f79(long a, long b)
{
    long double x = a;
    x = x * 1.5L + b;
    long r = (long)x;
    r ^= f77(a + 1, b);
    return r;
}
static long f80(long a, long b)
{
    __int128 x = (__int128)a * 1000003 + b;
    __int128 y = (__int128)(b | 1);
    long r = (long)(x / y) + (long)(x % y);
    return r;
}
static long f81(long a, long b)
{
    long r = sum_values(3, a, b, a + b) + sum_values(1, b);
    r ^= f68(a + 1, b);
    return r;
}
static long f82(long a, long b)
{
    long r = a;
    while (r > 1000)
    {
        r = r / 2 + b % 3;
    }
    return r;
}
static long f83(long a, long b)
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
        total = total * 31 + f24(i, total & 255);
        total = total * 31 + f25(i, total & 255);
        total = total * 31 + f26(i, total & 255);
        total = total * 31 + f27(i, total & 255);
        total = total * 31 + f28(i, total & 255);
        total = total * 31 + f29(i, total & 255);
        total = total * 31 + f30(i, total & 255);
        total = total * 31 + f31(i, total & 255);
        total = total * 31 + f32(i, total & 255);
        total = total * 31 + f33(i, total & 255);
        total = total * 31 + f34(i, total & 255);
        total = total * 31 + f35(i, total & 255);
        total = total * 31 + f36(i, total & 255);
        total = total * 31 + f37(i, total & 255);
        total = total * 31 + f38(i, total & 255);
        total = total * 31 + f39(i, total & 255);
        total = total * 31 + f40(i, total & 255);
        total = total * 31 + f41(i, total & 255);
        total = total * 31 + f42(i, total & 255);
        total = total * 31 + f43(i, total & 255);
        total = total * 31 + f44(i, total & 255);
        total = total * 31 + f45(i, total & 255);
        total = total * 31 + f46(i, total & 255);
        total = total * 31 + f47(i, total & 255);
        total = total * 31 + f48(i, total & 255);
        total = total * 31 + f49(i, total & 255);
        total = total * 31 + f50(i, total & 255);
        total = total * 31 + f51(i, total & 255);
        total = total * 31 + f52(i, total & 255);
        total = total * 31 + f53(i, total & 255);
        total = total * 31 + f54(i, total & 255);
        total = total * 31 + f55(i, total & 255);
        total = total * 31 + f56(i, total & 255);
        total = total * 31 + f57(i, total & 255);
        total = total * 31 + f58(i, total & 255);
        total = total * 31 + f59(i, total & 255);
        total = total * 31 + f60(i, total & 255);
        total = total * 31 + f61(i, total & 255);
        total = total * 31 + f62(i, total & 255);
        total = total * 31 + f63(i, total & 255);
        total = total * 31 + f64(i, total & 255);
        total = total * 31 + f65(i, total & 255);
        total = total * 31 + f66(i, total & 255);
        total = total * 31 + f67(i, total & 255);
        total = total * 31 + f68(i, total & 255);
        total = total * 31 + f69(i, total & 255);
        total = total * 31 + f70(i, total & 255);
        total = total * 31 + f71(i, total & 255);
        total = total * 31 + f72(i, total & 255);
        total = total * 31 + f73(i, total & 255);
        total = total * 31 + f74(i, total & 255);
        total = total * 31 + f75(i, total & 255);
        total = total * 31 + f76(i, total & 255);
        total = total * 31 + f77(i, total & 255);
        total = total * 31 + f78(i, total & 255);
        total = total * 31 + f79(i, total & 255);
        total = total * 31 + f80(i, total & 255);
        total = total * 31 + f81(i, total & 255);
        total = total * 31 + f82(i, total & 255);
        total = total * 31 + f83(i, total & 255);
    }
    return (int)(total & 127);
}
