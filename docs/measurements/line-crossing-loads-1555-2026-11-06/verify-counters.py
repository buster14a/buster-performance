#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Summarize retained CSV rows, without asserting lock, execution or perf coverage."""
from collections import defaultdict
import csv
from pathlib import Path
from statistics import median

root = Path(__file__).resolve().parent
workloads = {'sq-c', 'sq-syn'}
events = {'cycles:u', 'instructions:u', 'ls_misal_loads.ma64:u', 'ls_misal_loads.ma4k:u', 'ls_dispatch.ld_dispatch:u'}
configs = {
    'counters-184325.csv': (3, {'main'}),
    'counters-185719.csv': (10, {'main', 'refine'}),
    'counters-185726.csv': (10, {'main', 'lexer'}),
}


def require(condition, message):
    if not condition:
        raise ValueError(message)


for name, (rounds, variants) in configs.items():
    samples = defaultdict(list)
    seen = set()
    with (root / 'logs/counters' / name).open(newline='') as f:
        reader = csv.DictReader(f)
        require(reader.fieldnames == ['round', 'variant', 'workload', 'event', 'value'], 'bad CSV header')
        for row in reader:
            require(None not in row and all(row[key] is not None for key in reader.fieldnames), 'malformed CSV row')
            round_text, variant, workload, event, value = (row[key] for key in reader.fieldnames)
            require(round_text.isascii() and round_text.isdigit() and value.isascii() and value.isdigit(), 'invalid numeric row')
            round_no = int(round_text)
            key = (round_no, variant, workload, event)
            require(1 <= round_no <= rounds and variant in variants and workload in workloads and event in events and key not in seen, 'unexpected or duplicate row')
            seen.add(key)
            samples[(variant, workload, event)].append(int(value))
    require(len(seen) == rounds * len(variants) * len(workloads) * len(events), 'incomplete CSV rows: ' + name)
    for key, values in sorted(samples.items()):
        require(len(values) == rounds, 'incomplete samples')
        print(name, *key, 'n=' + str(len(values)), 'median=' + str(median(values)), 'min=' + str(min(values)), 'max=' + str(max(values)), sep='\t')
print('PASS retained row inventories; lock, subprocess status and event-running coverage are not established')
