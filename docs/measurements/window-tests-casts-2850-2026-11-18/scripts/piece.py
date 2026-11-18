#!/usr/bin/env python3
# piece.py FILE...: what the fourth piece's three rules would leave out, by rule, and the listed expressions after.
import sys, collections
src = open(__file__.replace('piece.py', 'rules.py')).read().split("for path in sys.argv[1:]:")[0]
exec(src)
ADD, SUBTRACT, ADD_ASSIGN, SUBTRACT_ASSIGN = 5, 6, 42, 43
INTEGER_CONSTANT = ('zero', 'tiny', 'small', 'constant')
PLAIN = ('signed', 'unsigned') + INTEGER_CONSTANT
def pointer(b): return kind(b) == 'pointer'
def p_cast(o): return o['op'] == CAST and ((o['sent'] == 4 and own_class(o['own'], o['width']) in ('void', 'pointer')) or o['sent'] == 2)
def pair(o): return (pointer(o['left']) and kind(o['right']) in PLAIN) or (pointer(o['right']) and kind(o['left']) in PLAIN)
def p_subscript(o):
    flagged_pointer = (pointer(o['left']) and flagged(o['left'])) or (pointer(o['right']) and flagged(o['right']))
    return o['op'] == SUBSCRIPT and o['sent'] == 1 and pair(o) and not flagged_pointer
def p_sum(o): return o['op'] in (ADD, SUBTRACT, ADD_ASSIGN, SUBTRACT_ASSIGN) and o['sent'] == 1 and pair(o)
RULES = [('casts', p_cast), ('subscripts', p_subscript), ('sums', p_sum)]
for path in sys.argv[1:]:
    expressions = []
    for line in open(path, errors='replace'):
        if not line.startswith('census-expr:'): continue
        parts = line.split()
        expressions.append((dict(x.split('=', 1) for x in parts[1:11]), [parse(o) for o in parts[11:]]))
    total = len(expressions); records = sum(int(f['records']) for f, _ in expressions)
    operators = sum(len(ops) for _, ops in expressions)
    out = collections.Counter(); found = collections.Counter()
    left = 0; left_records = 0
    for f, ops in expressions:
        why = int(f['why']); quiet = 0
        for o in ops:
            for name, r in RULES:
                if r(o):
                    out[name] += 1; quiet += 1
                    found[name] += o['tests'] != 0
                    break
        if (why & ~1) != 0 or int(f['trees']) != 0 or quiet != len(ops):
            left += 1; left_records += int(f['records'])
    print('== %s: listed expressions %d (records %d), listed operators %d' % (path.split('/')[-1], total, records, operators))
    print('   left out: ' + ', '.join('%s %d (with a test %d)' % (n, out[n], found[n]) for n, _ in RULES) + '; operators listed after %d' % (operators - sum(out.values())))
    print('   listed expressions after %d (%.1f%%), their records %d (%.1f%%)' % (left, 100.0 * left / total, left_records, 100.0 * left_records / records))
