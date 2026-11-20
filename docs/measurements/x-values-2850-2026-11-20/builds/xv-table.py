#!/usr/bin/env python3
# xv-table.py RESULTS: the values' builds' readings (turns.sh's files, RESULTS/LABEL/TAG-CORPUS-N.txt): for each build
# and corpus the rows' sweeps' ticks a record swept, a chunk's first run and its second, by their parts, the median of
# the readings and their range; the counts; and the piece before's executable's (xb6), whose readings are those taken
# beside the last build's (each job wrote them under one name, so the ones beside the builds before are gone).
import glob, re, statistics, sys
results = sys.argv[1]
ROWS = (r"window rows ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\) the updates and the branches=\d+ \(([\d.]+)\)"
        r" the rows=\d+ \(([\d.]+)\)(?: the values=\d+ \(([\d.]+)\))? an expression's part=\d+ \(([\d.]+)\)")
LATER = (r"window rows a second run over the same chunk, not counted: ticks=\d+ \(([\d.]+) a record swept, ([\d.]+) a record of the taken\): the reads=\d+ \(([\d.]+)\) the shapes=\d+ \(([\d.]+)\)"
         r" the updates and the branches=\d+ \(([\d.]+)\) the rows=\d+ \(([\d.]+)\)(?: the values=\d+ \(([\d.]+)\))? an expression's part=\d+ \(([\d.]+)\)")
COUNTS = r"window rows expressions=(\d+) records=\d+ taken=(\d+) \(([\d.]+)%\) their-records=\d+ \([\d.]+%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+) second-runs-that-differ=(\d+) records-swept=(\d+) entries-written=(\d+)"
VALUES = r"window rows values: tapes that differ in a value alone=(\d+); records on a list=(\d+) \(([\d.]+) a record swept\)(.*?); expressions numbered=(\d+)"
NAMES = ('a record swept', 'a record of the taken', 'the reads', 'the shapes', 'the updates and the branches', 'the rows', 'the values', "an expression's part")
def read(path, pattern):
    m = re.search(pattern, open(path, errors='replace').read())
    return m.groups() if m else None
every = sorted(glob.glob(results + '/*/*-*-*.txt'))
print('runs: %d; without status 0: %d' % (len(every), len([p for p in every if 'status 0' not in open(p, errors='replace').read()])))
labels = sorted(set(p.split('/')[-2] for p in every))
for label in labels:
    for tag in sorted(set(re.sub(r'-(sqlite3|lua|musl)-\d+\.txt$', '', p.split('/')[-1]) for p in every if p.split('/')[-2] == label)):
        for corpus in ('sqlite3', 'lua', 'musl'):
            paths = sorted(glob.glob('%s/%s/%s-%s-*.txt' % (results, label, tag, corpus)))
            if not paths:
                continue
            c = read(paths[0], COUNTS); v = read(paths[0], VALUES)
            same = all(read(p, COUNTS) == c for p in paths)
            print('%-5s %-6s %-7s readings %d: expressions %s taken %s (%s%%) entries %s differences %s unkept %s second-runs-that-differ %s swept %s written %s; values: differ %s listed %s numbered %s; the same in every reading: %s' % (
                label, tag, corpus, len(paths), c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7], c[8], v[0] if v else '-', v[1] if v else '-', v[4] if v else '-', same))
            for pattern, which in ((ROWS, 'first run'), (LATER, 'second run')):
                rows = [read(p, pattern) for p in paths]
                rows = [r for r in rows if r]
                for i, name in enumerate(NAMES):
                    xs = [float(r[i]) for r in rows if r[i] is not None]
                    if xs:
                        print('%-5s %-6s %-7s %-10s %-28s %6.2f (%.2f to %.2f)' % (label, tag, corpus, which, name, statistics.median(xs), min(xs), max(xs)))
