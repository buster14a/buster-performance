#!/usr/bin/env python3
# arenas.py LOG: the reservations of a compile by their call's place: how many, what their pushes took fresh, what of it
# is resident, what of that is pages of pushes that need zeros, and how many such pushes; and the sums by whether a
# reservation has such a push.
import sys, collections
rows = collections.defaultdict(lambda: [0, 0, 0, 0, 0, 0])
for line in open(sys.argv[1]):
    p = line.split()
    r = rows[p[0]]
    r[0] += 1; r[1] += int(p[2]); r[2] += int(p[3]); r[3] += int(p[4]); r[4] += int(p[5]); r[5] += int(p[6])
mb = 1 << 20
total = sum(r[3] for r in rows.values()); with_zero = sum(r[3] for r in rows.values() if r[5] != 0); own = sum(r[4] for r in rows.values())
print('reservation sites %d; resident in registered arenas %.1f MB: %.1f MB in arenas no push of which needs zeros, %.1f MB in arenas with one (the zero-needing pushes own pages %.1f MB of those)' % (len(rows), total / mb, (total - with_zero) / mb, with_zero / mb, own / mb))
print('%-34s %5s %10s %10s %10s %6s' % ('reservation', 'count', 'fresh MB', 'resid MB', 'zero MB', 'zpush'))
for k, r in sorted(rows.items(), key=lambda x: -x[1][3])[:int(sys.argv[2]) if len(sys.argv) > 2 else 28]:
    print('%-34s %5d %10.1f %10.1f %10.1f %6d' % (k, r[0], r[1] / mb, r[3] / mb, r[4] / mb, r[5]))
