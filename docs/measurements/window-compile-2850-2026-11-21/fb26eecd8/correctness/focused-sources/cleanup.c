extern void use(int);
static void drop(int *p) { use(*p); }
int sparse_cleanup(int x) {
    while (x-- > 0) { int n __attribute__((cleanup(drop))) = x; if (n == 2) continue; if (n == 3) break; }
    return x;
}
