#!/usr/bin/env python3
# abl4.py TREE VARIANT...: measurement-only kill switches over TREE's direct-path sources (not semantics-preserving).
# Each variant switches one family of #3577's checks off with an opaque test (cc->pos == UINT32_MAX) or drops a store;
# `layout` instead widens main's FastVal (24 -> 32 bytes) and FastExprOp (24 -> 28) to the branch's sizes.
import sys
tree = sys.argv[1]
cc = tree + '/src/buster/compiler/c_direct_cc.c'
def edit(path, pairs, variant):
    s = open(path).read()
    for old, new in pairs:
        n = s.count(old)
        assert n == 1, (variant, old[:90], n)
        s = s.replace(old, new)
    open(path, 'w').write(s)
V = {}
V['seq'] = [
    ('''    if (__builtin_expect((ex)->seq_logging == 0, 1)) \\
    { \\
        const uint32_t seq_plain = (v)->seq_ident; \\
        (ex)->seq_mod_ids[(ex)->seq_mod_count & 3u] = seq_plain; \\
        (ex)->seq_mod_count += (uint32_t)(seq_plain != 0); \\
    } \\''', '''    if (__builtin_expect((ex)->seq_logging == 0, 1)) \\
    { \\
    } \\'''),
    ('''        if (ex.seq_mod_count != 0 && ((uint32_t)(ex.seq_mod_count != 1u)''', '''        if (cc->pos == UINT32_MAX && ex.seq_mod_count != 0 && ((uint32_t)(ex.seq_mod_count != 1u)'''),
]
V['push'] = [
    ('''                    uint8_t push_marks = sym->push_marks;
                    if (__builtin_expect((push_marks & BUSTER_FSYM_PUSH_UNASKED) != 0, 0)) { push_marks = fast_cc_library_pure_query(cc, sym); }
                    const uint32_t enumerator = (uint32_t)(symbol_kind == FSYM_ENUM_CONST);''',
     '''                    uint8_t push_marks = 0;
                    if (cc->pos == UINT32_MAX) { push_marks = fast_cc_library_pure_query(cc, sym); }
                    (void)push_marks;
                    const uint32_t enumerator = (uint32_t)(symbol_kind == FSYM_ENUM_CONST);
                    (void)enumerator;'''),
    ('''                            .sym_idx = osym | (sym->sec_off & (UINT32_C(0) - enumerator)),''', '''                            .sym_idx = osym,'''),
    ('''                            .marks = push_marks,
                            .seq_ident = id,''', ''''''),
]
V['ops'] = [
    ('''            if (osp < 128u) { ops[osp++] = (FastExprOp){ .op = (uint16_t)(FEOP_TOK_BASE + k), .lbl2 = cc->pos, .seq_mid''',
     '''            if (osp < 128u) { ops[osp++] = (FastExprOp){ .op = (uint16_t)(FEOP_TOK_BASE + k), .seq_mid'''),
]
V['binops'] = [
    ('''    if (asked != 0)
    {
        if (!fast_cc_binary_operands_quiet(''', '''    if (asked != 0 && cc->pos == UINT32_MAX)
    {
        if (!fast_cc_binary_operands_quiet('''),
]
V['binops_all'] = [
    ('''    const uint32_t integers = (uint32_t)(((lt | rt) & (BUSTER_FTYPE_COMPLEX_BIT | BUSTER_FTYPE_PTR_MASK)) == 0) &
                              (BUSTER_FAST_INTEGER_KINDS >> (lt & BUSTER_FTYPE_SCALAR_MASK)) & (BUSTER_FAST_INTEGER_KINDS >> (rt & BUSTER_FTYPE_SCALAR_MASK)) & 1u;
    const uint32_t compared = (uint32_t)(((UINT64_C(1) << (op & 63u)) & BUSTER_FAST_COMPARISON_OPS) != 0);
    const uint32_t kinds = (UINT32_C(1) << lhs->kind) | (UINT32_C(1) << rhs->kind);
    uint32_t asked = (integers ^ 1u) | ((kinds >> FVAL_BITFIELD) & 1u);
    if ((asked == 0) & (compared != 0))
    {
        asked = BUSTER_FAST_INT_COMPARE_ASKED(lhs, rhs, lt, rt, kinds) | BUSTER_FAST_SAME_PLACE(lhs, rhs);
    }
    if (asked != 0)
    {''', '''    if (cc->pos == UINT32_MAX)
    {
        const uint32_t integers = 0;'''),
]
V['conv'] = [
    ('''    if (questioned != 0) { fast_cc_check_implicit_conv_full(cc, dst_t, src); }''',
     '''    (void)questioned;
    if (((uint32_t)ftype_is_ptr(dt) | (uint32_t)ftype_is_ptr(st)) != 0) { fast_cc_check_implicit_conv_full(cc, dst_t, src); }'''),
]
V['cond'] = [
    ('''#define BUSTER_FAST_CONDITION_QUIET(cc, v) (BUSTER_FAST_CONDITION_SUSPECT(v) == 0 || BUSTER_FAST_CONDITION_EXACT(cc, v))''',
     '''#define BUSTER_FAST_CONDITION_QUIET(cc, v) ((void)(cc), (void)(v), true)'''),
    ('''        if (BUSTER_FAST_DISCARD_QUIET(final_v) == 0) { fast_cc_bail(cc, "discarded value"); return; }''',
     '''        if (cc->pos == UINT32_MAX && BUSTER_FAST_DISCARD_QUIET(final_v) == 0) { fast_cc_bail(cc, "discarded value"); return; }'''),
    ('''        if (final_v.op == FTOK_ASSIGN) { fast_cc_bail(cc, "assignment as a condition"); return; }
        if (cc->tk[ex.seq_start_pos] == FTOK_LPAREN && fast_cc_parentheses_equality(''',
     '''        if (cc->pos == UINT32_MAX && final_v.op == FTOK_ASSIGN) { fast_cc_bail(cc, "assignment as a condition"); return; }
        if (cc->pos == UINT32_MAX && cc->tk[ex.seq_start_pos] == FTOK_LPAREN && fast_cc_parentheses_equality('''),
]
V['unary'] = [
    ('''            if (((uint32_t)(op == FEOP_SIZEOF_UNARY) | ((uint32_t)(allowed != 15u) & ((integer_scalar & allowed & 1u) ^ 1u))) != 0)''',
     '''            if ((((uint32_t)(op == FEOP_SIZEOF_UNARY) | ((uint32_t)(allowed != 15u) & ((integer_scalar & allowed & 1u) ^ 1u))) & (uint32_t)(cc->pos == UINT32_MAX)) != 0)'''),
    ('''    if ((((lclass | rclass) & fast_expr_conflicts_any[tok & 127u]) | (lclass & fast_expr_conflicts_left[tok & 127u])) != 0)''',
     '''    if (((((lclass | rclass) & fast_expr_conflicts_any[tok & 127u]) | (lclass & fast_expr_conflicts_left[tok & 127u])) & (uint32_t)(cc->pos == UINT32_MAX)) != 0)'''),
]
V['layout'] = [
    ('''    uint8_t bf_signed;
};

_Static_assert(sizeof(FastVal) == 24u, "expression stack entry size");''', '''    uint8_t bf_signed;
    uint64_t measurement_pad;
};

_Static_assert(sizeof(FastVal) == 32u, "expression stack entry size");'''),
    ('''    int32_t slot;          // tern_slot or compound lit stack slot
};''', '''    int32_t slot;          // tern_slot or compound lit stack slot
    uint32_t measurement_pad;
};'''),
]
for v in sys.argv[2:]:
    edit(cc, V[v], v)
print('applied', sys.argv[2:])
