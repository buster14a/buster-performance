import sys, collections
# census.py BODIES...: over the recordings' body lists, how often each control kind and expression op appears (by bodies
# and by their tokens), and what a set of constructs covers.
CONTROLS = 'EVALUATE INITIALIZE VLA ASM RETURN SWITCH CASE END STACK_SAVE ALLOCATE STACK_RESTORE LABEL JUMP_INDIRECT CLEANUP RESULT LIFETIME EXIT BRANCH_FALSE BRANCH_TRUE JUMP KEPT TAIL'.split()
OPS = 'VALUE POSITIVE NEGATIVE NOT BIT_NOT ADD SUBTRACT MULTIPLY DIVIDE REMAINDER SHIFT_LEFT SHIFT_RIGHT LESS LESS_EQUAL GREATER GREATER_EQUAL EQUAL NOT_EQUAL BIT_AND BIT_OR BIT_XOR LOGICAL_AND LOGICAL_OR CONDITIONAL CAST ADDRESS DEREFERENCE ASSIGN COMMA SUBSCRIPT SIZEOF ALIGNOF MEMBER ARROW CALL INITIALIZE CONVERT CONDITION PRE_INCREMENT PRE_DECREMENT POST_INCREMENT POST_DECREMENT ADD_ASSIGN SUBTRACT_ASSIGN MULTIPLY_ASSIGN DIVIDE_ASSIGN REMAINDER_ASSIGN SHIFT_LEFT_ASSIGN SHIFT_RIGHT_ASSIGN BIT_AND_ASSIGN BIT_OR_ASSIGN BIT_XOR_ASSIGN SELECT BUILTIN_UNARY BUILTIN_OVERFLOW STATEMENT_VALUE VARARGS VLA_BOUND VLA_EXTENT SIZEOF_VLA BUILTIN_MISC BUILTIN_FLOAT BUILTIN_QUERY BUILTIN_ATOMIC REAL IMAGINARY BUILTIN_VECTOR BUILTIN_X86 BUILTIN_BIT_CAST'.split()
bodies = []
for path in sys.argv[1:]:
    for line in open(path):
        f = line.rstrip('\n').split('\t')
        if len(f) < 10: continue
        bodies.append(dict(tokens=int(f[1]) - int(f[0]) + 1, refusal=f[2], entries=int(f[3]), name=f[4], controls=int(f[5], 16), ops=int(f[6], 16) | (int(f[7], 16) << 64), nodes=int(f[8])))
total_tokens = sum(b['tokens'] for b in bodies)
print(f'{len(bodies)} bodies, {total_tokens} tokens, {sum(b["nodes"] for b in bodies)} nodes, {sum(b["entries"] for b in bodies)} entries')
def table(names, key, title):
    print(f'\n{title}: bodies with it, their tokens\' share')
    rows = []
    for i, n in enumerate(names):
        hit = [b for b in bodies if b[key] >> i & 1]
        if hit: rows.append((len(hit), sum(b['tokens'] for b in hit), n))
    for c, t, n in sorted(rows, reverse=True):
        print(f'  {n:<20} {c:>6} {100 * c / len(bodies):5.1f}%  {100 * t / total_tokens:5.1f}% of tokens')
table(CONTROLS, 'controls', 'control kinds')
table(OPS, 'ops', 'expression ops')
# Greedy: the order of constructs (control kinds and ops together) that frees the most tokens soonest.
items = [('c', i, n) for i, n in enumerate(CONTROLS)] + [('o', i, n) for i, n in enumerate(OPS)]
need = []
for b in bodies:
    s = frozenset([('c', i) for i in range(len(CONTROLS)) if b['controls'] >> i & 1] + [('o', i) for i in range(len(OPS)) if b['ops'] >> i & 1])
    need.append((s, b['tokens']))
have = set()
print('\ngreedy order: construct added, bodies whole so far, tokens covered')
remaining = set(k for s, _ in need for k in s)
while remaining:
    best = None
    for k in remaining:
        h = have | {k}
        cov = sum(t for s, t in need if s <= h)
        # tie-break: how many bodies need it
        score = (cov, sum(1 for s, _ in need if k in s))
        if best is None or score > best[0]: best = (score, k)
    have.add(best[1]); remaining.discard(best[1])
    done = sum(1 for s, _ in need if s <= have); cov = sum(t for s, t in need if s <= have)
    name = (CONTROLS if best[1][0] == 'c' else OPS)[best[1][1]]
    print(f'  {("control " if best[1][0] == "c" else "op ") + name:<28} {done:>6} bodies {100 * done / len(bodies):5.1f}%  tokens {100 * cov / total_tokens:5.1f}%')
