#!/usr/bin/env python3
# abl-a1.py SRC_DIR: measurement-only ablation of #3577's expression-side checks (A1). Each check's test is made opaque
# (BUSTER_ABL: cc->pos == UINT32_MAX, never true, not foldable), main's own checks kept; sqlite3.c's object must stay
# the head's. Applies each replacement exactly once or fails.
import sys

src_dir = sys.argv[1]
path = src_dir + '/src/buster/compiler/c_direct_cc.c'
s = open(path).read()


def rep(old, new, count=1):
    global s
    n = s.count(old)
    if n != count:
        sys.exit('replacement applies %d times, wanted %d: %r' % (n, count, old[:120]))
    s = s.replace(old, new)


# The opaque test, defined before its first use (beside the condition macros).
rep('// (A comparison\'s flags, 58% of sqlite3.c\'s 20,000 conditions, are tested first, alone.)\n',
    '#define BUSTER_ABL(cc) ((cc)->pos == UINT32_MAX)\n'
    '// (A comparison\'s flags, 58% of sqlite3.c\'s 20,000 conditions, are tested first, alone.)\n')

# Conditions (-Wpointer-bool-conversion and kin): quiet.
rep('#define BUSTER_FAST_CONDITION_QUIET(cc, v) \\\n'
    '    ((v)->kind == FVAL_FLAGS || BUSTER_FAST_CONDITION_SUSPECT(v) == 0 || BUSTER_FAST_CONDITION_EXACT(cc, v))\n',
    '#define BUSTER_FAST_CONDITION_QUIET(cc, v) (!BUSTER_ABL(cc) || BUSTER_FAST_CONDITION_SUSPECT(v) == 0 || BUSTER_FAST_CONDITION_EXACT(cc, v))\n')

# -Wunsequenced's counting of modifications.
rep('        const uint32_t seq_plain = (v)->seq_ident; \\\n'
    '        (ex)->seq_mod_ids[(ex)->seq_mod_count & 3u] = seq_plain; \\\n'
    '        (ex)->seq_mod_count += (uint32_t)(seq_plain != 0); \\\n',
    '        (void)(v); \\\n')

# The implicit conversion: main's gate (a pointer on either side calls the full check).
rep('    if (dt != BUSTER_FTYPE_UNQUAL(st))\n'
    '    {\n'
    '        const uint32_t small_integer',
    '    if (((uint32_t)ftype_is_ptr(dst_t) | (uint32_t)ftype_is_ptr(st)) != 0) { fast_cc_check_implicit_conv_full(cc, dst_t, src); }\n'
    '    if (BUSTER_ABL(cc) && dt != BUSTER_FTYPE_UNQUAL(st))\n'
    '    {\n'
    '        const uint32_t small_integer')

# Stores and arguments call the gate as main does (no own-type shortcut, which only saves the #3577 checks' call).
rep('    if (BUSTER_FAST_CONV_OWN(lhs->type, rhs) == 0)\n    {\n        fast_cc_check_implicit_conv(cc, lhs->type, rhs);\n    }\n',
    '    fast_cc_check_implicit_conv(cc, lhs->type, rhs);\n')
rep('    if (((uint32_t)(lhs->kind == FVAL_BITFIELD) & ((uint32_t)(rhs->kind == FVAL_IMM) | (uint32_t)((rhs->marks & BUSTER_FVAL_MARK_CONST_ARMS) != 0))) != 0 &&\n'
    '        !fast_cc_bitfield_constant_quiet(cc, lhs, rhs))\n',
    '    if (BUSTER_ABL(cc) && ((uint32_t)(lhs->kind == FVAL_BITFIELD) & ((uint32_t)(rhs->kind == FVAL_IMM) | (uint32_t)((rhs->marks & BUSTER_FVAL_MARK_CONST_ARMS) != 0))) != 0 &&\n'
    '        !fast_cc_bitfield_constant_quiet(cc, lhs, rhs))\n')
rep('            if (BUSTER_FAST_CONV_OWN(pt, &args[i]) == 0)\n            {\n                fast_cc_check_implicit_conv(cc, pt, &args[i]);\n',
    '            {\n                fast_cc_check_implicit_conv(cc, pt, &args[i]);\n')

# The binary operators' operand checks: the gate and its out-of-line check.
rep('    bool asked = (integers == 0) || ((kinds >> FVAL_BITFIELD) & 1u) != 0;\n',
    '    bool asked = BUSTER_ABL(cc) && ((integers == 0) || ((kinds >> FVAL_BITFIELD) & 1u) != 0);\n')
rep('    if (!asked && ((UINT64_C(1) << (op & 63u)) & BUSTER_FAST_COMPARISON_OPS) != 0)\n    {\n        if ((kinds &',
    '    if (BUSTER_ABL(cc) && !asked && ((UINT64_C(1) << (op & 63u)) & BUSTER_FAST_COMPARISON_OPS) != 0)\n    {\n        if ((kinds &')

# Unary operands.
rep('        if (((uint32_t)(op == FEOP_SIZEOF_UNARY) | ((uint32_t)(allowed != 15u) & ((integer_scalar & allowed & 1u) ^ 1u))) != 0)\n',
    '        if (BUSTER_ABL(cc) && ((uint32_t)(op == FEOP_SIZEOF_UNARY) | ((uint32_t)(allowed != 15u) & ((integer_scalar & allowed & 1u) ^ 1u))) != 0)\n')

# An assignment's record with a const member, and its unevaluated operand (main checked an lvalue and const).
rep('        if (((uint32_t)(lhs->type >> 31) & (uint32_t)((lhs->type & BUSTER_FTYPE_PTR_MASK) == 0)) != 0)\n        {\n            record_const',
    '        if (BUSTER_ABL(cc) && ((uint32_t)(lhs->type >> 31) & (uint32_t)((lhs->type & BUSTER_FTYPE_PTR_MASK) == 0)) != 0)\n        {\n            record_const')

# Precedence (-Wparentheses' family) and a string literal's `+`.
rep('    if ((((lclass | rclass) & fast_expr_conflicts_any[tok & 127u]) | (lclass & fast_expr_conflicts_left[tok & 127u])) != 0)\n',
    '    if (BUSTER_ABL(cc) && (((lclass | rclass) & fast_expr_conflicts_any[tok & 127u]) | (lclass & fast_expr_conflicts_left[tok & 127u])) != 0)\n')
rep('    if ((literal_operand & (uint32_t)(tok == FTOK_PLUS)) != 0)\n',
    '    if (BUSTER_ABL(cc) && (literal_operand & (uint32_t)(tok == FTOK_PLUS)) != 0)\n')

# A name's marks: purity, an enumerator's enum and the -Wunsequenced identity.
rep('                    uint8_t push_marks = sym->push_marks;\n'
    '                    if (__builtin_expect((push_marks & BUSTER_FSYM_PUSH_UNASKED) != 0, 0)) { push_marks = fast_cc_library_pure_query(cc, sym); }\n',
    '                    uint8_t push_marks = 0;\n'
    '                    if (BUSTER_ABL(cc)) { push_marks = fast_cc_library_pure_query(cc, sym); }\n')
rep('                            (uint64_t)(osym | (sym->sec_off & (UINT32_C(0) - enumerator))),\n'
    '                            BUSTER_FVAL_WORD_TAIL(push_marks, id),\n',
    '                            (uint64_t)(osym | ((sym->sec_off & (UINT32_C(0) - enumerator)) & (UINT32_C(0) - (uint32_t)BUSTER_ABL(cc)))),\n'
    '                            BUSTER_FVAL_WORD_TAIL(push_marks, 0u),\n')

# A subscript's index and element checks.
rep('            if ((((elem >> 31) | void_elem | (plain_index ^ 1u)) & 1u) != 0 &&\n',
    '            if (BUSTER_ABL(cc) && (((elem >> 31) | void_elem | (plain_index ^ 1u)) & 1u) != 0 &&\n')

# The expression's end: -Wunsequenced, an assignment or a parenthesized equality as a condition, a discarded value.
rep('        if (ex.seq_mod_count != 0 && ((uint32_t)(ex.seq_mod_count != 1u)',
    '        if (BUSTER_ABL(cc) && ex.seq_mod_count != 0 && ((uint32_t)(ex.seq_mod_count != 1u)')
rep('        if (final_v->op == FTOK_ASSIGN) { fast_cc_bail(cc, "assignment as a condition"); return; }\n'
    '        if (cc->tk[ex.seq_start_pos] == FTOK_LPAREN && fast_cc_parentheses_equality(cc, ex.seq_start_pos, cc->pos))\n',
    '        if (BUSTER_ABL(cc) && final_v->op == FTOK_ASSIGN) { fast_cc_bail(cc, "assignment as a condition"); return; }\n'
    '        if (BUSTER_ABL(cc) && cc->tk[ex.seq_start_pos] == FTOK_LPAREN && fast_cc_parentheses_equality(cc, ex.seq_start_pos, cc->pos))\n')
rep('    else if (discard_result && (final_v->marks & (BUSTER_FVAL_MARK_EFFECT | BUSTER_FVAL_MARK_UNUSED_RESULT)) != BUSTER_FVAL_MARK_EFFECT &&\n',
    '    else if (BUSTER_ABL(cc) && discard_result && (final_v->marks & (BUSTER_FVAL_MARK_EFFECT | BUSTER_FVAL_MARK_UNUSED_RESULT)) != BUSTER_FVAL_MARK_EFFECT &&\n')

open(path, 'w').write(s)
print('A1 applied')
