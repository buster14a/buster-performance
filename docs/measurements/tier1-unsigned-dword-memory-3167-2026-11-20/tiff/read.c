#include "tiffio.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc,char **argv) {
    if(argc!=4) return 2;
    unsigned n=(unsigned)strtoul(argv[2],0,10), reps=(unsigned)strtoul(argv[3],0,10);
    TIFF *t=TIFFOpen(argv[1],"r");if(!t)return 3;uint64_t check=0;
    for(unsigned j=0;j<=reps;j++) {
        if(j && !TIFFSetDirectory(t,0))return 4;
        if(!TIFFSetField(t,TIFFTAG_PERSAMPLE,PERSAMPLE_MULTI))return 5;
        double *low=0,*high=0;float *ref=0;
        if(!TIFFGetField(t,TIFFTAG_SMINSAMPLEVALUE,&low)||!TIFFGetField(t,TIFFTAG_SMAXSAMPLEVALUE,&high)||!TIFFGetField(t,TIFFTAG_REFERENCEBLACKWHITE,&ref)||!low||!high||!ref)return 6;
        if(!j){
            for(unsigned i=0;i<n;i++){
                uint32_t x=(i*UINT32_C(2654435761)+UINT32_C(0x1000001))&UINT32_C(0x7fffffff),y=UINT32_MAX-x/2;
                if(low[i]!=(double)x||high[i]!=(double)y){fprintf(stderr,"entry %u %.0f %.0f\n",i,low[i],high[i]);return 7;}
            }
            uint32_t num[6]={0,UINT32_MAX,1,UINT32_C(0x80000001),2,UINT32_C(0xfffffffd)};
            unsigned den[6]={1,3,1,7,1,11};
            for(unsigned i=0;i<6;i++){float expected=(float)((double)num[i]/den[i]);if(ref[i]!=expected)return 8;}
        }
        unsigned k=(j*17u)%n;check=check*UINT64_C(6364136223846793005)+(uint64_t)low[k]+(uint64_t)high[k];
    }
    TIFFClose(t);printf("%u %u %016llx\n",n,reps,(unsigned long long)check);return 0;
}
