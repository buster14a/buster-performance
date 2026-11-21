extern int accept(int, int);
extern void touch(int *);
extern long produce(void);
extern int (*int_designator)(int,int);
extern void (*void_designator)(int *);
extern long (*long_designator)(void);
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
