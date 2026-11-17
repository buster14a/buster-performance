# Worklist mutants for #2924's branch sizing: they change only the counts (evaluations, rounds), which the twin
# comparison checked. Run on main's tree (its twin test) and the PR's.
D = 'src/buster/compiler/branch_sizing.c'
MUTANTS = [
    ('w1-mark-long-branches-too', D, 'const unsigned __int128 marks = (unsigned __int128)(uint16_t)((forward | backward) & _mm512_testn_epi32_mask(growths, growths) & lanes) << (i % 64);', 'const unsigned __int128 marks = (unsigned __int128)(uint16_t)((forward | backward) & (_mm512_testn_epi32_mask(growths, growths) | 0xffff) & lanes) << (i % 64);'),
    ('w2-mark-misses-rank-k', D, 'const __mmask16 backward = _mm512_cmpgt_epu32_mask(index, key) & _mm512_cmple_epu32_mask(ranks, key);', 'const __mmask16 backward = _mm512_cmpgt_epu32_mask(index, key) & _mm512_cmplt_epu32_mask(ranks, key);'),
]
