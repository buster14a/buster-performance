#!/usr/bin/env python3
# Classify register-to-register moves in an object's functions by context.
import subprocess, re, sys, os, collections
sys.path.insert(0, os.path.dirname(__file__))
from cats import sizes
ARGS = ["rdi","rsi","rdx","rcx","r8","r9"]
def norm(r):
    r = r.lstrip('%')
    m = {"eax":"rax","ebx":"rbx","ecx":"rcx","edx":"rdx","esi":"rsi","edi":"rdi","ebp":"rbp","esp":"rsp"}
    if r in m: return m[r]
    mm = re.match(r'(r\d+)[dwb]?$', r)
    if mm: return mm.group(1)
    return r
def run(path):
    sz = sizes(path)
    out = subprocess.run(["objdump", "-d", "-w", path], capture_output=True, text=True).stdout
    funcs = collections.defaultdict(list); cur = None
    for line in out.splitlines():
        m = re.match(r'^[0-9a-f]+ <(.+)>:$', line)
        if m: cur = m.group(1); continue
        m = re.match(r'^\s*([0-9a-f]+):\t((?:[0-9a-f]{2} )+)\s*\t?(.*)$', line)
        if m and cur in sz and int(m.group(1), 16) < sz[cur][0] + sz[cur][1]:
            funcs[cur].append((len(m.group(2).split()), m.group(3).split('#')[0].strip()))
    cats = collections.Counter(); bts = collections.Counter()
    for f, ins in funcs.items():
        for i, (n, t) in enumerate(ins):
            m = re.match(r'(mov|movl|movq)\s+%(\w+),%(\w+)$', t)
            if not m: continue
            src, dst = norm(m.group(2)), norm(m.group(3))
            if src.startswith(('xmm','k')) or dst.startswith(('xmm','k')): k = "vector"
            else:
                nxt = [x[1] for x in ins[i+1:i+12]]
                prev = [x[1] for x in ins[max(0,i-3):i]]
                callnext = any(x.startswith('call') for x in nxt)
                jmpnext = i + 1 < len(ins) and re.match(r'j', ins[i+1][1]) is not None
                if src == dst: k = "self(32-bit zext)"
                elif dst in ARGS and callnext: k = "to-arg-before-call"
                elif src == "rax" and prev and any(x.startswith('call') for x in prev): k = "result-after-call"
                elif dst == "rax" and i + 1 < len(ins) and (ins[i+1][1].startswith('ret') or ins[i+1][1].startswith('add') or ins[i+1][1].startswith('pop')): k = "to-rax-at-return"
                elif jmpnext: k = "before-jump(edge)"
                elif src in ("rax","rdx") and any(x.startswith(('div','idiv','imul','mul','cqto','cltd')) for x in prev): k = "after-div/mul"
                elif dst in ("rax","rcx") and any(x.startswith(('div','idiv','shl','shr','sar','cqto','cltd','mul')) for x in [y[1] for y in ins[i+1:i+4]]): k = "before-fixed"
                elif i + 1 < len(ins) and re.match(r'(add|sub|imul|and|or|xor|shl|shr|sar|lea|neg|not)\w*\s.*%' + m.group(3) + r'$', ins[i+1][1]): k = "two-address"
                else: k = "other"
            cats[k] += 1; bts[k] += n
    tot = sum(bts.values())
    for k, v in bts.most_common(): print("%-22s %7d moves %8d bytes" % (k, cats[k], v))
    print("total", sum(cats.values()), tot)
for p in sys.argv[1:]: run(p)
