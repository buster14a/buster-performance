#!/usr/bin/env python3
# enums.py FILE...: the listed operators an enumeration operand alone sent, by operator, and those with one operand.
import sys, collections
src = open(__file__.replace('enums.py', 'rules.py')).read().split("for path in sys.argv[1:]:")[0]
exec(src)
for path in sys.argv[1:]:
    names = {}
    table = collections.Counter(); fired = collections.Counter(); sent_on = collections.Counter()
    for line in open(path, errors='replace'):
        if line.startswith('census-op:'):
            g = dict(x.split('=', 1) for x in line.split()[1:]); names[int(g['code'])] = g['name']
        if not line.startswith('census-expr:'): continue
        for o in map(parse, line.split()[11:]):
            if o['sent'] & 2 == 0: continue
            key = (o['op'], 'E' if o['sent'] == 2 else 'E+%x' % (o['sent'] & ~2), 'one operand' if o['rop'] == 255 else 'two')
            table[key] += 1; fired[key] += o['tests'] != 0; sent_on[key] += o['trigger'] != 16
    print('==', path.split('/')[-1])
    for key, n in sorted(table.items(), key=lambda x: -x[1])[:14]:
        print('  %6d  %-10s sent=%-5s %-11s with a test %d, sent on %d' % (n, names.get(key[0], key[0]), key[1], key[2], fired[key], sent_on[key]))
