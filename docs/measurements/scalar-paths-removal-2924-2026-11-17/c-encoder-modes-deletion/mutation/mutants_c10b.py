# #2924 C10b: mutants of the encoder's last partial group by masked loads, each (name, file, old, new).
E = 'src/buster/compiler/x86_64_encoder.c'
MUTANTS = [
    ('t1-tail-last-record', E, 'const uint64_t dwords = loaded < BUSTER_X86_GROUP_INSTRUCTIONS ? (UINT64_C(1) << (4 * loaded)) - 1 : ~UINT64_C(0);', 'const uint64_t dwords = loaded < BUSTER_X86_GROUP_INSTRUCTIONS ? (UINT64_C(1) << (4 * loaded - 4)) - 1 : ~UINT64_C(0);'),
    ('t2-tail-quad-mask', E, '_mm512_maskz_loadu_epi32((__mmask16)(dwords >> (16 * q)), instructions + BUSTER_X86_QUAD_INSTRUCTIONS * q)', '_mm512_maskz_loadu_epi32((__mmask16)(dwords >> (8 * q)), instructions + BUSTER_X86_QUAD_INSTRUCTIONS * q)'),
    ('t3-tail-full-quad', E, ': loaded >= BUSTER_X86_QUAD_INSTRUCTIONS * (q + 1) ? _mm512_loadu_si512', ': loaded >= BUSTER_X86_QUAD_INSTRUCTIONS * q ? _mm512_loadu_si512'),
    ('t4-tail64-forms', E, '        end = encode_group(instructions, 1, out, output, offsets, lanes, fixups, X86_GATHER_INSERTS_FORMS_FROM_RECORDS,', '        end = encode_group(instructions, 1, out, output, offsets, lanes, fixups, X86_GATHER_INSERTS,'),
    ('t5-generic-tail-forms', E, 'X86_GATHER_INSERTS_FORMS_FROM_RECORDS, store, fixup_store, encoder, (uint32_t)(count - i));', 'gather, store, fixup_store, encoder, (uint32_t)(count - i));'),
    ('t6-tail64-loaded', E, 'X86_STORE_FULL, X86_FIXUP_STORE_FULL, X86_ENCODER_MODE_64, count);\n    }\n    else', 'X86_STORE_FULL, X86_FIXUP_STORE_FULL, X86_ENCODER_MODE_64, count - (count == 3));\n    }\n    else'),
]
MUTANTS += [
    # 32-bit and 16-bit modes' own paths: 16-bit mode's presence bits, a 16-bit address's displacement size.
    ('l1-legacy-presence', E, 'const __m512i group_presence = x86_mode_is_legacy(encoder) ? fields.legacy_presence : fields.presence;', 'const __m512i group_presence = x86_mode_is_legacy(encoder) && encoder == X86_ENCODER_MODE_32 ? fields.legacy_presence : fields.presence;'),
    ('l2-address16-displacement', E, '_mm512_srai_epi32(_mm512_slli_epi32(displacement, 16), 16)', '_mm512_srai_epi32(_mm512_slli_epi32(displacement, 16), 15)'),
]
