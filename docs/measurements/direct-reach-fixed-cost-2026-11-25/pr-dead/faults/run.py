import subprocess, sys, os, shutil, concurrent.futures
SRC = '/home/user/buster-6b/src/buster/compiler'
CL = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
OUT = '/tmp/claude-0/faults11'
M = [
 ('ternary-const-never', 'cc', "const uint32_t constant = (uint32_t)((ex.eval_only == 0) & (cond.kind == FVAL_IMM)) * (BUSTER_FCONSTANT_FALSE", "const uint32_t constant = (uint32_t)((ex.eval_only == 0) & (cond.kind == FVAL_IMM)) * 0u * (BUSTER_FCONSTANT_FALSE"),
 ('ternary-const-inverted', 'cc', "(BUSTER_FCONSTANT_FALSE + (uint32_t)(cond.imm != 0));", "(BUSTER_FCONSTANT_FALSE + (uint32_t)(cond.imm == 0));"),
 ('ternary-dead-then-live', 'cc', "ex.eval_only = (uint8_t)(ex.eval_only + (constant == BUSTER_FCONSTANT_FALSE));", "ex.eval_only = (uint8_t)(ex.eval_only + 0u * (constant == BUSTER_FCONSTANT_FALSE));"),
 ('ternary-branch-too', 'cc', "if ((ex.eval_only == 0) & (constant == BUSTER_FCONSTANT_NONE))", "if ((ex.eval_only == 0) | (constant == BUSTER_FCONSTANT_TRUE))"),
 ('colon-pop-live', 'cc', "ex.vsp -= (uint32_t)(constant == BUSTER_FCONSTANT_FALSE);", "ex.vsp -= (uint32_t)(constant == BUSTER_FCONSTANT_TRUE);"),
 ('colon-no-toggle', 'cc', "ex.eval_only = (uint8_t)(ex.eval_only + (constant == BUSTER_FCONSTANT_TRUE) - (constant == BUSTER_FCONSTANT_FALSE));", "ex.eval_only = (uint8_t)(ex.eval_only + 0u * (constant == BUSTER_FCONSTANT_TRUE));"),
 ('colon-then-type-lost', 'cc', "ops[osp - 1u] = (FastExprOp){ .op = FEOP_TERNARY_C, .extra = (uint16_t)constant, .type = arm_t };", "ops[osp - 1u] = (FastExprOp){ .op = FEOP_TERNARY_C, .extra = (uint16_t)constant, .type = FTYPE_I32 + 0u * arm_t };"),
 ('done-no-restore', 'cc', "ex->eval_only = (uint8_t)(ex->eval_only - (cur.extra == BUSTER_FCONSTANT_TRUE));", "ex->eval_only = (uint8_t)(ex->eval_only - 0u * (cur.extra == BUSTER_FCONSTANT_TRUE));"),
 ('done-live-is-else', 'cc', "                live = ex->vstack[--ex->vsp];\n            }\n            FastVal result", "                ex->vsp -= 1u;\n            }\n            FastVal result"),
 ('done-no-convert', 'cc', "                fval_convert(ex, &live, common_t);\n                const bool fp = ftype_is_float(common_t);", "                const bool fp = ftype_is_float(common_t);"),
 ('done-fp-as-gp', 'cc', "                const bool fp = ftype_is_float(common_t);", "                const bool fp = false & ftype_is_float(common_t);"),
 ('done-void-unreleased', 'cc', "            if (ftype_is_void(common_t))\n            {\n                fval_release(ex, &live);\n            }", "            if (ftype_is_void(common_t))\n            {\n                (void)live;\n            }"),
 ('done-record-uncopied', 'cc', "                FastVal dst = result;\n                fval_store(ex, &dst, &live, false, NULL);", "                result = live;"),
 ('eval-call-no-count', 'cc', "            fast_cc_bail(cc, \"call argument count mismatch\");\n        }\n        const uint32_t checked", "            (void)0;\n        }\n        const uint32_t checked"),
 ('eval-call-no-conv', 'cc', "            fast_cc_check_implicit_conv(cc, ftype_unqual(cc->param_types[fn->start + i]), &args[i]);\n        }\n        for (uint32_t i = 0; i < argc; i += 1) { fval_release(ex, &args[i]); }", "            (void)args;\n        }\n        for (uint32_t i = 0; i < argc; i += 1) { fval_release(ex, &args[i]); }"),
 ('branch-constant-never', 'cc', "cc->branch_constant = (uint8_t)((uint32_t)(final_v.kind == FVAL_IMM) *", "cc->branch_constant = (uint8_t)((uint32_t)(final_v.kind == FVAL_IMM) * 0u *"),
 ('branch-constant-inverted', 'cc', "(BUSTER_FCONSTANT_FALSE + (uint32_t)(final_v.imm != 0)));", "(BUSTER_FCONSTANT_FALSE + (uint32_t)(final_v.imm == 0)));"),
 ('if-constant-in-dead', 'cc', "const uint32_t constant = cc->branch_constant * (uint32_t)(cc->dead == 0);", "const uint32_t constant = cc->branch_constant;"),
 ('dead-then-unscanned', 'cc', "                dead_then = fast_cc_dead_simple(cc, cc->pos);", "                dead_then = fast_cc_dead_simple(cc, cc->pos) | true;"),
 ('dead-else-unscanned', 'cc', "                        dead_else = fast_cc_dead_simple(cc, cc->pos);", "                        dead_else = fast_cc_dead_simple(cc, cc->pos) | true;"),
 ('then-no-decrement', 'cc', "cc->dead -= (uint32_t)(top->dead == BUSTER_FDEAD_THEN);", "cc->dead -= 0u * (uint32_t)(top->dead == BUSTER_FDEAD_THEN);"),
 ('else-no-decrement', 'cc', "cc->dead -= (uint32_t)(top->dead == BUSTER_FDEAD_ELSE);", "cc->dead -= 0u * (uint32_t)(top->dead == BUSTER_FDEAD_ELSE);"),
 ('else-jmp-in-dead', 'cc', "if ((cc->dead == 0) & !dead_else & (top->dead != BUSTER_FDEAD_THEN))", "if (!dead_else & (top->dead != BUSTER_FDEAD_THEN))"),
 ('else-jmp-after-dead-then', 'cc', "if ((cc->dead == 0) & !dead_else & (top->dead != BUSTER_FDEAD_THEN))", "if ((cc->dead == 0) & !dead_else)"),
 ('else-dead-flag-lost', 'cc', "top->dead = (uint8_t)((uint32_t)dead_else * BUSTER_FDEAD_ELSE);", "top->dead = (uint8_t)((uint32_t)dead_else * 0u);"),
 ('scan-accepts-types', 'cc', "ok = semicolon != UINT32_MAX && !fast_cc_is_type_start(cc, pos);", "ok = semicolon != UINT32_MAX;"),
 ('scan-accepts-statements', 'cc', "const uint32_t semicolon = statement || label ? UINT32_MAX : fast_cc_dead_expression_end(cc, pos, FTOK_SEMI);", "const uint32_t semicolon = label ? UINT32_MAX + 0u * statement : fast_cc_dead_expression_end(cc, pos, FTOK_SEMI);"),
 ('scan-accepts-labels', 'cc', "const uint32_t semicolon = statement || label ? UINT32_MAX : fast_cc_dead_expression_end(cc, pos, FTOK_SEMI);", "const uint32_t semicolon = statement ? UINT32_MAX + 0u * label : fast_cc_dead_expression_end(cc, pos, FTOK_SEMI);"),
 ('scan-no-else', 'cc', "            else if (frames[depth - 1u] == BUSTER_FDEAD_SCAN_IF && k == FTOK_KW_ELSE)", "            else if (frames[depth - 1u] == BUSTER_FDEAD_SCAN_IF && k == FTOK_KW_ELSE && false)"),
 ('scan-statement-expression', 'cc', "ok = !(k == FTOK_LBRACE && i > 0 && cc->tk[i - 1u] == FTOK_LPAREN) && ", "ok = "),
 ('scan-depth-ignored', 'cc', "depth = depth + (uint32_t)opens - (uint32_t)closes;", "depth = 0u * ((uint32_t)opens - (uint32_t)closes);"),
 ('scan-depth-one', 'cc', "ok = depth < 32u && (k == FTOK_LBRACE || close != UINT32_MAX);", "ok = depth < 1u && (k == FTOK_LBRACE || close != UINT32_MAX);"),
 ('expr-not-dead', 'cc', "    ex.eval_only = (uint8_t)(cc->dead != 0);\n\n    FastExprOp ops[128];", "    ex.eval_only = 0;\n\n    FastExprOp ops[128];"),
 ('function-no-reset', 'cc', "    cc->cur_tmp_off = 0;\n    cc->dead = 0;", "    cc->cur_tmp_off = 0;"),
 ('release-frees-in-eval', 'cc', "const uint32_t live = 0u - (uint32_t)(ex->eval_only == 0);", "const uint32_t live = 0u - 1u + 0u * (uint32_t)(ex->eval_only == 0);"),
 ('release-xmm-frees-in-eval', 'cc', "else if (fval_holds_xmm(v)) { ex->xmm_used &= (uint8_t)~((1u << v->reg) & live); }", "else if (fval_holds_xmm(v)) { ex->xmm_used &= (uint8_t)~(1u << v->reg); }"),
 ('logic-decided-never', 'cc', "const uint32_t decided = (uint32_t)((ex.eval_only == 0) & (lhs.kind == FVAL_IMM) & ((lhs.imm != 0) == (k == FTOK_LOR)));", "const uint32_t decided = 0u * (uint32_t)((ex.eval_only == 0) & (lhs.kind == FVAL_IMM) & ((lhs.imm != 0) == (k == FTOK_LOR)));"),
 ('logic-decided-inverted', 'cc', "& ((lhs.imm != 0) == (k == FTOK_LOR)));", "& ((lhs.imm == 0) == (k == FTOK_LOR)));"),
 ('logic-value-inverted', 'cc', "FastVal value = { .type = FTYPE_I32, .kind = FVAL_IMM, .imm = tok == FTOK_LOR };", "FastVal value = { .type = FTYPE_I32, .kind = FVAL_IMM, .imm = tok == FTOK_LAND };"),
 ('logic-no-restore', 'cc', "            ex->eval_only -= 1u;\n            if (!ftype_is_scalar(ftype_decay(cc, rhs.type)))", "            if (!ftype_is_scalar(ftype_decay(cc, rhs.type)))"),
 ('logic-no-scalar-check', 'cc', "if (!ftype_is_scalar(ftype_decay(cc, rhs.type))) { fast_cc_bail(cc, \"logical operand not scalar\"); return; }", "(void)rhs;"),
 ('logic-value-constant', 'cc', "            ex->vstack[ex->vsp++] = (FastVal){ .type = FTYPE_I32, .kind = FVAL_REG, .reg = reg };\n            return;\n        }\n        if (ex->eval_only > 0)", "            ex->vstack[ex->vsp++] = (FastVal){ .type = FTYPE_I32, .kind = FVAL_IMM, .imm = (int64_t)(tok == FTOK_LOR) + 0 * (int64_t)reg };\n            return;\n        }\n        if (ex->eval_only > 0)"),
 ('ternary-value-constant', 'cc', "                result.kind = fp ? FVAL_XMM : FVAL_REG;\n                result.reg = fp ? fval_to_xmm(ex, &live, true) : fval_to_gp(ex, &live, true);", "                result = live.kind == FVAL_IMM ? live : result;\n                result.kind = live.kind == FVAL_IMM ? FVAL_IMM : fp ? FVAL_XMM : FVAL_REG;\n                result.reg = live.kind == FVAL_IMM ? 0u : fp ? fval_to_xmm(ex, &live, true) : fval_to_gp(ex, &live, true);"),
]
FILES = {'lex': 'c_direct_lex.c', 'drv': 'c_direct.c', 'cc': 'c_direct_cc.c'}
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
    r = subprocess.run(['nice', 'timeout', '120', d + '/h'], capture_output=True, text=True, cwd=d)
    fails = [l for l in r.stderr.splitlines() if 'FAIL' in l or 'test-direct: ' in l][:3]
    shutil.rmtree(d, ignore_errors=True)
    return (name, ('found(%d): ' % r.returncode + '; '.join(fails)) if r.returncode != 0 else 'SURVIVED')
only = set(sys.argv[1:])
todo = [m for m in M if not only or m[0] in only]
with concurrent.futures.ThreadPoolExecutor(2) as ex:
    for name, verdict in ex.map(one, todo):
        print(name, verdict[:400], flush=True)
