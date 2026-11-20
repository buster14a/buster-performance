#define _GNU_SOURCE
#include <fenv.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc,char **argv) {
    if(argc!=2)return 2;FILE *f=fopen(argv[1],"wb");if(!f)return 2;
    int modes[]={FE_TONEAREST,FE_DOWNWARD,FE_UPWARD,FE_TOWARDZERO};unsigned short pc[]={0,0x200,0x300};
    static const long double edges[]={0.0L,-0.0L,1.0L,-1.0L,0x1p-126L,0x1p-127L,0x1p-16382L,0x1p-16445L,0x1.fffffffffffffffep16383L,INFINITY,-INFINITY,NAN};
    for(unsigned a=0;a<3;a++)for(unsigned r=0;r<4;r++){
        __asm__ volatile("fninit");if(fesetround(modes[r]))return 2;
        unsigned short cw;__asm__ volatile("fnstcw %0":"=m"(cw));cw=(cw&~0x300u)|pc[a];__asm__ volatile("fldcw %0"::"m"(cw):"memory");
        uint64_t random=UINT64_C(0x81c39d715912ef4f);
        for(unsigned i=0;i<2048;i++){
            random^=random<<13;random^=random>>7;random^=random<<17;
            long double x=(long double)((int)(random%131071)-65535)*0x1p-12L;
            long double y=(long double)((int)((random>>20)%1023)-511)*0x1p-7L;
            if(i%16==0)x=edges[(i/16)%12];
            for(unsigned k=0;k<12;k++){
                volatile long double z;int exponent=0;unsigned before,after;unsigned short sw,actual;
                __asm__ volatile("fnclex; stmxcsr %0":"=m"(before)::"memory");before &=~63u;__asm__ volatile("ldmxcsr %0"::"m"(before):"memory");
                switch(k){
                    case 0:z=exp2l(x);break;case 1:z=expm1l(x);break;case 2:z=log10l(x);break;
                    case 3:z=acosl(x);break;case 4:z=atan2l(x,y);break;case 5:z=powl(x,y);break;
                    case 6:z=coshl(x);break;case 7:z=frexpl(x,&exponent);break;case 8:z=exp10l(x);break;
                    case 9:z=tgammal(x);break;case 10:z=erfl(x);break;default:z=sinl(x);break;
                }
                __asm__ volatile("fnstsw %0; fnstcw %1; stmxcsr %2":"=m"(sw),"=m"(actual),"=m"(after):"m"(z):"memory");
                if((sw&0x3800)||cw!=actual)return 3;
                unsigned char raw[16]={0};memcpy(raw,(const void*)&z,10);raw[10]=(unsigned char)(sw&63);raw[11]=(unsigned char)(after&63);memcpy(raw+12,&exponent,4);if(fwrite(raw,1,sizeof(raw),f)!=sizeof(raw))return 4;
            }
        }
    }
    __asm__ volatile("fninit");return fclose(f)!=0;
}
