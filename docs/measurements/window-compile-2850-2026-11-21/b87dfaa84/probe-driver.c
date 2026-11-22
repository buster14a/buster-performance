#include <stdio.h>
struct inner { int pad; int x; };
struct next { int pad; struct inner v; struct inner *p; };
struct root { long n; struct next *p; struct next z; };
extern int f(struct root*,int);
extern int *addr(struct root*);
extern int call(struct root*);
extern int store(struct root*,int);
int take(int *p, int v){return 3*(*p)+v;}
int main(void) {
    unsigned long long h=17;
    struct inner b[4]={{0}};
    struct next v[4]={{0}};
    struct root r={0};
    for (int i=0;i<10000;i++) {
        int j=i&3, k=(i+1)&3;
        b[j].x=(i*5+1)&4095; b[k].x=(i*7+3)&4095;
        v[j].v.x=i&2047; v[j].p=&b[k]; r.p=&v[j]; r.z.p=&b[j]; r.z.v.x=i&127;
        h=h*131+(unsigned)f(&r,i); h=h*131+(unsigned)*addr(&r); h=h*131+(unsigned)call(&r);
        h=h*131+(unsigned)store(&r,i-1); h=h*131+(unsigned)b[k].x;
    }
    printf("%llu\n",h);
    return 0;
}
