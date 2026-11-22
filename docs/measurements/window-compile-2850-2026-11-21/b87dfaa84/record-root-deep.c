struct item {int a; int x;};
struct D {int a; struct item *p;};
struct C {int a; struct D d;};
struct B {int a; struct C c;};
struct A {int a; struct B b;};
extern int fptr(int*);
int get(struct A r){return r.b.c.d.p->x;}
int *addr(struct A r){return &r.b.c.d.p->x;}
void store(struct A r,int x){r.b.c.d.p->x=x;}
int pass(struct A r){return fptr(&r.b.c.d.p->x);}
