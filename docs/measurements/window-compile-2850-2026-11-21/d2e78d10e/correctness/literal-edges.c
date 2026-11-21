extern void use(int);
int source_checks(int x) {
    if (0) { int unreachable = 9.25; use(unreachable); }
    int nested = x ? (x ? 1.5 : 0.0) : 4;
    use(sizeof((int)(x ? 0.125 : 0.75)));
    use(_Alignof(int[x ? 1 : 2]));
    use(sizeof(int[x++]));
    if (x) return 1;
    int from_reach = __builtin_choose_expr(1, 1 ? 4.25 : 7.5, 8.75);
    int selected = _Generic(x, int: 11.125, default: 12.75);
    return from_reach + selected + nested;
}
