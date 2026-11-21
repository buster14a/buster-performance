extern void use(int);
int sparse_asm(int x) {
    asm goto ("" : : "r"(x) : : done);
    use(x);
done:
    return x;
}
