struct inner { int pad; int x; };
struct next { int pad; struct inner v; struct inner *p; };
struct root { long n; struct next *p; struct next z; };
extern int take(int*, int);
int f(struct root *r,int k) {return k + r->p->v.x + r->z.p->x;}
int *addr(struct root *r) {return &r->p->p->x;}
int call(struct root *r) {return take(&r->z.v.x,r->p->v.x);}
int store(struct root *r,int k){r->p->p->x=k;return r->p->p->x;}
