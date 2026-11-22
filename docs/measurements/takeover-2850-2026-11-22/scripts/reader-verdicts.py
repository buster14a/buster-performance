import sys, collections
# verdicts.py VERDICTS BODIES: the machine's reader-time verdicts by body (the shadow's dump: opening, closing, roots the
# lowering popped, those T ran on, T took, the tests left silent, C and X took, nodes, nodes in swept roots, the census's
# whole) against the recording's list of bodies (opening, closing, refusal, entries, name, control kinds, ops, nodes).
CONTROLS = 'EVALUATE INITIALIZE VLA ASM RETURN SWITCH CASE END STACK_SAVE ALLOCATE STACK_RESTORE LABEL JUMP_INDIRECT CLEANUP RESULT LIFETIME EXIT BRANCH_FALSE BRANCH_TRUE JUMP KEPT TAIL'.split()
V = {}
for line in open(sys.argv[1]):
    f = [int(x) for x in line.split('\t')]
    V[f[0]] = dict(closing=f[1], roots=f[2], ran=f[3], typed=f[4], silent=f[5], swept=f[6], nodes=f[7], swept_nodes=f[8], census=f[9])
B = {}
for line in open(sys.argv[2]):
    f = line.rstrip('\n').split('\t')
    if len(f) < 9: continue
    B[int(f[0])] = dict(closing=int(f[1]), refusal=f[2], controls=int(f[5], 16), nodes=int(f[8]))
tokens = lambda o, r: r['closing'] - o + 1
T = sum(tokens(o, r) for o, r in B.items()); N = sum(v['nodes'] for v in V.values())
print(f"bodies {len(B)} in the recording, {len(V)} in the shadow; body tokens {T}; evaluated nodes {N}")
def has(r, name): return r['controls'] >> CONTROLS.index(name) & 1
rows = collections.OrderedDict()
def add(k, o): 
    c = rows.setdefault(k, [0, 0, 0]); c[0] += 1; c[1] += tokens(o, B[o]); c[2] += V[o]['nodes'] if o in V else 0
whole = []
for o, r in B.items():
    v = V.get(o)
    if v is None: add('not lowered (the selection dropped it)', o); continue
    w = v['roots'] == v['swept']
    if w: whole.append(o)
    if w: add('every root taken at reader time', o)
    elif v['ran'] < v['roots']: add('a root the front made no expression of', o)
    elif v['typed'] < v['ran']: add('a root T refuses', o)
    elif v['silent'] < v['typed']: add('a root the tests refuse', o)
    else: add('a root C or X refuses', o)
print(f"\n{'by the first failing step':<46} {'bodies':>6} {'tokens':>8} {'share':>6} {'nodes':>8} {'share':>6}")
for k, (c, t, n) in rows.items():
    print(f"{k:<46} {c:>6} {t:>8} {100 * t / T:>5.1f}% {n:>8} {100 * n / N:>5.1f}%")
def report(title, keep):
    sel = [o for o in whole if keep(B[o])]
    t = sum(tokens(o, B[o]) for o in sel); n = sum(V[o]['nodes'] for o in sel)
    print(f"{title:<78} {len(sel):>5} bodies {t:>7} tokens {100 * t / T:>5.1f}% {100 * n / N:>5.1f}% of nodes")
print()
report('whole at reader time', lambda r: True)
report('... and the boundary takes it (recorded as supplied)', lambda r: r['refusal'] == 'supplied')
simple = lambda r: r['refusal'] == 'supplied' and not any(has(r, k) for k in ('SWITCH', 'CASE', 'VLA', 'ASM', 'STACK_SAVE', 'ALLOCATE', 'STACK_RESTORE', 'LABEL', 'JUMP_INDIRECT', 'CLEANUP', 'RESULT', 'LIFETIME', 'EXIT'))
report('... and no switch, label, cleanup or stack allocation', simple)
report('... and no initializer either', lambda r: simple(r) and not has(r, 'INITIALIZE'))
# What the machine sweeps for nothing: the bodies it starts and refuses.
lost = [o for o in B if o in V and o not in whole]
print(f"\nbodies the machine would start and refuse: {len(lost)}, {sum(tokens(o, B[o]) for o in lost)} tokens ({100 * sum(tokens(o, B[o]) for o in lost) / T:.1f}%), "
      f"{sum(V[o]['nodes'] for o in lost)} nodes ({100 * sum(V[o]['nodes'] for o in lost) / N:.1f}%), of them in roots it took {sum(V[o]['swept_nodes'] for o in lost)}")
