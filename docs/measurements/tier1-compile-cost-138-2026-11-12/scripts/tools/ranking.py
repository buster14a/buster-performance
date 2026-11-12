#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# ranking.py STAGES.tsv WORK.tsv TD.tsv COMPILE_MS: the ranking table of the pipeline's stages, grouped by what a
# lever would remove: each group's milliseconds (stage_table.py's), its share of the compile between the first lap and
# the last (the header's), the compile without it (COMPILE_MS, the baseline's median wall time, less the group), and
# from samples_reduce.py's per-stage counters its user cycles, IPC and the share of its dispatch slots (8 a cycle) that
# waited for the frontend. Markdown.
import sys, re

GROUPS = [
    ('register allocation: the first call', ['alloc1.']),
    ('register allocation: the second call', ['alloc2.']),
    ('register allocation: the callee-saved step', ['cfg.callee']),
    ('emission: the allocation problem', ['cfg.problem']),
    ('emission: saves and frame', ['cfg.saves', 'cfg.frame']),
    ('emission: records', ['cfg.records']),
    ('SSA construction', ['ssa.cfg', 'ssa.classify', 'ssa.prepare', 'ssa.definitions', 'ssa.construct', 'ssa.simplify', 'ssa.layout', 'ssa.fill']),
    ('instruction selection', ['select.']),
    ('IR verification, six checks', ['lower.verify', 'ssa.dominance', 'ssa.verify', 'opt.verify-input', 'opt.dominance', 'final.']),
    ('optimizer: analyses, SCCP, dead code, rewrite', ['opt.cfg-uses', 'opt.dominators', 'opt.sccp', 'opt.dce', 'opt.rewrite']),
    ('lowering to the IR', ['lower.validate', 'lower.plan', 'lower.count', 'lower.emit']),
    ('inlining, wide integers, vector pieces, truth, if-conversion', ['inline', 'wide', 'vector-split', 'truth', 'if-convert']),
    ("straight-line functions' back end", ['chain.']),
    ('arenas, publication, the rest', ['other', 'arenas', 'publish', 'rest', 'certify', 'gvn']),
]

def load(path):
    rows, header, comments = {}, None, []
    for line in open(path):
        if line.startswith('#'):
            comments.append(line)
            continue
        p = line.rstrip('\n').split('\t')
        if header is None:
            header = p[1:]
            continue
        try:
            rows[p[0]] = dict(zip(header, (float(x.rstrip('%')) if x else 0.0 for x in p[1:])))
        except ValueError:
            pass
    return rows, comments

def main():
    stages, comments = load(sys.argv[1])
    work, _ = load(sys.argv[2])
    td, _ = load(sys.argv[3])
    baseline = float(sys.argv[4])
    between = float(re.search(r'of ([0-9.]+) ms between', comments[0]).group(1))
    def members(prefixes):
        return [n for n in stages if not n.startswith('driver.') and n != 'the pipeline' and any(n == p or (p.endswith('.') and n.startswith(p)) for p in prefixes)]
    print('| stages | ms | of the compile | the compile without it, ms | M cycles | IPC | slots waiting for the frontend |')
    print('| --- | ---: | ---: | ---: | ---: | ---: | ---: |')
    seen = set()
    totals = [0.0, 0.0, 0.0, 0.0, 0.0]
    def line(name, names):
        ms = sum(stages[n]['ms'] for n in names)
        cycles = sum(work[n]['cycles:u'] for n in names if n in work)
        instructions = sum(work[n]['instructions:u'] for n in names if n in work)
        slots = 8 * sum(td[n]['ls_not_halted_cyc:u'] for n in names if n in td)
        frontend = sum(td[n]['de_no_dispatch_per_slot.no_ops_from_frontend:u'] for n in names if n in td)
        print(f'| {name} | {ms:.1f} | {100 * ms / between:.1f}% | {baseline - ms:.0f} | {cycles / 1e6:.1f} | {instructions / cycles:.2f} | {100 * frontend / slots:.0f}% |')
        return ms, cycles, instructions, slots, frontend
    every = []
    for name, prefixes in GROUPS:
        names = members(prefixes)
        seen.update(names)
        every += names
        line(name, names)
    left = [n for n in stages if not n.startswith('driver.') and n != 'the pipeline' and n not in seen and n in work]
    if left:
        line('not grouped: ' + ', '.join(left), left)
        every += left
    line('the pipeline', every)

main()
