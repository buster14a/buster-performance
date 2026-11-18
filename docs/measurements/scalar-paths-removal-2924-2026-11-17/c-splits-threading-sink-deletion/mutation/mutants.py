# #2924 C9c: mutants of the scans whose scalar twins C9c deletes, each (name, file, old, new): a unique text replaced
# by another unique one, every identifier kept.
T = 'src/buster/compiler/ir_thread.c'
I = 'src/buster/compiler/ir_if_convert.c'
R = 'src/buster/compiler/ir_truth.c'
S = 'src/buster/compiler/tier1_schedule_ir.c'
W = 'src/buster/compiler/ir_wide.c'
V = 'src/buster/compiler/ir_vector_split.c'
MUTANTS = [
    # Threading: the conditional branches' last lane; the escapes' optional operands, their other-block test, the
    # extra operands' intrinsics, and a batch's last lane.
    ('t1-candidates-tail', T, 'UINT64_MAX >> (BUSTER_IR_THREAD_BATCH - count);', 'UINT64_MAX >> (BUSTER_IR_THREAD_BATCH - count + 1);'),
    ('t2-escapes-optional', T, 'const __mmask16 used = valid & (_mm512_test_epi32_mask(fixed, bit) | (_mm512_test_epi32_mask(optional, bit) & present));', 'const __mmask16 used = valid & (_mm512_test_epi32_mask(fixed, bit) | (_mm512_test_epi32_mask(optional, bit) & present & (__mmask16)0));'),
    ('t3-escapes-same-block', T, '_mm512_mask_cmpneq_epi32_mask(used, defined, own)', '_mm512_mask_cmpeq_epi32_mask(used, defined, own)'),
    ('t4-escapes-intrinsic', T, '_mm_mask_cmpeq_epi8_mask(valid, op, _mm_set1_epi8(IR_INTRINSIC)) |', '(_mm_mask_cmpeq_epi8_mask(valid, op, _mm_set1_epi8(IR_INTRINSIC)) & 0) |'),
    ('t6-escapes-scatter', T, '_mm_mask_cmpeq_epi8_mask(valid, op, _mm_set1_epi8(IR_SCATTER));', '(_mm_mask_cmpeq_epi8_mask(valid, op, _mm_set1_epi8(IR_SCATTER)) & 0);'),
    ('t5-escapes-tail', T, 'const __mmask16 valid = (__mmask16)((UINT32_C(1) << lanes) - 1);', 'const __mmask16 valid = (__mmask16)(((UINT32_C(1) << lanes) - 1) >> 1);'),
    # If-conversion: the conditional branches' last lane; the barriers' observable loads and batch start; the keys'
    # filter's b column; the narrowing casts' operation and last lane.
    ('i1-candidates-tail', I, 'UINT64_MAX >> (BUSTER_IR_IF_CONVERT_BATCH - count);', 'UINT64_MAX >> (BUSTER_IR_IF_CONVERT_BATCH - count + 1);'),
    ('i2-barrier-observable', I, 'hits |= _mm512_mask_cmpeq_epi8_mask(valid, op, _mm512_set1_epi8(IR_LOAD))', 'hits |= _mm512_mask_cmpeq_epi8_mask(valid, op, _mm512_set1_epi8(IR_STORE))'),
    ('i3-barrier-row', I, 'found = hits != 0 ? start + 63 - (uint32_t)__builtin_clzll(hits)', 'found = hits != 0 ? start + 62 - (uint32_t)__builtin_clzll(hits)'),
    ('i4-filter-b', I, '_mm512_maskz_loadu_epi32(valid, f->b + first), _mm512_set1_epi32((int)key.b)', '_mm512_maskz_loadu_epi32(valid, f->c + first), _mm512_set1_epi32((int)key.b)'),
    ('i5-casts-operation', I, 'return valid & _mm512_cmpeq_epi8_mask(op, _mm512_set1_epi8(IR_TRUNC));', 'return valid & _mm512_cmpeq_epi8_mask(op, _mm512_set1_epi8(IR_ZEXT));'),
    ('i6-casts-tail', I, 'UINT64_MAX >> (BUSTER_IR_IF_CONVERT_BATCH - lanes);', 'UINT64_MAX >> (BUSTER_IR_IF_CONVERT_BATCH - lanes + 1);'),
    # Truth simplification: the comparisons' type and last lane.
    ('r1-truth-type', R, '_mm512_cmpeq_epi8_mask(type, _mm512_set1_epi8(IR_I1));', '_mm512_cmpeq_epi8_mask(type, _mm512_set1_epi8(IR_I8));'),
    ('r2-truth-tail', R, 'UINT64_MAX >> (BUSTER_IR_TRUTH_BATCH - lanes);', 'UINT64_MAX >> (BUSTER_IR_TRUTH_BATCH - lanes + 1);'),
    # The operand sink: the classification's observable loads, terminators and last lane; the readers' optional operands.
    ('s1-classify-observable', S, 'const __mmask64 observable = _mm512_cmpeq_epi8_mask(op, _mm512_set1_epi8(IR_LOAD))', 'const __mmask64 observable = _mm512_cmpeq_epi8_mask(op, _mm512_set1_epi8(IR_STORE))'),
    ('s2-classify-terminators', S, '| _mm512_test_epi8_mask(terminators, terminators) |', '| (_mm512_test_epi8_mask(terminators, terminators) & 0) |'),
    ('s3-readers-optional', S, 'const __mmask16 live = valid & (_mm512_test_epi32_mask(fixed, bit) | _mm512_test_epi32_mask(optional, bit));', 'const __mmask16 live = valid & (_mm512_test_epi32_mask(fixed, bit) | (_mm512_test_epi32_mask(optional, bit) & 0));'),
    ('s4-classify-tail', S, 'const __mmask64 valid = UINT64_MAX >> (64 - lanes);\n        const __m512i op = _mm512_maskz_loadu_epi8(valid, f->op + first);\n        const __m512i type', 'const __mmask64 valid = UINT64_MAX >> (65 - lanes);\n        const __m512i op = _mm512_maskz_loadu_epi8(valid, f->op + first);\n        const __m512i type'),
    # The splits' scans: the wide one's tail, the vector one's upper bound.
    ('w1-wide-tail', W, '(UINT64_C(1) << count) - 1;\n        const __m512i types', '(UINT64_C(1) << count) - 2;\n        const __m512i types'),
    ('v1-vector-bound', V, '_mm512_set1_epi8(IR_V16I32 + 1)) != 0;', '_mm512_set1_epi8(IR_V16I32)) != 0;'),
]
