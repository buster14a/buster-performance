# Mutants for #2924's diagnostics deletion: the PR tree's test-diagnostics, which checks the sort against its
# definition, must fail each. d1 breaks the insertion path (256 records or fewer), which the twin test compared with
# itself; d2 to d5 break the radix sort.
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
]
