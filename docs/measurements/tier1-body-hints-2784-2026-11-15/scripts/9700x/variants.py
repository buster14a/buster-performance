# variants.py RUNS: speedtest1's user cycles by shift, each revision's median over its rounds, and 100 ln(revision / base)
# over the shifts: mean, 95% t interval (7 degrees of freedom), shifts where slower; instructions' 100 ln of medians.
import collections, math, statistics as st, sys
d = collections.defaultdict(list)
for line in open(sys.argv[1]):
    f = line.split()
    kv = dict(x.split('=') for x in f[5:])
    d[(f[3], f[1])].append((float(kv['cycles']) / 1e6, float(kv['instructions']) / 1e6))
shifts = sorted({k[1] for k in d}, key=int)
revs = ['base', 'head', 'nohints', 'nostamps']
print('shift', *[f'{r:>10}' for r in revs])
ratios = collections.defaultdict(list)
for s in shifts:
    med = {r: st.median(c for c, _ in d[(r, s)]) for r in revs}
    print(f'{s:>5}', *[f'{med[r]:10.1f}' for r in revs])
    for r in revs[1:]:
        ratios[r].append(100 * math.log(med[r] / med['base']))
base_instructions = st.median(i for (r, s), v in d.items() if r == 'base' for _, i in v)
for r in revs[1:]:
    x = ratios[r]
    m = st.mean(x)
    se = st.stdev(x) / math.sqrt(len(x))
    instructions = st.median(i for (q, s), v in d.items() if q == r for _, i in v)
    print(f'{r}: user cycles 100 ln vs base, mean {m:+.2f} (95% {m - 2.365 * se:+.2f} to {m + 2.365 * se:+.2f}), slower at {sum(v > 0 for v in x)} of {len(x)}; instructions {100 * math.log(instructions / base_instructions):+.2f}')
