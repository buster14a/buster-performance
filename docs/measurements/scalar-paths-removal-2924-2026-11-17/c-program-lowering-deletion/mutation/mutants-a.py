# Mutants of piece (a)'s vector code, on the deletion (c_check_program_lower.c). Each: (name, old, new).
M=[
("m1-entry-vector-class", "vector |= _mm512_cmpeq_epi8_mask(some, _mm512_set1_epi8(BUSTER_TYPED_CLASS_VECTOR));", "vector |= 0;"),
("m2-labels-span", "const __m512i kinds_span = _mm512_set1_epi8((char)(BUSTER_TYPED_JUMP_VALUE - BUSTER_TYPED_BRANCH_FALSE));", "const __m512i kinds_span = _mm512_set1_epi8((char)(BUSTER_TYPED_JUMP_VALUE - BUSTER_TYPED_BRANCH_FALSE - 1));"),
("m3-classify-plain-char", "const __mmask64 plain_char = types->char_unsigned ? UINT64_C(1) << BUSTER_TYPE_CODE_CHAR : 0;", "const __mmask64 plain_char = 0;"),
("m4-volatile-scan-lane", "const __mmask16 active = left < 16 ? (__mmask16)((1u << left) - 1) : UINT16_MAX;\n        const __m512i values = _mm512_maskz_loadu_epi32(active, types->members.type + m);", "const __mmask16 active = left < 16 ? (__mmask16)((1u << left) - 1) >> 1 : UINT16_MAX >> 1;\n        const __m512i values = _mm512_maskz_loadu_epi32(active, types->members.type + m);"),
("m5-named-rewrite-tail", "const __mmask8 active = (__mmask8)((1u << (count - e < 8 ? count - e : 8)) - 1);", "const __mmask8 active = (__mmask8)((1u << (count - e < 8 ? count - e : 8)) - 1) & 0x7f;"),
("m6-forwards-kind", "forwards = _mm512_mask_cmpeq_epi32_mask(active, check_lower_control_kinds(controls + i, lanes), _mm512_set1_epi32(CHECK_CONTROL_RESULT)) == 0;", "forwards = _mm512_mask_cmpeq_epi32_mask(active & 0x7fff, check_lower_control_kinds(controls + i, lanes), _mm512_set1_epi32(CHECK_CONTROL_RESULT)) == 0;"),
("m7-named-result-lane", "uint32_t returns = (uint32_t)(_mm512_mask_cmpeq_epi32_mask(active, kinds, _mm512_set1_epi32(CHECK_CONTROL_RETURN)) |", "uint32_t returns = (uint32_t)(_mm512_mask_cmpeq_epi32_mask(active & 0x7fff, kinds, _mm512_set1_epi32(CHECK_CONTROL_RETURN)) |"),
("m8-twice-names", "named = name != 0 && _mm256_movemask_epi8(_mm256_cmpeq_epi32(names, _mm256_set1_epi32((int)name))) != 0;", "named = name != 0 && (_mm256_movemask_epi8(_mm256_cmpeq_epi32(names, _mm256_set1_epi32((int)name))) & 0x0fffffff) != 0;"),
]
