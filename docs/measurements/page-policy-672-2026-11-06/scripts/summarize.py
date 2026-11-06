#!/usr/bin/env python3
# Summarize final.sh's results: per config and worker count, median wall and MB/s; each config's --time-stages peak and
# total; the 8-process decisions.
import collections, glob, os, re, statistics as st, sys
d = sys.argv[1]
SOURCE_MB = 9.507037
walls = collections.defaultdict(list)
for line in open(os.path.join(d, 'workers.txt')):
    p = line.split()
    if p and p[0] == 'round':
        walls[(p[3], int(p[5]))].append(int(p[7]) / 1e6)
configs = []
for (c, w) in walls:
    if c not in configs:
        configs.append(c)
print('| config | ' + ' | '.join('%d at once' % w for w in (1, 2, 4, 8)) + ' |')
print('| --- |' + ' ---: |' * 4)
for c in configs:
    cells = []
    for w in (1, 2, 4, 8):
        v = walls.get((c, w), [])
        if v:
            m = st.median(v)
            cells.append('%.1f ms, %.1f MB/s' % (m, w * SOURCE_MB / (m / 1000)))
        else:
            cells.append('-')
    print('| %s | %s |' % (c, ' | '.join(cells)))
print()
for c in configs:
    peaks = []; totals = []; pages = []
    for f in sorted(glob.glob(os.path.join(d, 'stages-*.txt'))):
        m = re.match(r'stages-(.+)-(\d+)\.txt$', os.path.basename(f))
        if not m or m.group(1) != c:
            continue
        for line in open(f):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'time-process' and p[1] == 'peak-rss-kb': peaks.append(int(p[2]))
            if p[0] == 'time-stage' and p[1] == 'total': totals.append(float(p[2]))
            if p[0] == 'time-process' and p[1] == 'huge-pages': pages.append(p[2])
    decisions = collections.Counter()
    for f in glob.glob(os.path.join(d, 'decide-*.txt')):
        m = re.match(r'decide-(.+)-(\d+)\.txt$', os.path.basename(f))
        if not m or m.group(1) != c:
            continue
        for line in open(f):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'time-process' and p[1] == 'huge-pages': decisions[p[2]] += 1
    print('%-8s alone: peak %s KB, total %s ms, pages %s; 8 at once decided %s' % (c, st.median(peaks) if peaks else '-', '%.1f' % st.median(totals) if totals else '-', ','.join(sorted(set(pages))), dict(decisions)))
