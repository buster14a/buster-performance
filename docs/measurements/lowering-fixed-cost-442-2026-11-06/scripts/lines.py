#!/usr/bin/env python3
# #442: the samples inside the named functions, by source line (addr2line), top N.
import sys, subprocess, bisect, collections
exe, samples, funcs = sys.argv[1], sys.argv[2], set(sys.argv[3].split(',')); top = int(sys.argv[4]) if len(sys.argv) > 4 else 30
syms = []
for line in subprocess.run(['nm', exe], capture_output=True, text=True).stdout.splitlines():
    p = line.split(maxsplit=2)
    if len(p) == 3 and p[1] in 'tT': syms.append((int(p[0], 16), p[2]))
syms.sort(); addrs = [a for a, _ in syms]
pcs = collections.Counter(); n = 0
for line in open(samples):
    a = int(line.split()[0], 16); n += 1
    k = bisect.bisect_right(addrs, a) - 1
    if a < 0x10000000 and k >= 0 and syms[k][1] in funcs: pcs[a] += 1
out = subprocess.run(['addr2line', '-i', '-e', exe] + [hex(a) for a in pcs], capture_output=True, text=True).stdout
# with -i, each address may print several lines (inline chain); take the first (innermost).
res = subprocess.run(['addr2line', '-e', exe] + [hex(a) for a in pcs], capture_output=True, text=True).stdout.splitlines()
lines = collections.Counter()
for (a, c), l in zip(pcs.items(), res): lines[l.rsplit('/', 1)[-1].split(' ')[0]] += c
tot = sum(pcs.values())
print(f'{tot} samples of {n} in {sorted(funcs)}')
for l, c in lines.most_common(top): print(f'{100*c/n:6.2f}% {c:6d} {l}')
