# Mutants for #2924's disassembler swap: each must fail main's twin test (t0) and the new checks (t2).
D = 'src/buster/compiler/x86_64_disassembler.c'
F = 'src/buster/compiler/x86_64_disassembly.c'
MUTANTS = [
    ('m01-classify-fwait', D, 'const __m128i low = _mm_setr_epi8(5, 1, 5, 5, 3, 3, 11, 3, 1, 1, 1, 17, 1, 1, 9, 1);', 'const __m128i low = _mm_setr_epi8(5, 1, 5, 5, 3, 3, 11, 3, 1, 1, 1, 1, 1, 1, 9, 1);'),
    ('m02-lane-rex-r', D, 'const __m512i r = _mm512_slli_epi32(_mm512_and_si512(rex, _mm512_set1_epi32(4)), 1);', 'const __m512i r = _mm512_slli_epi32(_mm512_and_si512(rex, _mm512_set1_epi32(4)), 2);'),
    ('m03-index-ambiguous', D, 'row = row == 0 ? x86_decode_forms[entry] : UINT16_MAX;', 'row = row == 0 ? x86_decode_forms[entry] : row;'),
    ('m04-end-mask', D, 'const __m512i available = _mm512_set1_epi64((1ull << 38) - 1);', 'const __m512i available = _mm512_set1_epi64((1ull << 46) - 1);'),
    ('m05-compact-lax', D, '(fields & (memory ? check.memory : check.registers)) == 0 &&', '(fields & (memory ? check.memory : check.registers) & 0xffff00ffu) == 0 &&'),
    ('m06-compact-strict', D, '(memory && (check.flags & (1u << 10)))', '(memory || (check.flags & (1u << 10)))'),
    ('m07-length-disp8', D, 'length = _mm512_mask_add_epi8(length, disp1, length, _mm512_set1_epi8(1));', 'length = _mm512_mask_add_epi8(length, disp1, length, _mm512_set1_epi8(2));'),
    ('m08-plan-token', F, 'memcpy(at, "addr32 ", 7);', 'memcpy(at, "addr16 ", 7);'),
    ('m09-listing-hex', F, '0x0504200302200100ull', '0x0405200302200100ull'),
    ('m10-batch-resync', D, 'consistent = lengths[at] == decoded.length;', 'consistent = lengths[at] != 0;'),
    ('m11-fwait-retry', D, 'bytes[0] == 0x9b)', 'bytes[0] == 0x9c)'),
    ('m12-lane-disp8-sign', D, 'displacement = _mm512_mask_srai_epi32(displacement, disp1, _mm512_slli_epi32(displacement_raw, 24), 24);', 'displacement = _mm512_mask_srli_epi32(displacement, disp1, _mm512_slli_epi32(displacement_raw, 24), 24);'),
    ('m13-index-pext', D, 'row = x86_decode_index_rows[index->first + _pext_u64(header.key, index->varying)];', 'row = x86_decode_index_rows[index->first + _pext_u64(header.key, index->varying & (index->varying - 1))];'),
    # The same mutant in the final tree, where the lookup is x86_decode_index_row's.
    ('m13b-index-pext', D, 'row = x86_decode_index_rows[index->first + _pext_u64(key, index->varying)];', 'row = x86_decode_index_rows[index->first + _pext_u64(key, index->varying & (index->varying - 1))];'),
]
