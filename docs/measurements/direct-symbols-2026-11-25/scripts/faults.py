import subprocess, sys
B = '/home/user/buster'
D = B + '/src/buster/compiler/'
F = {'lex': D + 'c_direct_lex.c', 'types': D + 'c_direct_types.c', 'cc': D + 'c_direct_cc.c', 'drv': D + 'c_checker_driver.c'}
O = {k: subprocess.run(['git', 'show', 'HEAD:src/buster/compiler/' + v.split('/')[-1]], cwd=B, capture_output=True, text=True).stdout for k, v in F.items()}
M = [
 ('coded-prefix-ignored', 'lex', 'bool coded = prefix_kind != 0;', 'bool coded = prefix_kind == 99;'),
 ('coded-hex-octal-ignored', 'lex', "(*q == 'x' || (*q >= '0' && *q <= '7') || *q == 'u' || *q == 'U')", "(*q == 'u' || *q == 'U')"),
 ('coded-octal-ignored', 'lex', "(*q == 'x' || (*q >= '0' && *q <= '7') || *q == 'u' || *q == 'U')", "(*q == 'x' || *q == 'u' || *q == 'U')"),
 ('coded-not-marked', 'lex', 'pp->lit_coded[tok_data >> 6] |= UINT64_C(1) << (tok_data & 63u);', 'pp->lit_coded[tok_data >> 6] |= UINT64_C(0) << (tok_data & 63u);'),
 ('plain-always', 'types', 'return ((cc->pp->lit_coded[literal >> 6] >> (literal & 63u)) & 1u) == 0;', 'return ((cc->pp->lit_coded[literal >> 6] >> (literal & 63u)) & 1u) != 2u;'),
 ('visibility-default-refused', 'types', 'if (sl.length == 7u && memcmp(vs, "default", 7) == 0) { visibility = STV_DEFAULT; }', 'if (sl.length == 7u && memcmp(vs, "default", 7) == 0) { visibility = UINT8_MAX; }'),
 ('internal-is-default', 'types', 'else if (sl.length == 8u && memcmp(vs, "internal", 8) == 0) { visibility = STV_HIDDEN; }', 'else if (sl.length == 8u && memcmp(vs, "internal", 8) == 0) { visibility = STV_DEFAULT; }'),
 ('visibility-rparen-unchecked', 'types', 'if (attr != NULL && fast_cc_peek(cc) == FTOK_STR_LIT && fast_cc_peek_at(cc, 1u) == FTOK_RPAREN &&', 'if (attr != NULL && fast_cc_peek(cc) == FTOK_STR_LIT &&'),
 ('visibility-plain-unchecked', 'types', '                        fast_cc_literal_plain(cc, fast_cc_data(cc)))\n                    {\n                        const FastLitSlice sl = cc->pp->lit_slices[fast_cc_data(cc)];\n                        const char* vs', '                        cc->pos != UINT32_MAX)\n                    {\n                        const FastLitSlice sl = cc->pp->lit_slices[fast_cc_data(cc)];\n                        const char* vs'),
 ('visibility-not-set', 'types', 'attr->visibility_set = 1u;', 'attr->visibility_set = 0u;'),
 ('gnu-inline-ignored', 'types', 'if (attr != NULL) { attr->gnu_inline = 1u; }', 'if (attr != NULL) { attr->gnu_inline = 0u; }'),
 ('label-length-last', 'types', '            length += bytes;', '            length = bytes;'),
 ('label-empty-ok', 'types', 'else if (fast_cc_peek(cc) == FTOK_RPAREN && length != 0 && plain)', 'else if (fast_cc_peek(cc) == FTOK_RPAREN && plain)'),
 ('label-plain-unchecked', 'types', 'plain = plain && fast_cc_literal_plain(cc, literal);', 'plain = plain || fast_cc_literal_plain(cc, literal);'),
 ('label-single-first', 'types', 'piece = bytes != 0 ? cc->pos : piece;', 'piece = bytes != 0 && pieces == 0u ? cc->pos : piece;'),
 ('reference-readies-pending', 'cc', 'if (!sym->referenced && (sym->inline_rules & BUSTER_FINLINE_PENDING) == 0)', 'if (!sym->referenced)'),
 ('join-plain-missing', 'cc', 'rules |= (ds->is_inline && !ds->is_extern) ? BUSTER_FINLINE_PLAIN : 0u;', 'rules |= (ds->is_inline && !ds->is_extern) ? 0u : 0u;'),
 ('join-external-missing', 'cc', 'rules |= (!body && (!ds->is_inline || ds->is_extern)) ? BUSTER_FINLINE_EXTERNAL : 0u;', 'rules |= (!body && (!ds->is_inline || ds->is_extern)) ? 0u : 0u;'),
 ('join-gnu-missing', 'cc', 'rules |= (ds->attr.gnu_inline || dr->attr.gnu_inline) ? BUSTER_FINLINE_GNU : 0u;', 'rules |= ds->attr.gnu_inline ? BUSTER_FINLINE_GNU : 0u;'),
 ('join-declarator-visibility-first', 'cc', '.visibility = dr->attr.visibility_set ? dr->attr.visibility : ds->attr.visibility,', '.visibility = ds->attr.visibility_set ? ds->attr.visibility : dr->attr.visibility,'),
 ('conflict-visibility-ignored', 'cc', 'if ((revisits && sym->visibility_set != 0) || (relabels && sym->asm_name != NULL))', 'if (relabels && sym->asm_name != NULL)'),
 ('conflict-label-ignored', 'cc', 'if ((revisits && sym->visibility_set != 0) || (relabels && sym->asm_name != NULL))', 'if (revisits && sym->visibility_set != 0)'),
 ('after-use-ignored', 'cc', 'else if (changes && sym->obj_sym != 0)', 'else if (changes && sym->obj_sym == UINT32_MAX)'),
 ('gnu-after-definition-ok', 'cc', 'else if ((join->inline_rules & BUSTER_FINLINE_GNU) != 0 && (sym->inline_rules', 'else if ((join->inline_rules & 64u) != 0 && (sym->inline_rules'),
 ('join-weak-dropped', 'cc', 'sym->is_weak |= join->weak;', 'sym->is_weak |= join->weak & 2u;'),
 ('join-visibility-dropped', 'cc', 'sym->visibility = join->visibility_set != 0 ? join->visibility : sym->visibility;', 'sym->visibility = join->visibility_set == 0xffu ? join->visibility : sym->visibility;'),
 ('join-label-dropped', 'cc', 'sym->asm_name = join->label != NULL ? join->label : sym->asm_name;', 'sym->asm_name = join->label == (const char*)1 ? join->label : sym->asm_name;'),
 ('join-rules-dropped', 'cc', 'sym->inline_rules |= join->inline_rules;', 'sym->inline_rules |= join->inline_rules & 64u;'),
 ('decide-c99-by-plain', 'cc', '((rules & BUSTER_FINLINE_C99_PENDING) != 0 && (rules & BUSTER_FINLINE_EXTERNAL) != 0)', '((rules & BUSTER_FINLINE_C99_PENDING) != 0 && (rules & BUSTER_FINLINE_PLAIN) != 0)'),
 ('decide-gnu-by-external', 'cc', '((rules & BUSTER_FINLINE_GNU_PENDING) != 0 && (rules & BUSTER_FINLINE_PLAIN) != 0)', '((rules & BUSTER_FINLINE_GNU_PENDING) != 0 && (rules & BUSTER_FINLINE_EXTERNAL) != 0)'),
 ('pending-allows-any', 'cc', 'if (cc->syms[si].defined != 0 || (pending != 0 && (pending != BUSTER_FINLINE_GNU_PENDING || ds.is_inline)))', 'if (cc->syms[si].defined != 0 || (pending != 0 && pending == 0xffu))'),
 ('internal-static-only', 'cc', 'const bool internal = storage == 1u || storage == 4u;', 'const bool internal = storage == 4u;'),
 ('decide-gnu-plain', 'cc', 'gnu && ds.is_extern ? (uint8_t)BUSTER_FINLINE_GNU_PENDING :', 'gnu && !ds.is_extern ? (uint8_t)BUSTER_FINLINE_GNU_PENDING :'),
 ('decide-c99-extern', 'cc', '!gnu && !ds.is_extern ? (uint8_t)BUSTER_FINLINE_C99_PENDING : 0u;', '!gnu && ds.is_extern ? (uint8_t)BUSTER_FINLINE_C99_PENDING : 0u;'),
 ('referenced-readies-pending-def', 'cc', 'if (cc->syms[si].referenced && decide == 0) { fast_cc_ready_task(cc, deferred_count); }', 'if (cc->syms[si].referenced) { fast_cc_ready_task(cc, deferred_count); }'),
 ('block-local-hides-ok', 'cc', 'if (dr.name_id == 0 || cc->syms[seen].kind != kind ||', 'if (dr.name_id == 0 || cc->syms[seen].kind == 0 ||'),
 ('block-unseen-ok', 'cc', 'if (dr.name_id == 0 || cc->syms[seen].kind != kind ||', 'if (dr.name_id == 0 || (cc->syms[seen].kind != kind && seen != 0) ||'),
 ('block-label-ok', 'cc', 'ds.is_static || dr.attr.asm_label != NULL || ds.attr.visibility_set', 'ds.is_static || ds.attr.visibility_set'),
 ('block-static-object-ok', 'cc', '(kind == FSYM_GLOBAL && cc->syms[seen].storage == 1u) ||', '(kind == FSYM_GLOBAL && cc->syms[seen].storage == 7u) ||'),
 ('typedef-declarator-visibility-ok', 'cc', "#3595)\n            if (ds.is_typedef && (ds.attr.visibility_set || dr.attr.visibility_set))", "#3595)\n            if (ds.is_typedef && ds.attr.visibility_set)"),
 ('block-typedef-visibility-ok', 'cc', '                if (ds.is_typedef && (ds.attr.visibility_set || dr.attr.visibility_set))', '                if (ds.is_typedef && ds.attr.visibility_set)'),
]
def restore():
    for k in F:
        if open(F[k]).read() != O[k]:
            open(F[k], 'w').write(O[k])
only = sys.argv[1:]
for name, which, old, new in M:
    if only and name not in only:
        continue
    src = O[which]
    if src.count(old) != 1:
        print(f'{name}: PATTERN {src.count(old)}', flush=True)
        continue
    restore()
    open(F[which], 'w').write(src.replace(old, new))
    b = subprocess.run(['./build.sh', '--config', 'Release'], cwd=B, capture_output=True, text=True)
    if b.returncode != 0:
        print(f'{name}: BUILD FAILED {b.returncode}: {(b.stdout + b.stderr)[-300:]}', flush=True)
        continue
    try:
        t = subprocess.run(['./build/compiler', 'test-direct'], cwd=B, capture_output=True, text=True, timeout=600)
        out = (t.stdout + t.stderr).strip().splitlines()
        print(f"{name}: {'KILLED' if t.returncode != 0 else 'SURVIVED'} (status {t.returncode}) {' | '.join(out[-3:])[:240]}", flush=True)
    except subprocess.TimeoutExpired:
        print(f'{name}: KILLED (timeout)', flush=True)
restore()
b = subprocess.run(['./build.sh', '--config', 'Release'], cwd=B, capture_output=True, text=True)
t = subprocess.run(['./build/compiler', 'test-direct'], cwd=B, capture_output=True, text=True)
print('restored:', b.returncode, t.stdout.strip(), t.stderr.strip()[-200:])
