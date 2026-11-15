#!/usr/bin/env python3
# chunks.py LABEL CORPUS CHUNK...: for each chunk size's rounds (results/LABEL/time-i<CHUNK>-<CORPUS>-r*.txt on the 9700X,
# results/9700x/LABEL/ in the record), the medians of the tight sets' cycles a taken node, of the walk alone, of each
# interleaved set less the walk, and of the sweeps' own ticks there against the tight set's ticks.
import sys, re, glob, os, statistics
label, corpus = sys.argv[1], sys.argv[2]
base = f'results/{label}' if os.path.isdir(f'results/{label}') else f'results/9700x/{label}'
for chunk in sys.argv[3:]:
    cycles, ticks, inner = {}, {}, {}
    for path in sorted(glob.glob(f'{base}/time-i{chunk}-{corpus}-r*.txt')):
        for line in open(path):
            m = re.search(r'time sweeps=(\S+) .*per-evaluated-node: cycles=([0-9.]+) instructions=([0-9.]+) ticks=([0-9.]+)', line)
            if m:
                cycles.setdefault(m.group(1), []).append(float(m.group(2)))
                ticks.setdefault(m.group(1), []).append(float(m.group(4)))
            m = re.search(r'interleaved sweeps=(\S+) .*per-evaluated-node: ticks=([0-9.]+)', line)
            if m:
                inner.setdefault(m.group(1), []).append(float(m.group(2)))
    if not cycles:
        print(f'chunk {chunk}: missing')
        continue
    med = lambda d, k: statistics.median(d[k]) if k in d else float('nan')
    out = [f'chunk {chunk:>4}: tight T+C+X {med(cycles, "T+C+X"):6.1f} T+CX {med(cycles, "T+CX"):6.1f} Tv+CX {med(cycles, "Tv+CX"):6.1f} | walk {med(cycles, "walk"):6.1f} |']
    for name, tight in (('walk;T+C+X', 'T+C+X'), ('walk;T+CX', 'T+CX'), ('walk;Tv+CX', 'Tv+CX')):
        less = med(cycles, name) - med(cycles, 'walk')
        own = med(inner, name) / med(ticks, tight) * med(cycles, tight) if name in inner else float('nan')
        out.append(f' {name} less walk {less:6.1f}, own {own:6.1f}')
    print(''.join(out))
