#include <fenv.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <immintrin.h>
#pragma STDC FENV_ACCESS ON

extern void apart32(float,float*,float*);
extern void apart64(double,double*,double*);
extern float same32(float);
extern double same64(double);
extern void array32(float*,float*,const float*,unsigned);
extern void array64(double*,double*,const double*,unsigned);
enum { N=1024 };
static uint32_t x32[N], expected32[N];
static uint64_t x64[N], expected64[N];
static float input32[N], actual32[N], saved32[N];
static double input64[N], actual64[N], saved64[N];
static uint64_t digest=UINT64_C(14695981039346656037);
static unsigned checks;
static void hash(uint64_t value) {digest=(digest^value)*UINT64_C(1099511628211);}
static uint32_t bits32(float v){uint32_t b;memcpy(&b,&v,4);return b;}
static uint64_t bits64(double v){uint64_t b;memcpy(&b,&v,8);return b;}

int main(void)
{
    const uint32_t f[]={0,0x80000000,1,0x80000001,0x007fffff,0x00800000,0x7f7fffff,0x7f800000,0xff800000,0x7fc01234,0xffc54321,0x7f801234,0xff805432};
    const uint64_t d[]={0,0x8000000000000000ULL,1,0x8000000000000001ULL,0x000fffffffffffffULL,0x0010000000000000ULL,0x7fefffffffffffffULL,0x7ff0000000000000ULL,0xfff0000000000000ULL,0x7ff8000000001234ULL,0xfff8000000005678ULL,0x7ff0000000001234ULL,0xfff0000000005678ULL};
    uint64_t seed=0x923b7eafae41b298ULL;
    for(unsigned i=0;i<N;++i){
        seed^=seed<<13;seed^=seed>>7;seed^=seed<<17;
        x32[i]=i<sizeof(f)/sizeof(*f)?f[i]:(uint32_t)seed;
        x64[i]=i<sizeof(d)/sizeof(*d)?d[i]:seed;
        expected32[i]=x32[i]^0x80000000U;expected64[i]=x64[i]^(UINT64_C(1)<<63);
    }
    memcpy(input32,x32,sizeof(x32));memcpy(input64,x64,sizeof(x64));
    const int modes[]={FE_TONEAREST,FE_DOWNWARD,FE_UPWARD,FE_TOWARDZERO};
    const unsigned original_control=_mm_getcsr();
    for(unsigned m=0;m<4;++m)for(unsigned denormal=0;denormal<4;++denormal)for(unsigned sticky=0;sticky<2;++sticky){
        if(fesetround(modes[m]))return 2;
        unsigned control=_mm_getcsr();
        control=(control&~(0x8040U|0x3fU))|((denormal&1)?0x40U:0)|((denormal&2)?0x8000U:0)|(sticky?0x21U:0);
        _mm_setcsr(control);
        for(unsigned i=0;i<N;++i){
            float y,z;double u,v;
            apart32(input32[i],&y,&z);apart64(input64[i],&u,&v);
            uint32_t ry=bits32(y),rz=bits32(z),rs=bits32(same32(input32[i]));
            uint64_t ru=bits64(u),rv=bits64(v),rt=bits64(same64(input64[i]));
            if(ry!=expected32[i]||rz!=x32[i]||rs!=ry||ru!=expected64[i]||rv!=x64[i]||rt!=ru||_mm_getcsr()!=control) {
                fprintf(stderr,"failed mode=%u denormal=%u sticky=%u input=%u mxcsr=%x expected=%x\n",m,denormal,sticky,i,_mm_getcsr(),control);
                return 1;
            }
            checks+=7;hash(ry);hash(ru);hash(rz);hash(rv);
        }
        array32(actual32,saved32,input32,N);array64(actual64,saved64,input64,N);
        if(memcmp(actual32,expected32,sizeof(x32)) || memcmp(actual64,expected64,sizeof(x64)) || memcmp(saved32,x32,sizeof(x32)) || memcmp(saved64,x64,sizeof(x64)) || _mm_getcsr()!=control)return 3;
        checks+=4*N+1;
    }
    _mm_setcsr(original_control);
    printf("negation and input-preservation checks=%u digest=%016" PRIx64 "\n",checks,digest);
    return 0;
}
