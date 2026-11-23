#!/usr/bin/env python3
"""perf_src.py UNSTRIPPED DIR EVENT PERIOD DIVISOR SRCROOT FUNCTION [TOP]: a symbol's samples by the innermost inlined
frame's source line, each count divided by DIVISOR (e.g. loops x functions), with the line's text (buster#2874)."""
import bisect, collections, os, subprocess, sys
S = '/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-symbolizer'
binary, directory, event, period, divisor, root, fn = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), float(sys.argv[5]), sys.argv[6], sys.argv[7]
top = int(sys.argv[8]) if len(sys.argv) > 8 else 14
out = subprocess.run(['nm', '-S', '--defined-only', binary], capture_output=True, text=True).stdout
syms = sorted((int(p[0], 16), int(p[1], 16), p[3]) for p in (l.split() for l in out.splitlines()) if len(p) == 4 and p[2] in 'tTwW')
starts = [s[0] for s in syms]
addrs = []
for line in open(f'{directory}/{event}.ips'):
    c, a = line.split(); a = int(a, 16); i = bisect.bisect_right(starts, a) - 1
    if i >= 0 and a < syms[i][0] + max(syms[i][1], 1) and syms[i][2].replace('.buster_split', '') == fn:
        addrs.append((a, int(c)))
r = subprocess.run([S, '--obj=' + binary, '--inlines', '--functions=short', '--output-style=LLVM'], input='\n'.join(hex(a) for a, _ in addrs) + '\n', capture_output=True, text=True).stdout
agg = collections.Counter(); byfn = collections.Counter(); total = 0
for (a, c), g in zip(addrs, r.strip().split('\n\n')):
    ls = g.split('\n')
    path, line = ls[1].rsplit(':', 2)[0], ls[1].rsplit(':', 2)[1]
    agg[(ls[0], os.path.basename(path), int(line))] += c; byfn[ls[0]] += c; total += c
cache = {}
def text(name, line):
    if name not in cache:
        p = os.path.join(root, 'src/buster/compiler', name)
        cache[name] = open(p).read().split('\n') if os.path.exists(p) else []
    return cache[name][line - 1].strip()[:105] if 0 < line <= len(cache[name]) else ''
print(f"{fn} ({event}): {total * period / divisor:.1f}")
for k, v in byfn.most_common(8):
    print(f"   {v * period / divisor:7.1f}  [{k}]")
for (f, name, line), v in agg.most_common(top):
    print(f"   {v * period / divisor:7.1f}  {f}:{line}: {text(name, line)}")
