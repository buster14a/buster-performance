#include <errno.h>
#include <fenv.h>
#include <math.h>
#include <mpfr.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
enum { count = 2048 };
static long double x[count], y[count], z[count], val[count];
static uint64_t rng = UINT64_C(0xfac1798797860319);
static uint64_t next(void) { rng^=rng<<13; rng^=rng>>7; rng^=rng<<17; return rng; }
static long double make(unsigned sign, int exp, uint64_t mant) {
    union {long double d; unsigned char b[sizeof(long double)];} u = {0};
    unsigned short se = (unsigned short)((sign<<15)|(exp+16383));
    mant |= UINT64_C(1)<<63;
    memcpy(u.b,&mant,8);memcpy(u.b+8,&se,2);return u.d;
}
static void prepare(unsigned group) {
    for(unsigned i=0;i<count;i++) {
        uint64_t a=next(),b=next(),c=next();int e=(int)(a%63)-31,k=(int)(b%57)-28,t=e+k;
        if(group==1) { e=1+(int)(a%8);k=-e;t=0; }
        else if(group==2) {e=(int)(a%30001)-15000;k=(int)(b%81)-40;t=e+k+((int)(c%17)-8);}
        else if(group==3) {e=i&1?-(8100+(int)(a%8100)):8100+(int)(a%8100);k=e+(int)(b%31)-15;t=e;}
        x[i]=make(a>>63,e,a);y[i]=make(b>>63,k,b);z[i]=make(c>>63,t,c);
        if(group==1 && (i&3)!=0) z[i]=-x[i]*y[i];
        if(!((i+1)%79))z[i]=-0.0L;
    }
}
static int which(const char *s,const char*const *names,unsigned n) {
    for(unsigned j=0;j<n;j++)if(!strcmp(names[j],s))return (int)j;return -1;
}
static void env_init(unsigned pc,unsigned r) {
    static const unsigned pcs[]={0,0x200,0x300};
    unsigned short cw=(unsigned short)(0x7f|pcs[pc]|(r<<10));
    unsigned mx=0x1f80|(r<<13);
    __asm__ volatile("fninit; fldcw %0; ldmxcsr %1"::"m"(cw),"m"(mx):"memory");
}
static void call(unsigned fn,unsigned i) {val[i]=fn?hypotl(x[i],y[i]):fmal(x[i],y[i],z[i]);}
static int oracle(unsigned fn,unsigned r,FILE *out) {
    const mpfr_rnd_t rnd[]={MPFR_RNDN,MPFR_RNDD,MPFR_RNDU,MPFR_RNDZ};
    mpfr_t xx,yy,zz,lo,hi;mpfr_inits2(256,xx,yy,zz,lo,hi,(mpfr_ptr)0);
    for(unsigned i=0;i<count;i++) {
        mpfr_set_ld(xx,x[i],MPFR_RNDN);mpfr_set_ld(yy,y[i],MPFR_RNDN);mpfr_set_ld(zz,z[i],MPFR_RNDN);
        if(fn){mpfr_hypot(lo,xx,yy,MPFR_RNDD);mpfr_hypot(hi,xx,yy,MPFR_RNDU);}
        else{mpfr_fma(lo,xx,yy,zz,MPFR_RNDD);mpfr_fma(hi,xx,yy,zz,MPFR_RNDU);}
        long double low=mpfr_get_ld(lo,rnd[r]),high=mpfr_get_ld(hi,rnd[r]);
        unsigned char record[11]={0};record[0]=memcmp(&low,&high,10)==0;memcpy(record+1,&low,10);
        if(fwrite(record,1,sizeof(record),out)!=sizeof(record))return 4;
    }
    mpfr_clears(xx,yy,zz,lo,hi,(mpfr_ptr)0);return 0;
}
int main(int argc,char **argv) {
    if(argc!=5)return 2;
    const char *const funcs[]={"fmal","hypotl"},*const groups[]={"ordinary","cancel","exponents","scaled"};
    int fn=which(argv[1],funcs,2),g=which(argv[2],groups,4);if(fn<0||g<0)return 2;
    unsigned repeat=(unsigned)strtoul(argv[4],NULL,10);if(!repeat||repeat>1024)return 2;
    env_init(2,0);prepare((unsigned)g);
    if(!strcmp(argv[3],"oracle")) {
        for(unsigned r=0;r<4;r++){int e=oracle((unsigned)fn,r,stdout);if(e)return e;}
    } else if(!strcmp(argv[3],"check")) {
        for(unsigned pc=0;pc<3;pc++)for(unsigned r=0;r<4;r++)for(unsigned i=0;i<count;i++) {
            env_init(pc,r);errno=0;call((unsigned)fn,i);
            unsigned short sw,cw;unsigned mx;unsigned char record[16]={0};
            __asm__ volatile("fnstsw %0;fnstcw %1;stmxcsr %2":"=m"(sw),"=m"(cw),"=m"(mx)::"memory");
            memcpy(record,&val[i],10);record[10]=sw&63;record[11]=mx&63;memcpy(record+12,&cw,2);record[14]=(sw>>11)&7;record[15]=(unsigned char)errno;
            if(fwrite(record,1,sizeof(record),stdout)!=sizeof(record))return 4;
        }
    } else {
        env_init(2,0);
        for(unsigned k=0;k<repeat;k++)for(unsigned i=0;i<count;i++)call((unsigned)fn,i);
        uint64_t hash=UINT64_C(1469598103934665603);
        for(unsigned i=0;i<count;i++)for(unsigned j=0;j<10;j++)hash=(hash^((unsigned char*)&val[i])[j])*UINT64_C(1099511628211);
        unsigned short sw;unsigned mx;__asm__ volatile("fnstsw %0;stmxcsr %1":"=m"(sw),"=m"(mx));printf("%016llx %x %x\n",(unsigned long long)hash,sw&0x383f,mx&63);
    }
    return 0;
}
