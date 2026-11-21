typedef int F2(int,int);
typedef long F0(void);
typedef void F1(long);
typedef int F8(int,int,int,int,int,int,int,int);
extern F2 pick, other;
extern F0 zero;
extern F1 visit;
extern F8 many;
F2 *known2, *other2;
F0 *known0;
F1 *known1;
F8 *known8;
int combine(int a, int b) { return pick(a,b); }
long first(void) { return zero(); }
int literals(void) { return pick(4,1); }
int split(int a, long b) { visit(b); other(a,3); return many(a,1,a,2,a,3,a,4); }
