#define _GNU_SOURCE
#include <fenv.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#pragma STDC FENV_ACCESS ON
static uint64_t random_word(uint64_t *s) { *s^=*s<<13;*s^=*s>>7;*s^=*s<<17;return *s; }
static void produce(FILE *out,const void *p,size_t n)
{
    uint64_t bits=0;uint32_t flags=fetestexcept(FE_ALL_EXCEPT);
    memcpy(&bits,p,n);if(fwrite(&bits,8,1,out)!=1 || fwrite(&flags,4,1,out)!=1)_Exit(2);
}
int main(int argc,char **argv)
{
    if(argc!=2)return 2;
    FILE *out=fopen(argv[1],"wb");if(!out)return 2;
    static const int modes[]={FE_TONEAREST,FE_DOWNWARD,FE_UPWARD,FE_TOWARDZERO};
    for(unsigned r=0;r<4;r++) {
        if(fesetround(modes[r]))return 2;
        uint64_t state=UINT64_C(0xd862da08cba382e5);
        for(unsigned i=0;i<8192;i++){
            double x;float y;uint64_t raw=random_word(&state);uint32_t small=(uint32_t)random_word(&state);
            if(i<4096) {int n=(int)(i%63)-31;double off=(double)(i/63)*0x1p-6;x=(double)n+off;y=(float)((double)(n%15)+off);}
            else if(i<6144){x=(double)((int)(raw%500001)-250000)*0.001953125;y=(float)x;}
            else {memcpy(&x,&raw,8);memcpy(&y,&small,4);}
            feclearexcept(FE_ALL_EXCEPT);double a=exp10(x);produce(out,&a,8);
            feclearexcept(FE_ALL_EXCEPT);float b=exp10f(y);produce(out,&b,4);
        }
    }
    return fclose(out)!=0;
}
