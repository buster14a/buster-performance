# Mutants of value numbering's kept walk (ir_optimize_gvn.c), #2924 C9g. Each is (name, old, new); old occurs once.
MUTANTS = [
    ("k1-payload-high", "    work->fields[n * 2 + i] = payload.high;\n", "    work->fields[n * 2 + i] = 0;\n"),
    ("k2-operand-c", "    work->fields[n * 5 + i] = (mask & 4) != 0 ?", "    work->fields[n * 5 + i] = (mask & 0) != 0 ?"),
    ("c1-fields-tail", "    for (uint32_t field = 0; result == 0 && field < BUSTER_IR_GVN_FIELDS; field += 1)", "    for (uint32_t field = 0; result == 0 && field + 1 < BUSTER_IR_GVN_FIELDS; field += 1)"),
    ("c2-vconst-words", "        for (uint32_t word = 2; result == 0 && word < 8; word += 1)", "        for (uint32_t word = 2; result == 0 && word < 7; word += 1)"),
    ("a1-no-rollback", "                    heads[work->hashes[value] & (buckets - 1)] = previous[value];", "                    (void)previous[value];"),
    ("a2-phi-pure", "                work->pure[i] = 0;\n            }\n        }\n        uint32_t depth", "                work->pure[i] = 1;\n            }\n        }\n        uint32_t depth"),
    ("a3-pressure-class", "                        work->classes[i] = match != BUSTER_IR_NONE ? work->classes[match] : work->classes[i];", "                        work->classes[i] = match != BUSTER_IR_NONE && !refused ? work->classes[match] : work->classes[i];"),
    ("a4-pressure-block", "(f->type[i] == IR_I1 && work->ir.cfg.instruction_blocks[match] != frame->block)", "(f->type[i] == IR_I1)"),
    ("a5-pressure-free", "(ir_gvn_free[f->op[i]] != 0 || (f->type[i]", "((f->type[i]"),
    ("v1-keep-tail", "        const __mmask16 own = valid & _mm_cmplt_epu8_mask(types, _mm_set1_epi8(IR_V4I32));", "        const __mmask16 own = (valid >> 1) & _mm_cmplt_epu8_mask(types, _mm_set1_epi8(IR_V4I32));"),
    ("v2-keep-threshold", "_mm_cmplt_epu8_mask(types, _mm_set1_epi8(IR_V4I32))", "_mm_cmplt_epu8_mask(types, _mm_set1_epi8(IR_V4I32 + 1))"),
    ("h1-vconst-hash", "        for (uint32_t word = 2; word < 8; word += 1)\n        {\n            hash = ir_gvn_mix(hash, words[word]);", "        for (uint32_t word = 2; word < 2; word += 1)\n        {\n            hash = ir_gvn_mix(hash, words[word]);"),
]
