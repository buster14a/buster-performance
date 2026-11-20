import sys, os, statistics, collections
# summarize.py REVIEW_DIR: medians of the review's TSVs (written when the record was assembled, 2026-11-20).
# Knob M2546 of the first commit's switch build (s2546/mutant-compiler2): 0 is the first commit as committed
# (bind_populate called), 44 is bind_populate not called (main's behaviour).
#   sweep/sweep.tsv: N, faults and peak-kb-added of the executable stage with knob 0, then with knob 44
#   sweep/{hit,hit3,hp2}.tsv: program, knob, executable ms, faults, peak-kb-added
#   knob/ab.tsv, knob/abh.tsv: knob, executable ms, faults (base pages; BUSTER_HUGE_PAGES=1)
#   knob/abb.tsv: knob, executable ms, faults, total ms (big.c, base pages)
#   stage/*/NAME.tsv: executable ms, faults, peak-kb-added (stage.sh's columns)
root = sys.argv[1]
def med(xs):
    return statistics.median(xs)
rows = [l.split('\t') for l in open(os.path.join(root, 'sweep/sweep.tsv')).read().split('\n') if l]
differ = [r for r in rows if r[1:3] != r[3:5]]
print('sweep: %d sizes from %s to %s bytes of data; %d differ with populate (%.2f%%):' % (len(rows), rows[0][0], rows[-1][0], len(differ), 100.0 * len(differ) / len(rows)))
for r in differ:
    print('  N=%s: knob 0 %s faults %s KB, knob 44 %s faults %s KB' % tuple(r))
for name in ('hit', 'hit3', 'hp2'):
    table = collections.defaultdict(list)
    for line in open(os.path.join(root, 'sweep/%s.tsv' % name)):
        f = line.split()
        table[(f[0], f[1])].append((float(f[2]), int(f[3]), int(f[4])))
    print('sweep/%s.tsv:' % name)
    for (program, knob), v in table.items():
        ms = sorted(x[0] for x in v)
        print('  %-5s knob %-2s n=%d executable median %.3f ms (q1 %.3f, q3 %.3f) faults %g peak-kb %g' % (program, knob, len(v), med(ms), ms[len(ms) // 4], ms[3 * len(ms) // 4], med(x[1] for x in v), med(x[2] for x in v)))
for name in ('ab', 'abh', 'abb'):
    table = collections.defaultdict(list)
    for line in open(os.path.join(root, 'knob/%s.tsv' % name)):
        f = line.split()
        table[f[0]].append([float(x) for x in f[1:]])
    print('knob/%s.tsv:' % name)
    for knob, v in table.items():
        print('  knob %-2s n=%d ' % (knob, len(v)) + ' '.join('%g' % med(x[k] for x in v) for k in range(len(v[0]))))
stage = os.path.join(root, 'stage')
for d in sorted(os.listdir(stage)):
    if os.path.isdir(os.path.join(stage, d)):
        print('stage/%s:' % d)
        for t in sorted(os.listdir(os.path.join(stage, d))):
            v = [l.split() for l in open(os.path.join(stage, d, t)) if l.strip()]
            print('  %-8s n=%d executable median %.3f ms faults %g peak-kb %g' % (t[:-4], len(v), med(float(x[0]) for x in v), med(int(x[1]) for x in v), med(int(x[2]) for x in v)))
