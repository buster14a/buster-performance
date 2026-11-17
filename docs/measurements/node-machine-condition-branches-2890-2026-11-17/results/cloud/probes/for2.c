int g(int);
int f(int a, int b, int c)
{
    int x = 0;
    for (x = 0; a && b; a -= 1) x += 1;
    for (int i = 0; i < a && b; i += 1) x += i;
    for (x = 1, c = 2; a || b; a -= 1) x += 1;
    for (; a && b;) x += 1;
    for (;; a -= 1) if (a && b) break;
    while (a && b) for (x = 0; c || x; c -= 1) x += 2;
    if (a && b) for (x = 0; !(c && x); c -= 1) x += 2; else while (c || x) c -= 1;
    do for (x = 0; a && b; a -= 1) x += 1; while (c && x);
    { for (x = 0; a && b; a -= 1) { x += 1; } }
    switch (a) { case 1: for (x = 0; b && c; b -= 1) x += 1; break; default: do x -= 1; while (x && b); }
    return x;
}
