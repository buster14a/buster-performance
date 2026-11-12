#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# stage_of.py STAGE-FUNCTIONS.tsv WORK.tsv: a profile by function (uarch symbols' table) as stages, for a command whose
# stage clock can't split it (a many-unit command's `lanes`). Each function's samples are divided among the stages in
# the proportions the single-unit compile's timed samples gave it (stage_reduce.py --functions' table); a function that
# compile never ran goes to the family its name's prefix names, or to `unmapped`.
import sys, collections

stage_table, work = sys.argv[1], sys.argv[2]
shares = collections.defaultdict(collections.Counter)
stage = None
for line in open(stage_table):
    line = line.rstrip('\n')
    if line.startswith('## '):
        stage = line[3:]
        continue
    if stage is None or line.startswith('#') or not line:
        continue
    p = line.split('\t')
    if len(p) >= 2:
        shares[p[0]][stage] += float(p[1])
prefixes = [('pp_', 'preprocess'), ('tokenize_', 'preprocess'), ('refine_', 'preprocess'), ('c_files', 'preprocess'), ('parse_', 'parse'),
            ('check_input', 'check-input'), ('check_graph', 'check-expressions'), ('check_action', 'check-expressions'),
            ('check_program', 'check-program'), ('check_common', 'check-program'), ('check_control', 'check-program'),
            ('check_lower', 'lower'), ('tier0', 'tier0'), ('x86_', 'tier0'), ('check_init', 'check-declarations')]
totals = collections.defaultdict(collections.Counter)
events = None
for line in open(work):
    p = line.rstrip('\n').split('\t')
    if events is None:
        events = p[1:]
        continue
    if len(p) < len(events) + 1:
        continue
    values = [float(v) for v in p[1:]]
    name = p[0]
    if name in shares:
        whole = sum(shares[name].values())
        for s, v in shares[name].items():
            for e, x in zip(events, values):
                totals[s][e] += x * v / whole
    else:
        s = 'unmapped'
        for prefix, family in prefixes:
            if name.startswith(prefix):
                s = family
                break
        if name.startswith('[') or 'unknown' in name:
            s = 'unmapped'
        for e, x in zip(events, values):
            totals[s][e] += x
grand = collections.Counter()
for s in totals:
    for e in events:
        grand[e] += totals[s][e]
print('stage\t' + '\t'.join(events) + '\tshare of ' + events[0])
for s, c in sorted(totals.items(), key=lambda x: -x[1][events[0]]):
    print(s + '\t' + '\t'.join(f'{c[e]:.0f}' for e in events) + f'\t{100 * c[events[0]] / grand[events[0]]:.1f}%')
print('total\t' + '\t'.join(f'{grand[e]:.0f}' for e in events))
