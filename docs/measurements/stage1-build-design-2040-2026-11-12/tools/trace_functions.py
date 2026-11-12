#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# trace_functions.py TRACE.json[.gz] FUNCTIONS.tsv OUTPUT_PREFIX: clang's -ftime-trace of one unit's compile, by function.
# Every event's own time (its duration less its children's) goes to the function its detail names (a function pass's
# function, an SCC pass's "(function)", the front end's ParseFunctionDefinition and CodeGen Function), or else to the
# nearest enclosing event that names one, or else to no function (the module passes' own time, the parser outside
# function bodies). FUNCTIONS.tsv is function_files' map of the unit's unoptimized bitcode: the functions clang
# emitted and the files their definitions are in. A function is the test code's when its file's name matches the
# record's rule (unit_lines.py's: _test, test_, _tests, fuzz), a benchmark's when its file's name says benchmark.
# Writes OUTPUT_PREFIX.functions.tsv (every function), OUTPUT_PREFIX.files.tsv (every file, by its functions),
# OUTPUT_PREFIX.sources.tsv (the front end's own time in each file it read) and prints the summary.
import collections
import gzip
import json
import os
import re
import sys

trace_path, functions_path, prefix = sys.argv[1:4]
opener = gzip.open if trace_path.endswith('.gz') else open
with opener(trace_path, 'rt') as handle:
    everything = json.load(handle)['traceEvents']
events = [e for e in everything if e.get('ph') == 'X' and not e['name'].startswith('Total ')]
# The front end's files: clang's Source events, a begin and an end for each file it enters, nested as the includes are.
# A file's own time is its span less the files it includes.
source_time = collections.Counter()
source_stack = []
for event in sorted((e for e in everything if e.get('name') == 'Source' and e.get('ph') in ('b', 'e')), key=lambda e: (e['ts'], e['ph'] == 'b')):
    if event['ph'] == 'b':
        source_stack.append([event.get('args', {}).get('detail', ''), event['ts'], 0])
    elif source_stack:
        path, start, nested = source_stack.pop()
        span = event['ts'] - start
        source_time[path] += span - nested
        if source_stack:
            source_stack[-1][2] += span
del everything

files = {}
instructions = {}
for line in open(functions_path):
    name, path, _line, _linkage, count = line.rstrip('\n').split('\t')[:5]
    files[name] = os.path.basename(path)
    instructions[name] = int(count)


def kind_of(base):
    if re.search(r'_test(_|\.)|_tests?\.|test_|fuzz', base):
        return 'test'
    if 'benchmark' in base:
        return 'benchmark'
    return 'product'


def owner_of(event):
    detail = event.get('args', {}).get('detail')
    if not isinstance(detail, str):
        return None
    if detail.startswith('(') and detail.endswith(')'):
        # An SCC: the build forbids recursion, so it is one function; a larger one goes to its first.
        detail = detail[1:-1].split(', ')[0]
    return detail if detail in files else None


# The phases, by the enclosing events' names.
PHASES = (('Optimizer', 'optimizer'), ('Frontend', 'frontend'), ('CodeGenPasses', 'codegen'), ('Backend', 'backend'))
INLINER = 'ModuleInlinerWrapperPass'

events.sort(key=lambda e: (e['ts'], -e['dur']))
time = collections.defaultdict(lambda: collections.Counter())
passes = collections.Counter()
stack = []
total_by_phase = collections.Counter()
for event in events:
    start, end = event['ts'], event['ts'] + event['dur']
    while stack and stack[-1]['end'] <= start:
        stack.pop()
    parent = stack[-1] if stack else None
    name = event['name']
    owner = owner_of(event) or (parent['owner'] if parent else None)
    phase = parent['phase'] if parent else 'other'
    for key, label in PHASES:
        if name == key:
            phase = label
    inliner = (parent['inliner'] if parent else False) or name == INLINER
    node = {'end': end, 'owner': owner, 'phase': phase, 'inliner': inliner, 'self': event['dur'], 'name': name}
    if parent:
        parent['self'] -= event['dur']
    stack.append(node)
    event['_node'] = node
for event in events:
    node = event['_node']
    column = node['phase'] + ('.inliner' if node['inliner'] and node['phase'] == 'optimizer' else '')
    time[node['owner']][column] += node['self']
    total_by_phase[column] += node['self']
    if node['phase'] == 'optimizer':
        passes[node['name']] += node['self']

columns = ['frontend', 'optimizer.inliner', 'optimizer', 'backend', 'codegen', 'other']
with open(prefix + '.functions.tsv', 'w') as out:
    out.write('function\tfile\tkind\tunoptimized instructions\t' + '\t'.join(c + ' us' for c in columns) + '\n')
    for name in sorted((n for n in time if n is not None), key=lambda n: -sum(time[n].values())):
        out.write(f"{name}\t{files[name]}\t{kind_of(files[name])}\t{instructions[name]}\t" + '\t'.join(str(time[name][c]) for c in columns) + '\n')

by_file = collections.defaultdict(collections.Counter)
by_kind = collections.defaultdict(collections.Counter)
count_kind = collections.Counter()
instructions_kind = collections.Counter()
for name, row in time.items():
    if name is None:
        continue
    for column, value in row.items():
        by_file[files[name]][column] += value
        by_kind[kind_of(files[name])][column] += value
for name, base in files.items():
    count_kind[kind_of(base)] += 1
    instructions_kind[kind_of(base)] += instructions[name]
with open(prefix + '.files.tsv', 'w') as out:
    out.write('file\tkind\t' + '\t'.join(c + ' us' for c in columns) + '\n')
    for base in sorted(by_file, key=lambda b: -sum(by_file[b].values())):
        out.write(f"{base}\t{kind_of(base)}\t" + '\t'.join(str(by_file[base][c]) for c in columns) + '\n')


def seconds(value):
    return f'{value / 1e6:8.2f} s'


optimizer = total_by_phase['optimizer'] + total_by_phase['optimizer.inliner']
print(f"events {len(events)}; functions in the map {len(files)}, with time {sum(1 for n in time if n is not None)}")
print('phase totals: ' + ', '.join(f'{c} {total_by_phase[c] / 1e6:.2f} s' for c in columns if total_by_phase[c]))
print(f'\nthe optimizer, {optimizer / 1e6:.2f} s, by whose function:')
for kind in ('product', 'test', 'benchmark'):
    row = by_kind[kind]
    own = row['optimizer'] + row['optimizer.inliner']
    print(f"  {kind:10s} {seconds(own)}  {100 * own / optimizer:5.1f}%   (in the inliner's pipeline {seconds(row['optimizer.inliner'])}, outside it {seconds(row['optimizer'])});"
          f" {count_kind[kind]} functions, {instructions_kind[kind]} unoptimized instructions")
none = time[None]['optimizer'] + time[None]['optimizer.inliner']
print(f"  {'no function':10s} {seconds(none)}  {100 * none / optimizer:5.1f}%   (module passes' own time, and events under the granularity outside any function's)")
codegen = total_by_phase['codegen'] + total_by_phase['backend']
if total_by_phase['codegen']:
    print(f'\nthe code generator (and what else follows the optimizer), {codegen / 1e6:.2f} s, by whose function:')
    for kind in ('product', 'test', 'benchmark'):
        own = by_kind[kind]['codegen'] + by_kind[kind]['backend']
        print(f"  {kind:10s} {seconds(own)}  {100 * own / codegen:5.1f}%")
    none = time[None]['codegen'] + time[None]['backend']
    print(f"  {'no function':10s} {seconds(none)}  {100 * none / codegen:5.1f}%")
frontend = total_by_phase['frontend']
print(f'\nthe front end, {frontend / 1e6:.2f} s, by whose function (parsing and IR generation of function bodies; the rest is declarations, macros and files):')
for kind in ('product', 'test', 'benchmark'):
    print(f"  {kind:10s} {seconds(by_kind[kind]['frontend'])}  {100 * by_kind[kind]['frontend'] / frontend:5.1f}%")
print(f"  {'no function':10s} {seconds(time[None]['frontend'])}  {100 * time[None]['frontend'] / frontend:5.1f}%")
sources = collections.Counter()
for path, value in source_time.items():
    inside = '/src/buster/' in path or path.startswith('src/buster/')
    sources[kind_of(os.path.basename(path)) if inside else 'system headers'] += value
print(f"\nthe front end by the file it was reading (clang's Source events, each file's own time; the unit's first file isn't one), {sum(sources.values()) / 1e6:.2f} s:")
for kind in ('product', 'test', 'benchmark', 'system headers'):
    print(f"  {kind:14s} {seconds(sources[kind])}  {100 * sources[kind] / max(sum(sources.values()), 1):5.1f}%")
with open(prefix + '.sources.tsv', 'w') as out:
    out.write('file\tkind\tfront end us\n')
    for path, value in source_time.most_common():
        out.write(f"{path}\t{kind_of(os.path.basename(path))}\t{value}\n")
print('\nthe optimizer by file, the 25 largest:')
for base in sorted(by_file, key=lambda b: -(by_file[b]['optimizer'] + by_file[b]['optimizer.inliner']))[:25]:
    own = by_file[base]['optimizer'] + by_file[base]['optimizer.inliner']
    print(f"  {seconds(own)}  {100 * own / optimizer:5.1f}%  {kind_of(base):9s} {base}")
print('\nthe optimizer by function, the 25 largest:')
for name in sorted((n for n in time if n is not None), key=lambda n: -(time[n]['optimizer'] + time[n]['optimizer.inliner']))[:25]:
    own = time[name]['optimizer'] + time[name]['optimizer.inliner']
    print(f"  {seconds(own)}  {100 * own / optimizer:5.1f}%  {kind_of(files[name]):9s} {name} ({files[name]}, {instructions[name]} instructions)")
ordered = sorted((time[n]['optimizer'] + time[n]['optimizer.inliner'] for n in time if n is not None), reverse=True)
running = 0
marks = {}
for index, value in enumerate(ordered, 1):
    running += value
    for share in (0.25, 0.5, 0.75, 0.9):
        if share not in marks and running >= share * sum(ordered):
            marks[share] = index
print('\nfunctions that hold a share of the functions\' optimizer time: ' + ', '.join(f'{int(100 * s)}% in {n}' for s, n in sorted(marks.items())))
print('\nthe optimizer by pass (own time), the 20 largest:')
for name, value in passes.most_common(20):
    print(f"  {seconds(value)}  {100 * value / optimizer:5.1f}%  {name}")
