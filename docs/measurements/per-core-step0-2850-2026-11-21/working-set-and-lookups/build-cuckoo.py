from pathlib import Path
d=Path(__file__).resolve().parent
s=(d/'tools/scratchfargather.c').read_text()
s=s.replace('    uint64_t* lookup_keys;', '''    uint64_t* bank[2];
    uint32_t* choices;
    uint64_t fragment;
    uint32_t bank_bits;
    uint64_t* lookup_keys;''')
a=s.index('static uint32_t lanes_lookup_index(')
s=s[:a]+'''// The slot number supplies the high bits of an exact hash. Those bits can
// hold the compact template number in the stored row. The second candidate
// rotates the hash and therefore supplies different bits.
static uint64_t bank_key(uint64_t hash, unsigned bank) {
    return bank == 0 ? hash : (hash<<31 | hash>>33);
}
static void lanes_banks(Lanes* l, const Unit* unit) {
    uint32_t bits=12;
    while ((1u<<bits)<unit->template_count+2 || (1u<<bits)<l->slot_keys) ++bits;
    for (;;) {
        if(bits>24) abort();
        uint32_t size=1u<<bits; uint64_t fragment=UINT64_MAX>>bits;
        uint64_t* occupied[2]={must(calloc(size,sizeof(uint64_t))),must(calloc(size,sizeof(uint64_t)))};
        uint32_t* ids[2]={must(calloc(size,sizeof(uint32_t))),must(calloc(size,sizeof(uint32_t)))};
        bool ok=true;
        for(uint32_t b=0;ok && b<=l->slot_mask;++b) for(unsigned i=0;i<4 && l->slots[b].checks[i];++i) {
            uint64_t hash=l->slots[b].checks[i];const uint32_t value=l->slots[b].values[i];
            uint32_t id=value==LANES_CHOSEN_MISSED ? 0 : (value&LANES_CHOSEN_TEMPLATE)+1;
            // Use an empty alternative first to keep settled primary residents.
            unsigned side=occupied[0][hash>>(64-bits)]!=0 && occupied[1][bank_key(hash,1)>>(64-bits)]==0;
            for(unsigned attempt=0;hash && attempt<128;++attempt) {
                uint32_t idx=(uint32_t)(bank_key(hash,side)>>(64-bits));
                uint64_t evict=occupied[side][idx];uint32_t old=ids[side][idx];
                occupied[side][idx]=hash;ids[side][idx]=id;hash=evict;id=old;side^=1;
            }
            if(hash) {ok=false;break;}
        }
        if(ok) {
            l->bank_bits=bits;l->fragment=fragment;
            l->choices=must(calloc(size,sizeof(uint32_t)));l->choices[0]=LANES_CHOSEN_MISSED;
            for(uint32_t t=0;t<unit->template_count;++t) l->choices[t+1]=t | (uint32_t)unit->templates[t].total<<24 | (unit->templates[t].early?LANES_CHOSEN_EARLY:0);
            for(unsigned side=0;side<2;++side) {
                l->bank[side]=must(calloc(size,sizeof(uint64_t)));
                for(uint32_t j=0;j<size;++j)
                    if(occupied[side][j]) l->bank[side][j]=(bank_key(occupied[side][j],side)&fragment) | ((uint64_t)ids[side][j]<<(64-bits));
            }
            for(uint32_t b=0;b<=l->slot_mask;++b) for(unsigned i=0;i<4 && l->slots[b].checks[i];++i) {
                const uint64_t h=l->slots[b].checks[i];bool found=false;
                for(unsigned side=0;side<2;++side) {
                    const uint64_t k=bank_key(h,side), row=l->bank[side][k>>(64-bits)];
                    if (occupied[side][k>>(64-bits)]==h) {
                        if (((row^k)&fragment)!=0 || l->choices[row>>(64-bits)]!=l->slots[b].values[i]) abort();
                        found=true;
                    }
                }
                if(!found) abort();
            }
        }
        for(unsigned side=0;side<2;++side){free(occupied[side]);free(ids[side]);}
        if(ok) break;
        ++bits;
    }
}
'''+s[a:]
s=s.replace('    lanes_build_lookup(lanes);','    lanes_banks(lanes,unit);')
a=s.index('            const __m256i bucket = _mm512_cvtepi64_epi32');b=s.index('\n        }',a)
s=s[:a]+'''            const __m128i shift=_mm_cvtsi32_si128(64-lanes->bank_bits);
            const __m512i fragment=_mm512_set1_epi64(lanes->fragment);
            const __m256i index=_mm512_cvtepi64_epi32(_mm512_srl_epi64(hash,shift));
            __m512i row=_mm512_i32gather_epi64(index,lanes->bank[0],8);
            const __mmask8 missed=_mm512_test_epi64_mask(_mm512_xor_si512(row,hash),fragment);
            if(missed) {
                const __m512i other=_mm512_rol_epi64(hash,31);
                const __m256i where=_mm512_cvtepi64_epi32(_mm512_srl_epi64(other,shift));
                const __m512i next=_mm512_mask_i32gather_epi64(_mm512_setzero_si512(),missed,where,lanes->bank[1],8);
                const __mmask8 found=_mm512_mask_testn_epi64_mask(missed,_mm512_xor_si512(next,other),fragment);
                row=_mm512_mask_mov_epi64(row,missed,_mm512_maskz_mov_epi64(found,next));
            }
            const __m256i ids=_mm512_cvtepi64_epi32(_mm512_srl_epi64(row,shift));
            answers[i]=_mm256_i32gather_epi32((const int*)lanes->choices,ids,4);'''+s[b:]
(d/'tools/banks.c').write_text(s)
