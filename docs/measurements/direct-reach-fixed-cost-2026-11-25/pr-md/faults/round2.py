import subprocess, sys, os, shutil, concurrent.futures
SRC = '/home/user/buster-md/src/buster/compiler'
CL = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
OUT = '/tmp/claude-0/faults9'
M = [
 ('find-off-by-one', 'lex', "result = same != 0 ? i + (uint32_t)__builtin_ctz(same) + 1u : 0u;", "result = same != 0 ? i + (uint32_t)__builtin_ctz(same) : 0u;"),
 ('find-no-device', 'lex', "const uint32_t same = (uint32_t)(_mm512_mask_cmpeq_epi64_mask(live, devices, want_device) & _mm512_mask_cmpeq_epi64_mask(live, inodes, want_inode));", "const uint32_t same = (uint32_t)((_mm512_mask_cmpeq_epi64_mask(live, devices, want_device) | live) & _mm512_mask_cmpeq_epi64_mask(live, inodes, want_inode));"),
 ('find-no-inode', 'lex', "const uint32_t same = (uint32_t)(_mm512_mask_cmpeq_epi64_mask(live, devices, want_device) & _mm512_mask_cmpeq_epi64_mask(live, inodes, want_inode));", "const uint32_t same = (uint32_t)(_mm512_mask_cmpeq_epi64_mask(live, devices, want_device) & (_mm512_mask_cmpeq_epi64_mask(live, inodes, want_inode) | live));"),
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
