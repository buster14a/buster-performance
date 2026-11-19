#!/usr/bin/env python3
# mix.py LOOP.s...: the loop's main body's instructions by kind (its body: from the target of its longest backward jump
# to that jump).
import re, sys, collections
for path in sys.argv[1:]:
    ins = []
    for line in open(path):
        m = re.match(r'\s*([0-9a-f]+):\s+(\S+)\s*(.*)', line)
        if m:
            ins.append((int(m.group(1), 16), m.group(2), m.group(3).split('#')[0]))
    best = None
    for a, op, args in ins:
        if op.startswith('j'):
            m = re.match(r'([0-9a-f]+) <', args)
            if m:
                t = int(m.group(1), 16)
                if t < a and (best is None or a - t > best[0]):
                    best = (a - t, t, a)
    _, head, tail = best
    body = [(a, op, args) for a, op, args in ins if head <= a <= tail]
    ops = collections.Counter(op for _, op, _ in body)
    groups = collections.Counter()
    for op, n in ops.items():
        if op.startswith('kmov'): g = 'kmov (a mask to or from a general register or the frame)'
        elif op in ('and', 'or', 'andn', 'not', 'xor', 'test'): g = 'general logic'
        elif op.startswith(('kand', 'kor', 'knot', 'kxor', 'kortest', 'ktest', 'kxnor', 'kadd', 'kshift')): g = 'mask-register logic'
        elif op.startswith(('vpcmp', 'vptest')): g = 'vector compare or test into a mask'
        elif op.startswith(('vperm', 'vpshuf')): g = 'vector permute'
        elif op.startswith('mov') or op.startswith('cmov') or op == 'lea': g = 'general mov, cmov, lea'
        elif op.startswith(('vmov', 'vbroadcast', 'vpbroadcast')): g = 'vector mov, load, store, broadcast'
        elif op.startswith('j') or op in ('cmp', 'call', 'ret'): g = 'branch, compare, call'
        elif op.startswith('v'): g = 'other vector'
        else: g = 'other general'
        groups[g] += n
    print('%s: %d instructions' % (path, len(body)))
    for g, n in groups.most_common():
        print('   %4d %s' % (n, g))
    print('   most: ' + ', '.join('%s %d' % kv for kv in ops.most_common(16)))
