static int call(int x) { return 3*x + 1; }
int tested(int n) {
    int x=n, y=0;
    (void)3;
    y=4;
    x=y;
    for (; x; --x) {
        (void)7;
        y=x;
        if (x & 1) y=3;
        else y=4;
        y += ({ int t = call(n); t + x; });
        ;
    }
    return y;
}
