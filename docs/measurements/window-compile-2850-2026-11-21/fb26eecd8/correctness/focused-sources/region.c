extern void use(int);
int sparse_region(int x) {
    for (int a=0; a<=x; a++) { x += ({ if (a == 2) break; if (a == 1) continue; a + x; }); }
    return x;
}
