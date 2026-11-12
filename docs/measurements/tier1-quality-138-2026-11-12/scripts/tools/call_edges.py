#!/usr/bin/env python3
# call_edges.py DISASSEMBLY [--units MAP] > EDGES: a program's static call graph for unit_stage_bench.c, from `objdump
# -d --no-show-raw-insn`: "functions N", then one "caller callee" line of function indices for each distinct direct
# call between two of its functions (PLT stubs left out; with --units, "function<TAB>unit" rows, calls between units
# too, as no unit's graph has them).
import sys, re
args = sys.argv[1:]
unit = {}
if '--units' in args:
    i = args.index('--units')
    for line in open(args[i + 1]):
        p = line.rstrip('\n').split('\t'); unit[p[0]] = p[1]
    del args[i:i + 2]
index = {}; edges = set(); current = None
lines = open(args[0]).read().split('\n')
for line in lines:
    m = re.match(r'^[0-9a-f]+ <(.+)>:$', line)
    if m and not m.group(1).endswith('@plt'): index.setdefault(m.group(1), len(index))
for line in lines:
    m = re.match(r'^[0-9a-f]+ <(.+)>:$', line)
    if m: current = m.group(1); continue
    m = re.search(r'\tcall\s+[0-9a-f]+ <([^>+]+)>$', line)
    if m and current in index and m.group(1) in index and (not unit or unit.get(current) == unit.get(m.group(1))):
        edges.add((index[current], index[m.group(1)]))
print(f'functions {len(index)}')
for a, b in sorted(edges): print(a, b)
