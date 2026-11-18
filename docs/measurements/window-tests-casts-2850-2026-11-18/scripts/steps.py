#!/usr/bin/env python3
# steps.py FILE...: the listed expressions and their records after each of the piece's rules, alone and together.
import sys, collections, importlib.util
spec = importlib.util.spec_from_file_location('rules', __file__.replace('steps.py', 'rules.py'))
src = open(__file__.replace('steps.py', 'rules.py')).read().split("for path in sys.argv[1:]:")[0]
exec(src)
ADD, SUBTRACT, ADD_ASSIGN, SUBTRACT_ASSIGN = 5, 6, 42, 43
def r_arith(o):
    integer = lambda b: kind(b) in ('zero', 'tiny', 'small', 'constant')
    plain = lambda b: kind(b) in ('signed', 'unsigned', 'zero', 'tiny', 'small', 'constant')
    lp, rp = kind(o['left']) == 'pointer', kind(o['right']) == 'pointer'
    return o['op'] in (ADD, SUBTRACT, ADD_ASSIGN, SUBTRACT_ASSIGN) and o['sent'] == 1 and ((lp and plain(o['right'])) or (rp and plain(o['left'])))
SETS = [('none', []), ('casts to void or a pointer', [r_cast_void_pointer]), ('casts (and to a 64-bit integer)', [r_cast]), ('subscripts', [r_subscript]), ('pointer and constant sums', [r_arith]),
        ('casts + subscripts', [r_cast, r_subscript]), ('casts + subscripts + sums', [r_cast, r_subscript, r_arith]),
        ('casts + subscripts + sums + null + literal zero', [r_cast, r_subscript, r_arith, r_null, r_assign_zero])]
for path in sys.argv[1:]:
    expressions = []
    for line in open(path, errors='replace'):
        if not line.startswith('census-expr:'): continue
        parts = line.split()
        f = dict(x.split('=', 1) for x in parts[1:11])
        expressions.append((f, [parse(o) for o in parts[11:]]))
    total = len(expressions); records = sum(int(f['records']) for f, _ in expressions)
    print('==', path.split('/')[-1], 'listed expressions', total, 'their records', records)
    for name, rules in SETS:
        left = 0; left_records = 0; operators = 0
        for f, ops in expressions:
            why = int(f['why'])
            out = [o for o in ops if any(r(o) for r in rules)]
            operators += len(out)
            listed = (why & ~1) != 0 or int(f['trees']) != 0 or len(out) != len(ops)
            if listed:
                left += 1; left_records += int(f['records'])
        print('  %-50s operators left out %6d  listed %6d (%5.1f%%)  records %7d (%5.1f%%)' % (name, operators, left, 100.0 * left / total, left_records, 100.0 * left_records / records))
