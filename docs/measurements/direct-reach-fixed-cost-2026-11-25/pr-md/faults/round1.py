import subprocess, sys, os, shutil, concurrent.futures
SRC = '/home/user/buster-md/src/buster/compiler'
CL = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
OUT = '/tmp/claude-0/faults9'
M = [
 ('find-off-by-one', 'lex', "result = same != 0 ? i + (uint32_t)__builtin_ctz(same) + 1u : 0u;", "result = same != 0 ? i + (uint32_t)__builtin_ctz(same) : 0u;"),
 ('find-tail-mask', 'lex', "(__mmask8)((1u << left) - 1u);", "(__mmask8)((1u << left) >> 1);"),
 ('find-no-device', 'lex', "const uint32_t same = (uint32_t)(_mm512_mask_cmpeq_epi64_mask(live, devices, want_device) & _mm512_mask_cmpeq_epi64_mask(live, inodes, want_inode));", "const uint32_t same = (uint32_t)(_mm512_mask_cmpeq_epi64_mask(live, inodes, want_inode));"),
 ('find-no-inode', 'lex', "const uint32_t same = (uint32_t)(_mm512_mask_cmpeq_epi64_mask(live, devices, want_device) & _mm512_mask_cmpeq_epi64_mask(live, inodes, want_inode));", "const uint32_t same = (uint32_t)(_mm512_mask_cmpeq_epi64_mask(live, devices, want_device));"),
 ('observe-or-system', 'lex', """    if (result != 0)
    {
        pp->dependency_records[result - 1u].system &= system;
    }
    else if (pp->dependency_count < BUSTER_FPP_MAX_DEPENDENCIES)""", """    if (result != 0)
    {
        pp->dependency_records[result - 1u].system |= system;
    }
    else if (pp->dependency_count < BUSTER_FPP_MAX_DEPENDENCIES)"""),
 ('observe-unused', 'lex', "                .used = true,\n                .system = system,", "                .used = false,\n                .system = system,"),
 ('observe-count-stuck', 'lex', "            pp->dependency_count = index + 1u;", "            pp->dependency_count = index + (index == 0u ? 1u : 0u);"),
 ('observe-last-not-set', 'lex', """        fast_pp_bail(pp, "too many files for a dependency rule");
    }
    pp->dependency_last = result;""", """        fast_pp_bail(pp, "too many files for a dependency rule");
    }
    pp->dependency_last = result & 0u;"""),
 ('again-no-pragma-bit', 'lex', "pp->dependency_records[record - 1u].system &= system || (entry & BUSTER_FPP_SYSTEM_PRAGMA) != 0;", "pp->dependency_records[record - 1u].system &= system;"),
 ('again-not-anded', 'lex', "pp->dependency_records[record - 1u].system &= system || (entry & BUSTER_FPP_SYSTEM_PRAGMA) != 0;", "pp->dependency_records[record - 1u].system &= true;"),
 ('again-record-kept-bit', 'lex', "    const uint32_t record = entry & ~BUSTER_FPP_SYSTEM_PRAGMA;", "    const uint32_t record = entry;"),
 ('again-zero-ok', 'lex', """        fast_pp_bail(pp, "a file read without its dependency record");""", """        (void)entry;"""),
 ('pop-bit-dropped', 'lex', """                    pp->guard_dependencies[ge - pp->guards] = (pp->guard_dependencies[ge - pp->guards] & BUSTER_FPP_SYSTEM_PRAGMA) | f->dependency;
                }
            }
        }""", """                    pp->guard_dependencies[ge - pp->guards] = f->dependency;
                }
            }
        }"""),
 ('pop-record-dropped', 'lex', """                    pp->guard_dependencies[ge - pp->guards] = (pp->guard_dependencies[ge - pp->guards] & BUSTER_FPP_SYSTEM_PRAGMA) | f->dependency;
                }
            }
        }""", """                    pp->guard_dependencies[ge - pp->guards] = (pp->guard_dependencies[ge - pp->guards] & BUSTER_FPP_SYSTEM_PRAGMA);
                }
            }
        }"""),
 ('once-record-dropped', 'lex', """                if (ge != NULL && pp->dependency_records != NULL)
                {
                    pp->guard_dependencies[ge - pp->guards] = (pp->guard_dependencies[ge - pp->guards] & BUSTER_FPP_SYSTEM_PRAGMA) | f->dependency;
                }""", """                if (ge != NULL && pp->dependency_records == NULL)
                {
                    pp->guard_dependencies[ge - pp->guards] = (pp->guard_dependencies[ge - pp->guards] & BUSTER_FPP_SYSTEM_PRAGMA) | f->dependency;
                }"""),
 ('skip-not-observed', 'lex', """        if (pp->dependency_records != NULL)
        {
            fast_pp_dependency_again(pp, ge, is_system);
        }
        return true; // Skipped with ZERO syscalls!""", """        return true; // Skipped with ZERO syscalls!"""),
 ('open-bit-ignored', 'lex', "    is_system |= ge != NULL && pp->dependency_records != NULL && (pp->guard_dependencies[ge - pp->guards] & BUSTER_FPP_SYSTEM_PRAGMA) != 0;", "    is_system |= false;"),
 ('open-not-observed', 'lex', "            const uint32_t record = pp->dependency_records != NULL ? fast_pp_dependency_observe(pp, path, path_len, &st, is_system) : 0u;", "            const uint32_t record = 0u;"),
 ('open-record-not-kept', 'lex', """                    else
                    {
                        pp->files[pp->file_depth - 1u].dependency = record;
                    }""", """                    else
                    {
                        pp->files[pp->file_depth - 1u].dependency = 0u;
                    }"""),
 ('include-level-not-inherited', 'lex', "if (!fast_pp_open_and_push(pp, resolved, (uint32_t)strlen(resolved), dir_idx, is_sys || f->is_system))", "if (!fast_pp_open_and_push(pp, resolved, (uint32_t)strlen(resolved), dir_idx, is_sys))"),
 ('pragma-main-marks', 'lex', "                        const bool marks = f->serial != pp->main_serial;", "                        const bool marks = true;"),
 ('pragma-no-mark', 'lex', "                            pp->guard_dependencies[ge - pp->guards] = BUSTER_FPP_SYSTEM_PRAGMA | f->dependency;", "                            pp->guard_dependencies[ge - pp->guards] = f->dependency;"),
 ('pragma-no-current', 'lex', "                        f->is_system |= marks;", "                        f->is_system |= false;"),
 ('probe-level-not-inherited', 'lex', "    const bool level = system || (pp->file_depth != 0 && pp->files[pp->file_depth - 1u].is_system);", "    const bool level = system;"),
 ('probe-directory-ok', 'lex', "    else if (stat(path, &status) == 0 && S_ISREG(status.st_mode))", "    else if (stat(path, &status) == 0)"),
 ('probe-not-called', 'lex', """                            if (val != 0 && pp->dependency_records != NULL)
                            {
                                fast_pp_dependency_probe(pp, tmp_path, sys);
                            }""", """                            if (val != 0 && pp->dependency_records == NULL)
                            {
                                fast_pp_dependency_probe(pp, tmp_path, sys);
                            }"""),
 ('probe-macro-ok', 'lex', """                            fast_pp_bail(pp, "__has_include of a macro with -MD");""", """                            (void)hlen;"""),
 ('defined-no-has-include', 'lex', "    return fast_ident_is_macro(&pp->idents, id) || pkw == FPP_KW_HAS_INCLUDE || pkw == FPP_KW_HAS_INCLUDE_NEXT;", "    return fast_ident_is_macro(&pp->idents, id) || pkw == FPP_KW_HAS_INCLUDE_NEXT;"),
 ('defined-no-has-include-next', 'lex', "    return fast_ident_is_macro(&pp->idents, id) || pkw == FPP_KW_HAS_INCLUDE || pkw == FPP_KW_HAS_INCLUDE_NEXT;", "    return fast_ident_is_macro(&pp->idents, id) || pkw == FPP_KW_HAS_INCLUDE;"),
 ('elifdef-plain', 'lex', "                        const bool def = (nt.kind == FTOK_IDENT || nt.kind >= 64u) && fast_pp_defined(pp, nt.data);", "                        const bool def = (nt.kind == FTOK_IDENT || nt.kind >= 64u) && fast_ident_is_macro(&pp->idents, nt.data);"),
 ('ifdef-plain', 'lex', "                const bool defined = fast_pp_defined(pp, nt.data);", "                const bool defined = fast_ident_is_macro(&pp->idents, nt.data);"),
 ('defined-op-plain', 'lex', "                    is_def = fast_pp_defined(pp, nt.data) ? 1u : 0u;", "                    is_def = fast_ident_is_macro(&pp->idents, nt.data) ? 1u : 0u;"),
 ('line-rest-ok', 'lex', "    if (pp->dependency_records != NULL && rest < f->end && *rest != '\\n')", "    if (pp->dependency_records == NULL && rest < f->end && *rest == 'Z')"),
 ('line-rest-always', 'lex', "    if (pp->dependency_records != NULL && rest < f->end && *rest != '\\n')", "    if (pp->dependency_records != NULL && rest < f->end)"),
 ('run-main-not-recorded', 'lex', "        pp->dependency_main = pp->dependency_last;", "        pp->dependency_main = 0u;"),
 ('main-used', 'drv', "            pp->dependency_records[pp->dependency_main - 1u].used = false;", "            pp->dependency_records[pp->dependency_main - 1u].used = true;"),
 ('predefines-user', 'drv', "            ok = fast_pp_run_file(pp, request->predefines_path, false, true);", "            ok = fast_pp_run_file(pp, request->predefines_path, false, false);"),
 ('forced-search-user', 'drv', "                ok = fast_pp_run_file(pp, resolved, false, is_sys);", "                ok = fast_pp_run_file(pp, resolved, false, false);"),
 ('callback-ignored', 'drv', "        ok = request->dependencies(request->dependency_context, pp->dependency_records, pp->dependency_count);", "        ok = request->dependencies(request->dependency_context, pp->dependency_records, pp->dependency_count) || true;"),
 ('callback-not-called', 'drv', "    if (ok && request->dependencies != NULL)\n    {\n        if (pp->dependency_main != 0)", "    if (ok && request->dependencies == NULL)\n    {\n        if (pp->dependency_main != 0)"),
]
FILES = {'lex': 'c_direct_lex.c', 'drv': 'c_direct.c'}
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
        return (name, 'PATTERN %d' % n)
    open(p, 'w').write(s.replace(old, new))
    c = d + '/src/buster/compiler/c_direct.c'
    s = open(c).read().replace('if (c_direct_test_admission())', 'if (true)')
    open(c, 'w').write(s)
    open(d + '/main.c', 'w').write('#include "buster/compiler/c_direct.c"\nint main(void) { return run_c_direct_tests(0, NULL); }\n')
    b = subprocess.run(['nice', CL, '-O1', '-g0', '-march=native', '-I' + d + '/src', '-fwrapv', '-funsigned-char', '-fno-strict-aliasing', '-Wall', '-Werror', '-Wno-unused-function', '-fno-stack-protector', d + '/main.c', '-lpthread', '-o', d + '/h'], capture_output=True, text=True)
    if b.returncode != 0:
        return (name, 'BUILD ' + b.stderr[:300])
    r = subprocess.run(['nice', 'timeout', '120', d + '/h'], capture_output=True, text=True, cwd=d)
    fails = [l for l in r.stderr.splitlines() if 'FAIL' in l]
    shutil.rmtree(d, ignore_errors=True)
    return (name, ('found: ' + '; '.join(fails)) if r.returncode != 0 else 'SURVIVED')
with concurrent.futures.ThreadPoolExecutor(2) as ex:
    for name, verdict in ex.map(one, M):
        print(name, verdict, flush=True)
