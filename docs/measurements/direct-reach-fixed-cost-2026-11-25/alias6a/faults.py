import subprocess, sys
B = '/home/user/buster-6a'
D = B + '/src/buster/compiler/'
F = {'lex': D + 'c_direct_lex.c', 'types': D + 'c_direct_types.c', 'cc': D + 'c_direct_cc.c', 'drv': D + 'c_checker_driver.c'}
O = {k: subprocess.run(['git', 'show', 'HEAD:src/buster/compiler/' + v.split('/')[-1]], cwd=B, capture_output=True, text=True).stdout for k, v in F.items()}
M = [
 ('alias-count-not-kept', 'types', '                    cc->alias_attributes += 1u;', '                    cc->alias_attributes += 0u;'),
 ('alias-plain-unchecked', 'types', """fast_cc_peek_at(cc, 1u) == FTOK_RPAREN &&
                                 fast_cc_literal_plain(cc, fast_cc_data(cc));""", """fast_cc_peek_at(cc, 1u) == FTOK_RPAREN &&
                                 cc->pos != UINT32_MAX;"""),
 ('alias-empty-ok', 'types', '                        named = sl.length != 0;', '                        named = sl.length != UINT32_MAX;'),
 ('targets-count-ignored', 'cc', '    if (cc->alias_count != cc->alias_attributes)', '    if (cc->alias_count == UINT32_MAX)'),
 ('target-kind-any', 'cc', 'target != 0 && target != alias->sym_idx && cc->syms[target].kind == kind &&', 'target != 0 && target != alias->sym_idx &&'),
 ('target-label-ok', 'cc', '                  cc->syms[target].asm_name == NULL;', '                  cc->syms[target].asm_name_len != UINT32_MAX;'),
 ('target-chain-ok', 'cc', '            ok = cc->aliases[j].sym_idx != target;', '            ok = cc->aliases[j].sym_idx != target || j != UINT32_MAX;'),
 ('target-not-referenced', 'cc', '            fast_cc_reference(cc, cc->syms + target);', '            (void)target;'),
 ('define-section-wrong', 'cc', '            out->section = place.section;', '            out->section = place.section + 1u;'),
 ('define-value-zero', 'cc', '            out->value = place.value;', '            out->value = 0;'),
 ('define-size-zero', 'cc', '            out->size = place.size;', '            out->size = 0;'),
 ('define-binding-global', 'cc', '            out->binding = sym->is_weak ? STB_WEAK : STB_GLOBAL;', '            out->binding = STB_GLOBAL;'),
 ('define-visibility-default', 'cc', '            out->visibility = sym->visibility;', '            out->visibility = STV_DEFAULT;'),
 ('define-undefined-target-ok', 'cc', '        if (sym_obj != 0 && cc->obj->syms[target_obj].defined != 0)', '        if (sym_obj != 0)'),
 ('decl-static-alias-ok', 'cc', 'if (alias != NULL && (ds.is_typedef || ds.is_static || ds.is_inline || join.label != NULL))', 'if (alias != NULL && (ds.is_typedef || ds.is_inline || join.label != NULL))'),
 ('decl-label-alias-ok', 'cc', 'if (alias != NULL && (ds.is_typedef || ds.is_static || ds.is_inline || join.label != NULL))', 'if (alias != NULL && (ds.is_typedef || ds.is_static || ds.is_inline))'),
 ('definition-alias-ok', 'cc', '                if (alias != NULL) { fast_cc_bail(cc, "alias attribute on a definition"); break; }', '                if (alias != NULL && alias->alias_len == UINT32_MAX) { fast_cc_bail(cc, "alias attribute on a definition"); break; }'),
 ('redefinition-of-alias-ok', 'cc', 'if (cc->syms[si].defined != 0 || cc->syms[si].is_alias != 0 || (pending', 'if (cc->syms[si].defined != 0 || (pending'),
 ('redeclared-alias-ok', 'cc', '                        if (declared->is_alias != 0 ||', '                        if (declared->is_alias == 99u ||'),
 ('prototype-defined-alias-ok', 'cc', '(alias != NULL && (declared->defined != 0 || declared->storage == 1u', '(alias != NULL && (declared->storage == 1u'),
 ('prototype-static-alias-ok', 'cc', '(alias != NULL && (declared->defined != 0 || declared->storage == 1u || declared->storage == 4u ||', '(alias != NULL && (declared->defined != 0 || declared->storage == 4u ||'),
 ('prototype-pending-alias-ok', 'cc', """                                               (declared->inline_rules & BUSTER_FINLINE_PENDING) != 0)))""", """                                               (declared->inline_rules & 64u) != 0)))"""),
 ('alias-late-join-strict', 'cc', '                        fast_cc_join_declaration(cc, existing, &join, alias != NULL);', '                        fast_cc_join_declaration(cc, existing, &join, false);'),
 ('object-redeclared-alias-ok', 'cc', 'if ((declared != 0 && cc->syms[declared].kind == FSYM_GLOBAL && cc->syms[declared].is_alias != 0) ||', 'if ((declared != 0 && cc->syms[declared].kind == FSYM_GLOBAL && cc->syms[declared].is_alias == 99u) ||'),
 ('object-init-alias-ok', 'cc', '                    (alias != NULL && (has_init || (declared != 0', '                    (alias != NULL && ((declared != 0'),
 ('object-tentative-alias-ok', 'cc', '(cc->syms[declared].defined != 0 || cc->syms[declared].is_tentative != 0 || cc->syms[declared].storage == 1u)))))', '(cc->syms[declared].defined != 0 || cc->syms[declared].storage == 1u)))))'),
 ('object-alias-not-added', 'cc', """                else if (alias != NULL)
                {
                    fast_cc_alias_add(cc, si, alias);
                }""", """                else if (alias != NULL && alias->alias_len == UINT32_MAX)
                {
                    fast_cc_alias_add(cc, si, alias);
                }"""),
 ('alias-not-marked', 'cc', '        cc->syms[sym_idx].is_alias = 1u;', '        cc->syms[sym_idx].is_alias = 0u;'),
 ('typeof-kind-any', 'types', "            if (kind != FSYM_FUNC && kind != FSYM_GLOBAL && kind != FSYM_LOCAL && kind != FSYM_TYPEDEF)", "            if (kind == 99u)"),
 ('typeof-specifier-mix-ok', 'types', 'if (saw_typeof && ((saw_void + saw_char + saw_short + saw_int + saw_long + saw_float + saw_double + saw_signed + saw_unsigned + saw_bool) != 0 ||', 'if (saw_typeof && ((saw_void + saw_char + saw_short + saw_int + saw_long + saw_float + saw_double + saw_signed + saw_bool) != 0 ||'),
 ('typeof-type-dropped', 'types', '            explicit_type = cc->syms[si].type;', '            explicit_type = FTYPE_I32;'),
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
