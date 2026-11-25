#!/usr/bin/env python3
# fnbytes.py BINARY REPO FUNCTION: the machine code bytes of FUNCTION by the source function each instruction's line
# (innermost inline frame) belongs to.
import sys, subprocess, re, collections
binary, repo, fn = sys.argv[1], sys.argv[2], sys.argv[3]
nm = subprocess.run(['nm', '-S', binary], capture_output=True, text=True).stdout
addr = size = None
for l in nm.splitlines():
    p = l.split()
    if len(p) == 4 and p[3] == fn:
        addr, size = int(p[0], 16), int(p[1], 16)
dis = subprocess.run(['/usr/lib/llvm-23/bin/llvm-objdump', '-d', '-l', '--no-show-raw-insn', '--start-address=%d' % addr,
                      '--stop-address=%d' % (addr + size), binary], capture_output=True, text=True).stdout
files = ['c_direct_cc.c', 'c_direct_lex.c', 'c_direct_types.c', 'c_direct_x86.c', 'c_direct.c']
func_of = {}
for f in files:
    lines = open(repo + '/src/buster/compiler/' + f).read().split('\n')
    cur = None
    for i, l in enumerate(lines):
        if cur is None and re.match(r'^(static|bool|void|uint|int|FastTok|FastLexed|const|BUSTER_)', l) and '(' in l and not l.rstrip().endswith(';'):
            m = re.search(r"(\w+)\s*\(", re.sub(r"__attribute__\(\([^)]*\)\)|BUSTER_\w+ ", "", l).split("=")[0])
            if m: cur = m.group(1)
        if cur: func_of['%s:%d' % (f, i + 1)] = cur
        if l.startswith('}'): cur = None
where = '?'
prev = None
bytes_by = collections.Counter()
for l in dis.splitlines():
    m = re.match(r'^; .*/([\w.]+):(\d+)', l)
    if m:
        where = func_of.get('%s:%s' % (m.group(1), m.group(2)), m.group(1)); continue
    m = re.match(r'^\s+([0-9a-f]+):', l)
    if m:
        a = int(m.group(1), 16)
        if prev is not None: bytes_by[prev[1]] += a - prev[0]
        prev = (a, where)
if prev: bytes_by[prev[1]] += addr + size - prev[0]
for k, v in bytes_by.most_common(25): print('%6d %s' % (v, k))
