#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# probe_table.py DIR PREFIX [FIELD...]: the probe reports DIR/PREFIX-VARIANT-pMODE-RUN.txt (musl's) or
# DIR/PREFIX-VARIANT-RUN.txt (sqlite3.c's) as one table: a row a stage, and for each variant the medians over its
# mode-1 runs of FIELDs (default: ms cycles-u cycles-k). `lanes-start` is the time between two units of a many-unit
# command. Also prints each variant's lowering phases (time-stage lower.*), tokens and totals.
import os, re, sys, statistics, collections


def read_lines(path):
    # A report's lines, whether the record keeps it as it was written or gzipped (its units' diagnostics make it large).
    if path.endswith('.gz'):
        import gzip
        return gzip.open(path, 'rt', errors='replace')
    return open(path, errors='replace')


directory, prefix = sys.argv[1], sys.argv[2]
fields = sys.argv[3:] or ['ms', 'cycles-u', 'cycles-k']
data = collections.defaultdict(lambda: collections.defaultdict(lambda: collections.defaultdict(list)))
extra = collections.defaultdict(lambda: collections.defaultdict(list))
stages = []
for name in sorted(os.listdir(directory)):
    m = re.fullmatch(re.escape(prefix) + r'-(.+?)(?:-p(\d))?-(\d+)\.txt(?:\.gz)?', name)
    if not m or (m.group(2) not in (None, '1')):
        continue
    variant = m.group(1)
    header = None
    for line in read_lines(os.path.join(directory, name)):
        p = line.rstrip('\n').split('\t')
        if p[0] == 'probe-stage':
            if p[1] == 'stage':
                header = p[2:]
                continue
            if p[1] not in stages:
                stages.append(p[1])
            for h, v in zip(header, p[2:]):
                data[variant][p[1]][h].append(float(v))
        elif p[0] == 'time-stage' and len(p) >= 3 and ('.' in p[1] or p[1] == 'total'):
            extra[variant][p[1]].append(float(p[2]))
        elif p[0] == 'time-process' and p[1] in ('tokens', 'minor-faults', 'user-ms', 'system-ms', 'rusage-peak-rss-kb'):
            extra[variant][p[1]].append(float(p[2]))
        elif p[0] == 'time-check' and p[1].startswith('expressions') and p[1] != 'expressions.usage':
            extra[variant]['check ' + p[1]].append(float(p[2]))
variants = list(data)
print('stage\t' + '\t'.join(f'{v} {f}' for v in variants for f in fields))
totals = collections.defaultdict(float)
for s in stages:
    row = [s]
    for v in variants:
        for f in fields:
            values = data[v][s].get(f, [])
            x = statistics.median(values) if values else 0.0
            totals[(v, f)] += x
            row.append(f'{x:.3f}' if f == 'ms' else f'{x / 1e6:.2f}')
    print('\t'.join(row))
print('sum\t' + '\t'.join(f'{totals[(v, f)]:.3f}' if f == 'ms' else f'{totals[(v, f)] / 1e6:.2f}' for v in variants for f in fields))
print()
keys = []
for v in variants:
    for k in extra[v]:
        if k not in keys:
            keys.append(k)
print('other\t' + '\t'.join(variants))
for k in keys:
    print(k + '\t' + '\t'.join(f'{statistics.median(extra[v][k]):.3f}' if extra[v].get(k) else '' for v in variants))
