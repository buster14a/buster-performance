#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# body_share.py WHOLE.work.tsv SPINE.work.tsv STAGE-FUNCTIONS.tsv RUNS BODY_TOKENS [TOP]: each function's cycles and
# instructions in the whole unit's compile and in its file scope's (spineprofile.sh), per compile, and their
# difference, the function bodies' cost in it, per body token; grouped by the stage whose time the function's samples
# fell in most (stage_reduce.py --functions).
import sys, collections

whole_path, spine_path, stage_path, runs, body_tokens = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5])
top = int(sys.argv[6]) if len(sys.argv) > 6 else 12

def load(path):
    rows = {}
    header = None
    for line in open(path):
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p[1:]
            continue
        if len(p) == len(header) + 1:
            rows[p[0]] = [float(v) / runs for v in p[1:]]
    return header, rows

header, whole = load(whole_path)
_, spine = load(spine_path)
home = {}
best = collections.Counter()
stage = None
for line in open(stage_path):
    line = line.rstrip('\n')
    if line.startswith('## '):
        stage = line[3:]
        continue
    if stage is None or line.startswith('#') or not line:
        continue
    p = line.split('\t')
    if len(p) >= 2 and float(p[1]) > best[p[0]]:
        best[p[0]] = float(p[1])
        home[p[0]] = stage
groups = collections.defaultdict(list)
width = len(header)
# Every function of either compile: one only the file scope's compile ran (its warnings' printing) counts against the
# bodies, so that the total is the two compiles' difference.
for name in sorted(set(whole) | set(spine)):
    values = whole.get(name, [0.0] * width)
    s = spine.get(name, [0.0] * width)
    groups[home.get(name, 'unmapped')].append((name, values, s))
totals = []
for stage, rows in groups.items():
    w = sum(r[1][0] for r in rows); s = sum(r[2][0] for r in rows)
    wi = sum(r[1][1] for r in rows); si = sum(r[2][1] for r in rows)
    totals.append((stage, w, s, wi, si, rows))
totals.sort(key=lambda x: -(x[1] - x[2]))
gw = sum(t[1] for t in totals); gs = sum(t[2] for t in totals)
print(f'# per compile; bodies = whole - file scope; per body token over {body_tokens} tokens')
print('stage or function\twhole Mcycles\tfile scope Mcycles\tbodies Mcycles\tbodies cycles/body token\tbodies instructions/body token\tbodies share of whole')
for stage, w, s, wi, si, rows in totals:
    if w < 0.002 * gw: continue
    print(f'{stage}\t{w / 1e6:.1f}\t{s / 1e6:.1f}\t{(w - s) / 1e6:.1f}\t{(w - s) / body_tokens:.1f}\t{(wi - si) / body_tokens:.1f}\t{100 * (w - s) / w:.0f}%')
    rows.sort(key=lambda r: -(r[1][0] - r[2][0]))
    for name, values, sv in rows[:top]:
        d = values[0] - sv[0]
        if d < 0.0015 * gw: break
        print(f'  {name}\t{values[0] / 1e6:.2f}\t{sv[0] / 1e6:.2f}\t{d / 1e6:.2f}\t{d / body_tokens:.1f}\t{(values[1] - sv[1]) / body_tokens:.1f}\t{100 * d / values[0] if values[0] else 0:.0f}%')
gwi = sum(t[3] for t in totals); gsi = sum(t[4] for t in totals)
print(f'total\t{gw / 1e6:.1f}\t{gs / 1e6:.1f}\t{(gw - gs) / 1e6:.1f}\t{(gw - gs) / body_tokens:.1f}\t{(gwi - gsi) / body_tokens:.1f}\t{100 * (gw - gs) / gw:.0f}%')
