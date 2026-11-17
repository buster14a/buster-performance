import sys
S = 'src/buster/compiler/tier1_select.c'
B = 'src/buster/compiler/tier1_select_burs.c'
M = [
    ('F1 inverse not negated', S, 'const uint8_t condition = inverse ? tier1_select_negations[holes->condition] : holes->condition;', 'const uint8_t condition = inverse ? holes->condition : holes->condition;'),
    ('F2 strict and non-strict swapped', S, 'const uint8_t condition = predicate == IR_LT || predicate == IR_GT ? IR_UGT : IR_UGE;', 'const uint8_t condition = predicate == IR_LT || predicate == IR_GT ? IR_UGE : IR_UGT;'),
    ('F3 grammar copy derives no FCOND', B, '{ TIER1_BURS_FCOND, TIER1_BURS_FAMILY_COPY_TRUTH, 0, { TIER1_BURS_FCMP,', '{ TIER1_BURS_ZCOND, TIER1_BURS_FAMILY_COPY_TRUTH, 0, { TIER1_BURS_FCMP,'),
    ('F4 walk passes no fcmp copy', S, "function->op[function->a[value]] == IR_FCMP &&\n                 tier1_select_tree_child(forest, root, value))", "function->op[function->a[value]] != IR_FCMP &&\n                 tier1_select_tree_child(forest, root, value))"),
    ('F5 vector copy class of icmp', B, '_mm512_cmpeq_epi32_mask(_mm512_and_si512(a_word, byte), _mm512_set1_epi32(IR_FCMP));', '_mm512_cmpeq_epi32_mask(_mm512_and_si512(a_word, byte), _mm512_set1_epi32(IR_ICMP));'),
    ('F6 scalar copy class past a node', B, 'op == IR_COPY && type == IR_I1 && a + 1 == node && function->op[a] == IR_FCMP', 'op == IR_COPY && type == IR_I1 && (a + 1 == node || a + 2 == node) && function->op[a] == IR_FCMP'),
    ('F7 compare at the select width', S, 'folded.source_width = folded.width;\n            folded.width = base.width;', 'folded.source_width = base.width;\n            folded.width = base.width;'),
    ('F8 no ties for float selects', S, 'const bool fused = rule == TIER1_RULE_SELECT_COMPARE || rule == TIER1_RULE_FLOAT_SELECT_COMPARE;', 'const bool fused = rule == TIER1_RULE_SELECT_COMPARE || (rule == TIER1_RULE_FLOAT_SELECT_COMPARE && pattern->width == 0);'),
    ('F9 ucomis operands swapped', S, 'tier1_select_float_forms(holes->source_width)->compare, holes->left & 15, holes->right & 15', 'tier1_select_float_forms(holes->source_width)->compare, holes->right & 15, holes->left & 15'),
    ('F10 copy not counted folded', S, '            walking = true;\n            pattern->fold_count += 1;', '            walking = true;\n            pattern->fold_count += 0;'),
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
