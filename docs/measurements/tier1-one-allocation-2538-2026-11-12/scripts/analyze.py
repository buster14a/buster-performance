#!/usr/bin/env python3
# analyze.py RESULTS_DIR CORPUS... : per configuration the medians of runs.tsv (wall ms, user cycles, user instructions),
# per placement each tree's change in user cycles and instructions against main's, their mean and range over
# placements, and the peaks (peaks.tsv, without perf). Prints Markdown.
import sys, statistics, collections
root = sys.argv[1]
for corpus in sys.argv[2:]:
    rows = collections.defaultdict(list)
    fields = None
    for line in open(f'{root}/{corpus}/runs.tsv'):
        parts = line.rstrip('\n').split('\t')
        if parts[0] == 'phase':
            fields = parts[5:]
            continue
        if parts[0] != 'run':
            continue
        if parts[4] != '0':
            print('nonzero status', corpus, parts[:5])
        rows[parts[3]].append(dict(zip(fields, map(float, parts[5:]))))
    med = {c: {f: statistics.median(r[f] for r in rs) for f in fields} for c, rs in rows.items()}
    trees, shifts = [], []
    for c in rows:
        t, s = c.rsplit('-', 1)
        if t not in trees: trees.append(t)
        if s not in shifts: shifts.append(s)
    print(f'\n### {corpus}\n')
    print('| tree | placement | runs | wall ms (range) | user cycles, M | user instructions, M |')
    print('| --- | ---: | ---: | ---: | ---: | ---: |')
    for s in shifts:
        for t in trees:
            c = f'{t}-{s}'
            w = [r['wall_ms'] for r in rows[c]]
            print(f"| {t} | {s} | {len(w)} | {med[c]['wall_ms']:.1f} ({min(w):.1f} to {max(w):.1f}) | {med[c]['user_cycles']/1e6:,.1f} | {med[c]['user_instructions']/1e6:,.1f} |")
    print('\n| tree | user cycles against main, per placement | mean | user instructions, mean | wall ms, mean |')
    print('| --- | --- | ---: | ---: | ---: |')
    for t in trees:
        if t == 'main': continue
        cyc = [med[f'{t}-{s}']['user_cycles'] / med[f'main-{s}']['user_cycles'] - 1 for s in shifts]
        ins = [med[f'{t}-{s}']['user_instructions'] / med[f'main-{s}']['user_instructions'] - 1 for s in shifts]
        wall = [med[f'{t}-{s}']['wall_ms'] / med[f'main-{s}']['wall_ms'] - 1 for s in shifts]
        print(f"| {t} | {', '.join(f'{x*100:+.2f}%' for x in cyc)} | {statistics.mean(cyc)*100:+.2f}% | {statistics.mean(ins)*100:+.2f}% | {statistics.mean(wall)*100:+.2f}% |")
    # main against itself across placements: the placement spread
    base = [med[f'main-{s}']['user_cycles'] for s in shifts]
    print(f"\nmain's user cycles over its placements: {min(base)/1e6:,.1f} to {max(base)/1e6:,.1f} M ({(max(base)/min(base)-1)*100:.2f}% spread)")
    try:
        prow = collections.defaultdict(list)
        for line in open(f'{root}/{corpus}/peaks.tsv'):
            parts = line.rstrip('\n').split('\t')
            if parts[0] == 'run':
                prow[parts[3]].append(float(parts[5 + fields.index('peak_kib')]))
        print('peaks (KiB, median of 3 without perf): ' + ', '.join(f'{c} {statistics.median(v):,.0f}' for c, v in prow.items()))
    except FileNotFoundError:
        pass
