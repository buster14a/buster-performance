#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Case {
    uint64_t low; uint16_t high;
    long double (*get)(void); void (*put)(long double*); long double (*arg)(void);
    long double (*plus)(long double); long double (*minus)(long double);
    int (*less)(long double); long double (*choose)(int);
};
#include "cases.h"
long double pass(long double x) { __asm__ volatile("" : "+m"(x)); return x; }
static void reset(unsigned short cw, unsigned seed) {
    __asm__ volatile("fninit; fldcw %0"::"m"(cw):"memory");
    if(seed)__asm__ volatile("fldz; fldz; fdivp; fstp %%st(0)":::"memory");
}
static void checkstate(FILE *out, long double *v, unsigned short cw) {
    unsigned short actual,sw; _Alignas(16) unsigned char image[512];
    __asm__ volatile("fnstcw %0; fnstsw %1; fxsave %2":"=m"(actual),"=m"(sw),"=m"(image):"m"(*v):"memory");
    if(cw!=actual || (sw&0x3800) || image[4]) abort();
    unsigned char f=sw&0x7f;
    if(fwrite(v,1,10,out)!=10||fputc(f,out)==EOF) abort();
}
int main(int argc,char **argv) {
    if(argc!=2) return 2;FILE *out=fopen(argv[1],"wb");if(!out)return 2;
    unsigned short pcs[]={0,0x200,0x300};unsigned long long checks=0;
    static const long double inputs[]={-0.0L,0.0L,1.0L,-1.0L,0x1.0000000000000002p0L,0x1p-126L,0x1p-16445L,0x1.fffffffffffffffep16383L};
    for(unsigned i=0;i<sizeof(cases)/sizeof(*cases);i++){
        const struct Case *q=cases+i;
        for(unsigned p=0;p<3;p++)for(unsigned r=0;r<4;r++)for(unsigned sticky=0;sticky<2;sticky++){
            unsigned short cw=0x7f|pcs[p]|(r<<10);
            for(unsigned op=0;op<5;op++){
                struct { long double v; uint64_t fence[2]; } box;
                memset(&box,0xaf,sizeof(box));
                reset(cw,sticky);
                if(op==0)box.v=q->get();else if(op==1)q->put(&box.v);else if(op==2)box.v=q->arg();else box.v=q->choose(op==3);
                checkstate(out,&box.v,cw);checks++;
                if(op!=4 && (memcmp(&box.v,&q->low,8)||memcmp((char*)&box.v+8,&q->high,2)))abort();
                if(box.fence[0]!=UINT64_C(0xafafafafafafafaf)||box.fence[1]!=box.fence[0])abort();
            }
            for(unsigned j=0;j<sizeof(inputs)/sizeof(*inputs);j++)for(unsigned op=0;op<3;op++){
                long double v;reset(cw,sticky);
                if(op==0)v=q->plus(inputs[j]);else if(op==1)v=q->minus(inputs[j]);else v=q->less(inputs[j]);
                checkstate(out,&v,cw);checks++;
            }
        }
    }
    __asm__ volatile("fninit");if(fclose(out))return 2;
    printf("%zu constants, %llu result/flags/control/TOP/tag checks\n",sizeof(cases)/sizeof(*cases),checks);
    return 0;
}
