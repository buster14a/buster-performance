#!/usr/bin/env python3
# tables.py RESULTS LABEL...: "the front writes the window" on the 9700X, from the jobs' files: for each label and corpus
# the medians of the readings, TSC ticks a record of the windows: the kernel in place, the names' pass, the front's
# rise and their sum (versions d and later), or the kernel's later run, the append again and the front's rise (versions
# a to c); beside them the piece before's figures of the same build where it ran (the copy of the front's records).
import re, sys, glob, statistics
root = sys.argv[1]
labels = sys.argv[2:]
def readings(label, tag, corpus):
    return sorted(glob.glob(f'{root}/{label}/{tag}-{corpus}-[0-9]*.txt'), key=lambda f: int(re.search(r'-(\d+)\.txt$', f).group(1)))
def text(f): return open(f, errors='replace').read()
def med(v): return statistics.median(v) if v else float('nan')
bad = []
def grab(t, pattern, cast=float):
    m = re.search(pattern, t)
    return [cast(x) for x in m.groups()] if m else None
for label in labels:
    print(f'## {label}')
    for tag in ('window', 'window-warm', 'window-tests'):
        for corpus in ('sqlite3', 'lua', 'musl'):
            files = readings(label, tag, corpus)
            if not files: continue
            d = {}
            last = {}
            for f in files:
                t = text(f)
                if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
                g = grab(t, r'fact words expressions=(\d+) records=(\d+) windows=(\d+)', int)
                records = g[1]; last['batch'] = g
                g = grab(t, r'reader-time T expressions=(\d+) records=(\d+) .* ticks=(\d+) setup-ticks=(\d+)', int)
                d.setdefault('T first', []).append(g[2] / g[1])
                g = grab(t, r'fact words ticks first=(\d+) later=(\d+) again=(\d+) rows=(\d+) lines=(\d+) append=(\d+)', int)
                for k, v in zip(('kernel first', 'kernel later', 'T again', 'rows', 'lines', 'append'), g): d.setdefault(k, []).append(v / records)
                g = grab(t, r"inputs from the front's records: expressions=(\d+) \(([\d.]+)%\) records=(\d+) \(([\d.]+)%\) differences=(\d+) expressions-not-given-whole=(\d+) ticks=(\d+) \(([\d.]+) a record\) \S+=(\d+) \(([\d.]+) a record of (\d+)\)")
                if g:
                    d.setdefault('copy again', []).append(g[9]); last['copy'] = g
                    if g[4] != 0: bad.append((f, 'copy differences'))
                g = grab(t, r'fact words made=(\d+) \(([\d.]+)% .* differences=(\d+) \(over decoys (\d+)\) list-differences=(\d+) failures=(\d+)')
                last['made'] = g
                if any(x != 0 for x in g[2:]): bad.append((f, 'differences'))
                g = grab(t, r'windows the front wrote: expressions=(\d+) \(([\d.]+)%\) records=(\d+) \(([\d.]+)%\) differences=(\d+) expressions-not-there-in-a-row=(\d+)')
                if g:
                    last['window'] = g
                    if g[4] != 0: bad.append((f, 'window differences'))
                    wrecords = g[2]
                    k = grab(t, r'the kernel in place: to-make=(\d+) made=(\d+) left=(\d+) differences=(\d+) ticks=(\d+)', int)
                    last['place'] = k
                    if k[3] != 0: bad.append((f, 'kernel differences in place'))
                    d.setdefault('kernel in place', []).append(k[4] / wrecords)
                    r = grab(t, r'the front with the window: ticks=(\d+) records=(\d+); the same front without it, on the same chunks: ticks=(\d+) records=(\d+) chunks-that-differ=(\d+); the rise=(\d+)', int)
                    if r[4] != 0: bad.append((f, 'chunks differ'))
                    d.setdefault('front', []).append(r[0] / r[1]); d.setdefault('plain', []).append(r[2] / r[3]); d.setdefault('rise', []).append(r[5] / wrecords)
                    n = grab(t, r"the names' pass: names=(\d+) ticks=(\d+), of which the declarations' lines it made=(\d+) \((\d+) lines\); the rest=(\d+) .* leaves-its-scalar-path-gives-otherwise=(\d+)", int)
                    if n[5] != 0: bad.append((f, 'names differ'))
                    d.setdefault('names', []).append(n[4] / wrecords); d.setdefault('name lines', []).append(n[2] / wrecords); last['names'] = n
                    c = grab(t, r"chunks' ends: waiting values kept whole=(\d+) \(their records (\d+)\) kept as their place alone, cut=(\d+)", int)
                    last['ends'] = c
                else:
                    g = grab(t, r"windows the front wrote: expressions=(\d+) \(([\d.]+)%\) records=(\d+) \(([\d.]+)%\) differences=(\d+) expressions-not-given=(\d+) ticks=(\d+) \(([\d.]+) a record\) again-ticks=(\d+) \(([\d.]+) a record of (\d+)\)")
                    if g:
                        last['window'] = g
                        if g[4] != 0: bad.append((f, 'window differences'))
                        d.setdefault('append again', []).append(g[9])
                        r = grab(t, r'the rise=(\d+) \(([\d.]+) ticks a record of the windows\)')
                        d.setdefault('rise', []).append(r[1])
                g = grab(t, r'in the expressions the whole machine takes there: records=(\d+) no-literal=(\d+) to-make=(\d+) made=(\d+) \(([\d.]+)%')
                if g: last['whole'] = g
            n = len(files)
            b = last['batch']; w = last.get('window'); m = last['made']
            print(f'{tag} {corpus} n={n}: expressions {b[0]} records {b[1]}; made {m[0]:.0f} ({m[1]}%); the front\'s window: {w[0]:.0f} ({w[1]}%) expressions, {w[2]:.0f} records, not there {w[5]:.0f}')
            if 'kernel in place' in d:
                s = med(d['kernel in place']) + med(d['names']) + med(d['rise'])
                p = last['place']; nm = last['names']; e = last['ends']
                print('   ticks a record: kernel in place %.2f + names\' pass %.2f + front\'s rise %.2f = %.2f | the batch\'s kernel later %.2f, first %.2f; T first %.1f, again %.2f; the copy again %.2f | lines made in the names\' pass %.2f; rows %.2f' % (
                    med(d['kernel in place']), med(d['names']), med(d['rise']), s, med(d['kernel later']), med(d['kernel first']), med(d['T first']), med(d['T again']), med(d.get('copy again', [])), med(d['name lines']), med(d['rows'])))
                print('   the front: %.2f ticks a record of its own with the window, %.2f without | in place: to make %d, made %d | names %d, lines %d | ends: kept whole %d (%d records), cut %d' % (
                    med(d['front']), med(d['plain']), p[0], p[1], nm[0], nm[3], e[0], e[1], e[2]))
                print('   readings of the sum: ' + ' '.join('%.2f' % (a + b2 + c) for a, b2, c in zip(d['kernel in place'], d['names'], d['rise'])))
            else:
                s = med(d['kernel later']) + med(d['append again']) + med(d['rise'])
                print('   ticks a record: kernel later %.2f + append again %.2f + front\'s rise %.2f = %.2f | T first %.1f, again %.2f; the copy again %.2f' % (
                    med(d['kernel later']), med(d['append again']), med(d['rise']), s, med(d['T first']), med(d['T again']), med(d.get('copy again', []))))
            if 'whole' in last:
                g = last['whole']
                print(f'   with the tests and C and X: records {g[0]:.0f}, no literal {g[1]:.0f}, made {g[3]:.0f} ({g[4]}%)')
    for corpus in ('sqlite3', 'lua', 'musl'):
        files = readings(label, 'facts', corpus)
        if not files: continue
        d = {}
        for f in files:
            t = text(f)
            if not re.search(r'^status 0$', t, re.M): bad.append((f, 'status'))
            records = grab(t, r'fact words expressions=(\d+) records=(\d+) windows=(\d+)', int)[1]
            g = grab(t, r'fact words ticks first=(\d+) later=(\d+) again=(\d+) rows=(\d+) lines=(\d+) append=(\d+)', int)
            for k, v in zip(('kernel first', 'kernel later', 'T again', 'rows', 'lines', 'append'), g): d.setdefault(k, []).append(v / records)
            g = grab(t, r"inputs from the front's records: expressions=(\d+) \(([\d.]+)%\) records=(\d+) \(([\d.]+)%\) differences=(\d+) expressions-not-given-whole=(\d+) ticks=(\d+) \(([\d.]+) a record\) \S+=(\d+) \(([\d.]+) a record of (\d+)\)")
            d.setdefault('copy again', []).append(g[9]); given = g
            g = grab(t, r'front ticks=(\d+)', int); r = grab(t, r'front after-the-walk lean tokens=(\d+) left=(\d+) records=(\d+)', int)
            d.setdefault('front', []).append(g[0] / r[2])
        print('facts %s n=%d: the copy gives %.0f (%s%%) expressions; ticks a record: kernel later %.2f + the copy again %.2f = %.2f; T again %.2f; lines %.2f; the lean front alone %.2f a record of its own' % (
            corpus, len(files), given[0], given[1], med(d['kernel later']), med(d['copy again']), med(d['kernel later']) + med(d['copy again']), med(d['T again']), med(d['lines']), med(d['front'])))
print('BAD:', bad if bad else 'none')
