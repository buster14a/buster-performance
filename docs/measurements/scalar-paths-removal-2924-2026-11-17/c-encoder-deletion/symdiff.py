import subprocess, sys
from collections import defaultdict
def load(path):
    d = defaultdict(list)
    out = subprocess.run(['nm', '-S', path], capture_output=True, text=True).stdout
    for l in out.splitlines():
        f = l.split()
        if len(f) == 4 and f[2] in ('T', 't') and not f[3].startswith('.L'):
            d[f[3]].append(int(f[1], 16))
    return {k: sorted(v) for k, v in d.items()}
b = load(sys.argv[1]); h = load(sys.argv[2])
rows = []
for n in sorted(set(b) | set(h)):
    if b.get(n) != h.get(n):
        rows.append((sum(h.get(n, [])) - sum(b.get(n, [])), n, b.get(n), h.get(n)))
rows.sort()
for r in rows:
    print(r[0], r[1], r[2], r[3])
