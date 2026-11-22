import sys, re, collections
# blockers.py BODY_VERDICTS ROOT_VERDICTS BODIES SOURCE: what stops a body from being taken whole at reader time, by class,
# and the order of classes that frees the most body tokens soonest.
V = {}
for line in open(sys.argv[1]):
    f = [int(x) for x in line.split('\t')]
    V[f[0]] = dict(closing=f[1], roots=f[2], swept=f[6], nodes=f[7])
src = open(sys.argv[4], errors='replace').read().split('\n')
def statement(line):
    # The source lines of the statement that ends at `line` (1-based): back to the line after the last one ending a statement.
    out = [src[line - 1]]
    at = line - 2
    while at >= 0 and len(out) < 12 and not re.search(r'[;{}]\s*(/\*.*\*/)?\s*$', src[at]) and not src[at].lstrip().startswith('#'):
        out.append(src[at]); at -= 1
    return ' '.join(reversed(out))
ROOTS = ['statement', 'condition', 'return', 'switch', 'initializer', 'brace-initializer', 'other']
need = collections.defaultdict(set)
count = collections.Counter(); nodes = collections.Counter()
for line in open(sys.argv[2]):
    f = line.rstrip('\n').split('\t')
    body, token, at, step, detail, op, kind, n = int(f[0]), int(f[1]), int(f[2]), int(f[3]), int(f[4], 16), int(f[5]), int(f[6]), int(f[7])
    if step == 1: k = 'a callee T refuses (a library call computed in place, returns_twice, no prototype)' if detail == 9 else f'T refuses ({detail})'
    elif step == 2: k = {0x20: 'a bit-field (the tests)', 0x40: 'an aggregate\'s value (the tests)', 0x100: 'a declaration\'s flag (the tests)'}.get(detail, f'tests {detail:#x}')
    elif step == 3: k = "an operator with no template of C's (a pointer difference, a conditional, a division or remainder, a comma)"
    else:
        text = statement(at)
        if kind == 5: k = 'a brace initializer\'s element'
        elif re.search(r'\bsizeof\b|\b_Alignof\b|\b__alignof', text): k = 'sizeof or _Alignof (the front leaves it)'
        elif re.search(r"'\\\\|\"[^\"]*\\\\", text): k = 'a character or string with an escape (the front leaves it)'
        elif re.search(r'\bva_(start|arg|end|copy)\b|__builtin_', text): k = 'a builtin or va_ (the front leaves it)'
        else: k = f'no expression of the front\'s, other ({ROOTS[kind]})'
    need[body].add(k); count[k] += 1; nodes[k] += n
B = {}
for line in open(sys.argv[3]):
    f = line.rstrip('\n').split('\t')
    if len(f) >= 9: B[int(f[0])] = dict(closing=int(f[1]), refusal=f[2])
tok = lambda o: V[o]['closing'] - o + 1
T = sum(tok(o) for o in V)
print(f"{'what stops a root':<84} {'roots':>6} {'bodies':>6} {'their tokens':>12}")
for k, c in count.most_common():
    bodies = [o for o in need if k in need[o]]
    print(f"{k:<84} {c:>6} {len(bodies):>6} {100 * sum(tok(o) for o in bodies) / T:>11.1f}%")
have = set(); remaining = set(count)
whole = lambda: sum(tok(o) for o in V if need[o] <= have)
print(f"\ntaken whole with nothing more: {100 * whole() / T:.1f}% of the body tokens")
while remaining:
    best = max(remaining, key=lambda k: (sum(tok(o) for o in V if need[o] <= have | {k}), count[k]))
    have.add(best); remaining.discard(best)
    print(f"  + {best:<82} {100 * whole() / T:>5.1f}%")
