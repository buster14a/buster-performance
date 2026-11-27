#include <immintrin.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define C_NAME_VA_OPT 237
#define C_TOKEN_HASHHASH 61
#define C_TOKEN_HASH 60
#define C_TOKEN_RAW_IDENTIFIER 1
#define C_TOKEN_NUMERIC_CONSTANT 2
typedef struct {uint32_t paste,hash,opt;} PPBodyPlaces;
typedef struct {const uint8_t*kinds;const uint32_t*values;uint32_t token_count;} PPFileData;
typedef struct PPBodyWord
{
    uint64_t paste, hash, opt;
    uint32_t index;
} PPBodyWord;

static PPBodyPlaces pp_body_places(const PPFileData* data, uint32_t begin, uint32_t end, PPBodyWord* cache)
{
    PPBodyPlaces places = { 0 };
    for (uint64_t word = (uint64_t)begin & ~UINT64_C(63); begin < end && word < end; word += 64)
    {
        if (cache->index != word)
        {
            cache->index = (uint32_t)word;
            const __mmask64 lanes = _bzhi_u64(UINT64_MAX, data->token_count - (uint32_t)word < 64 ? data->token_count - (uint32_t)word : 64);
            const __m512i kinds = _mm512_and_si512(_mm512_maskz_loadu_epi8(lanes, data->kinds + word), _mm512_set1_epi8(0x7f));
            cache->paste = _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(C_TOKEN_HASHHASH));
            cache->hash = _mm512_cmpeq_epi8_mask(kinds, _mm512_set1_epi8(C_TOKEN_HASH));
            cache->opt = 0;
            const uint64_t identifiers = _mm512_mask_cmpeq_epi8_mask(lanes, kinds, _mm512_set1_epi8(C_TOKEN_RAW_IDENTIFIER));
            for (uint32_t offset = 0; offset < 64 && (identifiers >> offset) != 0; offset += 16)
            {
                const __mmask16 named = (__mmask16)(identifiers >> offset);
                const __m512i ids = _mm512_maskz_loadu_epi32(named, data->values + word + offset);
                cache->opt |= (uint64_t)_mm512_mask_cmpeq_epi32_mask(named, ids, _mm512_set1_epi32(C_NAME_VA_OPT)) << offset;
            }
        }
        const uint32_t last = end - (uint32_t)word;
        const uint64_t active = _bzhi_u64(UINT64_MAX, last < 64 ? last : 64) & (UINT64_MAX << (begin > word ? begin - word : 0));
        const uint64_t paste = cache->paste & active, hash = cache->hash & active, opt = cache->opt & active;
        if (paste != 0)
        {
            places.paste = (uint32_t)(word + 64 - __builtin_clzll(paste));
        }
        if (hash != 0)
        {
            places.hash = (uint32_t)(word + 64 - __builtin_clzll(hash));
        }
        if (opt != 0)
        {
            places.opt = (uint32_t)(word + 64 - __builtin_clzll(opt));
        }
    }
    return places;
}

static void pp_scan_body_vector(const uint8_t* kinds, const uint32_t* values, uint32_t begin, uint32_t end, bool* pastes, bool* hashes, bool* va_opt)
{
    uint64_t found_pastes = 0;
    uint64_t found_hashes = 0;
    uint64_t found_va_opt = 0;
    for (uint32_t t = begin; t < end; t += 64)
    {
        const __mmask64 lanes = _bzhi_u64(~0ull, end - t < 64 ? end - t : 64);
        const __m512i kind = _mm512_and_si512(_mm512_maskz_loadu_epi8(lanes, kinds + t), _mm512_set1_epi8(0x7F));
        found_pastes |= _mm512_mask_cmpeq_epi8_mask(lanes, kind, _mm512_set1_epi8(C_TOKEN_HASHHASH));
        found_hashes |= _mm512_mask_cmpeq_epi8_mask(lanes, kind, _mm512_set1_epi8(C_TOKEN_HASH));
        // An identifier's value is its id; another token's is its end, which may equal __VA_OPT__'s id.
        const uint64_t identifiers = _mm512_mask_cmpeq_epi8_mask(lanes, kind, _mm512_set1_epi8(C_TOKEN_RAW_IDENTIFIER));
        for (uint32_t j = 0; j < 4 && (identifiers >> (16 * j)) != 0; j += 1)
        {
            const __mmask16 named = (__mmask16)(identifiers >> (16 * j));
            const __m512i ids = _mm512_maskz_loadu_epi32(named, values + t + 16 * j);
            found_va_opt |= _mm512_mask_cmpeq_epi32_mask(named, ids, _mm512_set1_epi32(C_NAME_VA_OPT));
        }
    }
    *pastes = found_pastes != 0;
    *hashes = found_hashes != 0;
    *va_opt = found_va_opt != 0;
}

// pp_scan_body_vector's scalar twin.
static void pp_scan_body_scalar(const uint8_t* kinds, const uint32_t* values, uint32_t begin, uint32_t end, bool* pastes, bool* hashes, bool* va_opt)
{
    *pastes = false;
    *hashes = false;
    *va_opt = false;
    for (uint32_t t = begin; t < end; t += 1)
    {
        *pastes |= (kinds[t] & 0x7F) == C_TOKEN_HASHHASH;
        *hashes |= (kinds[t] & 0x7F) == C_TOKEN_HASH;
        *va_opt |= (kinds[t] & 0x7F) == C_TOKEN_RAW_IDENTIFIER && values[t] == C_NAME_VA_OPT;
    }
}

#define ROWS 65536
static uint8_t kinds[ROWS];
static uint32_t values[ROWS];
static PPBodyPlaces places[ROWS];
static PPFileData file = {kinds,values,ROWS};
static unsigned noinline_scalar(unsigned b,unsigned e) {
 bool p,h,o;pp_scan_body_scalar(kinds,values,b,e,&p,&h,&o);return p|2*h|4*o;
}
static unsigned noinline_vector(unsigned b,unsigned e) {
 bool p,h,o;pp_scan_body_vector(kinds,values,b,e,&p,&h,&o);return p|2*h|4*o;
}
static unsigned narrow(unsigned b,unsigned e) {
 unsigned left=e-b;
 if(left==0)return 0;
 if(left==1){
  __m128i targets=_mm_cvtsi32_si128(C_TOKEN_HASHHASH|(C_TOKEN_HASH<<8)|(C_TOKEN_RAW_IDENTIFIER<<16));
  unsigned flags=_mm_cmpeq_epi8_mask(_mm_set1_epi8(kinds[b]&0x7f),targets);
  return flags & (3u | ((values[b]==C_NAME_VA_OPT)<<2));
 }
 // Sixteen token kinds and their values occupy one 512-bit column of identifiers.
 unsigned flags=0;
 for(uint64_t i=b;i<e;i+=16){
  unsigned remain=e-(unsigned)i;
  __mmask16 active=(__mmask16)_bzhi_u32(65535,remain>=16?16:remain);
  __m128i kind=_mm_and_si128(_mm_maskz_loadu_epi8(active,kinds+i),_mm_set1_epi8(0x7f));
  __mmask16 id=_mm_mask_cmpeq_epi8_mask(active,kind,_mm_set1_epi8(C_TOKEN_RAW_IDENTIFIER));
  flags |= (_mm_mask_cmpeq_epi8_mask(active,kind,_mm_set1_epi8(C_TOKEN_HASHHASH))!=0)
     | ((_mm_mask_cmpeq_epi8_mask(active,kind,_mm_set1_epi8(C_TOKEN_HASH))!=0)<<1)
     | ((_mm512_mask_cmpeq_epi32_mask(id,_mm512_maskz_loadu_epi32(id,values+i),_mm512_set1_epi32(C_NAME_VA_OPT))!=0)<<2);
 }
 return flags;
}
static unsigned summary(unsigned b,unsigned d){
 __m128i last=_mm_maskz_loadu_epi32(7,places+d);
 return _mm_cmpgt_epu32_mask(last,_mm_set1_epi32((int)b))&7;
}
static __attribute__((noinline)) uint64_t scan(unsigned variant,unsigned n,unsigned stride,unsigned first,unsigned windows) {
 unsigned sum=0;
 PPBodyWord cache={.index=UINT32_MAX};
 if(variant==2){
  for(unsigned d=0;d<windows;d++){unsigned b=first+d*stride;places[d]=pp_body_places(&file,b,b+n,&cache);}
 }
 for(unsigned d=0;d<windows;d++){
  unsigned b=first+d*stride;
  switch(variant){
   case 0:sum+=noinline_scalar(b,b+n);break;
   case 1:sum+=noinline_vector(b,b+n);break;
   case 2:sum+=summary(b,d);break;
   default:sum+=narrow(b,b+n);break;
  }
 }
 return sum;
}
static int cmp(const void*a,const void*b){uint64_t u=*(const uint64_t*)a,v=*(const uint64_t*)b;return(u>v)-(u<v);}
int main(void){
 uint32_t random=2924;
 puts("layout\tlength\tspacing\tscalar\tvector\tprepared\tnarrow");
 for(unsigned layout=0;layout<3;layout++){
  for(unsigned i=0;i<ROWS;i++){
   random=random*1664525u+1013904223u;
   static const int types[]={C_TOKEN_HASH,C_TOKEN_HASHHASH,C_TOKEN_RAW_IDENTIFIER,9};
   kinds[i]=layout==0?9:layout==1?C_TOKEN_RAW_IDENTIFIER:types[(random>>16)%4];
   kinds[i]|=(random>>31)<<7;
   values[i]=(random%19==0)?C_NAME_VA_OPT:random;
  }
  for(unsigned n=0;n<=257;n++){
   if(n>65 && n!=95&&n!=127&&n!=128&&n!=129&&n!=191&&n!=255&&n!=256&&n!=257)continue;
   for(unsigned spacing=0;spacing<2;spacing++){
    unsigned stride=3+n+spacing*17,windows=(ROWS-384)/stride;
    uint64_t samples[4][9],reference=0;
    for(unsigned rep=0;rep<9;rep++){
     for(unsigned ix=0;ix<4;ix++){
      unsigned v=(ix+rep)%4,first=3+(rep%3)*7;
      _mm_lfence();uint64_t start=__rdtsc();_mm_lfence();
      uint64_t sum=scan(v,n,stride,first,windows);
      _mm_lfence();uint64_t stop=__rdtsc();_mm_lfence();
      if(ix==0)reference=sum;else if(sum!=reference){fprintf(stderr,"mismatch %u %u %u %u\n",v,n,rep,layout);return 1;}
      samples[v][rep]=stop-start;
     }
    }
    printf("%u\t%u\t%u",layout,n,spacing);
    for(unsigned v=0;v<4;v++){qsort(samples[v],9,sizeof(uint64_t),cmp);printf("\t%.3f",(double)samples[v][4]/windows);}puts("");
   }
  }
 }
 return 0;
}
