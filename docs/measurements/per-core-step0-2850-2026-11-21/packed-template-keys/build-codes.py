from pathlib import Path
d=Path(__file__).resolve().parent
s=(d/'tools/single.c').read_text()
s=s.replace('    uint32_t template_bits;', '    uint32_t template_bits;\n    uint8_t flags_of_code[64] __attribute__((aligned(64)));')
s=s.replace('    uint32_t bits=14;\n    if (bits<7+tbits) bits=7+tbits;', '''    uint8_t codes[128], groups=0;
    memset(codes,255,sizeof(codes)); codes[LANES_CHOSEN_MISSED>>24]=groups++;
    l->flags_of_code[0]=LANES_CHOSEN_MISSED>>24;
    for(uint32_t t=0;t<unit->template_count;++t) {
        uint8_t flags=unit->templates[t].total | (unit->templates[t].early ? 32 : 0);
        if(codes[flags]==255) {
            if(groups==64) abort();
            codes[flags]=groups; l->flags_of_code[groups++]=flags;
        }
    }
    uint32_t bits=13;
    for(uint32_t gbits=0;;++gbits) if ((1u<<gbits)>=groups) {
        if(bits<tbits+gbits) bits=tbits+gbits;
        break;
    }''')
s=s.replace('((values[i]>>24)<<tbits)','((uint32_t)codes[values[i]>>24]<<tbits)')
a='const __m256i flags=_mm256_slli_epi32(_mm256_srl_epi32(code,_mm_cvtsi32_si128(lanes->template_bits)),24);'
b='''const __m256i groups=_mm256_srl_epi32(code,_mm_cvtsi32_si128(lanes->template_bits));
            const __m512i flags8=_mm512_permutexvar_epi8(_mm512_castsi256_si512(groups),_mm512_load_si512(lanes->flags_of_code));
            const __m256i flags=_mm256_slli_epi32(_mm512_castsi512_si256(flags8),24);'''
assert a in s;s=s.replace(a,b);(d/'tools/codes.c').write_text(s)
s=s.replace('return (h&~mask)|((h*multiplier)&mask);','return (h&~mask)|((h^(h<<(multiplier&63)))&mask);').replace('for(;factor<256;factor+=2)','for(;factor<64;++factor)').replace('if(factor==257)','if(factor==64)').replace('_mm512_mullo_epi64(hash,mult)','_mm512_xor_si512(hash,_mm512_sllv_epi64(hash,mult))')
(d/'tools/codebits.c').write_text(s)
