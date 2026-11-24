# Mutants of the assembler's kept code (#2924 C11b): the scalar relaxation and the 64-byte word scan. Each is
# (name, old, new) on src/buster/compiler/assembler.c; `old` must occur once.
MUTANTS = [
    ("first-offset-dropped",
     "        else\n        {\n            fragment->offset = offset;\n            const uint32_t role = asm_relax_role(relax, fragment, id);",
     "        else\n        {\n            fragment->offset = offset + (fragment->size > 4);\n            const uint32_t role = asm_relax_role(relax, fragment, id);"),
    ("first-leb-events-dropped",
     "            if (role != ASM_RELAX_PLAIN)\n            {\n                asm_relax_add(relax, fragment, id, region << 2 | role, &event_end);\n            }\n            offset += fragment->size;",
     "            if (role == ASM_RELAX_BRANCH)\n            {\n                asm_relax_add(relax, fragment, id, region << 2 | role, &event_end);\n            }\n            offset += fragment->size;"),
    ("first-region-shifted",
     "                asm_relax_add(relax, fragment, id, region << 2 | role, &event_end);\n            }\n            offset += fragment->size;",
     "                asm_relax_add(relax, fragment, id, (region + 1) << 2 | role, &event_end);\n            }\n            offset += fragment->size;"),
    ("first-tail-zero",
     "    relax->tails[section] = offset - event_end;",
     "    relax->tails[section] = 0;"),
    ("first-limit-unchecked",
     "        if (offset > BUSTER_ASM_MAX_SECTION)\n        {\n            asm_fail(parser, fragment->location, \"section exceeds the 256 MiB layout limit\");",
     "        if (offset > BUSTER_ASM_MAX_SECTION + 0x1000000u)\n        {\n            asm_fail(parser, fragment->location, \"section exceeds the 256 MiB layout limit\");"),
    ("place-last-skipped",
     "    while (at < end)\n    {\n        AsmFragment* fragment = &parser->fragments[order[at]];\n        fragment->offset = offset;",
     "    while (at + 1 < end)\n    {\n        AsmFragment* fragment = &parser->fragments[order[at]];\n        fragment->offset = offset;"),
    ("place-sizes-kept",
     "        parser->fragments[relax->events[e].fragment].size = relax->events[e].size;",
     "        parser->fragments[relax->events[e].fragment].size += 0;"),
    ("place-offset-stale",
     "        fragment->offset = offset;\n        offset += fragment->size;\n        at += 1;\n    }\n}",
     "        fragment->offset = at + 1 == end ? fragment->offset : offset;\n        offset += fragment->size;\n        at += 1;\n    }\n}"),
    ("word-long-cut",
     "        count += stopped ? (uint32_t)__builtin_ctzll(stop) : n;",
     "        count += stopped ? (uint32_t)__builtin_ctzll(stop) : n - (n == 64);"),
    ("word-dot-dropped",
     "        word |= _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8('_')) | _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8('.'));\n        const uint64_t stop = valid & ~word;\n        stopped",
     "        word |= _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8('_'));\n        const uint64_t stop = valid & ~word;\n        stopped"),
    ("word-digits-dropped",
     "        word |= _mm512_cmple_epu8_mask(_mm512_sub_epi8(bytes, _mm512_set1_epi8('0')), _mm512_set1_epi8(9));\n        word |= _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8('_')) | _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8('.'));\n        const uint64_t stop",
     "        word |= _mm512_cmple_epu8_mask(_mm512_sub_epi8(bytes, _mm512_set1_epi8('0')), _mm512_set1_epi8(8));\n        word |= _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8('_')) | _mm512_cmpeq_epi8_mask(bytes, _mm512_set1_epi8('.'));\n        const uint64_t stop"),
]
import sys
src = sys.argv[1]; name = sys.argv[2]
s = open(src).read()
for n, a, b in MUTANTS:
    if name == "list":
        print(n)
    elif n == name:
        assert s.count(a) == 1, (n, s.count(a))
        open(src, "w").write(s.replace(a, b))
