#!/usr/bin/env python3
# inline_classes.py DISASSEMBLY ARCS [--units MAP] INS...: Tier 1's dynamic calls into the program's own code by the
# callee's shape in Tier 1's code and its size, for the inliner's steps: a straight-line leaf (the existing inliner's
# scope), a leaf with control flow, and a callee with calls of its own, each with or without a frame object whose
# address it takes; then what each step reaches at a size limit, with the code it adds if every static site of an
# inlined callee is expanded, and if only the sites these runs executed are.
import sys, re, collections
args = sys.argv[1:]
units_path = None
if '--units' in args:
    i = args.index('--units'); units_path = args[i + 1]; del args[i:i + 2]
dis, arcs_path = args[:2]
ins_paths = args[2:]
order = []; fstart = {}; fend = {}
function = None
for line in open(dis):
    m = re.match(r'^([0-9a-f]+) <(.+)>:$', line)
    if m:
        function = m.group(2); fstart[function] = len(order); continue
    m = re.match(r'^\s+([0-9a-f]+):\t(.*)$', line.rstrip('\n'))
    if m and function is not None:
        order.append((int(m.group(1), 16), m.group(2).strip(), function)); fend[function] = len(order)
counts = collections.Counter()
for path in ins_paths:
    for line in open(path):
        f = line.rstrip('\n').split('\t'); counts[int(f[2], 16)] += int(f[5])
unit = {}
if units_path:
    for line in open(units_path):
        p = line.rstrip('\n').split('\t'); unit[p[0]] = p[1]
def unit_of(f): return unit.get(f, '?') if units_path else 'unit'
size = {}; leaf = {}; straight = {}; objects = {}
for f in fstart:
    n = 0; calls = 0; branches = 0; frame = 0
    for i in range(fstart[f], fend[f]):
        a, t, _ = order[i]
        m = t.split(None, 1)[0]
        if m.startswith('nop') or t.startswith('xchg   %ax,%ax') or m in ('int3', 'cs', 'data16'):
            continue
        n += 1
        calls += m.startswith('call')
        # A jump to the next instruction is no control flow; a ret isn't either.
        nxt = order[i + 1][0] if i + 1 < fend[f] else None
        tm = re.match(r'^j\w+\s+([0-9a-f]+)', t)
        if m.startswith('j') and not (m == 'jmp' and tm and nxt is not None and int(tm.group(1), 16) == nxt):
            branches += 1
        frame += bool(re.match(r'^lea\s+(-?0x[0-9a-f]+)?\(%rsp', t))
    size[f] = n; leaf[f] = calls == 0; straight[f] = branches == 0; objects[f] = frame != 0
arcs = []
for line in open(arcs_path):
    s, caller, callee, c = line.rstrip('\n').split('\t'); arcs.append((int(s, 16), caller, callee, int(c)))
graph = collections.defaultdict(set)
for s, caller, callee, c in arcs: graph[caller].add(callee)
# cycles of the measured graph
idx = {}; low = {}; onstack = set(); stack = []; cyc = set(); counter = [0]
for root in list(graph):
    if root in idx: continue
    work = [(root, iter(graph[root]))]; idx[root] = low[root] = counter[0]; counter[0] += 1; stack.append(root); onstack.add(root)
    while work:
        node, it = work[-1]; advanced = False
        for w in it:
            if w not in idx:
                idx[w] = low[w] = counter[0]; counter[0] += 1; stack.append(w); onstack.add(w); work.append((w, iter(graph[w]))); advanced = True; break
            elif w in onstack: low[node] = min(low[node], idx[w])
        if advanced: continue
        work.pop()
        if work: low[work[-1][0]] = min(low[work[-1][0]], low[node])
        if low[node] == idx[node]:
            comp = []
            while True:
                w = stack.pop(); onstack.discard(w); comp.append(w)
                if w == node: break
            if len(comp) > 1 or node in graph[node]: cyc.update(comp)
total = sum(c for _, _, _, c in arcs)
static_sites = collections.Counter()
for a, t, f in order:
    m = re.match(r'^call\s+[0-9a-f]+ <([^>+]+)>', t)
    if m: static_sites[m.group(1)] += 1
def cls(f):
    if f not in fstart: return 'not in the program'
    if f in cyc: return 'in a cycle of calls'
    shape = ('straight-line' if straight[f] else 'control flow') + (' leaf' if leaf[f] else ', calls')
    return shape + (', frame object' if objects[f] else '')
by = collections.Counter(); bysize = collections.defaultdict(collections.Counter)
other_unit = 0
for s, caller, callee, c in arcs:
    if unit_of(caller) != unit_of(callee):
        other_unit += c; continue
    k = cls(callee); by[k] += c
    for S in (16, 32, 64, 128):
        if size.get(callee, 1 << 30) <= S: bysize[k][S] += c
print(f"calls into the program's own code: {total / 1e6:.2f} M; to a callee of another unit: {other_unit / 1e6:.2f} M ({100.0 * other_unit / total:.1f}%)")
print("callee's shape\tcalls, M\tshare\tat most 16 instructions\tat most 32\tat most 64\tat most 128")
for k, c in sorted(by.items(), key=lambda x: -x[1]):
    print(f"{k}\t{c / 1e6:.2f}\t{100.0 * c / total:.1f}%\t" + '\t'.join(f"{100.0 * bysize[k][S] / total:.1f}%" for S in (16, 32, 64, 128)))
# Steps: 0 the existing scope (straight-line leaves, no frame object needed: it takes them), 1 leaves with control flow, 2 callees with calls.
steps = [('existing scope: straight-line leaves', lambda f: straight[f] and leaf[f]),
         ('+ leaves with control flow', lambda f: leaf[f]),
         ('+ callees with calls of their own', lambda f: True)]
print()
print("step\tsize limit\tcalls removed, M\tshare of calls\tcallees\tcode added, all static sites\tcode added, executed sites only\tprogram's code")
program = sum(size.values())
executed_sites = collections.Counter()
for s, caller, callee, c in arcs: executed_sites[callee] += 1
for name, ok in steps:
    for S in (16, 32, 64, 128):
        removed = 0; chosen = set()
        for s, caller, callee, c in arcs:
            if callee in fstart and unit_of(caller) == unit_of(callee) and callee not in cyc and size[callee] <= S and ok(callee):
                removed += c; chosen.add(callee)
        g_all = sum(size[f] * static_sites[f] for f in chosen); g_exec = sum(size[f] * executed_sites[f] for f in chosen)
        print(f"{name}\t{S}\t{removed / 1e6:.2f}\t{100.0 * removed / total:.1f}%\t{len(chosen)}\t{g_all} ({100.0 * g_all / program:.1f}%)\t{g_exec} ({100.0 * g_exec / program:.1f}%)\t{program}")
