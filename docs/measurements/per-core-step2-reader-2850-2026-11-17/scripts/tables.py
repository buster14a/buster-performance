#!/usr/bin/env python3
# tables.py RESULTS LABEL...: the fact words' kernel at reader time on the 9700X, from job.sh's files: for each label and
# corpus the medians of the readings, TSC ticks a record: T there on the lean front alone and beside the kernel; the
# kernel's first and later runs and T again on the same expressions; the windows' inputs from the front's records, as
# each expression came and by the batch's passes; the words' making; and what the kernel made and how it compared.
import re, sys, glob, statistics
root = sys.argv[1]
labels = sys.argv[2:]
def readings(label, tag, corpus):
    return sorted(glob.glob(f'{root}/{label}/{tag}-{corpus}-[0-9]*.txt'), key=lambda f: int(re.search(r'-(\d+)\.txt$', f).group(1)))
def text(f): return open(f, errors='replace').read()
bad = []
def med(v): return statistics.median(v) if v else float('nan')
for label in labels:
    print(f'## {label}')
    for corpus in ('sqlite3', 'lua', 'musl'):
        d = {}
        n = 0
        last = None
        for f in readings(label, 'facts', corpus):
            t = text(f); n += 1
            if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
            m = re.search(r'reader-time T expressions=(\d+) records=(\d+) .* ticks=(\d+) setup-ticks=(\d+)', t)
            d.setdefault('T beside', []).append(int(m.group(3)) / int(m.group(2)))
            m = re.search(r'fact words expressions=(\d+) records=(\d+) windows=(\d+)', t); records = int(m.group(2)); last = m.groups()
            m = re.search(r'fact words ticks first=(\d+) later=(\d+) again=(\d+) rows=(\d+) lines=(\d+) append=(\d+)', t)
            for k, v in zip(('kernel first', 'kernel later', 'T again', 'rows', 'lines', 'append'), m.groups()): d.setdefault(k, []).append(int(v) / records)
            m = re.search(r"inputs from the front's records: expressions=(\d+) \(([\d.]+)%\) records=(\d+) \(([\d.]+)%\) differences=(\d+) expressions-not-given-whole=(\d+) ticks=(\d+) \(([\d.]+) a record\) \S+=(\d+) \(([\d.]+) a record of (\d+)\)", t)
            if m:
                d.setdefault('front first', []).append(float(m.group(8))); d.setdefault('front again', []).append(float(m.group(10)))
                front = (m.group(1), m.group(2), m.group(3), m.group(4), m.group(5), m.group(6))
            m = re.search(r'fact words made=(\d+) \(([\d.]+)% .* differences=(\d+) \(over decoys (\d+)\) list-differences=(\d+) failures=(\d+)', t)
            made = m.groups()
            if any(int(x) != 0 for x in made[2:]): bad.append((f, 'differences'))
        lean = [int(m.group(3)) / int(m.group(2)) for f in readings(label, 'types-lean', corpus) for m in [re.search(r'reader-time T expressions=(\d+) records=(\d+) .* ticks=(\d+) setup-ticks=(\d+)', text(f))]]
        if n == 0: continue
        print(f'{corpus} n={n}: expressions {last[0]} records {last[1]} windows {last[2]}; made {made[0]} ({made[1]}%); front gives {front[0]} ({front[1]}%) expressions, {front[2]} ({front[3]}%) records, differences {front[4]}, not whole {front[5]}')
        print('   ticks a record: T alone on the lean front %.1f (n=%d), beside the kernel %.1f | kernel first %.2f later %.2f | T again %.2f | front: as it came %.2f, again %.2f | rows %.2f lines %.2f | append %.1f' % (
            med(lean), len(lean), med(d['T beside']), med(d['kernel first']), med(d['kernel later']), med(d['T again']), med(d.get('front first', [])), med(d.get('front again', [])), med(d['rows']), med(d['lines']), med(d['append'])))
        print('   kernel later + front again = %.2f; against T again %.2f and T alone %.1f' % (med(d['kernel later']) + med(d.get('front again', [0])), med(d['T again']), med(lean)))
        for f in readings(label, 'facts-tests', corpus):
            t = text(f)
            if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
            m = re.search(r'in the expressions the whole machine takes there: records=(\d+) no-literal=(\d+) to-make=(\d+) made=(\d+) \(([\d.]+)%', t)
            if m: print(f'   with the tests and C and X: records {m.group(1)}, no literal {m.group(2)}, made {m.group(4)} ({m.group(5)}%)')
print('BAD:', bad if bad else 'none')
