
#include <immintrin.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BUSTER_VECTOR_PATH(x) (x)
#define X86_FORM_FSTP_M80 729
typedef struct { uint16_t form; uint8_t rest[14]; } X86Instruction;
static inline uint64_t legacy(const X86Instruction* records, const uint32_t* tokens, const uint8_t* eligible, uint32_t first, uint32_t count, bool vector)
{
    uint64_t candidates = 0;
    if (BUSTER_VECTOR_PATH(vector))
    {
        const __m512i indices = _mm512_setr_epi32(0, 16, 32, 48, 64, 80, 96, 112, 128, 144, 160, 176, 192, 208, 224, 240);
        const __m512i lanes_ids = _mm512_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
        for (uint32_t r = 0; r < count; r += 16)
        {
            const uint32_t left = count - r;
            const __mmask16 lanes = left >= 16 ? (__mmask16)0xffff : (__mmask16)((1u << left) - 1);
            const __m512i words = _mm512_mask_i32gather_epi32(_mm512_setzero_si512(), lanes, indices, &records[first + r].form, 1);
            const __m512i forms = _mm512_and_si512(words, _mm512_set1_epi32(0xffff));
            const __m512i ids = _mm512_add_epi32(lanes_ids, _mm512_set1_epi32((int32_t)(first + r)));
            const __m512i names = _mm512_maskz_loadu_epi32(lanes, tokens + first + r);
            const __mmask16 stores = lanes & _mm512_cmpeq_epi32_mask(forms, _mm512_set1_epi32(X86_FORM_FSTP_M80)) & _mm512_cmpeq_epi32_mask(names, ids);
            candidates |= (uint64_t)stores << r;
        }
    }
    else
    {
        for (uint32_t r = 0; r < count; r += 1)
        {
            candidates |= (uint64_t)(records[first + r].form == X86_FORM_FSTP_M80 && tokens[first + r] == first + r) << r;
        }
    }
    uint64_t enabled = candidates;
    while (enabled != 0)
    {
        const uint32_t r = (uint32_t)__builtin_ctzll(enabled);
        candidates &= eligible[first + r] != 0 ? UINT64_MAX : ~(UINT64_C(1) << r);
        enabled &= enabled - 1;
    }
    return candidates;
}
#define ROWS 65536u
static X86Instruction records[ROWS];
static uint32_t tokens[ROWS];
static uint8_t enabled[ROWS],certificates[ROWS];

#define X86_FORM_FLD_M80 520
#define BUSTER_X87_TRANSFER_STORE 1u
#define BUSTER_X87_TRANSFER_RELOAD 2u
static __m512i x87_transfer_annotations(const uint8_t* annotations, uint32_t first, uint32_t count)
{
    return _mm512_maskz_loadu_epi8(_bzhi_u64(UINT64_MAX, count), annotations + first);
}

static __attribute__((noinline)) uint64_t scalar(unsigned first, unsigned count)
{
    uint64_t candidates = legacy(records, tokens, enabled, first, count, false);
    uint64_t reads = 0, repeated = 0;
    for (uint32_t r = 0; candidates != 0 && r < count; r += 1)
    {
        const uint32_t home = tokens[first + r] - first;
        if (home < r && records[first + r].form == X86_FORM_FLD_M80)
        {
            const uint64_t bit = UINT64_C(1) << home;
            repeated |= reads & bit;
            reads |= bit;
        }
    }
    candidates &= reads & ~repeated;
    return candidates;
}
static __attribute__((noinline)) uint64_t gather(unsigned first, unsigned count)
{
    uint64_t candidates = legacy(records, tokens, enabled, first, count, true);
    uint64_t reads = 0, repeated = 0;
    for (uint32_t r = 0; candidates != 0 && r < count; r += 1)
    {
        const uint32_t home = tokens[first + r] - first;
        if (home < r && records[first + r].form == X86_FORM_FLD_M80)
        {
            const uint64_t bit = UINT64_C(1) << home;
            repeated |= reads & bit;
            reads |= bit;
        }
    }
    candidates &= reads & ~repeated;
    return candidates;
}
static __attribute__((noinline)) uint64_t head(unsigned first, unsigned count)
{
    const __m512i tags = x87_transfer_annotations(certificates, first, count);
    uint64_t candidates = _mm512_test_epi8_mask(tags, _mm512_set1_epi8(BUSTER_X87_TRANSFER_STORE));
    uint64_t loads = _mm512_test_epi8_mask(tags, _mm512_set1_epi8(BUSTER_X87_TRANSFER_RELOAD));
    uint64_t reads = 0, repeated = 0;
    while (loads != 0 && candidates != 0)
    {
        const uint32_t r = (uint32_t)__builtin_ctzll(loads);
        loads &= loads - 1;
        const uint32_t owner = tokens[first + r];
        const uint32_t home = owner - first;
        if (home < r && records[first + r].form == X86_FORM_FLD_M80 &&
            records[owner].form == X86_FORM_FSTP_M80 && tokens[owner] == owner)
        {
            const uint64_t bit = UINT64_C(1) << home;
            repeated |= reads & bit;
            reads |= bit;
        }
    }
    candidates &= reads & ~repeated;
    return candidates;
}
typedef uint64_t (*Scan)(unsigned, unsigned);
static Scan const variants[] = {scalar,gather,head};
static uint64_t time_scan(Scan scan,unsigned first,unsigned stride,unsigned count,unsigned windows,uint64_t *sum){
    uint64_t value=0;_mm_lfence();uint64_t start=__rdtsc();_mm_lfence();
    for(unsigned j=0;j<windows;j++)value+=scan(first+j*stride,count);
    _mm_lfence();uint64_t end=__rdtsc();_mm_lfence();*sum=value;return end-start;
}
static int cmp(const void*a,const void*b){uint64_t x=*(const uint64_t*)a,y=*(const uint64_t*)b;return (x>y)-(x<y);}
int main(void){
 uint64_t state=2924;
 for(unsigned layout=0;layout<4;layout++){
  for(unsigned i=0;i<ROWS;i++){
   state=state*6364136223846793005ull+1442695040888963407ull;
   records[i].form=(state>>33)&1 ? X86_FORM_FSTP_M80:X86_FORM_FLD_M80;
   unsigned delta=(state>>39)%10;
   tokens[i]=records[i].form==X86_FORM_FSTP_M80?i:i>=delta ? i-delta:UINT32_MAX;
   enabled[i]=(records[i].form==X86_FORM_FSTP_M80 && ((state>>42)&1)) ? 0x80:0;
   if(layout==1)enabled[i]=0;
   if(layout==2){
     records[i].form=i%2 ? X86_FORM_FLD_M80:X86_FORM_FSTP_M80;
     enabled[i]=!(i%2);tokens[i]=i&~1u;
   }
   if(layout==3){tokens[i]=(state>>47)&1?tokens[i]:UINT32_MAX;enabled[i]=(state>>43)&1;}
  }
  for(unsigned i=0;i<ROWS;i++) certificates[i]=(enabled[i]!=0)|((tokens[i]<i)?2:0);
  for(unsigned n=1;n<=64;n++)for(unsigned pattern=0;pattern<3;pattern++){
    unsigned stride=(unsigned[]){64,67,17}[pattern],start=(unsigned[]){0,7,63}[pattern],nt=(ROWS-64-start)/stride+1;
    uint64_t ticks[3][9],oracle=0;
    for(unsigned j=0;j<nt;j++){
      unsigned first=start+j*stride;uint64_t v=scalar(first,n);
      if(v!=head(first,n)||v!=gather(first,n))return 2;
      oracle+=v;
    }
    for(unsigned round=0;round<9;round++)for(unsigned k=0;k<3;k++){
      unsigned v=(k+round)%3;uint64_t got=0;
      ticks[v][round]=time_scan(variants[v],start,stride,n,nt,&got);
      if(got!=oracle)return 3;
    }
    printf("%u %u %u",layout,n,stride);
    for(unsigned v=0;v<3;v++){qsort(ticks[v],9,sizeof(uint64_t),cmp);printf(" %.4f",(double)ticks[v][4]/nt);}
    puts("");
  }
 }
}
