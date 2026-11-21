extern void use(int);
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
