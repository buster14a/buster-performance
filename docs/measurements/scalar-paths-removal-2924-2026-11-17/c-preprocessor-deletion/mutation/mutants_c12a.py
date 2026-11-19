# C12a's mutants: the kernels whose scalar twins were their only comparison. Each is (name, file, old, new); `old`
# must occur once in the file.
P = 'src/buster/compiler/c_preprocessor.c'
I = 'src/buster/compiler/c_preprocessor_impl.c'
H = 'src/buster/compiler/c_preprocessor_history_impl.c'
F = 'src/buster/compiler/c_files.c'
MUTANTS = [
    ('m1-splice-carry', P, "possible = (((backslashes << 1) | carry) & blanks)", "possible = ((backslashes << 1) & blanks)"),
    ('m2-splits-unknown', P, "result += pp_splits_unknown(bytes, starts[t], ends[t], split);", "result += 0 * pp_splits_unknown(bytes, starts[t], ends[t], split);"),
    ('m3-lines-lane63', P, "        const __m512i block = _mm512_maskz_loadu_epi8(valid, kinds + i);\n        lines[i / 64] = _mm512_movepi8_mask(block) & valid;\n        uint64_t directives",
     "        const __m512i block = _mm512_maskz_loadu_epi8(valid, kinds + i);\n        lines[i / 64] = _mm512_movepi8_mask(block) & valid & ~(1ull << 63);\n        uint64_t directives"),
    ('m4-pair-depth', P, "_mm512_add_epi16(_mm512_sub_epi16(pp_prefix_sum_words(steps), steps), _mm512_set1_epi16((short)depth))",
     "_mm512_add_epi16(_mm512_sub_epi16(pp_prefix_sum_words(steps), steps), _mm512_set1_epi16((short)(depth > 1 ? depth - 1 : depth)))"),
    ('m5-places-16', P, "if (BUSTER_UNLIKELY(here > 16))", "if (BUSTER_UNLIKELY(here > 17))"),
    ('m6-file-run-lane63', I, """        for (uint64_t bits = identifiers; bits != 0; bits &= bits - 1)
        {
            const uint32_t lane = (uint32_t)__builtin_ctzll(bits);
            if (pp_is_macro(pp, data->values[p + lane]))
            {
                take = lane;
                stopped = true;
                break;
            }
        }
        if (take != 0)
        {
            pp_store_file_tokens(target, target->count, data, base, p, available, take, kinds, false);""",
     """        for (uint64_t bits = identifiers; bits != 0; bits &= bits - 1)
        {
            const uint32_t lane = (uint32_t)__builtin_ctzll(bits);
            if (pp_is_macro(pp, data->values[p + lane]) && lane != 63)
            {
                take = lane;
                stopped = true;
                break;
            }
        }
        if (take != 0)
        {
            pp_store_file_tokens(target, target->count, data, base, p, available, take, kinds, false);"""),
    ('m7-buffer-paint', I, "                    paint |= 1ull << lane;", "                    paint |= 0;"),
    ('m8-history-first', H, "_mm256_mask_set1_epi32(_mm256_permutexvar_epi32(shifted, values), 1, (int)previous)",
     "_mm256_mask_set1_epi32(_mm256_permutexvar_epi32(shifted, values), 0, (int)previous)"),
    ('m9-parameters-last', I, "        const __mmask16 lanes = (__mmask16)_bzhi_u32(0xFFFF, count);\n        const __m512i ids = _mm512_maskz_loadu_epi32(lanes, names);",
     "        const __mmask16 lanes = (__mmask16)_bzhi_u32(0xFFFF, count - (count > 8));\n        const __m512i ids = _mm512_maskz_loadu_epi32(lanes, names);"),
    ('m10-remap-guard', F, "    data->guard = data->guard >= C_NAME_COUNT ? shared[data->guard] : data->guard;\n}",
     "    data->guard = data->guard >= C_NAME_COUNT + 100000 ? shared[data->guard] : data->guard;\n}"),
    ('m11-embed-first', I, "const uint64_t first = i == 0 && !separated ? ~3ull : ~0ull;", "const uint64_t first = i == 0 && !separated ? ~1ull : ~0ull;"),
    ('m12-separation', I, "    0, 1, 1, 1, 1, 0, 1, 0,\n};", "    0, 1, 1, 1, 1, 0, 0, 0,\n};"),
    ('m13-keywords-group3', I, "                                    : _mm512_inserti32x4(looked, kinds_here, 3);", "                                    : _mm512_inserti32x4(looked, kinds_here, 2);"),
]
