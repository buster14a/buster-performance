#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct P { int a; long b; };
int f0(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 7) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 7) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 7) x += (int)p.b; else x -= v; }
    return x;
}
int f1(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 8) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 8) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 8) x += (int)p.b; else x -= v; }
    return x;
}
int f2(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 9) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 9) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 9) x += (int)p.b; else x -= v; }
    return x;
}
int f3(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 10) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 10) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 10) x += (int)p.b; else x -= v; }
    return x;
}
int f4(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 11) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 11) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 11) x += (int)p.b; else x -= v; }
    return x;
}
int f5(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 12) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 12) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 12) x += (int)p.b; else x -= v; }
    return x;
}
int f6(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 13) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 13) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 13) x += (int)p.b; else x -= v; }
    return x;
}
int f7(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 14) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 14) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 14) x += (int)p.b; else x -= v; }
    return x;
}
int f8(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 15) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 15) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 15) x += (int)p.b; else x -= v; }
    return x;
}
int f9(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 16) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 16) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 16) x += (int)p.b; else x -= v; }
    return x;
}
int f10(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 17) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 17) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 17) x += (int)p.b; else x -= v; }
    return x;
}
int f11(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 18) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 18) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 18) x += (int)p.b; else x -= v; }
    return x;
}
int f12(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 19) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 19) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 19) x += (int)p.b; else x -= v; }
    return x;
}
int f13(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 20) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 20) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 20) x += (int)p.b; else x -= v; }
    return x;
}
int f14(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 21) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 21) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 21) x += (int)p.b; else x -= v; }
    return x;
}
int f15(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 22) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 22) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 22) x += (int)p.b; else x -= v; }
    return x;
}
int f16(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 23) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 23) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 23) x += (int)p.b; else x -= v; }
    return x;
}
int f17(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 24) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 24) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 24) x += (int)p.b; else x -= v; }
    return x;
}
int f18(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 25) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 25) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 25) x += (int)p.b; else x -= v; }
    return x;
}
int f19(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 26) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 26) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 26) x += (int)p.b; else x -= v; }
    return x;
}
int f20(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 27) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 27) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 27) x += (int)p.b; else x -= v; }
    return x;
}
int f21(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 28) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 28) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 28) x += (int)p.b; else x -= v; }
    return x;
}
int f22(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 29) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 29) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 29) x += (int)p.b; else x -= v; }
    return x;
}
int f23(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 30) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 30) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 30) x += (int)p.b; else x -= v; }
    return x;
}
int f24(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 31) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 31) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 31) x += (int)p.b; else x -= v; }
    return x;
}
int f25(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 32) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 32) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 32) x += (int)p.b; else x -= v; }
    return x;
}
int f26(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 33) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 33) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 33) x += (int)p.b; else x -= v; }
    return x;
}
int f27(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 34) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 34) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 34) x += (int)p.b; else x -= v; }
    return x;
}
int f28(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 35) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 35) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 35) x += (int)p.b; else x -= v; }
    return x;
}
int f29(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 36) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 36) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 36) x += (int)p.b; else x -= v; }
    return x;
}
int f30(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 37) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 37) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 37) x += (int)p.b; else x -= v; }
    return x;
}
int f31(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 38) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 38) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 38) x += (int)p.b; else x -= v; }
    return x;
}
int f32(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 39) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 39) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 39) x += (int)p.b; else x -= v; }
    return x;
}
int f33(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 40) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 40) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 40) x += (int)p.b; else x -= v; }
    return x;
}
int f34(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 41) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 41) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 41) x += (int)p.b; else x -= v; }
    return x;
}
int f35(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 42) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 42) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 42) x += (int)p.b; else x -= v; }
    return x;
}
int f36(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 43) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 43) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 43) x += (int)p.b; else x -= v; }
    return x;
}
int f37(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 44) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 44) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 44) x += (int)p.b; else x -= v; }
    return x;
}
int f38(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 45) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 45) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 45) x += (int)p.b; else x -= v; }
    return x;
}
int f39(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 46) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 46) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 46) x += (int)p.b; else x -= v; }
    return x;
}
int f40(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 47) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 47) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 47) x += (int)p.b; else x -= v; }
    return x;
}
int f41(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 48) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 48) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 48) x += (int)p.b; else x -= v; }
    return x;
}
int f42(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 49) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 49) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 49) x += (int)p.b; else x -= v; }
    return x;
}
int f43(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 50) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 50) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 50) x += (int)p.b; else x -= v; }
    return x;
}
int f44(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 51) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 51) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 51) x += (int)p.b; else x -= v; }
    return x;
}
int f45(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 52) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 52) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 52) x += (int)p.b; else x -= v; }
    return x;
}
int f46(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 53) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 53) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 53) x += (int)p.b; else x -= v; }
    return x;
}
int f47(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 54) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 54) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 54) x += (int)p.b; else x -= v; }
    return x;
}
int f48(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 55) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 55) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 55) x += (int)p.b; else x -= v; }
    return x;
}
int f49(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 56) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 56) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 56) x += (int)p.b; else x -= v; }
    return x;
}
int f50(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 57) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 57) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 57) x += (int)p.b; else x -= v; }
    return x;
}
int f51(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 58) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 58) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 58) x += (int)p.b; else x -= v; }
    return x;
}
int f52(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 59) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 59) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 59) x += (int)p.b; else x -= v; }
    return x;
}
int f53(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 60) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 60) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 60) x += (int)p.b; else x -= v; }
    return x;
}
int f54(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 61) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 61) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 61) x += (int)p.b; else x -= v; }
    return x;
}
int f55(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 62) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 62) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 62) x += (int)p.b; else x -= v; }
    return x;
}
int f56(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 63) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 63) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 63) x += (int)p.b; else x -= v; }
    return x;
}
int f57(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 64) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 64) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 64) x += (int)p.b; else x -= v; }
    return x;
}
int f58(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 65) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 65) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 65) x += (int)p.b; else x -= v; }
    return x;
}
int f59(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 66) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 66) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 66) x += (int)p.b; else x -= v; }
    return x;
}
int f60(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 67) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 67) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 67) x += (int)p.b; else x -= v; }
    return x;
}
int f61(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 68) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 68) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 68) x += (int)p.b; else x -= v; }
    return x;
}
int f62(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 69) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 69) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 69) x += (int)p.b; else x -= v; }
    return x;
}
int f63(int x, const char* s)
{
    { int v = x * 3 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 70) x += (int)p.b; else x -= v; }
    { int v = x * 4 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 70) x += (int)p.b; else x -= v; }
    { int v = x * 5 + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > 70) x += (int)p.b; else x -= v; }
    return x;
}
