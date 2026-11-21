extern int pick(int, int);
extern void visit(long);
extern long zero(void);
extern int many(int,int,int,int,int,int,int,int);
int combine(int a, int b) { return pick(a,b); }
long first(void) { return zero(); }
int literals(void) { return pick(4,1); }
int split(int a, long b) { visit(b); pick(a,3); return many(a,1,a,2,a,3,a,4); }
int big(void) { return pick(2147483647,0); }
