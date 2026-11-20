#!/usr/bin/env python3
# check-strides.py LINES...: of the pointers' updates' records (own shapes 91 to 94), those whose first operand's
# conversion's stride is not their own type's; and of the stepped updates (own shapes 89, 90, 93, 94), their steps'
# values by the class the entry has.
import sys, collections
n = 0; differ = 0; steps = collections.Counter(); kept = collections.Counter(); floats = collections.Counter()
for path in sys.argv[1:]:
    for line in open(path, errors='replace'):
        if not line.startswith('xv\t'):
            continue
        f = line.rstrip('\n').split('\t')
        own = int(f[7])
        if 91 <= own <= 94:
            n += 1
            differ += f[25] != f[26]
        entries = [x.split(':') for x in f[30].split(',')] if len(f) > 30 and f[30] else []
        if own in (89, 90, 93, 94) and entries:
            steps[(own, entries[0][0], entries[0][1], entries[0][2])] += 1
        if 102 <= own <= 106:
            kept[(own, int(f[8]), tuple(e[0] for e in entries), tuple(e[2][-1] if int(e[2], 16) >> 63 else '-' for e in entries))] += 1
        if own == 1 and entries and int(entries[0][1]) >= 9:
            floats[int(entries[0][1])] += 1
print('pointer updates', n, 'whose two strides differ', differ)
for k, v in sorted(steps.items()):
    print('step own=%d kind=%s class=%s value=%s: %d' % (k + (v,)))
for k, v in sorted(kept.items()):
    print('kept own=%d conv=%d kinds=%s temporaries=%s: %d' % (k[0], k[1], ','.join(k[2]), ''.join(k[3]), v))
print('floating constants by class', dict(floats))
