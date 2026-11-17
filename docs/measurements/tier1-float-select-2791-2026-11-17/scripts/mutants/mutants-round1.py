import sys
S = 'src/buster/compiler/tier1_select.c'
B = 'src/buster/compiler/tier1_select_burs.c'
M = [
    ('M1 parity cmovp->cmovnp', S, 'const uint16_t parity = width == 8 ? X86_FORM_CMOVP_R64_RM64 : X86_FORM_CMOVP_R32_RM32;', 'const uint16_t parity = width == 8 ? X86_FORM_CMOVNP_R64_RM64 : X86_FORM_CMOVNP_R32_RM32;'),
    ('M2 scratch path cmove->cmovne', S, 'tier1_select_append(&result, tier1_select_register_record(moves[IR_EQ], destination, equal));', 'tier1_select_append(&result, tier1_select_register_record(moves[IR_NE], destination, equal));'),
    ('M3 ordered inverse not negated', S, 'moves[inverse ? tier1_select_negations[condition] : condition]', 'moves[inverse ? condition : condition]'),
    ('M4 eq/ne through links', S, 'tested == a || (function->op[a] == IR_COPY && function->a[a] == tested)', 'tested == a || (function->op[a] == IR_COPY || function->a[a] != tested)'),
    ('M5 grammar copy derives no FCOND', B, '{ TIER1_BURS_FCOND, TIER1_BURS_FAMILY_COPY_TRUTH, 0, { TIER1_BURS_FCMP,', '{ TIER1_BURS_ZCOND, TIER1_BURS_FAMILY_COPY_TRUTH, 0, { TIER1_BURS_FCMP,'),
    ('M6 walk passes no fcmp copy', S, "function->op[function->a[value]] == IR_FCMP &&\n                            tier1_select_tree_child(forest, root, value);", "function->op[function->a[value]] != IR_FCMP &&\n                            tier1_select_tree_child(forest, root, value);"),
    ('M7 vector copy class of icmp', B, '_mm512_cmpeq_epi32_mask(_mm512_and_si512(a_word, byte), _mm512_set1_epi32(IR_FCMP));', '_mm512_cmpeq_epi32_mask(_mm512_and_si512(a_word, byte), _mm512_set1_epi32(IR_ICMP));'),
    ('M8 vector fcmp_eq class misses ne', B, '_mm512_cmple_epu32_mask(c, _mm512_set1_epi32(IR_NE));', '_mm512_cmple_epu32_mask(c, _mm512_set1_epi32(IR_EQ));'),
    ('M9 eq tie keeps the false value', S, 'fused ? pattern->values[3] : equality ? pattern->values[2] : BUSTER_IR_NONE;', 'fused ? pattern->values[3] : equality ? pattern->values[3] : BUSTER_IR_NONE;'),
    ('M10 scalar copy class past a node', B, 'op == IR_COPY && type == IR_I1 && a + 1 == node && function->op[a] == IR_FCMP', 'op == IR_COPY && type == IR_I1 && (a + 1 == node || a + 2 == node) && function->op[a] == IR_FCMP'),
    ('M11 eq candidate cost 3', S, 'folded.intrinsic_cost = folded.condition == IR_EQ || folded.condition == IR_NE ? 4 : 3;', 'folded.intrinsic_cost = folded.condition == IR_EQ || folded.condition == IR_NE ? 3 : 3;'),
    ('M12 scratch path never taken', S, 'if (destination == other && other != equal)', 'if (destination == other && other == equal)'),
    ('M13 eq/ne predicate swapped', S, 'const uint8_t condition = equal ? (uint8_t)predicate : predicate == IR_LT', 'const uint8_t condition = equal ? (uint8_t)(predicate ^ 1u) : predicate == IR_LT'),
]
action = sys.argv[1]
if action == 'count':
    print(len(M))
    sys.exit(0)
k = int(sys.argv[2])
name, f, old, new = M[k]
if action == 'name':
    print(name)
    sys.exit(0)
s = open(f).read()
if action == 'apply':
    assert s.count(old) == 1 and s.count(new) == 0, (name, 'apply', s.count(old), s.count(new))
    s = s.replace(old, new)
elif action == 'revert':
    assert s.count(new) == 1 and s.count(old) == 0, (name, 'revert')
    s = s.replace(new, old)
open(f, 'w').write(s)
