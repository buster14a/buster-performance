import sys, re, subprocess
def load(cg, binary):
    syms = {}
    for line in subprocess.run(['nm', binary], capture_output=True, text=True).stdout.splitlines():
        p = line.split()
        if len(p) == 3 and p[1] in 'tT':
            syms[int(p[0], 16)] = p[2]
    out = subprocess.run(['callgrind_annotate', '--threshold=100', '--inclusive=no', cg], capture_output=True, text=True).stdout
    res = {}
    go = False
    for line in out.splitlines():
        if 'file:function' in line: go = True; continue
        if not go: continue
        line = re.sub(r'\([^)]*\)', '', line)
        p = line.split()
        if len(p) < 4: continue
        m = re.search(r'\?\?\?:0x([0-9a-f]+)', line)
        if not m or '[/' in line: continue
        a = int(m.group(1), 16) - 0x108000
        name = syms.get(a, hex(a))
        ir = int(p[0].replace(',', '')); dr = int(p[1].replace(',', '').replace('.', '0'))
        old = res.get(name, (0, 0)); res[name] = (old[0] + ir, old[1] + dr)
    return res
a = load(sys.argv[1], sys.argv[2]); b = load(sys.argv[3], sys.argv[4])
rows = []
for k in set(a) | set(b):
    x = a.get(k, (0, 0)); y = b.get(k, (0, 0))
    rows.append((y[0] - x[0], k, x[0], y[0], x[1], y[1]))
rows.sort(key=lambda r: -abs(r[0]))
for r in rows[:int(sys.argv[5]) if len(sys.argv) > 5 else 15]:
    print(f"{r[1]:30s} Ir {r[2]:>12,} -> {r[3]:>12,} ({r[0]:+,})  Dr {r[4]:>12,} -> {r[5]:>12,} ({r[5]-r[4]:+,})")
