# #2924 C9a: mutants of the IR verifier's vector code, which its scalar twin's comparison used to check. Each is
# (name, file, old, new): a unique text replaced by another unique one, every identifier kept.
F = 'src/buster/compiler/ir.c'
V = 'src/buster/compiler/ir_validate.c'
MUTANTS = [
    # Row checks: an operand's type far outside the 128-type window, from the first 64 types, and from the window's
    # upper half.
    ('r1-far-type', F, 'types[lane] = f->type[values[lane]];', 'types[lane] = f->type[values[lane] - 1];'),
    ('r2-head-types', F, 'head = _mm512_loadu_si512(f->type);', 'head = _mm512_loadu_si512(f->type + 1);'),
    ('r3-window-high', F, 'f->type + base + (window < 64 ? window : 64));', 'f->type + base + (window < 64 ? window : 63));'),
    # Row rules: a shift's count must be an integer, a select's c of the result's type, an access's alignment at most 31.
    ('r4-shift-count', F, 'bad |= shift & (_mm512_cmpneq_epi32_mask(ta, type) | ~b_integer);', 'bad |= shift & (_mm512_cmpneq_epi32_mask(ta, type) & ~b_integer);'),
    ('r5-select-c', F, '| _mm512_cmpneq_epi32_mask(tc, type));', '| _mm512_cmpgt_epu32_mask(tc, type));'),
    ('r6-alignment', F, '_mm512_cmpgt_epu32_mask(align, _mm512_set1_epi32(31)));', '_mm512_cmpgt_epu32_mask(align, _mm512_set1_epi32(32)));'),
    # Dominance batches: a c operand of an earlier block never sent to the exact check; the last lane's earlier uses
    # never sent.
    ('d1-earlier-c', F, 'use_c & _mm512_cmplt_epu32_mask(c, start), c, use_enter, use_leave);', 'use_c & _mm512_cmplt_epu32_mask(c, _mm512_setzero_si512()), c, use_enter, use_leave);'),
    ('d2-earlier-lane-15', F, '        bad &= earlier;\n', '        bad &= earlier & 0x7fff;\n'),
    # The complete verifier's reachable uses: the nested-interval test, and the last partial batch.
    ('d3-use-batch-leave', F, '| _mm512_cmplt_epu32_mask(definition_leave, use_leave));', '| _mm512_cmplt_epu32_mask(definition_leave, _mm512_setzero_si512()));'),
    ('d4-reachable-tail', V, 'if (check.error == IR_OK && batch.count != 0)', 'if (check.error == IR_OK && batch.count > BUSTER_IR_VECTOR_COUNT)'),
    # Graph: the scan for switches; a tail's last operation.
    ('g1-switch-scan', F, '| _mm512_mask_cmpeq_epi8_mask(active, op, _mm512_set1_epi8(IR_SWITCH));', '| _mm512_mask_cmpeq_epi8_mask(active, op, _mm512_set1_epi8(IR_PHI));'),
    ('g2-scan-tail', F, 'const __mmask64 active = remaining >= 64 ? (__mmask64)-1 : ((__mmask64)1 << remaining) - 1;', 'const __mmask64 active = remaining >= 64 ? (__mmask64)-1 : ((__mmask64)1 << remaining) - 1 - ((__mmask64)1 << (remaining - 1));'),
    # Use lists: a fixed operand's column, and a phi's input stride.
    ('u1-fixed-column', F, 'const uint32_t* const columns[4] = { f->a + first, f->b + first, f->c + first, f->c + first };', 'const uint32_t* const columns[4] = { f->a + first, f->b + first, f->b + first, f->c + first };'),
    ('u2-phi-stride', F, 'const uint32_t stride = phi ? 2 : 1;', 'const uint32_t stride = phi ? 2 : 2;'),
    # SIMD scans: a v4i32 type, and v16i32 as a vector.
    ('s1-simd-v4', F, 'const __mmask64 simd = _mm512_mask_cmpge_epu8_mask(active, types, _mm512_set1_epi8(IR_V4I32))', 'const __mmask64 simd = _mm512_mask_cmpge_epu8_mask(active, types, _mm512_set1_epi8(IR_V8I32))'),
    ('s2-vectors-v16', F, '_mm512_set1_epi8(IR_V16I32 + 1));', '_mm512_set1_epi8(IR_V16I32));'),
]
