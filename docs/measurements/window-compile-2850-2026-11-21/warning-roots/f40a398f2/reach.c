extern void use(int);
extern int x;
int checked(int k) {
    int a[2] = {1, 2};
    if (k) use(a[4]);
    if (0) { int folded = a[5]; use(folded); }
    use(k ? a[6] : 7);
    use(0 && a[7]);
    use(1 || a[8]);
    use(sizeof(a[9]));
    use(_Generic(k, int: a[10], default: a[11]));
    use(__builtin_choose_expr(0, a[12], a[13]));
    use(({ if (0) use(a[14]); k; }));
    switch (k) { case 2: use(a[15]); break; default: break; }
    if (k) goto end;
    for (int j = 0; j < k; ++j) use(a[16]);
end:
    return a[17];
}
