from pathlib import Path
d=Path(__file__).resolve().parent
s=(d/'tools/scratchfargather.c').read_text()
s=s.replace('    uint64_t* lookup_keys;', '''    uint64_t* single_rows;
    uint32_t single_bits;
    uint32_t template_bits;
    uint8_t single_seed[64] __attribute__((aligned(64)));
    uint64_t* lookup_keys;''')
a=s.index('static uint32_t lanes_lookup_index(')
s=s[:a]+'''// Each of 64 prefixes independently chooses an odd multiplier for the remaining
// 58 bits. Multiplication is bijective there. A row supplies the low fragment;
// its address already checked the remaining bits of the mixed hash.
static uint64_t mixed_key(uint64_t h, uint8_t multiplier) {
    const uint64_t mask=UINT64_MAX>>6;
    return (h&~mask)|((h*multiplier)&mask);
}
static void lanes_single_rows(Lanes* l, const Unit* unit) {
    unsigned tbits=0;
    while ((UINT64_C(1)<<tbits)<unit->template_count) ++tbits;
    uint32_t bits=14;
    if (bits<7+tbits) bits=7+tbits;
    int32_t* next=must(malloc(l->slot_keys*sizeof(int32_t)));
    uint64_t* keys=must(malloc(l->slot_keys*sizeof(uint64_t)));
    uint32_t* values=must(malloc(l->slot_keys*sizeof(uint32_t)));
    int32_t heads[64];
    memset(heads,0xff,sizeof(heads));
    uint32_t n=0;
    for (uint32_t b=0;b<=l->slot_mask;++b) for(uint32_t i=0;i<4 && l->slots[b].checks[i];++i){
        uint64_t h=l->slots[b].checks[i];unsigned g=(unsigned)(h>>58);
        keys[n]=h;values[n]=l->slots[b].values[i];next[n]=heads[g];heads[g]=(int32_t)n++;
    }
    for(;;++bits) {
        if(bits>23) abort();
        const uint32_t size=1u<<bits, bucket=size/64;
        uint8_t* used=must(calloc(bucket,1));bool ok=true;
        for(unsigned g=0;g<64;++g) {
            unsigned factor=1;
            for(;factor<256;factor+=2) {
                memset(used,0,bucket);bool fits=true;
                for(int j=heads[g];j>=0;j=next[j]){
                    unsigned at=(unsigned)(mixed_key(keys[j],factor)>>(64-bits)) & (bucket-1);
                    if(used[at]) {fits=false;break;} used[at]=1;
                }
                if(fits) break;
            }
            if(factor==257) {ok=false;break;} l->single_seed[g]=(uint8_t)factor;
        }
        free(used);
        if(ok) break;
    }
    l->single_bits=bits; l->template_bits=tbits;
    l->single_rows=must(calloc(UINT64_C(1)<<bits,sizeof(uint64_t)));
    uint64_t mask=UINT64_MAX>>bits;
    for(uint32_t i=0;i<n;++i){
        uint64_t h=keys[i],mixed=mixed_key(h,l->single_seed[h>>58]);
        uint32_t code=(values[i]&LANES_CHOSEN_TEMPLATE) | ((values[i]>>24)<<tbits);
        if((code>>bits)!=0) abort();
        uint64_t* row=&l->single_rows[mixed>>(64-bits)];
        if(*row!=0) abort();
        *row=(mixed&mask)|((uint64_t)code<<(64-bits));
    }
    printf("single exact table\\t%u keys %u index bits %u template bits\\n",n,bits,tbits);
    free(next);free(keys);free(values);
}
'''+s[a:]
s=s.replace('    lanes_build_lookup(lanes);','    lanes_single_rows(lanes,unit);')
a=s.index('            const __m256i bucket = _mm512_cvtepi64_epi32');b=s.index('\n        }',a)
s=s[:a]+'''            const __m512i seeds=_mm512_load_si512(lanes->single_seed);
            const __m512i mult=_mm512_and_si512(_mm512_permutexvar_epi8(_mm512_srli_epi64(hash,58),seeds),_mm512_set1_epi64(255));
            const __m512i mask=_mm512_set1_epi64(UINT64_MAX>>6);
            const __m512i mixed=_mm512_or_si512(_mm512_andnot_si512(mask,hash),_mm512_and_si512(mask,_mm512_mullo_epi64(hash,mult)));
            const __m128i shift=_mm_cvtsi32_si128(64-lanes->single_bits);
            const __m256i index=_mm512_cvtepi64_epi32(_mm512_srl_epi64(mixed,shift));
            const __m512i row=_mm512_i32gather_epi64(index,lanes->single_rows,8);
            const __mmask8 hit=_mm512_testn_epi64_mask(_mm512_xor_si512(row,mixed),_mm512_set1_epi64(UINT64_MAX>>lanes->single_bits));
            const __m256i code=_mm512_cvtepi64_epi32(_mm512_srl_epi64(row,shift));
            const __m256i id=_mm256_and_si256(code,_mm256_set1_epi32((1u<<lanes->template_bits)-1));
            const __m256i flags=_mm256_slli_epi32(_mm256_srl_epi32(code,_mm_cvtsi32_si128(lanes->template_bits)),24);
            answers[i]=_mm256_mask_mov_epi32(_mm256_set1_epi32(LANES_CHOSEN_MISSED),hit,_mm256_or_si256(id,flags));'''+s[b:]
(d/'tools/single.c').write_text(s)
