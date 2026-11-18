#!/usr/bin/env python3
# left2.py FILE...: the rows of "what is left" after the fourth piece's rules: listed expressions by why (alone), and the
# listed operators by kind.
import sys, collections
here = __file__.rsplit('/', 1)[0]
exec(open(here + '/rules.py').read().split("for path in sys.argv[1:]:")[0])
piece = open(here + '/piece.py').read()
exec(piece[piece.index("ADD, SUBTRACT"):piece.rindex("for path in sys.argv[1:]:")])
CALL, CONDITIONAL, COMMA = 34, 23, 28
for path in sys.argv[1:]:
    rows = collections.Counter()
    for line in open(path, errors='replace'):
        if not line.startswith('census-expr:'): continue
        parts = line.split()
        f = dict(x.split('=', 1) for x in parts[1:11]); ops = [parse(o) for o in parts[11:]]
        w = int(f['why'])
        left = [o for o in ops if not any(r(o) for _, r in RULES)]
        operator = bool(w & 1) and (bool(left) or int(f['trees']) != 0)
        reasons = (1 if operator else 0) | (w & ~1)
        if reasons == 0: continue
        rows['listed'] += 1
        rows['initializations, with anything'] += bool(w & 2)
        rows['initialization alone'] += reasons == 2
        rows['operator alone'] += reasons == 1
        rows['two writes alone'] += reasons == 4
        rows['address alone'] += reasons == 16
        rows['statement alone'] += reasons == 8
        for o in left:
            rows['operators'] += 1
            nothing = o['tests'] == 0 and o['trigger'] == 16
            rows['operators with nothing'] += nothing
            if o['op'] == ASSIGN:
                rows['assignments'] += 1; rows['assignments with nothing'] += nothing
                rows['assignments of a constant'] += bool(o['all'] & 1)
                rows['assignments: a zero in a plain pointer'] += kind(o['left']) == 'pointer' and kind(o['right']) == 'zero'
            if o['op'] == SUBSCRIPT:
                rows['subscripts'] += 1
                rows['subscripts of an array by a constant'] += bool((o['lp'] | o['rp']) & 0x10) and o['sent'] == 1
            if o['op'] == CALL: rows['calls'] += 1
            if o['op'] in (CONDITIONAL, COMMA): rows['conditionals and commas'] += 1
            if o['op'] == CAST:
                rows['casts'] += 1
                rows['casts of a pointer to a 64-bit integer'] += o['sent'] == 4 and own_class(o['own'], o['width']) == 'int64'
    print('==', path.split('/')[-1])
    for k, v in rows.items(): print('   %-45s %d' % (k, v))
