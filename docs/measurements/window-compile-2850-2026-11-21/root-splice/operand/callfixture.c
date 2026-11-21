extern int accept(int, int);
extern void touch(int *);
extern long produce(void);
static int target;
int invoke(int a, int b) {
    return accept(
        a,
        b);
}
void discarded(int a) {
    (void)accept(
        a,
        11);
    touch(
        &target);
}
long narrow_zero(void) {
    return produce();
}
