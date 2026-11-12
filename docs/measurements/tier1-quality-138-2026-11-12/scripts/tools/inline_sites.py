#!/usr/bin/env python3
# inline_sites.py DISASSEMBLY NM ARCS [--units MAP]: what a size threshold that depends on the call site's loop depth
# buys over one threshold for every site, from Tier 1's code and the measured call arcs. A site's depth is the number of
# backward jumps of its function that span it (the layout's loops); a callee's size its instructions in Tier 1's code
# but its padding. A site is admitted when its callee is defined in the caller's unit, is in no cycle of the static
# call graph and is at most T instructions, T by the site's depth (in a loop or not). Printed per policy: the share of
# the program's dynamic calls into its own code that the admitted sites make, and the static growth, the admitted
# sites' callee sizes less 5 instructions a site (a call's own sequence), as a share of the program's instructions.
import sys, re, bisect, collections
args = sys.argv[1:]
units_path = None
if '--units' in args:
    i = args.index('--units'); units_path = args[i + 1]; del args[i:i + 2]
dis, nm, arcs_path = args[:3]
functions = {}; order = []; current = None
sites = []  # (address, caller, callee)
jumps = collections.defaultdict(list)
for line in open(dis):
    m = re.match(r'^([0-9a-f]+) <(.+)>:$', line)
    if m:
        current = m.group(2); functions[current] = 0; continue
    m = re.match(r'^\s+([0-9a-f]+):\t(\S+)\s*(.*)$', line.rstrip('\n'))
    if not m or current is None: continue
    address = int(m.group(1), 16); mnemonic = m.group(2); operands = m.group(3)
    if mnemonic != 'int3': functions[current] += 1
    t = re.match(r'([0-9a-f]+) <([^>+]+)(\+0x[0-9a-f]+)?>$', operands)
    if mnemonic == 'call' and t and not t.group(3):
        sites.append((address, current, t.group(2)))
    elif mnemonic.startswith('j') and t and t.group(2) == current:
        target = int(t.group(1), 16)
        if target <= address: jumps[current].append((target, address))
unit = {}
if units_path:
    for line in open(units_path):
        p = line.rstrip('\n').split('\t'); unit[p[0]] = p[1]
def unit_of(f): return unit.get(f, '?') if units_path else 'unit'
dynamic = collections.Counter()
for line in open(arcs_path):
    p = line.rstrip('\n').split('\t')
    dynamic[int(p[0], 16)] += int(p[3])
# Cycles of the static call graph (Tarjan, iterative).
graph = collections.defaultdict(set)
for a, caller, callee in sites:
    if callee in functions: graph[caller].add(callee)
index = {}; low = {}; on = set(); stack = []; cyclic = set(); counter = 0
for root in functions:
    if root in index: continue
    work = [(root, iter(graph[root]))]
    index[root] = low[root] = counter; counter += 1; stack.append(root); on.add(root)
    while work:
        node, it = work[-1]
        advanced = False
        for nxt in it:
            if nxt not in index:
                index[nxt] = low[nxt] = counter; counter += 1; stack.append(nxt); on.add(nxt)
                work.append((nxt, iter(graph[nxt]))); advanced = True; break
            elif nxt in on: low[node] = min(low[node], index[nxt])
        if advanced: continue
        work.pop()
        if work: low[work[-1][0]] = min(low[work[-1][0]], low[node])
        if low[node] == index[node]:
            members = []
            while True:
                w = stack.pop(); on.discard(w); members.append(w)
                if w == node: break
            if len(members) > 1 or node in graph[node]: cyclic.update(members)
total_dynamic = sum(dynamic[a] for a, caller, callee in sites if callee in functions and not callee.endswith('@plt'))
total_static = sum(functions.values())
rows = []
for a, caller, callee in sites:
    if callee not in functions or callee.endswith('@plt') or callee in cyclic or unit_of(caller) != unit_of(callee) or caller == callee: continue
    depth = sum(1 for lo, hi in jumps[caller] if lo <= a <= hi)
    rows.append((functions[callee], depth, dynamic[a]))
print(f'static sites {len(sites)}, eligible {len(rows)}; dynamic calls into own code {total_dynamic / 1e6:.2f} M; instructions {total_static}')
in_loop = sum(d for s, depth, d in rows if depth > 0); n_loop = sum(1 for s, depth, d in rows if depth > 0)
print(f'eligible sites in a loop: {n_loop} of {len(rows)} ({100 * n_loop / len(rows):.1f}%), which make {100 * in_loop / total_dynamic:.1f}% of the dynamic calls')
def policy(cold, hot):
    removed = sum(d for s, depth, d in rows if s <= (hot if depth > 0 else cold))
    growth = sum(max(s - 5, 0) for s, depth, d in rows if s <= (hot if depth > 0 else cold))
    count = sum(1 for s, depth, d in rows if s <= (hot if depth > 0 else cold))
    return removed, growth, count
print('threshold outside loops\tin loops\tsites\tdynamic calls removed\tstatic growth')
for cold, hot in [(8, 8), (16, 16), (32, 32), (64, 64), (128, 128), (256, 256), (8, 32), (8, 64), (8, 128), (8, 256), (16, 64), (16, 128), (16, 256), (32, 128), (32, 256), (64, 256)]:
    removed, growth, count = policy(cold, hot)
    print(f'{cold}\t{hot}\t{count}\t{100 * removed / total_dynamic:.1f}%\t{100 * growth / total_static:+.1f}%')
