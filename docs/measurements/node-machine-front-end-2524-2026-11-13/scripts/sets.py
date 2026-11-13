# sets.py DIR...: each DIR (results/LABEL/sets-INPUT) has explore-sets.sh's counts-p0-setx.txt and counts-p40-setK.txt for
# K in 0, 1, 2, and shadow-p40-set0.txt for the machine-taken nodes. Prints each set's 40 passes, less --passes 0, per taken
# node, and each sweep's own share (T; C = set 1 - set 0; X = set 2 - set 1), each DIR's and then, for more than one, the
# medians of each figure over the DIRs. perf stat multiplexes the five events, so each figure is a difference of two
# processes' scaled counts.
import re, sys, os, statistics
def counts(path):
    out = {}
    for line in open(path):
        m = re.match(r'\s*([\d,]+)\s+(\S+)', line)
        if m and ':u' in m.group(2):
            out[m.group(2).replace(':u', '')] = int(m.group(1).replace(',', ''))
    return out
names = ['cycles', 'instructions', 'de_no_dispatch_per_slot.no_ops_from_frontend', 'ic_tag_hit_miss.instruction_cache_miss', 'ex_ret_brn_misp']
short = ['cycles', 'instr', 'fe-slots', 'l1i-miss', 'misp']
labels = ['T', 'C', 'X', 'T+C+X']
def show(title, rows):
    print('== %s' % title)
    print('%-8s' % '' + ''.join('%10s' % x for x in short) + '%10s' % 'fe-share')
    for label, v in zip(labels, rows):
        print('%-8s' % label + ''.join('%10.1f' % x for x in v) + '%9.0f%%' % (100.0 * v[2] / (8.0 * v[0]) if v[0] else 0))
every = []
for d in sys.argv[1:]:
    nodes = int(re.search(r'machine-taken .*?evaluated-nodes=(\d+)', open(os.path.join(d, 'shadow-p40-set0.txt')).read()).group(1))
    base = counts(os.path.join(d, 'counts-p0-setx.txt'))
    sets = [counts(os.path.join(d, 'counts-p40-set%d.txt' % k)) for k in range(3)]
    per = [[(s[n] - base[n]) / (40.0 * nodes) for n in names] for s in sets]
    rows = [per[0], [b - a for a, b in zip(per[0], per[1])], [b - a for a, b in zip(per[1], per[2])], per[2]]
    every.append(rows)
    show('%s (nodes %d)' % (d, nodes), rows)
if len(every) > 1:
    show('medians of %d' % len(every), [[statistics.median(r[i][j] for r in every) for j in range(len(names))] for i in range(len(labels))])
