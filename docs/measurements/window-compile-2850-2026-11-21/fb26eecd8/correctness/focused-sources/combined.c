extern void use(int);
static void drop(int *p) { use(*p); }
int sparse_plain(int x) {
    int v = x;
    if (x > 5) goto later;
    while (x--) { if (x == 4) continue; v += x; if (v > 22) break; }
later:
    switch (v) { case 0: case 3: v++; break; default: if (v < 0) goto later; }
    return v;
}
int sparse_cleanup(int x) {
    while (x-- > 0) { int n __attribute__((cleanup(drop))) = x; if (n == 2) continue; if (n == 3) break; }
    return x;
}
int sparse_region(int x) {
    for (int a=0; a<=x; a++) { x += ({ if (a == 2) break; if (a == 1) continue; a + x; }); }
    return x;
}
int sparse_asm(int x) {
    asm goto ("" : : "r"(x) : : done);
    use(x);
done:
    return x;
}
int sparse_vla(int x) {
    while (x > 0) {
        int data[x];
        data[x-1] = x;
        if (x == 5) goto end;
        if (x == 3) break;
        --x;
        if (x == 1) continue;
        use(data[0]);
    }
end:
    return x;
}
