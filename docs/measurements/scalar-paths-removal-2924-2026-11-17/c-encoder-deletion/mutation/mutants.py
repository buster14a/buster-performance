# #2924 C10: mutants of the vector encoder (x86_encode_16 and its tail) and of x86_measure, whose scalar twins C10
# deletes, each (name, file, old, new): a unique text replaced by another unique one, every identifier kept.
E = 'src/buster/compiler/x86_64_encoder.c'
MUTANTS = [
    # Measure: the tail's masked loads (the last record, the third quad's mask), the last full group's total, the base.
    ('m1-measure-tail-last', E, 'const uint64_t dwords = (UINT64_C(1) << (4 * (count - i))) - 1;', 'const uint64_t dwords = (UINT64_C(1) << (4 * (count - i) - 4)) - 1;'),
    ('m2-measure-tail-quad2', E, '_mm512_maskz_loadu_epi32((__mmask16)(dwords >> 32), group + 8)', '_mm512_maskz_loadu_epi32((__mmask16)(dwords >> 16), group + 8)'),
    ('m3-measure-tail-lanes', E, 'offsets + i, (__mmask16)((1u << (count - i)) - 1));', 'offsets + i, (__mmask16)((1u << (count - i)) - 1) & 0x7ffe);'),
    ('m4-measure-total', E, 'return base + (uint32_t)_mm_extract_epi8(ends, BUSTER_X86_GROUP_INSTRUCTIONS - 1);', 'return base + (uint32_t)_mm_extract_epi8(ends, BUSTER_X86_GROUP_INSTRUCTIONS - 2);'),
    ('m5-measure-base', E, '_mm512_mask_storeu_epi32(offsets, lanes, _mm512_add_epi32(starts, _mm512_set1_epi32((int32_t)base)));', '_mm512_mask_storeu_epi32(offsets, lanes, _mm512_add_epi32(starts, _mm512_set1_epi32((int32_t)(base & ~1u))));'),
    # Encode: the tail's quads choice and lanes, the offsets' last lane, the fixup ends' count, the group's offset, the
    # capacity check, and an 8-bit displacement's range.
    ('e1-tail-quads', E, '    if (count <= 4)\n    {\n        end = encode_group(tail, 1,', '    if (count <= 5)\n    {\n        end = encode_group(tail, 1,'),
    ('e2-tail-lanes', E, '    const uint32_t lanes = (1u << count) - 1;\n    uint8_t* end;', '    const uint32_t lanes = ((1u << count) - 1) & ~(count == 7 ? 64u : 0u);\n    uint8_t* end;'),
    ('e3-offsets-last-lane', E, '_mm512_mask_storeu_epi32(offsets, (__mmask16)offset_lanes, _mm512_add_epi32(starts, group_start));', '_mm512_mask_storeu_epi32(offsets, (__mmask16)(offset_lanes & 0x7fff), _mm512_add_epi32(starts, group_start));'),
    ('e4-fixup-count', E, '            *fixup_ends += __builtin_popcount(marked);\n        }\n    }\n    return out;', '            *fixup_ends += __builtin_popcount(marked & 0x7fff);\n        }\n    }\n    return out;'),
    ('e5-group-offset', E, 'uint32_t group_offset = (uint32_t)(group_out - output);', 'uint32_t group_offset = (uint32_t)(group_out - output) & ~1u;'),
    ('e6-capacity', E, '    else if (capacity < BUSTER_X86_ENCODER_CAPACITY(count))\n    {\n        result = X86_ENCODER_ERROR_OUTPUT_TOO_SMALL;\n    }\n    else\n    {\n        result = x86_encode_16(instructions, count, output, offsets, fixup_ends);', '    else if (capacity + 1 < BUSTER_X86_ENCODER_CAPACITY(count))\n    {\n        result = X86_ENCODER_ERROR_OUTPUT_TOO_SMALL;\n    }\n    else\n    {\n        result = x86_encode_16(instructions, count, output, offsets, fixup_ends);'),
    ('e7-disp8-range', E, 'const __m512i too_long = _mm512_srlv_epi32(BUSTER_X86_SPLAT(0x01ffffff), _mm512_lzcnt_epi32(magnitude));', 'const __m512i too_long = _mm512_srlv_epi32(BUSTER_X86_SPLAT(0x00ffffff), _mm512_lzcnt_epi32(magnitude));'),
    ('e8-tail-copy', E, '    X86Instruction tail[BUSTER_X86_GROUP_INSTRUCTIONS] __attribute__((aligned(64))) = { 0 };\n    memcpy(tail, instructions, count * sizeof(X86Instruction));\n    uint32_t* cursor', '    X86Instruction tail[BUSTER_X86_GROUP_INSTRUCTIONS] __attribute__((aligned(64))) = { 0 };\n    memcpy(tail, instructions, (count - (count == 9)) * sizeof(X86Instruction));\n    uint32_t* cursor'),
    ('e9-fixup-marked-tail', E, 'const __mmask16 marked = (__mmask16)_mm512_movepi8_mask(_mm512_permutexvar_epi8(_mm512_load_si512(x86_form_high_bytes), extension));', 'const __mmask16 marked = (__mmask16)_mm512_movepi8_mask(_mm512_permutexvar_epi8(_mm512_load_si512(x86_form_high_bytes), extension)) & 0x7fff;'),
]
