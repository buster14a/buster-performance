# The per-unit runs' tables: python3 bins.py logs/units-u.tsv|units-v.tsv|units-l.tsv. Each line of a .tsv: a unit,
# its preprocessed bytes, time-runs' status, then each build's median user cycles and instructions. By size: the
# control (no bit again against no bit), bit 12 against the faster and the slower no-bit run, the units where bit 12
# read below both, the bin's cycles pooled against the two no-bit runs' mean, and its instructions against no bit.
import statistics as st, sys
rows = []
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    w = f[3].split()
    d = {w[i]: (int(w[i + 1]), int(w[i + 2])) for i in range(0, len(w) - 2, 3)}
    if f[2] == '0' and set(d) == {'none', 'bit12', 'none-again'}:
        rows.append((int(f[1]), d))
print(f'{len(rows)} units')
bins = [0, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 128000, 10 ** 9]
for a, b in zip(bins, bins[1:]):
    sel = [d for n, d in rows if a <= n < b]
    if not sel:
        continue
    control = [d['none-again'][0] / d['none'][0] - 1 for d in sel]
    low = [d['bit12'][0] / min(d['none'][0], d['none-again'][0]) - 1 for d in sel]
    high = [d['bit12'][0] / max(d['none'][0], d['none-again'][0]) - 1 for d in sel]
    pooled = sum(d['bit12'][0] for d in sel) / sum((d['none'][0] + d['none-again'][0]) / 2 for d in sel) - 1
    instructions = sum(d['bit12'][1] for d in sel) / sum(d['none'][1] for d in sel) - 1
    print(f'{a:>6} to {b:<10} {len(sel):4} units; control median {st.median(control) * 100:+6.2f}% '
          f'[{min(control) * 100:+.1f}%, {max(control) * 100:+.1f}%]; bit 12 against the faster no-bit run median '
          f'{st.median(low) * 100:+.1f}%, the slower median {st.median(high) * 100:+.1f}% (least {min(high) * 100:+.1f}%); '
          f'below both {sum(1 for x in low if x < 0)}; pooled {pooled * 100:+.2f}%; instructions {instructions * 100:+.2f}%')
