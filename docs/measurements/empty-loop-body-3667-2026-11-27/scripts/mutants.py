import os, shutil, subprocess, sys, concurrent.futures
SRC = '/home/user/buster/src/buster/compiler'
FILES = ['c_direct.c', 'c_direct_cc.c', 'c_direct_lex.c', 'c_direct_types.c', 'c_direct_x86.c', 'c_direct_pretty.c', 'c_direct.h']
M = [
 ('base', None, None, None),
 ('while_call', 'c_direct_cc.c', "            if (cc->tk[cc->pos] == FTOK_SEMI) { fast_cc_empty_statement(cc); }\n            break_frame[break_sp] = (uint8_t)ssp;\n            cont_frame[cont_sp] = (uint8_t)ssp;\n            break_stack[break_sp++] = brk_lbl;\n            cont_stack[cont_sp++] = cond_lbl;", "            break_frame[break_sp] = (uint8_t)ssp;\n            cont_frame[cont_sp] = (uint8_t)ssp;\n            break_stack[break_sp++] = brk_lbl;\n            cont_stack[cont_sp++] = cond_lbl;"),
 ('for_call', 'c_direct_cc.c', "            // #3667: a lone `;` body, as a while's.\n            if (cc->tk[cc->pos] == FTOK_SEMI) { fast_cc_empty_statement(cc); }", ""),
 ('rule1', 'c_direct_cc.c', "if (semi_line != close_line)", "if (false)"),
 ('col_lt', 'c_direct_cc.c', "next.column <= column", "next.column < column"),
 ('col_gt', 'c_direct_cc.c', "next.column <= column", "next.column <= column + 1u"),
 ('owned_all', 'c_direct_cc.c', "const bool owned = before == FTOK_SEMI || before == FTOK_LBRACE || before == FTOK_RBRACE;", "const bool owned = true;"),
 ('owned_rbrace', 'c_direct_cc.c', "const bool owned = before == FTOK_SEMI || before == FTOK_LBRACE || before == FTOK_RBRACE;", "const bool owned = before == FTOK_SEMI || before == FTOK_LBRACE;"),
 ('last', 'c_direct_cc.c', "cc->tk[rparen + 2u] == FTOK_RBRACE ||", ""),
 ('system', 'c_direct_cc.c', "|| placed == (BUSTER_FTOK_PLACED | BUSTER_FTOK_PLACED_SYSTEM);", ";"),
 ('quiet', 'c_direct_cc.c', "const bool quiet = cc->quiet ||", "const bool quiet ="),
 ('emit_mark', 'c_direct_lex.c', "out_data[out_count + k] = fast_pp_window_placed(pp, f, i + k);", ""),
 ('single_mark', 'c_direct_lex.c', "tok.data = fast_pp_placed(pp, f, f->ptr - (tok.kind == FTOK_KW_WHILE ? 5u : 3u));", ""),
 ('main_off', 'c_direct_lex.c', "return f->serial == pp->main_serial ? main : other;", "return f->serial == pp->main_serial ? (main + 1u) : other;"),
 ('gives_true', 'c_direct_cc.c', "    return gives;\n}", "    return true;\n}"),
 ('gives_false', 'c_direct_cc.c', "    return gives;\n}", "    return false;\n}"),
 ('else_dir', 'c_direct_cc.c', 'const bool ends = fast_cc_raw_named(q, length, "else") ||', 'const bool ends = false && fast_cc_raw_named(q, length, "else") ||'),
 ('ifdef_pass', 'c_direct_cc.c', 'fast_cc_raw_named(q, length, "line") || fast_cc_raw_named(q, length, "endif");', 'fast_cc_raw_named(q, length, "line") || fast_cc_raw_named(q, length, "endif") || fast_cc_raw_named(q, length, "ifdef");'),
 ('compound', 'c_direct_cc.c', "const bool compound = same && cc->tk[following] == FTOK_LBRACE;", "const bool compound = false;"),
 ('same_spell', 'c_direct_cc.c', "same = text != NULL && length == r->length && memcmp(text, r->at, length) == 0;", "same = text != NULL;"),
 ('unexp_true', 'c_direct_cc.c', "    return same && matched == count && stream_marks == marks;", "    return true;"),
 ('unexp_marks', 'c_direct_cc.c', "    return same && matched == count && stream_marks == marks;", "    return same && matched == count;"),
 ('balanced_true', 'c_direct_cc.c', "        balanced = balanced && level == 0;\n    }\n    return balanced;", "        balanced = balanced && level == 0;\n    }\n    return true;"),
 ('hdr_special', 'c_direct_cc.c', "ok = ok && (special & span) == 0 && read != 0", "ok = ok && read != 0"),
 ('hdr_literal', 'c_direct_cc.c', "            inside |= literal;", "            (void)literal;"),
 ('hdr_sep', 'c_direct_cc.c', "return ok && close != NULL && semi && separators == (is_for ? 2u : 0u) ? r + 1 : NULL;", "return ok && close != NULL && semi ? r + 1 : NULL;"),
 ('hdr_lines', 'c_direct_cc.c', "        line += (uint32_t)__builtin_popcountll(newlines & span);", ""),
 ('hdr_newline_semi', 'c_direct_cc.c', "        line += (uint32_t)(r[0] == '\\n');", ""),
 ('back_scan', 'c_direct_cc.c', "            open = level == 0 ? low + bit : UINT32_MAX;", "            open = level == 0 ? low + bit + 1u : UINT32_MAX;"),
 ('hdr_fallback_off', 'c_direct_cc.c', "plain && fast_cc_raw_loop_tokens(cc, at, word_length, line_start, end, is_for, &close_line, &semi_line, &next);", "false;"),
]
def run(m):
    name, f, old, new = m
    d = f'/tmp/claude-0/-home-user-buster/da15bdfb-5e43-5e97-aa3c-4d24204bdc99/scratchpad/mut/w_{name}'
    shutil.rmtree(d, ignore_errors=True)
    os.makedirs(d + '/buster/compiler')
    for x in FILES:
        shutil.copy(f'{SRC}/{x}', f'{d}/buster/compiler/{x}')
    p = f'{d}/buster/compiler/c_direct.c'
    s = open(p).read(); s = s.replace('if (c_direct_test_admission())', 'if (true)', 1); open(p, 'w').write(s)
    if f:
        p = f'{d}/buster/compiler/{f}'
        s = open(p).read()
        if old not in s: return (name, 'PATTERN-MISSING')
        s = s.replace(old, new, 1); open(p, 'w').write(s)
    open(f'{d}/main.c', 'w').write('#include "buster/compiler/c_direct.c"\nint main(void) { return run_c_direct_tests(0, NULL); }\n')
    r = subprocess.run(['clang', '-O1', '-g0', '-march=native', f'-I{d}', '-fwrapv', '-funsigned-char', '-fno-strict-aliasing', '-Wall', '-Wno-unused-function', '-Wno-unused-variable', '-Wno-unused-but-set-variable', '-fno-stack-protector', f'{d}/main.c', '-o', f'{d}/t', '-lpthread', '-lm'], capture_output=True, text=True)
    if r.returncode != 0: return (name, 'BUILD-FAIL ' + r.stderr[:300])
    r = subprocess.run([f'{d}/t'], capture_output=True, text=True, cwd=d, timeout=600)
    fails = [l for l in (r.stderr + r.stdout).splitlines() if 'FAIL' in l or 'left' in l or 'stayed' in l]
    last = [l for l in (r.stderr + r.stdout).splitlines() if 'passed' in l]
    shutil.rmtree(d, ignore_errors=True)
    return (name, (last[-1] if last else '?') + ' | ' + ' || '.join(fails[:4]))
with concurrent.futures.ThreadPoolExecutor(4) as ex:
    for name, res in ex.map(run, M):
        print(f'{name:14s} {res}', flush=True)
