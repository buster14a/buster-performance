extern void use(int);
int sparse_plain(int x) {
    int v = x;
    if (x > 5) goto later;
    while (x--) { if (x == 4) continue; v += x; if (v > 22) break; }
later:
    switch (v) { case 0: case 3: v++; break; default: if (v < 0) goto later; }
    return v;
}
