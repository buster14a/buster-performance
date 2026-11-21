from pathlib import Path
d=Path(__file__).resolve().parent;s=(d/'tools/packedkey.c').read_text()
s=s.replace('    uint32_t scratch_origin;', '''    __m512i* key_blocks;
    uint64_t* key_invalid;
    uint32_t key_stride;
    uint32_t scratch_origin;''')
s=s.replace('    lanes->gaps = lanes_column', '''    lanes->key_stride=(uint32_t)((scratch+127)/64);
    lanes->key_blocks=must(aligned_alloc(64,(uint64_t)lanes->key_stride*8*sizeof(__m512i)));
    lanes->key_invalid=must(calloc(lanes->key_stride,sizeof(uint64_t)));
    lanes->gaps = lanes_column''')
a=s.index('        __m512i v[16];',s.index('static __attribute__((noinline)) void lanes_keys'));b=s.index('        for(unsigned j=0;j<4;++j){',a)
g=s[s.index('        const __m512i bad=',a):b]
s=s[:a]+'''        const uint32_t at=(uint32_t)((base-lanes->scratch_origin)/64);
        __m512i p[8],w[8],d[8],q[8];
        for(unsigned j=0;j<8;++j) p[j]=lanes->key_blocks[at*8+j];
        const __m512i ctx=_mm512_load_si512(lanes->context_dense+base);
        const __m512i tc=_mm512_load_si512(lanes->target_class+base);
        const __m512i tf=_mm512_load_si512(lanes->target_facts+base);
        const __m512i bad=_mm512_or_si512(_mm512_and_si512(ctx,_mm512_set1_epi8((char)0xf8)),_mm512_and_si512(_mm512_or_si512(tc,tf),_mm512_set1_epi8((char)0xf0)));
        const __mmask64 bad_lanes=lanes->key_invalid[at]|_mm512_test_epi8_mask(bad,bad);
        p[1]=_mm512_or_si512(p[1],tc);
        p[3]=_mm512_or_si512(p[3],tf);
        p[5]=_mm512_or_si512(p[5],_mm512_and_si512(_mm512_slli_epi16(ctx,5),_mm512_set1_epi8((char)0xe0)));
'''+s[b:]
a=s.index("        // A store's destination's kind",s.index('static __attribute__((noinline)) void lanes_types'))
s=s[:a]+'''        __m512i v[16],p[8];
        const __m512i op=operators;
        v[0]=v[1]=v[2]=_mm512_setzero_si512();
        v[4]=_mm512_load_si512(lanes->counts_whole+base);
        for(unsigned j=0;j<7;++j) v[9+j]=facts[j];
'''+s[a:]
s=s.replace('_mm512_store_si512(lanes->store + base, _mm512_maskz_mov_epi8(stores, store));','v[3]=_mm512_maskz_mov_epi8(stores,store);').replace('_mm512_store_si512(lanes->types[2 * k + f] + base, _mm512_maskz_mov_epi8(with_operands, type));','v[5+2*k+f]=_mm512_maskz_mov_epi8(with_operands,type);')
a=s.index('    }\n    lanes->type_rounds += rounds;')
s=s[:a]+g+'''        const uint32_t at=(uint32_t)((base-lanes->scratch_origin)/64);
        lanes->key_invalid[at]=bad_lanes;
        for(unsigned j=0;j<8;++j) lanes->key_blocks[at*8+j]=p[j];
'''+s[a:]
(d/'tools/produced.c').write_text(s)
s=s.replace('[at*8+j]','[(uint64_t)j*lanes->key_stride+at]')
(d/'tools/producedcols.c').write_text(s)
