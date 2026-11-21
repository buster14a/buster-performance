extern int zero(void);
extern int one(int);
extern int mix(unsigned short, void *);
extern void side(int);
static int local(int a) { return a + 1; }
int f(int x, void *p, int (*indirect)(int)) {
    side(x); side(one(x)); mix(3, p); zero();
    if (one(x) == 3) return zero();
    if (indirect(4)) return one(local(x));
    return mix(x + 1, p);
}
