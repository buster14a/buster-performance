#!/usr/bin/env python3
# inline_model.py DISASSEMBLY NM ARCS CLANG_ARCS [--units MAP] INS...: what inlining would remove from Tier 1's dynamic
# instructions, by a size threshold, from the measured call arcs and the tagged instructions.
#   DISASSEMBLY  objdump -d --no-show-raw-insn of Tier 1's executable (static order and sizes)
#   NM           nm of it (t: internal linkage)
#   ARCS         arcs.py's rows of Tier 1's runs; CLANG_ARCS clang -O2's (for the calls it still makes)
#   --units MAP  "function<TAB>unit" rows; without it the program is one unit
#   INS          gap's per-instruction rows (#ins function address tag type count text)
# A call is removed when its callee is defined in the caller's unit, is in no cycle of the measured call graph, and has
# at most S instructions in Tier 1's code (or, with --single, is internal with one call site in the program). What a
# removed call saves, counted from the tags: at its site the call sequence's instructions around the call (tag a: the
# moves, the call) and the saves just before it (tag C); in the callee, per call, its frame (f), its entry's moves (p)
# and its ret; and the caller's restores (R) by the call's share of the caller's calls. Enabling effects (constants
# into the callee, registers no longer clobbered) are not modelled.
import sys, re, bisect, collections
args = sys.argv[1:]
units_path = None
if '--units' in args:
    i = args.index('--units'); units_path = args[i + 1]; del args[i:i + 2]
dis, nm, arcs_path, clang_arcs = args[:4]
ins_paths = args[4:]
order = []; fstart = {}; fend = {}
function = None
for line in open(dis):
    m = re.match(r'^([0-9a-f]+) <(.+)>:$', line)
    if m:
        function = m.group(2); fstart[function] = len(order); continue
    m = re.match(r'^\s+([0-9a-f]+):\t(.*)$', line.rstrip('\n'))
    if m and function is not None:
        order.append((int(m.group(1), 16), m.group(2).strip(), function)); fend[function] = len(order)
index = {a: i for i, (a, t, f) in enumerate(order)}
counts = collections.Counter(); tags = {}; types = {}
for path in ins_paths:
    for line in open(path):
        f = line.rstrip('\n').split('\t')
        a = int(f[2], 16); counts[a] += int(f[5]); tags[a] = f[3]; types[a] = f[4]
total = sum(counts.values())
local = set()
for line in open(nm):
    p = line.split()
    if len(p) == 3 and p[1] == 't':
        local.add(p[2])
unit = {}
if units_path:
    for line in open(units_path):
        p = line.rstrip('\n').split('\t'); unit[p[0]] = p[1]
def unit_of(f): return unit.get(f, '?') if units_path else 'unit'
# Static size: the function's instructions but its padding and its frame.
size = {}
for f in fstart:
    n = 0
    for i in range(fstart[f], fend[f]):
        a, t, _ = order[i]
        if t.startswith('nop') or t.startswith('xchg   %ax,%ax') or t.startswith('int3') or t.startswith('cs nop') or t.startswith('data16'):
            continue
        n += 1
    size[f] = n
arcs = []
for line in open(arcs_path):
    s, caller, callee, c = line.rstrip('\n').split('\t'); arcs.append((int(s, 16), caller, callee, int(c)))
clang_calls = sum(int(l.rstrip('\n').split('\t')[3]) for l in open(clang_arcs))
calls_in = collections.Counter(); calls_out = collections.Counter(); sites_of = collections.Counter()
graph = collections.defaultdict(set)
for s, caller, callee, c in arcs:
    calls_in[callee] += c; calls_out[caller] += c; sites_of[callee] += 1; graph[caller].add(callee)
# Static call sites too (a callee with one executed site may have others never run): count call instructions by target.
static_sites = collections.Counter()
for a, t, f in order:
    m = re.match(r'^call\s+[0-9a-f]+ <([^>+]+)>', t)
    if m: static_sites[m.group(1)] += 1
# Functions in a cycle of the measured call graph (Tarjan, iterative).
idx = {}; lowlink = {}; onstack = set(); stack = []; cyc = set(); counter = [0]
def strong(v):
    work = [(v, iter(graph[v]))]; idx[v] = lowlink[v] = counter[0]; counter[0] += 1; stack.append(v); onstack.add(v)
    while work:
        node, it = work[-1]
        advanced = False
        for w in it:
            if w not in idx:
                idx[w] = lowlink[w] = counter[0]; counter[0] += 1; stack.append(w); onstack.add(w)
                work.append((w, iter(graph[w]))); advanced = True; break
            elif w in onstack:
                lowlink[node] = min(lowlink[node], idx[w])
        if advanced: continue
        work.pop()
        if work: lowlink[work[-1][0]] = min(lowlink[work[-1][0]], lowlink[node])
        if lowlink[node] == idx[node]:
            comp = []
            while True:
                w = stack.pop(); onstack.discard(w); comp.append(w)
                if w == node: break
            if len(comp) > 1 or node in graph[node]:
                cyc.update(comp)
for v in list(graph):
    if v not in idx: strong(v)
# Per-callee per-call overhead: frame, entry, ret.
callee_over = {}
for f in fstart:
    o = 0
    for i in range(fstart[f], fend[f]):
        a = order[i][0]
        if tags.get(a) in ('f', 'p') or types.get(a) == 'ret':
            o += counts.get(a, 0)
    callee_over[f] = o
# Per-site overhead: the a/C run around the call.
def site_over(site):
    i = index.get(site)
    if i is None: return 0
    k = counts.get(site, 0); o = k
    j = i - 1
    while j >= 0 and tags.get(order[j][0]) in ('a', 'C') and types.get(order[j][0]) != 'call' and order[j][2] == order[i][2]:
        o += min(counts.get(order[j][0], 0), k); j -= 1
    j = i + 1
    while j < len(order) and tags.get(order[j][0]) == 'a' and types.get(order[j][0]) != 'call' and order[j][2] == order[i][2]:
        o += min(counts.get(order[j][0], 0), k); j += 1
    return o
restores = collections.Counter()
for f in fstart:
    for i in range(fstart[f], fend[f]):
        a = order[i][0]
        if tags.get(a) == 'R': restores[f] += counts.get(a, 0)
total_calls = sum(c for _, _, _, c in arcs)
print(f"program instructions {total / 1e6:.1f} M; calls into its own code: Tier 1 {total_calls / 1e6:.2f} M, clang -O2 {clang_calls / 1e6:.2f} M")
allover = sum(callee_over.values()) + sum(site_over(s) for s, _, _, _ in arcs) + sum(restores.values())
print(f"call-related instructions counted this way (sites' sequences and saves, callees' frames, entries and rets, restores): {allover / 1e6:.1f} M ({100.0 * allover / total:.1f}% of the program's)")
print("threshold\tcalls removed, M\tshare of calls\tcalls left, M\tinstructions saved, M\tshare of program\tcallees inlined\tcode instructions added")
for single in (False, True):
    for S in (8, 16, 32, 64, 128, 256, 100000):
        removed = 0; saved = 0.0; inlined = set(); growth = 0
        for s, caller, callee, c in arcs:
            same = unit_of(caller) == unit_of(callee) and callee in fstart
            ok = same and callee not in cyc and (size.get(callee, 1 << 30) <= S or (single and callee in local and static_sites[callee] == 1))
            if not ok: continue
            removed += c; inlined.add(callee)
            saved += site_over(s) * 1.0
            saved += callee_over[callee] * (c / calls_in[callee]) if calls_in[callee] else 0
            saved += restores[caller] * (c / calls_out[caller]) if calls_out[caller] else 0
        for callee in inlined:
            # Static growth: each static site gets a copy; the out-of-line copy goes if the callee is internal.
            growth += size[callee] * static_sites[callee] - (size[callee] if callee in local else 0)
        label = ('S<=%d' % S if S < 100000 else 'any size') + (' or single-site' if single else '')
        print(f"{label}\t{removed / 1e6:.2f}\t{100.0 * removed / total_calls:.1f}%\t{(total_calls - removed) / 1e6:.2f}\t{saved / 1e6:.1f}\t{100.0 * saved / total:.1f}%\t{len(inlined)}\t{growth}")
