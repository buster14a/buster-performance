# Mutants for #2924's dataflow deletion: the PR tree's tests (no twin) must kill each. Count-only mutants (d4, d5, d6)
# and the phi targets (i5) were checked by the twin comparison alone, or by nothing, before the sweep search and the
# layout check.
D = 'src/buster/compiler/dataflow.c'
I = 'src/buster/compiler/ir_dataflow.c'
MUTANTS = [
    ('d1-self-edge-takes-register', D, 'if (__builtin_expect(successor == previous_block, 1))', 'if (__builtin_expect(successor == previous_block || successor == block, 1))'),
    ('d2-register-holds-out', D, '            previous_block = block;\n            previous_in = in;', '            previous_block = block;\n            previous_in = out;'),
    ('d3-last-block-decides', D, '            changes = _mm512_or_si512(changes, difference);', '            changes = _mm512_or_si512(difference, _mm512_and_si512(changes, _mm512_setzero_si512()));'),
    ('d4-one-count-from-two', D, '    uint64_t iterations = 1;\n    const uint32_t block_count = dataflow->block_count;\n    const uint32_t* restrict successor_offsets', '    uint64_t iterations = 2;\n    const uint32_t block_count = dataflow->block_count;\n    const uint32_t* restrict successor_offsets'),
    ('d5-rows-count-doubled', D, '            changed = changes != 0;\n            iterations += changed;', '            changed = changes != 0;\n            iterations += changed * (1 + (row_words > 8));'),
    ('d6-empty-count-two', D, '    uint64_t iterations = 1;\n    if (dataflow->row_words == BUSTER_DATAFLOW_VECTOR_WORDS', '    uint64_t iterations = 2;\n    if (dataflow->row_words == BUSTER_DATAFLOW_VECTOR_WORDS'),
    ('d7-rows-first-vector-only', D, 'out = _mm512_or_si512(out, _mm512_load_si512(successor_in + word));', 'out = _mm512_or_si512(out, _mm512_load_si512(successor_in + (word & 0)));'),
    ('d8-intersects-last-vector', D, '        intersections |= _mm512_test_epi64_mask(left_values, right_values);', '        intersections = _mm512_test_epi64_mask(left_values, right_values);'),
    ('i1-operand-range-off-by-one', I, '_mm512_mask_cmpge_epu32_mask(active, operands, end)', '_mm512_mask_cmpgt_epu32_mask(active, operands, end)'),
    ('i2-phi-range-off-by-one', I, '_mm512_mask_cmpge_epu32_mask(tail, original, finish)', '_mm512_mask_cmpgt_epu32_mask(tail, original, finish)'),
    ('i3-set-high-group-shift', I, '_mm512_maskz_mov_epi64((__mmask8)(group >> 8), high)', '_mm512_maskz_mov_epi64((__mmask8)(group >> 7), high)'),
    ('i4-set-ninth-id-lost', I, '        if (count > 8)\n        {\n            high = ', '        if (count > 9)\n        {\n            high = '),
    ('i5-phi-target-predecessor', I, '                        candidate.phi_targets[place] = block;', '                        candidate.phi_targets[place] = blocks[lane];'),
    ('i6-dense-rank-base', I, '_mm512_add_epi32(rank, _mm512_set1_epi32((int)dense))', '_mm512_add_epi32(rank, _mm512_set1_epi32((int)(dense + (first != 0))))'),
    ('i7-restore-into-in', I, 'ir_dataflow_set(dataflow->flow.out + (uint64_t)block * dataflow->flow.row_words, dataflow->phi_values + first, count);', 'ir_dataflow_set(dataflow->flow.in + (uint64_t)block * dataflow->flow.row_words, dataflow->phi_values + first, count);'),
    ('i8-single-operand-batches-skipped', I, '    if (nonlocal != 0)\n    {\n        const __m512i ids = flow == NULL', '    if (nonlocal != 0 && count > 1)\n    {\n        const __m512i ids = flow == NULL'),
]
