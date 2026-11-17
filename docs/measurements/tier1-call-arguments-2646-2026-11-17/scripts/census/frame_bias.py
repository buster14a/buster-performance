#!/usr/bin/env python3
# For each function of a Tier 1 object: bytes its rsp-based memory operands spend on SIB and displacement, and what an
# rbp base at rsp+B would spend (disp8 within [-128,127], else disp32), for the best B; net of the base's setup cost.
import subprocess, re, sys, os, collections
sys.path.insert(0, os.path.dirname(__file__))
from cats import sizes
def funcs(path):
    sz = sizes(path)
    out = subprocess.run(["objdump", "-d", "-w", path], capture_output=True, text=True).stdout
    cur = None; res = collections.defaultdict(list); pushes = collections.Counter()
    for line in out.splitlines():
        m = re.match(r'^[0-9a-f]+ <(.+)>:$', line)
        if m: cur = m.group(1); continue
        m = re.match(r'^\s*([0-9a-f]+):\t((?:[0-9a-f]{2} )+)\s*\t?(.*)$', line)
        if not m or cur is None or cur not in sz or int(m.group(1), 16) >= sz[cur][0] + sz[cur][1]: continue
        t = m.group(3)
        if re.match(r'push\s+%rbp', t): pushes[cur] += 1
        for d in re.findall(r'(-?0x[0-9a-f]+|-?\d+)?\(%rsp\)', t):
            res[cur].append(int(d, 16) if d.startswith(('0x','-0x')) else int(d or 0))
    return res, pushes, sz
def cost_rsp(d): return 1 + (0 if d == 0 else 1 if -128 <= d <= 127 else 4)
def cost_rbp(d, b): x = d - b; return 1 if -128 <= x <= 127 else 4
tot_now = 0; tot_best = 0; gain = 0; nf = 0; nacc = 0; gain_free = 0; nf_free = 0
paths = sys.argv[1:]
for p in paths:
    res, pushes, sz = funcs(p)
    for f, ds in res.items():
        now = sum(cost_rsp(d) for d in ds)
        best = now; 
        for b in range(0, 2048, 8):
            c = sum(min(cost_rsp(d), cost_rbp(d, b)) for d in ds) + (5 if b <= 127 else 8) + 2
            if c < best: best = c
        tot_now += now; tot_best += best; nacc += len(ds)
        if best < now:
            gain += now - best; nf += 1
            if not pushes[f]: gain_free += now - best; nf_free += 1
print("rbp unused: gain", gain_free, "functions", nf_free)
print("accesses", nacc, "bytes on SIB+disp now", tot_now, "with best rbp base", tot_best, "gain", gain, "functions gaining", nf)
