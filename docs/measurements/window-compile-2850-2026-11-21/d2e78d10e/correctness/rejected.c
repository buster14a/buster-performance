extern void sink(int);
int invalid = missing;
int later(int x) {
    int a[2] = { 1, 2 };
    if (0) sink(a[5]);
    if (x) return a[6];
    return 0;
}
