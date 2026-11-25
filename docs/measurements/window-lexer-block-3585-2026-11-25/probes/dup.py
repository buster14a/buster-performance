import sys
p = sys.argv[1] + '/src/buster/compiler/c_direct_lex.c'
s = open(p).read()
def rep(old, new):
    global s
    assert s.count(old) == 1, old[:60]
    s = s.replace(old, new)
rep('''        const __m512i v = _mm512_loadu_si512((const void*)(base + off));
        const __m512i v1 = _mm512_loadu_si512((const void*)(base + off + 1u));''', '''        const __m512i v = _mm512_loadu_si512((const void*)(base + off));
        const __m512i v1 = _mm512_loadu_si512((const void*)(base + off + 1u));
        {
            __m512i d = v, d1 = v1;
            __asm__("" : "+v"(d), "+v"(d1));
            const __m512i k2 = _mm512_permutex2var_epi8(v_lut_lo, d, v_lut_hi);
            const __m512i c2 = _mm512_permutex2var_epi8(v_class_lo, d, v_class_hi);
            const __m512i n2 = _mm512_maskz_permutex2var_epi8(_mm512_testn_epi8_mask(d1, v_sign_bit), v_next_lo, d1, v_next_hi);
            const __m512i pk2 = _mm512_permutex2var_epi8(v_pair_lo, _mm512_ternarylogic_epi32(_mm512_permutex2var_epi8(v_first_lo, d, v_first_hi), n2, v_second_bits, 0xf8), v_pair_hi);
            uint64_t sp2 = _mm512_test_epi8_mask(c2, v_special_bits) | _mm512_movepi8_mask(d);
            const uint64_t lm2 = _bzhi_u64(~UINT64_C(0), (uint32_t)_tzcnt_u64(sp2));
            const uint64_t so2 = _mm512_testn_epi8_mask(c2, v_space_bit) & lm2;
            const uint64_t r2 = _mm512_test_epi8_mask(c2, v_run_bit) & lm2;
            const uint64_t rg2 = r2 & _mm512_test_epi8_mask(n2, v_run_bit);
            const uint64_t ca2 = _mm512_test_epi8_mask(pk2, pk2) & lm2;
            const uint64_t ts2 = so2 & ~((r2 & ((r2 << 1) | run_carry)) | (ca2 << 1));
            const uint64_t te2 = so2 & ~(rg2 | ca2);
            const uint64_t oe2 = te2 & (te2 - run_carry);
            const __m512i ck2 = _mm512_maskz_compress_epi8(ts2, _mm512_mask_blend_epi8(ca2, k2, pk2));
            const __m512i cp2 = _mm512_maskz_compress_epi8(ts2, v_iota);
            const __m512i ce2 = _mm512_maskz_compress_epi8(oe2, v_iota1);
            dup_sink = _mm512_xor_si512(dup_sink, _mm512_add_epi8(ck2, _mm512_sub_epi8(ce2, cp2)));
            dup_sink = _mm512_add_epi32(dup_sink, _mm512_cvtepu8_epi32(_mm512_castsi512_si128(cp2)));
            dup_count += __builtin_popcountll(ts2) + _mm512_test_epi8_mask(_mm512_and_si512(c2, n2), v_dot_bit);
        }''')
rep('''    uint64_t open_start = 0;     // the first byte's offset of the last run that started
''', '''    uint64_t open_start = 0;     // the first byte's offset of the last run that started
    __m512i dup_sink = _mm512_setzero_si512();
    uint64_t dup_count = 0;
''')
rep('''    w->count = n;
    w->pos = 0;''', '''    w->generation += (uint32_t)(_mm512_reduce_add_epi32(dup_sink) + dup_count) & 0x10000000u;
    w->count = n;
    w->pos = 0;''')
open(p, 'w').write(s)
