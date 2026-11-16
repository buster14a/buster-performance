#!/usr/bin/env python3
# summary.py RESULTS LABEL...: medians over a label's runs of each setting's figures on each corpus: the operators'
# kernel's cycles, instructions and mispredicted branches a unit and an evaluated node, the leaves' and lookups' kernel's a
# taken leaf or lookup, and main's T's a unit and an evaluated node (the shadow's own line in the same runs).
import re, sys, glob, statistics, os
results = sys.argv[1]
for label in sys.argv[2:]:
    groups = {}
    for path in sorted(glob.glob(os.path.join(results, label, 'facts-*-[0-9].txt'))):
        m = re.match(r'facts-([a-z0-9]+?)(-[a-z]+)?-(\d)\.txt', os.path.basename(path))
        corpus, suffix = m.group(1), m.group(2) or ''
        text = open(path).read()
        row = {}
        m = re.search(r"the operators' kernel a unit: cycles=(\d+) instructions=(\d+) mispredicted-branches=(\d+); a record it made: cycles=([\d.]+); a record of the windows: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+); an evaluated node: cycles=([\d.]+) instructions=([\d.]+)", text)
        if m:
            row.update(unit=int(m.group(1)), unit_instructions=int(m.group(2)), unit_mispredicts=int(m.group(3)), made=float(m.group(4)), record=float(m.group(5)),
                       record_mispredicts=float(m.group(7)), node=float(m.group(8)), node_instructions=float(m.group(9)))
        m = re.search(r"the kernel a taken leaf or lookup: cycles=([\d.]+) instructions=([\d.]+) mispredicted-branches=([\d.]+) \(a pass less its windows' given records put in place: ([\d.]+) cycles", text)
        if m:
            row.update(taken=float(m.group(1)), taken_instructions=float(m.group(2)), taken_mispredicts=float(m.group(3)), given=float(m.group(4)))
        m = re.search(r"node-shadow: time sweeps=T passes=\d+ repeat=\d+ cycles=(\d+) instructions=(\d+) ticks=\d+ per-evaluated-node: cycles=([\d.]+) instructions=([\d.]+)", text)
        if m:
            row.update(t_unit=int(m.group(1)), t_node=float(m.group(3)), t_node_instructions=float(m.group(4)))
        m = re.search(r"node-facts: taken identifiers=(\d+) \(([\d.]+)%\) lookups=(\d+) \(([\d.]+)%\) differences=(\d+) list-differences=(\d+) failures=(\d+)", text)
        if m:
            row.update(differences=int(m.group(5)) + int(m.group(6)) + int(m.group(7)))
        m = re.search(r"status (\d+)", text)
        row['status'] = int(m.group(1)) if m else -1
        groups.setdefault((corpus, suffix), []).append(row)
    for (corpus, suffix), rows in sorted(groups.items()):
        keys = sorted({k for r in rows for k in r})
        med = {k: statistics.median([r[k] for r in rows if k in r]) for k in keys}
        spread = {k: (min(r[k] for r in rows if k in r), max(r[k] for r in rows if k in r)) for k in keys}
        parts = []
        for k in ('node', 'node_instructions', 'unit', 'unit_mispredicts', 'record', 'record_mispredicts', 'made', 'taken', 'taken_mispredicts', 'given', 't_node', 't_unit', 'differences', 'status'):
            if k in med:
                v = med[k]
                parts.append('%s=%s' % (k, ('%.2f' % v) if isinstance(v, float) and not float(v).is_integer() else ('%d' % v)) + (' [%.2f..%.2f]' % spread[k] if k in ('node', 'taken') else ''))
        print('%-6s %-8s %-16s runs=%d %s' % (label, corpus, suffix or '-', len(rows), ' '.join(parts)))
