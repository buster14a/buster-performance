#!/usr/bin/env python3
# casts.py FILE...: the listed casts by what sent them and by their own type.
import sys, collections
src = open(__file__.replace('casts.py', 'rules.py')).read().split("for path in sys.argv[1:]:")[0]
exec(src)
for path in sys.argv[1:]:
    table = collections.Counter(); fired = collections.Counter(); total = 0; operators = 0
    for line in open(path, errors='replace'):
        if not line.startswith('census-expr:'): continue
        for o in map(parse, line.split()[11:]):
            operators += 1
            if o['op'] != CAST: continue
            total += 1
            key = ('pointer' if o['sent'] == 4 else 'enumeration' if o['sent'] == 2 else 'other %x' % o['sent'], own_class(o['own'], o['width']))
            table[key] += 1
            fired[key] += (o['tests'] != 0) + 1000000 * (o['trigger'] != 16)
    print('==', path.split('/')[-1], 'listed operators', operators, 'casts', total)
    for key, n in sorted(table.items(), key=lambda x: -x[1]):
        print('  %6d  operand: %-12s own type: %-8s with a test %d, sent to the census\'s code %d' % (n, key[0], key[1], fired[key] % 1000000, fired[key] // 1000000))
