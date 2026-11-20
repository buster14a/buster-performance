#!/usr/bin/env python3
# tested-values.py CENSUS: of the census of X's rows' lines (x-rows-census-2850-2026-11-19/second/census-*.tsv), the
# values an operator evaluated as branches tests (a record's state with BUSTER_NODE_MACHINE_AFTER_BRANCH, 0x10): how
# many, with a conversion before the test, the test's and the branch's entries, their own entries, the rows over eight
# entries, the senses, and the operators evaluated as branches (0x40).
import csv, collections, sys
census = sys.argv[1]
out = collections.OrderedDict()
def n(cell): return 0 if cell == '-' else len(cell.split(','))
for corpus in ('sqlite3', 'lua', 'musl', 'own'):
    rows = list(csv.DictReader(open('%s/census-%s.tsv' % (census, corpus)), delimiter='\t'))
    tested = [r for r in rows if int(r['state']) & 0x10]
    c = lambda pred: sum(int(r['count']) for r in tested if pred(r))
    out.setdefault('values an operator evaluated as branches tests', []).append(c(lambda r: True))
    out.setdefault('with a conversion before the test', []).append(c(lambda r: r['conv'] != '-'))
    out.setdefault('the test and the branch: three entries', []).append(c(lambda r: n(r['after']) == 3))
    out.setdefault('four (a narrow class\'s)', []).append(c(lambda r: n(r['after']) == 4))
    out.setdefault('another number', []).append(c(lambda r: n(r['after']) not in (3, 4)))
    for k in range(5):
        out.setdefault('own entries: %d' % k, []).append(c(lambda r: n(r['own']) == k))
    out.setdefault('rows over eight entries', []).append(c(lambda r: n(r['own']) + n(r['conv']) + n(r['after']) > 8))
    out.setdefault('a branch of kind 37', []).append(c(lambda r: r['after'].endswith('37:5')))
    out.setdefault('a branch of kind 36', []).append(c(lambda r: r['after'].endswith('36:5')))
    out.setdefault('operators evaluated as branches', []).append(sum(int(r['count']) for r in rows if int(r['state']) & 0x40))
print("| | `sqlite3.c` | Lua | musl | the compiler's own source |")
print('| --- | ---: | ---: | ---: | ---: |')
for k, v in out.items():
    print('| %s | %s |' % (k, ' | '.join('{:,}'.format(x) for x in v)))
