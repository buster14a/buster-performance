# C12b's mutants: the vector kernels whose scalar twins were their only comparison, and the fallbacks the new checks
# cover. Each is (name, file, old, new); `old` must occur once in the file.
C = 'src/buster/compiler/c_parser_impl.c'
G = 'src/buster/compiler/c_gnu.c'
MUTANTS = [
    ('m1-k1-open-last', C, "uint64_t open = openers & _mm512_cmpeq_epi8_mask(suffix, after);",
     "uint64_t open = openers & _mm512_cmpeq_epi8_mask(suffix, after) & ~(1ull << 63);"),
    ('m2-k3-lane63', C, "        uint64_t lanes = _mm512_cmpeq_epi8_mask(kind, identifier);\n        uint64_t type_names = 0;",
     "        uint64_t lanes = _mm512_cmpeq_epi8_mask(kind, identifier) & ~(1ull << 63);\n        uint64_t type_names = 0;"),
    ('m3-k2-loop-typed', C, "            typed[i] = typed[opener - 2];", "            typed[i] = !typed[opener - 2];"),
    ('m4-colons-lane0', C, "        lanes &= block == 0 ? ~(uint64_t)1 : ~(uint64_t)0;", "        lanes &= block == 0 ? ~(uint64_t)1 : ~(uint64_t)1;"),
    ('m5-k4-wide-part', C, "                    part_fits |= size == 1;\n                    size = part_fits ? size : size / 2;\n                }\n                parse_top_left8_block(",
     "                    part_fits |= size <= 2;\n                    size = part_fits ? size : size / 2;\n                }\n                parse_top_left8_block("),
    ('m6-k4-deep-stack', C, "        while (left_count != 0 && kernels->stack_keys[left_count - 1] >= key)\n",
     "        while (left_count != 0 && kernels->stack_keys[left_count - 1] > key)\n"),
    ('m7-k5-carry', C, "first, _mm512_set1_epi8((char)state->last_classes));", "first, _mm512_set1_epi8((char)(state->last_classes & 0)));"),
    ('m8-k5-stack-end', C, "i == waiting->extra + 1;", "i == waiting->extra + 2;"),
    ('m9-k6-range-items', C, "const uint8_t inner_items = empty ? 0 : frames->items[depth + 1];", "const uint8_t inner_items = empty ? 0 : frames->items[depth];"),
    ('m10-function-roles-last', C, "PARSE_GROUP_PARAMETERS) & live_mask;", "PARSE_GROUP_PARAMETERS) & live_mask & ~(1ull << 63);"),
    ('m11-handoff-colons', C, "                                 _mm512_mask_cmpeq_epi8_mask(live, kinds, _mm512_set1_epi8((char)BUSTER_PP_KIND_PRAGMA_END)) |\n                                 _mm512_mask_cmpeq_epi8_mask(live, kinds, _mm512_set1_epi8(C_TOKEN_COLONCOLON));",
     "                                 _mm512_mask_cmpeq_epi8_mask(live, kinds, _mm512_set1_epi8((char)BUSTER_PP_KIND_PRAGMA_END)) |\n                                 (_mm512_mask_cmpeq_epi8_mask(live, kinds, _mm512_set1_epi8(C_TOKEN_COLONCOLON)) & 0);"),
    ('m12-gnu-asm', G, "                     _mm512_cmpeq_epi8_mask(values, _mm512_set1_epi8(PARSE_KIND_ASM)));",
     "                     (_mm512_cmpeq_epi8_mask(values, _mm512_set1_epi8(PARSE_KIND_ASM)) & 0));"),
    ('m5b-k4-wide-part8', C, "                    part_fits |= size == 1;\n                    size = part_fits ? size : size / 2;\n                }\n                parse_top_left8_block(",
     "                    part_fits |= size <= 8;\n                    size = part_fits ? size : size / 2;\n                }\n                parse_top_left8_block("),
    ('m6b-k4-deep-waiting', C, "        while (right_count != 0 && kernels->waiting_thresholds[right_count - 1] > key)",
     "        while (right_count != 0 && kernels->waiting_thresholds[right_count - 1] >= key)"),
    ('m5c-k4-wide-unsplit', C, "                    part_fits |= size == 1;\n                    size = part_fits ? size : size / 2;\n                }\n                parse_top_left8_block(",
     "                    part_fits |= size <= 32;\n                    size = part_fits ? size : size / 2;\n                }\n                parse_top_left8_block("),
    ('m13-k1-deep-enclosing', C, "        enclosing[i] = *depth > 0 ? open_stack[*depth - 1] : BUSTER_PARSE_NONE;",
     "        enclosing[i] = *depth > 1 ? open_stack[*depth - 2] : BUSTER_PARSE_NONE;"),
]
