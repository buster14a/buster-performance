#!/usr/bin/env python3
# left.py FILE...: what is listed still after the fourth piece's three rules, by why and by operator.
import sys, collections
here = __file__.rsplit('/', 1)[0]
exec(open(here + '/rules.py').read().split("for path in sys.argv[1:]:")[0])
piece = open(here + '/piece.py').read()
exec(piece[piece.index("ADD, SUBTRACT"):piece.rindex("for path in sys.argv[1:]:")])
for path in sys.argv[1:]:
    names = {}
    expressions = []
    for line in open(path, errors='replace'):
        if line.startswith('census-op:'):
            g = dict(x.split('=', 1) for x in line.split()[1:]); names[int(g['code'])] = g['name']
        if not line.startswith('census-expr:'): continue
        parts = line.split()
        expressions.append((dict(x.split('=', 1) for x in parts[1:11]), [parse(o) for o in parts[11:]]))
    why = collections.Counter(); ops = collections.Counter(); nothing = collections.Counter(); listed = 0; total_ops = 0
    for f, operators in expressions:
        w = int(f['why'])
        left = [o for o in operators if not any(r(o) for _, r in RULES)]
        reasons = []
        if (w & 1) and (left or int(f['trees']) != 0): reasons.append('operator')
        if w & 2: reasons.append('initialization')
        if w & 4: reasons.append('two writes')
        if w & 8: reasons.append('statement')
        if w & 16: reasons.append('address')
        if w & 32: reasons.append('warned')
        if not reasons: continue
        listed += 1
        why['+'.join(reasons)] += 1
        for o in left:
            total_ops += 1
            ops[names.get(o['op'], o['op'])] += 1
            nothing[names.get(o['op'], o['op'])] += (o['tests'] == 0 and o['trigger'] == 16)
    print('== %s: listed %d, operators %d' % (path.split('/')[-1], listed, total_ops))
    print('   why:', ', '.join('%s %d' % x for x in why.most_common(9)))
    print('   operators:', ', '.join('%s %d (%d with nothing)' % (n, c, nothing[n]) for n, c in ops.most_common(12)))
