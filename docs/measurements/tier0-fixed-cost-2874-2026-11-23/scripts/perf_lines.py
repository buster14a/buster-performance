#!/usr/bin/env python3
"""perf_lines.py UNSTRIPPED EVENT.ips PERIOD RUNS FUNCTION [--top N]: a function's samples by the innermost inlined
frame's function and line (buster#2874)."""
import bisect, collections, subprocess, sys
S = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer'
binary, path, period, runs, fn = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), sys.argv[5]
out = subprocess.run(['nm', '-S', '--defined-only', binary], capture_output=True, text=True).stdout
syms = sorted((int(p[0], 16), int(p[1], 16), p[3]) for p in (l.split() for l in out.splitlines()) if len(p) == 4 and p[2] in 'tTwW')
starts = [s[0] for s in syms]
addrs = []
for line in open(path):
    c, a = line.split(); a = int(a, 16); i = bisect.bisect_right(starts, a) - 1
    if i >= 0 and a < syms[i][0] + max(syms[i][1], 1) and syms[i][2].replace('.buster_split', '') == fn:
        addrs.append((a, int(c)))
r = subprocess.run([S, '--obj=' + binary, '--inlines', '--functions=short', '--output-style=LLVM'], input='\n'.join(hex(a) for a, _ in addrs) + '\n', capture_output=True, text=True).stdout
agg = collections.Counter(); byfn = collections.Counter(); total = 0
for (a, c), g in zip(addrs, r.strip().split('\n\n')):
    ls = g.split('\n')
    key = ls[0] + ':' + ls[1].rsplit('/', 1)[-1].rsplit(':', 1)[0]
    agg[key] += c; byfn[ls[0]] += c; total += c
print(f"{fn}: {total * period / runs / 1e6:.3f} M a run")
top = int(sys.argv[sys.argv.index('--top') + 1]) if '--top' in sys.argv else 16
print(' by innermost function:')
for k, v in byfn.most_common(top):
    print(f"   {100 * v / total:5.1f}%  {v * period / runs / 1e3:8.1f}K  {k}")
print(' by line:')
for k, v in agg.most_common(top):
    print(f"   {100 * v / total:5.1f}%  {v * period / runs / 1e3:8.1f}K  {k}")
