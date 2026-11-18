# Mutants for #2924 C7b-2, the emit areas: each breaks vector code that stays (the fixed-range filter's cross product and
# sweep, the liveness adapter's dense compaction and row builder, the rematerialization marks' table, the call-save rows'
# helpers, the calls before each position, the CFG column's set check, the move resolver's scratch check, the select
# requests' batch). The twin-free tests must fail each.
A = 'src/buster/compiler/tier1_allocate.c'
L = 'src/buster/compiler/tier1_liveness.c'
R = 'src/buster/compiler/tier1_rematerialize.c'
E = 'src/buster/compiler/tier1_emit.c'
C = 'src/buster/compiler/tier1_emit_cfg.c'
G = 'src/buster/compiler/tier1_cfg.c'
S = 'src/buster/compiler/tier1_select.c'
MUTANTS = [
    ('a1-fixed-cross-end-touches', A,
     '& _mm512_cmpgt_epu32_mask(end, _mm512_set1_epi32((int32_t)columns.fixed.starts[f]));',
     '& _mm512_cmpge_epu32_mask(end, _mm512_set1_epi32((int32_t)columns.fixed.starts[f]));'),
    ('a2-fixed-sweep-register-16', A,
     'const uint32_t high = _mm512_cmpgt_epu32_mask(_mm512_loadu_si512(maximum + 16), start);',
     'const uint32_t high = _mm512_cmpgt_epu32_mask(_mm512_loadu_si512(maximum + 16), start) & 0xfffe;'),
    ('l1-dense-odd-batches-shifted', L,
     '_mm512_mask_storeu_epi32(ids + first, selected, _mm512_add_epi32(rank, _mm512_set1_epi32((int)dense)));',
     '_mm512_mask_storeu_epi32(ids + first, selected, _mm512_add_epi32(rank, _mm512_set1_epi32((int)(dense + ((first >> 4) & 1)))));'),
    ('l2-rows-leader-bit-alone', L,
     'const __mmask16 group = active & _mm512_cmpeq_epi32_mask(words, _mm512_set1_epi32((int)word));',
     'const __mmask16 group = active & (__mmask16)(1u << lane) & _mm512_cmpeq_epi32_mask(words, _mm512_set1_epi32((int)word));'),
    ('r1-marks-stack-unrecognized', R,
     '''        // Operation table lookup rejects every unrecognized value, including byte values beyond the table.
        static const uint8_t table[64] __attribute__((aligned(64))) = {
            [BUSTER_TIER1_REMAT_INTEGER] = 1,
            [BUSTER_TIER1_REMAT_SYMBOL] = 1,
            [BUSTER_TIER1_REMAT_STACK] = 1,''',
     '''        // Operation table lookup rejects every unrecognized value, including byte values beyond the table.
        static const uint8_t table[64] __attribute__((aligned(64))) = {
            [BUSTER_TIER1_REMAT_INTEGER] = 1,
            [BUSTER_TIER1_REMAT_SYMBOL] = 1,
            [BUSTER_TIER1_REMAT_STACK] = 0,'''),
    ('s1-kept-register-15', E,
     'return _mm512_mask_cmpeq_epi32_mask((__mmask16)saved, _mm512_loadu_si512(saves->rows), _mm512_loadu_si512(transitions->owners));',
     'return _mm512_mask_cmpeq_epi32_mask((__mmask16)(saved & 0x7fff), _mm512_loadu_si512(saves->rows), _mm512_loadu_si512(transitions->owners));'),
    ('s2-fixed-rows-register-15', E,
     '(__mmask16)fixed, _mm512_set1_epi32((int)BUSTER_IR_NONE)));',
     '(__mmask16)(fixed & 0x7fff), _mm512_set1_epi32((int)BUSTER_IR_NONE)));'),
    ('c1-calls-carry-lane-14', C,
     'carry = _mm512_permutexvar_epi32(last, sum);',
     'carry = _mm512_permutexvar_epi32(_mm512_sub_epi32(last, _mm512_set1_epi32(1)), sum);'),
    ('v1-sets-definition-lane-15', G,
     '| _mm512_mask_test_epi32_mask(lanes, unallowed, unallowed);',
     '| _mm512_mask_test_epi32_mask(lanes & 0x7fff, unallowed, unallowed);'),
    ('m1-moves-scratch-destination-lane-7', A,
     '| _mm256_cmpeq_epi32_mask(destinations, scratch);',
     '| (_mm256_cmpeq_epi32_mask(destinations, scratch) & 0x7f);'),
    ('q1-requests-last-left-empty', S,
     'for (uint32_t q = 0; q < requests->count; q += 1)',
     'for (uint32_t q = 0; q + 1 < requests->count; q += 1)'),
]
