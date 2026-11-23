import sys, collections
rows = collections.OrderedDict(); dig = {}
for line in open(sys.argv[1]):
    p = line.split()
    if len(p) != 3: continue
    if p[1] == 'digest': dig[p[0]] = p[2]; continue
    rows.setdefault(p[0], {})[p[1]] = int(p[2])
labels = list(rows)
base = rows[labels[0]]
print('%-18s' % 'kernel' + ''.join('%11s' % l[-10:] for l in labels))
for k in sorted(base):
    vals = [rows[l].get(k, 0) for l in labels]
    if all(v == vals[0] for v in vals): continue
    print('%-18s' % k + ''.join('%+10.1f%%' % (100.0 * (v / base[k] - 1)) for v in vals))
print('%-18s' % 'TOTAL' + ''.join('%+10.2f%%' % (100.0 * (sum(rows[l].values()) / sum(base.values()) - 1)) for l in labels))
print('digests', set(dig.values()))
