import subprocess, sys, os, shutil, concurrent.futures
SRC = '/home/user/buster-6c/src/buster/compiler'
CL = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
OUT = '/tmp/claude-0/faults12'
M = [
 ('pretty-paren-never', 'pr', "else if (d->kind == BUSTER_FPRETTY_PAREN && !empties[i - 1u] && inner != BUSTER_FPRETTY_FUNCTION)", "else if (d->kind == BUSTER_FPRETTY_PAREN && !empties[i - 1u] && inner != BUSTER_FPRETTY_FUNCTION && false)"),
 ('pretty-array-paren-never', 'pr', "            if (inner == BUSTER_FPRETTY_ARRAY)\n            {\n                fast_pretty_putc(p, '(');", "            if (inner == BUSTER_FPRETTY_ARRAY && false)\n            {\n                fast_pretty_putc(p, '(');"),
 ('pretty-quals-swapped', 'pr', "        fast_pretty_put(p, \"const\", 5u);", "        fast_pretty_put(p, \"volatile\", 8u);"),
 ('pretty-quals-no-space', 'pr', "    if (written && space)\n", "    if (written && space && false)\n"),
 ('pretty-no-array-adjust', 'pr', "    if (first < t->count && t->derivations[first].kind == BUSTER_FPRETTY_ARRAY)\n", "    if (first < t->count && t->derivations[first].kind == BUSTER_FPRETTY_ARRAY && false)\n"),
 ('pretty-array-quals-lost', 'pr', "        const uint8_t qualifiers = t->derivations[first].qualifiers;\n", "        const uint8_t qualifiers = 0u * t->derivations[first].qualifiers;\n"),

 ('pretty-va-list-unadjusted', 'pr', "    else if (first == t->count && t->va_list != 0)\n", "    else if (first == t->count && t->va_list != 0 && false)\n"),
 ('pretty-function-typedef-unadjusted', 'pr', "    else if (first == t->count && t->function_typedef != 0)\n", "    else if (first == t->count && t->function_typedef != 0 && false)\n"),
 ('pretty-unsigned-short', 'pr', "longs == 0 ? (unsigned_type ? \"unsigned int\" : \"int\") :", "longs == 0 ? (unsigned_type ? \"unsigned\" : \"int\") :"),
 ('pretty-long-long-as-long', 'pr', "longs == 2 ? (unsigned_type ? \"unsigned long long\" : \"long long\") : NULL;", "longs == 2 ? (unsigned_type ? \"unsigned long\" : \"long\") : NULL;"),
 ('pretty-bool-c23-ignored', 'pr', "keyword == FTOK_KW_FLOAT ? \"float\" : c23 ? \"bool\" : \"_Bool\";", "keyword == FTOK_KW_FLOAT ? \"float\" : (c23 && false) ? \"bool\" : \"_Bool\";"),
 ('pretty-c23-empty-ignored', 'pr', "function->prototyped = (uint8_t)(list.first != list.end || cc->pp->c23);", "function->prototyped = (uint8_t)(list.first != list.end);"),
 ('pretty-variadic-no-comma', 'pr', "                    fast_pretty_put(p, f->printed != 0 ? \", ...\" : \"...\", f->printed != 0 ? 5u : 3u);", "                    fast_pretty_put(p, \"...\", 3u);"),
 ('pretty-own-variadic-no-comma', 'pr', "                    fast_pretty_put(p, printed ? \", ...\" : \"...\", printed ? 5u : 3u);", "                    fast_pretty_put(p, \"...\", 3u);"),
 ('pretty-void-never', 'pr', "                else if (!printed && own_function.prototyped != 0)\n", "                else if (!printed && own_function.prototyped != 0 && false)\n"),
 ('pretty-redundant-accepted', 'pr', "            needed &= inner == BUSTER_FPRETTY_POINTER && (outer == BUSTER_FPRETTY_ARRAY || outer == BUSTER_FPRETTY_FUNCTION);", "            needed &= true || inner == outer;"),
 ('pretty-declared-empty-accepted', 'pr', "!fast_pretty_parentheses_needed(t, own + 1u) || (empty_list && cc->cur_func_declared != 0))", "!fast_pretty_parentheses_needed(t, own + 1u) || (empty_list && cc->cur_func_declared != 0 && false))"),
 ('pretty-name-paren-accepted', 'pr', "if (name != cc->cur_func_name_id || own != 0 || t->count == 0", "if (name != cc->cur_func_name_id || (own != 0 && false) || t->count == 0"),
 ('pretty-param-attribute-accepted', 'pr', "                if ((parameter && !unused) || makes_type)\n", "                if (makes_type && !unused)\n"),
 ('pretty-typedef-array-accepted', 'pr', "            if (ftype_is_array(type) && type != cc->va_list_type)\n", "            if (ftype_is_array(type) && type != cc->va_list_type && false)\n"),
 ('pretty-bound-expression-accepted', 'pr', "                if (fast_pretty_kind(p, p->pos, end) != FTOK_RBRACKET || (bounded && bound == UINT32_MAX))\n                {\n                    fast_pretty_fail(p);\n                }\n                p->pos += 1u;", "                while (p->pos < end && fast_pretty_kind(p, p->pos, end) != FTOK_RBRACKET) { p->pos += 1u; }\n                p->pos += 1u;"),
 ('pretty-shadow-not-file-scope', 'pr', "        if (cc->undo[i].is_tag == 0 && cc->undo[i].ident_id == id)\n", "        if (cc->undo[i].is_tag == 0 && cc->undo[i].ident_id == id && false)\n"),
 ('pretty-cache-kept', 'cc', "    cc->cur_func_body_pos = cc->pos;\n    cc->cur_func_pretty = NULL;\n", "    cc->cur_func_body_pos = cc->pos;\n"),
 ('pretty-deferred-decl-lost', 'cc', "            cc->cur_func_decl_pos = task->decl_start;\n", ""),
 ('pretty-pointer-quals-reversed', 'pr', "        for (uint32_t i = level_end; i > level_first[level] && !p->bad; i -= 1)\n        {\n            fast_pretty_derive(p, t, (FastPrettyDerivation){ .kind = BUSTER_FPRETTY_POINTER, .qualifiers = pointers[i - 1u] });", "        for (uint32_t i = level_first[level]; i < level_end && !p->bad; i += 1)\n        {\n            fast_pretty_derive(p, t, (FastPrettyDerivation){ .kind = BUSTER_FPRETTY_POINTER, .qualifiers = pointers[i] });"),
 ('assert-never-rewritten', 'cc', "                    fast_cc_assert_rewrite(cc, cc->pos);\n", ""),
 ('assert-any-callee', 'cc', "                    td[c + 3u] == cc->id_assert_fail && tk[c + 4u] == FTOK_LPAREN;", "                    tk[c + 4u] == FTOK_LPAREN;"),
 ('assert-arms-swapped', 'cc', "        for (uint32_t i = call_first; i < call_end; i += 1) { kinds[n] = tk[i]; datas[n] = td[i]; n += 1u; }\n        kinds[n] = FTOK_RPAREN; datas[n] = 0; n += 1u;\n        if (n == end - start - 1u)", "        for (uint32_t i = call_first; i < call_end; i += 1) { kinds[n] = tk[i]; datas[n] = td[i]; n += 1u; }\n        kinds[n] = FTOK_RPAREN; datas[n] = 0; n += 1u;\n        kinds[3u + cond_end - cond_first] = FTOK_BANG;\n        if (n == end - start - 1u)"),
 ('assert-tail-unchecked', 'cc', "    shape = shape && call_end + 2u < cc->tcount && tk[call_end] == FTOK_SEMI && tk[call_end + 1u] == FTOK_RBRACE && tk[call_end + 2u] == FTOK_RPAREN;", "    shape = shape && call_end + 2u < cc->tcount && tk[call_end] == FTOK_SEMI;"),
 ('dead-scan-no-rewrite', 'cc', "            fast_cc_assert_rewrite(cc, i - 2u);\n", ""),
 ('round-no-daz', 'cc', "    x86_jcc_label(obj, FCC_NE, zero);\n    fast_label_bind(obj, normal);", "    fast_label_bind(obj, normal);"),
 ('round-nan-unquieted', 'cc', "    x86_sse_rr(obj, is_double, 0x58u, xr, xr);                  // quiets a NaN\n", ""),
 ('round-ceil-floor-swapped', 'cc', "    x86_jcc_label(obj, is_ceil ? FCC_NE : FCC_E, signed_result);", "    x86_jcc_label(obj, is_ceil ? FCC_E : FCC_NE, signed_result);"),
 ('round-threshold-low', 'cc', "    const int32_t integral = is_double ? 0x433 : 0x96;", "    const int32_t integral = is_double ? 0x432 : 0x95;"),
 ('round-small-half', 'cc', "    const uint64_t one = is_double ? UINT64_C(0x3ff0000000000000) : UINT64_C(0x3f800000);", "    const uint64_t one = is_double ? UINT64_C(0x3fe0000000000000) : UINT64_C(0x3f000000);"),
 ('round-no-spill', 'cc', "    fval_spill_all(ex, ex->vsp, ex->arg_sp);\n    const uint32_t xr = fval_to_xmm(ex, &args[0], true);", "    const uint32_t xr = fval_to_xmm(ex, &args[0], true);"),
 ('round-sign-lost', 'cc', "    x86_alu_rr(obj, w, 0x09u, FREG_RDX, FREG_R9);\n", ""),
 ('round-integral-not-kept', 'cc', "    x86_alu_rr(obj, w, 0x85u, FREG_RDX, FREG_R11);\n    x86_jcc_label(obj, FCC_E, same);\n", ""),
 ('round-no-convert', 'cc', "    fval_convert(ex, &args[0], ft);\n    fval_spill_all", "    fval_spill_all"),
 ('round-accepts-pointer', 'cc', "    if (argc != 1u || !(ftype_is_int(args[0].type) || ftype_is_float(args[0].type)) || ftype_is_unsupported(args[0].type))", "    if (argc != 1u || ftype_is_unsupported(args[0].type))"),
 ('frames-64', 'cc', "#define BUSTER_FSTMT_FRAMES 256u", "#define BUSTER_FSTMT_FRAMES 64u"),
 ('frames-unbounded', 'cc', "            if (ssp >= BUSTER_FSTMT_FRAMES) { fast_cc_bail(cc, \"stmt nesting depth\"); break; }\n            cc->pos += 1u;\n            if (fast_cc_peek(cc) != FTOK_LPAREN) { fast_cc_bail(cc, \"expected ( after if\"); break; }", "            cc->pos += 1u;\n            if (fast_cc_peek(cc) != FTOK_LPAREN) { fast_cc_bail(cc, \"expected ( after if\"); break; }"),
]
FILES = {'lex': 'c_direct_lex.c', 'drv': 'c_direct.c', 'cc': 'c_direct_cc.c', 'pr': 'c_direct_pretty.c'}
def one(m):
    name, f, old, new = m
    d = os.path.join(OUT, name)
    shutil.rmtree(d, ignore_errors=True)
    os.makedirs(d + '/src/buster')
    shutil.copytree(SRC, d + '/src/buster/compiler')
    p = d + '/src/buster/compiler/' + FILES[f]
    s = open(p).read()
    n = s.count(old)
    if n != 1:
        shutil.rmtree(d, ignore_errors=True)
        return (name, 'PATTERN %d' % n)
    open(p, 'w').write(s.replace(old, new))
    c = d + '/src/buster/compiler/c_direct.c'
    s = open(c).read().replace('if (c_direct_test_admission())', 'if (true)')
    open(c, 'w').write(s)
    open(d + '/main.c', 'w').write('#include "buster/compiler/c_direct.c"\nint main(void) { return run_c_direct_tests(0, NULL); }\n')
    b = subprocess.run(['nice', CL, '-O1', '-g0', '-march=native', '-I' + d + '/src', '-fwrapv', '-funsigned-char', '-fno-strict-aliasing', '-Wall', '-Werror', '-Wno-unused-function', '-fno-stack-protector', d + '/main.c', '-lpthread', '-o', d + '/h'], capture_output=True, text=True)
    if b.returncode != 0:
        shutil.rmtree(d, ignore_errors=True)
        return (name, 'BUILD ' + b.stderr[:300])
    r = subprocess.run(['nice', 'timeout', '180', d + '/h'], capture_output=True, text=True, cwd=d)
    fails = [l for l in r.stderr.splitlines() if 'FAIL' in l][:3]
    shutil.rmtree(d, ignore_errors=True)
    return (name, ('found(%d): ' % r.returncode + '; '.join(fails)) if r.returncode != 0 else 'SURVIVED')
only = set(sys.argv[1:])
todo = [m for m in M if not only or m[0] in only]
with concurrent.futures.ThreadPoolExecutor(3) as ex:
    for name, verdict in ex.map(one, todo):
        print(name, verdict[:300], flush=True)
