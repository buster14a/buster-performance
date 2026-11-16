#!/usr/bin/env python3
# symdiff.py A B: text symbols whose multiset of sizes differs between two executables (nm -S).
import sys, subprocess, collections
def sizes(path):
    out = subprocess.run(['nm', '-S', '--defined-only', path], capture_output=True, text=True).stdout
    d = collections.defaultdict(list)
    for line in out.splitlines():
        f = line.split()
        if len(f) == 4 and f[2] in 'tT':
            d[f[3]].append(int(f[1], 16))
    return {k: sorted(v) for k, v in d.items()}
a = sizes(sys.argv[1]); b = sizes(sys.argv[2])
for name in sorted(set(a) | set(b)):
    if a.get(name) != b.get(name):
        print(name, a.get(name), '->', b.get(name))
