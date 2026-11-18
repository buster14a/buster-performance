# #2924 C9e: mutants of the inliner's paths whose scalar twins C9e deletes, each (name, file, old, new): a unique text
# replaced by another unique one, every identifier kept.
I = 'src/buster/compiler/ir_optimize_inline.c'
D = 'src/buster/compiler/c_check_tier1_inline.c'
MUTANTS = [
    # The cost sweeps: the threshold's equality, the limits' equality and last lane.
    ('t1-threshold-equal', I, '_mm512_cmple_epu32_mask(values, _mm512_set1_epi32((int32_t)maximum))', '_mm512_cmplt_epu32_mask(values, _mm512_set1_epi32((int32_t)maximum))'),
    ('t2-limits-equal', I, '_mm512_cmple_epu32_mask(values, limits)', '_mm512_cmplt_epu32_mask(values, limits)'),
    ('t3-limits-tail', I, 'const __m512i limits = _mm512_maskz_loadu_epi32(mask, maxima + first);', 'const __m512i limits = _mm512_maskz_loadu_epi32(mask >> 1, maxima + first);'),
    # The caller's runs: optional operands, a block at an expanded site's own block, the gathers' block table, a site's
    # own value, the last lane's operands.
    ('c1-run-optional', I, 'const __mmask16 value = mask & (_mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(BUSTER_IR_INLINE_VALUE)) | optional);', 'const __mmask16 value = mask & (_mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(BUSTER_IR_INLINE_VALUE)) | (optional & 0));'),
    ('c2-run-later-block', I, 'const __mmask16 later = target & _mm512_cmpgt_epu32_mask(operand, _mm512_set1_epi32((int32_t)sites->block[k]));', 'const __mmask16 later = target & _mm512_cmpge_epu32_mask(operand, _mm512_set1_epi32((int32_t)sites->block[k]));'),
    ('c3-run-gather-blocks', I, 'rebased = _mm512_mask_i32gather_epi32(rebased, target, operand, block_first, 4);', 'rebased = _mm512_mask_i32gather_epi32(rebased, target, operand, block_last, 4);'),
    ('c4-run-site-result', I, 'rebased = _mm512_mask_mov_epi32(rebased, at, _mm512_set1_epi32((int32_t)sites->result[k]));', 'rebased = _mm512_mask_mov_epi32(rebased, at & 0, _mm512_set1_epi32((int32_t)sites->result[k]));'),
    ('c5-run-tail', I, '_mm512_mask_storeu_epi32(outputs[column] + to, mask, rebased);', '_mm512_mask_storeu_epi32(outputs[column] + to, mask & 0x7fff, rebased);'),
    # The vector splice: a parameter's bound, a slot's base, the last lane's operands.
    ('s1-splice-parameter', I, 'const __mmask16 parameter = value & _mm512_cmplt_epu32_mask(operand, first_value);', 'const __mmask16 parameter = value & _mm512_cmple_epu32_mask(operand, first_value);'),
    ('s2-splice-slot-base', I, '[BUSTER_IR_INLINE_SLOT] = bases.slots,', '[BUSTER_IR_INLINE_SLOT] = bases.addresses,'),
    ('s3-splice-tail', I, '_mm512_mask_storeu_epi32(outputs[column] + at, mask, rebased);', '_mm512_mask_storeu_epi32(outputs[column] + at, mask & 0x7fff, rebased);'),
    # The driver's scan for the candidates whose address code takes: its marks, a full batch's last lane.
    # (check_tier1_inline_addressed_entries since 30cf59b55.)
    ('a1-addressed-marks', D, 'addressed[candidate != 0 ? candidate - 1 : body_count] = 1;', 'addressed[candidate != 0 ? candidate - 1 : body_count] = 0;'),
    ('a2-addressed-full-tail', D, 'const __mmask64 mask = n == 64 ? UINT64_MAX : (UINT64_C(1) << n) - 1;', 'const __mmask64 mask = n == 64 ? UINT64_MAX >> 1 : (UINT64_C(1) << n) - 1;'),
    # The node-at-a-time splice, now only the fallback for a callee whose parameters don't begin it or number more than
    # 16: its branches' block bases; and the choice between the two splices.
    ('f1-fallback-br', I, 'rewritten->a[at] += block_base;', 'rewritten->a[at] += 0 * block_base;'),
    ('f2-fallback-cbr-b', I, 'rewritten->b[at] += block_base;', 'rewritten->b[at] += 0 * block_base;'),
    ('f3-fallback-cbr-c', I, 'rewritten->c[at] += block_base;', 'rewritten->c[at] += 0 * block_base;'),
    ('g1-choice-parameters', I, 'if (shape->prefix == shape->parameters && shape->parameters <= 16)', 'if (shape->prefix == shape->parameters && shape->parameters <= 17)'),
    ('g2-choice-prefix', I, 'if (shape->prefix == shape->parameters && shape->parameters <= 16)', 'if ((shape->prefix == shape->parameters || shape->parameters != 0) && shape->parameters <= 16)'),
]
