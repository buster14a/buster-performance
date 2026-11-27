"""Summarize captured AMD Ryzen 7 9700X results. Run from the measurement directory."""
from collections import defaultdict
from pathlib import Path
from statistics import median
import re

root = Path(__file__).resolve().parent
logs = root / 'results'
for path in sorted(root.glob('tags-*.tsv')):
    rows = [list(map(float, line.split())) for line in path.read_text().splitlines()]
    assert len(rows) == 4 * 64 * 3
    for old, name in [(3, 'scalar'), (4, 'gather')]:
        ratios = [row[5] / row[old] for row in rows]
        print(path.name, name, sum(r <= 1 for r in ratios), '/', len(rows), f'{min(ratios):.5f}..{max(ratios):.5f}')

for tier in ('tier0', 'tier1'):
    totals = {}
    for mode in ('scalar', 'gather', 'correct'):
        files = sorted(logs.glob(f'actual-{mode}-{tier}-*.log'))
        assert len(files) == 5
        rows = [[list(map(int, l.split()[1:])) for l in p.read_text().splitlines()] for p in files]
        assert all(len(round_) == 260 for round_ in rows)
        assert all([r[:2] for r in round_] == [r[:2] for r in rows[0]] for round_ in rows)
        totals[mode] = sum(median(c[2] for c in calls) for calls in zip(*rows))
    print(tier, totals, 'candidate/scalar and candidate/gather', *(round(totals['correct']/totals[k],4) for k in ('scalar','gather')))

balanced = defaultdict(list)
for path in sorted([*logs.glob('qbalanced-tier*'), *logs.glob('qfinal-tier*')]):
    for table in path.read_text().split('list 1, user cycles (millions):')[1:]:
        rows = {k: float(v) for k, v in re.findall(r'^  ([\w-]+): .*?median ([\d.]+)', table, re.M)[:3]}
        if len(rows) == 3:
            balanced[path.stem.rsplit('-', 1)[0]].append((rows['correct-head']/rows['fresh'], rows['fresh-control']/rows['fresh']))
print('workload rounds candidate/base control/base')
for key, rows in sorted(balanced.items()):
    print(key, len(rows), *(f'{100*(median(col)-1):+.2f}%' for col in zip(*rows)))
