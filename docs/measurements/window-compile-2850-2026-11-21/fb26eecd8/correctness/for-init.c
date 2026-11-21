int started(int n) {
    int x = 0, y = 0;
    for (x = 3; x < n; ++x) {
        y = x;
        (void)7;
        if (x > 7) break;
    }
    for (x = y; x > 0; --x) y += x;
    return y;
}
