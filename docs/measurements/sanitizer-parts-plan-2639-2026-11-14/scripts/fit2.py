#!/usr/bin/env python3
# fit2.py ALIGN.tsv FEATURES.tsv TRACES... : the code generator's measured time per function (OptFunction events of
# -ftime-trace) against features; candidate cost models; each model's plan by split.c's exact rule (contiguous in module
# order, each part starting in each text section at a function of the greatest alignment it holds there, the costliest
# part as cheap as possible), with and without the alignment rule, scored by the measured times.
import sys, json, re, math
import numpy as np

align_path, feat_path, traces = sys.argv[1], sys.argv[2], sys.argv[3:]
info = {}
order = []
for line in open(align_path):
    c = line.rstrip('\n').split('\t')
    index, al, optsize, minsize, cold, section, n, name = int(c[0]), int(c[1]), int(c[2]), int(c[3]), int(c[4]), c[5], int(c[6]), c[7]
    alignment = max(al, 1 if (optsize or minsize) else 16)
    sec = 1 if section != '-' else (2 if cold else 0)
    info[name] = dict(index=index, alignment=alignment, section=sec)
    order.append(name)
feats = {}
for line in open(feat_path):
    c = line.rstrip('\n').split('\t')
    feats[c[2]] = [int(v) for v in c[3:]]
times = {}
walls = {}
for path in traces:
    part = int(re.search(r'part(\d+)\.json$', path).group(1))
    ev = json.load(open(path))['traceEvents']
    tot = 0
    for e in ev:
        if e.get('ph') == 'X' and e.get('name') == 'OptFunction':
            times[e['args']['detail']] = times.get(e['args']['detail'], 0) + e['dur']
        if e.get('ph') == 'X' and e.get('name') == 'ExecuteCompiler':
            tot = max(tot, e['dur'])
    walls[part] = tot / 1e6
names = [n for n in order if n in feats]
missing = [n for n in names if n not in times]
X = np.array([feats[n] for n in names], dtype=float)
y = np.array([times.get(n, 0) for n in names], dtype=float) / 1e6
A = np.array([info[n]['alignment'] for n in names])
S = np.array([info[n]['section'] for n in names])
print(f'{len(names)} functions, {len(missing)} without an event; functions {y.sum():.1f} s; compiles {sum(walls.values()):.1f} s')
ins, blk, sq, lg, calls, phis, loads, stores, vec, cases, optnone = X.T
on = optnone > 0
off = ~on
print(f'optnone: {on.sum()} functions, {ins[on].sum():.0f} instructions, {y[on].sum():.1f} s ({1000*y[on].sum()/max(1,ins[on].sum()):.4f} s/kinstr); others {ins[off].sum():.0f} instructions, {y[off].sum():.1f} s ({1000*y[off].sum()/ins[off].sum():.4f})')
io = ins * on
inn = ins * off

import subprocess
PLAN = __import__('os').path.expanduser('~/.cache/claude-2639/tools/plan')
def plan(cost, parts=8, rule=True):
    data = '\n'.join(f'{c} {A[i]} {S[i]}' for i, c in enumerate(cost))
    out = subprocess.run([PLAN, str(parts), '1' if rule else '0'], input=data, capture_output=True, text=True, check=True).stdout
    starts = [int(v) for v in out.split()]
    ends = starts[1:] + [len(cost)]
    return list(zip(starts, ends))

def score(name, pred, rule=True):
    pred = np.maximum(pred, 1e-12)
    scale = 1e7 / pred.sum()
    cost = [max(1, int(round(v * scale))) for v in pred]
    b = plan(cost, 8, rule)
    actual = [y[i:j].sum() for i, j in b]
    err = np.abs(pred / pred.sum() * y.sum() - y).sum() / y.sum()
    print(f'  {name:34s} rule={int(rule)} err {err:.2f}  max {max(actual):6.1f}  ' + ' '.join(f'{v:5.1f}' for v in actual) + f'   bounds {[i for i, j in b]}')
    return max(actual)

print('rate by size class (s per 1000 instructions):')
for lo_, hi_ in [(0, 30), (30, 100), (100, 300), (300, 1000), (1000, 3000), (3000, 10000), (10000, 30000), (30000, 10**9)]:
    m = (ins >= lo_) & (ins < hi_) & off
    if m.sum():
        print(f'  [{lo_:6d},{hi_:10d}) {m.sum():5d} fns {y[m].sum():6.1f} s  {1000*y[m].sum()/ins[m].sum():.4f}  blocks/instr {blk[m].sum()/ins[m].sum():.3f}  per-fn {1000*y[m].sum()/m.sum():.2f} ms')
mask = (y > 0) & (ins > 0)
k, b0 = np.polyfit(np.log(ins[mask & off]), np.log(y[mask & off]), 1)
print(f'log-log slope {k:.3f}')
def ls(cols, weight=None):
    M = np.column_stack(cols)
    w = np.ones_like(y) if weight is None else weight
    coef, *_ = np.linalg.lstsq(M * w[:, None], y * w, rcond=None)
    return M @ coef, coef
models = {}
models['current: instr+8'] = np.where(on, (ins + 3) // 4, ins) + 8
models['instr+optnone'], c0 = ls([inn, io, np.ones_like(ins)]); print('instr, optnone instr, 1', c0 * 1e6)
models['instr+blocks*k'], c1 = ls([inn, io, blk, np.ones_like(ins)]); print('instr, optnone, blocks, 1', c1 * 1e6)
models['linear all'], c2 = ls([ins, blk, sq, lg, calls, phis, loads, stores, vec, cases, np.ones_like(ins)]); print('linear all', np.round(c2 * 1e6, 4))
models['instr*log(instr)'], c3 = ls([inn * np.log2(inn + 2), inn, io, np.ones_like(ins)]); print('nlogn, n, optnone, 1', c3 * 1e6)
models['instr^2'], c4 = ls([inn * inn, inn, io, np.ones_like(ins)]); print('n^2, n, optnone, 1', c4 * 1e6)
models[f'instr^{k:.2f}'] = np.where(on, y[on].sum() / ins[on].sum() * ins, np.exp(b0) * ins ** k)
models['oracle (measured)'] = y.copy()
for name, pred in models.items():
    score(name, pred, True)
for name in ['current: instr+8', 'oracle (measured)']:
    score(name, models[name], False)
print('quadratic family: n + n^2/K (optnone n/4), + F per function')
for K in (10000, 15000, 20000, 25000, 35000, 50000, 10**12):
    for F in (8, 30):
        pred = np.where(on, (ins + 3) // 4, ins + ins * ins / K) + F
        score(f'n+n^2/{K} +{F}', pred, True)
for K in (15000, 25000):
    pred = np.where(on, (ins + 3) // 4, ins + ins * ins / K) + 30
    score(f'n+n^2/{K} +30', pred, False)
