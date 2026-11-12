#!/usr/bin/env python3
# [ARCS_BASE=0x108000] arcs.py DISASSEMBLY OBJECT CALLGRIND... > TSV: the dynamic call arcs inside OBJECT (the name callgrind gives the
# executable: its path when it ran through an explicit loader), summed over the CALLGRIND files:
# "call-site address<TAB>caller<TAB>callee<TAB>calls", from callgrind's calls= lines (the call's position is the
# next cost line's, its target the calls= line's), with functions from `objdump -d --no-show-raw-insn`.
import sys, re, bisect, collections
import os
dis, obj = sys.argv[1], sys.argv[2]
# ARCS_BASE: what callgrind adds to the executable's addresses (0x108000 for Buster's run directly, as #1189's record says).
base = int(os.environ.get('ARCS_BASE', '0'), 0)
starts = []; names = []
for line in open(dis):
    m = re.match(r'^([0-9a-f]+) <(.+)>:$', line)
    if m:
        starts.append(int(m.group(1), 16)); names.append(m.group(2))
def function(a):
    i = bisect.bisect_right(starts, a) - 1
    return names[i] if i >= 0 else '?'
def pos(tok, prev):
    if tok.startswith('+'): return prev + int(tok[1:], 0)
    if tok.startswith('-'): return prev - int(tok[1:], 0)
    if tok == '*': return prev
    return int(tok, 0)
arcs = collections.Counter()
for path in sys.argv[3:]:
    objects = {}; ours = False; callee_ours = False; prev = 0; pending = None
    for line in open(path):
        line = line.rstrip('\n')
        if line.startswith('ob='):
            m = re.match(r'ob=\((\d+)\)(?: (.*))?', line)
            if m.group(2): objects[m.group(1)] = m.group(2)
            ours = objects.get(m.group(1)) == obj; callee_ours = ours
        elif line.startswith('cob='):
            m = re.match(r'cob=\((\d+)\)(?: (.*))?', line)
            if m.group(2): objects[m.group(1)] = m.group(2)
            callee_ours = objects.get(m.group(1)) == obj
        elif line.startswith('fn='):
            callee_ours = ours
        elif line.startswith('calls='):
            parts = line[6:].split()
            pending = (int(parts[0]), pos(parts[1], prev), callee_ours)
            callee_ours = ours
        elif line and (line[0] in '+-*' or line[0].isdigit()):
            parts = line.split()
            prev = pos(parts[0], prev)
            if pending is not None:
                count, target, callee = pending
                if ours and callee:
                    arcs[(prev, target)] += count
                pending = None
        elif line.startswith('jump=') or line.startswith('jcnd='):
            pending = None
for (site, target), count in sorted(arcs.items(), key=lambda x: -x[1]):
    print(f'{site - base:x}\t{function(site - base)}\t{function(target - base)}\t{count}')
