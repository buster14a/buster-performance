import sys, collections
# unlock.py SHADOW.txt: bodies by what blocks a whole-body take, and the order that unlocks the most nodes.
TESTS = ['tracked-body', 'popped-again', 'control', 'operator', 'complex-bitint-atomic-vector-half', 'bit-field', 'aggregate-value', 'compound-literal', 'declaration-flag', 'callee',
         'size', 'action-warning', 'warning-event', 'enum-mix', 'sign-compare', 'pointer-cast-or-void-dereference', 'string-plus-int', 'packed-member-address', 'unevaluated-operand',
         'constant', 'parentheses', 'unused-value', 'self-assign', 'return-address', 'for-loop-analysis', 'unsequenced', 'region', 'unmodeled-warning', 'pointer-integer-order']
CONTROLS = ['EVALUATE', 'INITIALIZE', 'VLA', 'ASM', 'RETURN', 'SWITCH', 'CASE', 'END', 'STACK_SAVE', 'ALLOCATE', 'STACK_RESTORE', 'LABEL', 'JUMP_INDIRECT', 'CLEANUP', 'RESULT',
            'LIFETIME', 'EXIT', 'BRANCH_FALSE', 'BRANCH_TRUE', 'JUMP', 'KEPT', 'TAIL']
PLAIN = {'EVALUATE', 'INITIALIZE', 'RETURN', 'END', 'EXIT', 'BRANCH_FALSE', 'BRANCH_TRUE', 'JUMP', 'RESULT', 'KEPT'}
bodies = []
for line in open(sys.argv[1]):
    if line.startswith('experiment-body:'):
        f = line.split()
        opening, controls, entries, roots, nodes = map(int, f[1:6])
        tests, kinds, refused = int(f[6], 16), int(f[7], 16), int(f[8])
        blockers = set()
        for i, name in enumerate(TESTS):
            if tests >> i & 1:
                blockers.add('test:' + name)
        if refused:
            blockers.add('machine-refusal')
        for i, name in enumerate(CONTROLS):
            if kinds >> i & 1 and name not in PLAIN:
                blockers.add('control:' + name)
        bodies.append((nodes, entries, blockers))
total_nodes = sum(b[0] for b in bodies)
total_entries = sum(b[1] for b in bodies)
print(f'bodies {len(bodies)}, nodes {total_nodes}, entries {total_entries}')
kinds_present = collections.Counter()
for nodes, entries, blockers in bodies:
    for b in blockers:
        kinds_present[b] += 1
free = [b for b in bodies if not b[2]]
print(f'no blocker: bodies {len(free)} ({len(free) / len(bodies):.1%}), nodes {sum(b[0] for b in free)} ({sum(b[0] for b in free) / total_nodes:.1%}), entries {sum(b[1] for b in free) / total_entries:.1%}')
remaining = [b for b in bodies if b[2]]
done = set()
unlocked_nodes = sum(b[0] for b in free)
print(f'{"unlock next":44} {"bodies with it":>14} {"bodies whole":>13} {"nodes whole":>12}')
while remaining:
    # the blocker whose removal (with those already removed) frees the most nodes; ties by presence
    best, gain = None, -1
    cands = set().union(*[b[2] for b in remaining]) - done
    for c in cands:
        g = sum(b[0] for b in remaining if b[2] - done - {c} == set())
        if g > gain or (g == gain and kinds_present[c] > kinds_present.get(best, 0)):
            best, gain = c, g
    done.add(best)
    still = []
    for b in remaining:
        if b[2] - done:
            still.append(b)
        else:
            unlocked_nodes += b[0]
    remaining = still
    whole = len(bodies) - len(remaining)
    print(f'{best:44} {kinds_present[best]:14} {whole:6} {whole / len(bodies):6.1%} {unlocked_nodes / total_nodes:11.1%}')
