# Mutants for #2924's diagnostics deletion: the PR tree's test-diagnostics, which checks the sort against its
# definition, must fail each. Round 1 (pr): d1 broke the insertion path (256 records or fewer), which the twin test
# compared with itself; d2 to d5 break the radix sort. Round 2 (pr2), on the tree with #2959's count sort: d1 is gone
# with the insertion sort; k1 to k5 break the count sort.
D = 'src/buster/compiler/diagnostic.c'
MUTANTS = [
    ('d1-insertion-unstable', D,
     '        while (at != 0 && diagnostic_order_before(value, items[at - 1]))',
     '        while (at != 0 && !diagnostic_order_before(items[at - 1], value))'),
    ('d2-radix-15-passes', D,
     '        for (uint32_t pass = 0; pass < 16; pass += 1)',
     '        for (uint32_t pass = 0; pass < 15; pass += 1)'),
    ('d3-radix-low-half-keys', D,
     '            const uint32_t shift = (pass & 7) * 8;',
     '            const uint32_t shift = (pass & 3) * 8;'),
    ('d4-radix-ranks-ignored', D,
     '                            output[histogram[digits[i]] + ranks[i]] = input[begin + i];',
     '                            output[histogram[digits[i]] + ranks[i] * 0] = input[begin + i];'),
    ('d5-radix-inactive-lanes-counted', D,
     '                    const uint32_t last = (uint32_t)live & ~(uint32_t)_mm512_mask_reduce_or_epi32(live, conflicts);',
     '                    const uint32_t last = 0xffffu & ~(uint32_t)_mm512_mask_reduce_or_epi32(live, conflicts);'),
    ('k1-earlier-ties-uncounted', D,
     '_mm512_cmplt_epu64_mask(block_sources, source) | _mm512_mask_cmple_epu64_mask(same_source, block_sequences, sequence);',
     '_mm512_cmplt_epu64_mask(block_sources, source) | _mm512_mask_cmplt_epu64_mask(same_source, block_sequences, sequence) | (__mmask8)0;'),
    ('k2-own-block-ties-all', D,
     '_mm512_mask_cmpeq_epu64_mask(same_source & below, block_sequences, sequence);',
     '_mm512_mask_cmpeq_epu64_mask(same_source & (below | 0xff), block_sequences, sequence);'),
    ('k3-source-column-lane-7', D,
     'const __m512i source_high = _mm512_setr_epi64(0, 0, 0, 0, 0, 0, 2, 5);',
     'const __m512i source_high = _mm512_setr_epi64(0, 0, 0, 0, 0, 0, 2, 4);'),
    ('k4-tail-smallest-keys', D,
     'const __m512i largest = _mm512_set1_epi64(-1);',
     'const __m512i largest = _mm512_set1_epi64(0);'),
    ('k5-second-register-short', D,
     'qwords > 8 ? (__mmask8)((1u << (qwords - 8)) - 1) : (__mmask8)0, bytes + 64);',
     'qwords > 8 ? (__mmask8)((1u << (qwords - 10)) - 1) : (__mmask8)0, bytes + 64);'),
]
