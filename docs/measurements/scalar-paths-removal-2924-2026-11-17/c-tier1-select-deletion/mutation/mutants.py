# Mutants for #2924 C7b, the selection: each breaks vector code that stays (the BURS kernels, the barrier scan, the
# ranges', storage's and known bits' scans, the symbol scan). The twin-free tests (test-tier1-select with its frozen plan
# digest, test-tier1-emit, test-tier1-masks) must fail each, on the tests commit's tree and on the deletion's.
B = 'src/buster/compiler/tier1_select_burs.c'
S = 'src/buster/compiler/tier1_select.c'
R = 'src/buster/compiler/tier1_select_ranges.c'
T = 'src/buster/compiler/tier1_select_storage.c'
MUTANTS = [
    ('b1-label-lane-15-right-absent', B,
     'const __mmask16 right_visible = _mm512_mask_cmpneq_epi32_mask(active, right_kid, none);',
     'const __mmask16 right_visible = _mm512_mask_cmpneq_epi32_mask(active & 0x7fff, right_kid, none);'),
    ('b2-label-row-from-right', B,
     'const __m512i row = tier1_burs_gather_pool(active, _mm512_add_epi32(left_map, left));',
     'const __m512i row = tier1_burs_gather_pool(active, _mm512_add_epi32(left_map, right));'),
    ('b3-rules-goal-low-bit', B,
     'const __m512i index = _mm512_add_epi32(_mm512_mullo_epi32(state, _mm512_set1_epi32(TIER1_BURS_NONTERMINALS)), goal);',
     'const __m512i index = _mm512_add_epi32(_mm512_mullo_epi32(state, _mm512_set1_epi32(TIER1_BURS_NONTERMINALS)), _mm512_and_si512(goal, _mm512_set1_epi32(1)));'),
    ('b4-classify-link-low-lanes', B,
     'result = _mm512_mask_mov_epi32(result, link, _mm512_set1_epi32(TIER1_BURS_OP_ICMP_LINK));',
     'result = _mm512_mask_mov_epi32(result, link & (__mmask16)0x00ff, _mm512_set1_epi32(TIER1_BURS_OP_ICMP_LINK));'),
    ('s1-barriers-fence-not', S,
     '_mm512_cmpeq_epi32_mask(op, _mm512_set1_epi32(IR_FENCE))',
     '_mm512_cmpeq_epi32_mask(op, _mm512_set1_epi32(IR_RET))'),
    ('s2-barriers-last-lane', S,
     'const __m512i lanes = _mm512_setr_epi32(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);',
     'const __m512i lanes = _mm512_setr_epi32(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 15);'),
    ('s3-known-bits-i16-15', S,
     'bits = _mm512_mask_mov_epi16(bits, _mm512_cmpeq_epi16_mask(type, _mm512_set1_epi16(IR_I16)), _mm512_set1_epi16(16));',
     'bits = _mm512_mask_mov_epi16(bits, _mm512_cmpeq_epi16_mask(type, _mm512_set1_epi16(IR_I16)), _mm512_set1_epi16(15));'),
    ('s4-symbol-firsts-skip-first', S,
     'for (uint64_t mask = tier1_select_leaves_mask(function, first, count); mask != 0; mask &= mask - 1)',
     'for (uint64_t mask = tier1_select_leaves_mask(function, first, count) & ~UINT64_C(1); mask != 0; mask &= mask - 1)'),
    ('r1-ranges-sext-of-i32', R,
     'uint32_t uses = active & _mm256_cmpeq_epi8_mask(op, _mm256_set1_epi8(IR_SEXT)) & _mm256_cmpeq_epi8_mask(type, _mm256_set1_epi8(IR_I64));',
     'uint32_t uses = active & _mm256_cmpeq_epi8_mask(op, _mm256_set1_epi8(IR_SEXT)) & _mm256_cmpeq_epi8_mask(type, _mm256_set1_epi8(IR_I32));'),
    ('t1-storage-wide-i16', T,
     'const __mmask16 wide = active & _mm_cmpeq_epi8_mask(types, _mm_set1_epi8(IR_I32)) & _mm_cmpeq_epi8_mask(facts, _mm_set1_epi8(BUSTER_TIER1_STORAGE_SIGN));',
     'const __mmask16 wide = active & _mm_cmpeq_epi8_mask(types, _mm_set1_epi8(IR_I16)) & _mm_cmpeq_epi8_mask(facts, _mm_set1_epi8(BUSTER_TIER1_STORAGE_SIGN));'),
]
