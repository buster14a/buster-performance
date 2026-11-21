#include "buster/compiler/c_lexer.c"
#include "buster/compiler/lane.c"
#include "buster/compiler/c_intern.c"
#include "buster/compiler/c_refine.c"
#include "buster/compiler/c_predefines.c"
#include "buster/compiler/c_preprocessor.c"
#include <sys/mman.h>
static uint64_t rng=UINT64_C(0xbfc0c6fefa189c31);
static uint64_t next_word(void) { rng ^= rng >> 12; rng ^= rng << 25; rng ^= rng >> 27; return rng * UINT64_C(2685821657736338717); }
int main(void) {
    static Preprocessor pp;
    size_t page=(size_t)sysconf(_SC_PAGESIZE);uint8_t* bytes=mmap(NULL,page*3,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(bytes==MAP_FAILED || mprotect(bytes+page,page,PROT_READ|PROT_WRITE))return 2;
    uint64_t bits[2];pp.is_macro=bits;
    for(uint32_t test=0;test<150000;test++){
        uint32_t* ids=(uint32_t*)(bytes+page+((test&1)?page-64*sizeof(*ids):0));uint64_t mask=next_word();uint64_t want=0;
        bits[0]=next_word();bits[1]=next_word();
        for(uint32_t i=0;i<64;i++){
            uint32_t v=(uint32_t)next_word();
            switch((test+i)%5) {case 0:v&=127;break;case 1:v%=256;break;case 2:v=(uint32_t[]){0,63,64,127,128,255,256,UINT32_MAX}[v%8];break;case 3:v=(v&31)+112;break;}
            ids[i]=v;
            if((mask>>i&1) && (v>=128 || (bits[v/64]>>(v%64)&1)))want|=UINT64_C(1)<<i;
        }
        uint64_t result=pp_file_low_bank(&pp,ids,mask);
        if(result!=want) {fprintf(stderr,"mismatch %u: %016lx %016lx\n",test,result,want);return 1;}
    }
    if(munmap(bytes,page*3))return 2;
    puts("150000 guarded 64-lane batches matched scalar, including ID 0,63,64,127,128,255,256 and UINT32_MAX");
}
