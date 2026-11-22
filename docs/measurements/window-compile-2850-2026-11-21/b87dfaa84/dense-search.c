struct C0 { char pad; int v; };
struct C1 { char pad; struct C0 *p; };
struct C2 { char pad; struct C1 *p; };
struct C3 { char pad; struct C2 *p; };
struct C4 { char pad; struct C3 *p; };
struct C5 { char pad; struct C4 *p; };
struct C6 { char pad; struct C5 *p; };
struct C7 { char pad; struct C6 *p; };
struct C8 { char pad; struct C7 *p; };
struct C9 { char pad; struct C8 *p; };
struct C10 { char pad; struct C9 *p; };
struct C11 { char pad; struct C10 *p; };
struct C12 { char pad; struct C11 *p; };
struct C13 { char pad; struct C12 *p; };
struct C14 { char pad; struct C13 *p; };
struct C15 { char pad; struct C14 *p; };
extern int pass(int,...);int f(struct C15*r){return pass(r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v,r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v,r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v,r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v,r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v,r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v,r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v,r->p->p->p->p->p->p->p->p->p->p->p->p->p->p->p->v);}
