#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# sweeps_summary.py DIRECTORY: the table of sweeps.sh's results (sweeps-UNIT-RUN.txt, sweeps-UNIT-by-OTHER.txt): the
# counts, which every run of a unit repeats, and each time's median of the three runs.
import re
import statistics
import sys

directory = sys.argv[1]
UNITS = (('sqlite3', '`sqlite3.c`'), ('musl', "musl's 1,336 units"))


def read(path):
    """A run's lines: {first field: {key: value}} for the count lines, and the time lines' numbers by part."""
    counts = {}
    times = {}
    refused = []
    for line in open(path):
        fields = line.rstrip('\n').split('\t')
        if fields[0] == 'time':
            numbers = [float(x) for x in re.findall(r'(?:ticks|cycles|instructions|branches) ([0-9.]+)', line)]
            times[fields[1].split(',')[0]] = numbers
        elif fields[0] == 'refused':
            refused.append((fields[1], fields[2], fields[3]))
        elif fields[0] in ('unit', 'structure', 'T', 'C', 'X', 'taken', 'checked'):
            row = counts.setdefault(fields[0], {})
            for field in fields[1:]:
                for key, value in re.findall(r'([A-Za-z\'-]+(?: [a-z]+)*?)=([0-9]+)', field):
                    row.setdefault(key.strip(), int(value))
            row['text'] = '\t'.join(fields[1:])
    return counts, times, refused


def number(value):
    return f'{value:,}'


def share(part, whole):
    return f'{number(part)} ({100.0 * part / whole:.1f}%)'


runs = {unit: [read(f'{directory}/sweeps-{unit}-{run}.txt') for run in (1, 2, 3)] for unit, _ in UNITS}
for unit, _ in UNITS:
    for run in runs[unit][1:]:
        assert {k: v['text'] for k, v in run[0].items()} == {k: v['text'] for k, v in runs[unit][0][0].items()}, unit

rows = []


def row(label, cell):
    rows.append((label, [cell(runs[unit][0][0], unit) for unit, _ in UNITS]))


def taken_of(counts, what):
    match = re.search(what + r'=([0-9]+) of ([0-9]+)', counts['taken']['text'])
    return int(match.group(1)), int(match.group(2))


row('function bodies', lambda c, u: number(c['unit']['bodies']))
row('evaluated nodes', lambda c, u: number(c['unit']['nodes']))
row('full expressions', lambda c, u: number(c['unit']['full-expressions']))
row("typed entries; the nodes' own and their conversions", lambda c, u: f"{number(c['unit']['entries'])}; {number(c['unit']['entries-of-the-nodes'])}")
row('**T** leaves', lambda c, u: share(c['T']['leaves'], c['unit']['nodes']))
row('nodes typed by the table', lambda c, u: share(c['T']['nodes-typed-by-the-table'], c['unit']['nodes']))
row('nodes whose facts a lookup gives', lambda c, u: share(c['T']['nodes-whose-facts-a-lookup-gives'], c['unit']['nodes']))
row('type keys; of one node; in conflict', lambda c, u: f"{number(c['T']['keys'])}; {number(c['T']['keys-of-one-node'])}; {c['T']['conflicting-keys']}")
row("**C** operands; given (a call's, a builtin's)", lambda c, u: f"{number(c['C']['operands'])}; {share(c['C']['operands-given'], c['C']['operands'])}")
row('context keys; of one operand; in conflict', lambda c, u: f"{number(c['C']['keys'])}; {number(c['C']['keys-of-one-operand'])}; {c['C']['conflicting-keys']}")
row('**X** template keys; of one node; in conflict', lambda c, u: f"{number(c['X']['keys'])}; {number(c['X']['keys-of-one-node'])}; {c['X']['conflicting-keys']}")
row('templates', lambda c, u: number(c['X']['templates']))
row("rebuilt keys that differ from the lowering's", lambda c, u: number(c['X']["rebuilt-keys-differing-from-the-lowering's"]))
row('nodes that write before or between their operands', lambda c, u: share(c['structure']['nodes-that-write-before-or-between-their-operands'], c['unit']['nodes']))
row('**taken** full expressions', lambda c, u: share(*taken_of(c, 'expressions')))
row('nodes in them', lambda c, u: share(*taken_of(c, 'nodes')))
row("entries, of the nodes'", lambda c, u: share(*taken_of(c, 'entries')))
row("emitted entries that differ from the stream's", lambda c, u: re.search(r'an expression at a time: emitted=[0-9]+ wrong-expressions=[0-9]+ wrong-entries=([0-9]+)', c['checked']['text']).group(1))

print('| | ' + ' | '.join(title for _, title in UNITS) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in UNITS) + ' |')
for label, cells in rows:
    print(f'| {label} | ' + ' | '.join(cells) + ' |')
# Refusals: each unit's own list.
for unit, title in UNITS:
    print()
    print(f'Refused in {title}:')
    print()
    print('| expressions | nodes | why, and the operator of the first such node |')
    print('| ---: | ---: | --- |')
    for expressions, nodes, why in runs[unit][0][2]:
        count, percent = nodes.split('=')[1].split(' ')
        print(f"| {number(int(expressions.split('=')[1]))} | {number(int(count))} {percent} | {why.replace('|', chr(92) + '|')} |")
# Times: the median of the three runs, a node of the unit.
print()
print('| a node of the unit, the median of three runs | ' + ' | '.join(f'{title}: cycles | instructions | mispredicted branches' for _, title in UNITS) + ' |')
print('| --- | ' + ' | '.join('---: | ---: | ---:' for _ in UNITS) + ' |')
PARTS = (('T', 'T'), ('C', 'C'), ('templates', "the templates' choice"), ('expand', 'the expansion'), ('unit-at-a-time', 'the four, a unit at a time'),
         ('expression-at-a-time', 'the four, an expression at a time'))
for part, label in PARTS:
    cells = []
    for unit, _ in UNITS:
        values = [run[1][part] for run in runs[unit]]
        cells.append(' | '.join(f'{statistics.median(v[i] for v in values):.{digits}f}' for i, digits in ((1, 1), (2, 1), (3, 2))))
    print(f'| {label} | ' + ' | '.join(cells) + ' |')
cells = []
for unit, _ in UNITS:
    values = [run[1]['expression-at-a-time'] for run in runs[unit]]
    cells.append(' | '.join(f'{statistics.median(v[i] for v in values):.1f}' for i in (5, 6)) + ' | ')
print('| the four, an expression at a time, a taken node | ' + ' | '.join(cells) + '|')
ranges = []
for unit, _ in UNITS:
    values = [run[1]['expression-at-a-time'][1] for run in runs[unit]]
    ranges.append(f'{min(values):.1f} to {max(values):.1f}')
print()
print('The three runs\' cycles a node, an expression at a time: ' + '; '.join(f'{title} {r}' for (_, title), r in zip(UNITS, ranges)) + '.')
# One corpus's tables on the other.
print()
print("| a unit by the other's tables | `sqlite3.c` by musl's | musl by `sqlite3.c`'s |")
print('| --- | ---: | ---: |')
cross = [read(f'{directory}/sweeps-sqlite3-by-musl.txt')[0], read(f'{directory}/sweeps-musl-by-sqlite3.txt')[0]]


def crossed(label, cell):
    print(f'| {label} | ' + ' | '.join(cell(c) for c in cross) + ' |')


crossed('nodes the table types: answered; of those, wrong', lambda c: f"{number(c['T']['nodes-typed-by-the-table'] - c['T']['misses'])} of {number(c['T']['nodes-typed-by-the-table'])}; {c['T']['facts-differing-from-the-truth']}")
crossed('operands the table is asked: answered; nodes whose context or target is wrong',
        lambda c: f"{number(c['C']['operands'] - c['C']['operands-given'] - c['C']['operands-missed'])} of {number(c['C']['operands'] - c['C']['operands-given'])}; {c['C']['nodes-whose-context-or-target-differs']}")
crossed('nodes in taken expressions', lambda c: share(*taken_of(c, 'nodes')))
crossed("emitted entries; of those, differing from the stream's",
        lambda c: '; '.join(number(int(x)) for x in re.search(r'an expression at a time: emitted=([0-9]+) wrong-expressions=[0-9]+ wrong-entries=([0-9]+)', c['checked']['text']).groups()))
