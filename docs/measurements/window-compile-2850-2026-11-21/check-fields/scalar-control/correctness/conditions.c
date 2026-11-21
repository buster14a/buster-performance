extern int reads(int *);
extern int consume(void);
static volatile int vol;
static _Atomic int atom;
struct pair { int i; unsigned field:3; };
typedef int four __attribute__((vector_size(16)));
static int sink;

int ordinary(int x, int y, int *p, struct pair a, long double f)
{
    if (x == y) sink++;
    if (++x > y) sink += 2;
    if (consume()) sink += 3;
    if ((reads(&x), x + y)) sink += 4;
    if (vol) sink += 5;
    if (atom) sink += 6;
    if (a.field) sink += 7;
    if ((unsigned _BitInt(67))x + (unsigned)y) sink += 8;
    if (p) sink += 9;
    if (f) sink += 10;
    if (0.0L + f) sink += 11;
    if (!!p + !!f) sink += 12;
    for (; x > 0 && y; --x) sink += y;
    do { --y; } while (y > 1);
    return sink;
}
#pragma STDC FENV_ACCESS ON
int floating_environment(int x, double y)
{
    if (x > 2) ++sink;
    if (y != 0.0) ++sink;
    return sink;
}
#pragma STDC FENV_ACCESS OFF
int main(void)
{
    int x=2;
    if (x+0) sink=3;
    if (x++ == 2) sink+=x;
    if ((x==x ? x : 0) + 1) sink++;
    return sink != 7;
}
