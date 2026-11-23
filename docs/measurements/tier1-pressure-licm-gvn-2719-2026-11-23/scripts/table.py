import sys, collections
rows = collections.OrderedDict()
for line in open(sys.argv[1]):
    p = line.split()
    if len(p) != 3: continue
    rows.setdefault(p[0], {})[p[1]] = int(p[2])
base = rows['base']
progs = ['arithmetic','calls','closures','strings','tables','speedtest1']
print('%-14s' % 'label' + ''.join('%12s' % x[:10] for x in progs) + '%10s%10s' % ('lua', 'st1'))
for label, r in rows.items():
    if not all(x in r for x in progs): continue
    lua = sum(r[x] for x in progs[:5]) / sum(base[x] for x in progs[:5]) - 1
    print('%-14s' % label + ''.join('%+11.2f%%' % (100.0 * (r[x] / base[x] - 1)) for x in progs) + '%+9.2f%%%+9.2f%%' % (100 * lua, 100 * (r['speedtest1'] / base['speedtest1'] - 1)))
