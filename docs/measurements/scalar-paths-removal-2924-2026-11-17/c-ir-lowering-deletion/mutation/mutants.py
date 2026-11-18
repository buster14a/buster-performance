# #2924 C9b: mutants of the IR lowering's vector code, which its scalar twin's comparison used to check. Each is
# (name, file, old, new): a unique text replaced by another unique one, every identifier kept.
F = 'src/buster/compiler/ir_lower.c'
MUTANTS = [
    # The classification of sixteen entries a batch: a full batch's last lane, the signed and floating choices, the
    # types' table, and the signed classes' mask.
    ('c1-batch-lane-15', F, 'const uint32_t active_count = remaining < 16 ? remaining : 16;', 'const uint32_t active_count = remaining < 16 ? remaining : 15;'),
    ('c2-signed-blend', F, '_mm_mask_blend_epi8(is_signed, integer, signed_integer);', '_mm_mask_blend_epi8(is_signed, signed_integer, integer);'),
    ('c3-floating-blend', F, '_mm_mask_blend_epi8(is_floating, integral, floating)', '_mm_mask_blend_epi8(is_floating, floating, integral)'),
    ('c4-types-by-kind', F, '_mm_mask_storeu_epi8(types + i, active, _mm_shuffle_epi8(type_table, classes));', '_mm_mask_storeu_epi8(types + i, active, _mm_shuffle_epi8(type_table, kinds));'),
    ('c5-signed-mask', F, 'const __mmask16 is_signed = _mm_test_epi8_mask(_mm_shuffle_epi8(signed_table, classes), _mm_set1_epi8(1));', 'const __mmask16 is_signed = _mm_test_epi8_mask(_mm_shuffle_epi8(signed_table, classes), _mm_set1_epi8(2));'),
    # The ignored arguments' scan of eight locations: a tail's last lane, IGNORE's kind byte, and r10's static chain.
    ('g1-tail-last-lane', F, 'const __mmask8 active = (__mmask8)((1u << lanes) - 1);', 'const __mmask8 active = (__mmask8)(((1u << lanes) - 1) >> 1);'),
    ('g2-ignore-kind', F, '_mm512_set1_epi64((int64_t)UINT64_C(0x00ff000000000000))) != 0)', '_mm512_set1_epi64((int64_t)UINT64_C(0x00fe000000000000))) != 0)'),
    ('g3-chain-register', F, '(uint64_t)BUSTER_ABI_LOCATION_REGISTERS << 48 | (uint64_t)BUSTER_ABI_R10 << 32', '(uint64_t)BUSTER_ABI_LOCATION_REGISTERS << 48 | ((uint64_t)BUSTER_ABI_R10 + 1) << 32'),
]
