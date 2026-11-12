#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# rank.py RAW_DIR: the levers outside buster#2524's scope, ranked by a measured bound: what each workload's compile
# would cost, in cycles of both modes, if the lever's work were free. From the probe's stage counters (probe.sh:
# RAW_DIR/probe), the asm index's two builds (asm.sh: RAW_DIR/asm) and an empty unit's process (fixed.sh:
# RAW_DIR/fixed). A lever's work on musl's command (1,336 units, one lane) and on the frozen sqlite3.c:
#   file scope   the checker's stages (type-table to select) on the units without bodies, less an empty unit's: what
#                reading the file scope's declarations costs
#   kernel       every kernel cycle of the compile
#   preprocess   the `preprocess` stage, both modes
#   fixed        the empty units' whole compile (musl: 1,336 of them as one command; sqlite3.c: an empty unit's process)
#   asm index    the asm matcher's index, made once a unit with asm statements: the two builds' difference
#   parse        the `parse` stage, both modes
#   emission     the stages from backend-setup and tier0 to object-write but the lowering
#   bodies       for reference, buster#2524's: the stages from check-input to lower on the units less the same on the
#                units without bodies, and less the asm index (which the lowering's preparation makes)
# The levers overlap (the kernel's cycles are in every other row, the fixed work's in the kernel's and the
# preprocessor's), so the bounds don't add up.
import os, re, statistics, sys, collections


def read_lines(path):
    # A report's lines, whether the record keeps it as it was written or gzipped (its units' diagnostics make it large).
    if path.endswith('.gz'):
        import gzip
        return gzip.open(path, 'rt', errors='replace')
    return open(path, errors='replace')

raw = sys.argv[1]


def probe(prefix, variant):
    # A variant's stage medians: {stage: (user cycles, kernel cycles, ms)}.
    runs = collections.defaultdict(lambda: collections.defaultdict(list))
    directory = os.path.join(raw, 'probe')
    for name in sorted(os.listdir(directory)):
        m = re.fullmatch(re.escape(prefix) + '-' + re.escape(variant) + r'(?:-p1)?-(\d+)\.txt(?:\.gz)?', name)
        if not m:
            continue
        header = None
        for line in read_lines(os.path.join(directory, name)):
            p = line.rstrip('\n').split('\t')
            if p[0] != 'probe-stage':
                continue
            if p[1] == 'stage':
                header = p[2:]
                continue
            row = dict(zip(header, p[2:]))
            runs[p[1]]['u'].append(float(row['cycles-u']))
            runs[p[1]]['k'].append(float(row['cycles-k']))
            runs[p[1]]['ms'].append(float(row['ms']))
    return {s: (statistics.median(v['u']), statistics.median(v['k']), statistics.median(v['ms'])) for s, v in runs.items()}


def stat(directory, name):
    values = collections.defaultdict(list)
    for file in sorted(os.listdir(os.path.join(raw, directory))):
        if re.fullmatch('stat-' + re.escape(name) + r'-\d+\.csv', file):
            for line in open(os.path.join(raw, directory, file)):
                p = line.strip().split(',')
                if len(p) > 2 and p[0] and not line.startswith('#'):
                    try:
                        values[p[2]].append(float(p[0]))
                    except ValueError:
                        pass
    return {k: statistics.median(v) for k, v in values.items()}


CHECKER = ['type-table', 'check-input', 'check-expressions', 'check-declarations', 'static-data', 'check-program', 'select']
MIDDLE = ['check-input', 'check-expressions', 'check-declarations', 'static-data', 'check-program', 'select', 'lower']
EMISSION = ['backend-setup', 'tier0', 'emit-setup', 'branch-sizing', 'encode', 'unwind', 'code-atoms', 'debug', 'publish-data', 'object-build', 'object-write']


def both(table, stages):
    return sum(table[s][0] + table[s][1] for s in stages if s in table)


musl = probe('musl', 'c')
musl_spine = probe('musl', 'spine-c')
musl_empty = probe('musl', 'empty-c')
sqlite = probe('sqlite', 'source')
sqlite_spine = probe('sqlite', 'spine')
total = {'musl': both(musl, musl), 'sqlite': both(sqlite, sqlite)}
asm_each = stat('asm', 'each-unit')
asm_once = stat('asm', 'once')
asm = (asm_each['cycles:u'] + asm_each['cycles:k']) - (asm_once['cycles:u'] + asm_once['cycles:k'])
empty_process = stat('fixed', 'process-empty')
levers = [
    ('file scope: reading its declarations', both(musl_spine, CHECKER) - both(musl_empty, CHECKER), both(sqlite_spine, CHECKER)),
    ('kernel: pages and system calls', sum(v[1] for v in musl.values()), sum(v[1] for v in sqlite.values())),
    ('preprocess (and the lexer)', both(musl, ['preprocess']), both(sqlite, ['preprocess'])),
    ("fixed: a unit's own start and end", both(musl_empty, musl_empty), empty_process['cycles:u'] + empty_process['cycles:k']),
    ("asm index: the matcher's, a unit with asm", asm, 0.0),
    ("parse: the parser and the tree's columns", both(musl, ['parse']), both(sqlite, ['parse'])),
    ('emission: Tier 0 to the object', both(musl, EMISSION), both(sqlite, EMISSION)),
    ("bodies between the parser and Tier 0 (buster#2524's, for reference)", both(musl, MIDDLE) - both(musl_spine, MIDDLE) - asm, both(sqlite, MIDDLE) - both(sqlite_spine, MIDDLE)),
]
print(f"compile, cycles of both modes (the probe's stages' sum): musl {total['musl'] / 1e6:.1f} M, sqlite3.c {total['sqlite'] / 1e6:.1f} M")
print('lever\tmusl: its cycles, M\tshare\tthe compile without it\tsqlite3.c: its cycles, M\tshare\tthe compile without it')
for name, m, s in sorted(levers[:-1], key=lambda x: -x[1]) + levers[-1:]:
    print(f"{name}\t{m / 1e6:.1f}\t{100 * m / total['musl']:.1f}%\t{total['musl'] / (total['musl'] - m):.3f} times faster\t"
          f"{s / 1e6:.1f}\t{100 * s / total['sqlite']:.1f}%\t{total['sqlite'] / (total['sqlite'] - s):.3f} times faster")
print()
print('stage\tmusl user M\tmusl kernel M\tmusl ms\tmusl without bodies user M\tkernel M\tmusl empty units user M\tkernel M\tsqlite3.c user M\tkernel M\tms\tsqlite3.c without bodies user M\tkernel M')
for s in musl:
    def cell(table, index):
        return f'{table[s][index] / 1e6:.2f}' if s in table and index < 2 else f'{table[s][index]:.3f}' if s in table else ''
    row = [s, cell(musl, 0), cell(musl, 1), cell(musl, 2), cell(musl_spine, 0), cell(musl_spine, 1), cell(musl_empty, 0), cell(musl_empty, 1),
           cell(sqlite, 0), cell(sqlite, 1), cell(sqlite, 2), cell(sqlite_spine, 0), cell(sqlite_spine, 1)]
    if any(float(x or 0) >= 0.005 for x in row[1:]):
        print('\t'.join(row))
