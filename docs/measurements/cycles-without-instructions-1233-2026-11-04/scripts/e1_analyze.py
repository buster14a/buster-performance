#!/usr/bin/env python3
"""#1233 E1: per regime, command, group and event, each build's median and mean against the reference build (M, or
M-self in the primed regime), paired by run, with the paired mean's standard error."""
import sys, csv, statistics as st, collections
rows = collections.defaultdict(dict)   # (regime, cmd, group, run, build) -> {event: value}
prev = {}
bad = 0
for path in sys.argv[1:]:
    for f in csv.reader(open(path)):
        regime, cmd, group, run, pos, build, before, status = f[:8]
        value, unit, event = f[8], f[9], f[10]
        pct = f[12] if len(f) > 12 else ''
        if run == '0':
            continue
        if status != '0' or value.startswith('<'):
            bad += 1; continue
        if pct and pct not in ('100.00', ''):
            print('multiplexed', f); bad += 1
        event = event.replace(':u', '')
        rows[(regime, cmd, group, int(run), build)][event] = float(value)
        prev[(regime, cmd, group, int(run), build)] = before
print('bad lines', bad)
for regime, cmd, group in sorted({k[:3] for k in rows}):
    runs = sorted({k[3] for k in rows if k[:3] == (regime, cmd, group)})
    builds = sorted({k[4] for k in rows if k[:3] == (regime, cmd, group)})
    ref = 'M' if 'M' in builds else 'M-self'
    builds = [ref] + [b for b in builds if b != ref]
    events = list(rows[(regime, cmd, group, runs[0], ref)].keys())
    print(f'== {regime} {cmd} group {group}: {len(runs)} runs; builds {builds}')
    for e in events:
        line = f'  {e[:48]:48s}'
        for b in builds:
            pairs = [(rows[(regime, cmd, group, r, b)][e], rows[(regime, cmd, group, r, ref)][e]) for r in runs
                     if e in rows.get((regime, cmd, group, r, b), {}) and e in rows.get((regime, cmd, group, r, ref), {})]
            v = [p[0] for p in pairs]
            if b == ref:
                line += f' {b} med {st.median(v):.6g} mean {st.mean(v):.6g} |'
            else:
                d = [p[0] - p[1] for p in pairs]
                se = st.stdev(d) / len(d) ** 0.5
                rm = st.median(rows[(regime, cmd, group, r, ref)][e] for r in runs)
                line += f' {b} {100 * (st.median(v) / rm - 1) if rm else 0:+.2f}% med, d {st.mean(d):+.4g}±{se:.3g} |'
        print(line)
