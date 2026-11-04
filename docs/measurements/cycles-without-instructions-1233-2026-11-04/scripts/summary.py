#!/usr/bin/env python3
"""#1233: per hold, the as-built pair (merge at offset 0 against main at offset 0, paired by run) and the merge minus
main over the offsets both trees were measured at, in user cycles; then the mean over holds with its standard error."""
import sys, csv, statistics as st, collections
def load(path):
    v = collections.defaultdict(dict)
    for f in csv.reader(open(path)):
        if f[3] == '0' or f[7] != '0':
            continue
        b = f[5]; b = b[0] + str(int(b[1:]))
        v[(b, f[6], int(f[3]))][f[10].replace(':u', '')] = float(f[8])
    return v
rows = collections.defaultdict(list)
for label, path in [a.split('=') for a in sys.argv[1:]]:
    v = load(path)
    runs = sorted({k[2] for k in v}); copies = sorted({k[1] for k in v})
    offs = sorted({int(k[0][1:]) for k in v})
    e = 'cycles'
    ref = st.median(v[('M0', c, r)][e] for c in copies for r in runs)
    pair = [st.mean(v[('H0', c, r)][e] for c in copies) - st.mean(v[('M0', c, r)][e] for c in copies) for r in runs]
    over = [st.mean(v[(f'H{o}', c, r)][e] for o in offs) - st.mean(v[(f'M{o}', c, r)][e] for o in offs) for r in runs for c in copies]
    spread = {t: [st.median(v[(f'{t}{o}', c, r)][e] for c in copies for r in runs) for o in offs] for t in 'MH'}
    cmd = label.split(':')[0]
    rows[cmd].append((100 * st.mean(pair) / ref, 100 * st.mean(over) / ref))
    print(f'{label:18s} offsets {len(offs)}: as built {100 * st.mean(pair) / ref:+.3f}% ± {100 * st.stdev(pair) / len(pair) ** 0.5 / ref:.3f}%; over offsets {100 * st.mean(over) / ref:+.3f}% ± {100 * st.stdev(over) / len(over) ** 0.5 / ref:.3f}%; offsets spread main {100 * (max(spread["M"]) / min(spread["M"]) - 1):.2f}%, merge {100 * (max(spread["H"]) / min(spread["H"]) - 1):.2f}%')
for cmd, lst in rows.items():
    a = [x[0] for x in lst]; o = [x[1] for x in lst]
    se = lambda x: st.stdev(x) / len(x) ** 0.5 if len(x) > 1 else float('nan')
    print(f'{cmd}: {len(lst)} holds; as built {st.mean(a):+.3f}% ± {se(a):.3f}% (holds {", ".join(f"{x:+.3f}" for x in a)}); over offsets {st.mean(o):+.3f}% ± {se(o):.3f}% (holds {", ".join(f"{x:+.3f}" for x in o)})')
