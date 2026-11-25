import sys
p = sys.argv[1] + '/src/buster/compiler/c_direct_lex.c'
s = open(p).read()
def rep(old, new):
    global s
    assert s.count(old) == 1, old[:60]
    s = s.replace(old, new)
rep('''    uint32_t open_start = 0;     // ... and its first byte's offset
''', '''    uint32_t open_start = 0;     // ... and its first byte's offset
#ifdef CEIL
    __m512i sink = _mm512_setzero_si512();
    uint64_t ssink = 0;
#endif
''')
rep('''        const __m512i v = _mm512_loadu_si512((const void*)p);
        const __m512i v1 = _mm512_loadu_si512((const void*)(p + 1));''', '''        const __m512i v = _mm512_loadu_si512((const void*)p);
#if CEIL == 3 || CEIL == 4
        {
#if CEIL == 3
            const __m512i classes3 = _mm512_permutex2var_epi8(v_class_lo, v, v_class_hi);
            const __mmask64 special3 = _mm512_test_epi8_mask(classes3, v_special_bits) | _mm512_movepi8_mask(v);
            const __mmask64 space3 = _mm512_test_epi8_mask(classes3, v_space_bit);
            const uint32_t m3 = (uint32_t)__builtin_popcountll(~space3 & (space3 << 1));
            sink = _mm512_xor_si512(sink, classes3);
            ssink += special3;
#else
            const uint32_t m3 = 9u;
            _mm512_storeu_si512((void*)(wk + n), v);
            _mm512_storeu_si512((void*)(wl + n), v);
            _mm512_storeu_si512((void*)(ws + n), v);
            _mm512_storeu_si512((void*)(ws + n + 16u), v);
#endif
            n += m3;
            p += 64;
            continue;
        }
#endif
        const __m512i v1 = _mm512_loadu_si512((const void*)(p + 1));''')
rep('''        _mm512_storeu_si512((void*)(wk + n), comp_kinds);
        _mm512_storeu_si512((void*)(wl + n), _mm512_sub_epi8(_mm512_maskz_expand_epi8(run_lanes, comp_ends), comp_pos));
        const __m512i v_offset = _mm512_set1_epi32((int32_t)block_offset);
        _mm512_storeu_si512((void*)(ws + n), _mm512_add_epi32(v_offset, _mm512_cvtepu8_epi32(_mm512_castsi512_si128(comp_pos))));
        _mm512_storeu_si512((void*)(ws + n + 16u), _mm512_add_epi32(v_offset, _mm512_cvtepu8_epi32(_mm512_extracti32x4_epi32(comp_pos, 1))));
        if (__builtin_expect(m_count > 32u, 0))
        {''', '''#if CEIL == 2
        (void)comp_kinds; (void)comp_ends; (void)run_lanes;
        ssink += tok_starts ^ paired_ends ^ pairs;
#elif CEIL == 1
        {
            const __m512i v_offset = _mm512_set1_epi32((int32_t)block_offset);
            sink = _mm512_xor_si512(sink, comp_kinds);
            sink = _mm512_xor_si512(sink, _mm512_sub_epi8(_mm512_maskz_expand_epi8(run_lanes, comp_ends), comp_pos));
            sink = _mm512_xor_si512(sink, _mm512_add_epi32(v_offset, _mm512_cvtepu8_epi32(_mm512_castsi512_si128(comp_pos))));
            sink = _mm512_xor_si512(sink, _mm512_add_epi32(v_offset, _mm512_cvtepu8_epi32(_mm512_extracti32x4_epi32(comp_pos, 1))));
        }
#else
        _mm512_storeu_si512((void*)(wk + n), comp_kinds);
        _mm512_storeu_si512((void*)(wl + n), _mm512_sub_epi8(_mm512_maskz_expand_epi8(run_lanes, comp_ends), comp_pos));
        const __m512i v_offset = _mm512_set1_epi32((int32_t)block_offset);
        _mm512_storeu_si512((void*)(ws + n), _mm512_add_epi32(v_offset, _mm512_cvtepu8_epi32(_mm512_castsi512_si128(comp_pos))));
        _mm512_storeu_si512((void*)(ws + n + 16u), _mm512_add_epi32(v_offset, _mm512_cvtepu8_epi32(_mm512_extracti32x4_epi32(comp_pos, 1))));
#endif
#if CEIL_STORES
        if (__builtin_expect(m_count > 32u, 0))
        {''')
rep('''_mm512_extracti32x4_epi32(comp_pos, 3))));
        }
''', '''_mm512_extracti32x4_epi32(comp_pos, 3))));
        }
#endif
''')
rep('''        if (__builtin_expect(scalars != 0, 0))
        {
            uint64_t rest = scalars;''', '''        if (__builtin_expect(scalars != 0, 0) && CEIL_STORES)
        {
            uint64_t rest = scalars;''')
rep('''        wl[carried_idx] = (uint8_t)carried_len;
        wk[run_carry != 0 && carried_len > 255u ? open_idx : spare] = BUSTER_FWIN_SCALAR;''', '''#if CEIL_STORES
        wl[carried_idx] = (uint8_t)carried_len;
        wk[run_carry != 0 && carried_len > 255u ? open_idx : spare] = BUSTER_FWIN_SCALAR;
#else
        ssink += carried_idx + carried_len;
#endif''')
rep('''    w->count = n;
    w->pos = 0;
    w->serial = f->serial;''', '''#ifdef CEIL
    w->kinds[2100] = (uint8_t)(_mm512_reduce_add_epi32(sink) + ssink);
#endif
    w->count = n;
    w->pos = 0;
    w->serial = f->serial;''')
rep('''static BUSTER_DIRECT_HOT void fast_pp_lex_window(''', '''#ifndef CEIL
#define CEIL_STORES 1
#elif CEIL == 1 || CEIL == 2
#define CEIL_STORES 0
#else
#define CEIL_STORES 1
#endif
static BUSTER_DIRECT_HOT void fast_pp_lex_window(''')
open(p, 'w').write(s)
