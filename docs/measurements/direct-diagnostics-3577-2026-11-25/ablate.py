#!/usr/bin/env python3
# abl2.py TREE VARIANT: a scratch kill switch over TREE's direct-path sources (measurement only, not semantics-preserving).
import re, sys
tree, variant = sys.argv[1], sys.argv[2]
cc = tree + '/src/buster/compiler/c_direct_cc.c'
lex = tree + '/src/buster/compiler/c_direct_lex.c'
def edit(path, fn):
    s = open(path).read()
    t = fn(s)
    assert t != s, (variant, path)
    open(path, 'w').write(t)
def macro(s, name, replacement):
    m = re.search(r'#define ' + re.escape(name) + r'\(([^)]*)\)', s)
    assert m, name
    end = s.index('\n', m.end())
    while s[end - 1] == '\\':
        end = s.index('\n', end + 1)
    return s[:m.start()] + '#define ' + name + '(' + m.group(1) + ') ' + replacement + s[end:]
def rep(s, old, new):
    assert s.count(old) == 1, (variant, old[:80], s.count(old))
    return s.replace(old, new)
if variant == 'seq':
    def f(s):
        s = macro(s, 'BUSTER_FSEQ_NAME', '{ (void)(identity); (void)(logged); }')
        s = macro(s, 'BUSTER_FSEQ_REGION', '((void)(lo), (void)(mid), (void)(hi))')
        s = macro(s, 'BUSTER_FSEQ_MARK', '((void)(ex), (uint8_t)0)')
        s = macro(s, 'BUSTER_FSEQ_BELOW', '((void)(ops), (void)(osp), (uint8_t)0)')
        s = macro(s, 'BUSTER_FSEQ_MODIFY', '{ (void)(v); }')
        return s
    edit(cc, f)
elif variant == 'push':
    def f(s):
        s = rep(s, '''                    if (__builtin_expect(function & (uint32_t)(library == 0), 0)) { library = fast_cc_library_pure_query(cc, sym); }
''', '''                    if (cc->pos == UINT32_MAX) { library = fast_cc_library_pure_query(cc, sym); }
''')
        s = rep(s, '''                            .marks = (uint8_t)((BUSTER_FVAL_MARK_NONLITERAL * enumerator) | (BUSTER_FVAL_MARK_PURE * (function & (uint32_t)(library == 2u)))),
''', '''                            .marks = (uint8_t)((library == 7u) & (enumerator == 9u)),
''')
        s = rep(s, '''                            .sym_idx = osym | (sym->sec_off & (UINT32_C(0) - enumerator)),''', '''                            .sym_idx = osym,''')
        return s
    edit(cc, f)
elif variant == 'binops':
    edit(cc, lambda s: rep(s, '''    if (((integers ^ 1u) | compared | bit_field) != 0)''', '''    if ((((integers ^ 1u) | compared | bit_field) & (uint32_t)(cc->pos == UINT32_MAX)) != 0)'''))
elif variant == 'unary':
    def f(s):
        s = rep(s, '''            if (((uint32_t)(op == FEOP_SIZEOF_UNARY) | ((uint32_t)(allowed != 15u) & ((integer_scalar & allowed & 1u) ^ 1u))) != 0)''',
                   '''            if ((((uint32_t)(op == FEOP_SIZEOF_UNARY) | ((uint32_t)(allowed != 15u) & ((integer_scalar & allowed & 1u) ^ 1u))) & (uint32_t)(cc->pos == UINT32_MAX)) != 0)''')
        s = rep(s, '''    if ((((lclass | rclass) & fast_expr_conflicts_any[tok & 127u]) | (lclass & fast_expr_conflicts_left[tok & 127u])) != 0)''',
                   '''    if (((((lclass | rclass) & fast_expr_conflicts_any[tok & 127u]) | (lclass & fast_expr_conflicts_left[tok & 127u])) & (uint32_t)(cc->pos == UINT32_MAX)) != 0)''')
        return s
    edit(cc, f)
elif variant == 'cond':
    def f(s):
        s = macro(s, 'BUSTER_FAST_CONDITION_QUIET', '((void)(cc), (void)(v), true)')
        s = rep(s, '''        if (BUSTER_FAST_DISCARD_QUIET(final_v) == 0) { fast_cc_bail(cc, "discarded value"); return; }''',
                   '''        if (cc->pos == UINT32_MAX && BUSTER_FAST_DISCARD_QUIET(final_v) == 0) { fast_cc_bail(cc, "discarded value"); return; }''')
        return s
    edit(cc, f)
elif variant == 'conv':
    def f(s):
        return rep(s, '''    if (dt == BUSTER_FTYPE_UNQUAL(st))
    {
        return;
    }
    // #3577: a constant's''', '''    if (dt == BUSTER_FTYPE_UNQUAL(st) || cc->pos != UINT32_MAX)
    {
        return;
    }
    // #3577: a constant's''')
    edit(cc, f)
else:
    raise SystemExit('unknown variant ' + variant)
