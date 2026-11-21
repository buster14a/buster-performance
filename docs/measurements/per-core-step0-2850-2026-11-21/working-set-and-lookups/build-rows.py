from pathlib import Path
d=Path(__file__).resolve().parent
for base in ['scratchfargather']:
 s=(d/'tools'/f'{base}.c').read_text()
 a=s.index('// X for roots [first_root, end_root)')
 s=s[:a]+'''// A full group with at most four consecutive entries per record can write both byte
// columns by compressing the template words. Fall back to the normal rows when a
// gap or long run interrupts the group. The payload stream is copied as one run
// only if every live record has the same mapping from source to output entry.
static void compact_rows(const uint64_t* places, const uint32_t* payloads, const uint32_t* chosen, const uint8_t* gaps,
                         const uint8_t* rows, const uint64_t* pool, uint8_t* kinds, uint8_t* classes, uint64_t* values,
                         uint32_t first, uint32_t end)
{
    uint32_t g=first;
    uint32_t aligned=(first+15u)&~15u;
    aligned=aligned<end ? aligned : end;
    lanes_rows(places,payloads,rows,pool,kinds,classes,values,g,aligned);
    g=aligned;
    for (; end-g>=16;g+=16) {
        const __m512i ch=_mm512_load_si512(chosen+g);
        const __m512i counts=_mm512_and_si512(_mm512_srli_epi32(ch,24),_mm512_set1_epi32(31));
        const __m128i gap=_mm_load_si128((const __m128i*)(gaps+g));
        if (_mm512_cmpgt_epu32_mask(counts,_mm512_set1_epi32(4)) || _mm_test_epi8_mask(gap,gap)) {
            lanes_rows(places,payloads,rows,pool,kinds,classes,values,g,g+16);
            continue;
        }
        const __mmask16 live=_mm512_test_epi32_mask(counts,counts);
        if (live==0) continue;
        const __m512i a=_mm512_load_si512(places+g), b=_mm512_load_si512(places+g+8);
        const __m512i indices=_mm512_permutex2var_epi32(a,_mm512_setr_epi32(0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30),b);
        const __m512i out=_mm512_permutex2var_epi32(a,_mm512_setr_epi32(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31),b);
        const __m512i sizes=_mm512_mullo_epi32(counts,_mm512_set1_epi32(0x01010101));
        const __mmask64 entries=_mm512_cmpgt_epu8_mask(sizes,_mm512_set1_epi32(0x03020100));
        const uint32_t at=(uint32_t)(places[g]>>32);
        const __m512i k=_mm512_i32gather_epi32(indices, rows, 1);
        const __m512i c=_mm512_i32gather_epi32(indices, rows+8, 1);
        _mm512_storeu_si512(kinds+at,_mm512_maskz_compress_epi8(entries,k));
        _mm512_storeu_si512(classes+at,_mm512_maskz_compress_epi8(entries,c));
        const __m512i src=_mm512_loadu_si512(payloads+g);
        const __m512i diff=_mm512_sub_epi32(src,out);
        const uint32_t lane=(uint32_t)__builtin_ctz((unsigned)live);
        const uint32_t offset=payloads[g+lane]-(uint32_t)(places[g+lane]>>32);
        if (!_mm512_mask_cmpneq_epi32_mask(live,diff,_mm512_set1_epi32((int)offset))) {
            const uint32_t length=(uint32_t)__builtin_popcountll(entries);
            memcpy(values+at,pool+(uint32_t)(at+offset),(size_t)length*sizeof(*values));
        } else {
            for (uint32_t i=0;i<16;++i)
                _mm256_storeu_si256((__m256i*)(values+(places[g+i]>>32)), _mm256_loadu_si256((const __m256i*)(pool+payloads[g+i])));
        }
    }
    lanes_rows(places,payloads,rows,pool,kinds,classes,values,g,end);
}
'''+s[a:]
 # Per-record kind/class overstores in the next scalar group are in increasing order.
 # Prefix allocations include gaps even for a zero row; the new group tests gaps before bulk copying.
 s=s.replace('lanes_rows(places, unit->payload + origin, lanes->rows,', 'compact_rows(places, unit->payload + origin, chosen, gaps, lanes->rows,')
 (d/'tools/compactrows.c').write_text(s)
