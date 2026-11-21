from pathlib import Path
d=Path(__file__).resolve().parent
s=(d/'tools/flat.c').read_text()
a=s.index('        uint64_t* hashes = lanes->hashes + base;',s.index('void lanes_keys('))
s=s[:a]+s[a:].replace('        uint64_t* hashes = lanes->hashes + base;','        __m256i answers[8];',1)
a=s.index('            _mm512_store_si512(hashes + 8 * i,');b=s.index('\n    }',a)
s=s[:a]+'''            hash = _mm512_or_si512(_mm512_mullo_epi64(hash, multiplier_first), low_bit);
            const __m256i bucket = _mm512_cvtepi64_epi32(_mm512_srl_epi64(hash, _mm_cvtsi32_si128(lanes->slot_shift)));
            const __m256i offsets = _mm256_i32gather_epi32((const int*)lanes->offsets, bucket, 4);
            const __m256i middle = _mm512_cvtepi64_epi32(_mm512_srli_epi64(hash, 17));
            const __m256i index = _mm256_and_si256(_mm256_add_epi32(middle, offsets), _mm256_set1_epi32(lanes->lookup_mask));
            const __m512i checked = _mm512_i32gather_epi64(index, lanes->lookup_keys, 8);
            const __mmask8 hit = _mm512_cmpeq_epi64_mask(checked,hash);
            const __m256i values = _mm256_i32gather_epi32((const int*)lanes->lookup_values, index, 4);
            answers[i] = _mm256_mask_mov_epi32(_mm256_set1_epi32(LANES_CHOSEN_MISSED), hit, values);
        }
        __m512i paired[4];
        for (uint32_t i=0; i<4; ++i)
            paired[i]=_mm512_inserti64x4(_mm512_castsi256_si512(answers[i]), answers[i+4], 1);
        const __m512i l01=_mm512_unpacklo_epi64(paired[0],paired[1]);
        const __m512i h01=_mm512_unpackhi_epi64(paired[0],paired[1]);
        const __m512i l23=_mm512_unpacklo_epi64(paired[2],paired[3]);
        const __m512i h23=_mm512_unpackhi_epi64(paired[2],paired[3]);
        const __m512i low=_mm512_setr_epi64(0,1,8,9,4,5,12,13);
        const __m512i high=_mm512_setr_epi64(2,3,10,11,6,7,14,15);
        _mm512_store_si512(lanes->chosen+base, _mm512_permutex2var_epi64(l01,low,l23));
        _mm512_store_si512(lanes->chosen+base+16, _mm512_permutex2var_epi64(h01,low,h23));
        _mm512_store_si512(lanes->chosen+base+32, _mm512_permutex2var_epi64(l01,high,l23));
        _mm512_store_si512(lanes->chosen+base+48, _mm512_permutex2var_epi64(h01,high,h23));'''+s[b:]
s=s.replace('            lanes_choose(lanes, first_block, end_block);','            // Selection is fused with hash construction.')
(d/'tools/gather.c').write_text(s)
