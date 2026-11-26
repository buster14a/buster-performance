import re
import sys
from pathlib import Path
from statistics import median

root = Path(sys.argv[1])
phase_rows = {'emit': {}, 'decode': {}, 'check': {}, 'certify': {}}
inventory = {}
for side in ('base', 'head'):
    for phase in phase_rows:
        phase_rows[phase][side] = []
    inventory[side] = set()
    for pair in range(1, 6):
        result = (root / f'{pair}-{side}.txt').read_text()
        counts = re.search(r'^benchmark-tier1-code-certificate: files=.*$', result, re.M)
        assert counts is not None, (pair, side)
        inventory[side].add(counts[0])
        for phase, samples in phase_rows.items():
            metrics = re.search(rf'^{phase}\s+([\d.]+)\s+([\d.]+)\s+([\d.]+)', result, re.M)
            assert metrics is not None, (pair, side, phase)
            samples[side].append(tuple(map(float, metrics.groups())))
for side, counts in inventory.items():
    assert len(counts) == 1, (side, counts)
    print(side, *counts)
for phase, samples in phase_rows.items():
    print(phase)
    for i, metric in enumerate(('ns/IR', 'cycles/IR', 'instructions/IR')):
        base = [row[i] for row in samples['base']]
        head = [row[i] for row in samples['head']]
        ratio = [100 * (h / b - 1) for b, h in zip(base, head, strict=True)]
        print(f'  {metric}: {median(base):.2f} -> {median(head):.2f} '
              f'({100 * (median(head) / median(base) - 1):+.2f}%), '
              f'per-pair range {min(ratio):+.2f}..{max(ratio):+.2f}%')
