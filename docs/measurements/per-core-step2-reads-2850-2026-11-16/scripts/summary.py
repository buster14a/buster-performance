#!/usr/bin/env python3
# summary.py RESULTS/LABEL: the census's tables from reads-sqlite3.txt, reads-lua.txt and reads-musl.txt (the node-reads:
# lines of measure-node-machine --shadow --facts-reads), as the record's README and the design's page have them.
import re, sys, collections
LOOKUPS = {'->', '.', '*x', '[]', 'call', 'discard'}
LEAVES = {'identifier', 'literal'}
def kind_of(op):
    return 'leaf' if op in LEAVES else 'lookup' if op in LOOKUPS else 'operator'
def parse(path):
    d = {'kind': {}, 'kindwide': {}, 'op': {}, 'bits': collections.defaultdict(dict), 'flags': collections.defaultdict(lambda: collections.defaultdict(dict)),
         'conversion_flags': collections.defaultdict(lambda: collections.defaultdict(dict)), 'payload': collections.defaultdict(dict),
         'sources': collections.defaultdict(lambda: collections.defaultdict(dict)), 'identities': []}
    for line in open(path, errors='replace'):
        if not line.startswith('node-reads: '):
            m = re.match(r'(status|wall) (\S+)', line)
            if m: d[m.group(1)] = m.group(2)
            m = re.match(r'node-shadow: machine-taken expressions=(\d+) \(([\d.]+)%\) evaluated-nodes=(\d+) \(([\d.]+)%\)', line)
            if m: d['taken_nodes'] = int(m.group(3))
            continue
        line = line.strip()
        m = re.match(r'node-reads: expressions=(\d+) records=(\d+) measured=(\d+) \(([\d.]+)%\); expressions past (\d+) records=(\d+) \(records (\d+)\); consumers left to T=(\d+); misplaced=(\d+)', line)
        if m:
            d['expressions'], d['records'], d['measured'], d['long'], d['long_records'], d['left'], d['misplaced'] = (int(m.group(i)) for i in (1, 2, 3, 6, 7, 8, 9)); continue
        m = re.match(r'node-reads: runs with a field changed: rules=(\d+) sweeps=(\d+); with none changed=(\d+) differences=(\d+)', line)
        if m:
            d['rules'], d['sweeps'], d['same'], d['differences'] = (int(x) for x in m.groups()); continue
        m = re.match(r'node-reads: kind=(\S+) records=(\d+) measured=(\d+) none=(\d+) \S+ named=(\d+) \S+ copied=(\d+) \S+ new=(\d+) \S+ C or X decide on an identity=(\d+) \S+ of a type with no other like it=(\d+)', line)
        if m:
            d['kind'][m.group(1)] = dict(zip(('records', 'measured', 'none', 'named', 'copied', 'new', 'identities', 'lone'), (int(x) for x in m.groups()[1:]))); continue
        m = re.match(r"node-reads: kind=(\S+) a wide field read: type=(\d+) object=(\d+) payload=(\d+) offset=(\d+) conversions=(\d+); of them new at the record: type=(\d+) object=(\d+) payload=(\d+) \(an operand's where it fits: (\d+); an operand's, its rule not run again: (\d+)\) offset=(\d+) conversions=(\d+); read by T=(\d+) C=(\d+) X=(\d+)", line)
        if m:
            v = [int(x) for x in m.groups()[1:]]
            d['kindwide'][m.group(1)] = {'read': v[0:5], 'new': v[5:8] + v[10:12], 'fits': v[8], 'unseen': v[9], 'by': v[12:15]}; continue
        m = re.match(r'node-reads: an identity decides: file=(\S+) line=(\d+) op=(\S+) consumer=(\S+) C=(\S+) X=(\S+) type=(\d+) other=(\d+)', line)
        if m:
            d['identities'].append(m.groups()); continue
        m = re.match(r'node-reads: op=(\S+) records=(\d+) measured=(\d+) none=(\d+) named=(\d+) copied=(\d+) new=(\d+)', line)
        if m:
            d['op'][m.group(1)] = dict(zip(('records', 'measured', 'none', 'named', 'copied', 'new'), (int(x) for x in m.groups()[1:]))); continue
        m = re.match(r'node-reads: op=(\S+) reader=(\S) flag=(\S+) records=(\d+)', line)
        if m:
            d['flags'][m.group(2)][m.group(3)][m.group(1)] = int(m.group(4)); continue
        m = re.match(r'node-reads: op=(\S+) reader=(\S) conversion-flag=(\S+) records=(\d+)', line)
        if m:
            d['conversion_flags'][m.group(2)][m.group(3)][m.group(1)] = int(m.group(4)); continue
        m = re.match(r'node-reads: op=(\S+) reader=(\S) (.*)', line)
        if m:
            d['bits'][(m.group(1), m.group(2))] = {k: int(v) for k, v in (x.split('=') for x in m.group(3).split())}; continue
        m = re.match(r'node-reads: op=(\S+) payload=(\S+) decides for C or X: records=(\d+)', line)
        if m:
            d['payload'][m.group(1)][m.group(2)] = int(m.group(3)); continue
        m = re.match(r'node-reads: op=(\S+) field=(\S+) read, its source=(\S+): records=(\d+)', line)
        if m:
            d['sources'][m.group(2)][m.group(3)][m.group(1)] = int(m.group(4)); continue
        print('UNPARSED', line, file=sys.stderr)
    return d
def share(a, b):
    return '%.2f%%' % (100.0 * a / b) if b else '-'
def n(x):
    return '{:,}'.format(x)
root = sys.argv[1]
names = [('sqlite3', '`sqlite3.c`'), ('lua', 'Lua'), ('musl', 'musl')]
D = [parse('%s/reads-%s.txt' % (root, c)) for c, _ in names]
def row(label, f):
    print('| ' + label + ' | ' + ' | '.join(f(d) for d in D) + ' |')
print('| | ' + ' | '.join(t for _, t in names) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in names) + ' |')
row('expressions the machine takes', lambda d: n(d['expressions']))
row('records of the windows', lambda d: n(d['records']))
row('measured: every reader run again', lambda d: '%s, %s' % (n(d['measured']), share(d['measured'], d['records'])))
row('consumers left to T, whose operands are not', lambda d: n(d['left']))
row('expressions past 256 records; their records', lambda d: '%s; %s' % (n(d['long']), n(d['long_records'])))
row('runs with a field changed: a rule; the sweeps', lambda d: '%s; %s' % (n(d['rules']), n(d['sweeps'])))
row('runs with nothing changed; those that differ', lambda d: '%s; %s' % (n(d['same']), n(d['differences'])))
row('records misplaced', lambda d: n(d['misplaced']))
row('wall time, ms; exit status', lambda d: '%s; %s' % (d.get('wall', '?'), d.get('status', '?')))
print()
for kind, title in (('operator', 'the operators that are no lookup'), ('lookup', 'the lookups'), ('leaf', 'the leaves')):
    print('| **%s**, measured | ' % title + ' | '.join(n(d['kind'][kind]['measured']) for d in D) + ' |')
    for c, t in (('none', 'nothing wide is read'), ('named', 'what is read a code names'), ('copied', 'what is read is a copy'), ('new', 'something read is new at the record')):
        row('… ' + t, lambda d: '%s, %s' % (n(d['kind'][kind][c]), share(d['kind'][kind][c], d['kind'][kind]['measured'])))
    row('… C or X decide on an identity', lambda d: n(d['kind'][kind]['identities']))
    row('… of a type with no other like it', lambda d: n(d['kind'][kind]['lone']))
print()
fields = ('type', 'object', 'payload', 'offset', 'conversions')
for kind in ('operator', 'lookup', 'leaf'):
    for i, f in enumerate(fields):
        row('%s: its %s read; new at the record' % (kind, f), lambda d: '%s; %s' % (n(d['kindwide'][kind]['read'][i]), n(d['kindwide'][kind]['new'][i])) if kind in d['kindwide'] else '?')
    row("%s: a new payload that is an operand's where it fits; an operand's, its rule not run again" % kind, lambda d: '%s; %s' % (n(d['kindwide'][kind]['fits']), n(d['kindwide'][kind]['unseen'])) if kind in d['kindwide'] else '?')
    for i, r in enumerate('TCX'):
        row('%s: a wide field read by %s' % (kind, r), lambda d: '%s, %s' % (n(d['kindwide'][kind]['by'][i]), share(d['kindwide'][kind]['by'][i], d['kind'][kind]['measured'])) if kind in d['kindwide'] else '?')
print()
for (c, t), d in zip(names, D):
    print('%s: the operators that are no lookup by what is new at the record (those with a record that needs one):' % t)
    ops = sorted(((o, v) for o, v in d['op'].items() if kind_of(o) == 'operator' and v['new']), key=lambda x: -x[1]['new'])
    total = sum(v['new'] for _, v in ops)
    for o, v in ops:
        print('  %-8s measured=%-6d new=%-6d (%.1f%% of its records, %.1f%% of the new)' % (o, v['measured'], v['new'], 100.0 * v['new'] / v['measured'], 100.0 * v['new'] / total))
    print('  operators: sources of read fields (field, source: records):')
    for f in sorted(d['sources']):
        for s in sorted(d['sources'][f]):
            k = sum(v for o, v in d['sources'][f][s].items() if kind_of(o) == 'operator')
            if k: print('    %-13s %-8s %d' % (f, s, k))
    print("  T's later rule decides on a record's type's identity (type-decides), by the record's operator:")
    t_all = sorted(((o, b.get('type-decides', 0)) for (o, r), b in d['bits'].items() if r == 'T' and b.get('type-decides', 0)), key=lambda x: -x[1])
    print('    ' + ', '.join('%s %d of %d' % (o, k, d['op'][o]['measured']) for o, k in t_all))
    for r in 'TCX':
        print('  flags %s decides on (records, all kinds; of the operators that are no lookup):' % r)
        print('    ' + ', '.join('%s %d; %d' % (f, sum(v.values()), sum(k for o, k in v.items() if kind_of(o) == 'operator'))
                                 for f, v in sorted(d['flags'][r].items(), key=lambda x: -sum(x[1].values()))))
        if d['conversion_flags'][r]:
            print('  conversion flags %s decides on: ' % r + ', '.join('%s %d' % (f, sum(v.values())) for f, v in sorted(d['conversion_flags'][r].items())))
    print('  payload values that decide for C or X: ' + ', '.join('%s %s %d' % (o, p, k) for o, v in sorted(d['payload'].items()) for p, k in sorted(v.items())))
    idb = collections.Counter()
    for (o, r), b in d['bits'].items():
        if r in 'CX':
            for bit in ('type-decides', 'object-decides', 'converted-decides'):
                if b.get(bit): idb[(o, r, bit)] += b[bit]
    print('  identities C or X decide on: ' + (', '.join('%s %s %s %d' % (o, r, bit, k) for (o, r, bit), k in sorted(idb.items())) or 'none'))
    if d['identities']:
        by = collections.Counter((o, k) for f, l, o, k, cc, xx, t, u in d['identities'])
        print('  listed: %d records; by the record\'s operator and its consumer\'s: ' % len(d['identities']) + ', '.join('%s under %s %d' % (o, k, c) for (o, k), c in sorted(by.items())))
        places = collections.Counter('%s:%s' % (f.split('/')[-1], l) for f, l, o, k, cc, xx, t, u in d['identities'])
        print('  the places with most: ' + ', '.join('%s %d' % (pl, c) for pl, c in places.most_common(8)))
        print('  builtin types among them (a type index under 64): %d' % sum(1 for f, l, o, k, cc, xx, t, u in d['identities'] if int(t) < 64))
    print()
