#!/usr/bin/env python3
# single_sites.py DISASSEMBLY NM ARCS RELOCATIONS: the internal functions with one direct call site in the program and
# no address taken: how many, their share of the program's instructions and of its dynamic calls into its own code.
#   DISASSEMBLY  objdump -d --no-show-raw-insn of Tier 1's executable (call sites, lea of a function's address, sizes)
#   NM           nm of it (t: internal linkage)
#   ARCS         arcs.py's rows of its runs
#   RELOCATIONS  readelf -rW of the same unit compiled by clang -O0 -ffunction-sections -c: a relocation in a section
#                that is not code names the function whose address a table holds (.text.NAME)
# speedtest1's unit: clang -O0 -w -ffunction-sections -c with the harness's -D options, of the unity file
# (#include "sqlite3.c", #define randomFunc speedtest1_randomFunc, #include "speedtest1.c").
import sys, re, collections
dis, nm, arcs, relocations = sys.argv[1:5]
taken = set(); section = None
for line in open(relocations):
    m = re.match(r"Relocation section '\.rela(\S+)'", line)
    if m: section = m.group(1); continue
    if section is None or section.startswith('.text') or section.startswith('.debug') or section.startswith('.eh_frame'): continue
    p = line.split()
    if len(p) >= 5 and p[2].startswith('R_X86_64'):
        taken.add(p[4][6:] if p[4].startswith('.text.') else p[4])
size = {}; current = None; sites = collections.Counter(); lea = set(); callers = collections.defaultdict(set)
for line in open(dis):
    m = re.match(r'^([0-9a-f]+) <(.+)>:$', line)
    if m: current = m.group(2); size[current] = 0; continue
    m = re.match(r'^\s+([0-9a-f]+):\t(\S+)\s*(.*)$', line.rstrip('\n'))
    if not m or current is None: continue
    if m.group(2) != 'int3': size[current] += 1
    t = re.search(r'<([^>+]+)>$', m.group(3))
    if t and m.group(2) == 'call': sites[t.group(1)] += 1; callers[t.group(1)].add(current)
    elif t and m.group(2) == 'lea': lea.add(t.group(1))
local = {p[2] for p in (l.split() for l in open(nm)) if len(p) == 3 and p[1] == 't'}
dynamic = collections.Counter()
for line in open(arcs):
    p = line.rstrip('\n').split('\t'); dynamic[p[2]] += int(p[3])
total = sum(v for k, v in dynamic.items() if '@plt' not in k)
single = [f for f in local if sites[f] == 1 and f not in lea and f not in taken and f not in callers[f]]
instructions = sum(size.values())
print(f'internal functions {len(local)}; with one direct call site and no address taken {len(single)}')
print(f'their instructions {sum(size[f] for f in single)} of {instructions} ({100 * sum(size[f] for f in single) / instructions:.1f}%)')
print(f'their dynamic calls {sum(dynamic[f] for f in single) / 1e6:.2f} M of {total / 1e6:.2f} M ({100 * sum(dynamic[f] for f in single) / total:.1f}%)')
for limit in (64, 128, 256, 512):
    chosen = [f for f in single if size[f] <= limit]
    print(f'  of at most {limit} instructions: {len(chosen)} functions, {sum(size[f] for f in chosen)} instructions, {sum(dynamic[f] for f in chosen) / 1e6:.2f} M calls')
