extern void sink(int);
int f(int cond) {
    int a[1] = {3};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warray-bounds"
    if (cond) sink(a[2]);
#pragma clang diagnostic warning "-Warray-bounds"
    if (!cond) sink(a[3]);
    if (0) { int never = a[4]; sink(never); }
#pragma clang diagnostic pop
    sink(_Generic(cond, int: a[5], long: a[6]));
    return 0;
}
