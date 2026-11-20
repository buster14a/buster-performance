#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <xmmintrin.h>
typedef unsigned long long U;
extern float uf(U), fl(const U *, unsigned), fsel(U,U,unsigned);
extern double ud(U), dl(const U *,unsigned), dsel(U,U,unsigned);
extern void both(U,U,U,U,U,U,U,U,float*,double*);
static U mix(U x) { x ^= x >> 30; x *= 0xbf58476d1ce4e5b9ULL; x ^= x >> 27; x *= 0x94d049bb133111ebULL; return x ^ (x >> 31); }
static U oracle(U x, unsigned p, unsigned mode, int *inexact) {
    if (!x) { *inexact = 0; return 0; }
    unsigned e = 63u - (unsigned)__builtin_clzll(x);
    unsigned s = e >= p ? e + 1 - p : 0;
    U bits = s ? x >> s : x << (p - 1 - e);
    U rem = x & ((1ULL << s) - 1);
    *inexact = rem != 0;
    if (rem && (mode == 2 || (mode == 0 && (rem > (1ULL << (s - 1)) || (rem == (1ULL << (s - 1)) && (bits & 1)))))) {
        if (++bits == (1ULL << p)) { bits >>= 1; ++e; }
    }
    return ((U)(e + (p == 24 ? 127u : 1023u)) << (p - 1)) | (bits & ((1ULL << (p - 1)) - 1));
}
static U fb(float x) { uint32_t z; memcpy(&z,&x,4);return z; }
static U db(double x) { U z;memcpy(&z,&x,8);return z; }
int main(void) {
    U inputs[32768]; unsigned n=0, original=_mm_getcsr(); U digest=0, bad=0, total=0, badflag=0, badvalue=0;
    for (unsigned e=0;e<64;e++) {
        U base=1ULL<<e;
        for (int i=-5;i<=5;i++) inputs[n++]=base+i;
        for (unsigned p=24;p<=53;p+=29) if(e>=p) {
            unsigned s=e+1-p;U step=1ULL<<s, half=step>>1;
            for(unsigned j=0;j<8;j++) for(int i=-3;i<=3;i++) { inputs[n++]=base+step*j+half+i;inputs[n++]=~(base+step*j+half+i); }
        }
    }
    for(unsigned i=0;i<4096;i++) inputs[n++]=mix(i+0x4922ULL);
    for(unsigned i=0;i<64;i++){inputs[n++]=i;inputs[n++]=~(U)i;}
    for(unsigned mode=0;mode<4;mode++) for(unsigned env=0;env<4;env++) for(unsigned i=0;i<n;i++) {
        U x=inputs[i],buf[3]={~x, x, x+1}; unsigned initial=0x1f80|(mode<<13)|(env&1?0x8040:0)|(env&2?0x15:0);
        for (unsigned which=0;which<8;which++) {
            const unsigned p=which&1?53:24;int inexact=0;U ref=oracle(x,p,mode,&inexact);
            _mm_setcsr(initial);
            U result;
            if(which==0)result=fb(uf(x));else if(which==1)result=db(ud(x));
            else if(which==2)result=fb(fl(buf,1));else if(which==3)result=db(dl(buf,1));
            else if(which==4)result=fb(fsel(i&1?~x:x,i&1?x:~x,!(i&1)));
            else if(which==5)result=db(dsel(i&1?~x:x,i&1?x:~x,!(i&1)));
            else {float f;double d;both(x^7,1,2,3,4,5,6,0,&f,&d);result=which&1?db(d):fb(f);}
            unsigned flags=_mm_getcsr()&63u;
            const unsigned expected=(initial&63u)|(inexact?32u:0);
            /* both() executes both casts. Its sticky precision flag is the union. */
            unsigned fexp=expected;
            if(which>=6){int other;oracle(x,p==24?53:24,mode,&other);if(other)fexp|=32;}
            if(result!=ref||flags!=fexp) {
                if(bad<12)fprintf(stderr,"mode=%u env=%u which=%u x=%016llx got=%016llx/%02x expected=%016llx/%02x\n",mode,env,which,x,result,flags,ref,fexp);
                ++bad;badvalue+=result!=ref;badflag+=flags!=fexp;
            }
            digest=mix(digest^result^flags);++total;
        }
    }
    _mm_setcsr(original);printf("%llu comparisons %u inputs %llu mismatches (%llu values, %llu flags) %016llx\n",total,n,bad,badvalue,badflag,digest);return bad!=0;
}
