from pathlib import Path
d=Path(__file__).resolve().parent
src=(d/'tools/single.c').read_text()
a=src.index('    for (uint32_t g = first;',src.index('void lanes_rows('));b=src.index('// X for roots',a)
body='''    for (uint32_t g=first;g<end;++g) {
        const uint64_t place=places[g], at=place>>32;
        const __m128i row=_mm_load_si128((const __m128i*)(rows+(uint32_t)place));
        _mm_storel_epi64((__m128i*)(out_kinds+at),row);
        _mm_storeh_pd((double*)(out_classes+at),_mm_castsi128_pd(row));
    }
    if(first==end) return;
    uint32_t start=first;
    uint32_t g=first;
    uint32_t previous_at=(uint32_t)(places[first]>>32);
    uint32_t previous_delta=payloads[first]-previous_at;
    __m512i prior=_mm512_set1_epi32((int)previous_delta);
    __m512i prior_at=_mm512_set1_epi32((int)previous_at);
    const __m512i high=_mm512_setr_epi32(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31);
    for(; end-g>=16; g+=16){
        const __m512i a=_mm512_loadu_si512(places+g),b=_mm512_loadu_si512(places+g+8);
        const __m512i at=_mm512_permutex2var_epi32(a,high,b);
        const __m512i delta=_mm512_sub_epi32(_mm512_loadu_si512(payloads+g),at);
        const __m512i jump=_mm512_sub_epi32(at,_mm512_alignr_epi32(at,prior_at,15));
        uint32_t changes=_mm512_cmpneq_epi32_mask(delta,_mm512_alignr_epi32(delta,prior,15)) |
            _mm512_cmpgt_epu32_mask(jump,_mm512_set1_epi32(4));
        for(;changes;changes &= changes-1) {
            uint32_t stop=g+(uint32_t)__builtin_ctz(changes);
            uint32_t lo=(uint32_t)(places[start]>>32),hi=(uint32_t)(places[stop-1]>>32);
            memcpy(out_values+lo,pool+payloads[start],((uint64_t)hi-lo+4)*8);
            start=stop;
        }
        prior=delta;prior_at=at;
    }
    if(g!=first){
        previous_at=(uint32_t)(places[g-1]>>32);
        previous_delta=payloads[g-1]-previous_at;
    }
    for(;g<end;++g){
        const uint32_t at=(uint32_t)(places[g]>>32),delta=payloads[g]-at;
        if (delta!=previous_delta || at-previous_at>4){
            const uint32_t lo=(uint32_t)(places[start]>>32);
            memcpy(out_values+lo,pool+payloads[start],((uint64_t)previous_at-lo+4)*8);
            start=g;
        }
        previous_at=at;previous_delta=delta;
    }
    const uint32_t lo=(uint32_t)(places[start]>>32);
    const uint32_t hi=(uint32_t)(places[end-1]>>32);
    memcpy(out_values+lo,pool+payloads[start],((uint64_t)hi-lo+4)*8);
}

'''
(d/'tools/runs.c').write_text(src[:a]+body+src[b:])
# In the other version coalesce only groups with one affine run. Fall back directly to ordinary ordered stores.
a=body.index('    uint32_t start=first;');b=body.index('\n}',a)
alt='''    const __m512i high=_mm512_setr_epi32(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31);
    uint32_t g=first;
    for(;end-g>=16;g+=16){
        const __m512i a=_mm512_loadu_si512(places+g),b=_mm512_loadu_si512(places+g+8);
        const __m512i at=_mm512_permutex2var_epi32(a,high,b);
        const __m512i delta=_mm512_sub_epi32(_mm512_loadu_si512(payloads+g),at);
        const __m512i jump=_mm512_sub_epi32(at,_mm512_alignr_epi32(at,at,15));
        if((_mm512_cmpneq_epi32_mask(delta,_mm512_alignr_epi32(delta,delta,15)) & 0xfffe)==0 &&
           (_mm512_cmpgt_epu32_mask(jump,_mm512_set1_epi32(4)) & 0xfffe)==0){
            uint32_t lo=(uint32_t)(places[g]>>32),hi=(uint32_t)(places[g+15]>>32);
            memcpy(out_values+lo,pool+payloads[g],((uint64_t)hi-lo+4)*8);
        } else {
            for(uint32_t i=0;i<16;++i)
                _mm256_storeu_si256((__m256i*)(out_values+(places[g+i]>>32)),_mm256_loadu_si256((const __m256i*)(pool+payloads[g+i])));
        }
    }
    for(;g<end;++g)
        _mm256_storeu_si256((__m256i*)(out_values+(places[g]>>32)),_mm256_loadu_si256((const __m256i*)(pool+payloads[g])));'''
a0=src.index('    for (uint32_t g = first;',src.index('void lanes_rows('));b0=src.index('// X for roots',a0)
(d/'tools/runblock.c').write_text(src[:a0]+body[:a]+alt+body[b:]+src[b0:])
