#include <errno.h>
#include <fenv.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum { Count = 768 };
static char inputs[4][Count][192];
static unsigned group(const char *s) {
    if (!strcmp(s,"short")) return 0;
    if (!strcmp(s,"decimal")) return 1;
    if (!strcmp(s,"hex")) return 2;
    return 3;
}
static uint64_t step(uint64_t *s) { *s ^= *s<<13; *s ^= *s>>7; *s ^= *s<<17; return *s; }
static void prepare(void) {
    static const char *special[]={"", "x", "  +", "infinity!", "-INFinity", "+nan", "nan(f00)", "-0", "  -0x0p64!", "0x", "1e", "-0x1p", "0.50000000000000000002710505431213761085018632002174854278564453125", "1e4933", "-1e-4952", "0x1p-16445", "0x1p16384", "0x1.0000000000000001p0", "0x1.0000000000000003p0","0.00000;tail"};
    uint64_t seed=UINT64_C(0xa76bb58fe7937e01);
    for (unsigned i=0;i<Count;i++) {
        uint64_t a=step(&seed),b=step(&seed);
        snprintf(inputs[0][i],192,"%s%u.%03u;",i&1?"-":"",(unsigned)(a%100000),(unsigned)(b%1000));
        char digits[90];for(unsigned j=0;j<sizeof(digits)-1;j++) digits[j]=(char)('0'+step(&seed)%10);digits[sizeof(digits)-1]=0;
        snprintf(inputs[1][i],192," %s%u.%se%+dX",i&1?"-":"",(unsigned)(1+a%9),digits,(int)(b%7201)-3600);
        snprintf(inputs[2][i],192,"%s0x%llx.%016llxp%+dZ",i&1?"-":"",(unsigned long long)(a%16),(unsigned long long)b,(int)(step(&seed)%2201)-1100);
        snprintf(inputs[3][i],192,"%s",special[i%(sizeof(special)/sizeof(*special))]);
    }
}
struct Obs { unsigned char bytes[12]; uint32_t end; int32_t error; uint16_t x87; uint16_t mxcsr; };
int main(int argc,char** argv){
    if(argc!=5) return 2;
    unsigned g=group(argv[1]),repeat=(unsigned)strtoul(argv[3],NULL,10);
    unsigned fmt=!strcmp(argv[2],"float")?0:!strcmp(argv[2],"double")?1:2;
    int check=!strcmp(argv[4],"check");if(!repeat||repeat>2048)return 2;
    prepare();FILE* fout=check?stdout:NULL;uint64_t hash=UINT64_C(1469598103934665603);
    static const int modes[]={FE_TONEAREST,FE_TOWARDZERO,FE_UPWARD,FE_DOWNWARD};
    for(unsigned r=0;r<repeat;r++) {
        if (check && fesetround(modes[r%4])) return 3;
        for(unsigned i=0;i<Count;i++) {
            unsigned j=(i+17*r)%Count;char* end;struct Obs record={0};
            if(check)feclearexcept(FE_ALL_EXCEPT);errno=0;
            if(fmt==0) {float n=strtof(inputs[g][j],&end);memcpy(record.bytes,&n,4);}
            else if(fmt==1) {double n=strtod(inputs[g][j],&end);memcpy(record.bytes,&n,8);}
            else {long double n=strtold(inputs[g][j],&end);memcpy(record.bytes,&n,10);}
            record.error=errno;record.end=(uint32_t)(end-inputs[g][j]);if(record.end>strlen(inputs[g][j]))return 4;
            unsigned short sw;unsigned mxcsr;__asm__ volatile("fnstsw %0;stmxcsr %1":"=m"(sw),"=m"(mxcsr)::"memory");record.x87=sw&0x383f;record.mxcsr=mxcsr&63;
            if(check){if(fwrite(&record,1,sizeof(record),fout)!=sizeof(record))return 5;}
            else {uint64_t low;memcpy(&low,record.bytes,8);hash=(hash^low)*UINT64_C(1099511628211);hash^=(uint64_t)record.bytes[9]<<48 | (uint64_t)record.end<<32 | (uint32_t)record.error;}
        }
    }
    if(!check)printf("%016llx\n",(unsigned long long)hash);return 0;
}
