import subprocess, sys, os, shutil, concurrent.futures
SRC = '/home/user/buster-6c/src/buster/compiler'
CL = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
OUT = '/tmp/claude-0/faults10'
M = [('mem-no-star', 'cc', '        ok = fast_cc_peek(cc) == FTOK_STAR;\n        cc->pos += ok ? 1u : 0u;', '        ok = true;\n        cc->pos += fast_cc_peek(cc) == FTOK_STAR ? 1u : 0u;'), ('mem-cast-any', 'cc', '            ok = parsed && !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN && ftype_is_ptr(pointer);', '            ok = parsed && !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN;'), ('out-const-ok', 'cc', '        ok = si != 0 && sym->kind == FSYM_LOCAL && (ftype_is_int(sym->type) || ftype_is_ptr(sym->type)) && !ftype_is_const(sym->type) &&', '        ok = si != 0 && sym->kind == FSYM_LOCAL && (ftype_is_int(sym->type) || ftype_is_ptr(sym->type)) &&'), ('out-float-ok', 'cc', '        ok = si != 0 && sym->kind == FSYM_LOCAL && (ftype_is_int(sym->type) || ftype_is_ptr(sym->type)) && !ftype_is_const(sym->type) &&', '        ok = si != 0 && sym->kind == FSYM_LOCAL && !ftype_is_const(sym->type) &&'), ('in-float-ok', 'cc', '        ok = !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN && (ftype_is_int(value.type) || ftype_is_ptr(value.type));', '        ok = !cc->bailout && fast_cc_peek(cc) == FTOK_RPAREN;'), ('cas-sizes-any', 'cc', '                 out.size == size && in.size == size && inputs[1].size == size;', '                 out.size == size;'), ('bsr-is-bsf', 'cc', '                x86_u8(obj, shape == BUSTER_FASM_BSF ? 0xbcu : 0xbdu);', '                x86_u8(obj, 0xbcu);'), ('out-stored-wide', 'cc', '            x86_store(obj, FREG_RBP, out.off, FREG_RAX, out.size);', '            x86_store(obj, FREG_RBP, out.off, FREG_RAX, 8u);')]

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
