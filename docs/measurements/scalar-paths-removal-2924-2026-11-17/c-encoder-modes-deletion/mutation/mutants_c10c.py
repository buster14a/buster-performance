# #2924 C10c: mutants of the vector encoder's APX and 32-bit address paths, each (name, file, old, new).
E = 'src/buster/compiler/x86_64_encoder.c'
MUTANTS = [
    ('a1-address32-67', E, 'BUSTER_X86_SPLAT(address32 ? 1u << BUSTER_X86_PRESENCE_ADDRESS32 : 0)));', 'BUSTER_X86_SPLAT(address32 && apx ? 1u << BUSTER_X86_PRESENCE_ADDRESS32 : 0)));'),
    ('a2-address32-length', E, 'const uint32_t dynamic_bytes = 0x6f0 | (address32 ? 1u << BUSTER_X86_PRESENCE_ADDRESS32 : 0) | (apx ? 0x8000 : 0);', 'const uint32_t dynamic_bytes = 0x6f0 | (address32 && apx ? 1u << BUSTER_X86_PRESENCE_ADDRESS32 : 0) | (apx ? 0x8000 : 0);'),
    ('x1-apx-rex2-presence', E, 'early_presence = apx ? _mm512_ternarylogic_epi32(early_presence, rex2, BUSTER_X86_SPLAT(0x8400), BUSTER_X86_A_OR_B_AND_C) : early_presence;', 'early_presence = apx ? _mm512_ternarylogic_epi32(early_presence, rex2, BUSTER_X86_SPLAT(0x8000), BUSTER_X86_A_OR_B_AND_C) : early_presence;'),
    ('x2-apx-length', E, '| (apx ? 0x8000 : 0);\n    const __m512i dynamic', '| (apx ? 0x0000 : 0);\n    const __m512i dynamic'),
]
