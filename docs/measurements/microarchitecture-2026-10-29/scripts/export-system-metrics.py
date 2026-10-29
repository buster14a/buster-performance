#!/usr/bin/env python3
"""Index the system-wide metric attempts without validating their semantics."""
import argparse
import csv
import json
import math
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument('directory')
a = p.parse_args()
root = Path(a.directory)
with (root / 'system-metrics-summary.csv').open('w', newline='') as out:
    writer = csv.writer(out, lineterminator='\n')
    writer.writerow(['metric', 'status', 'finite_value', 'unit_and_name', 'minimum_duty_percent', 'classification'])
    for line in (root / 'system-metrics.jsonl').read_text().splitlines():
        row = json.loads(line)
        fields = [s.split(';') for s in row['perf_stat'].splitlines()]
        fields = [f for f in fields if len(f) >= 7 and f[2]]
        duties, values = [], []
        for f in fields:
            try:
                duties.append(float(f[4]))
            except ValueError:
                pass
            try:
                value = float(f[5])
                if math.isfinite(value):
                    values.append((value, f[6]))
            except ValueError:
                pass
        if row['status']:
            classification = 'failed'
        elif not values:
            classification = 'no finite value'
        elif len(duties) != len(fields) or min(duties, default=0) < 99:
            classification = 'finite, below 99% or unavailable duty'
        else:
            classification = 'finite, at least 99% duty; semantics unvalidated'
        value, label = values[0] if values else ('', '')
        writer.writerow([row['metric'], row['status'], value, label,
                         min(duties, default=0), classification])
