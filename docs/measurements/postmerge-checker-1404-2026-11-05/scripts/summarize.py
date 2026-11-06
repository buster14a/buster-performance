#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
"""Summarize retained time-runs and #673 cohort receipts; no measurements run here."""
import csv
import json
from pathlib import Path
import re
import statistics
import sys

root = Path(sys.argv[1])
summaries = {}
builds = {}
for path in sorted(root.glob('*.txt')):
    rows = []
    metric = None
    for line in path.read_text().splitlines():
        if re.match(r'list \d+, ', line):
            metric = line.rstrip(':')
        aggregate = re.match(r'  (baseline|postmerge): (\d+) runs, median ([\d.]+)(.*)', line)
        if aggregate and metric:
            name, count, median, suffix = aggregate.groups()
            change = re.search(r'against baseline ([+-][\d.]+)%', suffix)
            builds.setdefault(path.name, {}).setdefault(metric, {})[name] = {'runs': int(count), 'median': float(median),
                                                                           'change_percent': float(change.group(1)) if change else 0.0,
                                                                           'spread': suffix.strip('; ')}
        if ' runs, median ' not in line or ' ms wall (' not in line:
            continue
        match = re.search(r']: (\d+) runs, median ([\d.]+) ms wall \(([\d.]+) to ([\d.]+)\), ([\d.]+) ms user, ([\d.]+) ms system, (\d+) KiB wait4 peak, (\d+) minor faults, (\d+) major, (\d+) user cycles, (\d+) instructions', line)
        if match:
            rows.append(dict(zip(('runs', 'wall_ms', 'wall_low_ms', 'wall_high_ms', 'user_ms', 'system_ms', 'maxrss_kb', 'minor_faults', 'major_faults', 'user_cycles', 'instructions'), map(float, match.groups()))))
    if rows:
        summaries[path.name] = rows
(root / 'single-summary.json').write_text(json.dumps(summaries, indent=2) + '\n')
(root / 'build-summary.json').write_text(json.dumps(builds, indent=2) + '\n')

cohorts = []
for path in sorted((root / 'cohorts').glob('*-*-*')):
    if not path.is_dir():
        continue
    round_number, workload, mode = path.name.split('-')
    cases = sorted(path.glob('c*-r*'), key=lambda case: int(case.name.split('-')[0][1:]))
    if (root / 'done').exists():
        assert [int(case.name.split('-')[0][1:]) for case in cases] == list(range(144)), path
        pairs = {(previous, role): 0 for previous in range(6) for role in range(6)}
        previous = 5
        for case in cases:
            role = int(case.name[-1])
            pairs[previous, role] += 1
            previous = role
        assert set(pairs.values()) == {4}, (path, pairs)
    for case in cases:
        usage = json.loads((case / 'sample.usage').read_text())
        assert usage['status'] == 0, case
        events = {}
        with (case / 'perf.csv').open() as stream:
            for row in csv.reader(stream):
                if len(row) >= 3 and row[2] in ('cycles:u', 'instructions:u', 'task-clock', 'page-faults'):
                    events[row[2]] = float(row[0])
        assert events['cycles:u'] > 0 and events['instructions:u'] > 0, case
        units = [json.loads((case / f'{unit}.usage').read_text()) for unit in range(8)]
        assert all(unit['status'] == 0 for unit in units), case
        receipts = [re.findall(r'^worker-budget\t([^\n]+)', (case / f'{unit}.stderr').read_text(), re.M) for unit in range(8)]
        assert all(len(unit) == 1 for unit in receipts), case
        role = int(case.name[-1])
        fields = [dict(item.split('=', 1) for item in unit[0].split('\t')) for unit in receipts]
        for unit in fields:
            assert unit['mode'] == ('none' if role % 3 == 2 else 'jobserver'), (case, unit)
            assert int(unit['limit']) == (1 if role % 3 == 1 else 8), (case, unit)
            assert 1 <= int(unit['requested']) <= int(unit['limit']), (case, unit)
            assert 1 <= int(unit['granted']) <= int(unit['limit']), (case, unit)
            assert int(unit['fallback']) == 0, (case, unit)
        argv = (case / 'argv.txt').read_text().splitlines()
        assert any(line.startswith('OPTIONS=--lanes=8 --worker-budget=') and
                   ('--no-deferred-bodies' if role < 3 else '--deferred-bodies') in line for line in argv), case
        actual_mode = ('source' if role < 3 else 'deferred') if mode == 'balanced' else mode
        cohorts.append({'round': int(round_number), 'workload': int(workload), 'mode': actual_mode, 'role': role % 3,
                        'case': case.name, 'wall_ms': usage['wall_s'] * 1000, 'user_cycles': events['cycles:u'],
                        'instructions': events['instructions:u'], 'max_unit_rusage_rss_kb': max(unit['maxrss_kb'] for unit in units),
                        'receipts': [unit[0] for unit in receipts]})
if cohorts:
    if (root / 'done').exists():
        assert len(cohorts) == 432, len(cohorts)
        for workload in range(3):
            for role in range(3):
                for mode in ('source', 'deferred'):
                    assert sum(row['workload'] == workload and row['role'] == role and row['mode'] == mode for row in cohorts) == 24
    (root / 'cohort-samples.json').write_text(json.dumps(cohorts, indent=2) + '\n')
    with (root / 'cohort-summary.tsv').open('w') as stream:
        writer = csv.writer(stream, delimiter='\t', lineterminator='\n')
        writer.writerow(('workload', 'role', 'mode', 'samples', 'wall_ms', 'wall_min_ms', 'wall_max_ms', 'user_cycles', 'instructions', 'max_unit_rusage_rss_kb'))
        for workload in range(3):
            for role in range(3):
                for mode in ('source', 'deferred'):
                    rows = [row for row in cohorts if row['workload'] == workload and row['role'] == role and row['mode'] == mode]
                    if rows:
                        writer.writerow((workload, role, mode, len(rows), statistics.median(row['wall_ms'] for row in rows),
                                         min(row['wall_ms'] for row in rows), max(row['wall_ms'] for row in rows),
                                         statistics.median(row['user_cycles'] for row in rows), statistics.median(row['instructions'] for row in rows),
                                         statistics.median(row['max_unit_rusage_rss_kb'] for row in rows)))
