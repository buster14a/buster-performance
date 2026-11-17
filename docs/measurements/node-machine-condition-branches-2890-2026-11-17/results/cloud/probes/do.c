int g(int);
int f(int a, int b, int c)
{
    int x = 0;
    do if (a && b) x = 1; while (c && x);
    do { if (a || b) x += 1; } while (c || x);
    for (;;) do x += a; while (b && c);
    do while (a && b) a -= 1; while (c && x);
    do x += 1; while (!(a && b));
    if (a) do x += 2; while (b || c); else do x += 3; while (b && c);
    do switch (a) { case 1: x += 1; } while (b && c);
    do for (; a && b; a -= 1) x += 1; while (c || x);
    do do x += 1; while (a && b); while (c || x);
    do x = a && b; while (g(x) && c);
    do return a && b ? 1 : 2; while (c || x);
    return x;
}
