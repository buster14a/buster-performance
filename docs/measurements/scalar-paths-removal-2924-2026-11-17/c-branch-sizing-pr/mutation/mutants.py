# Mutants for #2924's branch sizing swap: each must fail the PR's test-branch-sizing (the plain run, no --cross-check).
D = 'src/buster/compiler/branch_sizing.c'
MUTANTS = [
    ('b1-columns-order-across-vectors', D, 'const __mmask16 ordered = k != 0 ? lanes : (__mmask16)(lanes & ~1u);', 'const __mmask16 ordered = (__mmask16)(lanes & ~1u);'),
    ('b2-columns-target-past-count', D, 'const __mmask16 target_errors = _mm512_mask_cmpgt_epu32_mask(lanes, target, count_vector);', 'const __mmask16 target_errors = _mm512_mask_cmpgt_epu32_mask(lanes, target, _mm512_add_epi32(count_vector, one));'),
    ('b3-columns-index-unreported', D, 'result.error = (index_errors & bit) != 0  ? BRANCH_SIZING_ERROR_BRANCH_INDEX :', 'result.error = (index_errors & bit & 0) != 0  ? BRANCH_SIZING_ERROR_BRANCH_INDEX :'),
    ('b4-columns-first-lane-form', D, 'const __mmask16 form_errors = (__mmask16)(inside & ~branch);', 'const __mmask16 form_errors = (__mmask16)(inside & ~branch & ~1u);'),
    ('b5-offsets-first-long', D, 'k += grown == 0 ? BUSTER_BRANCH_SIZING_LANES : (uint64_t)__builtin_ctz(grown);', 'k += BUSTER_BRANCH_SIZING_LANES;'),
    ('b6-round-long-stays-long', D, 'const __mmask16 grows = _mm512_test_epi32_mask(old, old) | branch_sizing_out_of_range_vector(displacement);', 'const __mmask16 grows = _mm512_test_epi32_mask(old, old) & branch_sizing_out_of_range_vector(displacement);'),
    ('b7-columns-target-load', D, '''        const __m512i target = _mm512_maskz_loadu_epi32(lanes, targets + k);
        // Each branch's record must be above the one before it''', '''        const __m512i target = _mm512_loadu_si512(targets + k);
        // Each branch's record must be above the one before it'''),
]
