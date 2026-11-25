import subprocess, sys, os, shutil, concurrent.futures
SRC = '/home/user/buster-6c/src/buster/compiler'
CL = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
OUT = '/tmp/claude-0/faults10'
M = [
 ('template-swap-unknown', 'cc', '        "xchg %0, %1",', '        "xchg %0, %9",'),
 ('template-off-by-one', 'cc', "        shape = fast_cc_asm_literal_is(cc, pos, templates[i]) ? BUSTER_FASM_CAS + i : BUSTER_FASM_NONE;", "        shape = fast_cc_asm_literal_is(cc, pos, templates[i]) ? BUSTER_FASM_CAS + i + (i == 1u ? 1u : 0u) : BUSTER_FASM_NONE;"),
 ('out-a-is-r', 'cc', """        kind = fast_cc_asm_literal_is(cc, at, "=a") ? 'a' : fast_cc_asm_literal_is(cc, at, "=r") ? 'r' : fast_cc_asm_literal_is(cc, at, "+r") ? '+' : 0u;""", """        kind = fast_cc_asm_literal_is(cc, at, "=a") ? 'r' : fast_cc_asm_literal_is(cc, at, "=r") ? 'r' : fast_cc_asm_literal_is(cc, at, "+r") ? '+' : 0u;"""),
 ('in-a-is-r', 'cc', """        kind = fast_cc_asm_literal_is(cc, at, "a") ? 'a' : fast_cc_asm_literal_is(cc, at, "r") ? 'r' : fast_cc_asm_literal_is(cc, at, "0") ? '0' : 0u;""", """        kind = fast_cc_asm_literal_is(cc, at, "a") ? 'a' : fast_cc_asm_literal_is(cc, at, "r") ? 'a' : fast_cc_asm_literal_is(cc, at, "0") ? '0' : 0u;"""),
 ('in-0-is-r', 'cc', """fast_cc_asm_literal_is(cc, at, "0") ? '0' : 0u;""", """fast_cc_asm_literal_is(cc, at, "0") ? 'r' : 0u;"""),
 ('mem-no-star', 'cc', """        ok = fast_cc_peek(cc) == FTOK_STAR;
        cc->pos += ok ? 1u : 0u;""", """        ok = true;
        cc->pos += fast_cc_peek(cc) == FTOK_STAR ? 1u : 0u;"""),
 ('mem-cast-any', 'cc', "            ok = parsed && !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN && ftype_is_ptr(pointer);", "            ok = parsed && !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN;"),
 ('mem-cast-ignored', 'cc', "        size = ok ? ftype_size(cc, ftype_deref(cc, pointer != 0 ? pointer : sym->type)) : 0u;", "        size = ok ? ftype_size(cc, ftype_deref(cc, sym->type)) : 0u;"),
 ('mem-global-ok', 'cc', "        ok = si != 0 && sym->kind == FSYM_LOCAL && ftype_is_ptr(sym->type) && fast_cc_peek_at(cc, 1u) == FTOK_RPAREN;", "        ok = si != 0 && ftype_is_ptr(sym->type) && fast_cc_peek_at(cc, 1u) == FTOK_RPAREN;"),
 ('mem-size-8', 'cc', "        size = ok ? ftype_size(cc, ftype_deref(cc, pointer != 0 ? pointer : sym->type)) : 0u;", "        size = ok ? 8u : 0u;"),
 ('out-const-ok', 'cc', "        ok = si != 0 && sym->kind == FSYM_LOCAL && (ftype_is_int(sym->type) || ftype_is_ptr(sym->type)) && !ftype_is_const(sym->type) &&", "        ok = si != 0 && sym->kind == FSYM_LOCAL && (ftype_is_int(sym->type) || ftype_is_ptr(sym->type)) &&"),
 ('out-float-ok', 'cc', "        ok = si != 0 && sym->kind == FSYM_LOCAL && (ftype_is_int(sym->type) || ftype_is_ptr(sym->type)) && !ftype_is_const(sym->type) &&", "        ok = si != 0 && sym->kind == FSYM_LOCAL && !ftype_is_const(sym->type) &&"),
 ('in-float-ok', 'cc', "        ok = !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN && (ftype_is_int(value.type) || ftype_is_ptr(value.type));", "        ok = !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN;"),
 ('size-any', 'cc', "    ok = ok && (size == 4u || size == 8u);\n    operand->size = size;", "    ok = ok && size != 0u;\n    operand->size = size;"),
 ('clobber-any', 'cc', """                ok = fast_cc_asm_literal_is(cc, cc->pos, "memory");""", """                ok = fast_cc_peek(cc) == FTOK_STR_LIT;"""),
 ('cas-no-memory', 'cc', "            ok = ok && memory && outs == 2u && out.kind == 'a' && place.kind == 'm' && ins == 2u && in.kind == 'a' && inputs[1].kind == 'r' &&", "            ok = ok && outs == 2u && out.kind == 'a' && place.kind == 'm' && ins == 2u && in.kind == 'a' && inputs[1].kind == 'r' &&"),
 ('cas-out-any', 'cc', "            ok = ok && memory && outs == 2u && out.kind == 'a' && place.kind == 'm' && ins == 2u && in.kind == 'a' && inputs[1].kind == 'r' &&", "            ok = ok && memory && outs == 2u && place.kind == 'm' && ins == 2u && in.kind == 'a' && inputs[1].kind == 'r' &&"),
 ('cas-in-any', 'cc', "            ok = ok && memory && outs == 2u && out.kind == 'a' && place.kind == 'm' && ins == 2u && in.kind == 'a' && inputs[1].kind == 'r' &&", "            ok = ok && memory && outs == 2u && out.kind == 'a' && place.kind == 'm' && ins == 2u && inputs[1].kind == 'r' &&"),
 ('cas-sizes-any', 'cc', "                 out.size == size && in.size == size && inputs[1].size == size;", "                 out.size == size;"),
 ('swap-in-any', 'cc', "            ok = ok && memory && outs == 2u && out.kind == 'r' && place.kind == 'm' && ins == 1u && in.kind == '0' && out.size == size && in.size == size;", "            ok = ok && memory && outs == 2u && out.kind == 'r' && place.kind == 'm' && ins == 1u && out.size == size && in.size == size;"),
 ('swap-order-any', 'cc', "            ok = ok && memory && outs == 2u && out.kind == 'r' && place.kind == 'm' && ins == 1u && in.kind == '0' && out.size == size && in.size == size;", "            ok = ok && memory && outs == 2u && ins == 1u && in.kind == '0' && out.size == size && in.size == size;"),
 ('update-size-any', 'cc', "            ok = ok && memory && outs == 1u && out.kind == 'm' && ins == 1u && in.kind == 'r' && in.size == size;", "            ok = ok && memory && outs == 1u && out.kind == 'm' && ins == 1u && in.kind == 'r';"),
 ('update-in-any', 'cc', "            ok = ok && memory && outs == 1u && out.kind == 'm' && ins == 1u && in.kind == 'r' && in.size == size;", "            ok = ok && memory && outs == 1u && out.kind == 'm' && ins == 1u && in.size == size;"),
 ('inc-other-place', 'cc', "            ok = ok && memory && outs == 1u && out.kind == 'm' && ins == 1u && in.kind == 'm' && in.off == out.off;", "            ok = ok && memory && outs == 1u && out.kind == 'm' && ins == 1u && in.kind == 'm';"),
 ('empty-out-any', 'cc', "            ok = ok && (outs == 0u || (outs == 1u && out.kind == '+')) && (ins == 0u || (ins == 1u && in.kind == 'r'));", "            ok = ok && (ins == 0u || (ins == 1u && in.kind == 'r'));"),
 ('pause-operands-ok', 'cc', "            ok = ok && outs == 0u && ins == 0u;", "            ok = ok && outs == 0u;"),
 ('bits-memory-ok', 'cc', "            ok = ok && !memory && outs == 1u && out.kind == 'r' && ins == 1u && in.kind == 'r' && in.size == out.size;", "            ok = ok && outs == 1u && out.kind == 'r' && ins == 1u && in.kind == 'r' && in.size == out.size;"),
 ('bits-size-any', 'cc', "            ok = ok && !memory && outs == 1u && out.kind == 'r' && ins == 1u && in.kind == 'r' && in.size == out.size;", "            ok = ok && !memory && outs == 1u && out.kind == 'r' && ins == 1u && in.kind == 'r';"),
 ('tail-any', 'cc', "    ok = ok && fast_cc_peek(cc) == FTOK_RPAREN && fast_cc_peek_at(cc, 1u) == FTOK_SEMI;\n    if (!ok)\n    {\n        fast_cc_bail(cc, \"asm statement\");\n    }\n    else\n    {\n        // REX.W", "    ok = ok && fast_cc_peek(cc) == FTOK_RPAREN;\n    if (!ok)\n    {\n        fast_cc_bail(cc, \"asm statement\");\n    }\n    else\n    {\n        // REX.W"),
 ('wide-never', 'cc', "        const uint8_t wide = (shape == BUSTER_FASM_BSF || shape == BUSTER_FASM_BSR ? out.size : size) == 8u ? 0x48u : 0u;", "        const uint8_t wide = 0u * size;"),
 ('wide-bits-mem', 'cc', "        const uint8_t wide = (shape == BUSTER_FASM_BSF || shape == BUSTER_FASM_BSR ? out.size : size) == 8u ? 0x48u : 0u;", "        const uint8_t wide = size == 8u ? 0x48u : 0u;"),
 ('no-address', 'cc', "            x86_load(obj, FREG_RDX, FREG_RBP, place.off, 8u, false);", "            x86_load(obj, FREG_RDX, FREG_RBP, place.off + 0 * (int32_t)size, 4u, false);"),
 ('no-input', 'cc', "        if (ins != 0u && in.kind != 'm' && shape != BUSTER_FASM_EMPTY)", "        if (ins != 0u && in.kind != 'm' && shape == BUSTER_FASM_EMPTY)"),
 ('no-source', 'cc', "            x86_load(obj, FREG_RCX, FREG_RBP, inputs[1].off, 8u, false);", "            x86_load(obj, FREG_RCX, FREG_RBP, inputs[0].off, 8u, false);"),
 ('cas-no-lock', 'cc', "            case BUSTER_FASM_CAS:\n            case BUSTER_FASM_FETCH_ADD:\n                x86_u8(obj, lock);", "            case BUSTER_FASM_CAS:\n            case BUSTER_FASM_FETCH_ADD:\n                x86_u8(obj, 0x2eu);"),
 ('and-no-lock', 'cc', "            case BUSTER_FASM_AND:\n            case BUSTER_FASM_OR:\n                x86_u8(obj, lock);", "            case BUSTER_FASM_AND:\n            case BUSTER_FASM_OR:\n                x86_u8(obj, 0x2eu);"),
 ('inc-no-lock', 'cc', "            case BUSTER_FASM_INC:\n            case BUSTER_FASM_DEC:\n                x86_u8(obj, lock);", "            case BUSTER_FASM_INC:\n            case BUSTER_FASM_DEC:\n                x86_u8(obj, 0x2eu);"),
 ('store-no-fence', 'cc', "                x86_u8(obj, lock);\n                x86_u8(obj, 0x83u);", "                x86_u8(obj, 0x2eu);\n                x86_u8(obj, 0x83u);"),
 ('or-is-and', 'cc', "                x86_u8(obj, shape == BUSTER_FASM_AND ? 0x21u : 0x09u);", "                x86_u8(obj, 0x21u);"),
 ('dec-is-inc', 'cc', "                x86_u8(obj, shape == BUSTER_FASM_INC ? 0x02u : 0x0au);", "                x86_u8(obj, 0x02u);"),
 ('pause-is-nop', 'cc', "                x86_u8(obj, 0xf3u);\n                x86_u8(obj, 0x90u);", "                x86_u8(obj, 0x90u);\n                x86_u8(obj, 0x90u);"),
 ('bsr-no-xor', 'cc', "                if (shape == BUSTER_FASM_BSR)\n                {\n                    if (wide != 0u) { x86_u8(obj, wide); }", "                if (shape == 99u)\n                {\n                    if (wide != 0u) { x86_u8(obj, wide); }"),
 ('bsr-is-bsf', 'cc', "                x86_u8(obj, shape == BUSTER_FASM_BSF ? 0xbcu : 0xbdu);", "                x86_u8(obj, 0xbcu);"),
 ('out-not-stored', 'cc', "        if (outs != 0u && (out.kind == 'a' || out.kind == 'r'))", "        if (outs != 0u && out.kind == 'a')"),
 ('out-stored-wide', 'cc', "            x86_store(obj, FREG_RBP, out.off, FREG_RAX, out.size);", "            x86_store(obj, FREG_RBP, out.off, FREG_RAX, 8u);"),
 ('dispatch-off', 'cc', "    const uint32_t atomic = fast_cc_peek(cc) == FTOK_LPAREN ? fast_cc_asm_atomic_shape(cc, cc->pos + 1u) : BUSTER_FASM_NONE;", "    const uint32_t atomic = BUSTER_FASM_NONE + 0u * fast_cc_peek(cc);"),
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
