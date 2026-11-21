#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>
#include "digits8-kernel.h"
static uint32_t next(uint32_t* seed) { *seed=*seed*1664525u+1013904223u;return *seed; }
int main(void)
{
    const size_t page=(size_t)sysconf(_SC_PAGESIZE);unsigned char* regions[8];
    for(unsigned l=0;l<8;l++)
    {
        regions[l]=mmap(NULL,4*page,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
        if(regions[l]==MAP_FAILED || mprotect(regions[l]+page,2*page,PROT_READ|PROT_WRITE))return 2;
    }
    uint32_t rng=32, checked=0;
    for(unsigned r=0;r<120000;r++)
    {
        uint64_t addresses[8];uint32_t lengths[8], values[8], expected[8]={0};
        __mmask8 active=(__mmask8)(r%256), valid=0, observed=0;
        for(unsigned l=0;l<8;l++)
        {
            unsigned n=1+(r/8+l)%9, align=(r+l)%8, tail=3*page-n;
            unsigned char* p=regions[l]+((r/9)%2 ? tail-((tail-align)&7) : page+align);
            for(unsigned j=0;j<n;j++)p[j]=(unsigned char)('0'+next(&rng)%10);
            if(r%3==1)p[next(&rng)%n]=(unsigned char)(next(&rng)>>24);
            if(r%11==0)p[0]='0';
            bool ok=n==1 || p[0]!='0';
            for(unsigned j=0;j<n;j++) {uint32_t d=(uint32_t)p[j]-'0';ok&=d<10;expected[l]=expected[l]*10+d;}
            lengths[l]=n;addresses[l]=(uintptr_t)((active & (1u<<l)) ? p : regions[l]);
            if(ok && (active & (1u<<l)))valid|=(__mmask8)(1u<<l);
            if(active & (1u<<l))checked++;
        }
        const __m256i v=check_input_decimal_eight(_mm512_loadu_si512(addresses),_mm256_loadu_si256((const __m256i*)lengths),active,&observed);
        _mm256_storeu_si256((__m256i*)values,v);
        if(valid!=observed){fprintf(stderr,"mask r=%u got=%u expected=%u\n",r,observed,valid);return 3;}
        for(unsigned l=0;l<8;l++)if((valid&(1u<<l)) && values[l]!=expected[l]){fprintf(stderr,"value r=%u lane=%u got=%u expected=%u\n",r,l,values[l],expected[l]);return 4;}
    }
    printf("120000 batches, %u active lanes, all lengths 1-9, offsets 0-7, each active mask, both mapping edges, invalid bytes and leading zeroes passed\n",checked);
    return 0;
}
