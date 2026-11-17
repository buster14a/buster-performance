#!/usr/bin/env python3
# Per-category byte census of two objects' matched functions: objdump -d, category by mnemonic/operands.
import subprocess, sys, re, collections
def sizes(path):
    out = subprocess.run(["nm", "-S", "--defined-only", path], capture_output=True, text=True).stdout
    r = {}
    for line in out.splitlines():
        p = line.split()
        if len(p) == 4 and p[2] in "tT": r[p[3]] = (int(p[0], 16), int(p[1], 16))
    return r
def disasm(path):
    sz = sizes(path)
    out = subprocess.run(["objdump", "-d", "-w", path], capture_output=True, text=True).stdout
    funcs = {}
    cur = None
    for line in out.splitlines():
        m = re.match(r'^[0-9a-f]+ <(.+)>:$', line)
        if m:
            cur = m.group(1); funcs[cur] = []; continue
        m = re.match(r'^\s*([0-9a-f]+):\t((?:[0-9a-f]{2} )+)\s*\t?(.*)$', line)
        if m and cur is not None and cur in sz and int(m.group(1), 16) < sz[cur][0] + sz[cur][1]:
            nbytes = len(m.group(2).split())
            text = m.group(3).strip()
            if text == "" and funcs[cur]:
                funcs[cur][-1] = (funcs[cur][-1][0] + nbytes, funcs[cur][-1][1]); continue
            funcs[cur].append((nbytes, text))
    return funcs
def category(text):
    t = text.split('#')[0].strip()
    parts = t.split(None, 1)
    if not parts: return "empty"
    mn = parts[0]; ops = parts[1] if len(parts) > 1 else ""
    stack = ("(%rsp" in ops) or ("(%rbp" in ops)
    if mn in ("nop","nopw","nopl","xchg") and "%ax,%ax" in ops or mn.startswith("nop") or mn == "int3": return "pad"
    if mn.startswith("call"): return "call"
    if mn.startswith("j"): return "jump"
    if mn.startswith("ret"): return "ret"
    if mn.startswith("push") or mn.startswith("pop"): return "pushpop"
    if mn == "lea" or mn.startswith("lea"):
        return "lea-stack" if stack else "lea"
    if mn.startswith("mov") or mn.startswith("cmov"):
        if stack:
            if ops.endswith("(%rsp)") or ops.endswith("(%rbp)") or re.search(r'\(%r[sb]p[^)]*\)$', ops): return "store-stack"
            return "load-stack"
        if "(" in ops: return "mov-mem"
        if "$" in ops: return "mov-imm"
        if mn in ("movzbl","movzwl","movsbl","movswl","movslq","movsbq","movswq","movzbq","movzwq","movsbw","movzbw"): return "ext-reg"
        if mn.startswith("cmov"): return "cmov"
        return "mov-reg"
    if mn.startswith("set"): return "setcc"
    if mn in ("cmp","cmpl","cmpq","cmpb","cmpw","test","testl","testq","testb","testw"): return "cmp-stack" if stack else "cmp"
    if mn in ("cltq","cqto","cltd","cwtl"): return "ext-reg"
    if stack: return "alu-stack"
    if "(" in ops: return "alu-mem"
    return "alu"
def census(path):
    f = disasm(path)
    res = {}
    for name, ins in f.items():
        c = collections.Counter(); n = collections.Counter()
        for b, t in ins:
            k = category(t); c[k] += b; n[k] += 1
        res[name] = (c, n, sum(b for b,_ in ins))
    return res
if __name__ == "__main__":
    a = census(sys.argv[1]); b = census(sys.argv[2])
    top = int(sys.argv[3]) if len(sys.argv) > 3 else 0
    tot_a = collections.Counter(); tot_b = collections.Counter(); na = collections.Counter(); nb = collections.Counter()
    for name in a:
        if name in b:
            tot_a.update(a[name][0]); tot_b.update(b[name][0]); na.update(a[name][1]); nb.update(b[name][1])
    print("%-12s %10s %10s %10s %8s %8s" % ("category", "tier1", "clang", "diff", "n1", "nc"))
    for k in sorted(set(tot_a) | set(tot_b), key=lambda k: -(tot_a[k]-tot_b[k])):
        print("%-12s %10d %10d %+10d %8d %8d" % (k, tot_a[k], tot_b[k], tot_a[k]-tot_b[k], na[k], nb[k]))
    print("%-12s %10d %10d %+10d" % ("total", sum(tot_a.values()), sum(tot_b.values()), sum(tot_a.values())-sum(tot_b.values())))
    if top:
        rows = sorted(((a[n][2]-b[n][2], n) for n in a if n in b), reverse=True)[:top]
        for d, n in rows: print("%+7d %7d %7d %s" % (d, a[n][2], b[n][2], n))
