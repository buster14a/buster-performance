#!/usr/bin/env python3
# Joins a stephist histogram with objdump's disassembly: instructions by function and by class.
import re, subprocess, sys, collections
exe, hist = sys.argv[1], sys.argv[2]
mode = sys.argv[3] if len(sys.argv) > 3 else "summary"
counts = {}
for line in open(hist):
    if line.startswith("#"): continue
    a, c = line.split(); counts[int(a, 16)] = int(c)
dis = subprocess.run(["objdump", "-d", "--no-show-raw-insn", "-M", "intel", exe], capture_output=True, text=True).stdout
func = None; rows = []
for line in dis.splitlines():
    m = re.match(r"^([0-9a-f]+) <(.+)>:$", line)
    if m: func = m.group(2); continue
    m = re.match(r"^\s*([0-9a-f]+):\s+(.*)$", line)
    if m:
        a = int(m.group(1), 16)
        if a in counts: rows.append((a, func, m.group(2).strip(), counts[a]))
def klass(text):
    t = re.sub(r"\s+", " ", text)
    op = t.split(" ")[0]; args = t[len(op):].strip()
    parts = [p.strip() for p in re.split(r",(?![^\[]*\])", args)] if args else []
    mem = [("[" in p) for p in parts]
    stack = [bool(re.search(r"\[(rsp|rbp)[+\-\]]", p)) for p in parts]
    isvec = lambda p: bool(re.match(r"^[xyz]mm\d+", p))
    ismask = lambda p: bool(re.match(r"^k\d", p))
    isgpr = lambda p: bool(re.match(r"^(r[a-z0-9]+|e[a-z]{2}|[a-ds][il]|[a-d]x|[sb]pl?|[sd]il?|r\d+[dwb]?)$", p))
    isimm = lambda p: bool(re.match(r"^-?(0x)?[0-9a-f]+$", p))
    vmov = op in ("vmovdqu64","vmovdqa64","vmovdqu8","vmovdqu","vmovdqa","vmovups","vmovaps","vmovdqu32","vmovdqa32","movdqu","movdqa","movups","movaps","vmovdqu16","vmovupd","vmovapd")
    if op in ("call","ret","push","pop","leave") : return "call/ret/push/pop"
    if op.startswith("j"): return "branch"
    if op.startswith("kmov"):
        if any(stack): return "mask<->stack"
        if len(parts)==2 and ismask(parts[0]) and ismask(parts[1]): return "mask<-mask move"
        if any(mem): return "mask<->memory"
        return "mask<->gpr"
    if vmov and len(parts) >= 2:
        if "{" in t: return "compute(vector masked move)"
        if stack[0]: return "vector->stack store"
        if stack[-1]: return "vector<-stack load"
        if isvec(parts[0]) and isvec(parts[-1]): return "vector<-vector move"
        if mem[0]: return "vector->memory store"
        return "vector<-memory load"
    if op in ("mov","movzx","movsx","movsxd","movabs") and len(parts)==2:
        if stack[0] and isimm(parts[1]): return "imm->stack store"
        if stack[0]: return "gpr->stack store"
        if stack[1]: return "gpr<-stack load"
        if isgpr(parts[0]) and isgpr(parts[1]):
            return "gpr<-gpr move" if op=="mov" else "compute(extend)"
        if isgpr(parts[0]) and isimm(parts[1]): return "gpr<-imm"
        if mem[0]: return "gpr->memory store"
        if mem[1]: return "gpr<-memory load"
    if op in ("vmovq","vmovd","movq","movd"): 
        if any(stack): return "vector<->stack (scalar)"
        return "vector<->gpr"
    if op == "lea": return "lea"
    if any(stack): return "compute(stack operand)"
    if op.startswith("v") or op.startswith("k") or op.startswith("p"): return "compute(vector/mask)"
    return "compute(scalar)"
total = sum(r[3] for r in rows)
if mode == "summary":
    byf = collections.Counter(); byc = collections.Counter()
    for a, f, t, c in rows: byf[f] += c; byc[klass(t)] += c
    print(f"total {total}")
    for f, c in byf.most_common(12): print(f"  {c:12d} {100*c/total:6.2f}%  {f}")
    print("classes:")
    for k, c in byc.most_common(): print(f"  {c:12d} {100*c/total:6.2f}%  {k}")
elif mode == "dump":
    for a, f, t, c in rows: print(f"{c:10d} {a:8x} {f:28s} {klass(t):28s} {t}")
