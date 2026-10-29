#!/usr/bin/env python3
# The paired logs' table: each benchmark row's median over its rounds per tree, main against head, with the ranges.
import re, sys, statistics, os
d = sys.argv[1]
def read(name):
    with open(os.path.join(d, name)) as f:
        return f.read()
def ir_rows(text):
    rows = {}
    size = None
    for line in text.splitlines():
        m = re.match(r'function: (\d+) instructions', line)
        if m:
            size = m.group(1)
        m = re.match(r'(scalar|vector|uses|cfg)\s+([\d.]+)\s+([\d.]+)', line)
        if m and size:
            rows[f'verifier {size} instr: {m.group(1)} (ns/instruction)'] = float(m.group(3))
    return rows
def lowering_rows(text):
    rows = {}
    section = None
    for line in text.splitlines():
        m = re.match(r'([a-z -]+ programs):', line)
        if m:
            section = m.group(1)
        m = re.match(r'(scalar|vector)\s+([\d.]+)\s+([\d.]+)', line)
        if m and section:
            rows[f'lowering {section}: {m.group(1)} (ns/typed entry)'] = float(m.group(3))
    return rows
def optimize_rows(text, prefix):
    rows = {}
    work = None
    for line in text.splitlines():
        m = re.match(r'(ir-optimize(?:-passes)?\S*) (\S+)', line)
        if m and 'ns/function' not in line:
            work = m.group(2)
        m = re.match(r'\s+(scalar|vector)\s+ns/function=([\d.]+)', line)
        if m and work:
            rows[f'{prefix} {work}: {m.group(1)} (ns/function)'] = float(m.group(2))
        m = re.match(r'ir-pass (\S+) (\S+) (scalar|vector) samples=\d+ repeats=\d+ ns=([\d.]+)', line)
        if m:
            rows[f'{prefix} {m.group(1)} {m.group(2)}: {m.group(3)} (ns/function)'] = float(m.group(4))
    return rows
def table(kind, parse, rounds):
    data = {}
    for tree in ('main', 'head'):
        for r in rounds:
            name = f'pair-{kind}-{tree}-{r}.log'
            if not os.path.exists(os.path.join(d, name)):
                continue
            for k, v in parse(read(name)).items():
                data.setdefault(k, {}).setdefault(tree, []).append(v)
    out = []
    for k, v in data.items():
        if 'main' in v and 'head' in v:
            m = statistics.median(v['main'])
            h = statistics.median(v['head'])
            out.append((k, m, h, 100.0 * (h - m) / m, min(v['main']), max(v['main']), min(v['head']), max(v['head']), len(v['main'])))
    return out
rows = []
rows += table('benchmark-ir', ir_rows, (1, 2, 3))
rows += table('benchmark-ir-lowering', lowering_rows, (1, 2, 3))
rows += table('benchmark-ir-optimize', lambda t: optimize_rows(t, 'optimize'), (1, 2))
rows += table('benchmark-ir-optimize-passes', lambda t: optimize_rows(t, 'passes'), (1, 2))
print('| Measurement | main | head | change | main range | head range | rounds |')
print('| --- | ---: | ---: | ---: | --- | --- | ---: |')
for k, m, h, c, mlo, mhi, hlo, hhi, n in rows:
    print(f'| {k} | {m:.3f} | {h:.3f} | {c:+.1f}% | {mlo:.3f}-{mhi:.3f} | {hlo:.3f}-{hhi:.3f} | {n} |')
