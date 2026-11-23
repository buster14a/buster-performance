# (name, file, old, new, runners): each old occurs once in the deletion commit's file.
C='src/buster/compiler/'
B=['test-bindings']
CK=['test-checker --part 1/8','test-checker --part 2/8','test-checker --part 3/8','test-checker --part 4/8','test-checker --part 5/8','test-checker --part 6/8','test-checker --part 7/8','test-checker --part 8/8']
DR=['test-checker-driver --executable EXE --part %d/8' % k for k in range(1,9)]
EXTRA=['test-checker-deferred','test-check-lanes','test-parser-bindings','test-environments']
ALL=B+CK+EXTRA+DR
MUTANTS=[
('s1-equal-self', C+'c_bindings.c', '& (__mmask16)(0xfffeu << other);', '& (__mmask16)(0xffffu << other);', ALL),
('s2-below-le', C+'c_bindings.c', 'const __mmask16 below = _mm512_mask_cmplt_epu32_mask(live, spread, high);', 'const __mmask16 below = _mm512_mask_cmple_epu32_mask(live, spread, high);', ALL),
('s3-no-carry', C+'c_bindings.c', '_mm512_store_si512(histogram + bucket, _mm512_add_epi32(carry, _mm512_sub_epi32(sum, frequency)));', '_mm512_store_si512(histogram + bucket, _mm512_sub_epi32(sum, frequency));', ALL),
('s4-scan-step8', C+'c_bindings.c', '                sum = _mm512_add_epi32(sum, _mm512_alignr_epi32(sum, zero, 8));\n', '', ALL),
('s5-skip-pass3', C+'c_bindings.c', 'count > BUSTER_C_BINDING_LANES && pass < 4; pass += 1)', 'count > BUSTER_C_BINDING_LANES && pass < 3; pass += 1)', ALL),
('s6-small-bound', C+'c_bindings.c', 'if (count > 1 && count <= BUSTER_C_BINDING_LANES)', 'if (count > 1 && count < BUSTER_C_BINDING_LANES)', ALL),
('s7-carry-lane', C+'c_bindings.c', '_mm512_permutexvar_epi32(_mm512_set1_epi32(15), sum));', '_mm512_permutexvar_epi32(_mm512_set1_epi32(14), sum));', ALL),
('b1-uses-restore', C+'c_check_body_bindings.c', 'const __mmask16 used = _mm_mask_cmpeq_epi8_mask(mask, operations, _mm_set1_epi8(C_BINDING_USE));', 'const __mmask16 used = _mm_mask_cmpeq_epi8_mask(mask, operations, _mm_set1_epi8(C_BINDING_RESTORE));', ALL),
('b2-no-point', C+'c_check_body_bindings.c', 'valid &= _mm512_mask_cmpneq_epu32_mask(global, points, _mm512_set1_epi32((int)point)) == 0;', 'valid &= _mm512_mask_cmpneq_epu32_mask(0, points, _mm512_set1_epi32((int)point)) == 0;', ALL),
('b3-no-base', C+'c_check_body_bindings.c', '_mm512_mask_sub_epi32(declaration, restored, declaration, base)', 'declaration', ALL),
('b4-within', C+'c_check_body_bindings.c', 'const __mmask16 within = _mm512_mask_cmplt_epu32_mask(known, ends, _mm512_set1_epi32((int)span->end));', 'const __mmask16 within = _mm512_mask_cmple_epu32_mask(known, ends, _mm512_set1_epi32((int)span->end));', ALL),
('a1-externs', C+'c_check_attested.c', 'externs |= names[u + _tzcnt_u64(storage)] == C_NAME_EXTERN;', 'externs |= true;', ALL),
('a2-callees', C+'c_check_attested.c', '_mm512_cmpeq_epi8_mask(next, _mm512_set1_epi8(PARSE_ROLE_OPEN_CALL)) | _mm512_cmpeq_epi8_mask(next, _mm512_set1_epi8(PARSE_ROLE_OPEN_FUNCTION))', '_mm512_cmpeq_epi8_mask(next, _mm512_set1_epi8(PARSE_ROLE_OPEN_CALL))', ALL),
('a3-levels-tail', C+'c_check_attested.c', 'const __mmask16 lanes = (__mmask16)_bzhi_u32(0xffffu, count - t < 16 ? count - t : 16);\n            const __m512i source', 'const __mmask16 lanes = (__mmask16)_bzhi_u32(0xffffu, count - t < 16 ? count - t - 1 : 16);\n            const __m512i source', ALL),
('a4-view-tail', C+'c_check_attested.c', 'const __mmask16 lanes = (__mmask16)_bzhi_u32(0xffffu, length - k < 16 ? length - k : 16);\n        const uint32_t t = from + k;', 'const __mmask16 lanes = (__mmask16)_bzhi_u32(0xffffu, length - k < 16 ? length - k - 1 : 16);\n        const uint32_t t = from + k;', ALL),
('a5-literal-char', C+'c_check_attested.c', '_mm512_cmpeq_epi8_mask(kind, number) | _mm512_cmpeq_epi8_mask(kind, character) | _mm512_cmpeq_epi8_mask(kind, string)', '_mm512_cmpeq_epi8_mask(kind, number) | _mm512_cmpeq_epi8_mask(kind, string)', ALL),
('a6-first-carry', C+'c_check_attested.c', 'const __m512i first = _mm512_max_epu64(local_first, carry_first);', 'const __m512i first = local_first;', ALL),
('a7-asm-strings', C+'c_check_attested.c', 'uint64_t texts = asms ? _mm512_mask_cmpeq_epi8_mask(lanes, kind, _mm512_set1_epi8(PARSE_KIND_STRING)) : 0;', 'uint64_t texts = 0;', ALL),
('r1-unlisted', C+'c_check_binding.c', 'uint32_t* uses = valid && reader->scratch != NULL ?', 'uint32_t* uses = false ?', ALL),
('b4b-within-short', C+'c_check_body_bindings.c', 'const __mmask16 within = _mm512_mask_cmplt_epu32_mask(known, ends, _mm512_set1_epi32((int)span->end));', 'const __mmask16 within = _mm512_mask_cmplt_epu32_mask(known, ends, _mm512_set1_epi32((int)span->end - 1));', ALL),
]
