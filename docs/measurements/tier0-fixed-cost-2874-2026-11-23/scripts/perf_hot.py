#!/usr/bin/env python3
"""perf_hot.py UNSTRIPPED DIR EVENT PERIOD DIVISOR FUNCTION [TOP] [BEFORE]: a symbol's hottest sampled addresses with
the instructions before each (buster#2874)."""
import bisect, subprocess, sys
binary, directory, event, period, divisor, fn = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), float(sys.argv[5]), sys.argv[6]
top = int(sys.argv[7]) if len(sys.argv) > 7 else 4
before = int(sys.argv[8]) if len(sys.argv) > 8 else 56
out = subprocess.run(['nm', '-S', '--defined-only', binary], capture_output=True, text=True).stdout
syms = sorted((int(p[0], 16), int(p[1], 16), p[3]) for p in (l.split() for l in out.splitlines()) if len(p) == 4 and p[2] in 'tTwW')
starts = [s[0] for s in syms]
rows = []
for line in open(f'{directory}/{event}.ips'):
    c, a = line.split(); a = int(a, 16); i = bisect.bisect_right(starts, a) - 1
    if i >= 0 and a < syms[i][0] + max(syms[i][1], 1) and syms[i][2].replace('.buster_split', '') == fn:
        rows.append((int(c), a))
rows.sort(reverse=True)
print(fn, 'total', round(sum(c for c, _ in rows) * period / divisor, 1))
for c, a in rows[:top]:
    print(f'  {c * period / divisor:7.1f} at {a:#x}')
    d = subprocess.run(['/usr/local/bin/llvm-objdump', '-d', '--no-show-raw-insn', '-l', f'--start-address={a - before:#x}', f'--stop-address={a + 12:#x}', binary], capture_output=True, text=True).stdout
    for l in d.split('\n')[6:]:
        if l.strip():
            print('        ', l.strip()[:130])
