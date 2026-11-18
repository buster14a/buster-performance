# #2924 C9d: mutants of the unroller's and the loop vectorizer's scans whose scalar twins C9d deletes, each (name, file,
# old, new): a unique text replaced by another unique one, every identifier kept.
U = 'src/buster/compiler/ir_optimize_unroll.c'
V = 'src/buster/compiler/ir_vectorize_loops.c'
MUTANTS = [
    # The unroller: the classes' last lane and phi test, the union's last lane and its reduction, the remap's optional
    # operands, last lane and c column.
    ('u1-classes-tail', U, 'const __mmask64 valid = UINT64_MAX >> (BUSTER_IR_UNROLL_BATCH - lanes);', 'const __mmask64 valid = UINT64_MAX >> (BUSTER_IR_UNROLL_BATCH - lanes + 1);'),
    ('u2-classes-phi', U, 'found |= _mm512_test_epi8_mask(looked, _mm512_set1_epi8(BUSTER_IR_UNROLL_PHI));', 'found |= _mm512_test_epi8_mask(looked, _mm512_set1_epi8(BUSTER_IR_UNROLL_PHI)) & 0;'),
    ('u3-union-tail', U, '_mm512_maskz_loadu_epi8(UINT64_MAX >> (BUSTER_IR_UNROLL_BATCH - lanes), classes + at)', '_mm512_maskz_loadu_epi8(UINT64_MAX >> (BUSTER_IR_UNROLL_BATCH - lanes + 1), classes + at)'),
    ('u4-union-reduce', U, '    word |= word >> 8;\n', '    word |= word >> 24;\n'),
    ('u5-remap-optional', U, '(_mm512_test_epi32_mask(optional, two) & _mm512_cmpneq_epi32_mask(b, none))', '(_mm512_test_epi32_mask(optional, two) & _mm512_cmpneq_epi32_mask(b, none) & 0)'),
    ('u6-remap-tail', U, 'const __mmask16 active = (__mmask16)((1u << lanes) - 1u);', 'const __mmask16 active = (__mmask16)(((1u << lanes) - 1u) >> 1);'),
    ('u7-remap-column', U, '_mm512_mask_i32gather_epi32(c, use_c, c, map, 4)', '_mm512_mask_i32gather_epi32(c, use_c, b, map, 4)'),
    # The vectorizer: the kinds' flags' last lane, the access flags, the stores among the memory kinds; the refusing
    # kinds' scan's kind bits and last lane.
    ('k1-kinds-flags-tail', V, 'const __m512i flags = _mm512_maskz_loadu_epi8(valid, f->flags + first);', 'const __m512i flags = _mm512_maskz_loadu_epi8(valid >> 1, f->flags + first);'),
    ('k2-kinds-access-flags', V, '_mm512_test_epi8_mask(flags, _mm512_set1_epi8(BUSTER_IR_ACCESS_FLAGS));', '_mm512_test_epi8_mask(flags, _mm512_set1_epi8(BUSTER_IR_VOLATILE));'),
    ('k3-kinds-stores', V, '| _mm512_cmpeq_epi8_mask(base, _mm512_set1_epi8(BUSTER_IR_VECTORIZE_KIND_STORE));', '| (_mm512_cmpeq_epi8_mask(base, _mm512_set1_epi8(BUSTER_IR_VECTORIZE_KIND_STORE)) & 0);'),
    ('f1-forbidden-bits', V, '_mm512_cmpeq_epi8_mask(_mm512_and_si512(kind, _mm512_set1_epi8(7)), _mm512_setzero_si512())', '_mm512_cmpeq_epi8_mask(_mm512_and_si512(kind, _mm512_set1_epi8(3)), _mm512_setzero_si512())'),
    ('f2-forbidden-tail', V, 'const __m512i kind = _mm512_maskz_loadu_epi8(valid, kinds + at);', 'const __m512i kind = _mm512_maskz_loadu_epi8(valid >> 1, kinds + at);'),
]
